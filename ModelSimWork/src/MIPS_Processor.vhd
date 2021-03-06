-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment


component ALU_Barrel_Shifter
   port(i_ALU_Shift : in std_logic; --0 = ALU output, 1 = shift output
	i_shamt  : in std_logic_vector(4 downto 0); 
	i_rl     : in std_logic; --0 = left shift, 1 = right shift
	i_al     : in std_logic; --0 = logical, 1 = arithmetic
	i_ALU_input_A  : in std_logic_vector(31 downto 0);
	i_ALU_input_B  : in std_logic_vector(31 downto 0);
	i_control      : in std_logic_vector(2 downto 0);
	o_ALU_output   : out std_logic_vector(31 downto 0);
	o_carry_out    : out std_logic;
	o_overflow     : out std_logic;
	o_zero         : out std_logic);
end component;

component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component MUX_dataflow
  generic(N : integer := 32);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

component MIPSRegister 
     port(
	i_cl : in std_logic;				--Clock
	i_re : in std_logic_vector(31 downto 0);        --Reset
	i_wr : in std_logic_vector(31 downto 0);	--Write data
	i_se : in std_logic_vector(4 downto 0);		--Write select
	i_en : in std_logic; 				--Write enable
	i_rs : in std_logic_vector(4 downto 0);		--Select for output A
	i_rt : in std_logic_vector(4 downto 0);		--Select for output B
	o_rs : out std_logic_vector(31 downto 0);	--Output A
	o_rt : out std_logic_vector(31 downto 0));	--Output B
end component;

component n_register port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component control_logic_module
    port(op_field : in std_logic_vector(5 downto 0);
	 funct_field : in std_logic_vector(5 downto 0);
	 RegDst, ALUSrc, i_ALU_shift, MemReg, RegWr, Jump, MemWr, Branch, LUI, shiftVariable, zeroextend, jr : out std_logic;
	 ALU_Control_Bits : out std_logic_vector(4 downto 0));

end component;

component sign_extender
      port( i_In : in std_logic_vector(15 downto 0);
	    i_zeroextend : in std_logic;
            o_Out : out std_logic_vector(31 downto 0));
end component;

component five_bit_mux
  port(i_S	: in std_logic;
       i_A 	: in std_logic_vector(4 downto 0);
       i_B 	: in std_logic_vector(4 downto 0);
       o_output  : out std_logic_vector(4 downto 0));
end component;

component Adder_Subtractor
  generic(N : integer := 32);
  port(i_A,i_B  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub  : in std_logic;
       o_Sum  : out std_logic_vector(N-1 downto 0);
       o_Cout : out std_logic);
end component;

component EX_MEM_Register port(
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


component ID_EX_Register port(
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
	i_inst10_6		: in std_logic_vector(4 downto 0);
	i_inst31_26		: in std_logic_vector(5 downto 0);
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

component MEM_WB_Register port(
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

signal o_overflow, o_zero, o_carry_out : std_logic;
signal o_rData1, s_NextMemInst : std_logic_vector(31 downto 0);
signal rl, al : std_logic;
signal control : std_logic_vector(2 downto 0);
signal regDst : std_logic;
signal MEM_MUX_Output, sign_extender_output, MUX_Output, ALUOut, s_RST, s_Readdata2, s_PCin, lui_Immediate, MemRegOut : std_logic_vector(31 downto 0);
signal immediateShited, jumpAddress, branchadder, branchmux, jumpmux, jrout, s_regWriteFinal, memRegMux : std_logic_vector(31 downto 0);
signal ALUsrc, ALU_shift, MemReg, Branch, Jump, shiftVariable, zeroextend, andoutput, jrControl, s_zero : std_logic;
signal ALU_Control_Bits, shift_amount, rtReadAddress, s_RegOrRA : std_logic_vector(4 downto 0);
signal LUI, branchMuxSelect : std_logic;

--Pipelining Signals

signal IF_inst, IF_pcPlusFour : std_logic_vector(31 downto 0);
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

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextMemInst when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  s_Halt <='1' when (WB_inst(31 downto 26) = "000000") and (WB_inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 
  
  
  
  --Jump and Link Cases for register address and value
  with IF_inst(31 downto 26) select
    s_RegWrAddr <= "11111" when "000011", --if JAL, write to $ra
      WB_regWriteAddress when others;

  with IF_inst(31 downto 26) select
    s_RegWrData <= IF_pcPlusFour when "000011", -- write return address to $31, if not jal, write the normal output -----------------------------------------------change ifpplsufopur
      s_regWriteFinal when others;
	  
	  
    s_NextMemInst(31 downto 20) <= x"004"; --keep instruction in x00400000 format for MIPS
	s_NextMemInst(19 downto 00) <= s_NextInstAddr(19 downto 0);
  
  s_RST <= (others => iRST); --Set Reset signals
  s_DMemData <= MEM_REG_B_out; --Set S_DMemData
 
  A0: MIPSRegister port map(i_cl => iCLK, --Register File
			i_re => s_RST, --reset
			i_wr => s_RegWrData,--write data
			i_se => s_RegWrAddr,--write select
			i_en => s_RegWr, --write enable
			i_rs => IF_inst(25 downto 21), --select for A
			i_rt => rtReadAddress, --select for b
			o_rs => o_rData1, --output a
			o_rt => s_Readdata2); --output b
			
  v0 <= WB_ALU_out when ((WB_regWriteAddress = "00010") and (s_RegWr = '1')) and (WB_mem_to_reg = '0'); --Set V0 to second register
  
  

  A1: control_logic_module port map(op_field    => IF_inst(31 downto 26), --Control Logic
				  funct_field => IF_inst(5 downto 0),
				  RegDst      => regDst,
				  ALUSrc      => ALUSrc,
				  i_ALU_shift => ALU_shift,
				  MemReg      => MemReg,
				  RegWr       => regWR,
				  MemWr	      => s_DmemWriteEnable,
				  Jump	      => Jump,
				  Branch      => Branch,
				  LUI         => LUI,
				  zeroextend  => zeroextend,
				  shiftVariable => shiftVariable,
				  jr => jrControl,
				  ALU_Control_Bits => ALU_Control_Bits);


  A3: five_bit_mux port map(i_S => regDst, --Mux to select write register address
			    i_A => IF_inst(20 downto 16),
			    i_B => IF_inst(15 downto 11),
			    o_output => s_RegOrRA);



  A4: sign_extender port map(i_In => IF_inst(15 downto 0), --immediate sign extender
			   i_zeroextend => zeroextend,
			   o_Out => sign_extender_output);

  A5: MUX_dataflow port map(i_X => EX_REG_B_out, --ALUSRC mux
		 i_Y => EX_immediate,
		 i_S => EX_ALUSrc,
		 o_F => MUX_Output);

  A6: five_bit_mux port map(i_S => EX_shiftVariable, --if its a shiftvariable call, it makes data1(4 downto 0) the shift amount
       		i_A => EX_inst10_6,
      		i_B => EX_REG_A_out(4 downto 0),
      		o_output => shift_amount);

  A7: ALU_Barrel_Shifter port map(   -- ALU
			i_ALU_Shift => EX_ALU_shift,
			i_shamt => shift_amount,
			i_rl => EX_ALU_Control_Bits(4),
			i_al => EX_ALU_Control_Bits(3),
			i_ALU_input_A => EX_REG_A_out,
			i_ALU_input_B => MUX_Output,
			i_control => EX_ALU_Control_Bits(2 downto 0),
			o_ALU_output => s_ALU_out,
			o_carry_out => o_carry_out,
			o_overflow=> o_overflow,
			o_zero => o_zero);

  oALUOut <= s_ALU_out;
  
  s_DMemAddr <= MEM_ALU_out;
  
  s_DMemWr <= MEM_memWE;


  A8: MUX_dataflow port map(i_X => WB_ALU_out, -- mem_to_reg mux
		 i_Y => WB_MEM_out,
		 i_S => WB_mem_to_reg,
		 o_F => memRegMux);
		 
  lui_Immediate(15 downto 0) <= x"0000"; --Load upper immediate
  lui_Immediate(31 downto 16) <= IF_inst(15 downto 0);
  
  immediateShited(31 downto 2) <= EX_immediate(29 downto 0); --Left shift immediate for branch
  immediateShited(1 downto 0) <= "00";
  
  jumpAddress(27 downto 2) <= EX_inst25_0; --Instruction left shifted and add PC+4[31-28]
  jumpAddress(1 downto 0) <= "00";
  jumpAddress(31 downto 28) <= EX_pcPlusFour(31 downto 28);
  
  A9: Adder_Subtractor port map(i_A => EX_pcPlusFour, --Branch adder
		i_B => immediateShited,
		i_nAdd_Sub => '1',
		o_Sum => branchadder,
		o_Cout => open);
		
with EX_inst31_26 select --if instruction is bne, set s_zero to the not of o_zero because its not equal
    s_zero <= o_zero when "000100", -- if beq use regular o_zero output
	  not o_zero when others; -- if bne use not'd o_zero
		
  A10: andg2 port map(i_A => EX_branch, --Branch logic
					  i_B => s_zero,
					  o_F => andoutput);
				
	
  A11: MUX_dataflow port map(i_X => EX_pcPlusFour, -- Branch Mux
		i_Y => branchadder,
		 i_S => andoutput,
		 o_F => branchmux);
		 
  A12: MUX_dataflow port map(i_X => branchmux, -- Jump mux
		i_Y => jumpAddress,
		 i_S => EX_jump,
		 o_F => jumpmux);
		 
  A13: MUX_dataflow port map(i_X => jumpmux, -- Jr mux
		 i_Y => EX_REG_B_out,
		 i_S => EX_jr,
		 o_F => jrout);
		 
  jrAddress: five_bit_mux port map(i_S => jrControl, -- IF JR, get the return address from $ra
			    i_A => IF_inst(20 downto 16),
			    i_B => "11111",
			    o_output => rtReadAddress);

		 
  A14: MUX_dataflow port map(i_X => memRegMux, -- LUI mux, if LUI, load LUI value into registers, if not, let the memreg data go through
		 i_Y => WB_LUIdata,
		 i_S => WB_LUI,
		 o_F => s_regWriteFinal);
		 
		 
  A15: Adder_Subtractor port map(i_A => s_IMemAddr, -- PC+4
		i_B => x"00000004",
		i_nAdd_Sub => '1',
		o_Sum => s_PCin,
		o_Cout => open);
		
  A16: org2 port map(i_A => Jump,
       i_B => jrControl,
       o_F => s_jump);
  
  
  A17: org2 port map(i_A => s_jump,
       i_B => branch,
       o_F => s_branch);
  
  
		
  A18: MUX_dataflow port map(i_X => s_PCin,
		 i_Y => MEM_Next_PC,
		 i_S => s_branch,
		 o_F => s_NextPC);
		
  PC : n_register port map(i_CLK => iCLK, --PC Register
       i_RST=> iRST,
       i_WE => '1',
       i_D   =>  s_NextPC,
       o_Q     => s_NextInstAddr);

IF_ID: IF_ID_Register 
	port map(
	i_clock => iCLK,
	i_flush => '0',
	i_stall => '0',
	i_instruction => s_Inst,
	i_pcPlusFour => s_PCin,
	o_instruction => IF_inst,
	o_pcPlusFour => IF_pcPlusFour);

ID_EX: ID_EX_Register port map(
	i_clock => iCLK,
	i_flush => '0',
	i_stall => '0',
	i_mem_to_reg => MemReg,
	i_LUI => LUI,
	i_memWE => s_DmemWriteEnable,
	i_branch => Branch,
	i_jump => Jump,
	i_jr => jrControl,
	i_ALU_Control_Bits => ALU_Control_Bits,
	i_shiftVariable => shiftVariable,
	i_ALU_shift => ALU_shift,
	i_ALUSrc => ALUSrc,
	i_REG_A_out => o_rData1,
	i_REG_B_out => s_Readdata2,
	i_immediate => sign_extender_output,
	i_pcPlusFour => IF_pcPlusFour,
	i_inst25_0 => IF_inst(25 downto 0),
	i_LUIimmediate => lui_Immediate,
	i_inst31_26 => IF_inst(31 downto 26),
	i_inst10_6 => IF_inst(10 downto 6),
	i_regWriteAddress => s_RegOrRA,
	i_regWrEnable => regWR,
	i_instruction => IF_inst,
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
	i_clock => iCLK,
	i_flush => '0',
	i_stall => '0',
	i_ALU_out => s_ALU_out,
	i_REG_B_out => EX_REG_B_out,
	i_Next_PC => jrout,
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
	i_clock => iCLK,
	i_flush => '0',
	i_stall => '0',
	i_ALU_out => MEM_ALU_out,
	i_MEM_out => s_DMemOut,
	i_LUIdata => MEM_LUIimmediate,
	i_mem_to_reg => MEM_mem_to_reg,
	i_LUI => MEM_LUI,
	i_regWriteAddress => MEM_regWrAddress,
	i_regWrEnable => MEM_regWrEnable,
	i_instruction => MEM_inst,
	o_instruction => WB_inst,
	o_regWrEnable => s_RegWr,
	o_regWriteAddress => WB_regWriteAddress,
	o_ALU_out => WB_ALU_out,
	o_MEM_out => WB_MEM_out,
	o_LUIdata => WB_LUIdata,
	o_mem_to_reg => WB_mem_to_reg,
	o_LUI => WB_LUI);



end structure;