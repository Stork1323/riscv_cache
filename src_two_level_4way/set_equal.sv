module set_equal(
	input logic [31:0] rs1_i, rs2_i,
	output logic [31:0] rd_o
	);
	
	logic [31:0] temp;
	xor_32bit X0(rs1_i, rs2_i, temp);
	logic ans;
	assign ans = temp[0] | temp[1] | temp[2] | temp[3] | temp[4] | temp[5] | temp[6] | temp[7] | temp[8] | temp[9] |  
					 temp[10] | temp[11] | temp[12] | temp[13] | temp[14] | temp[15] | temp[16] | temp[17] | temp[18] | 
				    temp[19] | temp[20] | temp[21] | temp[22] | temp[23] | temp[24] | temp[25] | temp[26] | temp[27] |
					 temp[28] | temp[29] | temp[30] | temp[31];
	assign rd_o = {{31{1'b0}}, (~ans)}; // rd_o = rs1_i == rs2_i ? 1 : 0
	
endmodule
