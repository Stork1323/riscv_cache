module WB(
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] alu_wb_i,
	input logic [31:0] pc4_wb_i,
	input logic [31:0] mem_wb_i,
	input logic [1:0] WBSel_wb_i,
	output logic [31:0] dataWB_o
	);

	mux3to1_32bit Mux_WB(
			.a_i(mem_wb_i),
			.b_i(alu_wb_i),
			.c_i(pc4_wb_i),
			.se_i(WBSel_wb_i),
			.r_o(dataWB_o)
			);
		

endmodule
