/* cache: data memory, single port, 1024 blocks */
import cache_def::*;
module cache_data(
    input logic clk_i,
    input cache_req_type data_req_i, 
    input cache_data_type data_write_i,
    output cache_data_type data_read_o
);

    cache_data_type data_mem[0:DEPTH-1];

    initial begin
        for (int i = 0; i < DEPTH; i++)
            data_mem[0] = '0;
    end

    assign data_read_o = data_mem[data_req_i.index];

    always_ff @(posedge clk_i) begin
        if (data_req_i.we)
            data_mem[data_req_i.index] <= data_write_i;
    end

endmodule
