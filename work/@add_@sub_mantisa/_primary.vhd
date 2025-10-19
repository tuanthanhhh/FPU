library verilog;
use verilog.vl_types.all;
entity Add_Sub_mantisa is
    port(
        mantA_aligned   : in     vl_logic_vector(27 downto 0);
        mantB_aligned   : in     vl_logic_vector(27 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        signA           : in     vl_logic;
        signB           : in     vl_logic;
        operation       : in     vl_logic;
        mantisa_raw     : out    vl_logic_vector(27 downto 0);
        sign_result     : out    vl_logic
    );
end Add_Sub_mantisa;
