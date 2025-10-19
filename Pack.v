module pack(
	input wire sign,
	input wire clk,
	input wire rst,
	input wire [22:0] mantisa,
	input wire [7:0] exp,
	
	output reg [31:0] result
);

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			result <= 32'b0;
		end else
		begin
			result <= {sign,exp,mantisa};
		end
	end
	
endmodule 