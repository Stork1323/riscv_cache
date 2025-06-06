module lsu( // A memory for loading(read) or storing(write) data words
	input logic [31:0] addr_i,
	input logic [127:0] dataW_i,
	input logic MemRW_i,
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] io_sw_i,
	/* valid signal memory request */
	input logic mem_req_valid_i,
	output logic [127:0] dataR_o,
	output logic [31:0] io_lcd_o,
	output logic [31:0] io_ledr_o,
	output logic [31:0] io_ledg_o,
	output logic [31:0] io_hex0_o,
	output logic [31:0] io_hex1_o,
	output logic [31:0] io_hex2_o,
	output logic [31:0] io_hex3_o,
	output logic [31:0] io_hex4_o,
	output logic [31:0] io_hex5_o,
	output logic [31:0] io_hex6_o,
	output logic [31:0] io_hex7_o,
	/* valid signal that memory response to cache */
	output logic Valid_memory2cache_o
	);
	
	logic [31:0] mem [1024]; //4KB,  1KB for data memory, 256B for output peripherals, 256B for input peripherals, 2.5KB for reserved
	
	/*
			mem[0:255] for data memory
			mem[256:319] for output peripherals
			mem[320:383] for input peripherals
			mem[384:1023] for reserved
	*/
	
	logic input_region;
	logic output_region;
	logic data_region;
	logic [31:0] temp1, temp2, temp3;
	
	set_less_than_unsign SLTU0(
		.rs1_i({2'b0, addr_i[31:2]}),
		.rs2_i(32'd768),
		.rd_o(temp1)
		);
	set_less_than_unsign SLTU1(
		.rs1_i({2'b0, addr_i[31:2]}),
		.rs2_i(32'd832),
		.rd_o(temp2)
		);
	set_less_than_unsign SLTU2(
		.rs1_i({2'b0, addr_i[31:2]}),
		.rs2_i(32'd896),
		.rd_o(temp3)
		);
		
	assign input_region = (temp2 == 32'b0 & temp3 == 32'b1) ? 1'b1 : 1'b0;
	//assign output_region = (temp1 == 32'b0 & temp2 == 32'b1) ? 1'b1 : 1'b0;
	//assign data_region = (temp1 == 32'b1) ? 1'b1 : 1'b0;
	
	//assign mem[320] = io_sw_i; 
	
	always_ff @(posedge clk_i) begin
		if (MemRW_i & (~input_region) & (mem_req_valid_i)) begin
			mem[addr_i[31:2]-512] <= dataW_i[31:0];
			mem[addr_i[31:2]-512+1] <= dataW_i[63:32];
			mem[addr_i[31:2]-512+2] <= dataW_i[95:64];
			mem[addr_i[31:2]-512+3] <= dataW_i[127:96];
		end
	end

	/* valid signal that memory response to cache */
	assign Valid_memory2cache_o = (rst_ni == 1'b0) ? 1'b0 : 1'b1;
	/* fixing */
	//assign dataR_o = (rst_ni == 1'b0 | mem_req_valid_i == 1'b0) ? 32'b0 : (input_region) ? {{15{1'b0}}, io_sw_i[16:0]} : mem[addr_i];
	assign dataR_o = (rst_ni == 1'b0) ? 128'b0 : (input_region) ? {{111{1'b0}}, io_sw_i[16:0]} : {mem[addr_i[31:2]-512+3], mem[addr_i[31:2]-512+2], mem[addr_i[31:2]-512+1], mem[addr_i[31:2]-512]};
	assign io_hex0_o = mem[256];
	assign io_hex1_o = mem[257];
	assign io_hex2_o = mem[258];
	assign io_hex3_o = mem[259];
	assign io_hex4_o = mem[260];
	assign io_hex5_o = mem[261];
	assign io_hex6_o = mem[262];
	assign io_hex7_o = mem[263];
	assign io_ledr_o = mem[264];
	assign io_ledg_o = mem[265];
	assign io_lcd_o = mem[266];
	
	
endmodule
