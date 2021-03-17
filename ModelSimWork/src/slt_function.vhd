library IEEE;
use IEEE.std_logic_1164.all;

entity slt_function is
   port(i_A : in std_logic_vector(31 downto 0);
	i_B : in std_logic_vector(31 downto 0);
	i_select : in std_logic_vector(2 downto 0);
	o_F : out std_logic_vector(31 downto 0));
end slt_function;

architecture structure of slt_function is

signal carry : std_logic_vector(32 downto 0);
signal output: std_logic_vector(31 downto 0);

component one_bit_ALU
   port(i_A,i_B,i_Cin  : in std_logic;
        i_select : std_logic_vector(2 downto 0);
        o_Out,o_Cout  : out std_logic);
end component;

component andg2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
  end component;

begin

A1: carry(0) <= '0';

A2: for i in 0 to 31 generate
    and_i : one_bit_ALU port map(i_A  => i_A(i), -- A-B
			         i_B  => i_B(i),
				 i_Cin => carry(i),
				 i_select => "000",
				 o_Out => output(i),
				 o_Cout => carry(i+1));
    end generate;

A3: andg2 port map(i_A => output(31), -- A-B< 0
		   i_B => '1',
		   o_F => o_F(0));

A4: for i in 1 to 31 generate
    and_i : andg2 port map(i_A => output(i), --add zeros
			   i_B => '0',
			   o_F => o_F(i));
    end generate;

end structure;

