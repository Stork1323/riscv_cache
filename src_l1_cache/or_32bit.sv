module or_32bit(
	input logic [31:0] a_i, b_i,
	output logic [31:0] c_o
	);
	
	assign c_o[0] = a_i[0] | b_i[0];
	assign c_o[1] = a_i[1] | b_i[1];
	assign c_o[2] = a_i[2] | b_i[2];
	assign c_o[3] = a_i[3] | b_i[3];
	assign c_o[4] = a_i[4] | b_i[4];
	assign c_o[5] = a_i[5] | b_i[5];
	assign c_o[6] = a_i[6] | b_i[6];
	assign c_o[7] = a_i[7] | b_i[7];
	assign c_o[8] = a_i[8] | b_i[8];
	assign c_o[9] = a_i[9] | b_i[9];
	assign c_o[10] = a_i[10] | b_i[10];
	assign c_o[11] = a_i[11] | b_i[11];
	assign c_o[12] = a_i[12] | b_i[12];
	assign c_o[13] = a_i[13] | b_i[13];
	assign c_o[14] = a_i[14] | b_i[14];
	assign c_o[15] = a_i[15] | b_i[15];
	assign c_o[16] = a_i[16] | b_i[16];
	assign c_o[17] = a_i[17] | b_i[17];
	assign c_o[18] = a_i[18] | b_i[18];
	assign c_o[19] = a_i[19] | b_i[19];
	assign c_o[20] = a_i[20] | b_i[20];
	assign c_o[21] = a_i[21] | b_i[21];
	assign c_o[22] = a_i[22] | b_i[22];
	assign c_o[23] = a_i[23] | b_i[23];
	assign c_o[24] = a_i[24] | b_i[24];
	assign c_o[25] = a_i[25] | b_i[25];
	assign c_o[26] = a_i[26] | b_i[26];
	assign c_o[27] = a_i[27] | b_i[27];
	assign c_o[28] = a_i[28] | b_i[28];
	assign c_o[29] = a_i[29] | b_i[29];
	assign c_o[30] = a_i[30] | b_i[30];
	assign c_o[31] = a_i[31] | b_i[31];
	
	
endmodule
