`timescale 1ns/1ps

module tb_FPU_32b;

  reg clk_i;
  reg RST;
  reg [31:0] opa_i, opb_i;
  reg [1:0] mode_i;
  reg fpu_op_i; // 0: add, 1: sub

  wire [31:0] result;
  wire ine, overflow, underflow, inf, zero;

  // DUT
  FPU_32b dut (
    .RST(RST),
    .opa_i(opa_i),
    .opb_i(opb_i),
    .mode_i(mode_i),
    .fpu_op_i(fpu_op_i),
    .clk_i(clk_i),
    .result(result),
    .ine(ine),
    .overflow(overflow),
    .underflow(underflow),
    .inf(inf),
    .zero(zero)
  );

  // Clock 10ns period
  always #5 clk_i = ~clk_i;

  integer pass_cnt = 0;
  integer fail_cnt = 0;
  reg [31:0] expected;
  reg [31:0] diff;

  // Hàm so sánh
  task check_result;
    input [31:0] got, exp;
    begin
      diff = got ^ exp;
      if (diff == 0) begin
        pass_cnt = pass_cnt + 1;
        $display("PASS: got=%h expected=%h", got, exp);
      end else begin
        fail_cnt = fail_cnt + 1;
        $display("FAIL: got=%h expected=%h", got, exp);
      end
    end
  endtask

  initial begin
    clk_i = 0;
    RST = 1;
    opa_i = 0;
    opb_i = 0;
    fpu_op_i = 0;
    mode_i = 2'b00;
    #20;
    RST = 0;  // Thả reset

    // Test 1: 1.0 + 1.0 = 2.0
    opa_i = 32'h3F800000;  // 1.0
    opb_i = 32'h3F800000;  // 1.0
    fpu_op_i = 0;
    #100;
    expected = 32'h40000000; // 2.0
    check_result(result, expected);

    // Test 2: 3.0 - 1.0 = 2.0
    opa_i = 32'h40400000;  // 3.0
    opb_i = 32'h3F800000;  // 1.0
    fpu_op_i = 1;
    #100;
    expected = 32'h40000000; // 2.0
    check_result(result, expected);

    // Test 3: 2.5 + 2.5 = 5.0
    opa_i = 32'h40200000; // 2.5
    opb_i = 32'h40200000; // 2.5
    fpu_op_i = 0;
    #100;
    expected = 32'h40A00000; // 5.0
    check_result(result, expected);

    $display("=====================================");
    $display("TOTAL PASS = %0d", pass_cnt);
    $display("TOTAL FAIL = %0d", fail_cnt);
    $display("=====================================");
    $stop;
  end

endmodule
