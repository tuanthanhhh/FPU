library verilog;
use verilog.vl_types.all;
entity FPU_32b_vlg_sample_tst is
    port(
        RST             : in     vl_logic;
        clk_i           : in     vl_logic;
        fpu_op_i        : in     vl_logic;
        mode_i          : in     vl_logic_vector(1 downto 0);
        opa_i           : in     vl_logic_vector(31 downto 0);
        opb_i           : in     vl_logic_vector(31 downto 0);
        sampler_tx      : out    vl_logic
    );
end FPU_32b_vlg_sample_tst;
