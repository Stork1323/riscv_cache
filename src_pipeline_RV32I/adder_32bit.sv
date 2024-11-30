module adder_32bit(
	input logic [31:0] a_i, b_i,
	//input logic c_i,
	output logic [31:0] re_o,
	output logic c_o
	);
	
	logic [32:0] temp;
	assign temp[0] = 1'b0;
	
	full_adder A0(.a_i(a_i[0]), .b_i(b_i[0]), .c_i(temp[0]), .s_o(re_o[0]), .c_o(temp[1]));
	full_adder A1(.a_i(a_i[1]), .b_i(b_i[1]), .c_i(temp[1]), .s_o(re_o[1]), .c_o(temp[2]));
	full_adder A2(.a_i(a_i[2]), .b_i(b_i[2]), .c_i(temp[2]), .s_o(re_o[2]), .c_o(temp[3]));
	full_adder A3(.a_i(a_i[3]), .b_i(b_i[3]), .c_i(temp[3]), .s_o(re_o[3]), .c_o(temp[4]));
	full_adder A4(.a_i(a_i[4]), .b_i(b_i[4]), .c_i(temp[4]), .s_o(re_o[4]), .c_o(temp[5]));
	full_adder A5(.a_i(a_i[5]), .b_i(b_i[5]), .c_i(temp[5]), .s_o(re_o[5]), .c_o(temp[6]));
	full_adder A6(.a_i(a_i[6]), .b_i(b_i[6]), .c_i(temp[6]), .s_o(re_o[6]), .c_o(temp[7]));
	full_adder A7(.a_i(a_i[7]), .b_i(b_i[7]), .c_i(temp[7]), .s_o(re_o[7]), .c_o(temp[8]));
	full_adder A8(.a_i(a_i[8]), .b_i(b_i[8]), .c_i(temp[8]), .s_o(re_o[8]), .c_o(temp[9]));
	full_adder A9(.a_i(a_i[9]), .b_i(b_i[9]), .c_i(temp[9]), .s_o(re_o[9]), .c_o(temp[10]));
	full_adder A10(.a_i(a_i[10]), .b_i(b_i[10]), .c_i(temp[10]), .s_o(re_o[10]), .c_o(temp[11]));
	full_adder A11(.a_i(a_i[11]), .b_i(b_i[11]), .c_i(temp[11]), .s_o(re_o[11]), .c_o(temp[12]));
	full_adder A12(.a_i(a_i[12]), .b_i(b_i[12]), .c_i(temp[12]), .s_o(re_o[12]), .c_o(temp[13]));
	full_adder A13(.a_i(a_i[13]), .b_i(b_i[13]), .c_i(temp[13]), .s_o(re_o[13]), .c_o(temp[14]));
	full_adder A14(.a_i(a_i[14]), .b_i(b_i[14]), .c_i(temp[14]), .s_o(re_o[14]), .c_o(temp[15]));
	full_adder A15(.a_i(a_i[15]), .b_i(b_i[15]), .c_i(temp[15]), .s_o(re_o[15]), .c_o(temp[16]));
	full_adder A16(.a_i(a_i[16]), .b_i(b_i[16]), .c_i(temp[16]), .s_o(re_o[16]), .c_o(temp[17]));
	full_adder A17(.a_i(a_i[17]), .b_i(b_i[17]), .c_i(temp[17]), .s_o(re_o[17]), .c_o(temp[18]));
	full_adder A18(.a_i(a_i[18]), .b_i(b_i[18]), .c_i(temp[18]), .s_o(re_o[18]), .c_o(temp[19]));
	full_adder A19(.a_i(a_i[19]), .b_i(b_i[19]), .c_i(temp[19]), .s_o(re_o[19]), .c_o(temp[20]));
	full_adder A20(.a_i(a_i[20]), .b_i(b_i[20]), .c_i(temp[20]), .s_o(re_o[20]), .c_o(temp[21]));
	full_adder A21(.a_i(a_i[21]), .b_i(b_i[21]), .c_i(temp[21]), .s_o(re_o[21]), .c_o(temp[22]));
	full_adder A22(.a_i(a_i[22]), .b_i(b_i[22]), .c_i(temp[22]), .s_o(re_o[22]), .c_o(temp[23]));
	full_adder A23(.a_i(a_i[23]), .b_i(b_i[23]), .c_i(temp[23]), .s_o(re_o[23]), .c_o(temp[24]));
	full_adder A24(.a_i(a_i[24]), .b_i(b_i[24]), .c_i(temp[24]), .s_o(re_o[24]), .c_o(temp[25]));
	full_adder A25(.a_i(a_i[25]), .b_i(b_i[25]), .c_i(temp[25]), .s_o(re_o[25]), .c_o(temp[26]));
	full_adder A26(.a_i(a_i[26]), .b_i(b_i[26]), .c_i(temp[26]), .s_o(re_o[26]), .c_o(temp[27]));
	full_adder A27(.a_i(a_i[27]), .b_i(b_i[27]), .c_i(temp[27]), .s_o(re_o[27]), .c_o(temp[28]));
	full_adder A28(.a_i(a_i[28]), .b_i(b_i[28]), .c_i(temp[28]), .s_o(re_o[28]), .c_o(temp[29]));
	full_adder A29(.a_i(a_i[29]), .b_i(b_i[29]), .c_i(temp[29]), .s_o(re_o[29]), .c_o(temp[30]));
	full_adder A30(.a_i(a_i[30]), .b_i(b_i[30]), .c_i(temp[30]), .s_o(re_o[30]), .c_o(temp[31]));
	full_adder A31(.a_i(a_i[31]), .b_i(b_i[31]), .c_i(temp[31]), .s_o(re_o[31]), .c_o(temp[32]));
	
	assign c_o = temp[32];
	
endmodule