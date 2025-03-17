// this module will decode the value of N to N value of 1

module decode_dif(
	input logic [4:0] N_i,
	output logic [31:0] Y_o
	);
	
	assign Y_o[0] = N_i[0] | N_i[1] | N_i[2] | N_i[3] | N_i[4];
	assign Y_o[1] = N_i[1] | N_i[2] | N_i[3] | N_i[4];
	assign Y_o[2] = (N_i[0] & N_i[1]) | N_i[2] | N_i[3] | N_i[4];
	assign Y_o[3] = N_i[2] | N_i[3] | N_i[4];
	assign Y_o[4] = (N_i[0] & N_i[2]) | (N_i[1] & N_i[2]) | N_i[3] | N_i[4];
	assign Y_o[5] = (N_i[1] & N_i[2]) | N_i[3] | N_i[4];
	assign Y_o[6] = (N_i[0] & N_i[1] & N_i[2]) | N_i[3] | N_i[4];
	assign Y_o[7] = N_i[3] | N_i[4];
	assign Y_o[8] = (N_i[0] & N_i[3]) | (N_i[1] & N_i[3]) | (N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[9] = (N_i[1] & N_i[3]) | (N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[10] = (N_i[0] & N_i[1] & N_i[3]) | (N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[11] = (N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[12] = (N_i[0] & N_i[2] & N_i[3]) | (N_i[1] & N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[13] = (N_i[1] & N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[14] = (N_i[0] & N_i[1] & N_i[2] & N_i[3]) | N_i[4];
	assign Y_o[15] = N_i[4];
	assign Y_o[16] = (N_i[0] & N_i[4]) | (N_i[1] & N_i[4]) | (N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[17] = (N_i[1] & N_i[4]) | (N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[18] = (N_i[0] & N_i[1] & N_i[4]) | (N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[19] = (N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[20] = (N_i[0] & N_i[2] & N_i[4]) | (N_i[1] & N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[21] = (N_i[1] & N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[22] = (N_i[0] & N_i[1] & N_i[2] & N_i[4]) | (N_i[3] & N_i[4]);
	assign Y_o[23] = (N_i[3] & N_i[4]);
	assign Y_o[24] = (N_i[0] & N_i[3] & N_i[4]) | (N_i[1] & N_i[3] & N_i[4]) | (N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[25] = (N_i[1] & N_i[3] & N_i[4]) | (N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[26] = (N_i[0] & N_i[1] & N_i[3] & N_i[4]) | (N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[27] = (N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[28] = (N_i[0] & N_i[2] & N_i[3] & N_i[4]) | (N_i[1] & N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[29] = (N_i[1] & N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[30] = (N_i[0] & N_i[1] & N_i[2] & N_i[3] & N_i[4]);
	assign Y_o[31] = 1'b0;
	
	

endmodule

	
	
	