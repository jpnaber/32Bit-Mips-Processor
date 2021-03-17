library IEEE;
use IEEE.std_logic_1164.all;

entity Second_MIPS_Application is
  port(i_Immediate                               : in std_logic_vector(15 downto 0); --Immediate
       i_wAddr					 : in std_logic_vector(4 downto 0);
       i_rAddr2					 : in std_logic_vector(4 downto 0);
       i_rAddr1					 : in std_logic_vector(4 downto 0);
       i_WE, i_RST, i_CLK			 : in std_logic; -- Register file control signals
       i_memWE                         		 : in std_logic; -- Memory write enable '1' to write to memory '0' to read from it
       i_rl, i_al				 : in std_logic; --0 = left shift, 1 = right shift, 0 = logical, 1 = arithmetic
       i_ALUsrc					 : in std_logic; -- '0' = readData2 '1' = sign extend
       i_ALU_Shift				 : in std_logic; -- 0 = ALU output, 1 = shift output
       i_ALU_control				 : in std_logic_vector(2 downto 0); -- Select what operation you want within the ALU
       i_shamt					 : in std_logic_vector(4 downto 0);
       i_mem_to_reg				 : in std_logic; --'0' = MemoryOutput '1' = ALU output to register file
       o_carry_out, o_overflow, o_zero		 : out std_logic; --Outputs from the ALU
       o_output					 : out std_logic_vector(31 downto 0)); --Output after the mem_to_reg mux

end Second_MIPS_Application;

architecture structural of Second_MIPS_Application is

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

component Adder_Subtractor
  generic(N : integer := 32);
  port(i_A,i_B  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub  : in std_logic;
       o_Sum  : out std_logic_vector(N-1 downto 0);
       o_Cout : out std_logic);

end component;

component mem
  generic (DATA_WIDTH : natural := 32;
	   ADDR_WIDTH : natural := 10);
  port (clk		: in std_logic;
	addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	we		: in std_logic := '1';
	q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;
component ALU_Barrel_Shifter
   port(i_ALU_Shift : in std_logic; --0 = ALU output, 1 = shift output
	i_shamt  : in std_logic_vector(4 downto 0); 
	i_rl     : in std_logic; --0 = left shift, 1 = right shift
	i_al     : in std_logic; --0 = logical, 1 = arithmetic
	i_ALU_input_A  : in std_logic_vector(31 downto 0);
	i_ALU_input_B  : in std_logic_vector(31 downto 0);
	i_control      : in std_logic_vector(2 downto 0);
	o_ALU_output   : out std_logic_vector(31 downto 0);
	o_carry_out    : out std_logic;
	o_overflow     : out std_logic;
	o_zero         : out std_logic);end component;

signal immediate_data : std_logic_vector(15 downto 0);
signal MUX_Output : std_logic_vector(31 downto 0);
signal MEM_Output : std_logic_vector(31 downto 0);
signal sum : std_logic_vector(31 downto 0);
signal MEM_MUX_Output : std_logic_vector(31 downto 0);
signal o_rData1, o_rData2 : std_logic_vector(31 downto 0);
signal sign_extender_output : std_logic_vector(31 downto 0);

begin

A0: immediate_data <= i_Immediate;


A1: Register_File port map(i_CLK => i_CLK,
			   i_RST => i_RST,
			   i_WE => i_WE,
			   i_wAddr => i_wAddr,
			   rAddr1 => i_rAddr1,
			   rAddr2 => i_rAddr2,
			   i_wData => MEM_MUX_Output,
			   o_rData1 => o_rData1,
			   o_rData2 => o_rData2);


A2: sign_extender port map(i_In => immediate_data,
			   o_Out => sign_extender_output);

A3: MUX_dataflow port map(i_X => o_rData2,
		 i_Y => sign_extender_output,
		 i_S => i_ALUsrc,
		 o_F => MUX_Output);		 
A4: ALU_Barrel_Shifter port map(   
			i_ALU_Shift => i_ALU_Shift,
			i_shamt => i_shamt,
			i_rl => i_rl,
			i_al => i_al,
			i_ALU_input_A => o_rData1,
			i_ALU_input_B => MUX_Output,
			i_control => i_ALU_control,
			o_ALU_output => sum,
			o_carry_out => o_carry_out,
			o_overflow=> o_overflow,
			o_zero => o_zero);


A5: mem port map(clk => i_CLK,
		 addr => sum(11 downto 2),
		 data => o_rData2,
		 we => i_memWE,
		 q => MEM_Output);

A6: MUX_dataflow port map(i_X => MEM_Output,
		 i_Y => sum,
		 i_S => i_mem_to_reg,
		 o_F => MEM_MUX_Output);

A7:  o_output <= MEM_MUX_Output;

end structural;




