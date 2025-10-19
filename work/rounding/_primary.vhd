library verilog;
use verilog.vl_types.all;
entity rounding is
    port(
        mantisa_norm    : in     vl_logic_vector(26 downto 0);
        exp_norm        : in     vl_logic_vector(7 downto 0);
        sign_norm       : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        mode            : in     vl_logic_vector(1 downto 0);
        mantisa_round   : out    vl_logic_vector(22 downto 0);
        exp_round       : out    vl_logic_vector(7 downto 0)
    );
end rounding;
