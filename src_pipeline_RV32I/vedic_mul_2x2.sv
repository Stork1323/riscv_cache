module vedic_mul_2x2(
	input logic a0, a1, b0, b1,
	output logic s0, s1, s2, s3
	);
	
	logic c;
	assign s0 = a0 & b0;
	assign s1 = (a0 & b1) ^ (a1 & b0);
	assign c = (a0 & b1) & (a1 & b0);
	assign s2 = c ^ (a1 & b1);
	assign s3 = c & (a1 & b1);
	
endmodule
