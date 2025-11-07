module FPU_32b(
	input wire RST,
	input wire [31:0] opa_i,
	input wire [31:0] opb_i,
	input wire [1:0]  mode_i,
	input wire fpu_op_i,
	input wire clk_i,
	
	output wire [31:0] result,
	output wire ine,
	output wire overflow,
	output wire underflow,
	output wire inf,
	output wire zero
);

	wire signA, signB;
	wire [7:0] expA, expB;
	wire [23:0] mantA, mantB;
	
	wire[7:0] exp_common;
	wire [27:0] mantA_aligned;
	wire [27:0] mantB_aligned;
	
	wire [27:0] mantisa_raw;
	wire sign_result;
	
	wire sign_norm;
	wire [27:0] mantisa_norm;
	wire [7:0] exp_norm;
	
	wire [22:0] mantisa_round;
	wire [7:0] exp_round;
	
	wire [31:0] packed_result;
	
	Unpack u_unpack(
			.clk(clk_i),
			.rst(RST),
			.opa_i(opa_i),
			.opb_i(opb_i),
			.signA_o(signA),
			.signB_o(signB),
			.expA_o(expA),
			.expB_o(expB),
			.mantA_o(mantA),
			.mantB_o(mantB)
			);
	Add_Sub_mantisa u_addsub(
			.clk(clk_i),
			.rst(RST),
			.mantA_aligned(mantA_aligned),
			.mantB_aligned(mantB_aligned),
			.signA(signA),
			.signB(signB),
			.operation(fpu_op_i),
			.mantisa_raw(mantisa_raw),
			.sign_result(sign_result)
	);
	
	pre_normalize u_pre_norm(
			.clk(clk_i),
			.rst(RST),
			.expA_i(expA),
			.expB_i(expB),
			.mantA_i(mantA),
			.mantB_i(mantB),
			.exp_common(exp_common),
			.mantA_aligned(mantA_aligned),
			.mantB_aligned(mantB_aligned)
	);
	
	Normalize u_normalize(
			.clk(clk_i),
			.rst(RST),
			.sign(sign_result),
			.mantisa_raw(mantisa_raw),
			.exp_common(exp_common),
			.mantisa_norm(mantisa_norm),
			.exp_norm(exp_norm),
			.sign_norm(sign_norm)
	);
		
	rounding u_rounding(
			.clk(clk_i),
			.rst(RST),
			.mantisa_norm(mantisa_norm),
			.exp_norm(exp_norm),
			.sign_norm(sign_norm),
			.mode(mode_i),
			.mantisa_round(mantisa_round),
			.exp_round(exp_round)
	);
	
	pack u_pack(
			.clk(clk_i),
			.rst(RST),
			.sign(sign_norm),
			.mantisa(mantisa_round),
			.exp(exp_round),
			.result(result)
	);
	
	assign ine = 1'b0;
	assign overflow = (exp_round == 8'b11111111);
	assign underflow = (exp_round == 8'b00);
	assign inf = (exp_round == 8'b11111111) && (mantisa_round == 0);
	assign zero = (exp_round == 8'b00) && (mantisa_round == 0);
endmodule 