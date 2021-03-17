library IEEE;
use IEEE.std_logic_1164.all;

entity five_bit_mux is
  port(i_S	: in std_logic;
       i_A 	: in std_logic_vector(4 downto 0);
       i_B 	: in std_logic_vector(4 downto 0);
       o_output  : out std_logic_vector(4 downto 0));

end five_bit_mux;

architecture dataflow of five_bit_mux is

signal inverted_S : std_logic;
signal A : std_logic_vector(4 downto 0);
signal B : std_logic_vector(4 downto 0);

begin

A0: inverted_S <= not i_S; 
A1: for i in 0 to 4 generate
	A1: A(i) <= i_A(i) and inverted_S;
    end generate;
A2: for i in 0 to 4 generate
	A2: B(i) <= i_B(i) and i_S;
    end generate;
A3: for i in 0 to 4 generate
	A3: o_output(i) <= A(i) or B(i);
    end generate;


end dataflow;