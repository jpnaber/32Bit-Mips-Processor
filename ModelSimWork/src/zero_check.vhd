library IEEE;
use IEEE.std_logic_1164.all;

entity zero_check is
   port(i_A : in std_logic_vector(31 downto 0);
	o_F : out std_logic);

end zero_check;

architecture behavioral of zero_check is

begin
with i_A select
	o_F <= '1' when "00000000000000000000000000000000",
	       '0' when others;
end behavioral;

   
