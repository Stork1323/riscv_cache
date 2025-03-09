
// ALU function decode from funct3 and bit 5 of funct7
`define ADD  4'b0000
`define SUB  4'b1000
`define SLL  4'b0001
`define SLT  4'b0010
`define SLTU 4'b0011
`define XOR  4'b0100
`define SRL  4'b0101
`define SRA  4'b1101
`define OR   4'b0110
`define AND  4'b0111
`define B	 4'b1111 // in case of grab only immediate value in LUI instruction

module alu(
	input logic [31:0]  rs1_i,  rs2_i,
	input logic [3:0] AluSel_i, // Alu_op[2:0] = funct3, Alu_op[3] = funct7[5]
	//input logic Mul_ext_i, // multiply extention signal
	output logic [31:0] Result_o
	);
	

	//logic [7:0] cond;
	logic overf1, overf2;
	logic [31:0] sum_r, sub_r, sll_r, slt_r, sltu_r, xor_r, srl_r, sra_r, or_r, and_r;
	//logic [31:0] mul_r;
	//logic [31:0] temp_ans_r[8]; // contain temporary answer
	//logic [31:0] mem_r;
	
	//assign mem_r = Result_o;
	//decode3to8 DE0(AluSel_i[2:0], cond);
	
	// funct3 = 000
	adder_32bit AD0( rs1_i,  rs2_i, sum_r, overf1);
	subtractor_32bit SB0( rs1_i,  rs2_i, sub_r, overf2);
	
	// funct3 = 001
	shift_left_logical SLL0( rs1_i,  rs2_i, sll_r);
	//mux2to1_32bit MU1(temp_ans_r[0], shift_left_r, cond[1], temp_ans_r[1]);
	
	// funct3 = 010
	set_less_than SLT0(rs1_i, rs2_i, slt_r);
	//mux2to1_32bit MU2(temp_ans_r[1], slt_r, cond[2], temp_ans_r[2]);
	
	// funct3 = 011
	set_less_than_unsign SLTU0(rs1_i, rs2_i, sltu_r);
	//mux2to1_32bit MU3(temp_ans_r[2], sltu_r, cond[3], temp_ans_r[3]);
	
	// funct3 = 100
	xor_32bit XOR0(rs1_i, rs2_i, xor_r);
	//mux2to1_32bit MU4(temp_ans_r[3], xor_r, cond[4], temp_ans_r[4]);
	
	// funct3 = 101
	shift_right_logical SRL0(rs1_i, rs2_i, srl_r);
	shift_right_arithmetic SRA0(rs1_i, rs2_i, sra_r);
	//mux3to1_32bit MU5(srl_r, sra_r, temp_ans_r[4], {(~cond[5]), AluSel_i[3]}, temp_ans_r[5]);
	
	// funct3 = 110
	or_32bit OR0(rs1_i, rs2_i, or_r);
	//mux2to1_32bit MU6(temp_ans_r[5], or_r, cond[6], temp_ans_r[6]);
	
	// funct3 = 111
	and_32bit AND0(rs1_i, rs2_i, and_r);
	//mux2to1_32bit MU7(temp_ans_r[6], and_r, cond[7], temp_ans_r[7]);
	
	//vedic_mul_16x16 MUL(.a(rs1_i[15:0]), .b(rs2_i[15:0]), .out(mul_r));
	//assign mul_r = 32'b0;
	
	assign Result_o = /*(Mul_ext_i == 1'b1) ? ((AluSel_i[2:0] == 3'b000) ? mul_r : {32{1'b0}}) : */
							(AluSel_i == `ADD) ? sum_r   : 
							(AluSel_i == `SUB) ? sub_r   : 
							(AluSel_i == `SLL) ? sll_r   : 
							(AluSel_i == `SLT) ? slt_r	  : 
							(AluSel_i == `SLTU) ? sltu_r :
							(AluSel_i == `XOR) ? xor_r   :
							(AluSel_i == `SRL) ? srl_r   :
							(AluSel_i == `SRA) ? sra_r   :
							(AluSel_i == `OR) ? or_r 	  : 
							(AluSel_i == `AND) ? and_r   : 
							(AluSel_i == `B) ? rs2_i	  : {32{1'b0}};
	
	
endmodule

	
	