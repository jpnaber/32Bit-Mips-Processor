library IEEE;
use IEEE.std_logic_1164.all;

entity B_inverter is
  port(i_B  : in std_logic_vector(31 downto 0);
       o_Out  : out std_logic_vector(31 downto 0));

end B_inverter;

architecture dataflow of B_inverter is

signal temp, temp1, temp2 : std_logic_vector(31 downto 0);
signal insign : std_logic;

begin

U1: insign <= not i_B(31);
U4: for i in 0 to 31 generate
	X1: temp(i) <= not i_B(i);
    end generate;

U5: for i in 0 to 31 generate
	X1: temp1(i) <= i_B(31) and temp(i); 
	X2: temp2(i) <= insign and i_B(i);
	X3: o_Out(i) <= temp1(i) or temp2(i);
    end generate;


end dataflow;