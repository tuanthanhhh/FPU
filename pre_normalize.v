/*
2. Exponent Compare & Align 
So sánh exponent của A và B, chọn exponent lớn hơn, dịch phải mantissa của số nhỏ hơn để căn chỉnh. 
Ngõ vào: expA, expB, mantA, mantB 
Ngõ ra: exp_common, mantA_aligned, mantB_aligned
*/
module pre_normalize(
    input clk,
    input rst,
    input [7:0] expA_i,
    input [7:0] expB_i,
    input [23:0] mantA_i,
    input [23:0] mantB_i,

    output reg [7:0] exp_common,
    output reg [27:0] mantA_aligned,
    output reg [27:0] mantB_aligned
);

    wire [7:0] diff = (expA_i > expB_i)? (expA_i - expB_i): (expB_i - expA_i);
    /*
       mantX_ext = [carry bit][24 bit mantissa][3 GRS bits]
    */
    wire [27:0] mantA_ext = {1'b0,mantA_i,3'b0};
    wire [27:0] mantB_ext = {1'b0,mantB_i,3'b0};

    wire [27:0] fracS = (expA_i > expB_i)? mantB_ext: mantA_ext; // Chọn mantissa nhỏ hơn (ứng với exponent nhỏ hơn)
    wire [27:0] frac_shift = (diff >= 28)? (28'b0): (fracS >> diff);  // Dịch phải mantissa nhỏ hơn

    always @(posedge clk)begin
        if (rst) begin
            exp_common <= 8'b0;
            mantA_aligned <= 28'b0;
            mantB_aligned <= 28'b0;
        end else begin
            exp_common <= (expA_i > expB_i)? expA_i:expB_i;
            mantA_aligned <= (expA_i > expB_i) ? mantA_ext: frac_shift;
            mantB_aligned <= (expA_i > expB_i) ? frac_shift: mantB_ext;
        end
    end 
endmodule