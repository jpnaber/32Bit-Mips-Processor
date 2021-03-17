library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4to32 is
port(
i_in0   : in std_logic_vector(31 downto 0);
i_in1   : in std_logic_vector(31 downto 0);
i_in2   : in std_logic_vector(31 downto 0);
i_in3   : in std_logic_vector(31 downto 0);
i_in4   : in std_logic_vector(31 downto 0);
i_in5   : in std_logic_vector(31 downto 0);
i_in6   : in std_logic_vector(31 downto 0);
i_in7   : in std_logic_vector(31 downto 0);
i_in8   : in std_logic_vector(31 downto 0);
i_in9   : in std_logic_vector(31 downto 0);
i_in10  : in std_logic_vector(31 downto 0);
i_in11  : in std_logic_vector(31 downto 0);
i_in12  : in std_logic_vector(31 downto 0);
i_in13  : in std_logic_vector(31 downto 0);
i_in14  : in std_logic_vector(31 downto 0);
i_in15  : in std_logic_vector(31 downto 0);
i_in16  : in std_logic_vector(31 downto 0);
i_in17  : in std_logic_vector(31 downto 0);
i_in18  : in std_logic_vector(31 downto 0);
i_in19  : in std_logic_vector(31 downto 0);
i_in20  : in std_logic_vector(31 downto 0);
i_in21  : in std_logic_vector(31 downto 0);
i_in22  : in std_logic_vector(31 downto 0);
i_in23  : in std_logic_vector(31 downto 0);
i_in24  : in std_logic_vector(31 downto 0);
i_in25  : in std_logic_vector(31 downto 0);
i_in26  : in std_logic_vector(31 downto 0);
i_in27  : in std_logic_vector(31 downto 0);
i_in28  : in std_logic_vector(31 downto 0);
i_in29  : in std_logic_vector(31 downto 0);
i_in30  : in std_logic_vector(31 downto 0);
i_in31  : in std_logic_vector(31 downto 0);
i_sel   : in std_logic_vector(04 downto 0);
o_out   : out std_logic_vector(31 downto 0));
end mux4to32;

architecture dataflow of mux4to32 is
	
begin
process (i_sel, i_in0, i_in1, i_in2, i_in3, i_in4, i_in5, i_in6, i_in7, i_in8, i_in9, i_in10, i_in11, i_in12, i_in13, i_in14, i_in15, i_in16, i_in17, i_in18, i_in19, i_in20, i_in21, i_in22, i_in23, i_in24, i_in25, i_in26, i_in27, i_in28, i_in29, i_in30, i_in31)
begin
if i_sel = std_logic_vector(to_unsigned(0,5)) then 
	o_out <= i_in0;
elsif i_sel = std_logic_vector(to_unsigned(1,5)) then
	o_out <= i_in1;
elsif i_sel = std_logic_vector(to_unsigned(2,5)) then
	o_out <= i_in2;
elsif i_sel = std_logic_vector(to_unsigned(3,5)) then
	o_out <= i_in3;
elsif i_sel = std_logic_vector(to_unsigned(4,5)) then
	o_out <= i_in4;
elsif i_sel = std_logic_vector(to_unsigned(5,5)) then
	o_out <= i_in5;
elsif i_sel = std_logic_vector(to_unsigned(6,5)) then
	o_out <= i_in6;
elsif i_sel = std_logic_vector(to_unsigned(7,5)) then
	o_out <= i_in7;
elsif i_sel = std_logic_vector(to_unsigned(08,5)) then
	o_out <= i_in8;
elsif i_sel = std_logic_vector(to_unsigned(09,5)) then
	o_out <= i_in9;
elsif i_sel = std_logic_vector(to_unsigned(10,5)) then
	o_out <= i_in10;
elsif i_sel = std_logic_vector(to_unsigned(11,5)) then
	o_out <= i_in11;
elsif i_sel = std_logic_vector(to_unsigned(12,5)) then
	o_out <= i_in12;
elsif i_sel = std_logic_vector(to_unsigned(13,5)) then
	o_out <= i_in13;
elsif i_sel = std_logic_vector(to_unsigned(14,5)) then
	o_out <= i_in14;
elsif i_sel = std_logic_vector(to_unsigned(15,5)) then
	o_out <= i_in15;
elsif i_sel = std_logic_vector(to_unsigned(16,5)) then
	o_out <= i_in16;
elsif i_sel = std_logic_vector(to_unsigned(17,5)) then
	o_out <= i_in17;
elsif i_sel = std_logic_vector(to_unsigned(18,5)) then
	o_out <= i_in18;
elsif i_sel = std_logic_vector(to_unsigned(19,5)) then
	o_out <= i_in19;
elsif i_sel = std_logic_vector(to_unsigned(20,5)) then
	o_out <= i_in20;
elsif i_sel = std_logic_vector(to_unsigned(21,5)) then
	o_out <= i_in21;
elsif i_sel = std_logic_vector(to_unsigned(22,5)) then
	o_out <= i_in22;
elsif i_sel = std_logic_vector(to_unsigned(23,5)) then
	o_out <= i_in23;
elsif i_sel = std_logic_vector(to_unsigned(24,5)) then
	o_out <= i_in24;
elsif i_sel = std_logic_vector(to_unsigned(25,5)) then
	o_out <= i_in25;
elsif i_sel = std_logic_vector(to_unsigned(26,5)) then
	o_out <= i_in26;
elsif i_sel = std_logic_vector(to_unsigned(27,5)) then
	o_out <= i_in27;
elsif i_sel = std_logic_vector(to_unsigned(28,5)) then
	o_out <= i_in28;
elsif i_sel = std_logic_vector(to_unsigned(29,5)) then
	o_out <= i_in29;
elsif i_sel = std_logic_vector(to_unsigned(30,5)) then
	o_out <= i_in30;
else    o_out <= i_in31;
end if;
end process;
end dataflow;

