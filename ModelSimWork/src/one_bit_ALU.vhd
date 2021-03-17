library IEEE;
use IEEE.std_logic_1164.all;

entity one_bit_ALU is
  port(i_A,i_B,i_Cin  : in std_logic;
       i_select : std_logic_vector(2 downto 0);
       o_Out,o_Cout  : out std_logic);

end one_bit_ALU;

architecture structure of one_bit_ALU is

  signal o_output : std_logic_vector(7 downto 0);
  signal o_carry : std_logic_vector(7 downto 0);
  signal not_b, not_a : std_logic;
  signal and_out, or_out : std_logic;
  

  component Full_Adder_Structural
  port(i_A,i_B,i_Cin  : in std_logic;
       o_S,o_Cout  : out std_logic);

  end component;

component Full_Subtractor
  port(i_A,i_B,i_Bin  : in std_logic;
       o_S,o_Cout  : out std_logic);

 end component;

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
  
  component invg
  port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;

  component eight_to_one_mux
  port(i_select_bits  : in std_logic_vector(2 downto 0);
       i_input : in std_logic_vector(7 downto 0);
       o_output  : out std_logic);
  end component;

begin


A2: Full_Subtractor port map(i_A => i_A,
			     i_B => i_B,
			     i_Bin => i_Cin,
                             o_S => o_output(0),
		  	     o_Cout => o_carry(0));

A3: Full_Adder_Structural port map(i_A => i_A,
				   i_B => i_B,
				   i_Cin => i_Cin,
                                   o_S => o_output(1),
				   o_Cout => o_carry(1));

A4: org2 port map(i_A => i_A,
   		  i_B => i_B,
       		  o_F => o_output(2));

A5: o_carry(2) <= '0';

A6: andg2 port map(i_A => i_A,
   		   i_B => i_B,
       		    o_F => o_output(3));
A7: o_carry(3) <= '0';

A8: andg2 port map(i_A => i_A,
   		   i_B => i_B,
       		   o_F => and_out);
A9: invg port map(i_A => and_out,
 		  o_F => o_output(4));
A10: o_carry(4) <= '0';

A11: xorg2 port map(i_A => i_A,
   		    i_B => i_B,
       		    o_F => o_output(5));
A12: o_carry(5) <= '0';

A13: org2 port map(i_A => i_A,
   		   i_B => i_B,
       		    o_F => or_out);
A14: invg port map(i_A => or_out,
 		   o_F => o_output(6));
A15: o_carry(6) <= '0';


A16: invg port map(i_A => i_A,
                  o_F => not_a);
A17: andg2 port map(i_A => not_a,
   		    i_B => i_B,
       		    o_F => o_output(7));
A18: o_carry(7) <= '0';


A19: eight_to_one_mux port map(i_select_bits => i_select,
       i_input => o_output,
       o_output => o_Out);

A20: eight_to_one_mux port map(i_select_bits => i_select,
       i_input => o_carry,
       o_output => o_Cout);


end structure;






