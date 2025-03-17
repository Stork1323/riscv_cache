import cache_def::*;

module cache_arbiter(
    input logic clk_i,
    input logic rst_ni,
    input mem_req_type i_cache_request_i,
    input mem_req_type d_cache_request_i,
    input mem_data_type l1_cache_result_i,
    input evict_data_type ins_evict_data_i, // evicted data from instruction cache
    input evict_data_type data_evict_data_i, // evicted data from data cache
    output evict_data_type inst_swap_o, // swap value for icache and vcache
    output evict_data_type data_swap_o, // swap value for dcache and vcache
    input cpu_req_type cpu_req_icache_i, // CPU request for icache and vcache
    input cpu_req_type cpu_req_dcache_i, // CPU request for dcache and vcache
    output cpu_req_type cpu_request_o, // CPU request for vcache
    input evict_data_type victim_result_i,
    input logic vc_miss_i, // miss signal of victim cache
    output evict_data_type evict_data_o,
    output mem_data_type i_cache_data_o,
    output mem_data_type d_cache_data_o,
    output mem_req_type l1_cache_request_o
);

    typedef enum {IDLE, I_CACHE, D_CACHE, VC_ICACHE, VC_DCACHE} arbiter_state_type;
    // VC_ICACHE: access victim cache with request from instruction cache
    // VC_DCACHE: access victim cache with request from data cache
    arbiter_state_type next_state, state;

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (i_cache_request_i.valid) next_state = I_CACHE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid) next_state = D_CACHE;
                // else if (i_cache_request_i.valid & (~vc_miss_i)) next_state = VC_ICACHE;
                // else if ((~i_cache_request_i.valid) & d_cache_request_i.valid & (~vc_miss_i)) next_state = VC_DCACHE;
            end
            I_CACHE: begin
                if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid)) next_state = IDLE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid) next_state = D_CACHE;
            end
            D_CACHE: begin
                if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid)) next_state = IDLE;
                else if (i_cache_request_i.valid & (~d_cache_request_i.valid)) next_state = I_CACHE;
            end
            // VC_ICACHE: begin
            //     if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid) & vc_miss_i) next_state = IDLE;
            //     else if (i_cache_request_i.valid & (~d_cache_request_i.valid) & vc_miss_i) next_state = I_CACHE;
            // end
            // VC_DCACHE: begin
            //     if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid) & vc_miss_i) next_state = IDLE;
            //     else if ((~i_cache_request_i.valid) & d_cache_request_i.valid & vc_miss_i) next_state = D_CACHE;
            // end
            default: next_state = IDLE;
        endcase
    end

    always_comb begin
        case (state)
            I_CACHE: begin
                /* fix address request for L2 */
                l1_cache_request_o.addr  = {i_cache_request_i.addr[31:4], 4'b0}; // fetch data from block 0
                l1_cache_request_o.data  = i_cache_request_i.data;
                l1_cache_request_o.rw    = i_cache_request_i.rw;
                l1_cache_request_o.valid = i_cache_request_i.valid;
                /* -------------------------- */
                i_cache_data_o = l1_cache_result_i;
                d_cache_data_o = '{0, 0};
                //evict_data_o = '{0, 0, 0, 0};
        end
            D_CACHE: begin
                /* fix address request for L2 */
                l1_cache_request_o.addr  = {d_cache_request_i.addr[31:4], 4'b0}; // fetch data from block 0
                l1_cache_request_o.data  = d_cache_request_i.data;
                l1_cache_request_o.rw    = d_cache_request_i.rw;
                l1_cache_request_o.valid = d_cache_request_i.valid;
                /* -------------------------- */
                i_cache_data_o = '{0, 0};
                d_cache_data_o = l1_cache_result_i;
                //evict_data_o = '{0, 0, 0, 0};
        end
        //     VC_ICACHE: begin
        //         l1_cache_request_o.addr  = i_cache_request_i.addr;
        //         l1_cache_request_o.data  = '0;
        //         l1_cache_request_o.rw    = '0;
        //         l1_cache_request_o.valid = i_cache_request_i.valid;
        //         i_cache_data_o = victim_result_i;
        //         d_cache_data_o = '{0, 0};
        //         //evict_data_o = ins_evict_data_i;
        // end
        //     VC_DCACHE: begin
        //         l1_cache_request_o.addr  = d_cache_request_i.addr;
        //         l1_cache_request_o.data  = '0;
        //         l1_cache_request_o.rw    = '0;
        //         l1_cache_request_o.valid = d_cache_request_i.valid;
        //         i_cache_data_o = '{0, 0};
        //         d_cache_data_o = victim_result_i;
        //         //evict_data_o = data_evict_data_i;
        // end
            default: begin 
                l1_cache_request_o = '{0, 0, 0, 0};
                i_cache_data_o = '{0, 0};
                d_cache_data_o = '{0, 0};
                //evict_data_o = '{0, 0, 0, 0};
        end
        endcase
    end

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        case ({ins_evict_data_i.valid, data_evict_data_i.valid})
            2'b10, 2'b11: evict_data_o = ins_evict_data_i;
            2'b01: evict_data_o = data_evict_data_i;
            default: evict_data_o = '{0, 0, 0, 0};
        endcase
    end

    /* debuging */
    // cpu_req_type cpu_req_r;
    // always_ff @(posedge clk_i, negedge rst_ni) begin
    //     if (!rst_ni) begin
    //         cpu_req_r <= '{0, 0, 0, 0};
    //     end
    //     else begin
    //         cpu_req_r <= cpu_req_icache_i;
    //     end
    // end
    logic debug_r;
    always_ff @(posedge clk_i) begin
        if (cpu_req_dcache_i.valid) begin
            debug_r <= 1'b0;
        end
        else if (cpu_req_icache_i.valid) begin
            debug_r <= 1'b1;
        end
        else begin
            debug_r <= 1'b1;
        end
    end
    logic delay_valid_icache_req; // the signal delay 1 cycle of icache_req_valid
    logic delay_valid_dcache_req; // the signal delay 1 cycle of dcache_req_valid
    always_ff @(posedge clk_i) begin
        delay_valid_icache_req <= cpu_req_icache_i.valid;
        delay_valid_dcache_req <= cpu_req_dcache_i.valid;
    end

    /*----------*/

    always_comb begin
        case ({delay_valid_icache_req, delay_valid_dcache_req})
            2'b10, 2'b11: begin
                inst_swap_o = victim_result_i;
                data_swap_o = '{0, 0, 0, 0};
            end
            2'b01: begin
                inst_swap_o = '{0, 0, 0, 0};
                data_swap_o = victim_result_i;
            end
            default: begin
                inst_swap_o = '{0, 0, 0, 0};
                data_swap_o = '{0, 0, 0, 0};
            end
        endcase
    end

    always_comb begin
        case ({cpu_req_icache_i.valid, cpu_req_dcache_i.valid})
            2'b10, 2'b11: begin 
                cpu_request_o = cpu_req_icache_i;
                // inst_swap_o = victim_result_i;
                // data_swap_o = '{0, 0, 0, 0};
            end
            2'b01: begin
                cpu_request_o = cpu_req_dcache_i;
                // inst_swap_o = '{0, 0, 0, 0};
                // data_swap_o = victim_result_i;
            end
            default: begin
                if (debug_r == 1'b0) cpu_request_o.addr = cpu_req_dcache_i.addr;
                else if (debug_r == 1'b1) cpu_request_o.addr = cpu_req_icache_i.addr;
                else cpu_request_o.addr = '0;
                //cpu_request_o.addr = cpu_req_r.addr; // debuging
                cpu_request_o.valid = '0;
                cpu_request_o.data = '0;
                cpu_request_o.rw = '0;
                // cpu_request_o = '{0, 0, 0, 0};
                // inst_swap_o = '{0, 0, 0, 0};
                // data_swap_o = '{0, 0, 0, 0};
            end
        endcase
    end

endmodule