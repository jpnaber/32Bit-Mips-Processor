library IEEE;
use IEEE.std_logic_1164.all;

package MIPS_package is
	type arr is array (31 downto 0) of std_logic_vector (31 downto 0);
end package MIPS_package;

library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_package.all;

entity eight_to_one_MUX_32_bit is
port(	i_A : in arr;
	i_S : in std_logic_vector(2 downto 0);
	o_F : out std_logic_vector(31 downto 0));

end eight_to_one_MUX_32_bit;

architecture behavioral of eight_to_one_MUX_32_bit is

begin
with i_S select
    o_F <= i_A(0) when "000",
         	i_A(1) when "001",
         	i_A(2) when "010",
         	i_A(3) when "011",
         	i_A(4) when "100",
         	i_A(5) when "101",
         	i_A(6) when "110",
         	i_A(7) when "111",
         	"00000000000000000000000000000000"  when others;
end behavioral;
