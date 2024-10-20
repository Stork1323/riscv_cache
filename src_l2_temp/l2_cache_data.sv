/* cache: data memory, single port, 1024 blocks */
import cache_def::*;
module l2_cache_data(
    input logic clk_i,
    input l2_cache_req_type data_req_i,
    input cache_data_type data_write_i,
    input logic [INDEX_WAY-1:0] address_way_tag2data_i,
    output cache_data_type data_read_o
);

    //logic [WAYS*DATA_WIDTH-1:0] data_mem[0:DEPTH-1];
    cache_data_type data_mem[0:DEPTH_L2-1][0:WAYS-1];

    initial begin
        for (int i = 0; i < DEPTH_L2; i++)
            for (int j = 0; j < WAYS; j++)
                data_mem[i][j] = '0;
    end

    assign data_read_o = data_mem[data_req_i.index[INDEX_L2-1:0]][address_way_tag2data_i];

    
    always_ff @(posedge clk_i) begin
        if (data_req_i.we) begin
            data_mem[data_req_i.index[INDEX_L2-1:0]][address_way_tag2data_i] <= data_write_i;
        end
    end

endmodule
