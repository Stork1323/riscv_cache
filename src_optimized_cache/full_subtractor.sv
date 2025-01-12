module full_subtractor(
	input logic a_i, b_i, c_i,
	output logic d_o, b_o
	);
	
	assign d_o = a_i ^ b_i ^ c_i;
	assign b_o = ((~a_i) & (b_i ^ c_i)) | (b_i & c_i);
	
endmodule
