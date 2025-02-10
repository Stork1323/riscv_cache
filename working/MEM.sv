import cache_def::*;

module MEM(
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] alu_mem_i,
	input logic [31:0] rs2_mem_i,
	input logic [31:0] pc4_mem_i,
	input logic MemRW_mem_i,
	input logic [1:0] WBSel_mem_i,
	input logic RegWEn_mem_i,
	input logic [4:0] rsW_mem_i,
	input logic [31:0] inst_mem_i,
	input logic enable_i,
	input logic reset_i,
	/* valid signal when CPU access cache */
	input logic Valid_cpu2cache_mem_i,
	input logic stall_by_icache_i,
	input mem_data_type d_cache_data_i,
	output evict_data_type evict_data_o,
	output logic [31:0] alu_wb_o,
	output logic [31:0] pc4_wb_o,
	output logic [31:0] mem_wb_o,
	output logic [1:0] WBSel_wb_o,
	output logic RegWEn_wb_o,
	output logic [4:0] rsW_wb_o,
	output logic [31:0] inst_wb_o,
	output logic stall_by_dcache_o,
	output mem_req_type d_cache_request_o,
	output logic [31:0] no_acc_o,
	output logic [31:0] no_hit_o,
	output logic [31:0] no_miss_o
	);
	
	logic [31:0] mem_w;
	
	logic [31:0] alu_r, pc4_r, mem_r;
	logic [1:0] WBSel_r;
	logic RegWEn_r;
	logic [4:0] rsW_r;
	logic [31:0] inst_r;

	/* valid signal that memory response to cache */
	logic Valid_memory2cache_w;

	import cache_def::*;
	cpu_req_type cpu_req_w;
	cpu_result_type cpu_result_w;
	mem_req_type mem_req_w;
	mem_data_type mem_data_w;

	cache_data_type memory_data_w;

	// counter of access, hit, miss cache
	// logic [31:0] no_acc_w;
	// logic [31:0] no_hit_w;
	// logic [31:0] no_miss_w;

	
	// lsu LSU_MEM(
	// 	.addr_i(mem_req_w.addr),
	// 	.dataW_i(mem_req_w.data),
	// 	.MemRW_i(mem_req_w.rw),
	// 	.clk_i(clk_i),
	// 	.rst_ni(rst_ni),
	// 	.io_sw_i(io_sw_i),
	// 	.mem_req_valid_i(mem_req_w.valid),
	// 	.dataR_o(memory_data_w),
	// 	.io_lcd_o(io_lcd_o),
	// 	.io_ledg_o(io_ledg_o),
	// 	.io_ledr_o(io_ledr_o),
	// 	.io_hex0_o(io_hex0_o),
	// 	.io_hex1_o(io_hex1_o),
	// 	.io_hex2_o(io_hex2_o),
	// 	.io_hex3_o(io_hex3_o),
	// 	.io_hex4_o(io_hex4_o),
	// 	.io_hex5_o(io_hex5_o),
	// 	.io_hex6_o(io_hex6_o),
	// 	.io_hex7_o(io_hex7_o),
	// 	.Valid_memory2cache_o(Valid_memory2cache_w)
	// 	);

	assign d_cache_request_o = mem_req_w;
	assign mem_data_w = d_cache_data_i;
	
	d_cache D_CACHE(
    	.clk_i(clk_i),
    	.rst_ni(rst_ni),
    	.cpu_req_i(cpu_req_w),
    	.mem_data_i(mem_data_w),
		.evict_data_o(evict_data_o),
    	.cpu_res_o(cpu_result_w),
    	.mem_req_o(mem_req_w),
		.no_acc_o(no_acc_o),
		.no_hit_o(no_hit_o),
		.no_miss_o(no_miss_o)
	);

	assign mem_w = cpu_result_w.data;

	always_ff @(posedge clk_i, negedge rst_ni) begin
		if (~rst_ni) begin
			alu_r <= 32'b0;
			pc4_r <= 32'b0;
			mem_r <= 32'b0;
			WBSel_r <= 2'b0;
			RegWEn_r <= 1'b0;
			rsW_r <= 5'b0;
			inst_r <= 32'b0;
		end
		else if (enable_i) begin
			if (reset_i) begin
				alu_r <= 32'b0;
				pc4_r <= 32'b0;
				mem_r <= 32'b0;
				WBSel_r <= 2'b0;
				RegWEn_r <= 1'b0;
				rsW_r <= 5'b0;
				inst_r <= 32'b0;
			end
			else begin
				alu_r <= alu_mem_i;
				pc4_r <= pc4_mem_i;
				mem_r <= mem_w;
				WBSel_r <= WBSel_mem_i;
				RegWEn_r <= RegWEn_mem_i;
				rsW_r <= rsW_mem_i;
				inst_r <= inst_mem_i;
			end
		end
	end

	assign alu_wb_o = alu_r;
	assign pc4_wb_o = pc4_r;
	assign mem_wb_o = mem_r;
	assign WBSel_wb_o = WBSel_r;
	assign RegWEn_wb_o = RegWEn_r;
	assign rsW_wb_o = rsW_r;
	assign inst_wb_o = inst_r;

	/* connect signals for cache */
	//assign cpu_req_w = {alu_mem_i, rs2_mem_i, MemRW_mem_i, Valid_cpu2cache_mem_i};
	assign cpu_req_w.addr = alu_mem_i;
	assign cpu_req_w.data = rs2_mem_i;
	assign cpu_req_w.rw = MemRW_mem_i;
	assign cpu_req_w.valid = Valid_cpu2cache_mem_i & (~stall_by_icache_i);
	//assign mem_data_w = {memory_data_w, Valid_memory2cache_w};
	// assign mem_data_w.data = memory_data_w;
	// assign mem_data_w.ready = Valid_memory2cache_w;

	/* control stall for previous stages */
	assign stall_by_dcache_o = (Valid_cpu2cache_mem_i&(~cpu_result_w.ready)) ? 1'b1 : 1'b0;
	
	// logic cpu_result_ready_d, cpu_result_ready_r;
	// assign cpu_result_ready_d = cpu_result_w.ready;
	// always_ff @(posedge clk_i) begin
	// 	cpu_result_ready_r <= cpu_result_ready_d;
	// end
	// assign stall_by_dcache_o = (Valid_cpu2cache_mem_i&(~cpu_result_ready_r)) ? 1'b1 : 1'b0;
	/* debuging */
	// always_ff @(posedge clk_i) begin
	// 	if (Valid_cpu2cache_mem_i&(~cpu_result_w.ready))
	// 		stall_by_dcache_o = 1'b1;
	// 	else stall_by_dcache_o = 1'b0;
	// end

	// assign No_acc_o = no_acc_w;
	// assign No_hit_o = no_hit_w;
	// assign No_miss_o = no_miss_w;
	
endmodule
