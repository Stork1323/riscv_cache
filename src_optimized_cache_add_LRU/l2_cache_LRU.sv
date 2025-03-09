import cache_def::*;

module l2_cache_LRU(
    input logic clk_i,
    input logic rst_ni,
    input logic valid_i,
    input logic [INDEX_L2-1:0] index_i,
    input logic [INDEX_WAY-1:0] address_i,
    output logic [INDEX_WAY-1:0] address_o
);

    /* Info: this LRU module use for 8 way set-associative cache */

    logic  [INDEX_WAY-1:0] age_bits_b0_w; // age bits for block 0
    logic  [INDEX_WAY-1:0] age_bits_b1_w; // age bits for block 1
    logic  [INDEX_WAY-1:0] age_bits_b2_w; // age bits for block 2
    logic  [INDEX_WAY-1:0] age_bits_b3_w; // age bits for block 3
    logic  [INDEX_WAY-1:0] age_bits_b4_w; // age bits for block 4
    logic  [INDEX_WAY-1:0] age_bits_b5_w; // age bits for block 5
    logic  [INDEX_WAY-1:0] age_bits_b6_w; // age bits for block 6
    logic  [INDEX_WAY-1:0] age_bits_b7_w; // age bits for block 7
    

    logic [INDEX_WAY-1:0] age_bits_b0_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b1_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b2_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b3_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b4_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b5_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b6_r [DEPTH_L2];
    logic [INDEX_WAY-1:0] age_bits_b7_r [DEPTH_L2];
    

    logic sel_way_b0; // select way bit of block 0 is or of all bits in age_bits_b0
    logic sel_way_b1; // select way bit of block 1 is or of all bits in age_bits_b1
    logic sel_way_b2; // select way bit of block 2 is or of all bits in age_bits_b2
    logic sel_way_b3; // select way bit of block 3 is or of all bits in age_bits_b3
    logic sel_way_b4; // select way bit of block 4 is or of all bits in age_bits_b4
    logic sel_way_b5; // select way bit of block 5 is or of all bits in age_bits_b5
    logic sel_way_b6; // select way bit of block 6 is or of all bits in age_bits_b6
    logic sel_way_b7; // select way bit of block 7 is or of all bits in age_bits_b7

    // initial begin
    //     for (int i = 0; i < DEPTH_L2; i++) begin
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
            for (int i = 0; i < DEPTH_L2; i++) begin
                age_bits_b0_r[i] <= 3'b000;
                age_bits_b1_r[i] <= 3'b001;
                age_bits_b2_r[i] <= 3'b010;
                age_bits_b3_r[i] <= 3'b011;
                age_bits_b4_r[i] <= 3'b100;
                age_bits_b5_r[i] <= 3'b101;
                age_bits_b6_r[i] <= 3'b110;
                age_bits_b7_r[i] <= 3'b111;
            end
        end
        else if (valid_i) begin
            age_bits_b0_r[index_i] <= age_bits_b0_w;
            age_bits_b1_r[index_i] <= age_bits_b1_w;
            age_bits_b2_r[index_i] <= age_bits_b2_w;
            age_bits_b3_r[index_i] <= age_bits_b3_w;
            age_bits_b4_r[index_i] <= age_bits_b4_w;
            age_bits_b5_r[index_i] <= age_bits_b5_w;
            age_bits_b6_r[index_i] <= age_bits_b6_w;
            age_bits_b7_r[index_i] <= age_bits_b7_w;
        end
    end


    assign sel_way_b0 = age_bits_b0_r[index_i][0] | age_bits_b0_r[index_i][1] | age_bits_b0_r[index_i][2];
    assign sel_way_b1 = age_bits_b1_r[index_i][0] | age_bits_b1_r[index_i][1] | age_bits_b1_r[index_i][2];
    assign sel_way_b2 = age_bits_b2_r[index_i][0] | age_bits_b2_r[index_i][1] | age_bits_b2_r[index_i][2];
    assign sel_way_b3 = age_bits_b3_r[index_i][0] | age_bits_b3_r[index_i][1] | age_bits_b3_r[index_i][2];
    assign sel_way_b4 = age_bits_b4_r[index_i][0] | age_bits_b4_r[index_i][1] | age_bits_b4_r[index_i][2];
    assign sel_way_b5 = age_bits_b5_r[index_i][0] | age_bits_b5_r[index_i][1] | age_bits_b5_r[index_i][2];
    assign sel_way_b6 = age_bits_b6_r[index_i][0] | age_bits_b6_r[index_i][1] | age_bits_b6_r[index_i][2];
    assign sel_way_b7 = age_bits_b7_r[index_i][0] | age_bits_b7_r[index_i][1] | age_bits_b7_r[index_i][2];

    always_comb begin
        unique case ({sel_way_b7, sel_way_b6, sel_way_b5, sel_way_b4, sel_way_b3, sel_way_b2, sel_way_b1, sel_way_b0})
            8'b0111_1111: address_o = 3'b111;
            8'b1011_1111: address_o = 3'b110;
            8'b1101_1111: address_o = 3'b101;
            8'b1110_1111: address_o = 3'b100;
            8'b1111_0111: address_o = 3'b011;
            8'b1111_1011: address_o = 3'b010;
            8'b1111_1101: address_o = 3'b001;
            8'b0111_1110: address_o = 3'b000;
            default: address_o = 3'b000;
        endcase
    end


    always_comb begin
        unique case (address_i)
            3'b000: begin
                if (age_bits_b0_r[index_i] == 3'b000) begin
                    age_bits_b0_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b0_w = 3'b111;
                    if (age_bits_b0_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b0_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b001: begin
                if (age_bits_b1_r[index_i] == 3'b000) begin
                    age_bits_b1_w = 3'b111;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b1_w = 3'b111;
                    if (age_bits_b1_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b1_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b010: begin
                if (age_bits_b2_r[index_i] == 3'b000) begin
                    age_bits_b2_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b2_w = 3'b111;
                    if (age_bits_b2_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b2_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b011: begin
                if (age_bits_b3_r[index_i] == 3'b000) begin
                    age_bits_b3_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b3_w = 3'b111;
                    if (age_bits_b3_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b3_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b100: begin
                if (age_bits_b4_r[index_i] == 3'b000) begin
                    age_bits_b4_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b4_w = 3'b111;
                    if (age_bits_b4_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b4_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b4_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b4_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b4_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b4_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b4_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b101: begin
                if (age_bits_b5_r[index_i] == 3'b000) begin
                    age_bits_b5_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b5_w = 3'b111;
                    if (age_bits_b5_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b5_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b5_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b5_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b5_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b5_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b5_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b110: begin
                if (age_bits_b6_r[index_i] == 3'b000) begin
                    age_bits_b6_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b6_w = 3'b111;
                    if (age_bits_b6_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b6_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b6_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b6_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b6_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b6_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                    if (age_bits_b6_r[index_i] < age_bits_b7_r[index_i]) age_bits_b7_w = age_bits_b7_r[index_i] -3'b1;
                    else age_bits_b7_w = age_bits_b7_r[index_i];
                end
            end
            3'b111: begin
                if (age_bits_b7_r[index_i] == 3'b000) begin
                    age_bits_b7_w = 3'b111;
                    age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                end
                else begin
                    age_bits_b7_w = 3'b111;
                    if (age_bits_b7_r[index_i] < age_bits_b1_r[index_i]) age_bits_b1_w = age_bits_b1_r[index_i] -3'b1;
                    else age_bits_b1_w = age_bits_b1_r[index_i];
                    if (age_bits_b7_r[index_i] < age_bits_b0_r[index_i]) age_bits_b0_w = age_bits_b0_r[index_i] -3'b1;
                    else age_bits_b0_w = age_bits_b0_r[index_i];
                    if (age_bits_b7_r[index_i] < age_bits_b3_r[index_i]) age_bits_b3_w = age_bits_b3_r[index_i] -3'b1;
                    else age_bits_b3_w = age_bits_b3_r[index_i];
                    if (age_bits_b7_r[index_i] < age_bits_b4_r[index_i]) age_bits_b4_w = age_bits_b4_r[index_i] -3'b1;
                    else age_bits_b4_w = age_bits_b4_r[index_i];
                    if (age_bits_b7_r[index_i] < age_bits_b5_r[index_i]) age_bits_b5_w = age_bits_b5_r[index_i] -3'b1;
                    else age_bits_b5_w = age_bits_b5_r[index_i];
                    if (age_bits_b7_r[index_i] < age_bits_b6_r[index_i]) age_bits_b6_w = age_bits_b6_r[index_i] -3'b1;
                    else age_bits_b6_w = age_bits_b6_r[index_i];
                    if (age_bits_b7_r[index_i] < age_bits_b2_r[index_i]) age_bits_b2_w = age_bits_b2_r[index_i] -3'b1;
                    else age_bits_b2_w = age_bits_b2_r[index_i];
                end
            end
            default: begin
                age_bits_b0_w = age_bits_b0_r[index_i];
                age_bits_b1_w = age_bits_b1_r[index_i];
                age_bits_b2_w = age_bits_b2_r[index_i];
                age_bits_b3_w = age_bits_b3_r[index_i];
                age_bits_b4_w = age_bits_b4_r[index_i];
                age_bits_b5_w = age_bits_b5_r[index_i];
                age_bits_b6_w = age_bits_b6_r[index_i];
                age_bits_b7_w = age_bits_b7_r[index_i];
            end
        endcase
    end

endmodule