library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



-- If stall == 1, the register will not be able to be written to
-- If Flush == 1, the register's will be cleared


entity EX_MEM_Register is port(
	i_clock 		: in std_logic;				--Clock
	i_flush 		: in std_logic;        			--Reset
	i_stall 		: in std_logic;				--Write data
	i_ALU_out 		: in std_logic_vector(31 downto 0);	--Input ALU
	i_REG_B_out 		: in std_logic_vector(31 downto 0);	--Input rt read data
	i_Next_PC		: in std_logic_vector(31 downto 0);	--Input PC+4
	i_LUIimmediate		: in std_logic_vector(31 downto 0);
	i_mem_to_reg, i_LUI	: in std_logic;
	i_memWE			: in std_logic;
	i_regWriteAddress	: in std_logic_vector(4 downto 0);
	i_regWrEnable		: in std_logic;
	i_instruction 		: in std_logic_vector(31 downto 0);
	o_instruction		: out std_logic_vector(31 downto 0);	
	o_regWrEnable		: out std_logic;
	o_regWriteAddress	: out std_logic_vector(4 downto 0);
	o_memWE			: out std_logic;
	o_ALU_out 		: out std_logic_vector(31 downto 0);	--Input ALU
	o_REG_B_out 		: out std_logic_vector(31 downto 0);	--Input rt read data
	o_Next_PC		: out std_logic_vector(31 downto 0);	--Input PC+4
	o_LUIimmediate		: out std_logic_vector(31 downto 0);
	o_mem_to_reg, o_LUI	: out std_logic);
end EX_MEM_Register;

architecture mixed of EX_MEM_Register is

component dffNbit
  generic (N : integer);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;	

component dffgate
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end component;

signal notstall : std_logic;

begin

A0: notstall <= not i_stall;

A1: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_ALU_out,
       		     o_Q => o_ALU_out);

A2: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_REG_B_out,
       		     o_Q => o_REG_B_out);

A3: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_Next_PC,
       		     o_Q => o_Next_PC);


A4: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_mem_to_reg,
             o_Q => o_mem_to_reg);

A5: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_LUI,
             o_Q => o_LUI);

A6: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_memWE,
             o_Q => o_memWE);

A7: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_LUIimmediate,
       		     o_Q => o_LUIimmediate);

A8: dffNbit 
    generic map(N => 5)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_regWriteAddress,
       		     o_Q => o_regWriteAddress);

A9: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_regWrEnable,
             o_Q => o_regWrEnable);
			 
A10: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_instruction,
       		     o_Q => o_instruction);


end mixed;