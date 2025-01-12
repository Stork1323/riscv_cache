
import cache_def::*;

module riscv_cache(
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] io_sw_i,
	//output logic [31:0] pc_debug_o,
	output logic [31:0] io_lcd_o,
	output logic [31:0] io_ledg_o,
	output logic [31:0] io_ledr_o,
	output logic [31:0] io_hex0_o,
	output logic [31:0] io_hex1_o,
	output logic [31:0] io_hex2_o,
	output logic [31:0] io_hex3_o,
	output logic [31:0] io_hex4_o,
	output logic [31:0] io_hex5_o,
	output logic [31:0] io_hex6_o,
	output logic [31:0] io_hex7_o
	//output logic [31:0] No_command_o
	// output logic [31:0] No_acc_o,
	// output logic [31:0] No_hit_o,
	// output logic [31:0] No_miss_o
	);
	
	logic BrEq_w, BrLt_w, RegWEn_w;
	logic [4:0] rsW_w;
	logic [31:0] alu_mem_w, pc_d_w, inst_d_w, pc4_d_w, data_wb_w;
	logic hit_d_w;
	logic [31:0] rs1_ex_w, rs2_ex_w, imm_ex_w, pc_ex_w, pc4_ex_w;
	logic [3:0] AluSel_ex_w;
	logic BSel_ex_w, ASel_ex_w, MemRW_ex_w, BrUn_ex_w, RegWEn_ex_w;
	logic hit_ex_w;
	logic [4:0] rsW_ex_w;
	logic [1:0] WBSel_ex_w;
	logic [31:0] rs2_mem_w, pc4_mem_w;
	logic MemRW_mem_w, RegWEn_mem_w;
	logic [1:0] WBSel_mem_w;
	logic [4:0] rsW_mem_w;
	logic [31:0] alu_wb_w, pc4_wb_w, mem_wb_w;
	logic RegWEn_wb_w;
	logic [1:0] WBSel_wb_w;
	logic [4:0] rsW_wb_w;
	
	logic [31:0] inst_ex_w, inst_mem_w, inst_wb_w;
	logic [1:0] Asel_haz_w, Bsel_haz_w;
	logic [31:0] alu_w;
	logic hit_w;
	logic [31:0] predicted_pc_w;
	
	logic Stall_IF_w, Stall_ID_w, Flush_ID_w, Stall_EX_w, Flush_EX_w, Stall_MEM_w, Flush_MEM_w, Stall_WB_w;
	logic Flush_WB_w;
	
	logic [31:0] pc_bp_w;
	logic [1:0] wrong_predicted_w;
	logic [31:0] alu_pc_w;

	/* valid signal when CPU access cache */
	logic Valid_cpu2cache_ex_w;
	logic Valid_cpu2cache_mem_w;

	logic stall_by_dcache_w;
	logic stall_by_icache_w;

	/* declare variables for cache */
	mem_data_type i_cache_data_w;
	mem_req_type i_cache_request_w;
	mem_data_type d_cache_data_w;
	mem_req_type d_cache_request_w;

	mem_data_type l1_cache_result_w;
	mem_req_type l1_cache_request_w;

	mem_data_type mem_result_w;
	mem_req_type mem_request_w;
	/* --------------------------- */

	/* evaluation */
	logic [31:0] icache_no_acc_w, icache_no_hit_w, icache_no_miss_w, dcache_no_acc_w, dcache_no_hit_w, dcache_no_miss_w, l2cache_no_acc_w, l2cache_no_hit_w, l2cache_no_miss_w;
	//logic [31:0] no_command_w;

	subtractor_32bit Icache_hit(
		.a_i(icache_no_acc_w),
		.b_i(icache_no_miss_w),
		.d_o(icache_no_hit_w),
		.b_o()
	);
	/* ---------- */
	
	IF IF(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.hit_i(hit_w),
		.predicted_pc_i(predicted_pc_w),
		.enable_pc_i(~(Stall_IF_w | stall_by_dcache_w | stall_by_icache_w)),
		.enable_i(~(Stall_ID_w | stall_by_dcache_w  | stall_by_icache_w)),
		.reset_i(Flush_ID_w),
		.mispredicted_pc_i(pc4_ex_w),
		.wrong_predicted_i(wrong_predicted_w),
		.alu_pc_i(alu_pc_w),
		.i_cache_data_i(i_cache_data_w),
		.pc_d_o(pc_d_w),
		.inst_d_o(inst_d_w),
		.pc4_d_o(pc4_d_w),
		.pc_bp_o(pc_bp_w),
		.hit_d_o(hit_d_w),
		.stall_by_icache_o(stall_by_icache_w),
		.No_command_o(icache_no_acc_w),
		.i_cache_request_o(i_cache_request_w),
		.no_acc_o(),
		.no_hit_o(),
		.no_miss_o(icache_no_miss_w)
		);
		
	ID ID(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.data_wb_i(data_wb_w),
		.inst_d_i(inst_d_w),
		.pc_d_i(pc_d_w),
		.pc4_d_i(pc4_d_w),
		.RegWEn_i(RegWEn_wb_w),
		.rsW_i(rsW_wb_w),
		.enable_i(~(Stall_EX_w | stall_by_dcache_w  | stall_by_icache_w)),
		.reset_i(Flush_EX_w),
		.hit_d_i(hit_d_w),
		.rs1_ex_o(rs1_ex_w),
		.rs2_ex_o(rs2_ex_w),
		.imm_ex_o(imm_ex_w),
		.pc_ex_o(pc_ex_w),
		.pc4_ex_o(pc4_ex_w),
		.AluSel_ex_o(AluSel_ex_w),
		.BSel_ex_o(BSel_ex_w),
		.ASel_ex_o(ASel_ex_w),
		.MemRW_ex_o(MemRW_ex_w),
		.WBSel_ex_o(WBSel_ex_w),
		.BrUn_ex_o(BrUn_ex_w),
		.RegWEn_ex_o(RegWEn_ex_w),
		.rsW_ex_o(rsW_ex_w),
		.inst_ex_o(inst_ex_w),
		.hit_ex_o(hit_ex_w),
		.Valid_cpu2cache_ex_o(Valid_cpu2cache_ex_w)
		);
		
	EX EX(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.rs1_ex_i(rs1_ex_w),
		.rs2_ex_i(rs2_ex_w),
		.imm_ex_i(imm_ex_w),
		.pc_ex_i(pc_ex_w),
		.pc4_ex_i(pc4_ex_w),
		.AluSel_ex_i(AluSel_ex_w),
		.BSel_ex_i(BSel_ex_w),
		.ASel_ex_i(ASel_ex_w),
		.MemRW_ex_i(MemRW_ex_w),
		.WBSel_ex_i(WBSel_ex_w),
		.BrUn_ex_i(BrUn_ex_w),
		.RegWEn_ex_i(RegWEn_ex_w),
		.rsW_ex_i(rsW_ex_w),
		.Asel_haz_i(Asel_haz_w),
		.Bsel_haz_i(Bsel_haz_w),
		.inst_ex_i(inst_ex_w),
		.data_wb_i(data_wb_w),
		.enable_i(~(Stall_MEM_w | stall_by_dcache_w  | stall_by_icache_w)),
		.reset_i(Flush_MEM_w),
		.Valid_cpu2cache_ex_i(Valid_cpu2cache_ex_w),
		.alu_mem_o(alu_mem_w),
		.rs2_mem_o(rs2_mem_w),
		.pc4_mem_o(pc4_mem_w),
		.MemRW_mem_o(MemRW_mem_w),
		.WBSel_mem_o(WBSel_mem_w),
		.BrEq_o(BrEq_w),
		.BrLt_o(BrLt_w),
		.RegWEn_mem_o(RegWEn_mem_w),
		.rsW_mem_o(rsW_mem_w),
		.inst_mem_o(inst_mem_w),
		.alu_o(alu_w),
		.Valid_cpu2cache_mem_o(Valid_cpu2cache_mem_w)
		);
		
	MEM MEM(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.alu_mem_i(alu_mem_w),
		.rs2_mem_i(rs2_mem_w),
		.pc4_mem_i(pc4_mem_w),
		.MemRW_mem_i(MemRW_mem_w),
		.WBSel_mem_i(WBSel_mem_w),
		.RegWEn_mem_i(RegWEn_mem_w),
		.rsW_mem_i(rsW_mem_w),
		//.io_sw_i(io_sw_i),
		.inst_mem_i(inst_mem_w),
		.enable_i(~(Stall_WB_w | stall_by_dcache_w | stall_by_icache_w)),
		.reset_i(Flush_WB_w),
		.Valid_cpu2cache_mem_i(Valid_cpu2cache_mem_w),
		.stall_by_icache_i(stall_by_icache_w),
		.d_cache_data_i(d_cache_data_w),
		.alu_wb_o(alu_wb_w),
		.pc4_wb_o(pc4_wb_w),
		.mem_wb_o(mem_wb_w),
		.WBSel_wb_o(WBSel_wb_w),
		.RegWEn_wb_o(RegWEn_wb_w),
		.rsW_wb_o(rsW_wb_w),
		// .io_lcd_o(io_lcd_o),
		// .io_ledg_o(io_ledg_o),
		// .io_ledr_o(io_ledr_o),
		// .io_hex0_o(io_hex0_o),
		// .io_hex1_o(io_hex1_o),
		// .io_hex2_o(io_hex2_o),
		// .io_hex3_o(io_hex3_o),
		// .io_hex4_o(io_hex4_o),
		// .io_hex5_o(io_hex5_o),
		// .io_hex6_o(io_hex6_o),
		// .io_hex7_o(io_hex7_o),
		.inst_wb_o(inst_wb_w),
		.stall_by_dcache_o(stall_by_dcache_w),
		.d_cache_request_o(d_cache_request_w),
		.no_acc_o(dcache_no_acc_w),
		.no_hit_o(dcache_no_hit_w),
		.no_miss_o(dcache_no_miss_w)
		);
		
	WB WB(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.alu_wb_i(alu_wb_w),
		.pc4_wb_i(pc4_wb_w),
		.mem_wb_i(mem_wb_w),
		.WBSel_wb_i(WBSel_wb_w),
		//.RegWEn_wb_i(RegWEn_wb_w),
		//.rsW_wb_i(rsW_wb_w),
		.dataWB_o(data_wb_w)
		//.RegWEn_o(RegWEn_w),
		//.rsW_o(rsW_w)
		);
		
	Hazard_unit FCU(
		.rst_ni(rst_ni),
		.RegWEn_mem_i(RegWEn_mem_w),
		.RegWEn_wb_i(RegWEn_wb_w),
		.inst_d_i(inst_d_w),
		.inst_ex_i(inst_ex_w),
		.inst_mem_i(inst_mem_w),
		.inst_wb_i(inst_wb_w),
		.PC_taken_i(wrong_predicted_w),
		.Stall_IF(Stall_IF_w),
		.Stall_ID(Stall_ID_w),
		.Flush_ID(Flush_ID_w),
		.Stall_EX(Stall_EX_w),
		.Flush_EX(Flush_EX_w),
		.Stall_MEM(Stall_MEM_w),
		.Flush_MEM(Flush_MEM_w),
		.Stall_WB(Stall_WB_w),
		.Flush_WB(Flush_WB_w),
		.Bsel_o(Bsel_haz_w),
		.Asel_o(Asel_haz_w)
		);
		
	Branch_predictor BP(
		.rst_ni(rst_ni),
		.clk_i(clk_i),
		.BrEq_i(BrEq_w),
		.BrLt_i(BrLt_w),
		.inst_ex_i(inst_ex_w),
		.alu_i(alu_w),
		.pc_i(pc_bp_w),
		.pc_ex_i(pc_ex_w),
		.hit_ex_i(hit_ex_w),
		.hit_o(hit_w),
		.predicted_pc_o(predicted_pc_w),
		.wrong_predicted_o(wrong_predicted_w),
		.alu_pc_o(alu_pc_w)
		);

	cache_arbiter Arbiter(
   		.clk_i(clk_i),
   		.rst_ni(rst_ni),
    	.i_cache_request_i(i_cache_request_w),
    	.d_cache_request_i(d_cache_request_w),
    	.l1_cache_result_i(l1_cache_result_w),
    	.i_cache_data_o(i_cache_data_w),
    	.d_cache_data_o(d_cache_data_w),
    	.l1_cache_request_o(l1_cache_request_w)
		);
	
	l2_cache L2_CACHE(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.l1_cache_request_i(l1_cache_request_w),
		.mem_result_i(mem_result_w),
		.l1_cache_result_o(l1_cache_result_w),
		.mem_req_o(mem_request_w),
		.no_acc_o(l2cache_no_acc_w),
		.no_hit_o(l2cache_no_hit_w),
		.no_miss_o(l2cache_no_miss_w)
		);

	Memory MEMORY(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.mem_request_i(mem_request_w),
		.io_sw_i(io_sw_i),
		.io_lcd_o(io_lcd_o),
		.io_ledr_o(io_ledr_o),
		.io_ledg_o(io_ledg_o),
		.io_hex0_o(io_hex0_o),
		.io_hex1_o(io_hex1_o),
		.io_hex2_o(io_hex2_o),
		.io_hex3_o(io_hex3_o),
		.io_hex4_o(io_hex4_o),
		.io_hex5_o(io_hex5_o),
		.io_hex6_o(io_hex6_o),
		.io_hex7_o(io_hex7_o),
		.mem_result_o(mem_result_w)
		);	
	
endmodule








