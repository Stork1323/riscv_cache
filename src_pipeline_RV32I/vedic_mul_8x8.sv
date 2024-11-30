module vedic_mul_8x8(
	input logic [7:0] a, b,
	output logic [15:0] out
	);
	
	logic [7:0] temp1;
	logic [7:0] temp2;
	logic [7:0] temp3;
	logic [9:0] temp4;
	logic [9:0] temp5;
	logic [7:0] temp6;
	logic [7:0] temp7;
	
	vedic_mul_4x4 F0(a[3:0], b[3:0], temp1);
	assign out[3:0] = temp1[3:0];
	vedic_mul_4x4 F1(a[7:4], b[3:0], temp2);
	vedic_mul_4x4 F2(a[3:0], b[7:4], temp3);
	
	adder_10bit B0({2'b00, temp2}, {2'b00, temp3}, temp4);
	adder_10bit B1(temp4, {6'b000000, temp1[7:4]}, temp5);
	assign out[7:4] = temp5[3:0];
	
	vedic_mul_4x4 F3(a[7:4], b[7:4], temp6);
	adder_8bit B2(temp6, {2'b00, temp5[9:4]}, temp7);
	assign out[15:8] = temp7;
	
endmodule
	