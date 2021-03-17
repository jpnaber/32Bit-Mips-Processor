library IEEE;
use IEEE.std_logic_1164.all;

entity Full_Adder_Structural is
  port(i_A,i_B,i_Cin  : in std_logic;
       o_S,o_Cout  : out std_logic);

end Full_Adder_Structural;

architecture structure of Full_Adder_Structural is

  signal and1,and2,and3,xor1,or1 : std_logic;

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

component xorg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

begin

U1: xorg2 port map(i_A => i_A, 
		   i_B => i_B, 
                   o_F => xor1);
 
U2: xorg2 port map(i_A => xor1, 
	           i_B => i_Cin,
		   o_F => o_S);

U3: andg2 port map(i_A => i_A, 
	  	   i_B => i_B, 
		   o_F => and1);
U4: andg2 port map(i_A => i_A, 
	  	   i_B => i_Cin, 
		   o_F => and2);
U5: andg2 port map(i_A => i_B, 
	  	   i_B => i_Cin, 
		   o_F => and3);

U6: org2 port map(i_A => and1,
		  i_B => and2,
		  o_F => or1);

U7: org2 port map(i_A => or1,
		  i_B => and3,
		  o_F => o_Cout);

  
end structure;