module sram_controller_128b(
  input logic clk_i,
  input logic rst_ni,

  input logic [31:0] i_ADDR,
  input logic [127:0] i_WDATA,
  input logic i_WREN,
  input logic i_RDEN,
  output logic [127:0] o_RDATA,
  output logic o_ACK,

  input logic SRAM_OE_N,
  inout [15:0] SRAM_DQ,
  output logic [17:0] SRAM_ADDR,
  output logic SRAM_CE_N,
  output logic SRAM_WE_N,
  output logic SRAM_LB_N,
  output logic SRAM_UB_N
);

typedef enum logic [4:0] {
  StIdle,
  StWrite0,
  StWrite1,
  StWrite2,
  StWrite3,
  StWrite4,
  StWrite5,
  StWrite6,
  StWriteAck,
  StRead0,
  StRead1,
  StRead2,
  StRead3,
  StRead4,
  StRead5,
  StRead6,
  StReadAck
} sram_state_e;

sram_state_e sram_state_d;
sram_state_e sram_state_q;

logic [127:0] wdata_d;
logic [127:0] wdata_q;
logic [127:0] rdata_d;
logic [127:0] rdata_q;
logic [31:0] addr_d;
logic [31:0] addr_q;

always_comb begin : proc_detect_state
  case (sram_state_q)
    StIdle, StWriteAck, StReadAck: begin
      if (i_WREN ~^ i_RDEN) begin
        sram_state_d = StIdle;
        addr_d = addr_q;
        wdata_d = wdata_q;
        rdata_d = rdata_q;
      end
      else begin
        sram_state_d = i_WREN ? StWrite0 : StRead0;
        addr_d = i_ADDR;
        wdata_d = i_WDATA;
        rdata_d = {rdata_q[127:16], SRAM_DQ}; end
    end
    StRead0: begin
      sram_state_d = StRead1;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {rdata_q[127:32], SRAM_DQ, rdata_q[15:0]};
    end
    StRead1: begin
      sram_state_d = StRead2;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {rdata_q[127:48], SRAM_DQ, rdata_q[31:0]};
    end
    StRead2: begin
      sram_state_d = StRead3;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {rdata_q[127:64], SRAM_DQ, rdata_q[47:0]};
    end
    StRead3: begin
      sram_state_d = StRead4;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {rdata_q[127:80], SRAM_DQ, rdata_q[63:0]};
    end
    StRead4: begin
      sram_state_d = StRead5;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {rdata_q[127:96], SRAM_DQ, rdata_q[79:0]};
    end
    StRead5: begin
      sram_state_d = StRead6;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {rdata_q[127:112], SRAM_DQ, rdata_q[95:0]};
    end
    StRead6: begin
      sram_state_d = StReadAck;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = {SRAM_DQ, rdata_q[111:0]};
    end
    StWrite0: begin
      sram_state_d = StWrite1;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    StWrite1: begin
      sram_state_d = StWrite2;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    StWrite2: begin
      sram_state_d = StWrite3;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    StWrite3: begin
      sram_state_d = StWrite4;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    StWrite4: begin
      sram_state_d = StWrite5;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    StWrite5: begin
      sram_state_d = StWrite6;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    StWrite6: begin
      sram_state_d = StWriteAck;
      addr_d = i_ADDR;
      wdata_d = i_WDATA;
      rdata_d = rdata_q;
    end
    default: begin
      sram_state_d = StIdle;
      addr_d = 32'b0;
      wdata_d = 128'b0;
      rdata_d = 128'b0;
    end
  endcase
end : proc_detect_state
  
always_ff @(posedge clk_i, negedge rst_ni) begin
  if (!rst_ni) begin
    sram_state_q <= StIdle;
    addr_q <= 32'b0;
    wdata_q <= 128'b0;
    rdata_q <= 128'b0;
  end
  else begin
    sram_state_q <= sram_state_d;
    addr_q <= addr_d;
    wdata_q <= wdata_d;
    rdata_q <= rdata_d;
  end
end

always_comb begin: proc_output
  SRAM_ADDR = 18'b0;
  SRAM_DQ = 'z;
  SRAM_CE_N = 1'b1;
  SRAM_WE_N = 1'b1;
  SRAM_LB_N = 1'b0;
  SRAM_UB_N = 1'b0;
  
  if (sram_state_q == StWrite0) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0];
    SRAM_DQ = wdata_q[15:0];
  end
  if (sram_state_q == StWrite1) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd1;
    SRAM_DQ = wdata_q[31:16];
  end
  if (sram_state_q == StWrite2) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd2;
    SRAM_DQ = wdata_q[47:32];
  end
  if (sram_state_q == StWrite3) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd3;
    SRAM_DQ = wdata_q[63:48];
  end
  if (sram_state_q == StWrite4) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd4;
    SRAM_DQ = wdata_q[79:64];
  end
  if (sram_state_q == StWrite5) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd5;
    SRAM_DQ = wdata_q[95:80];
  end
  if (sram_state_q == StWrite6) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd6;
    SRAM_DQ = wdata_q[111:96];
  end
  if (sram_state_q == StWriteAck) begin
    SRAM_CE_N = 1'b0;
    SRAM_WE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd7;
    SRAM_DQ = wdata_q[127:112];
  end
  if (sram_state_q == StRead0) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0];
  end
  if (sram_state_q == StRead1) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd1;
  end
  if (sram_state_q == StRead2) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd2;
  end
  if (sram_state_q == StRead3) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd3;
  end
  if (sram_state_q == StRead4) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd4;
  end
  if (sram_state_q == StRead5) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd5;
  end
  if (sram_state_q == StRead6) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd6;
  end
  if (sram_state_q == StReadAck) begin
    SRAM_CE_N = 1'b0;
    SRAM_ADDR = addr_q[17:0]+18'd7;
  end
end : proc_output
 
assign o_RDATA = rdata_q;
assign o_ACK = (sram_state_q == StReadAck) || (sram_state_q == StWriteAck);

endmodule
