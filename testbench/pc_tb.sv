`timescale 10ns / 10ps

module pc_tb();

`define clk 1

	logic clk_i = 1'b0;
	logic rst_ni;
	logic [31:0] data_i;
	logic [31:0] data_o;
	
	pc PC(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.data_i(data_i),
		.data_o(data_o)
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
		data_i <= 1'b0;
		#3;
		
		rst_ni <= 1'b1;
		#1;
		
		repeat(100) begin
			data_i = $random;
			#0.5;
		end
		$display("Test passed");
		#5 $finish;
	end
	
	always @(posedge clk_i) begin
		#0.1 check(data_i);
	end
	
	always #(`clk) clk_i = ~clk_i;

endmodule

