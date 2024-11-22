`timescale 1ns / 1ps
module or_32bit_tb;
	logic [31:0] a_i, b_i;
	logic [31:0] c_o;
	logic [31:0] o_x;
	logic ok;
  or_32bit A0(.*);

  task tk_expect(input logic [31:0] o_x );

    $display("[%3d] a_i = %10d, b_i = %10d, o_x = %10d", $time, a_i, b_i, c_o, o_x );
    $display("[%3d] a_i = %10d, b_i = %10d, o_x = %10d", $time, a_i, b_i, c_o, o_x );
    
    assert( (o_x == c_o)) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  initial begin
    repeat(100) begin
		a_i = $random; 
      b_i = $random;
		o_x = a_i | b_i;
      #1 tk_expect(o_x);
      #49;
    end
    $display("TEST PASSED");
    $finish;
  end
endmodule
