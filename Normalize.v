module Normalize(
    input  wire [27:0] mantisa_raw,
    input  wire [7:0]  exp_common,
    input  wire clk,
    input  wire rst,
    output reg [27:0] mantisa_norm,
    output reg [7:0]  exp_norm
);
	reg [27:0] mant_temp;
	reg [7:0] exp_temp;
	integer i;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			mantisa_norm <= 27'b0;
			exp_norm <= 8'b0;
		end else
		begin
			mant_temp = mantisa_raw;
			exp_temp = exp_common;
			if(mant_temp[27])
			begin
				mant_temp = mant_temp >> 1;
				exp_temp = exp_temp + 8'b1;
			end else if(!mant_temp[26])
			begin
				for(i = 0; i < 27 && !mant_temp[26];i = i + 1)
				begin
					mant_temp = mant_temp << 1;
					exp_temp = exp_temp - 1;
				end
			end
			
			mantisa_norm <= mant_temp[27:0];
			exp_norm <= exp_temp;
		end
	end
endmodule
