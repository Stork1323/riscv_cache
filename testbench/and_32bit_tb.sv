`timescale 1ns / 1ps
module and_32bit_tb;

  logic [31:0] a_i;
  logic [31:0] b_i;
  logic [31:0] c_o;
  logic [31:0] m_x;

  and_32bit A0(.*);

  task tk_expect(
    input logic [31:0] s_x
  );

    $display("[%3d] a_i = %10d, b_i = %10d,  c_o = %10d ,m_x = %10d", $time, a_i, b_i, c_o, m_x );
    $display("[%3d] a_i = %10d, b_i = %10d,  c_o = %10d, m_x = %10d", $time, a_i, b_i, c_o, m_x );
    
    assert( (m_x == c_o)) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  initial begin
    repeat(100) begin
		a_i = $random;
      b_i= $random;
		m_x = a_i & b_i;
      #1 tk_expect(m_x);
      #49;
    end
    $display("TEST PASSED");
    $finish;
  end
endmodule
