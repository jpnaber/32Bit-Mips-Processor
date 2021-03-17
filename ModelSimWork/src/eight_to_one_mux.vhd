library IEEE;
use IEEE.std_logic_1164.all;

entity eight_to_one_mux is
  port(i_select_bits  : in std_logic_vector(2 downto 0);
       i_input : in std_logic_vector(7 downto 0);
       o_output  : out std_logic);

end eight_to_one_mux;

architecture behavioral of eight_to_one_mux is

begin
with i_select_bits select
    o_output <= i_input(0) when "000",
         	i_input(1) when "001",
         	i_input(2) when "010",
         	i_input(3) when "011",
         	i_input(4) when "100",
         	i_input(5) when "101",
         	i_input(6) when "110",
         	i_input(7) when "111",
         	'0'  when others;
end behavioral;