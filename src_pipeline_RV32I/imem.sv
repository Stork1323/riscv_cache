module imem( // A read-only memory for fetching instructions
	input logic [31:0] addr_i,
	input logic rst_ni,
	output logic [31:0] inst_o
	);
	
	logic [31:0] mem [2048]; //8KB
	
	assign inst_o = (rst_ni == 1'b0) ? 32'b0 : mem[addr_i[31:2]];
	

	initial begin
		// ADDI x15, x0, 50    imm=000000110010, rs1=00000, funt3=000, rd=01111, opcode=0010011
		$readmemh("C:/altera/projects/Pipeline_RV32I/memfile.txt", mem); 
	end

	
	initial begin
		//mem[0] = 32'h0000_0000;
//		mem[0] = 32'h00D00793;
//		mem[1] = 32'h0387C713;
//		mem[2] = 32'h00E7E713;
//		mem[3] = 32'h0597F713;
//		mem[4] = 32'h00579713;
//		mem[5] = 32'h0077D713;
//		mem[6] = 32'h4097D713;
//		mem[7] = 32'hFF87A713;
//		mem[8] = 32'h0527B713;
		//mem[9] = 32'h00F726B3;
		//mem[10] = 32'h00F736B3;
	end
	
endmodule

	