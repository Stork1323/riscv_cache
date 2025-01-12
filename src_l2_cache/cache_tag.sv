/* cache: tag memory, single port, 1024 blocks */
import cache_def::*;

module cache_tag(
    input logic clk_i,
    input cache_req_type tag_req_i,
    input cache_tag_type tag_write_i,
    input logic [INDEX_WAY-1:0] address_way_i,
    input logic [TAGMSB:0] cpu_address_i,
    output logic [INDEX_WAY-1:0] address_way_o,
    output cache_tag_type tag_read_o,
    output logic full_o // signal notices that set is full or not
);

    //logic [NO_TAG_TYPE*WAYS-1:0] tag_mem[0:DEPTH-1];
    cache_tag_type tag_mem[0:DEPTH-1][0:WAYS-1];

    // hit signal of ways
    logic hit[0:WAYS-1];

    // signal from comparation from tags
    logic pre_hit[0:WAYS-1];


    // temporary variable for tag_read_o
    cache_tag_type tag_read_w;

    //
    //logic [INDEX_WAY-1:0] address_temp;
    logic [INDEX_WAY-1:0] way_w;
    logic [INDEX_WAY-1:0] address_way_w;

    initial begin
        for (int i = 0; i < DEPTH; i++)
            for (int j = 0; j < WAYS; j++)
                tag_mem[i][j] = '0;
    end

                
    always_comb begin
        // unique case (tag_write_i.tag)
        //     tag_mem[tag_req_i.index[INDEX-1:0]][0].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00000001;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][1].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00000010;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][2].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00000100;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][3].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00001000;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][4].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00010000;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][5].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00100000;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][6].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b01000000;
        //     tag_mem[tag_req_i.index[INDEX-1:0]][7].tag: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b10000000;
        //     default: {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00000000;
        // endcase
        {pre_hit[7], pre_hit[6], pre_hit[5], pre_hit[4], pre_hit[3], pre_hit[2], pre_hit[1], pre_hit[0]} = 8'b00000000;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][0].tag) pre_hit[0] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][1].tag) pre_hit[1] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][2].tag) pre_hit[2] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][3].tag) pre_hit[3] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][4].tag) pre_hit[4] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][5].tag) pre_hit[5] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][6].tag) pre_hit[6] = 1'b1;
        if (cpu_address_i[TAGMSB:TAGLSB] == tag_mem[tag_req_i.index[INDEX-1:0]][7].tag) pre_hit[7] = 1'b1;

        hit[0] = (tag_mem[tag_req_i.index[INDEX-1:0]][0].valid) & pre_hit[0];
        hit[1] = (tag_mem[tag_req_i.index[INDEX-1:0]][1].valid) & pre_hit[1];
        hit[2] = (tag_mem[tag_req_i.index[INDEX-1:0]][2].valid) & pre_hit[2];
        hit[3] = (tag_mem[tag_req_i.index[INDEX-1:0]][3].valid) & pre_hit[3];
        hit[4] = (tag_mem[tag_req_i.index[INDEX-1:0]][4].valid) & pre_hit[4];
        hit[5] = (tag_mem[tag_req_i.index[INDEX-1:0]][5].valid) & pre_hit[5];
        hit[6] = (tag_mem[tag_req_i.index[INDEX-1:0]][6].valid) & pre_hit[6];
        hit[7] = (tag_mem[tag_req_i.index[INDEX-1:0]][7].valid) & pre_hit[7];

        priority case ({hit[7], hit[6], hit[5], hit[4], hit[3], hit[2], hit[1], hit[0]})
            8'b10000000: begin address_way_w = 3'b111; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][7]; end
            8'b01000000: begin address_way_w = 3'b110; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][6]; end
            8'b00100000: begin address_way_w = 3'b101; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][5]; end
            8'b00010000: begin address_way_w = 3'b100; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][4]; end
            8'b00001000: begin address_way_w = 3'b011; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][3]; end
            8'b00000100: begin address_way_w = 3'b010; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][2]; end
            8'b00000010: begin address_way_w = 3'b001; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][1]; end
            8'b00000001: begin address_way_w = 3'b000; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][0]; end
            default: begin address_way_w = address_way_i; tag_read_w = tag_mem[tag_req_i.index[INDEX-1:0]][address_way_i]; end
        endcase
    end

    //assign tag_read_o = (full_w) ? tag_mem[tag_req_i.index[INDEX-1:0]][address_way_i] : tag_read_w;
    assign tag_read_o = tag_read_w;

    assign full_o = tag_mem[tag_req_i.index[INDEX-1:0]][0].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][1].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][2].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][3].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][4].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][5].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][6].valid &
                    tag_mem[tag_req_i.index[INDEX-1:0]][7].valid;

    // always_comb begin
        // if (~tag_mem[tag_req_i.index[INDEX-1:0]][0].valid) address_temp = 3'b000;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][1].valid) address_temp = 3'b001;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][2].valid) address_temp = 3'b010;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][3].valid) address_temp = 3'b011;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][4].valid) address_temp = 3'b100;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][5].valid) address_temp = 3'b101;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][6].valid) address_temp = 3'b110;
        // else if (~tag_mem[tag_req_i.index[INDEX-1:0]][7].valid) address_temp = 3'b111;
        // else address_temp = 3'b000;
    // end

    // logic [INDEX_WAY-1:0] address_r;
    // always_ff @(posedge clk_i) begin
    //     address_r <= address_temp;
    // end

    //assign way_w = (full_w) ? address_way_i : address_temp;
    assign way_w = (hit[7] | hit[6] | hit[5] | hit[4] | hit[3] | hit[2] | hit[1] | hit[0]) ? address_way_w : address_way_i;

    assign address_way_o = (tag_req_i.we) ? way_w : address_way_w;

    always_ff @(posedge clk_i) begin
        if (tag_req_i.we) begin
            tag_mem[tag_req_i.index[INDEX-1:0]][way_w] <= tag_write_i;
        end
    end

endmodule