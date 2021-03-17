library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



-- If stall == 1, the register will not be able to be written to
-- If Flush == 1, the register's will be cleared


entity IF_ID_Register is port(
	i_clock 		: in std_logic;				--Clock
	i_flush 		: in std_logic;        			--Reset
	i_stall 		: in std_logic;				--Write data
	i_instruction 		: in std_logic_vector(31 downto 0);	--Input Instruction
	i_pcPlusFour 		: in std_logic_vector(31 downto 0);	--Input PC+4
	o_instruction 		: out std_logic_vector(31 downto 0);	--Output Instruction
	o_pcPlusFour 		: out std_logic_vector(31 downto 0));	--Output PC+4
end IF_ID_Register;

architecture mixed of IF_ID_Register is

component dffNbit
  generic (N : integer);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;	

signal notstall : std_logic;

begin

A0: notstall <= not i_stall;

--Mips 32 bit Instruction register
A1: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_instruction,
       		     o_Q => o_instruction);

--PC+4 Register
A2: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_pcPlusFour,
       		     o_Q => o_pcPlusFour);

end mixed;