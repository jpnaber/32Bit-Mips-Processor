library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pipeline_registers is
	port(s_CLK : std_logic;
	     s_flushIF, s_stallIF : in std_logic;
	     s_flushEX, s_stallEX : in std_logic;
	     s_flushMEM, s_stallMEM : in std_logic;
	     s_flushWB, s_stallWB : in std_logic;
	     instruction, pcplusfour : in std_logic_vector(31 downto 0)); 
	     
end tb_pipeline_registers;

architecture structure of tb_pipeline_registers is
  

component IF_ID_Register 
	port(
	i_clock 		: in std_logic;				--Clock
	i_flush 		: in std_logic;        			--Reset
	i_stall 		: in std_logic;				--Write data
	i_instruction 		: in std_logic_vector(31 downto 0);	--Input Instruction
	i_pcPlusFour 		: in std_logic_vector(31 downto 0);	--Input PC+4
	o_instruction 		: out std_logic_vector(31 downto 0);	--Output Instruction
	o_pcPlusFour 		: out std_logic_vector(31 downto 0));	--Output PC+4
end component;

component EX_MEM_Register 
	port(
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
end component;

component ID_EX_Register 
	port(
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
end component;


component MEM_WB_Register 
	port(
	i_clock 		: in std_logic;				--Clock
	i_flush 		: in std_logic;        			--Reset
	i_stall 		: in std_logic;				--Write data
	i_ALU_out 		: in std_logic_vector(31 downto 0);	--Input ALU
	i_MEM_out,i_LUIdata	: in std_logic_vector(31 downto 0);	--Input PC+4
	i_mem_to_reg, i_LUI	: in std_logic;
	i_regWriteAddress	: in std_logic_vector(4 downto 0);
	i_regWrEnable		: in std_logic;
	i_instruction 		: in std_logic_vector(31 downto 0);
	o_instruction		: out std_logic_vector(31 downto 0);	
	o_regWrEnable		: out std_logic;
	o_regWriteAddress	: out std_logic_vector(4 downto 0);
	o_ALU_out 		: out std_logic_vector(31 downto 0);	--Input ALU
	o_MEM_out,o_LUIdata	: out std_logic_vector(31 downto 0);	--Input PC+4
	o_mem_to_reg, o_LUI	: out std_logic);
end component;

signal s_instruction, s_pcPlusFour : std_logic_vector(31 downto 0);
signal o_instruction, o_pcPlusFour : std_logic_vector(31 downto 0);
signal EX_mem_to_reg, EX_LUI, EX_memWE, EX_branch, EX_jump, EX_jr, EX_shiftVariable, EX_ALU_shift, EX_ALUSrc, EX_regWrEnable : std_logic;
signal EX_ALU_Control_Bits, EX_regWrAddress : std_logic_vector(4 downto 0);
signal EX_REG_A_out, EX_REG_B_out, EX_immediate, EX_pcPlusFour, EX_LUIimmediate : std_logic_vector(31 downto 0);
signal EX_inst25_0 : std_logic_vector(25 downto 0);
signal EX_inst10_6 : std_logic_vector(4 downto 0);
signal EX_inst31_26 : std_logic_vector(5 downto 0);
signal MEM_memWE, MEM_mem_to_reg, MEM_LUI, MEM_regWrEnable : std_logic;
signal MEM_ALU_out, MEM_REG_B_out, MEM_Next_PC, MEM_LUIimmediate : std_logic_vector(31 downto 0);
signal MEM_regWrAddress, WB_regWriteAddress : std_logic_vector(4 downto 0);
signal WB_ALU_out, WB_MEM_out, WB_LUIdata : std_logic_vector(31 downto 0);
signal WB_mem_to_reg, WB_LUI, regWR : std_logic;
signal s_jump, s_branch, s_DmemWriteEnable : std_logic;
signal s_NextPC : std_logic_vector(31 downto 0);
signal EX_inst, MEM_inst, WB_inst, s_ALU_out : std_logic_vector(31 downto 0);

signal IF_instruction, IF_pcPlusFour, IFEX_instruction : std_logic_vector(31 downto 0);
signal o_regWrite : std_logic;
begin

fill_IF: 
	IF_ID_Register port map(
	i_clock => s_CLK,
	i_flush => s_flushIF,
	i_stall => s_stallIF,
	i_instruction => instruction,
	i_pcPlusFour => pcplusfour,
	o_instruction => IF_instruction,
	o_pcPlusFour => IF_pcPlusFour);

fill_EX:
	ID_EX_Register port map(
	i_clock => s_CLK,
	i_flush => s_flushEX,
	i_stall => s_stallEX,
	i_mem_to_reg => '0',
	i_LUI => '0',
	i_memWE => '0',
	i_branch => '0',
	i_jump => '0',
	i_jr => '0',
	i_ALU_Control_Bits => "00000",
	i_shiftVariable => '0',
	i_ALU_shift => '0',
	i_ALUSrc => '0',
	i_REG_A_out => X"11110000",
	i_REG_B_out => X"00000000",
	i_immediate => X"00000000",
	i_pcPlusFour => IF_pcPlusFour,
	i_inst25_0 => IF_instruction(25 downto 0),
	i_LUIimmediate => X"000F0000",
	i_inst31_26 => IF_instruction(31 downto 26),
	i_inst10_6 => IF_instruction(10 downto 6),
	i_regWriteAddress => "00000",
	i_regWrEnable => '0',
	i_instruction => IF_instruction,
	o_instruction => EX_inst,
	o_regWrEnable => EX_regWrEnable,
	o_regWriteAddress => EX_regWrAddress,
	o_inst31_26 => EX_inst31_26,
	o_inst25_0 => EX_inst25_0,
	o_LUIimmediate => EX_LUIimmediate,
	o_inst10_6 => EX_inst10_6,
	o_immediate => EX_immediate,
	o_pcPlusFour => EX_pcPlusFour,
	o_mem_to_reg => EX_mem_to_reg,
	o_LUI => EX_LUI,
	o_memWE => EX_memWE,
	o_branch => EX_branch,
	o_jump => EX_jump,
	o_jr => EX_jr,
	o_REG_A_out => EX_REG_A_out,
	o_REG_B_out => EX_REG_B_out,
	o_ALU_Control_Bits => EX_ALU_Control_Bits,
	o_shiftVariable => EX_shiftVariable,
	o_ALU_shift => EX_ALU_shift,
	o_ALUsrc => EX_ALUsrc);

EXMEM: EX_MEM_Register port map(
	i_clock => s_CLK,
	i_flush => s_flushMEM,
	i_stall => s_stallMEM,
	i_ALU_out => s_ALU_out,
	i_REG_B_out => EX_REG_B_out,
	i_Next_PC => EX_pcPlusFour,
	i_LUIimmediate => EX_LUIimmediate,
	i_mem_to_reg => EX_mem_to_reg,
	i_LUI => EX_LUI,
	i_memWE => EX_memWE,
	i_regWriteAddress => EX_regWrAddress,
	i_regWrEnable => EX_regWrEnable,
	i_instruction => EX_inst,
	o_instruction => MEM_inst,
	o_regWrEnable => MEM_regWrEnable,
	o_regWriteAddress => MEM_regWrAddress,
	o_memWE => MEM_memWE,
	o_ALU_out => MEM_ALU_out,
	o_REG_B_out => MEM_REG_B_out,
	o_Next_PC => MEM_Next_PC,
	o_LUIimmediate => MEM_LUIimmediate,
	o_mem_to_reg => MEM_mem_to_reg,
	o_LUI => MEM_LUI);

MEMWB: MEM_WB_Register port map(
	i_clock => s_CLK,
	i_flush => s_flushWB,
	i_stall => s_stallWB,
	i_ALU_out => MEM_ALU_out,
	i_MEM_out => X"88884444",
	i_LUIdata => MEM_LUIimmediate,
	i_mem_to_reg => MEM_mem_to_reg,
	i_LUI => MEM_LUI,
	i_regWriteAddress => MEM_regWrAddress,
	i_regWrEnable => MEM_regWrEnable,
	i_instruction => MEM_inst,
	o_instruction => WB_inst,
	o_regWrEnable => o_regWrite,
	o_regWriteAddress => WB_regWriteAddress,
	o_ALU_out => WB_ALU_out,
	o_MEM_out => WB_MEM_out,
	o_LUIdata => WB_LUIdata,
	o_mem_to_reg => WB_mem_to_reg,
	o_LUI => WB_LUI);

end structure;
