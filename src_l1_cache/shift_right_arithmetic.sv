module shift_right_arithmetic (
	input logic [31:0] rs1_i, rs2_i,
	output logic [31:0] rd_o
	);
	
	logic [31:0] cond;
	decode_dif DE0(.N_i(rs2_i[4:0]), .Y_o(cond));
	
	logic [31:0] temp [32];
	
	mux2to1_32bit M0(rs1_i, {rs1_i[31], rs1_i[31:1]}, cond[0], temp[0]); 
	mux2to1_32bit M1(temp[0], {temp[0][31], temp[0][31:1]}, cond[1], temp[1]); 
	mux2to1_32bit M2(temp[1], {temp[1][31], temp[1][31:1]}, cond[2], temp[2]); 
	mux2to1_32bit M3(temp[2], {temp[2][31], temp[2][31:1]}, cond[3], temp[3]); 
	mux2to1_32bit M4(temp[3], {temp[3][31], temp[3][31:1]}, cond[4], temp[4]); 
	mux2to1_32bit M5(temp[4], {temp[4][31], temp[4][31:1]}, cond[5], temp[5]); 
	mux2to1_32bit M6(temp[5], {temp[5][31], temp[5][31:1]}, cond[6], temp[6]); 
	mux2to1_32bit M7(temp[6], {temp[6][31], temp[6][31:1]}, cond[7], temp[7]); 
	mux2to1_32bit M8(temp[7], {temp[7][31], temp[7][31:1]}, cond[8], temp[8]); 
	mux2to1_32bit M9(temp[8], {temp[8][31], temp[8][31:1]}, cond[9], temp[9]); 
	mux2to1_32bit M10(temp[9], {temp[9][31], temp[9][31:1]}, cond[10], temp[10]); 
	mux2to1_32bit M11(temp[10], {temp[10][31], temp[10][31:1]}, cond[11], temp[11]); 
	mux2to1_32bit M12(temp[11], {temp[11][31], temp[11][31:1]}, cond[12], temp[12]); 
	mux2to1_32bit M13(temp[12], {temp[12][31], temp[12][31:1]}, cond[13], temp[13]); 
	mux2to1_32bit M14(temp[13], {temp[13][31], temp[13][31:1]}, cond[14], temp[14]); 
	mux2to1_32bit M15(temp[14], {temp[14][31], temp[14][31:1]}, cond[15], temp[15]); 
	mux2to1_32bit M16(temp[15], {temp[15][31], temp[15][31:1]}, cond[16], temp[16]); 
	mux2to1_32bit M17(temp[16], {temp[16][31], temp[16][31:1]}, cond[17], temp[17]); 
	mux2to1_32bit M18(temp[17], {temp[17][31], temp[17][31:1]}, cond[18], temp[18]); 
	mux2to1_32bit M19(temp[18], {temp[18][31], temp[18][31:1]}, cond[19], temp[19]); 
	mux2to1_32bit M20(temp[19], {temp[19][31], temp[19][31:1]}, cond[20], temp[20]); 
	mux2to1_32bit M21(temp[20], {temp[20][31], temp[20][31:1]}, cond[21], temp[21]); 
	mux2to1_32bit M22(temp[21], {temp[21][31], temp[21][31:1]}, cond[22], temp[22]); 
	mux2to1_32bit M23(temp[22], {temp[22][31], temp[22][31:1]}, cond[23], temp[23]); 
	mux2to1_32bit M24(temp[23], {temp[23][31], temp[23][31:1]}, cond[24], temp[24]); 
	mux2to1_32bit M25(temp[24], {temp[24][31], temp[24][31:1]}, cond[25], temp[25]); 
	mux2to1_32bit M26(temp[25], {temp[25][31], temp[25][31:1]}, cond[26], temp[26]); 
	mux2to1_32bit M27(temp[26], {temp[26][31], temp[26][31:1]}, cond[27], temp[27]); 
	mux2to1_32bit M28(temp[27], {temp[27][31], temp[27][31:1]}, cond[28], temp[28]); 
	mux2to1_32bit M29(temp[28], {temp[28][31], temp[28][31:1]}, cond[29], temp[29]); 
	mux2to1_32bit M30(temp[29], {temp[29][31], temp[29][31:1]}, cond[30], temp[30]); 
	mux2to1_32bit M31(temp[30], {temp[30][31], temp[30][31:1]}, cond[31], temp[31]); 
	
	assign rd_o = temp[31];
	
	
	
endmodule
