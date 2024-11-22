`timescale 10ns / 10ps

module singlecycle_tb();

`define clk 50

	logic clk_i = 1'b0;
	logic rst_ni;
	logic [31:0] io_sw_i;
	//logic [31:0] pc_debug_o;
	logic [31:0] io_lcd_o;
	logic [31:0] io_ledg_o;
	logic [31:0] io_ledr_o;
	logic [31:0] io_hex0_o;
	logic [31:0] io_hex1_o;
	logic [31:0] io_hex2_o;
	logic [31:0] io_hex3_o;
	logic [31:0] io_hex4_o;
	logic [31:0] io_hex5_o;
	logic [31:0] io_hex6_o;
	logic [31:0] io_hex7_o;
	
	
	singlecycle CPU(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.io_sw_i(io_sw_i),
		.io_hex0_o(io_hex0_o),
		.io_hex1_o(io_hex1_o),
		.io_hex2_o(io_hex2_o),
		.io_hex3_o(io_hex3_o),
		.io_hex4_o(io_hex4_o),
		.io_hex5_o(io_hex5_o),
		.io_hex6_o(io_hex6_o),
		.io_hex7_o(io_hex7_o),
		.io_lcd_o(io_lcd_o),
		.io_ledg_o(io_ledg_o),
		.io_ledr_o(io_ledr_o)
		//.pc_debug_o(pc_debug_o)
	);
	
	initial begin
		$dumpfile("Risc-v_processor.vcd");
		$dumpvars(0);
	end
	
	initial begin
		rst_ni <= 1'b0;
		#150;
		
		rst_ni <= 1'b1;
		#4000;
		$finish;
	end
	
	always #(`clk) clk_i = ~clk_i;

endmodule

