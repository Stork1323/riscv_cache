`timescale 10ns / 10ps

module alu_tb();

`define clk 1

	logic [31:0]  rs1_i,  rs2_i;
	logic [3:0] AluSel_i;
	logic Mul_ext_i = 0;
	logic [31:0] Result_o;
	logic [31:0] temp;
	
	alu ALU(
		.*
	);
	
	task check(input logic [31:0] data_ex);
		$display("[%3d], rs1_i = %5d, rs2_i = %5d, Result_o = %5d, data_ex = %5d", $time, rs1_i, rs2_i, Result_o, data_ex);
		assert(data_ex == Result_o)
		else begin
			$display("Test failed");
			$stop;
		end
	endtask
	
	initial begin
		//rst_ni = 1'b0;
		//#3;
		
		//rst_ni = 1'b1;
		//#1;
		
		AluSel_i = 4'b0000; //add
		rs1_i = $random;
		rs1_2 = $random;
		temp = rs1_i + rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b1000; //sub
		rs1_i = $random;
		rs1_2 = $random;
		temp = rs1_i - rs2_i;
		check(temp);
		#2;
		
		AluSel_i =  4'b0001; //sll
		rs1_i = $random;
		rs1_2 = $random % 32;
		temp = rs1_i << rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b0010; //slt
		rs1_i = $random;
		rs1_2 = $random;
		temp = (rs1_i < rs2_i) ? 32'b1 : 32'b0;
		check(temp);
		#2;
		
		AluSel_i = 4'b0011; //sltu
		rs1_i = $urandom;
		rs1_2 = $urandom;
		temp = (rs1_i < rs2_i) ? 32'b1 : 32'b0;
		check(temp);
		#2;
		
		AluSel_i = 4'b0100; //xor
		rs1_i = $random;
		rs1_2 = $random;
		temp = rs1_i ^ rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b0101; //srl
		rs1_i = $random;
		rs1_2 = $random % 32;
		temp = rs1_i >> rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b1101; //sra
		rs1_i = $random;
		rs1_2 = $random % 32;
		temp = rs1_i >>> rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b0110; //or
		rs1_i = $random;
		rs1_2 = $random;
		temp = rs1_i | rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b0111; //and 
		rs1_i = $random;
		rs1_2 = $random;
		temp = rs1_i & rs2_i;
		check(temp);
		#2;
		
		AluSel_i = 4'b1111; // B
		rs1_i = $random;
		rs1_2 = $random;
		temp = rs2_i;
		check(temp);
		#2;
		
		$display("Test passed");
		#5 $finish;
	end
	
	
	//always #(`clk) clk_i = ~clk_i;

endmodule