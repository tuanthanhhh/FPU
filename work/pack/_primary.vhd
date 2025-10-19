library verilog;
use verilog.vl_types.all;
entity pack is
    port(
        sign            : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        mantisa         : in     vl_logic_vector(22 downto 0);
        exp             : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end pack;
