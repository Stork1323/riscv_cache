`timescale 1ns / 1ps
module mux3to1_32bit_tb;

  logic [31:0] a_i;
  logic [31:0] b_i;
  logic [31:0] c_i;
  logic [1:0] se_i;
  logic [31:0] m_x;
  logic [31:0] r_o;

  mux3to1_32bit A0(.*);

  task tk_expect(input logic [31:0] m_x );

    $display("[%3d] a_i = %10d, b_i = %10d, c_i = %10d,  se_i = %10d ,m_x = %10d", $time, a_i, b_i, c_i, se_i, m_x );
    $display("[%3d] a_i = %10d, b_i = %10d, c_i = %10d,  se_i = %10d, m_x = %10d", $time, a_i, b_i, c_i, se_i, m_x );
    
    assert( (m_x == c_o)) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  initial begin
  repeat (100)
	begin
		a_i = $random;
      b_i= $random;
		c_i=$random;
		se_i=$random % 3;
		
		if (se_i == 2'b00) begin
		m_x = a_i;
		end
		else if (se_i == 2'b01) begin
		m_x = b_i;
		end
		else  begin
		m_x = c_i;
		end
      #1 tk_expect(m_x);
      #49;
    
  end
	$display("TEST PASSED");
    $finish;
 end 
endmodule
