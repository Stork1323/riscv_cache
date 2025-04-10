module set_less_than(
	input logic [31:0] rs1_i, rs2_i,
	output logic [31:0] rd_o
	);
	
	logic overf;
	//logic overf_v; // overflow of the result from subtractor
	//logic ans_v; // answer of operation
	logic [31:0] dif_r;
	subtractor_32bit SUB0(rs1_i, rs2_i, dif_r, overf);
	
	assign rd_o = ({rs1_i[31], rs2_i[31]} == 2'b10) ? {{31{1'b0}}, 1'b1} :
					  ({rs1_i[31], rs2_i[31]} == 2'b01) ? {32{1'b0}} : {{31{1'b0}}, dif_r[31]};
					  
	
	
endmodule
