module vedic_mul_16x16(
	input logic [15:0] a, b,
	output logic [31:0] out
	);
	
	logic [15:0] temp1;
	logic [15:0] temp2;
	logic [15:0] temp3;
	logic [15:0] temp4;
	logic [23:0] temp5;
	logic [15:0] temp6;
	logic [23:0] temp7;
	logic sign_of_a;
	logic sign_of_b;
	logic [15:0] a_r;
	logic [15:0] b_r;
	logic [15:0] a_n;
	logic [15:0] b_n;
	logic [31:0] out_r;
	logic [31:0] out_nr;
	logic overf_r;
	
	assign sign_of_a = (a[15]) ? 1'b1 : 1'b0;
	assign sign_of_b = (b[15]) ? 1'b1 : 1'b0;
	adder_16bit NA(.a(~a), .b(16'b1), .s(a_n));
	adder_16bit NB(.a(~b), .b(16'b1), .s(b_n));
	
	assign a_r = (sign_of_a) ? a_n : a;
	assign b_r = (sign_of_b) ? b_n : b;
	
	
	vedic_mul_8x8 F0(a_r[7:0], b_r[7:0], temp1);
	assign out_r[7:0] = temp1[7:0];
	vedic_mul_8x8 F1(a_r[15:8], b_r[7:0], temp2);
	vedic_mul_8x8 F2(a_r[7:0], b_r[15:8], temp3);
	vedic_mul_8x8 F3(a_r[15:8], b_r[15:8], temp6);
	
	adder_16bit B0({8'h00, temp1[15:8]}, temp2, temp4);
	adder_24bit B1({8'h00, temp3}, {temp6, 8'h00}, temp5);
	adder_24bit B2({8'h00, temp4}, temp5, temp7);
	
	assign out_r[31:8] = temp7;
	adder_32bit NO(~out_r, 32'b1, out_nr, overf_r);
	assign out = (sign_of_a ^ sign_of_b) ? out_nr : out_r;
	
endmodule
	