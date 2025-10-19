module Add_Sub_mantisa(
	input [27:0] mantA_aligned,
	input [27:0] mantB_aligned,
	input clk,
	input rst,
	input signA,
	input signB,
	input operation,
	 
	output reg [27:0] mantisa_raw,
	output reg sign_result
);
	wire [27:0] mant_sum;
	wire [27:0] mant_diff;
	wire Is_mantA_bigger;
	wire effective_sub;
	
	assign effective_sub = (operation ^ (signA ^ signB));
	assign Is_mantA_bigger = (mantA_aligned >= mantB_aligned);
	
	assign mant_sum = mantA_aligned + mantB_aligned;
	assign mant_diff = Is_mantA_bigger ? (mantA_aligned - mantB_aligned) : (mantB_aligned - mantA_aligned);  
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			mantisa_raw <= 28'b0;
			sign_result <= 1'b0;
		end else
		begin
			if(effective_sub)
			begin
				mantisa_raw <= mant_diff;
				sign_result <= Is_mantA_bigger? signA:signB;
			end else
			begin
				mantisa_raw <= mant_sum;
				sign_result <= signA;
			end
		end
	end
endmodule 