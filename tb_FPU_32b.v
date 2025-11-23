`timescale 1ns/1ps

module tb_FPU_32b;

    reg         clk_i;
    reg         RST;
    reg  [31:0] opa_i;
    reg  [31:0] opb_i;
    reg  [31:0] expected;
    reg         fpu_op_i;

    wire [31:0] result;
    wire ine, overflow, underflow, inf, zero;

    integer fp;
    integer code;

    // ==============================
    // DUT
    // ==============================
    FPU_32b DUT (
        .clk_i(clk_i),
        .RST(RST),
        .opa_i(opa_i),
        .opb_i(opb_i),
        .mode_i(2'b00),   // ví dụ ROUND TO NEAREST
        .fpu_op_i(fpu_op_i),
        .result(result),
        .ine(ine),
        .overflow(overflow),
        .underflow(underflow),
        .inf(inf),
        .zero(zero)
    );

    // ==============================
    // Clock
    // ==============================
    initial clk_i = 0;
    always #5 clk_i = ~clk_i;
	 integer i = 0;
	 integer pass_cnt = 0;
	 integer fail_cnt = 0;

    // ==============================
    // Task check_result
    // ==============================
    task check_result;
        input [31:0] opa_i_t;
        input [31:0] opb_i_t;
        input        fpu_op_i_t;
        input [31:0] dut_result;
        input [31:0] expected_bits;
        begin
				i = i +1;
            if (dut_result === expected_bits) begin
                $display("PASS opa=%h opb=%h op=%0d DUT=%h Expected=%h", opa_i_t, opb_i_t, fpu_op_i_t, dut_result, expected_bits);
					 pass_cnt = pass_cnt + 1;
					 
            end else begin
                $display("FAIL opa=%h opb=%h op=%0d DUT=%h Expected=%h", opa_i_t, opb_i_t, fpu_op_i_t, dut_result, expected_bits);
					 fail_cnt = fail_cnt + 1;
            end
        end
    endtask
	 


    // ==============================
    // Testbench bằng file
    // ==============================
    initial begin
        RST = 1;
        #20 RST = 0;

        fp = $fopen("test_vectors.txt", "r");
        if (fp == 0) begin
            $display("Cannot open file!");
            $stop;
        end

        while (!$feof(fp)) begin
            code = $fscanf(fp, "%h %h %d %h\n", opa_i, opb_i, fpu_op_i, expected);
				repeat(10) @(posedge clk_i);
            // So sánh
            check_result(opa_i, opb_i, fpu_op_i, result, expected);
        end

        $fclose(fp);
        $display("TEST DONE, Test case: %d, Test case pass: %d, Test case fail: %d ",i, pass_cnt, fail_cnt);
        $stop;
    end

endmodule
