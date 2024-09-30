module imem( // A read-only memory for fetching instructions
	input logic [31:0] addr_i,
	input logic rst_ni,
	output logic [127:0] inst_o,
	output logic Valid_memory2cache_o
	);
	
	logic [31:0] mem [2048]; //8KB
	
	assign inst_o = (rst_ni == 1'b0) ? 32'b0 : {mem[addr_i[31:2]+3], mem[addr_i[31:2]+2], mem[addr_i[31:2]+1], mem[addr_i[31:2]]};
	
	/* valid signal that memory response to cache */
	assign Valid_memory2cache_o = (rst_ni == 1'b0) ? 1'b0 : 1'b1;

	initial begin
		// ADDI x15, x0, 50    imm=000000110010, rs1=00000, funt3=000, rd=01111, opcode=0010011
		$readmemh("C:/altera/projects/riscv_cache/memfile.txt", mem); 
	end
	
endmodule

	