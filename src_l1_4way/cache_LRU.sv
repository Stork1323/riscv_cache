import cache_def::*;

module cache_LRU(
    input logic clk_i,
    input logic rst_ni,
    input logic valid_i,
    input logic [INDEX_L1-1:0] index_i,
    input logic [INDEX_WAY_L1-1:0] address_i,
    output logic [INDEX_WAY_L1-1:0] address_o
);

    /* Info: this LRU module use for 8 way set-associative cache */

    logic  [INDEX_WAY_L1-1:0] age_bits_b0_w; // age bits for block 0
    logic  [INDEX_WAY_L1-1:0] age_bits_b1_w; // age bits for block 1
    logic  [INDEX_WAY_L1-1:0] age_bits_b2_w; // age bits for block 2
    logic  [INDEX_WAY_L1-1:0] age_bits_b3_w; // age bits for block 3
    

    logic [INDEX_WAY_L1-1:0] age_bits_b0_r [DEPTH_L1];
    logic [INDEX_WAY_L1-1:0] age_bits_b1_r [DEPTH_L1];
    logic [INDEX_WAY_L1-1:0] age_bits_b2_r [DEPTH_L1];
    logic [INDEX_WAY_L1-1:0] age_bits_b3_r [DEPTH_L1];
    

    logic sel_way_b0; // select way bit of block 0 is or of all bits in age_bits_b0
    logic sel_way_b1; // select way bit of block 1 is or of all bits in age_bits_b1
    logic sel_way_b2; // select way bit of block 2 is or of all bits in age_bits_b2
    logic sel_way_b3; // select way bit of block 3 is or of all bits in age_bits_b3

    // initial begin
    //     for (int i = 0; i < DEPTH; i++) begin
    //         age_bits_b0_r[i] <= 3'b000;
    //         age_bits_b1_r[i] <= 3'b001;
    //         age_bits_b2_r[i] <= 3'b010;
    //         age_bits_b3_r[i] <= 3'b011;
    //         age_bits_b4_r[i] <= 3'b100;
    //         age_bits_b5_r[i] <= 3'b101;
    //         age_bits_b6_r[i] <= 3'b110;
    //         age_bits_b7_r[i] <= 3'b111;
    //     end
    // end


    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            for (int i = 0; i < DEPTH_L1; i++) begin
                age_bits_b0_r[i] <= 2'b00;
                age_bits_b1_r[i] <= 2'b01;
                age_bits_b2_r[i] <= 2'b10;
                age_bits_b3_r[i] <= 2'b11;
            end
        end
        else if (valid_i) begin
            age_bits_b0_r[index_i] <= age_bits_b0_w;
            age_bits_b1_r[index_i] <= age_bits_b1_w;
            age_bits_b2_r[index_i] <= age_bits_b2_w;
            age_bits_b3_r[index_i] <= age_bits_b3_w;
        end
    end


    assign sel_way_b0 = age_bits_b0_r[index_i][0] | age_bits_b0_r[index_i][1];
    assign sel_way_b1 = age_bits_b1_r[index_i][0] | age_bits_b1_r[index_i][1];
    assign sel_way_b2 = age_bits_b2_r[index_i][0] | age_bits_b2_r[index_i][1];
    assign sel_way_b3 = age_bits_b3_r[index_i][0] | age_bits_b3_r[index_i][1];

    always_comb begin
        unique case ({sel_way_b3, sel_way_b2, sel_way_b1, sel_way_b0})
            4'b0111: address_o = 2'b11;
            4'b1011: address_o = 2'b10;
            4'b1101: address_o = 2'b01;
            4'b1110: address_o = 2'b00;
            default: address_o = 2'b00;
        endcase
    end


    always_comb begin
        unique case (address_i)
            2'b00: begin
                if (age_bits_b0_r[index_i] == 2'b00) begin
                    age_bits_b0_w = 2'b11;
                    age_bits_b1_w = age_bits_b1_r[index_i] -2'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -2'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -2'b1;
                end
                else begin
                    age_bits_b0_w = 2'b11;
                    if (age_bits_b0_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -2'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -2'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -2'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                end
            end
            2'b01: begin
                if (age_bits_b1_r[index_i] == 2'b00) begin
                    age_bits_b1_w = 2'b11;
                    age_bits_b0_w = age_bits_b0_r[index_i] -2'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -2'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -2'b1;
                end
                else begin
                    age_bits_b1_w = 2'b11;
                    if (age_bits_b1_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -2'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -2'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -2'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                end
            end
            2'b10: begin
                if (age_bits_b2_r[index_i] == 2'b00) begin
                    age_bits_b2_w = 2'b11;
                    age_bits_b1_w = age_bits_b1_r[index_i] -2'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -2'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -2'b1;
                end
                else begin
                    age_bits_b2_w = 2'b11;
                    if (age_bits_b2_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -2'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -2'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -2'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                end
            end
            2'b11: begin
                if (age_bits_b3_r[index_i] == 2'b00) begin
                    age_bits_b3_w = 2'b11;
                    age_bits_b1_w = age_bits_b1_r[index_i] -2'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -2'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -2'b1;
                end
                else begin
                    age_bits_b3_w = 2'b11;
                    if (age_bits_b3_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -2'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -2'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -2'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                end
            end
            default: begin
                age_bits_b0_w = age_bits_b0_r[index_i];
                age_bits_b1_w = age_bits_b1_r[index_i];
                age_bits_b2_w = age_bits_b2_r[index_i];
                age_bits_b3_w = age_bits_b3_r[index_i];
            end
        endcase
    end

endmodule