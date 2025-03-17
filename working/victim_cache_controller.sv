/* cache finite state machine */
import cache_def::*;

module victim_cache_controller(
    input logic clk_i,
    input logic rst_ni,
    input cpu_req_type cpu_req_i,
    //input mem_req_type l1_cache_request_i,
    input vc_cache_tag_type tag_read_i,
    input cache_data_type data_read_i,
    input logic full_i,
    input evict_data_type evict_data_i,
    output logic vc_miss_o,
    output vc_cache_tag_type tag_write_o,
    output vc_cache_req_type tag_req_o,
    output cache_data_type data_write_o,
    output vc_cache_req_type data_req_o,
    //output cpu_result_type cpu_res_o,
    output evict_data_type victim_result_o,
    //output mem_req_type mem_req_o,
    output logic [31:0] no_acc_o,
    output logic [31:0] no_hit_o,
    output logic [31:0] no_miss_o,
    output logic lru_valid_o,
    output logic accessing_o // signal use only for icache stall
);

    typedef enum {
        IDLE,
        COMPARE_TAG,
        UPDATE_VC
    } vc_state_type;

    vc_state_type vstate, rstate;

    /* interface signals to cache tag memory */
    vc_cache_tag_type tag_read; // tag read result
    vc_cache_tag_type tag_write; // tag write data
    vc_cache_req_type tag_req; // tag request
    assign tag_read = tag_read_i;

    /* interface signals to cache data memory */
    cache_data_type data_read; // cache line read data
    cache_data_type data_write; // cache line write data
    vc_cache_req_type data_req; // data request
    assign data_read = data_read_i;

    /* temporary variable for cache controller result */
    evict_data_type v_vc_res;

    /* temporary variable for memory controller request */
    // mem_req_type v_mem_req;

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

    logic v_vc_miss; // victim cache miss signal

    evict_data_type r_evict_data;

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
    assign victim_result_o = v_vc_res;
    //assign mem_req_o = v_mem_req;

    assign vc_miss_o = v_vc_miss;

    /* debug for cpu request valid not trigger when compare between cpu req address and tag read */
    logic delay_cpu_req_valid;
    always_ff @(posedge clk_i) begin
        delay_cpu_req_valid <= cpu_req_i.valid;
    end

    /* Combinational block */
    // always_comb begin
    //     /* default values for all signals */
    //     /* no state change by default */
    //     vstate = rstate;
    //     v_vc_res = '{0, 0, 0, 0};
    //     tag_write = '{0, 0, 0};

    //     /* read current cache line by default */
    //     data_req.we = '0;
    //     /* read tag by default */
    //     tag_req.we = '0;
    //     data_write = evict_data_i.data;

	// 	v_vc_res.data = data_read;
    //     v_vc_res.addr = cpu_req_i.addr;

    //     lru_valid = 1'b0; // default vaule of signal load lru
    //     acc1_w = 1'b0; // default value of access count incr
    //     //hit1_w = 1'b0;
    //     miss1_w = 1'b0;
    //     accessing_o = 1'b0;
	// 	v_vc_miss = 1'b1;

    //     /* ------------------- Cache FSM --------------------- */
    //     case (rstate)
    //         // IDLE: begin
    //         //     // if (l1_cache_request_i.valid) begin
    //         //         // vstate = COMPARE_TAG;
    //         //         // acc1_w = 1'b1;
    //         //     // end
    //         //     // else if (evict_data_i.valid) begin
    //         //         // vstate = UPDATE_VC;
    //         //     // end
    //         //     unique case ({cpu_req_i.valid, evict_data_i.valid})
    //         //         2'b01, 2'b11: begin
    //         //                 vstate = UPDATE_VC;
    //         //                 acc1_w = 1'b0;
    //         //         end
    //         //         2'b10: begin
    //         //                 vstate = COMPARE_TAG;
    //         //                 acc1_w = 1'b1;
    //         //         end
    //         //         default: begin
    //         //                 vstate = IDLE;
    //         //                 acc1_w = 1'b0;
    //         //         end
    //         //     endcase
    //         // end
    //         COMPARE_TAG: begin
    //             /* cache hit (tag match and cache entry is valid) */
    //             if (evict_data_i.valid) begin
    //                 vstate = UPDATE_VC;
    //             end
    //             //else if (cpu_req_i.valid) begin
    //             else if (delay_cpu_req_valid) begin
    //                 if (cpu_req_i.addr[TAGMSB_VC:TAGLSB_VC] == tag_read.tag && tag_read.valid) begin
    //                     v_vc_res.valid = '1;
    //                     v_vc_res.dirty = tag_read.dirty;
    //                     tag_req.we = '1;
    //                     data_req.we = '1;

    //                     tag_write.tag = evict_data_i.addr[TAGMSB_VC:TAGLSB_VC];
    //                     tag_write.valid = '1;

    //                     /*cache line is dirty */
    //                     tag_write.dirty = evict_data_i.dirty;
    //                     //end
    //                     lru_valid = 1'b1;
    //                     vstate = COMPARE_TAG;
    //                     accessing_o = 1'b1;
    //                     v_vc_miss = 1'b0;
    //                 end
    //                 /* cache miss */
    //                 else begin
    //                     accessing_o = 1'b1;
    //                     miss1_w = 1'b1;
    //                     v_vc_miss = 1'b1;
    //                     v_vc_res.valid = '0;
    //                     vstate = COMPARE_TAG;
    //                 end
    //             end
    //             else vstate = COMPARE_TAG;
    //         end
    //         UPDATE_VC: begin
    //             v_vc_res.valid = '0;
    //             tag_req.we = '1;
    //             data_req.we = '1;
    //             //tag_write.tag = evict_data_i.addr[TAGMSB_VC:TAGLSB_VC];
    //             tag_write.tag = r_evict_data.addr[TAGMSB_VC:TAGLSB_VC];
    //             tag_write.valid = '1;
    //             //tag_write.dirty = evict_data_i.dirty;
    //             tag_write.dirty = r_evict_data.dirty;
    //             data_write = r_evict_data.data;
    //             lru_valid = 1'b1;
    //             vstate = COMPARE_TAG;
                
    //         end
    //         default: vstate = COMPARE_TAG;
    //     endcase
    // end

    always_comb begin
        v_vc_res.data = data_read;
        v_vc_res.addr = cpu_req_i.addr;
        if (delay_cpu_req_valid && (cpu_req_i.addr[TAGMSB_VC:TAGLSB_VC] == tag_read.tag) && tag_read.valid) begin
            v_vc_res.valid = '1;
            v_vc_res.dirty = tag_read.dirty;
            v_vc_miss = 1'b0;
        end else begin
            v_vc_res.valid = '0;
            v_vc_res.dirty = '0;
            v_vc_miss = 1'b1;
        end
        if (evict_data_i.valid) begin
            tag_req.we = '1;
            data_req.we = '1;
            tag_write.valid = '1;
            tag_write.tag = evict_data_i.addr[TAGMSB_VC:TAGLSB_VC];
            tag_write.dirty = evict_data_i.dirty;
            data_write = evict_data_i.data;
            lru_valid = 1'b1;
        end else begin
            tag_req.we = '0;
            data_req.we = '0;
            tag_write = '{0, 0, 0};
            data_write = '0;
            lru_valid = '0;
        end
    end


    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni)
            rstate <= COMPARE_TAG;
        else
            rstate <= vstate;
    end 

    assign tag_write_o = tag_write;
    assign tag_req_o = tag_req;
    assign data_write_o = data_write;
    assign data_req_o = data_req;
    assign lru_valid_o = lru_valid;

    /* reg to store evict data */
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) r_evict_data <= '{0, 0, 0, 0};
        else r_evict_data <= evict_data_i;
    end

endmodule
