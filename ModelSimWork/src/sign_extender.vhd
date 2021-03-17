library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is
      port( i_In : in std_logic_vector(15 downto 0);
	    i_zeroextend : in std_logic;
            o_Out : out std_logic_vector(31 downto 0));
end sign_extender;

architecture dataflow of sign_extender is
begin

A1: for i in 0 to 15 generate
    o_Out(i) <= i_In(i);
end generate;

A2: for i in 16 to 31 generate
    o_Out(i) <= i_In(15) and (not i_zeroextend);
end generate;


end dataflow;