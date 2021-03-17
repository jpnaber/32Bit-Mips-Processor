library IEEE;
use IEEE.std_logic_1164.all;

entity dffNbit is
    generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end dffNbit;	

architecture structure of dffNbit is

component dffgate
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

begin

-- We loop through and instantiate and connect N andg2 modules
G1: for i in 0 to N-1 generate
  ndff: dffgate 
    port map(i_CLK  => i_CLK,
             i_RST  => i_RST,
	      i_WE  => i_WE,
	       i_D  => i_D(i),
  	       o_Q  => o_Q(i));
end generate;
  
end structure;