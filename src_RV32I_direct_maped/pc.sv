module pc( // Program Counter
	input logic [31:0] data_i,
	//input logic WE_i, // Write Enable
	input logic clk_i,
	input logic rst_ni,
	input logic enable_i,
	output logic [31:0] data_o
	);
	
	//logic [31:0] mem;
	//logic [31:0] pc;
	
	//mux2to1_32bit MU0(mem, data_i, WE_i, pc);
	
	always_ff @(posedge clk_i) begin
		//if (WE_i) data_o <= data_i;
		if (~rst_ni) data_o <= 32'b0;
		else if (enable_i) data_o <= data_i;
		//mem <= data_o;
	end
	
endmodule
