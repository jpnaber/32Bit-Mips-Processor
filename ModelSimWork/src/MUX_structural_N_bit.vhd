library IEEE;
use IEEE.std_logic_1164.all;

entity MUX_structural_N_bit is
  generic(N : integer := 32);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end MUX_structural_N_bit;

architecture structure of MUX_structural_N_bit is

  signal temp  : std_logic_vector(N-1 downto 0);
  signal temp2  : std_logic_vector(N-1 downto 0);
  signal inverted_S : std_logic;

component andg2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
end component;

component org2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
end component;

component invg
  port(i_A  : in std_logic;
       o_F  : out std_logic);
end component;

begin

U1: invg port map(i_A => i_S, 
	          o_F => inverted_S);

U2: for i in 0 to N-1 generate
  and_i: andg2 port map(i_A  => i_X(i),
                        i_B  => inverted_S,
  	                o_F  => temp(i));
end generate;
 

U3: for i in 0 to N-1 generate
  and_i: andg2 port map(i_A => i_S, 
	  	        i_B => i_Y(i), 
		        o_F => temp2(i));
end generate;

U4: for i in 0 to N-1 generate
  and_i: org2 port map(i_A => temp(i),
		       i_B => temp2(i),
		       o_F => o_F(i));
end generate;

  
end structure;