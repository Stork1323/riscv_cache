
module adder_4bit(
	input logic [3:0] a, b,
	output logic [3:0] s,
	output logic c
	);
	
	logic [3:0] carry;
	full_adder FA0(a[0], b[0], 1'b0, s[0], carry[0]);
	full_adder FA1(a[1], b[1], carry[0], s[1], carry[1]);
	full_adder FA2(a[2], b[2], carry[1], s[2], carry[2]);
	full_adder FA3(a[3], b[3], carry[2], s[3], carry[3]);
	assign c = carry[3];
	
endmodule