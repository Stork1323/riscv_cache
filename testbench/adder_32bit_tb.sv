`timescale 1ns / 1ps
module adder_32bit_tb;

  logic [31:0] a_i;
  logic [31:0] b_i;
  logic [31:0] re_o;
  logic [32:0] s_x;
  logic  c_o;

  adder_32bit A0(.*);

  task tk_expect(
    input logic [32:0] s_x
  );

    $display("[%3d] a_i = %10d, b_i = %10d, s_o = %10d, c_o = %1b ,s_x = %10d", $time, a_i, b_i, re_o, c_o, s_x[32], s_x[31:0]);
    $display("[%3d] a_i = %10d, b_i = %10d,  s_o = %10d, c_o = %1b, s_x = %10d", $time, a_i, b_i, re_o, c_o, s_x[32], s_x[31:0]);
    
    assert((c_o == s_x[32]) && (re_o == s_x[31:0])) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  initial begin
    repeat(100) begin
		a_i = $random;
      b_i= $random;
      #1 tk_expect(a_i + b_i);
      #49;
    end
    $display("TEST PASSED");
    $finish;
  end
endmodule
