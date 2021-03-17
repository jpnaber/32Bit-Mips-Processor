library IEEE;
use IEEE.std_logic_1164.all;

entity Full_Adder_Dataflow_N_Bit is
  generic(N : integer := 32);
  port(i_A,i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic;
       o_S  : out std_logic_vector(N-1 downto 0);
       o_Cout  : out std_logic);

end Full_Adder_Dataflow_N_Bit;

architecture structure of Full_Adder_Dataflow_N_Bit is

  signal temp  : std_logic_vector(N downto 0);

begin
U2: temp(0) <= i_Cin;
U3: o_Cout <= temp(N);
U4: for i in 0 to N-1 generate
  X1: o_S(i) <= temp(i) xor (i_A(i) xor i_B(i));
  X2: temp(i+1) <= (i_B(i) and temp(i)) or (i_A(i) and i_B(i)) or (i_A(i) and temp(i));
end generate;

U5: o_Cout <= temp(N);

end structure;