// Immediate generation type 
`define I_TYPE 3'b000
`define S_TYPE 3'b001
`define B_TYPE 3'b010
`define J_TYPE 3'b011
`define U_TYPE 3'b100

module imm_gen(
	input logic [31:7] inst_i,
	input logic [2:0] ImmSel_i,
	output logic [31:0] imm_o
	);
		
	assign imm_o = (ImmSel_i == `I_TYPE) ? {{21{inst_i[31]}}, inst_i[30:20]} :
						(ImmSel_i == `S_TYPE) ? {{21{inst_i[31]}}, inst_i[30:25], inst_i[11:7]} : 
						(ImmSel_i == `B_TYPE) ? {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0} : 
						(ImmSel_i == `J_TYPE) ? {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0} : 
						(ImmSel_i == `U_TYPE) ? {inst_i[31:12], {12{1'b0}}} : {32{1'b0}};
	
endmodule

