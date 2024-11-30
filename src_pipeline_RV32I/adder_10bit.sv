

module adder_10bit(
	input logic [9:0] a, b,
	output logic [9:0] s
	//output logic c
	);
	
	logic [9:0] carry;
	full_adder FA0(a[0], b[0], 1'b0, s[0], carry[0]);
	full_adder FA1(a[1], b[1], carry[0], s[1], carry[1]);
	full_adder FA2(a[2], b[2], carry[1], s[2], carry[2]);
	full_adder FA3(a[3], b[3], carry[2], s[3], carry[3]);
	full_adder FA4(a[4], b[4], carry[3], s[4], carry[4]);
	full_adder FA5(a[5], b[5], carry[4], s[5], carry[5]);
	full_adder FA6(a[6], b[6], carry[5], s[6], carry[6]);
	full_adder FA7(a[7], b[7], carry[6], s[7], carry[7]);
	full_adder FA8(a[8], b[8], carry[7], s[8], carry[8]);
	full_adder FA9(a[9], b[9], carry[8], s[9], carry[9]);
	//assign c = carry[9];
	
endmodule