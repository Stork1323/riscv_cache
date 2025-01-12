module full_adder(
	input logic a_i, b_i, c_i,
	output logic s_o, c_o
	);
	
	assign s_o = a_i ^ b_i ^ c_i;
	assign c_o = (a_i & b_i) | (b_i & c_i) | (a_i & c_i);
	
endmodule
