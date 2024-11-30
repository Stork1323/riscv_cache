module vedic_mul_4x4(
	input logic [3:0] a, b,
	output logic [7:0] out
	);
	
	logic w1, w2, x0, x1, x2, x3, y0, y1, y2, y3, y4, p0, p1, p2, p3, ca1, w3, w4, ca2, q0, q1, q2, q3, ca3;
	vedic_mul_2x2 T0(a[0], a[1], b[0], b[1], out[0], out[1], w1, w2);
	vedic_mul_2x2 T1(a[0], a[1], b[2], b[3], x0, x1, x2, x3);
	vedic_mul_2x2 T2(a[2], a[3], b[0], b[1], y0, y1, y2, y3);
	vedic_mul_2x2 T3(a[2], a[3], b[2], b[3], q0, q1, q2, q3);
	
	
	adder_4bit A0({x3, x2, x1, x0}, {y3, y2, y1, y0}, {p3, p2, p1, p0}, ca1);
	adder_4bit A1({2'b00, w2, w1}, {p3, p2, p1, p0}, {w4, w3, out[3], out[2]}, ca2);
	adder_4bit A2({q3, q2, q1, q0}, {ca1, 1'b0, w4, w3}, out[7:4], ca3);
	
endmodule
	