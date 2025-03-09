// Opcode of all types in RISC-V
`define OP_Rtype 		 7'b0110011
`define OP_Itype 		 7'b0010011
`define OP_Itype_load 7'b0000011
`define OP_Stype 		 7'b0100011
`define OP_Btype 		 7'b1100011
`define OP_JAL 		 7'b1101111
`define OP_LUI 		 7'b0110111
`define OP_AUIPC 		 7'b0010111
`define OP_JALR 		 7'b1100111

// ALU function decode from funct3 and bit 5 of funct7
`define ADD  4'b0000
`define SUB  4'b1000
`define SLL  4'b0001
`define SLT  4'b0010
`define SLTU 4'b0011
`define XOR  4'b0100
`define SRL  4'b0101
`define SRA  4'b1101
`define OR   4'b0110
`define AND  4'b0111
`define B	 4'b1111 // in case of grab only immediate value in LUI instruction

// Immediate generation type 
`define I_TYPE 3'b000
`define S_TYPE 3'b001
`define B_TYPE 3'b010
`define J_TYPE 3'b011
`define U_TYPE 3'b100

// Control signal (funct3) for Branch Comparator
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111

module ctrl_unit(
	input logic [31:0] inst_i,
	output logic RegWEn_o,
	output logic [3:0] AluSel_o, // same as AluOp
	output logic Bsel_o,
	output logic [2:0] ImmSel_o,
	output logic MemRW_o,
	output logic [1:0] WBSel_o,
	output logic BrUn_o,
	output logic Asel_o,
	//output logic Mul_ext_o
	/* valid signal when CPU access cache */
	output logic Valid_cpu2cache_o
	);

	logic [6:0] opcode_r;
	logic [2:0] funct3;
	logic [6:0] funct7;
	
	assign opcode_r = inst_i[6:0];
	assign funct3 = inst_i[14:12];
	assign funct7 = inst_i[31:25];
	
	assign RegWEn_o = (opcode_r == `OP_Stype) | // S type & B type
							(opcode_r == `OP_Btype) ? (1'b0) : (1'b1);
	
	// 10 instructions R type
	assign AluSel_o = ((opcode_r == `OP_Btype) | (opcode_r == `OP_JAL) | (opcode_r == `OP_Itype_load) |
							(opcode_r == `OP_Stype) | (opcode_r == `OP_AUIPC) | (opcode_r == `OP_JALR) |
							((opcode_r == `OP_Itype) & (funct3 == 3'b000))) ? `ADD :						// in case addi 
							(opcode_r == `OP_LUI) ? `B : {funct7[5], funct3};
	
	assign Bsel_o = (opcode_r == `OP_Rtype) ? 1'b0 : 1'b1;
	
	assign ImmSel_o = ((opcode_r == `OP_Itype) | (opcode_r == `OP_JALR) | (opcode_r == `OP_Itype_load)) ? `I_TYPE : 
							(opcode_r == `OP_Stype) 																			 ? `S_TYPE : 
							(opcode_r == `OP_Btype)																				 ? `B_TYPE : 
							(opcode_r == `OP_JAL)   																			 ? `J_TYPE : 
							((opcode_r == `OP_LUI) | (opcode_r == `OP_AUIPC))											 ? `U_TYPE : 3'b111;
	
	assign MemRW_o = (opcode_r == `OP_Stype) ? 1'b1 : 1'b0;
	
	assign WBSel_o = (opcode_r == `OP_Itype_load) 							? 2'b00 : 
						  ((opcode_r == `OP_JAL) | (opcode_r == `OP_JALR)) ? 2'b10 : 2'b01;
	
	assign BrUn_o = ((funct3 == `BLTU) | (funct3 == `BGEU)) ? 1'b1 : 1'b0;
	
	
	
	assign Asel_o = ((opcode_r == `OP_Btype) |
						 (opcode_r == `OP_JAL)    | 
						 (opcode_r == `OP_AUIPC)) ? 1'b1 : 1'b0;
						 
	//assign Mul_ext_o = ((opcode_r == `OP_Rtype) & (funct7[0] == 1'b1)) ? 1'b1 : 1'b0;

	/* valid signal when CPU access cache */
	assign Valid_cpu2cache_o = ((opcode_r == `OP_Itype_load) | (opcode_r == `OP_Stype)) ? 1'b1 : 1'b0;
	
endmodule
