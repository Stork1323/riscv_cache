module EX(
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] rs1_ex_i,
	input logic [31:0] rs2_ex_i,
	input logic [31:0] imm_ex_i,
	input logic [31:0] pc_ex_i,
	input logic [31:0] pc4_ex_i,
	input logic [3:0] AluSel_ex_i,
	input logic BSel_ex_i,
	input logic ASel_ex_i,
	input logic MemRW_ex_i,
	input logic [1:0] WBSel_ex_i,
	input logic BrUn_ex_i,
	input logic RegWEn_ex_i,
	input logic [4:0] rsW_ex_i,
	input logic [31:0] inst_ex_i,
	input logic [31:0] data_wb_i,
	input logic [1:0] Asel_haz_i,
	input logic [1:0] Bsel_haz_i,
	input logic enable_i,
	input logic reset_i,
	/* valid signal when CPU access cache */
	input logic Valid_cpu2cache_ex_i,
	output logic [31:0] alu_mem_o,
	output logic [31:0] rs2_mem_o,
	output logic [31:0] pc4_mem_o,
	output logic MemRW_mem_o,
	output logic [1:0] WBSel_mem_o,
	output logic BrEq_o,
	output logic BrLt_o,
	output logic RegWEn_mem_o,
	output logic [4:0] rsW_mem_o,
	output logic [31:0] inst_mem_o,
	output logic [31:0] alu_o,
	/* valid signal when CPU access cache */
	output logic Valid_cpu2cache_mem_o
	);
	
	logic [31:0] alu_w;
	logic BrEq_w, BrLt_w;
	
	logic [31:0] alu_r, rs2_r, pc4_r;
	logic MemRW_r, /*BrEq_r, BrLt_r,*/ RegWEn_r;
	logic [1:0] WBSel_r;
	logic [4:0] rsW_r;
	logic [31:0] inst_r;
	
	logic [31:0] rs1_ex_w, rs2_ex_w;
	logic [31:0] rs1_haz_w, rs2_haz_w;

	/* valid signal when CPU access cache */
	logic Valid_cpu2cache_r;
	
	brcomp BrComp_EX(
		.rs1_i(rs1_ex_w),
		.rs2_i(rs2_ex_w),
		.BrUn_i(BrUn_ex_i),
		.BrEq_o(BrEq_w),
		.BrLt_o(BrLt_w)
		);
		
	mux3to1_32bit Mux12_EX(
		.a_i(rs1_ex_i),
		.b_i(alu_r),
		.c_i(data_wb_i),
		.se_i(Asel_haz_i),
		.r_o(rs1_ex_w)
		);
		
	mux2to1_32bit Mux1_EX(
		.a_i(rs1_ex_w),
		.b_i(pc_ex_i),
		.se_i(ASel_ex_i),
		.c_o(rs1_haz_w)
		);
		
	mux3to1_32bit Mux22_EX(
		.a_i(rs2_ex_i),
		.b_i(alu_r),
		.c_i(data_wb_i),
		.se_i(Bsel_haz_i),
		.r_o(rs2_ex_w)
		);		
		
	mux2to1_32bit Mux2_EX(
		.a_i(rs2_ex_w),
		.b_i(imm_ex_i),
		.se_i(BSel_ex_i),
		.c_o(rs2_haz_w)
		);
		
	
	
	alu ALU_EX(
		.rs1_i(rs1_haz_w),
		.rs2_i(rs2_haz_w),
		.AluSel_i(AluSel_ex_i),
		//.Mul_ext_i(Mul_ext_w),
		.Result_o(alu_w)
		);
		
	always_ff @(posedge clk_i, negedge rst_ni) begin
		if (~rst_ni) begin
			alu_r <= 32'b0;
			rs2_r <= 32'b0;
			pc4_r <= 32'b0;
			MemRW_r <= 1'b0;
			WBSel_r <= 2'b0;
			//BrEq_r <= 1'b0;
			//BrLt_r <= 1'b0;
			RegWEn_r <= 1'b0;
			rsW_r <= 5'b0;
			inst_r <= 32'b0;
			Valid_cpu2cache_r <= 1'b0;
		end
		else if (enable_i) begin
			if (reset_i) begin
				alu_r <= 32'b0;
				rs2_r <= 32'b0;
				pc4_r <= 32'b0;
				MemRW_r <= 1'b0;
				WBSel_r <= 2'b0;
				//BrEq_r <= 1'b0;
				//BrLt_r <= 1'b0;
				RegWEn_r <= 1'b0;
				rsW_r <= 5'b0;
				inst_r <= 32'b0;
				Valid_cpu2cache_r <= 1'b0;
			end
			else begin
				alu_r <= alu_w;
				rs2_r <= rs2_ex_w;
				pc4_r <= pc4_ex_i;
				MemRW_r <= MemRW_ex_i;
				WBSel_r <= WBSel_ex_i;
				//BrEq_r <= BrEq_w;
				//BrLt_r <= BrLt_w;
				RegWEn_r <= RegWEn_ex_i;
				rsW_r <= rsW_ex_i;
				inst_r <= inst_ex_i;
				Valid_cpu2cache_r <= Valid_cpu2cache_ex_i;
			end
		end
	end
	
	assign alu_mem_o = alu_r;
	assign rs2_mem_o = rs2_r;
	assign pc4_mem_o = pc4_r;
	assign MemRW_mem_o = MemRW_r;
	assign WBSel_mem_o = WBSel_r;
	//assign BrEq_mem_o = BrEq_r;
	//assign BrLt_mem_o = BrLt_r;
	assign BrEq_o = BrEq_w;
	assign BrLt_o = BrLt_w;
	assign RegWEn_mem_o = RegWEn_r;
	assign rsW_mem_o = rsW_r;
	assign inst_mem_o = inst_r;
	assign alu_o = alu_w;
	/* fixing */
	//assign Valid_cpu2cache_mem_o = Valid_cpu2cache_ex_i;
	assign Valid_cpu2cache_mem_o = Valid_cpu2cache_r;
	
endmodule
