library IEEE;
use IEEE.std_logic_1164.all;

entity two_one_mux_7 is
  port(i_select_bits  : in std_logic_vector(2 downto 0);
       i_A : in std_logic;
       i_B : in std_logic;
       o_output  : out std_logic);

end two_one_mux_7;

architecture behavioral of two_one_mux_7 is

begin
with i_select_bits select
    o_output <= i_B when "111",
         	i_A  when others;
end behavioral;
