/* cache: data memory, single port, 1024 blocks */
import cache_def::*;
module cache_data(
    input logic clk_i,
    input cache_req_type data_req_i,
    input cache_data_type data_write_i,
    input logic [INDEX_WAY_L1-1:0] address_way_tag2data_i,
    output cache_data_type data_read_o
);

    //logic [WAYS*DATA_WIDTH-1:0] data_mem[0:DEPTH-1];
    (* ram_style = "block" *)
    cache_data_type data_mem[0:DEPTH_L1-1][0:WAYS_L1-1];

    initial begin
        for (int i = 0; i < DEPTH_L1; i++)
            for (int j = 0; j < WAYS_L1; j++)
                data_mem[i][j] = '0;
    end

    //assign data_read_o = data_mem[data_req_i.index[INDEX_L1-1:0]][address_way_tag2data_i];
    always_ff @(posedge clk_i) begin
        data_read_o <= data_mem[data_req_i.index[INDEX_L1-1:0]][address_way_tag2data_i];
    end
    
    always_ff @(posedge clk_i) begin
        if (data_req_i.we) begin
            data_mem[data_req_i.index[INDEX_L1-1:0]][address_way_tag2data_i] <= data_write_i;
        end
    end

endmodule
