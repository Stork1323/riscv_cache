module wrapper(
	input logic CLOCK_50,
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
	output logic [7:0] LCD_DATA
	);
	
	logic [31:0] temp_r;
	
	//assign SW[16] = 1'b0;
	
	singlecycle CPU(
		.clk_i(CLOCK_50),
		.rst_ni(SW[17]),
		.io_sw_i({{15{1'b0}}, KEY[0], SW[15:0]}),
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
		.io_hex7_o(HEX7)
		);
	
endmodule
