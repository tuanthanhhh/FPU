library verilog;
use verilog.vl_types.all;
entity pre_normalize is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        expA_i          : in     vl_logic_vector(7 downto 0);
        expB_i          : in     vl_logic_vector(7 downto 0);
        mantA_i         : in     vl_logic_vector(23 downto 0);
        mantB_i         : in     vl_logic_vector(23 downto 0);
        exp_common      : out    vl_logic_vector(7 downto 0);
        mantA_aligned   : out    vl_logic_vector(27 downto 0);
        mantB_aligned   : out    vl_logic_vector(27 downto 0)
    );
end pre_normalize;
