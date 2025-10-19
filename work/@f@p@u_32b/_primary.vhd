library verilog;
use verilog.vl_types.all;
entity FPU_32b is
    port(
        RST             : in     vl_logic;
        opa_i           : in     vl_logic_vector(31 downto 0);
        opb_i           : in     vl_logic_vector(31 downto 0);
        mode_i          : in     vl_logic_vector(1 downto 0);
        fpu_op_i        : in     vl_logic;
        clk_i           : in     vl_logic;
        result          : out    vl_logic_vector(31 downto 0);
        ine             : out    vl_logic;
        overflow        : out    vl_logic;
        underflow       : out    vl_logic;
        inf             : out    vl_logic;
        zero            : out    vl_logic
    );
end FPU_32b;
