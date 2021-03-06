library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_Barrel_Shifter is
   port(i_ALU_Shift : in std_logic; --0 = ALU output, 1 = shift output
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

end ALU_Barrel_Shifter;

architecture structure of ALU_Barrel_Shifter is

component Barrel_Shifter
  port(i_data_input  : in std_logic_vector(31 downto 0); 
       i_shamt  : in std_logic_vector(4 downto 0); 
       i_rl : in std_logic; --0 = left shift, 1 = right shift
       i_al : in std_logic; --0 = logical, 1 = arithmetic
       o_data_output  : out std_logic_vector(31 downto 0));
end component Barrel_Shifter;

component ALU_32_bit
   port(i_A, i_B    :  in std_logic_vector(31 downto 0);
	i_control   :  in std_logic_vector(2  downto 0);
	i_Cin		   : in std_logic;
	o_F         : out std_logic_vector(31 downto 0);
	o_carry_out : out std_logic;
	o_overflow  : out std_logic;
	o_zero	    : out std_logic);
end component ALU_32_bit;

component MUX_dataflow
  generic(N : integer := 32);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

component five_bit_mux
  port(i_S	: in std_logic;
       i_A 	: in std_logic_vector(4 downto 0);
       i_B 	: in std_logic_vector(4 downto 0);
       o_output  : out std_logic_vector(4 downto 0));
end component;

component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

signal shift_out, ALU_out, input_B : std_logic_vector(31 downto 0);
signal carry  : std_logic;
begin


A1: Barrel_Shifter port map(    i_data_input => i_ALU_input_B,
				     i_shamt => i_shamt,
				        i_rl => i_rl,
				        i_al => i_al,
			       o_data_output => shift_out);

A2: ALU_32_bit port map(       i_A => i_ALU_input_A,
			       i_B => i_ALU_input_B,
			 i_control => i_control,
				i_Cin => '0',
			       o_F => ALU_out,
			o_carry_out => carry,
			o_overflow => o_overflow,
			    o_zero => o_zero);

A3: MUX_dataflow port map(i_X => ALU_out,
			  i_Y => shift_out,
       			  i_S => i_ALU_Shift,
      			  o_F => o_ALU_output);
A4: o_carry_out <= carry;

end structure;
			   
       

