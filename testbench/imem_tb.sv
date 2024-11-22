`timescale 10ns / 10ps

module imem_tb();

`define clk 1

	//logic clk_i = 1'b0;
	logic rst_ni;
	//logic [31:0] data_i;
	//logic [31:0] data_o;
	logic [31:0] addr_i;
	logic [31:0] inst_o;
	
	imem IMEM(
		.rst_ni(rst_ni),
		.addr_i(addr_i),
		.inst_o(inst_o)
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
		
		/*
			mem[0] = 32'h00D00793;
			mem[1] = 32'h0387C713;
			mem[2] = 32'h00E7E713;
		*/
		addr_i <= 0;
		#4;
		
		addr_i <= 1;
		#2;
		
		addr_i <= 2;
		#4;
		
		$display("Test passed");
		#5 $finish;
	end
	
	
	always #(`clk) clk_i = ~clk_i;

endmodule

