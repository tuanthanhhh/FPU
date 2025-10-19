library verilog;
use verilog.vl_types.all;
entity Unpack is
    port(
        opa_i           : in     vl_logic_vector(31 downto 0);
        opb_i           : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        signA_o         : out    vl_logic;
        signB_o         : out    vl_logic;
        expA_o          : out    vl_logic_vector(7 downto 0);
        expB_o          : out    vl_logic_vector(7 downto 0);
        mantA_o         : out    vl_logic_vector(23 downto 0);
        mantB_o         : out    vl_logic_vector(23 downto 0)
    );
end Unpack;
