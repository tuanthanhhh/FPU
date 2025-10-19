module rounding(
	input wire [27:0] mantisa_norm,
	input wire [7:0]	exp_norm,
	input wire sign_norm,
	input wire clk,
	input wire rst,
	input wire [1:0] mode,
	
	output reg [22:0] mantisa_round,
	output reg [7:0] exp_round
);
	
	wire G = mantisa_norm[2];
	wire R = mantisa_norm[1];
	wire S = mantisa_norm[0];
	
	reg [24:0] mant_shifted;
	reg [24:0] mant_temp;
	reg [7:0] exp_temp;
	reg overflow;
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			mant_temp <= 24'b0;
			exp_round <= 8'b0;
			mantisa_round <= 23'b0;
			exp_temp <= 8'b0;
		end else
		begin
			exp_temp = exp_norm;
			case(mode)
			2'b00:
			begin
				if(G && (R | S | mantisa_norm[3]))
				begin
					mant_temp <= mantisa_norm[27:3] + 1;
				end else
				begin
					mant_temp <= mantisa_norm[27:3];
				end
			end
			2'b01:
			begin
				mant_temp <= mantisa_norm[27:3];
			end
			2'b10:
			begin
				if((sign_norm == 1'b0) && (G | R | S))
				begin
					mant_temp <= mantisa_norm[27:3] + 1;
				end else
				begin
					mant_temp <= mantisa_norm[27:3];
				end
			end
			2'b11:
			begin
				if((sign_norm == 1'b1) && (G | R | S))
				begin
					mant_temp <= mantisa_norm[27:3] + 1;
				end else
				begin
				mant_temp <= mantisa_norm[27:3];
				end
			end
			endcase
			if(mant_temp[24] == 1'b1)
			begin
				overflow <= 1'b1;
			end else
			begin
				overflow <= 1'b0;
			end
			
			mant_shifted = overflow ? (mant_temp >> 1) : mant_temp;
			mantisa_round = mant_shifted[22:0];
			exp_round = overflow? (exp_temp + 1) : exp_temp;
		end
	end
endmodule 