`define OP_Itype_load 7'b0000011

module Hazard_unit(
	input logic rst_ni,
	input logic RegWEn_mem_i,
	input logic RegWEn_wb_i,
	input logic [31:0] inst_ex_i,
	input logic [31:0] inst_mem_i,
	input logic [31:0] inst_wb_i,
	input logic [1:0] PC_taken_i,
	output logic [1:0] Bsel_o,
	output logic [1:0] Asel_o,
	output logic Stall_IF,
	output logic Stall_ID,
	output logic Flush_ID,
	output logic Stall_EX,
	output logic Flush_EX,
	output logic Stall_MEM,
	output logic Flush_MEM,
	output logic Stall_WB,
	output logic Flush_WB
	);
	
	

	assign Asel_o = (~rst_ni) ? 2'b00 :
						 ((RegWEn_mem_i) & (inst_ex_i[19:15] == inst_mem_i[11:7]) & (inst_mem_i[11:7] != 5'b0)) ? 2'b01 :
						 ((RegWEn_wb_i) & (inst_ex_i[19:15] == inst_wb_i[11:7]) & (inst_wb_i[11:7] != 5'b0)) ? 2'b10 : 2'b00;
	assign Bsel_o = (~rst_ni) ? 2'b00 : 
						 ((RegWEn_mem_i) & (inst_ex_i[24:20] == inst_mem_i[11:7]) & (inst_mem_i[11:7] != 5'b0)) ? 2'b01 :
						 ((RegWEn_wb_i) & (inst_ex_i[24:20] == inst_wb_i[11:7]) & (inst_wb_i[11:7] != 5'b0)) ? 2'b10 : 2'b00;
						 
	logic lwStall;
	assign lwStall = ((RegWEn_mem_i) & (inst_mem_i[11:7] != 5'b0) & 
						  ((inst_ex_i[19:15] == inst_mem_i[11:7]) | (inst_ex_i[24:20] == inst_mem_i[11:7])) &
						  (inst_mem_i[6:0] == `OP_Itype_load)) ? 1'b1 : 1'b0;
						  
	logic nop;
	assign nop = ((PC_taken_i == 2'b01) | (PC_taken_i == 2'b10)) ? 1'b1 : 1'b0;
	
	assign Stall_IF = lwStall;
	assign Stall_ID = lwStall;
	assign Stall_EX = lwStall;
	assign Stall_MEM = 1'b0;
	assign Stall_WB = 1'b0;
	assign Flush_ID = nop;
	assign Flush_EX = nop;
	assign Flush_MEM = lwStall;
	assign Flush_WB = 1'b0;
	
endmodule

