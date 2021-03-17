library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decode32 is
port(
	i_in  : in std_logic_vector(4 downto 0);
	i_en  : in std_logic;
	o_out : out std_logic_vector(31 downto 0));
end decode32;

architecture dataflow of decode32 is
begin
--o_out <= (to_integer(unsigned(i_in))   => '1', others => '0');
process(i_in,i_en)
begin
o_out <= "00000000000000000000000000000000";
if(i_en = '1') then
case i_in is
when "00000" => o_out(0) <= '1';
when "00001" => o_out(1) <= '1';
when "00010" => o_out(2) <= '1';
when "00011" => o_out(3) <= '1';
when "00100" => o_out(4) <= '1';
when "00101" => o_out(5) <= '1';
when "00110" => o_out(6) <= '1';
when "00111" => o_out(7) <= '1';
when "01000" => o_out(8) <= '1';
when "01001" => o_out(9) <= '1';
when "01010" => o_out(10) <= '1';
when "01011" => o_out(11) <= '1';
when "01100" => o_out(12) <= '1';
when "01101" => o_out(13) <= '1';
when "01110" => o_out(14) <= '1';
when "01111" => o_out(15) <= '1';
when "10000" => o_out(16) <= '1';
when "10001" => o_out(17) <= '1';
when "10010" => o_out(18) <= '1';
when "10011" => o_out(19) <= '1';
when "10100" => o_out(20) <= '1';
when "10101" => o_out(21) <= '1';
when "10110" => o_out(22) <= '1';
when "10111" => o_out(23) <= '1';
when "11000" => o_out(24) <= '1';
when "11001" => o_out(25) <= '1';
when "11010" => o_out(26) <= '1';
when "11011" => o_out(27) <= '1';
when "11100" => o_out(28) <= '1';
when "11101" => o_out(29) <= '1';
when "11110" => o_out(30) <= '1';
when "11111" => o_out(31) <= '1';
when others => o_out <= "00000000000000000000000000000001";
end case; 
end if;
end process;
end dataflow;
