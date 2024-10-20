`define OP_Btype 		 7'b1100011
`define OP_JAL 		 7'b1101111
`define OP_JALR 		 7'b1100111

// Control signal (funct3) for Branch Comparator
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111

module Branch_predictor(
	input logic rst_ni,
	input logic clk_i,
	input logic BrEq_i,
	input logic BrLt_i,
	input logic [31:0] inst_ex_i,
	input logic [31:0] alu_i,
	input logic [31:0] pc_i,
	input logic [31:0] pc_ex_i,
	input logic hit_ex_i,
	output logic hit_o,
	output logic [31:0] predicted_pc_o,
	output logic [1:0] wrong_predicted_o,
	output logic [31:0] alu_pc_o
	);
	
	logic [6:0] opcode_r;
	logic [2:0] funct3;
	
	logic [4:0] index_w;
	logic pc_sel_w;
	logic [31:0] alu_w;
	
	logic hit_w;
	logic [1:0] wrong_predicted_w;
	logic predicted_bit;
	
	typedef struct packed {
		logic [19:0] tag;
		logic valid;
		logic [31:0] target_pc;
		} BTB_t;
	
	// 
	typedef enum logic [1:0] {
		ST = 2'b11,
		WT = 2'b10,
		SNT = 2'b01,
		WNT = 2'b00
		} predict_2bit_e;
		
	predict_2bit_e predicted_2bit[31:0], predicted_2bit_temp;
	
	BTB_t BTB_r[31:0], BTB_temp_r;
	
	assign opcode_r = inst_ex_i[6:0];
	assign funct3 = inst_ex_i[14:12];
	
				 
	assign pc_sel_w = ((opcode_r == `OP_Btype) & ((funct3 == `BEQ) & (BrEq_i))  | 
						   ((opcode_r == `OP_Btype) & (funct3 == `BNE) & (~BrEq_i))  | 
						   ((opcode_r == `OP_Btype) & (funct3 == `BLT) & (BrLt_i))   | 
						   ((opcode_r == `OP_Btype) & (funct3 == `BGE) & (~BrLt_i))  |
						   ((opcode_r == `OP_Btype) & (funct3 == `BLTU) & (BrLt_i))  |
						   ((opcode_r == `OP_Btype) & (funct3 == `BGEU) & (~BrLt_i)) |
						   ((opcode_r == `OP_JAL) | (opcode_r == `OP_JALR))) ? 1'b1 : 1'b0;
	assign alu_w = (~rst_ni) ? 32'b0 : alu_i;
	

	// update BTB
	//assign BTB_temp_r = ((pc_sel_w) | (BTB_r[pc_ex_i[6:2]].valid)) ? ({pc_ex_i[31:12], 1'b1, alu_w}) : 53'b0;
	always_comb begin
		//if ((pc_sel_w) | (BTB_r[pc_ex_i[6:2]].valid))
		if (pc_sel_w)
			BTB_temp_r = {pc_ex_i[31:12], 1'b1, alu_w};
		//else BTB_temp_r = 53'b0;
		else BTB_temp_r = BTB_r[pc_ex_i[6:2]];
	end
	assign index_w = pc_ex_i[6:2];
	
//	assign BTB_r[index_w] = (pc_sel_w) ? ({pc_ex_i[31:12], 1'b1, alu_w}) : 53'b0;
	//
	
	// update static of 2bit dynamic prediction
	always_comb begin
		case (predicted_2bit[pc_ex_i[6:2]])
			ST:
				if (wrong_predicted_w == 2'b01) predicted_2bit_temp = WT;
				else predicted_2bit_temp = ST;
			WT:
				if (wrong_predicted_w == 2'b01) predicted_2bit_temp = WNT;
				//else if (wrong_predicted_w == 2'b10) predicted_2bit_temp = ST;
				else predicted_2bit_temp = ST;
			WNT:
				if (wrong_predicted_w == 2'b10) predicted_2bit_temp = WT;
				//else if (wrong_predicted_w == 2'b10) predicted_2bit_temp = WT;
				else predicted_2bit_temp = SNT;
			SNT:
				if (wrong_predicted_w == 2'b10) predicted_2bit_temp = WNT;
				else predicted_2bit_temp = SNT;
		endcase
	end
	
	// 1 du doan nhay nhung khong nhya
	// 2 du doan khong nhay nhung nhay
	
	always_ff @(posedge clk_i) begin
		if (~rst_ni) begin
			BTB_r[0] <= 53'b0;
			BTB_r[1] <= 53'b0;
			BTB_r[2] <= 53'b0;
			BTB_r[3] <= 53'b0;
			BTB_r[4] <= 53'b0;
			BTB_r[5] <= 53'b0;
			BTB_r[6] <= 53'b0;
			BTB_r[7] <= 53'b0;
			BTB_r[8] <= 53'b0;
			BTB_r[9] <= 53'b0;
			BTB_r[10] <= 53'b0;
			BTB_r[11] <= 53'b0;
			BTB_r[12] <= 53'b0;
			BTB_r[13] <= 53'b0;
			BTB_r[14] <= 53'b0;
			BTB_r[15] <= 53'b0;
			BTB_r[16] <= 53'b0;
			BTB_r[17] <= 53'b0;
			BTB_r[18] <= 53'b0;
			BTB_r[19] <= 53'b0;
			BTB_r[20] <= 53'b0;
			BTB_r[21] <= 53'b0;
			BTB_r[22] <= 53'b0;
			BTB_r[23] <= 53'b0;
			BTB_r[24] <= 53'b0;
			BTB_r[25] <= 53'b0;
			BTB_r[26] <= 53'b0;
			BTB_r[27] <= 53'b0;
			BTB_r[28] <= 53'b0;
			BTB_r[29] <= 53'b0;
			BTB_r[30] <= 53'b0;
			BTB_r[31] <= 53'b0;
			predicted_2bit[0] <= ST;
			predicted_2bit[1] <= ST;
			predicted_2bit[2] <= ST;
			predicted_2bit[3] <= ST;
			predicted_2bit[4] <= ST;
			predicted_2bit[5] <= ST;
			predicted_2bit[5] <= ST;
			predicted_2bit[6] <= ST;
			predicted_2bit[7] <= ST;
			predicted_2bit[8] <= ST;
			predicted_2bit[9] <= ST;
			predicted_2bit[10] <= ST;
			predicted_2bit[11] <= ST;
			predicted_2bit[12] <= ST;
			predicted_2bit[13] <= ST;
			predicted_2bit[14] <= ST;
			predicted_2bit[15] <= ST;
			predicted_2bit[16] <= ST;
			predicted_2bit[17] <= ST;
			predicted_2bit[18] <= ST;
			predicted_2bit[19] <= ST;
			predicted_2bit[20] <= ST;
			predicted_2bit[21] <= ST;
			predicted_2bit[22] <= ST;
			predicted_2bit[23] <= ST;
			predicted_2bit[24] <= ST;
			predicted_2bit[25] <= ST;
			predicted_2bit[26] <= ST;
			predicted_2bit[27] <= ST;
			predicted_2bit[28] <= ST;
			predicted_2bit[29] <= ST;
			predicted_2bit[30] <= ST;
			predicted_2bit[31] <= ST;
		end
		else begin
			BTB_r[index_w] <= BTB_temp_r;
			predicted_2bit[index_w] <= predicted_2bit_temp;
		end
		
	end
	
	always_comb begin
		if ((pc_i[31:12] == BTB_r[pc_i[6:2]].tag) & (BTB_r[pc_i[6:2]].valid))
			hit_w = 1'b1;
		else hit_w = 1'b0;
		
		if ((pc_sel_w == 1'b0) & (hit_ex_i == 1'b1))
			wrong_predicted_w = 2'b01;						// predict jump but wrong
		else if ((pc_sel_w == 1'b1) & (hit_ex_i == 1'b0))
			wrong_predicted_w = 2'b10;						// predict not jump but wrong
		else if ((pc_sel_w == 1'b1) & (hit_ex_i == 1'b1) & (alu_w != BTB_r[pc_ex_i[6:2]].target_pc)) // jump to wrong address
			wrong_predicted_w = 2'b10;
		else wrong_predicted_w = 2'b0;
		
		case (predicted_2bit[pc_i[6:2]])
			ST, WT: predicted_bit = 1'b1;
			SNT, WNT: predicted_bit = 1'b0;
			default : predicted_bit = 1'b0;
		endcase
	end
	
	
	assign predicted_pc_o = BTB_r[pc_i[6:2]].target_pc;
	assign alu_pc_o = alu_w;
	assign wrong_predicted_o = wrong_predicted_w;
	assign hit_o = hit_w & predicted_bit;
	
endmodule
