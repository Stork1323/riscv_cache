module set_less_than_unsign(
	input logic [31:0] rs1_i, rs2_i,
	output logic [31:0] rd_o
	);
		
	logic [31:0] dif;
	logic overf;
	
	subtractor_32bit S0(rs1_i, rs2_i, dif, overf);
	assign rd_o = {{31{1'b0}}, overf};
	
endmodule
