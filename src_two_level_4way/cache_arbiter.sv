import cache_def::*;

module cache_arbiter(
    input logic clk_i,
    input logic rst_ni,
    input mem_req_type i_cache_request_i,
    input mem_req_type d_cache_request_i,
    input mem_data_type l1_cache_result_i,
    output mem_data_type i_cache_data_o,
    output mem_data_type d_cache_data_o,
    output mem_req_type l1_cache_request_o
);

    typedef enum {IDLE, I_CACHE, D_CACHE} arbiter_state_type;
    arbiter_state_type next_state, state;

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (i_cache_request_i.valid) next_state = I_CACHE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid) next_state = D_CACHE;
            end
            I_CACHE: begin
                if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid)) next_state = IDLE;
                else if ((~i_cache_request_i.valid) & d_cache_request_i.valid) next_state = D_CACHE;
            end
            D_CACHE: begin
                if ((~i_cache_request_i.valid) & (~d_cache_request_i.valid)) next_state = IDLE;
                else if (i_cache_request_i.valid & (~d_cache_request_i.valid)) next_state = I_CACHE;
            end
            default: next_state = IDLE;
        endcase
    end

    always_comb begin
        if (state == I_CACHE) begin
            /* fix address request for L2 */
            l1_cache_request_o.addr  = {i_cache_request_i.addr[31:4], 4'b0}; // fetch data from block 0
            l1_cache_request_o.data  = i_cache_request_i.data;
            l1_cache_request_o.rw    = i_cache_request_i.rw;
            l1_cache_request_o.valid = i_cache_request_i.valid;
            /* -------------------------- */
            i_cache_data_o = l1_cache_result_i;
            d_cache_data_o = '{0, 0};
        end
        else if (state == D_CACHE) begin
            /* fix address request for L2 */
            l1_cache_request_o.addr  = {d_cache_request_i.addr[31:4], 4'b0}; // fetch data from block 0
            l1_cache_request_o.data  = d_cache_request_i.data;
            l1_cache_request_o.rw    = d_cache_request_i.rw;
            l1_cache_request_o.valid = d_cache_request_i.valid;
            /* -------------------------- */
            i_cache_data_o = '{0, 0};
            d_cache_data_o = l1_cache_result_i;
        end
        else begin 
            l1_cache_request_o = '{0, 0, 0, 0};
            i_cache_data_o = '{0, 0};
            d_cache_data_o = '{0, 0};
        end
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