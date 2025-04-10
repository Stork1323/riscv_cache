module wrapper(
	input logic CLOCK_27,
	input logic [17:0] SW,
	input logic [0:0] KEY,
	output logic [16:0] LEDR,
	output logic [7:0] LEDG,
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [6:0] HEX2,
	output logic [6:0] HEX3,
	output logic [6:0] HEX4,
	output logic [6:0] HEX5,
	output logic [6:0] HEX6,
	output logic [6:0] HEX7,
	output logic LCD_EN,
	output logic LCD_RW,
	output logic LCD_RS,
	output logic LCD_ON,
	output logic [7:0] LCD_DATA,
  input logic SRAM_OE_N,
  inout [15:0] SRAM_DQ,
  output logic [17:0] SRAM_ADDR,
  output logic SRAM_CE_N,
  output logic SRAM_WE_N,
  output logic SRAM_LB_N,
  output logic SRAM_UB_N
	);
	
	logic [31:0] temp_r;
//	//logic [31:0] cache_r;
//	
//	//assign SW[16] = 1'b0;
//	
//	pipeline CPU(
//		.clk_i(CLOCK_27),
//		.rst_ni(SW[17]),
//		//.io_sw_i({{15{1'b0}}, KEY[0], SW[15:0]}),
//		.io_sw_i({{16{1'b0}}, SW[15:0]}),
//		//.pc_debug_o(cache_r),
//		.io_lcd_o({LCD_ON, temp_r[19:0], LCD_EN, LCD_RS, LCD_RW, LCD_DATA}),
//		.io_ledg_o(LEDG),
//		.io_ledr_o(LEDR),
//		.io_hex0_o(HEX0),
//		.io_hex1_o(HEX1),
//		.io_hex2_o(HEX2),
//		.io_hex3_o(HEX3),
//		.io_hex4_o(HEX4),
//		.io_hex5_o(HEX5),
//		.io_hex6_o(HEX6),
//		.io_hex7_o(HEX7)
//		);
	
 riscv_cache CPU(
   .clk_i(CLOCK_27),
   .rst_ni(SW[17]),
   .io_sw_i({{16{1'b0}}, SW[15:0]}),
   .io_lcd_o({LCD_ON, temp_r[19:0], LCD_EN, LCD_RS, LCD_RW, LCD_DATA}),
   .io_ledg_o(LEDG),
   .io_ledr_o(LEDR),
   .io_hex0_o(HEX0),
   .io_hex1_o(HEX1),
   .io_hex2_o(HEX2),
   .io_hex3_o(HEX3),
   .io_hex4_o(HEX4),
   .io_hex5_o(HEX5),
   .io_hex6_o(HEX6),
   .io_hex7_o(HEX7),
   .SRAM_OE_N(SRAM_OE_N),
   .SRAM_DQ(SRAM_DQ),
   .SRAM_ADDR(SRAM_ADDR),
   .SRAM_CE_N(SRAM_CE_N),
   .SRAM_WE_N(SRAM_WE_N),
   .SRAM_LB_N(SRAM_LB_N),
   .SRAM_UB_N(SRAM_UB_N)
);
endmodule
