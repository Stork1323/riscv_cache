import cache_def::*;

module cache_pLRU(
    input logic clk_i,
    input logic rst_ni,
    input logic valid_i,
    input logic [INDEX-1:0] index_i,
    input logic [INDEX_WAY-1:0] address_i,
    output logic [INDEX_WAY-1:0] address_o
);

    /* pseudo LRU tree 8 ways
                                            L0
                                          /    \
                                        L1      L2
                                       /  \    /  \
                                     L3    L4 L5   L6

                |   | 0
                 ---
            L3  |   | 1
          /      ---
        L1      |   | 2
       /  \      ---
      /     L4  |   | 3
     /           ---
    L0          |   | 4
     \           ---
      \     L5  |   | 5
       \  /      ---
        L2      |   | 6
          \      ---
            L6  |   | 7
                 ---
    Convention: 0->Up, 1->Down

    ex: address = 3'b100 => L0 = 1 -> L2 = 0 -> L5 = 0
    -------------------- */

    logic L0, L1, L2, L3, L4, L5, L6;
    logic L1_w,  L2_w,  L3_w,  L4_w,  L5_w,  L6_w; // signal notices that a node need to change
    logic [INDEX_WAY-1:0] pLRU;

    /*
    always_comb begin
        if (valid_i) L0_w[index_i] = address_i[2];
        //else L0_w[index_i] = L0[index_i];
        if ((valid_i) && (address_i[2] == 1'b0)) L1_w[index_i] = address_i[1];
        //else L1_w[index_i] = L1[index_i];
        if ((valid_i) && (address_i[2] == 1'b1)) L2_w[index_i] = address_i[1];
        //else L2_w[index_i] = L2[index_i];
        if ((valid_i) && (address_i[2] == 1'b0) && (address_i[1] == 1'b0)) L3_w[index_i] = address_i[0];
        //else L3_w[index_i] = L3[index_i];
        if ((valid_i) && (address_i[2] == 1'b0) && (address_i[1] == 1'b1)) L4_w[index_i] = address_i[0];
        //else L4_w[index_i] = L4[index_i];
        if ((valid_i) && (address_i[2] == 1'b1) && (address_i[1] == 1'b0)) L5_w[index_i] = address_i[0];
        //else L5_w[index_i] = L5[index_i];
        if ((valid_i) && (address_i[2] == 1'b1) && (address_i[1] == 1'b1)) L6_w[index_i] = address_i[0];
        //else L6_w[index_i] = L6[index_i];
    end
    */
/*
    assign L0_w[index_i] = (valid_i) ? address_i[2] : L0[index_i];
    assign L1_w[index_i] = (valid_i & (~address_i[2])) ? address_i[1] : L1[index_i];
    assign L2_w[index_i] = (valid_i & address_i[2]) ? address_i[1] : L2[index_i];
    assign L3_w[index_i] = (valid_i & (~address_i[2]) & (~address_i[1])) ? address_i[0] : L3[index_i];
    assign L4_w[index_i] = (valid_i & (~address_i[2]) & address_i[1]) ? address_i[0] : L4[index_i];
    assign L5_w[index_i] = (valid_i & (address_i[2]) & (~address_i[1])) ? address_i[0] : L5[index_i];
    assign L6_w[index_i] = (valid_i & (address_i[2]) & (address_i[1])) ? address_i[0] : L6[index_i];
*/
    // always_ff @(posedge clk_i, negedge rst_ni) begin
    //     if (~rst_ni) begin
    //         L0[DEPTH-1:0] <= {DEPTH{1'b1}};
    //         L1[DEPTH-1:0] <= {DEPTH{1'b1}};
    //         L2[DEPTH-1:0] <= {DEPTH{1'b1}};
    //         L3[DEPTH-1:0] <= {DEPTH{1'b1}};
    //         L4[DEPTH-1:0] <= {DEPTH{1'b1}};
    //         L5[DEPTH-1:0] <= {DEPTH{1'b1}};
    //         L6[DEPTH-1:0] <= {DEPTH{1'b1}};
    //     end
    //     else begin
    //         L0[index_i] <= L0_w[index_i];
    //         L1[index_i] <= L1_w[index_i];
    //         L2[index_i] <= L2_w[index_i];
    //         L3[index_i] <= L3_w[index_i];
    //         L4[index_i] <= L4_w[index_i];
    //         L5[index_i] <= L5_w[index_i];
    //         L6[index_i] <= L6_w[index_i];
    //     end
    // end

    cache_pLRU_node NODE_L0(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(valid_i),
        .index_i(index_i),
        .value_i(address_i[2]),
        .load_left_o(L1_w),
        .load_right_o(L2_w),
        .load_o(L0)
    );

    cache_pLRU_node NODE_L1(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(L1_w),
        .index_i(index_i),
        .value_i(address_i[1]),
        .load_left_o(L3_w),
        .load_right_o(L4_w),
        .load_o(L1)
    );

    cache_pLRU_node NODE_L2(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(L2_w),
        .index_i(index_i),
        .value_i(address_i[1]),
        .load_left_o(L5_w),
        .load_right_o(L6_w),
        .load_o(L2)
    );

    cache_pLRU_node NODE_L3(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(L3_w),
        .index_i(index_i),
        .value_i(address_i[0]),
        .load_left_o(),
        .load_right_o(),
        .load_o(L3)
    );

    cache_pLRU_node NODE_L4(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(L4_w),
        .index_i(index_i),
        .value_i(address_i[0]),
        .load_left_o(),
        .load_right_o(),
        .load_o(L4)
    );

    cache_pLRU_node NODE_L5(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(L5_w),
        .index_i(index_i),
        .value_i(address_i[0]),
        .load_left_o(),
        .load_right_o(),
        .load_o(L5)
    );

    cache_pLRU_node NODE_L6(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(L6_w),
        .index_i(index_i),
        .value_i(address_i[0]),
        .load_left_o(),
        .load_right_o(),
        .load_o(L6)
    );

    
    always_comb begin
        pLRU[2] = (~L0);
        if (~pLRU[2]) pLRU[1] = (~L1);
        else pLRU[1] = (~L2);
        case ({pLRU[2],pLRU[1]})
            2'b00: pLRU[0] = (~L3);
            2'b01: pLRU[0] = (~L4);
            2'b10: pLRU[0] = (~L5);
            2'b11: pLRU[0] = (~L6);
            default: pLRU[0] = 1'b0;
        endcase
    end

    assign address_o = pLRU;

endmodule

module cache_pLRU_node(
    input logic clk_i,
    input logic rst_ni,
    input logic valid_i,
    input logic [INDEX-1:0] index_i,
    input logic value_i,
    output logic load_left_o,
    output logic load_right_o,
    output logic load_o
);

    logic [DEPTH-1:0] L_r;

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            L_r <= {DEPTH{1'b0}};
        end
        else if (valid_i) begin
            L_r[index_i] <= value_i;
        end
    end

    assign load_left_o = (valid_i & (~value_i));
    assign load_right_o = (valid_i & value_i);
    assign load_o = L_r[index_i];

endmodule
