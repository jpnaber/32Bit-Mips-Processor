library IEEE;
use IEEE.std_logic_1164.all;

entity MUX_dataflow is
  generic(N : integer := 16);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end MUX_dataflow;

architecture dataflow of MUX_dataflow is

  signal temp  : std_logic_vector(N-1 downto 0);
  signal temp2  : std_logic_vector(N-1 downto 0);
  signal inverted_S : std_logic;

begin

--1 Selects Y
U1: for i in 0 to N-1 generate
  and_i: temp(i) <= i_Y(i) and i_S;
end generate;

U2: inverted_S <= not i_S;

--0 selects X
U3: for i in 0 to N-1 generate
  and_i: temp2(i) <= i_X(i) and inverted_S;
end generate;

U4: for i in 0 to N-1 generate
  and_i: o_F(i) <= temp(i) or temp2(i);
end generate;
  
end dataflow;