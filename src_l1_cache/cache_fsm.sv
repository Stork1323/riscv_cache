/* cache finite state machine */
import cache_def::*;

module cache_fsm(
    input logic clk_i,
    input logic rst_ni,
    input cpu_req_type cpu_req_i,
    input mem_data_type mem_data_i,
    input cache_tag_type tag_read_i,
    input cache_data_type data_read_i,
    input logic full_i,
    output cache_tag_type tag_write_o,
    output cache_req_type tag_req_o,
    output cache_data_type data_write_o,
    output cache_req_type data_req_o,
    output cpu_result_type cpu_res_o,
    output mem_req_type mem_req_o,
    output logic [31:0] no_acc_o,
    output logic [31:0] no_hit_o,
    output logic [31:0] no_miss_o,
    output logic lru_valid_o,
    output logic accessing_o // signal use only for icache stall
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
    assign tag_read = tag_read_i;

    /* interface signals to cache data memory */
    cache_data_type data_read; // cache line read data
    cache_data_type data_write; // cache line write data
    cache_req_type data_req; // data request
    assign data_read = data_read_i;

    /* temporary variable for cache controller result */
    cpu_result_type v_cpu_res;

    /* temporary variable for memory controller request */
    mem_req_type v_mem_req;

    /* Request address from pLRU*/
    //logic [INDEX_WAY-1:0] request_address_w;

    logic full_w; // signal notices that set is full or not
    assign full_w = full_i;

    /* signal enable lru load */
    logic lru_valid;


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

    /* debuging */
     /* fix case address request for L2 cache being changed when transfer to Writeback state */
    logic [31:0] address_wb;

    /* Combinational block */
    always_comb begin
        /* default values for all signals */
        /* no state change by default */
        vstate = rstate;
        v_cpu_res = '{0, 0};
        tag_write = '{0, 0, 0};

        /* read current cache line by default */
        data_req.we = '0;
        /* read tag by default */
        tag_req.we = '0;

        /* direct map index for tag */
        tag_req.index = cpu_req_i.addr[INDEX+3:4];

        /* direct map index for cache data */
        data_req.index = cpu_req_i.addr[INDEX+3:4];

        /* modify correct word (32-bit) based on address */
        data_write = data_read;
        
        case (cpu_req_i.addr[3:2])
            2'b00: data_write[31:0] = cpu_req_i.data;
            2'b01: data_write[63:32] = cpu_req_i.data;
            2'b10: data_write[95:64] = cpu_req_i.data;
            2'b11: data_write[127:96] = cpu_req_i.data;
        endcase 
		//data_write = cpu_req_i.data;

        /* read out correct word (32-bit) from cache (to CPU) */
        case (cpu_req_i.addr[3:2])
            2'b00: v_cpu_res.data = data_read[31:0];
            2'b01: v_cpu_res.data = data_read[63:32];
            2'b10: v_cpu_res.data = data_read[95:64];
            2'b11: v_cpu_res.data = data_read[127:96];
        endcase
		//v_cpu_res.data = data_read[31:0];

        /* memory request address (sampled from CPU request) */
        v_mem_req.addr = cpu_req_i.addr;

        /* memory request data (used when write) */
        v_mem_req.data = data_read;
        v_mem_req.rw = '0;
        v_mem_req.valid = '0;

        lru_valid = 1'b0; // default vaule of signal load lru
        acc1_w = 1'b0; // default value of access count incr
        //hit1_w = 1'b0;
        miss1_w = 1'b0;
        accessing_o = 1'b0;

        /* ------------------- Cache FSM --------------------- */
        case (rstate)
            IDLE: begin
                //second_compare = 1'b0;
                //tag_write = '{0, 0, 0};
                /* if there is a CPU reqest, then compare cache tag */
                if (cpu_req_i.valid) begin
                    vstate = COMPARE_TAG;
                    acc1_w = 1'b1;
                end
            end
            COMPARE_TAG: begin
                /* cache hit (tag match and cache entry is valid) */
                if (cpu_req_i.addr[TAGMSB:TAGLSB] == tag_read.tag && tag_read.valid) begin
                    v_cpu_res.ready = '1;

                    /* write hit */
                    if (cpu_req_i.rw) begin
                        /* read/modify cache line */
                        //tag_req.we = '1;
                        data_req.we = '1;

                        /* no change in tag */
                        tag_write.tag = tag_read.tag;
                        tag_write.valid = '1;

                        /*cache line is dirty */
                        tag_write.dirty = '1;
                    end
                    lru_valid = 1'b1;
                    vstate = IDLE;
                    accessing_o = 1'b0;
                end
                /* cache miss */
                else begin
                    accessing_o = 1'b1;
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

                    if (tag_read.valid == 1'b1 && tag_read.dirty == 1'b1) begin
                        /* miss with dirty line */
                        /* write back address */
                        v_mem_req.addr = {tag_read.tag, cpu_req_i.addr[TAGLSB-1:0]};
                        v_mem_req.rw = '1;

                        /* wait till write is completed */
                        vstate = WRITE_BACK;
                    end
                    else begin
                        vstate = ALLOCATE;
                    end

                    // /* compulsory miss or miss with clean block */
                    // if (tag_read.valid == 1'b0 || tag_read.dirty == 1'b0 || full_w == 1'b0)
                    //     /* wait till a new block is allocated */
                    //     vstate = ALLOCATE;
                    // else begin
                    // /* miss with dirty line */
                    //     /* write back address */
                    //     v_mem_req.addr = {tag_read.tag, cpu_req_i.addr[TAGLSB-1:0]};
                    //     v_mem_req.rw = '1;

                    //     /* wait till write is completed */
                    //     vstate = WRITE_BACK;
                    // end
                end
            end
            /* wait for allocating a new cache line */
            ALLOCATE: begin
                accessing_o = 1'b1;

                /* debuging */
                v_mem_req.rw = '0;
                /* -------- */
                    
                if (cpu_req_i.rw == 1'b0) v_mem_req.valid = '1;
                else v_mem_req.valid = 1'b0;

                /* memory controller has responded */
                if (mem_data_i.ready | (cpu_req_i.rw == 1'b1)) begin
                    if (cpu_req_i.rw == 1'b0)
                        data_write = mem_data_i.data;
                    
                    //data_write = mem_data_i.data;
                    /* update cache line data */
                    data_req.we = '1; //************

                    /* re-compare tag for write miss (need modify correct word) */
                    //second_compare = 1'b1;
                    vstate = COMPARE_TAG;
                end
            end
            /* wait for writing back dirty cache line */
            WRITE_BACK: begin
                accessing_o = 1'b1;

                v_mem_req.valid = '1; // fixing
                v_mem_req.rw = '1;

                /* logic for fixing bottom lines code situation */
                v_mem_req.addr = address_wb;
                /* -------- */

                /* write back is completed */
                if (mem_data_i.ready) begin
                    /* issue new memory request (allocating a new line) */
                    v_mem_req.valid = '1;
                    //v_mem_req.rw = '0;

                    vstate = ALLOCATE;
                end
            end
        endcase
    end


    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni)
            rstate <= IDLE;
        else
            rstate <= vstate;
    end 

    assign tag_write_o = tag_write;
    assign tag_req_o = tag_req;
    assign data_write_o = data_write;
    assign data_req_o = data_req;
    assign lru_valid_o = lru_valid;

    /* fix case address request for L2 cache being changed when transfer to Writeback state */
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni)
            address_wb <= 32'b0;
        else if (rstate == COMPARE_TAG) 
            address_wb <= {tag_read.tag, cpu_req_i.addr[TAGLSB-1:0]};
    end
    /* ------------- */

endmodule
