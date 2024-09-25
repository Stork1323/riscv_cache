module mux2to1_32bit(
	input logic [31:0] a_i, b_i,
	input logic se_i, // select se_i=0->c_o=a_i, se_i=1->c_o=b_i
	output logic [31:0] c_o
	);
	
	logic se_n;
	assign se_n = ~se_i;
	assign c_o[0] = (a_i[0] & se_n) | (b_i[0] & se_i);
	assign c_o[1] = (a_i[1] & se_n) | (b_i[1] & se_i);
	assign c_o[2] = (a_i[2] & se_n) | (b_i[2] & se_i);
	assign c_o[3] = (a_i[3] & se_n) | (b_i[3] & se_i);
	assign c_o[4] = (a_i[4] & se_n) | (b_i[4] & se_i);
	assign c_o[5] = (a_i[5] & se_n) | (b_i[5] & se_i);
	assign c_o[6] = (a_i[6] & se_n) | (b_i[6] & se_i);
	assign c_o[7] = (a_i[7] & se_n) | (b_i[7] & se_i);
	assign c_o[8] = (a_i[8] & se_n) | (b_i[8] & se_i);
	assign c_o[9] = (a_i[9] & se_n) | (b_i[9] & se_i);
	assign c_o[10] = (a_i[10] & se_n) | (b_i[10] & se_i);
	assign c_o[11] = (a_i[11] & se_n) | (b_i[11] & se_i);
	assign c_o[12] = (a_i[12] & se_n) | (b_i[12] & se_i);
	assign c_o[13] = (a_i[13] & se_n) | (b_i[13] & se_i);
	assign c_o[14] = (a_i[14] & se_n) | (b_i[14] & se_i);
	assign c_o[15] = (a_i[15] & se_n) | (b_i[15] & se_i);
	assign c_o[16] = (a_i[16] & se_n) | (b_i[16] & se_i);
	assign c_o[17] = (a_i[17] & se_n) | (b_i[17] & se_i);
	assign c_o[18] = (a_i[18] & se_n) | (b_i[18] & se_i);
	assign c_o[19] = (a_i[19] & se_n) | (b_i[19] & se_i);
	assign c_o[20] = (a_i[20] & se_n) | (b_i[20] & se_i);
	assign c_o[21] = (a_i[21] & se_n) | (b_i[21] & se_i);
	assign c_o[22] = (a_i[22] & se_n) | (b_i[22] & se_i);
	assign c_o[23] = (a_i[23] & se_n) | (b_i[23] & se_i);
	assign c_o[24] = (a_i[24] & se_n) | (b_i[24] & se_i);
	assign c_o[25] = (a_i[25] & se_n) | (b_i[25] & se_i);
	assign c_o[26] = (a_i[26] & se_n) | (b_i[26] & se_i);
	assign c_o[27] = (a_i[27] & se_n) | (b_i[27] & se_i);
	assign c_o[28] = (a_i[28] & se_n) | (b_i[28] & se_i);
	assign c_o[29] = (a_i[29] & se_n) | (b_i[29] & se_i);
	assign c_o[30] = (a_i[30] & se_n) | (b_i[30] & se_i);
	assign c_o[31] = (a_i[31] & se_n) | (b_i[31] & se_i);
	
endmodule