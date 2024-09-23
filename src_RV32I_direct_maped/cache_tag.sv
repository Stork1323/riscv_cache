/* cache: tag memory, single port, 1024 blocks */
import cache_def::*;

module cache_tag(
    input logic clk_i,
    input cache_req_type tag_req_i,
    input cache_tag_type tag_write_i,
    output cache_tag_type tag_read_o
);

    cache_tag_type tag_mem[0:DEPTH-1];

    initial begin
        for (int i = 0; i < DEPTH; i++)
            tag_mem[i] = '0;
    end

    assign tag_read_o = tag_mem[tag_req_i.index];

    always_ff @(posedge clk_i) begin
        if (tag_req_i.we) 
            tag_mem[tag_req_i.index] <= tag_write_i;
    end

endmodule