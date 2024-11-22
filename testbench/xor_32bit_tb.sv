`timescale 1ns / 1ps
module xor_32bit_tb;

  logic [31:0] a_i;
  logic [31:0] b_i;
  logic [31:0] c_o;
  logic [31:0] xo_x;

  xor_32bit A0(.*);

  task tk_expect(input logic [31:0] xo_x );

    $display("[%3d] a_i = %10d, b_i = %10d,  c_o = %10d ,xo_x = %10d", $time, a_i, b_i, c_o, xo_x );
    $display("[%3d] a_i = %10d, b_i = %10d,  c_o = %10d, xo_x = %10d", $time, a_i, b_i, c_o, xo_x );
    
    assert( (xo_x == c_o)) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  initial begin
    repeat(100) begin
		a_i = $random;
      b_i= $random;
		xo_x = a_i ^ b_i;
      #1 tk_expect(xo_x);
      #49;
    end
    $display("TEST PASSED");
    $finish;
  end
endmodule
