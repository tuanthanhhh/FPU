library verilog;
use verilog.vl_types.all;
entity FPU_32b_vlg_check_tst is
    port(
        ine             : in     vl_logic;
        inf             : in     vl_logic;
        overflow        : in     vl_logic;
        result          : in     vl_logic_vector(31 downto 0);
        underflow       : in     vl_logic;
        zero            : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end FPU_32b_vlg_check_tst;
