`timescale 1ns / 1ns
`define clk 10

module riscv_cache_tb();

	logic clk_i;
	logic rst_ni;
	logic [31:0] io_sw_i;
	//output logic [31:0] pc_debug_o,
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
	// logic [31:0] No_acc_o;
	// logic [31:0] No_hit_o;
	// logic [31:0] No_miss_o;
	//logic [31:0] No_command_o;
	
	riscv_cache dut(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.io_sw_i(io_sw_i),
	//output logic [31:0] pc_debug_o,
		.io_lcd_o(io_lcd_o),
		.io_ledg_o(io_ledg_o),
		.io_ledr_o(io_ledr_o),
		.io_hex0_o(io_hex0_o),
		.io_hex1_o(io_hex1_o),
		.io_hex2_o(io_hex2_o),
		.io_hex3_o(io_hex3_o),
		.io_hex4_o(io_hex4_o),
		.io_hex5_o(io_hex5_o),
		.io_hex6_o(io_hex6_o),
		.io_hex7_o(io_hex7_o)
		//.No_command_o(No_command_o)
		// .No_acc_o(No_acc_o),
		// .No_hit_o(No_hit_o),
		// .No_miss_o(No_miss_o)
		);
		
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0);
	end
		
	initial begin
		clk_i <= 1'b0;
		rst_ni <= 1'b0;
		io_sw_i <= 17755;
		
		#100;
		
		rst_ni <= 1'b1;
		
		#60000;
		$finish;
		
	end
	
	always #(`clk) clk_i = ~clk_i;

endmodule

