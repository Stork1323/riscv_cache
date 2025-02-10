import cache_def::*;

module cache_arbiter(
    input logic clk_i,
    input logic rst_ni,
    input mem_req_type i_cache_request_i,
    input mem_req_type d_cache_request_i,
    input mem_data_type l1_cache_result_i,
    input evict_data_type ins_evict_data_i, // evicted data from instruction cache
    input evict_data_type data_evict_data_i, // evicted data from data cache
    input mem_data_type victim_result_i,
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
                if (i_cache_request_i.valid & vc_miss_i) next_state = I_CACHE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid & vc_miss_i) next_state = D_CACHE;
                else if (i_cache_request_i.valid & (~vc_miss_i)) next_state = VC_ICACHE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid & (~vc_miss_i)) next_state = VC_DCACHE;
            end
            I_CACHE: begin
                if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid) & vc_miss_i) next_state = IDLE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid & vc_miss_i) next_state = D_CACHE;
            end
            D_CACHE: begin
                if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid) & vc_miss_i) next_state = IDLE;
                else if (i_cache_request_i.valid & (~d_cache_request_i.valid) & vc_miss_i) next_state = I_CACHE;
            end
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
        end
            VC_ICACHE: begin
                l1_cache_request_o.addr  = i_cache_request_i.addr;
                l1_cache_request_o.data  = '0;
                l1_cache_request_o.rw    = '0;
                l1_cache_request_o.valid = i_cache_request_i.valid;
                i_cache_data_o = victim_result_i;
                d_cache_data_o = '{0, 0};
        end
            VC_DCACHE: begin
                l1_cache_request_o.addr  = d_cache_request_i.addr;
                l1_cache_request_o.data  = '0;
                l1_cache_request_o.rw    = '0;
                l1_cache_request_o.valid = d_cache_request_i.valid;
                i_cache_data_o = '{0, 0};
                d_cache_data_o = victim_result_i;
        end
            default: begin 
                l1_cache_request_o = '{0, 0, 0, 0};
                i_cache_data_o = '{0, 0};
                d_cache_data_o = '{0, 0};
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

endmodule