library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_package.all;

entity Overflow is
   port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
	i_Z : in std_logic_vector(31 downto 0);
	o_F : out std_logic);
end Overflow;

architecture structure of Overflow is

signal and_ab : std_logic;
signal and_az : std_logic;
signal not_az : std_logic;

component andg2
  port(i_A : in std_logic;
       i_B : in std_logic;
       o_F : out std_logic);
end component;

component invg
  port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;

begin

A1: andg2 port map(i_A => i_A (31),
		   i_B => i_B (31),
		   o_F => and_ab);

A2: andg2 port map(i_A => i_A (31),
		   i_B => i_Z (31),
		   o_F => and_az);

A3: invg port map(i_A => and_az,
		  o_F => not_az);


A4: andg2 port map(i_A => and_ab,
		   i_B => not_az,
		   o_F => o_F);

end structure;