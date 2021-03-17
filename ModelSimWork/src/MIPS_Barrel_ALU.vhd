library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Barrel_ALU is
  port(i_Immediate                                   : in std_logic_vector(15 downto 0);
       i_WE, i_RST, i_CLK, i_nAdd_Sub, i_ALUsrc      : in std_logic; --    
       i_memWrite, i_memRead, i_mem_to_reg            : in std_logic; --Memory Control Signals
       i_ALU_Shift				     : in std_logic; --Select bit between 0: ALU and 1:Shift
       i_rl, i_al				     : in std_logic; --Barrel Shifter controls for shift 0:left/1:right and 0:arithmetic/1:logical
       i_wAddr, rAddr1, rAddr2                       : in std_logic_vector(4 downto 0);
       i_ALUctrl	                             : in std_logic_vector(2 downto 0);
       i_Shamt					     : in std_logic_vector(4 downto 0);
       o_Overflow, o_zero, carryout                  : out std_logic;
       o_Sum                                         : out std_logic_vector(31 downto 0)); 

end MIPS_Barrel_ALU;

architecture structure of MIPS_Barrel_ALU is

component MUX_dataflow
  generic(N : integer := 32);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

component Register_File
  port(i_CLK                    : in std_logic;     -- Clock input
       i_RST                    : in std_logic;     -- Reset input
       i_WE                     : in std_logic;     -- Write enable input
       i_wAddr, rAddr1, rAddr2  : in std_logic_vector(4 downto 0);     -- Data value input
       i_wData      		: in std_logic_vector(31 downto 0);     -- Data value input
       o_rData1       : out std_logic_vector(31 downto 0);   -- Data value output
       o_rData2       : out std_logic_vector(31 downto 0));   -- Data value output

end component;

component sign_extender
      port( i_In : in std_logic_vector(15 downto 0);
            o_Out : out std_logic_vector(31 downto 0));
end component;

component ALU_Barrel_Shifter
   port(i_ALU_Shift : in std_logic;
	--Shifter I/O
	i_shamt  : in std_logic_vector(4 downto 0); 
	i_rl     : in std_logic; --0 = left shift, 1 = right shift
	i_al     : in std_logic; --0 = logical, 1 = arithmetic
	--ALU I/O
	i_ALU_input_A  : in std_logic_vector(31 downto 0);
	i_ALU_input_B  : in std_logic_vector(31 downto 0);
	i_control      : in std_logic_vector(2 downto 0);
	o_ALU_output   : out std_logic_vector(31 downto 0);
	o_carry_out    : out std_logic;
	o_overflow     : out std_logic;
	o_zero         : out std_logic);

end component;

component mem
  generic (DATA_WIDTH : natural := 32;
	   ADDR_WIDTH : natural := 10);
  port (clk		: in std_logic;
	addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	memWrite	: in std_logic;
	memRead		: in std_logic;
	q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;


signal immediate_data : std_logic_vector(15 downto 0);
signal MUX_Output : std_logic_vector(31 downto 0);
signal MEM_Output : std_logic_vector(31 downto 0);
signal sum : std_logic_vector(31 downto 0);
signal MEM_MUX_Output : std_logic_vector(31 downto 0);
signal temp_cOUT : std_logic;
signal o_rData1, o_rData2 : std_logic_vector(31 downto 0);
signal sign_extender_output : std_logic_vector(31 downto 0);

begin

A0: immediate_data <= i_Immediate;

A1: Register_File port map(i_CLK => i_CLK,
			   i_RST => i_RST,
			   i_WE => i_WE,
			   i_wAddr => i_wAddr,
			   rAddr1 => rAddr1,
			   rAddr2 => rAddr2,
			   i_wData => MEM_MUX_Output,
			   o_rData1 => o_rData1,
			   o_rData2 => o_rData2);

A2: sign_extender port map(i_In => immediate_data,
			   o_Out => sign_extender_output);

A3: MUX_dataflow port map(i_X => o_rData2,
		 i_Y => sign_extender_output,
		 i_S => i_ALUsrc,
		 o_F => MUX_Output);

A4: ALU_Barrel_Shifter port map(i_ALU_Shift => i_ALU_Shift,
				--Shifter I/O
				i_shamt => i_Shamt,
				i_rl => i_rl,
				i_al => i_al,
				--ALU I/O
				i_ALU_input_A => o_rData1,
				i_ALU_input_B => MUX_Output,
				i_control => i_ALUctrl,
				o_ALU_output => sum,
				o_carry_out => carryout,
				o_overflow => o_overflow,
				o_zero => o_zero);  

A5: mem port map(clk => i_CLK,
		 addr => sum(9 downto 0),
		 data => o_rData2,
		 memWrite => i_memWrite,
		 memRead => i_memRead,	
		 q => MEM_Output);

A6: MUX_dataflow port map(i_X => MEM_Output,
		 i_Y => sum,
		 i_S => i_mem_to_reg,
		 o_F => MEM_MUX_Output);

A7:  o_Sum <= MEM_MUX_Output;

end structure;



