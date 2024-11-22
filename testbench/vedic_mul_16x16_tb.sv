`timescale 1ns / 1ps

module vedic_mul_16x16_tb;
	
	logic [15:0] a, b;
	logic [31:0] result;
	Vedic_mul_16x16 U0(a, b, result);
	
	initial begin
		#10 a = 14222; b = 2145;
		#10 a = 12331; b = -13330;
		#10 a = -2478; b = -131;
		#10 a = -7391; b = 66;
		#10 a = 24; b = 134;
		#10 a = 1127; b = -8913;
		
		//#50 $finish;
	end
	
	//always #5 clk = ~clk;
	
endmodule