`timescale 10ns / 10ps

module brcomp_tb();

`define clk 1

	logic [31:0] rs1_i, rs2_i;
	logic BrUn_i;
	logic BrEq_o;
	logic BrLt_o;
	
	logic BrEq_ex;
	logic BrLt_ex;
	
	brcomp BRC(
		.*
	);
	
	task check(input logic BrEq_ex, BrLt_ex);
		$display("[%3d], rs1_i = %5d, rs2_i = %5d, BrEq_o = %1b, BrLt_o = %1b, BrEq_ex = %1b, BrLt_ex = %1b,"
		,$time, data_i, data_o, data_ex);
		assert(BrEq_ex == BrEq_o & BrLt_ex == BrLt_o)
		else begin
			$display("Test failed");
			$stop;
		end
	endtask
	
	initial begin
//		rst_ni = 1'b0;
//		#3;
//		
//		rst_ni = 1'b1;
//		#1;
	
		repeat(100) begin
		
			BrUn_i = 0;
			rs1_i = $random();
			rs2_i = $random();
			BrEq_ex = (rs1_i == rs2_i) ? 1'b1 : 1'b0;
			BrLt_ex = (rs1_i < rs2_i) ? 1'b1 : 1'b0;
			check(BrEq_ex, BrLt_ex);
			#3;
		end
		
		repeat(100) begin
		
			BrUn_i = 1;
			rs1_i = $urandom();
			rs2_i = $urandom();
			BrEq_ex = (rs1_i == rs2_i) ? 1'b1 : 1'b0;
			BrLt_ex = (rs1_i < rs2_i) ? 1'b1 : 1'b0;
			check(BrEq_ex, BrLt_ex);
			#3;
		end
		
		
		$display("Test passed");
		#5 $finish;
	end
	
	
	//always #(`clk) clk_i = ~clk_i;

endmodule