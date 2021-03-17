library IEEE;
use IEEE.std_logic_1164.all;

entity two_to_one_mux is
  port(i_select_bits  : in std_logic_vector(2 downto 0);
       i_A 	: in std_logic;
       i_B 	: in std_logic;
       o_output  : out std_logic);

end two_to_one_mux;

architecture behavioral of two_to_one_mux is

begin
with i_select_bits select
    o_output <= i_A when "000",
         	i_B when "001",
         	'0'  when others;
end behavioral;
