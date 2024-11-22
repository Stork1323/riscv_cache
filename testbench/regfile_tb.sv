`timescale 10ns / 10ps

module regfile_tb();

`define clk 1

	logic [31:0] dataW_i;
	logic [4:0] rsW_i, rs1_i, rs2_i;
	logic RegWEn_i;
	logic clk_i = 0;
	logic rst_ni;
	logic [31:0] data1_o, data2_o;
	
	regfile RF(
		.*
	);
	
	task check(input logic [31:0] data_ex);
		$display("[%3d], data_i = %5d, data_o = %5d, data_ex = %5d", $time, data_i, data_o, data_ex);
		assert(data_ex == data_o)
		else begin
			$display("Test failed");
			$stop;
		end
	endtask
	
	initial begin
		rst_ni <= 1'b0;
		#3;
		
		rst_ni <= 1'b1;
		#1;
		
		rs1_i <= 2;
		rs2_i <= 5;
		RegWEn_i <= 0;
		#2;
		
		rs1_i <= 0;
		rs2_i <= 7;
		rsW_i <= 5;
		dataW_i <= 32'h214;
		RegWEn_i <= 1;
		#2;
		
		$display("Test passed");
		#5 $finish;
	end
	
	
	always #(`clk) clk_i = ~clk_i;

endmodule