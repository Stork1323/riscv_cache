module pc( // Program Counter
	input logic [31:0] data_i,
	//input logic WE_i, // Write Enable
	input logic clk_i,
	input logic rst_ni,
	input logic enable_i,
	output logic [31:0] data_o,
	output logic [31:0] No_command_o
	);
	
	//logic [31:0] mem;
	//logic [31:0] pc;
	
	//mux2to1_32bit MU0(mem, data_i, WE_i, pc);
	logic [31:0] No_command_r, No_command_d;

	adder_32bit Incr_command (
            .a_i(No_command_r),
            .b_i({32'b1}),
            .c_o(),
            .re_o(No_command_d)
    );
	
	always_ff @(posedge clk_i) begin
		//if (WE_i) data_o <= data_i;
		if (~rst_ni) begin 
			data_o <= 32'b0;
			No_command_r <= 32'b0;
		end
		else if (enable_i) begin
			data_o <= data_i;
			No_command_r <= No_command_d;
		end
		//mem <= data_o;
	end

	assign No_command_o = No_command_r;
	
endmodule
