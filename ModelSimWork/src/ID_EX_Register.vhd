library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



-- If stall == 1, the register will not be able to be written to
-- If Flush == 1, the register's will be cleared


entity ID_EX_Register is port(
	i_clock 		: in std_logic;				--Clock
	i_flush 		: in std_logic;        			--Reset
	i_stall 		: in std_logic;				--Write data
	i_mem_to_reg, i_LUI	: in std_logic;				--Control Signals for next stage
	i_memWE, i_branch	: in std_logic;		
	i_jump, i_jr		: in std_logic;
	i_ALU_Control_Bits	: in std_logic_vector(4 downto 0);
	i_shiftVariable		: in std_logic;
	i_ALU_shift, i_ALUSrc	: in std_logic;
	i_REG_A_out		: in std_logic_vector(31 downto 0);	--ALU A output
	i_REG_B_out		: in std_logic_vector(31 downto 0);	--ALU B ouptut
	i_immediate		: in std_logic_vector(31 downto 0);	--Input Immediate
	i_pcPlusFour 		: in std_logic_vector(31 downto 0);	--Input PC+4
	i_inst25_0		: in std_logic_vector(25 downto 0);
	i_LUIimmediate		: in std_logic_vector(31 downto 0);
	i_inst31_26		: in std_logic_vector(5 downto 0);
	i_inst10_6		: in std_logic_vector(4 downto 0);
	i_regWriteAddress	: in std_logic_vector(4 downto 0);
	i_regWrEnable		: in std_logic;
	i_instruction 		: in std_logic_vector(31 downto 0);
	o_instruction		: out std_logic_vector(31 downto 0);	
	o_regWrEnable		: out std_logic;
	o_regWriteAddress	: out std_logic_vector(4 downto 0);
	o_inst31_26		: out std_logic_vector(5 downto 0);
	o_inst25_0		: out std_logic_vector(25 downto 0);
	o_LUIimmediate		: out std_logic_vector(31 downto 0);
	o_inst10_6		: out std_logic_vector(4 downto 0);
	o_immediate 		: out std_logic_vector(31 downto 0);	--Output Instruction
	o_pcPlusFour 		: out std_logic_vector(31 downto 0);
	o_mem_to_reg, o_LUI	: out std_logic;				--Control Signals for next stage
	o_memWE, o_branch	: out std_logic;		
	o_jump, o_jr		: out std_logic;		
	o_REG_A_out		: out std_logic_vector(31 downto 0);	--ALU A output
	o_REG_B_out		: out std_logic_vector(31 downto 0);	--ALU B ouptut
	o_ALU_Control_Bits	: out std_logic_vector(4 downto 0);
	o_shiftVariable 	: out std_logic;
	o_ALU_shift		: out std_logic;
	o_ALUsrc		: out std_logic);
end ID_EX_Register;

architecture mixed of ID_EX_Register is

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
      		     i_D => i_immediate,
       		     o_Q => o_immediate);

B1: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_REG_A_out,
       		     o_Q => o_REG_A_out);

B2: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_REG_B_out,
       		     o_Q => o_REG_B_out);

A2: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_pcPlusFour,
       		     o_Q => o_pcPlusFour);

A3: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_mem_to_reg,
             o_Q => o_mem_to_reg);

A4: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_LUI,
             o_Q => o_LUI);

A5: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_memWE,
             o_Q => o_memWE);

A6: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_branch,
             o_Q => o_branch);


A7: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_jump,
             o_Q => o_jump);

A8: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_jr,
             o_Q => o_jr);

A9: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_shiftVariable,
             o_Q => o_shiftVariable);

A10: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_ALU_shift,
             o_Q => o_ALU_shift);

A11: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_ALUsrc,
             o_Q => o_ALUsrc);

A12: dffNbit 
    generic map(N => 5)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_ALU_Control_Bits,
       		     o_Q => o_ALU_Control_Bits);

A13: dffNbit 
    generic map(N => 5)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_inst10_6,
       		     o_Q => o_inst10_6);

A14: dffNbit 
    generic map(N => 26)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_inst25_0,
       		     o_Q => o_inst25_0);

A15: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_LUIimmediate,
       		     o_Q => o_LUIimmediate);

A16: dffNbit 
    generic map(N => 6)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_inst31_26,
       		     o_Q => o_inst31_26);

A17: dffNbit 
    generic map(N => 5)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_regWriteAddress,
       		     o_Q => o_regWriteAddress);

A18: dffgate
    port map(i_CLK => i_clock,
             i_RST => i_flush,
             i_WE => notstall,
             i_D => i_regWrEnable,
             o_Q => o_regWrEnable);
			 
A19: dffNbit 
    generic map(N => 32)
    port map(i_CLK => i_clock,
       		     i_RST => i_flush,
      		     i_WE => notstall,
      		     i_D => i_instruction,
       		     o_Q => o_instruction);
end mixed;