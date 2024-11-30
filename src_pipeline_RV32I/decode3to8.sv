module decode3to8(
	input logic [2:0] code_i,
	output logic [7:0] onehot_o
	);
	
	assign onehot_o[0] = (~code_i[2]) & (~code_i[1]) & (~code_i[0]);
	assign onehot_o[1] = (~code_i[2]) & (~code_i[1]) & (code_i[0]);
	assign onehot_o[2] = (~code_i[2]) & (code_i[1]) & (~code_i[0]);
	assign onehot_o[3] = (~code_i[2]) & (code_i[1]) & (code_i[0]);
	assign onehot_o[4] = (code_i[2]) & (~code_i[1]) & (~code_i[0]);
	assign onehot_o[5] = (code_i[2]) & (~code_i[1]) & (code_i[0]);
	assign onehot_o[6] = (code_i[2]) & (code_i[1]) & (~code_i[0]);
	assign onehot_o[7] = (code_i[2]) & (code_i[1]) & (code_i[0]);

endmodule
