module regfile( // Register file
	input logic [31:0] dataW_i,
	input logic [4:0] rsW_i, rs1_i, rs2_i,
	input RegWEn_i,
	input logic clk_i,
	input logic rst_ni,
	output logic [31:0] data1_o, data2_o
	);
	
	logic [31:0] reg_r0_q;
	logic [31:0] reg_r1_q;
   logic [31:0] reg_r2_q;
   logic [31:0] reg_r3_q;
   logic [31:0] reg_r4_q;
   logic [31:0] reg_r5_q;
   logic [31:0] reg_r6_q;
   logic [31:0] reg_r7_q;
   logic [31:0] reg_r8_q;
   logic [31:0] reg_r9_q;
   logic [31:0] reg_r10_q;
   logic [31:0] reg_r11_q;
   logic [31:0] reg_r12_q;
   logic [31:0] reg_r13_q;
   logic [31:0] reg_r14_q;
   logic [31:0] reg_r15_q;
   logic [31:0] reg_r16_q;
   logic [31:0] reg_r17_q;
   logic [31:0] reg_r18_q;
   logic [31:0] reg_r19_q;
   logic [31:0] reg_r20_q;
   logic [31:0] reg_r21_q;
   logic [31:0] reg_r22_q;
   logic [31:0] reg_r23_q;
   logic [31:0] reg_r24_q;
   logic [31:0] reg_r25_q;
   logic [31:0] reg_r26_q;
   logic [31:0] reg_r27_q;
   logic [31:0] reg_r28_q;
   logic [31:0] reg_r29_q;
   logic [31:0] reg_r30_q;
   logic [31:0] reg_r31_q;
	
	logic [31:0] reg1_r;
	logic [31:0] reg2_r;
	
	assign reg_r0_q = 32'b0;
	
	always_ff @(negedge clk_i) begin : Synchronous_register_write_back
		if (~rst_ni) begin
        reg_r1_q       <= 32'h00000000;
        reg_r2_q       <= 32'h00000000;
        reg_r3_q       <= 32'h00000000;
        reg_r4_q       <= 32'h00000000;
        reg_r5_q       <= 32'h00000000;
        reg_r6_q       <= 32'h00000000;
        reg_r7_q       <= 32'h00000000;
        reg_r8_q       <= 32'h00000000;
        reg_r9_q       <= 32'h00000000;
        reg_r10_q      <= 32'h00000000;
        reg_r11_q      <= 32'h00000000;
        reg_r12_q      <= 32'h00000000;
        reg_r13_q      <= 32'h00000000;
        reg_r14_q      <= 32'h00000000;
        reg_r15_q      <= 32'h00000000;
        reg_r16_q      <= 32'h00000000;
        reg_r17_q      <= 32'h00000000;
        reg_r18_q      <= 32'h00000000;
        reg_r19_q      <= 32'h00000000;
        reg_r20_q      <= 32'h00000000;
        reg_r21_q      <= 32'h00000000;
        reg_r22_q      <= 32'h00000000;
        reg_r23_q      <= 32'h00000000;
        reg_r24_q      <= 32'h00000000;
        reg_r25_q      <= 32'h00000000;
        reg_r26_q      <= 32'h00000000;
        reg_r27_q      <= 32'h00000000;
        reg_r28_q      <= 32'h00000000;
        reg_r29_q      <= 32'h00000000;
        reg_r30_q      <= 32'h00000000;
        reg_r31_q      <= 32'h00000000;
		end
		else if (RegWEn_i) begin
			if (rsW_i == 5'd1) reg_r1_q <= dataW_i;
         if (rsW_i == 5'd2) reg_r2_q <= dataW_i;
         if (rsW_i == 5'd3) reg_r3_q <= dataW_i;
         if (rsW_i == 5'd4) reg_r4_q <= dataW_i;
         if (rsW_i == 5'd5) reg_r5_q <= dataW_i;
         if (rsW_i == 5'd6) reg_r6_q <= dataW_i;
         if (rsW_i == 5'd7) reg_r7_q <= dataW_i;
         if (rsW_i == 5'd8) reg_r8_q <= dataW_i;
         if (rsW_i == 5'd9) reg_r9_q <= dataW_i;
         if (rsW_i == 5'd10) reg_r10_q <= dataW_i;
         if (rsW_i == 5'd11) reg_r11_q <= dataW_i;
         if (rsW_i == 5'd12) reg_r12_q <= dataW_i;
         if (rsW_i == 5'd13) reg_r13_q <= dataW_i;
         if (rsW_i == 5'd14) reg_r14_q <= dataW_i;
         if (rsW_i == 5'd15) reg_r15_q <= dataW_i;
         if (rsW_i == 5'd16) reg_r16_q <= dataW_i;
         if (rsW_i == 5'd17) reg_r17_q <= dataW_i;
         if (rsW_i == 5'd18) reg_r18_q <= dataW_i;
         if (rsW_i == 5'd19) reg_r19_q <= dataW_i;
         if (rsW_i == 5'd20) reg_r20_q <= dataW_i;
         if (rsW_i == 5'd21) reg_r21_q <= dataW_i;
         if (rsW_i == 5'd22) reg_r22_q <= dataW_i;
         if (rsW_i == 5'd23) reg_r23_q <= dataW_i;
         if (rsW_i == 5'd24) reg_r24_q <= dataW_i;
         if (rsW_i == 5'd25) reg_r25_q <= dataW_i;
         if (rsW_i == 5'd26) reg_r26_q <= dataW_i;
         if (rsW_i == 5'd27) reg_r27_q <= dataW_i;
         if (rsW_i == 5'd28) reg_r28_q <= dataW_i;
         if (rsW_i == 5'd29) reg_r29_q <= dataW_i;
         if (rsW_i == 5'd30) reg_r30_q <= dataW_i;
         if (rsW_i == 5'd31) reg_r31_q <= dataW_i;
		end
	end : Synchronous_register_write_back
	
	always_comb begin : Asynchronous_read
		case (rs1_i)
		  5'd0: reg1_r = reg_r0_q;
        5'd1: reg1_r = reg_r1_q;
        5'd2: reg1_r = reg_r2_q;
        5'd3: reg1_r = reg_r3_q;
        5'd4: reg1_r = reg_r4_q;
        5'd5: reg1_r = reg_r5_q;
        5'd6: reg1_r = reg_r6_q;
        5'd7: reg1_r = reg_r7_q;
        5'd8: reg1_r = reg_r8_q;
        5'd9: reg1_r = reg_r9_q;
        5'd10: reg1_r = reg_r10_q;
        5'd11: reg1_r = reg_r11_q;
        5'd12: reg1_r = reg_r12_q;
        5'd13: reg1_r = reg_r13_q;
        5'd14: reg1_r = reg_r14_q;
        5'd15: reg1_r = reg_r15_q;
        5'd16: reg1_r = reg_r16_q;
        5'd17: reg1_r = reg_r17_q;
        5'd18: reg1_r = reg_r18_q;
        5'd19: reg1_r = reg_r19_q;
        5'd20: reg1_r = reg_r20_q;
        5'd21: reg1_r = reg_r21_q;
        5'd22: reg1_r = reg_r22_q;
        5'd23: reg1_r = reg_r23_q;
        5'd24: reg1_r = reg_r24_q;
        5'd25: reg1_r = reg_r25_q;
        5'd26: reg1_r = reg_r26_q;
        5'd27: reg1_r = reg_r27_q;
        5'd28: reg1_r = reg_r28_q;
        5'd29: reg1_r = reg_r29_q;
        5'd30: reg1_r = reg_r30_q;
        5'd31: reg1_r = reg_r31_q;
        default : reg1_r = 32'h00000000;
      endcase

      case (rs2_i)
		  5'd0: reg2_r = reg_r0_q;
        5'd1: reg2_r = reg_r1_q;
        5'd2: reg2_r = reg_r2_q;
        5'd3: reg2_r = reg_r3_q;
        5'd4: reg2_r = reg_r4_q;
        5'd5: reg2_r = reg_r5_q;
        5'd6: reg2_r = reg_r6_q;
        5'd7: reg2_r = reg_r7_q;
        5'd8: reg2_r = reg_r8_q;
        5'd9: reg2_r = reg_r9_q;
        5'd10: reg2_r = reg_r10_q;
        5'd11: reg2_r = reg_r11_q;
        5'd12: reg2_r = reg_r12_q;
        5'd13: reg2_r = reg_r13_q;
        5'd14: reg2_r = reg_r14_q;
        5'd15: reg2_r = reg_r15_q;
        5'd16: reg2_r = reg_r16_q;
        5'd17: reg2_r = reg_r17_q;
        5'd18: reg2_r = reg_r18_q;
        5'd19: reg2_r = reg_r19_q;
        5'd20: reg2_r = reg_r20_q;
        5'd21: reg2_r = reg_r21_q;
        5'd22: reg2_r = reg_r22_q;
        5'd23: reg2_r = reg_r23_q;
        5'd24: reg2_r = reg_r24_q;
        5'd25: reg2_r = reg_r25_q;
        5'd26: reg2_r = reg_r26_q;
        5'd27: reg2_r = reg_r27_q;
        5'd28: reg2_r = reg_r28_q;
        5'd29: reg2_r = reg_r29_q;
        5'd30: reg2_r = reg_r30_q;
        5'd31: reg2_r = reg_r31_q;
        default : reg2_r = 32'h00000000;
      endcase
    end : Asynchronous_read

    assign data1_o = (rst_ni == 1'b0) ? 32'b0 : reg1_r;
    assign data2_o = (rst_ni == 1'b0) ? 32'b0 : reg2_r;
	 
	
endmodule
