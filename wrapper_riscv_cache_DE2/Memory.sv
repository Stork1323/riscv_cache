import cache_def::*;

module Memory(
    input logic clk_i,
    input logic rst_ni,
    input mem_req_type mem_request_i,
	/* input/output */
	//input logic [31:0] io_sw_i,
	//output logic [31:0] io_lcd_o,
	//output logic [31:0] io_ledr_o,
	//output logic [31:0] io_ledg_o,
	//output logic [31:0] io_hex0_o,
	//output logic [31:0] io_hex1_o,
	//output logic [31:0] io_hex2_o,
	//output logic [31:0] io_hex3_o,
	//output logic [31:0] io_hex4_o,
	//output logic [31:0] io_hex5_o,
	//output logic [31:0] io_hex6_o,
	//output logic [31:0] io_hex7_o,
	/* ------------ */
    output mem_data_type mem_result_o,

  input logic SRAM_OE_N,
  inout [15:0] SRAM_DQ,
  output logic [17:0] SRAM_ADDR,
  output logic SRAM_CE_N,
  output logic SRAM_WE_N,
  output logic SRAM_LB_N,
  output logic SRAM_UB_N
);

  mem_req_type mem_request; // memory request to SRAM between CPU and initialize value for SRAM 
  mem_req_type mem_boot;
  /* Booting sequence 
  *     Boot0: Initialize begining value
  *     Boot1: Booting value into SRAM
  *     Boot2: End of booting sequence
  */
  typedef enum logic [1:0] {
    Boot0,
    Boot1,
    Boot2
  } boot_e;

  boot_e boot_d;
  boot_e boot_q;
  logic [8:0] cnt; // count value for initialize SRAM (depth of imem is 512)
  logic cnt_en;

	/* Spec of memory */
	/*
	 4KB instruction and data, the first 2KB for instruction and the second 2KB for data
	 Address:
	 	0 -> 511 : instructions
		512 -> 767 : data memory
		768 -> 831 : output peripherals
		832 -> 895 : input peripherals
		896 -> 1023 : for reserved
	*/
	/* -------------- */

	/* imem */
	(* ram_style = "block" *)
  logic [31:0] imem [512]; //2KB instruction memory
	
	initial begin
		$readmemh("C:/altera/projects/riscv_cache/memfile.txt", imem); 
	end

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      boot_q <= Boot0;
      cnt <= 9'b0;
    end
    else begin
      boot_q <= boot_d;
      cnt <= cnt_en ? cnt+9'b1 : cnt;
    end
  end

  always_comb begin: boot_sequence
    cnt_en = 1'b0;
    boot_d = boot_q;
    mem_boot.data = '0;
    mem_boot.addr = '0;
    mem_boot.rw = 1'b0;
    mem_boot.valid = 1'b0;

    case (boot_q)
      Boot0: begin
        cnt_en = 1'b0;
        boot_d = Boot1;
        mem_boot.data = '0;
        mem_boot.addr = '0;
        mem_boot.rw = 1'b1;
        mem_boot.valid = 1'b1;
      end
      Boot1: begin
        if (mem_result_o.ready && (cnt != 9'd511)) begin
          cnt_en = 1'b1;
          boot_d = Boot1;
          mem_boot.data = imem[cnt];
          mem_boot.addr = {23'b0, cnt[8:1], 1'b0};
          mem_boot.rw = 1'b1;
          mem_boot.valid = 1'b1;
        end
        else if (mem_result_o.ready && (cnt == 9'd511)) begin
          cnt_en = 1'b0;
          boot_d = Boot2;
          mem_boot.data = imem[cnt];
          mem_boot.addr = {23'b0, cnt[8:1], 1'b0};
          mem_boot.rw = 1'b1;
          mem_boot.valid = 1'b1;
        end
      end
      Boot2: begin
        cnt_en = 1'b0;
        boot_d = Boot2;
        mem_boot.data = imem[cnt];
        mem_boot.addr = {23'b0, cnt[8:1], 1'b0};
        mem_boot.rw = 1'b1;
        mem_boot.valid = 1'b1;
      end
    endcase 
  end : boot_sequence

  assign mem_request.data = (boot_q == Boot2) ? mem_request_i.data : mem_boot.data;
  assign mem_request.addr = (boot_q == Boot2) ? mem_request_i.addr : mem_boot.addr;
  assign mem_request.rw = (boot_q == Boot2) ? mem_request_i.rw : mem_boot.rw;
  assign mem_request.valid = (boot_q == Boot2) ? mem_request_i.valid : mem_boot.valid;
	/* ------------- */

	/* dmem */

	//logic [31:0] dmem [1024]; //4KB,  1KB for data memory, 256B for output peripherals, 256B for input peripherals, 2.5KB for reserved
	
	/*
			dmem[0:255] for data memory
			dmem[256:319] for output peripherals
			dmem[320:383] for input peripherals
			dmem[384:1023] for reserved
	*/
	
	//logic input_region;
	//logic output_region;
	//logic data_region;
	//logic [31:0] temp1, temp2, temp3, temp4;
	//
	//set_less_than_unsign SLTU0(
	//	.rs1_i({2'b0, mem_request_i.addr[31:2]}),
	//	.rs2_i(32'd768), // updated for memory (previous value was 256)
	//	.rd_o(temp1)
	//	);
	//set_less_than_unsign SLTU1(
	//	.rs1_i({2'b0, mem_request_i.addr[31:2]}),
	//	.rs2_i(32'd832), // updated for memory (previous value was 320)
	//	.rd_o(temp2)
	//	);
	//set_less_than_unsign SLTU2(
	//	.rs1_i({2'b0, mem_request_i.addr[31:2]}),
	//	.rs2_i(32'd896), // updated for memory (previous value was 384)
	//	.rd_o(temp3)
	//	);
	//set_less_than_unsign SLTU3(
	//	.rs1_i({2'b0, mem_request_i.addr[31:2]}),
	//	.rs2_i(32'd512),
	//	.rd_o(temp4) // compare address for imem
	//	);
	//	
	//assign input_region = (temp2 == 32'b0 & temp3 == 32'b1) ? 1'b1 : 1'b0;
	//
	//always_ff @(posedge clk_i) begin
	//	if (mem_request_i.rw & (~input_region) & (mem_request_i.valid) & (temp4 == 32'b0)) begin
	//		dmem[mem_request_i.addr[31:2]-512]   <= mem_request_i.data[31:0];
	//		dmem[mem_request_i.addr[31:2]+1-512] <= mem_request_i.data[63:32];
	//		dmem[mem_request_i.addr[31:2]+2-512] <= mem_request_i.data[95:64];
	//		dmem[mem_request_i.addr[31:2]+3-512] <= mem_request_i.data[127:96];
	//	end
	//end

	//assign io_hex0_o = dmem[256];
	//assign io_hex1_o = dmem[257];
	//assign io_hex2_o = dmem[258];
	//assign io_hex3_o = dmem[259];
	//assign io_hex4_o = dmem[260];
	//assign io_hex5_o = dmem[261];
	//assign io_hex6_o = dmem[262];
	//assign io_hex7_o = dmem[263];
	//assign io_ledr_o = dmem[264];
	//assign io_ledg_o = dmem[265];
	//assign io_lcd_o  = dmem[266];

	/* --------------- */

	/* valid signal that memory response to cache */
	//assign mem_result_o.ready = (rst_ni == 1'b0) ? 1'b0 : 1'b1;
	//assign mem_result_o.data = (rst_ni == 1'b0) ? 128'b0 : (input_region) ? {{111{1'b0}}, io_sw_i[16:0]} : {mem[mem_request_i.addr[31:2]+3], mem[mem_request_i.addr[31:2]+2], mem[mem_request_i.addr[31:2]+1], mem[mem_request_i.addr[31:2]]};
	//always_comb begin
	//	if (!rst_ni) mem_result_o.data = 128'b0;
	//	else if (input_region) mem_result_o.data = {{111{1'b0}}, io_sw_i[16:0]};
	//	else if (temp4 == 32'b1) mem_result_o.data = {imem[mem_request_i.addr[31:2]+3], imem[mem_request_i.addr[31:2]+2], imem[mem_request_i.addr[31:2]+1], imem[mem_request_i.addr[31:2]]};
	//	else mem_result_o.data = {dmem[mem_request_i.addr[31:2]+3-512], dmem[mem_request_i.addr[31:2]+2-512], dmem[mem_request_i.addr[31:2]+1-512], dmem[mem_request_i.addr[31:2]-512]};
	//end


// imem IMEM_IF(
	// 	.mem_request_i.addr(mem_req_w.addr),
	// 	.rst_ni(rst_ni),
	// 	.inst_o(inst_mem_w),
	// 	.Valid_memory2cache_o(Valid_memory2cache_w)
	// 	);

// lsu LSU_MEM(
	// 	.mem_request_i.addr(mem_req_w.addr),
	// 	.dataW_i(mem_req_w.data),
	// 	.MemRW_i(mem_req_w.rw),
	// 	.clk_i(clk_i),
	// 	.rst_ni(rst_ni),
	// 	.io_sw_i(io_sw_i),
	// 	.mem_req_valid_i(mem_req_w.valid),
	// 	.dataR_o(memory_data_w),
	// 	.io_lcd_o(io_lcd_o),
	// 	.io_ledg_o(io_ledg_o),
	// 	.io_ledr_o(io_ledr_o),
	// 	.io_hex0_o(io_hex0_o),
	// 	.io_hex1_o(io_hex1_o),
	// 	.io_hex2_o(io_hex2_o),
	// 	.io_hex3_o(io_hex3_o),
	// 	.io_hex4_o(io_hex4_o),
	// 	.io_hex5_o(io_hex5_o),
	// 	.io_hex6_o(io_hex6_o),
	// 	.io_hex7_o(io_hex7_o),
	// 	.Valid_memory2cache_o(Valid_memory2cache_w)
	// 	);

logic [15:0] SRAM_DQ_w;

sram_controller_128b u_SRAM_CTRL(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .i_ADDR({1'b0, mem_request.addr[31:1]}),
  .i_WDATA(mem_request.data),
  .i_WREN(mem_request.valid & mem_request.rw),
  .i_RDEN(mem_request.valid & (~mem_request.rw)),
  .o_RDATA(mem_result_o.data),
  .o_ACK(mem_result_o.ready),
  .SRAM_OE_N(SRAM_OE_N),
  .SRAM_DQ(SRAM_DQ),
  .SRAM_ADDR(SRAM_ADDR),
  .SRAM_CE_N(SRAM_CE_N),
  .SRAM_WE_N(SRAM_WE_N),
  .SRAM_LB_N(SRAM_LB_N),
  .SRAM_UB_N(SRAM_UB_N)
);

//assign SRAM_DQ = SRAM_DQ_w;

endmodule
