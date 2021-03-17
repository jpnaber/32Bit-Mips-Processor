library IEEE;
use IEEE.std_logic_1164.all;

entity alu_32_bit is
   port(i_A, i_B    :  in std_logic_vector(31 downto 0);
	i_control   :  in std_logic_vector(2  downto 0);
	i_Cin		: in std_logic;
	o_F         : out std_logic_vector(31 downto 0);
	o_carry_out : out std_logic;
	o_overflow  : out std_logic;
	o_zero	    : out std_logic);

end alu_32_bit;

architecture structure of alu_32_bit is

component one_bit_alu
   port(i_A      : in  std_logic;
	i_B      : in  std_logic;
	i_Cin    : in  std_logic;
	i_select : in  std_logic_vector(2 downto 0);
	o_Out    : out std_logic;
	o_Cout	 : out std_logic);
   end component;
component andg2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
  end component;

  component zero_check
  port(i_A  :  in  std_logic_vector(31 downto 0);
       o_F  :  out std_logic);
  end component;

  component Overflow
  port(i_A : in std_logic_vector(31 downto 0);
       i_B : in std_logic_vector(31 downto 0);
       i_Z : in std_logic_vector(31 downto 0);
       o_F : out std_logic);
  end component;

   component eight_to_one_mux
   port(i_select_bits  :  in std_logic_vector(2 downto 0);
        i_input        :  in std_logic_vector(7 downto 0);
        o_output       : out std_logic);
   end component;

   component two_to_one_mux
   port(i_select_bits  :  in std_logic_vector(2 downto 0);
        i_A, i_B       :  in std_logic;
        o_output       : out std_logic);
   end component;

   component two_one_mux_7
   port(i_select_bits  :  in std_logic_vector(2 downto 0);
        i_A, i_B       :  in std_logic;
        o_output       : out std_logic);
   end component;

   component slt_function
   port(i_A : in std_logic_vector(31 downto 0);
	i_B : in std_logic_vector(31 downto 0);
	i_select : in std_logic_vector(2 downto 0);
	o_F : out std_logic_vector(31 downto 0));
   end component;


signal o_output : std_logic_vector(31 downto 0);
signal carry    : std_logic_vector(32 downto 0);
signal slt      : std_logic_vector(31 downto 0);

begin


A1: carry(0) <= i_Cin;

A2: for i in 0 to 31 generate
    and_i : one_bit_ALU port map(i_A => i_A(i),
				 i_B => i_B(i),
				 i_Cin => carry(i),
				 i_select => i_control,
				 o_Out  => o_output(i),
				 o_Cout => carry(i+1));
    end generate;

A3: zero_check port map(i_A => o_output,
	 	        o_F => o_zero);

A4: Overflow port map(i_A => i_A,
		      i_B => i_B,
	     	      i_Z => o_output,
	     	      o_F => o_overflow);

A6: slt_function port map(i_A => i_A,
			  i_B => i_B,
			  i_select => i_control,
			  o_F => slt);

A8: for i in 0 to 31 generate
    and_i : two_one_mux_7 port map(i_select_bits => i_control, --if contrl =7, replace o_F with proper slt 
			     i_A => o_output(i),
			     i_B => slt(i),
			     o_output => o_F(i));
    end generate;

A9: o_carry_out <= carry(32);

end structure;



