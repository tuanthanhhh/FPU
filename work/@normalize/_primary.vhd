library verilog;
use verilog.vl_types.all;
entity Normalize is
    port(
        mantisa_raw     : in     vl_logic_vector(27 downto 0);
        exp_common      : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        mantisa_norm    : out    vl_logic_vector(26 downto 0);
        exp_norm        : out    vl_logic_vector(7 downto 0)
    );
end Normalize;
