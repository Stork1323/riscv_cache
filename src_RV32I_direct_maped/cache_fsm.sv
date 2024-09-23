/* cache finite state machine */
import cache_def::*;

module cache_fsm(
    input logic clk_i,
    input logic rst_ni,
    input cpu_req_type cpu_req_i,
    input mem_data_type mem_data_i,
    output cpu_result_type cpu_res_o,
    output mem_req_type mem_req_o,
    output logic [31:0] no_acc_o,
    output logic [31:0] no_miss_o,
    output logic [31:0] no_hit_o
    //output logic stall_by_cache_o
);

    typedef enum {
        IDLE,
        COMPARE_TAG,
        ALLOCATE,
        WRITE_BACK
    } cache_state_type;

    cache_state_type vstate, rstate;

    /* interface signals to cache tag memory */
    cache_tag_type tag_read; // tag read result
    cache_tag_type tag_write; // tag write data
    cache_req_type tag_req; // tag request

    /* interface signals to cache data memory */
    cache_data_type data_read; // cache line read data
    cache_data_type data_write; // cache line write data
    cache_req_type data_req; // data request

    /* temporary variable for cache controller result */
    cpu_result_type v_cpu_res;

    /* temporary variable for memory controller request */
    mem_req_type v_mem_req;

     /* var of counter */
    logic [31:0] no_acc_old_w;
    //logic [31:0] no_hit_old_w;
    logic [31:0] no_miss_old_w;

    logic [31:0] no_acc_new_w;
    logic [31:0] no_hit_new_w;
    logic [31:0] no_miss_new_w;

    logic [31:0] no_acc_r;
    logic [31:0] no_hit_r;
    logic [31:0] no_miss_r;

    logic acc1_w; // if access (load or store) acc1_w = 1 otherwise 0
    //logic hit1_w; // if cache hit hit1_w = 1 otherwise 0
    logic miss1_w; // if cache miss miss1_w = 1 otherwise 0

    /* -------------------*/

    /* count for additional variables */
    adder_32bit A_access (
            .a_i(no_acc_old_w),
            .b_i({31'b0, acc1_w}),
            .c_o(),
            .re_o(no_acc_new_w)
    );
    subtractor_32bit S_hit (
            .a_i(no_acc_o),
            .b_i(no_miss_o),
            .b_o(),
            .d_o(no_hit_o)
    );
    adder_32bit A_miss (
            .a_i(no_miss_old_w),
            .b_i({31'b0, miss1_w}),
            .c_o(),
            .re_o(no_miss_new_w)
    );
    always_ff @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni) begin
                    no_acc_r <= 32'b0;
                    //no_hit_r <= 32'b0;
                    no_miss_r <= 32'b0;
            end
            else begin
                    no_acc_r <= no_acc_new_w;
                    //no_hit_r <= no_hit_new_w;
                    no_miss_r <= no_miss_new_w;
            end
    end

    assign no_acc_old_w = no_acc_r; // update old value
    //assign no_hit_old_w = no_hit_r;
    assign no_miss_old_w = no_miss_r;

    assign no_acc_o = no_acc_r; // update output
    //assign no_hit_o = no_hit_r;
    assign no_miss_o = no_miss_r;

    /* --------------- */

    /* connect to output ports */
    assign cpu_res_o = v_cpu_res;
    assign mem_req_o = v_mem_req;

    /* connect cache tag/data memory */
    cache_tag ctag(
        .clk_i(clk_i),
        .tag_req_i(tag_req),
        .tag_write_i(tag_write),
        .tag_read_o(tag_read)
    );

    cache_data cdata(
        .clk_i(clk_i),
        .data_req_i(data_req), 
        .data_write_i(data_write),
        .data_read_o(data_read)
    );

    /* Combinational block */
    always_comb begin
        /* default values for all signals */
        /* no state change by default */
        vstate = rstate;
        v_cpu_res = '{0, 0};
        tag_write = '{0, 0, 0};

        /* read tag by default */
        tag_req.we = '0;

        /* direct map index for tag */
        tag_req.index = cpu_req_i.addr[INDEX+1:2];

        /* read current cache line by default */
        data_req.we = '0;

        /* direct map index for cache data */
        data_req.index = cpu_req_i.addr[INDEX+1:2];

        /* modify correct word (32-bit) based on address */
        data_write = data_read;
        
        /* case (cpu_req_i.addr[3:2])
            2'b00: data_write[31:0] = cpu_req_i.data;
            2'b01: data_write[63:32] = cpu_req_i.data;
            2'b10: data_write[95:64] = cpu_req_i.data;
            2'b11: data_write[127:96] = cpu_req_i.data;
        endcase */
		data_write[31:0] = cpu_req_i.data;

        /* read out correct word (32-bit) from cache (to CPU) */
        /*case (cpu_req_i.addr[3:2])
            2'b00: v_cpu_res.data = data_read[31:0];
            2'b01: v_cpu_res.data = data_read[63:32];
            2'b10: v_cpu_res.data = data_read[95:64];
            2'b11: v_cpu_res.data = data_read[127:96];
        endcase */
		v_cpu_res.data = data_read[31:0];

        /* memory request address (sampled from CPU request) */
        v_mem_req.addr = cpu_req_i.addr;

        /* memory request data (used when write) */
        v_mem_req.data = data_read;
        v_mem_req.rw = '0;

        acc1_w = 1'b0;
        miss1_w = 1'b0;
        //stall_by_cache_o = 1'b0;

        /* ------------------- Cache FSM --------------------- */
        case (rstate)
            IDLE: begin
                /* if there is a CPU reqest, then compare cache tag */
                if (cpu_req_i.valid) begin
                    vstate = COMPARE_TAG;
                    acc1_w = 1'b1;
                    //stall_by_cache_o = 1'b1;
                end
            end
            COMPARE_TAG: begin
                /* cache hit (tag match and cache entry is valid) */
                if (cpu_req_i.addr[TAGMSB:TAGLSB] == tag_read.tag && tag_read.valid) begin
                    v_cpu_res.ready = '1;

                    /* write hit */
                    if (cpu_req_i.rw) begin
                        /* read/modify cache line */
                        tag_req.we = '1;
                        data_req.we = '1;

                        /* no change in tag */
                        tag_write.tag = tag_read.tag;
                        tag_write.valid = '1;

                        /*cache line is dirty */
                        tag_write.dirty = '1;
                    end
                    //stall_by_cache_o = 1'b0;
                    vstate = IDLE;
                end
                /* cache miss */
                else begin
                    miss1_w = 1'b1;
                    /* generate new tag */
                    tag_req.we = '1;
                    tag_write.valid = '1;

                    /* new tag */
                    tag_write.tag = cpu_req_i.addr[TAGMSB:TAGLSB];

                    /* cache line is dirty if write */
                    tag_write.dirty = cpu_req_i.rw;

                    /* generate memory request on miss */
                    v_mem_req.valid = '1;

                    /* compulsory miss or miss with clean block */
                    if (tag_read.valid == 1'b0 || tag_read.dirty == 1'b0)
                        /* wait till a new block is allocated */
                        vstate = ALLOCATE;
                    else begin
                    /* miss with dirty line */
                        /* write back address */
                        v_mem_req.addr = {tag_read.tag, cpu_req_i.addr[TAGLSB-1:0]};
                        v_mem_req.rw = '1;

                        /* wait till write is completed */
                        vstate = WRITE_BACK;
                    end
                end
            end
            /* wait for allocating a new cache line */
            ALLOCATE: begin
                /* memory controller has responded */
                if (mem_data_i.ready) begin
                    /* re-compare tag for write miss (need modify correct word) */
                    vstate = COMPARE_TAG;
                    data_write = mem_data_i.data;

                    /* update cache line data */
                    data_req.we = '1;
                end
            end
            /* wait for writing back dirty cache line */
            WRITE_BACK: begin
                /* write back is completed */
                if (mem_data_i.ready) begin
                    /* issue new memory request (allocating a new line) */
                    v_mem_req.valid = '1;
                    v_mem_req.rw = '0;

                    vstate = ALLOCATE;
                end
            end
        endcase
    end

    always_ff @(posedge clk_i) begin
        if (!rst_ni)
            rstate <= IDLE;
        else
            rstate <= vstate;
    end 

endmodule

// Currently, because memory of DE2 is not big enough, so i reduce from 16KiB to 2KiB