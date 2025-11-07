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
  integer i =0;
  integer pass_cnt = 0;
  integer fail_cnt = 0;
  reg [31:0] expected;
  reg [31:0] diff;

  // Hàm so sánh
  task check_result;
    input integer i;
    input [31:0] got, exp;
    begin
      diff = got ^ exp;
      if (diff == 0) begin
        pass_cnt = pass_cnt + 1;
        $display("Testcase [%d] PASS: got=%h expected=%h",i, got, exp);
      end else begin
        fail_cnt = fail_cnt + 1;
        $display("Testcase [%d] FAIL: got=%h expected=%h",i, got, exp);
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
    i=i+1;
    // Test 1: 1.0 + 1.0 = 2.0
    opa_i = 32'h3F800000;  // 1.0
    opb_i = 32'h3F800000;  // 1.0
    fpu_op_i = 0;
    #200;
    expected = 32'h40000000; // 2.0
    check_result(i, result, expected);
    i=i+1;
    // Test 2: 3.0 - 1.0 = 2.0
    opa_i = 32'h40400000;  // 3.0
    opb_i = 32'h3F800000;  // 1.0
    fpu_op_i = 1;
    #200;
    expected = 32'h40000000; // 2.0
    check_result(i, result, expected);

    i=i+1;
    // Test 3: 2.5 + 2.5 = 5.0
    opa_i = 32'h40200000; // 2.5
    opb_i = 32'h40200000; // 2.5
    fpu_op_i = 0;
    #200;
    expected = 32'h40A00000; // 5.0
    check_result(i, result, expected);

    i=i+1;
    // 4
    opa_i = 32'h40200000; // 2.5
    opb_i = 32'h3F800000; // 1
    fpu_op_i = 0;
    #200;
    expected = 32'h40600000; // 3.5
    check_result(i, result, expected);

    i=i+1;
    // 5
    opa_i = 32'h477FFF00; // 65535
    opb_i = 32'h00000000; // 0
    fpu_op_i = 0;
    #200;
    expected = 32'h477FFF00; // 65535
    check_result(i, result, expected);

    i=i+1;
    // 6
    opa_i = 32'h477FFE00; // 65534
    opb_i = 32'h3F800000; // 1
    fpu_op_i = 0;
    #200;
    expected = 32'h477FFF00; // 65535
    check_result(i, result, expected);

    i=i+1;
    // 7
    opa_i = 32'h477FFF00; // 65535
    opb_i = 32'h477FFF00; // 65535
    fpu_op_i = 0;
    #200;
    expected = 32'h47FFFF00; // 131070
    check_result(i, result, expected);

    i=i+1;
    // 8
    opa_i = 32'h46FFEA00; // 32757
    opb_i = 32'h46FFEA00; // 32757
    fpu_op_i = 0;
    #200;
    expected = 32'h477FEA00; // 65514
    check_result(i, result, expected);

    i=i+1;
    // 9
    opa_i = 32'h4083F2E5; // 4.1234
    opb_i = 32'h3FD47AE1; // 1.66
    fpu_op_i = 0;
    #200;
    expected = 32'h40B9119D; // 5.7834  
    check_result(i, result, expected);

    i=i+1;
    // 10
    opa_i = 32'h412A7C50; // 10.65535
    opb_i = 32'h3FD3E282; // 1.65535
    fpu_op_i = 0;
    #200;
    expected = 32'h4144F8A1; // 12.3107
    check_result(i, result, expected);

    i=i+1;
    // 11
    opa_i = 32'h41280000; // 10.5
    opb_i = 32'hC1200000; // -10.0
    fpu_op_i = 0;
    #200;
    expected = 32'h3F000000; // 0.5
    check_result(i, result, expected);

    i=i+1;
    // 12
    opa_i = 32'h00000000; // 0
    opb_i = 32'hBE6D9168; // -0.232
    fpu_op_i = 0;
    #200;
    expected = 32'hBE6D9168; // -0.232
    check_result(i, result, expected);

    i=i+1;
    // 13
    opa_i = 32'h00000000; // 0
    opb_i = 32'h00000000; // 0
    fpu_op_i = 0;
    #200;
    expected = 32'h00000000; // 0
    check_result(i, result, expected);

    i=i+1;
    // 14
    opa_i = 32'h447A0CAC; // 1000.198
    opb_i = 32'hBE6D9168; // -0.232
    fpu_op_i = 0;
    #200;
    expected = 32'h4479FDD3; // 999.966
    check_result(i, result, expected);

    i=i+1;
    // 15
    opa_i = 32'h46FFFF00; // 32767.5
    opb_i = 32'h46FFFF00; // 32767.5
    fpu_op_i = 0;
    #200;
    expected = 32'h477FFF00; // 65535
    check_result(i, result, expected);

    i=i+1;
    // 16
    opa_i = 32'h46FFFF00; // 32767.5
    opb_i = 32'hC6FFFF00; // -32767.5
    fpu_op_i = 0;
    #200;
    expected = 32'h00000000; // 0
    check_result(i, result, expected);

    i=i+1;
    // 17
    opa_i = 32'hC6FFFF00; // -32767.5
    opb_i = 32'hC6FFFF00; // -32767.5
    fpu_op_i = 0;
    #200;
    expected = 32'hC77FFF00; // -65535
    check_result(i, result, expected);

    i=i+1;
    // 18
    opa_i = 32'hC6FFFF00; // -32767.5
    opb_i = 32'h46FFFF00; // 32767.5
    fpu_op_i = 0;
    #200;
    expected = 32'h00000000; // 0
    check_result(i, result, expected);

    i=i+1;
    // 19
    opa_i = 32'h42580CA3; // 54.01234
    opb_i = 32'h40871C43; // 4.2222
    fpu_op_i = 0;
    #200;
    expected = 32'h4268F02B; // 58.23454
    check_result(i, result, expected);

    i=i+1;
    // 20
    opa_i = 32'h00000000; // 0
    opb_i = 32'hC77FFF00; // -65535
    fpu_op_i = 0;
    #200;
    expected = 32'hC77FFF00; // -65535
    check_result(i, result, expected);

    i=i+1;
    // 21
    opa_i = 32'hC77FFF00; // -65535
    opb_i = 32'hC77FFF00; // -65535
    fpu_op_i = 0;
    #200;
    expected = 32'hC7FFFF00; // -131070
    check_result(i, result, expected);

    i=i+1;
    // 22
    opa_i = 32'h477FFE39; // 65534.22222
    opb_i = 32'h3F471C97; // 0.77778
    fpu_op_i = 0;
    #200;
    expected = 32'h477FFF00; // 65535
    check_result(i, result, expected);

    i=i+1;
    // 23
    opa_i = 32'h404D9653; // 3.2123
    opb_i = 32'h3F9C71C5; // 1.222222
    fpu_op_i = 0;
    #200;
    expected = 32'h408DE79B; // 4.434522
    check_result(i, result, expected);

    i=i+1;
    // 24
    opa_i = 32'hC0200000; // -2.5
    opb_i = 32'hBF800000; // -1
    fpu_op_i = 0;
    #200;
    expected = 32'hC0600000; // -3.5
    check_result(i, result, expected);

    i=i+1;
    // 25
    opa_i = 32'hC77FFF00; // -65535
    opb_i = 32'h00000000; // 0
    fpu_op_i = 0;
    #200;
    expected = 32'hC77FFF00; // -65535
    check_result(i, result, expected);

    i=i+1;
    // 26
    opa_i = 32'hC77FFE00; // -65534
    opb_i = 32'hBF800000; // -1
    fpu_op_i = 0;
    #200;
    expected = 32'hC77FFF00; // -65535
    check_result(i, result, expected);

    i=i+1;
    // 27
    opa_i = 32'hC77FFF00; // -65535
    opb_i = 32'hC77FFF00; // -65535
    fpu_op_i = 0;
    #200;
    expected = 32'hC7FFFF00; // -131070
    check_result(i, result, expected);

    i=i+1;
    // 28
    opa_i = 32'hC6FFEA00; // -32757
    opb_i = 32'hC6FFEA00; // -32757
    fpu_op_i = 0;
    #200;
    expected = 32'hC77FEA00; // -65514
    check_result(i, result, expected);

    i=i+1;
    // 29
    opa_i = 32'hC083F2E5; // -4.1234
    opb_i = 32'hBFD47AE1; // -1.66
    fpu_op_i = 0;
    #200;
    expected = 32'hC0B9119D; // -5.7834
    check_result(i, result, expected);

    i=i+1;
    // 30
    opa_i = 32'hC12A7C50; // -10.65535
    opb_i = 32'hBFD3E282; // -1.65535
    fpu_op_i = 0;
    #200;
    expected = 32'hC144F8A1; // -12.3107
    check_result(i, result, expected);

    i=i+1;
    // 31
    opa_i = 32'hC77FFE39; // -65534.22222
    opb_i = 32'hBF471C97; // -0.77778
    fpu_op_i = 0;
    #200;
    expected = 32'hC77FFF00; // -65535
    check_result(i, result, expected);

    i=i+1;
    // 32
    opa_i = 32'hC007E32A; // -2.12324
    opb_i = 32'hBF800347; // -1.0001
    fpu_op_i = 0;
    #200;
    expected = 32'hC047E4CD; // -3.12334
    check_result(i, result, expected);

    i=i+1;
    // 33
    opa_i = 32'hC1239581; // -10.224
    opb_i = 32'hBDFBE76D; // -0.123
    fpu_op_i = 0;
    #200;
    expected = 32'hC1258D50; // -10.347
    check_result(i, result, expected);

    i=i+1;
    // 34
    opa_i = 32'hBF8E353F; // -1.111
    opb_i = 32'h3DE353F8; // 0.111
    fpu_op_i = 0;
    #200;
    expected = 32'hBF800000; // -1
    check_result(i, result, expected);

    i=i+1;
    // 35
    opa_i = 32'h41000831; // 8.002
    opb_i = 32'h3EB0A3D7; // 0.345
    fpu_op_i = 0;
    #200;
    expected = 32'h41058D50; // 8.347
    check_result(i, result, expected);

    i=i+1;
    // 36
    opa_i = 32'h4188EB85; // 17.115
    opb_i = 32'h3F143958; // 0.579
    fpu_op_i = 0;
    #200;
    expected = 32'h418D8D50; // 17.694
    check_result(i, result, expected);

    i=i+1;
    // 37
    opa_i = 32'h41D1D2F2; // 26.228
    opb_i = 32'h3F5020C5; // 0.813
    fpu_op_i = 0;
    #200;
    expected = 32'h41D853F8; // 27.041
    check_result(i, result, expected);

    // 38
    i=i+1;
    opa_i = 32'h3A83126F; // 0.001
    opb_i = 32'h3A83126F; // 0.001
    fpu_op_i = 0;
    #200;
    expected = 32'h3B03126F; // ~0.002
    check_result(i, result, expected);

    // 39: 10.0 - 10.0 = 0
    i=i+1;
    opa_i = 32'h41200000; // 10.0
    opb_i = 32'h41200000; // 10.0
    fpu_op_i = 1;
    #200;
    expected = 32'h00000000; // 0.0
    check_result(i, result, expected);

    // 40: -5.0 + 5.0 = 0
    i=i+1;
    opa_i = 32'hC0A00000; // -5.0
    opb_i = 32'h40A00000; // 5.0
    fpu_op_i = 0;
    #200;
    expected = 32'h00000000; // 0.0
    check_result(i, result, expected);

    // 41: 100000.0 - 0.1
    i=i+1;
    opa_i = 32'h47C35000; // 100000.0
    opb_i = 32'h3DCCCCCD; // 0.1
    fpu_op_i = 1;
    #200;
    expected = 32'h47C34FF3; // ~99999.9
    check_result(i, result, expected);

    // 42: -100000.0 + 0.1
    i=i+1;
    opa_i = 32'hC7C35000; // -100000.0
    opb_i = 32'h3DCCCCCD; // 0.1
    fpu_op_i = 0;
    #200;
    expected = 32'hC7C34FF3; // ~-99999.9
    check_result(i, result, expected);

    // 43: 0.0 + 10.0
    i=i+1;
    opa_i = 32'h00000000; // 0.0
    opb_i = 32'h41200000; // 10.0
    fpu_op_i = 0;
    #200;
    expected = 32'h41200000; // 10.0
    check_result(i, result, expected);

    // 44: 0.0 - 10.0
    i=i+1;
    opa_i = 32'h00000000; // 0.0
    opb_i = 32'h41200000; // 10.0
    fpu_op_i = 1;
    #200;
    expected = 32'hC1200000; // -10.0
    check_result(i, result, expected);

    // 45: -10.0 - (-10.0)
    i=i+1;
    opa_i = 32'hC1200000; // -10.0
    opb_i = 32'hC1200000; // -10.0
    fpu_op_i = 1;
    #200;
    expected = 32'h00000000; // 0.0
    check_result(i, result, expected);

    // 46
    i=i+1;
    opa_i = 32'h47C35000; // ~100000.0
    opb_i = 32'h47C35000; // ~100000.0
    fpu_op_i = 0;
    #200;
    expected = 32'h48435000; // ~200000.0
    check_result(i, result, expected);

    // 47
    i=i+1;
    opa_i = 32'h3DCCCCCD; // 0.1
    opb_i = 32'h47C35000; // 100000.0
    fpu_op_i = 0;
    #200;
    expected = 32'h47C3500D; // ~100000.1 (rounds to 100000)
    check_result(i, result, expected);

    $display("=====================================");
    $display("TOTAL PASS = %0d", pass_cnt);
    $display("TOTAL FAIL = %0d", fail_cnt);
    $display("=====================================");
    $stop;
  end

endmodule