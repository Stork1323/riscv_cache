`timescale 1ns / 1ps
module shift_right_logical_tb;
	logic [31:0] rs1_i, rs2_i;
	logic [31:0] rd_o;
	logic [31:0] m_x;
  shift_right_logical A0(.*);

  task tk_expect(input logic [31:0] m_x );

    $display("[%3d] rs1_i = %10d, rs2_i = %10d,  rd_o = %10d ,m_x = %10d", $time, rs1_i, rs2_i, rd_o, m_x );
    $display("[%3d] rs1_i = %10d, rs2_i = %10d,  rd_o = %10d, m_x = %10d", $time, rs1_i, rs2_i, rd_o, m_x );
    
    assert( (m_x == rd_o)) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  initial begin
    repeat(100) begin
		rs1_i= $random;
      rs2_i= $random % 32;
		m_x = rs1_i >> rs2_i;
      #1 tk_expect(m_x);
      #49;
    end
    $display("TEST PASSED");
    $finish;
  end
endmodule
