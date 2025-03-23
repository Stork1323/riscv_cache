
import cache_def::*;

module d_victim_cache_data(
    input logic clk_i,
    input vc_cache_req_type data_req_i,
    input cache_data_type data_write_i,
    input logic [INDEX_WAY_VC-1:0] address_way_tag2data_i,
    output cache_data_type data_read_o
);

    //logic [WAYS*DATA_WIDTH-1:0] data_mem[0:DEPTH-1];
    cache_data_type data_mem[0:WAYS_VC-1];

    initial begin
        for (int j = 0; j < WAYS_VC; j++)
            data_mem[j] = '0;
    end

    assign data_read_o = data_mem[address_way_tag2data_i];

    
    always_ff @(posedge clk_i) begin
        if (data_req_i.we) begin
            data_mem[address_way_tag2data_i] <= data_write_i;
        end
    end

endmodule
