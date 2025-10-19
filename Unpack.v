module Unpack(
	input wire [31:0] opa_i,
	input wire [31:0] opb_i,
	input wire clk,
	input rst, 
	output reg signA_o,
	output reg signB_o,
	output reg [7:0] expA_o,
	output reg [7:0] expB_o,
	output reg [23:0] mantA_o,
	output reg [23:0] mantB_o
);

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			signA_o <= 0;
			signB_o <= 0;
			expA_o <= 8'b0;
			expB_o <= 8'b0;
			mantA_o <= 23'b0;
			mantB_o <= 23'b0;
		end else
		begin
			signA_o <= opa_i[31];
			signB_o <= opb_i[31];
			expA_o <= opa_i[30:23];
			expB_o <= opb_i[30:23];
			mantA_o <=  (opa_i[30:23] == 8'b0) ? {1'b0, opa_i[22:0]} : {1'b1, opa_i[22:0]};
			mantB_o <=  (opb_i[30:23] == 8'b0) ? {1'b0, opb_i[22:0]} : {1'b1, opb_i[22:0]};
		end
	end
endmodule