module subtractor_32bit(
	input logic [31:0] a_i, b_i,
	//input logic c_i,
	output logic [31:0] d_o,
	output logic b_o
	);
	
	logic [32:0] temp;
	assign temp[0] = 1'b0;
	
	full_subtractor S0(.a_i(a_i[0]), .b_i(b_i[0]), .c_i(temp[0]), .d_o(d_o[0]), .b_o(temp[1]));
	full_subtractor S1(.a_i(a_i[1]), .b_i(b_i[1]), .c_i(temp[1]), .d_o(d_o[1]), .b_o(temp[2]));
	full_subtractor S2(.a_i(a_i[2]), .b_i(b_i[2]), .c_i(temp[2]), .d_o(d_o[2]), .b_o(temp[3]));
	full_subtractor S3(.a_i(a_i[3]), .b_i(b_i[3]), .c_i(temp[3]), .d_o(d_o[3]), .b_o(temp[4]));
	full_subtractor S4(.a_i(a_i[4]), .b_i(b_i[4]), .c_i(temp[4]), .d_o(d_o[4]), .b_o(temp[5]));
	full_subtractor S5(.a_i(a_i[5]), .b_i(b_i[5]), .c_i(temp[5]), .d_o(d_o[5]), .b_o(temp[6]));
	full_subtractor S6(.a_i(a_i[6]), .b_i(b_i[6]), .c_i(temp[6]), .d_o(d_o[6]), .b_o(temp[7]));
	full_subtractor S7(.a_i(a_i[7]), .b_i(b_i[7]), .c_i(temp[7]), .d_o(d_o[7]), .b_o(temp[8]));
	full_subtractor S8(.a_i(a_i[8]), .b_i(b_i[8]), .c_i(temp[8]), .d_o(d_o[8]), .b_o(temp[9]));
	full_subtractor S9(.a_i(a_i[9]), .b_i(b_i[9]), .c_i(temp[9]), .d_o(d_o[9]), .b_o(temp[10]));
	full_subtractor S10(.a_i(a_i[10]), .b_i(b_i[10]), .c_i(temp[10]), .d_o(d_o[10]), .b_o(temp[11]));
	full_subtractor S11(.a_i(a_i[11]), .b_i(b_i[11]), .c_i(temp[11]), .d_o(d_o[11]), .b_o(temp[12]));
	full_subtractor S12(.a_i(a_i[12]), .b_i(b_i[12]), .c_i(temp[12]), .d_o(d_o[12]), .b_o(temp[13]));
	full_subtractor S13(.a_i(a_i[13]), .b_i(b_i[13]), .c_i(temp[13]), .d_o(d_o[13]), .b_o(temp[14]));
	full_subtractor S14(.a_i(a_i[14]), .b_i(b_i[14]), .c_i(temp[14]), .d_o(d_o[14]), .b_o(temp[15]));
	full_subtractor S15(.a_i(a_i[15]), .b_i(b_i[15]), .c_i(temp[15]), .d_o(d_o[15]), .b_o(temp[16]));
	full_subtractor S16(.a_i(a_i[16]), .b_i(b_i[16]), .c_i(temp[16]), .d_o(d_o[16]), .b_o(temp[17]));
	full_subtractor S17(.a_i(a_i[17]), .b_i(b_i[17]), .c_i(temp[17]), .d_o(d_o[17]), .b_o(temp[18]));
	full_subtractor S18(.a_i(a_i[18]), .b_i(b_i[18]), .c_i(temp[18]), .d_o(d_o[18]), .b_o(temp[19]));
	full_subtractor S19(.a_i(a_i[19]), .b_i(b_i[19]), .c_i(temp[19]), .d_o(d_o[19]), .b_o(temp[20]));
	full_subtractor S20(.a_i(a_i[20]), .b_i(b_i[20]), .c_i(temp[20]), .d_o(d_o[20]), .b_o(temp[21]));
	full_subtractor S21(.a_i(a_i[21]), .b_i(b_i[21]), .c_i(temp[21]), .d_o(d_o[21]), .b_o(temp[22]));
	full_subtractor S22(.a_i(a_i[22]), .b_i(b_i[22]), .c_i(temp[22]), .d_o(d_o[22]), .b_o(temp[23]));
	full_subtractor S23(.a_i(a_i[23]), .b_i(b_i[23]), .c_i(temp[23]), .d_o(d_o[23]), .b_o(temp[24]));
	full_subtractor S24(.a_i(a_i[24]), .b_i(b_i[24]), .c_i(temp[24]), .d_o(d_o[24]), .b_o(temp[25]));
	full_subtractor S25(.a_i(a_i[25]), .b_i(b_i[25]), .c_i(temp[25]), .d_o(d_o[25]), .b_o(temp[26]));
	full_subtractor S26(.a_i(a_i[26]), .b_i(b_i[26]), .c_i(temp[26]), .d_o(d_o[26]), .b_o(temp[27]));
	full_subtractor S27(.a_i(a_i[27]), .b_i(b_i[27]), .c_i(temp[27]), .d_o(d_o[27]), .b_o(temp[28]));
	full_subtractor S28(.a_i(a_i[28]), .b_i(b_i[28]), .c_i(temp[28]), .d_o(d_o[28]), .b_o(temp[29]));
	full_subtractor S29(.a_i(a_i[29]), .b_i(b_i[29]), .c_i(temp[29]), .d_o(d_o[29]), .b_o(temp[30]));
	full_subtractor S30(.a_i(a_i[30]), .b_i(b_i[30]), .c_i(temp[30]), .d_o(d_o[30]), .b_o(temp[31]));
	full_subtractor S31(.a_i(a_i[31]), .b_i(b_i[31]), .c_i(temp[31]), .d_o(d_o[31]), .b_o(temp[32]));
	
	assign b_o = temp[32];
	
endmodule
