

module brcomp(
	input logic [31:0] rs1_i, rs2_i,
	input logic BrUn_i,
	output logic BrEq_o,
	output logic BrLt_o
	);
	
	logic [31:0] comp_eq, comp_lt, comp_ltu;
	set_equal SE(.rs1_i(rs1_i), .rs2_i(rs2_i), .rd_o(comp_eq));
	set_less_than SLT(.rs1_i(rs1_i), .rs2_i(rs2_i), .rd_o(comp_lt));
	set_less_than_unsign SLTU(.rs1_i(rs1_i), .rs2_i(rs2_i), .rd_o(comp_ltu));
	
	assign BrEq_o = (comp_eq[0]) ? 1'b1 : 1'b0;
	assign BrLt_o = (~BrUn_i) ? ((comp_lt[0]) ? 1'b1 : 1'b0) : ((comp_ltu[0]) ? 1'b1 : 1'b0);
	
endmodule
