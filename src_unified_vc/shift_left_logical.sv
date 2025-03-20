module shift_left_logical(
	input logic [31:0] rs1_i, rs2_i,
	output logic [31:0] rd_o
	);
	

	logic [31:0] cond;
	decode_dif DE0(.N_i(rs2_i[4:0]), .Y_o(cond));
	
	logic [31:0] temp [32];
	
	mux2to1_32bit M0(rs1_i, {  rs1_i[30:0], 1'b0}, cond[0], temp[0]); 
	mux2to1_32bit M1(temp[0], {  temp[0][30:0], 1'b0}, cond[1], temp[1]); 
	mux2to1_32bit M2(temp[1], {  temp[1][30:0], 1'b0}, cond[2], temp[2]); 
	mux2to1_32bit M3(temp[2], {  temp[2][30:0], 1'b0}, cond[3], temp[3]); 
	mux2to1_32bit M4(temp[3], {  temp[3][30:0], 1'b0}, cond[4], temp[4]); 
	mux2to1_32bit M5(temp[4], {  temp[4][30:0], 1'b0}, cond[5], temp[5]); 
	mux2to1_32bit M6(temp[5], {  temp[5][30:0], 1'b0}, cond[6], temp[6]); 
	mux2to1_32bit M7(temp[6], {  temp[6][30:0], 1'b0}, cond[7], temp[7]); 
	mux2to1_32bit M8(temp[7], {  temp[7][30:0], 1'b0}, cond[8], temp[8]); 
	mux2to1_32bit M9(temp[8], {  temp[8][30:0], 1'b0}, cond[9], temp[9]); 
	mux2to1_32bit M10(temp[9], {  temp[9][30:0], 1'b0}, cond[10], temp[10]); 
	mux2to1_32bit M11(temp[10], {  temp[10][30:0], 1'b0}, cond[11], temp[11]); 
	mux2to1_32bit M12(temp[11], {  temp[11][30:0], 1'b0}, cond[12], temp[12]); 
	mux2to1_32bit M13(temp[12], {  temp[12][30:0], 1'b0}, cond[13], temp[13]); 
	mux2to1_32bit M14(temp[13], {  temp[13][30:0], 1'b0}, cond[14], temp[14]); 
	mux2to1_32bit M15(temp[14], {  temp[14][30:0], 1'b0}, cond[15], temp[15]); 
	mux2to1_32bit M16(temp[15], {  temp[15][30:0], 1'b0}, cond[16], temp[16]); 
	mux2to1_32bit M17(temp[16], {  temp[16][30:0], 1'b0}, cond[17], temp[17]); 
	mux2to1_32bit M18(temp[17], {  temp[17][30:0], 1'b0}, cond[18], temp[18]); 
	mux2to1_32bit M19(temp[18], {  temp[18][30:0], 1'b0}, cond[19], temp[19]); 
	mux2to1_32bit M20(temp[19], {  temp[19][30:0], 1'b0}, cond[20], temp[20]); 
	mux2to1_32bit M21(temp[20], {  temp[20][30:0], 1'b0}, cond[21], temp[21]); 
	mux2to1_32bit M22(temp[21], {  temp[21][30:0], 1'b0}, cond[22], temp[22]); 
	mux2to1_32bit M23(temp[22], {  temp[22][30:0], 1'b0}, cond[23], temp[23]); 
	mux2to1_32bit M24(temp[23], {  temp[23][30:0], 1'b0}, cond[24], temp[24]); 
	mux2to1_32bit M25(temp[24], {  temp[24][30:0], 1'b0}, cond[25], temp[25]); 
	mux2to1_32bit M26(temp[25], {  temp[25][30:0], 1'b0}, cond[26], temp[26]); 
	mux2to1_32bit M27(temp[26], {  temp[26][30:0], 1'b0}, cond[27], temp[27]); 
	mux2to1_32bit M28(temp[27], {  temp[27][30:0], 1'b0}, cond[28], temp[28]); 
	mux2to1_32bit M29(temp[28], {  temp[28][30:0], 1'b0}, cond[29], temp[29]); 
	mux2to1_32bit M30(temp[29], {  temp[29][30:0], 1'b0}, cond[30], temp[30]); 
	mux2to1_32bit M31(temp[30], {  temp[30][30:0], 1'b0}, cond[31], temp[31]); 
	
	assign rd_o = temp[31];
	
endmodule

