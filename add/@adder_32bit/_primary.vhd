library verilog;
use verilog.vl_types.all;
entity Adder_32bit is
    port(
        sum             : out    vl_logic_vector(31 downto 0);
        cout            : out    vl_logic;
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end Adder_32bit;
