library IEEE;
use IEEE.std_logic_1164.all;

entity Full_Subtractor is
  port(i_A,i_B,i_Bin  : in std_logic;
       o_S,o_Cout  : out std_logic);

end Full_Subtractor;

architecture dataflow of Full_Subtractor is

  signal and1,and2,and3,xor1,or1 : std_logic;

begin

A1: o_S <= (i_A xor i_B) xor i_Bin;
A2: o_Cout <= ((not i_A) and (i_B or i_Bin)) or (i_B and i_Bin); 

  
end dataflow;