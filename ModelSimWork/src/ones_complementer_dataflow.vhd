library IEEE;
use IEEE.std_logic_1164.all;

entity ones_complementer_dataflow is
  generic(N : integer := 32);
  port(i_B  : in std_logic_vector(N-1 downto 0);
       o_G  : out std_logic_vector(N-1 downto 0));

end ones_complementer_dataflow;

architecture dataflow of ones_complementer_dataflow is
begin

-- We loop through and instantiate and connect N andg2 modules
G1: for i in 0 to N-1 generate
  and_i: o_G(i) <= not i_B(i);
end generate;

  
end dataflow;