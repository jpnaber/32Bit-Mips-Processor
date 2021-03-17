library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_Second_MIPS_Application is
	generic(gCLK_HPER   : time := 50 ns);
end tb_Second_MIPS_Application;

architecture behavior of tb_Second_MIPS_Application is
  
	constant cCLK_PER  : time := gCLK_HPER * 2;

component Second_MIPS_Application
  port(i_Immediate                               : in std_logic_vector(15 downto 0); --Immediate
       i_wAddr					 : in std_logic_vector(4 downto 0);
       i_rAddr2					 : in std_logic_vector(4 downto 0);
       i_rAddr1					 : in std_logic_vector(4 downto 0);
       i_WE, i_RST, i_CLK			 : in std_logic; -- Register file control signals
       i_memWE                         		 : in std_logic; -- Memory write enable '1' to write to memory '0' to read from it
       i_rl, i_al				 : in std_logic; --0 = left shift, 1 = right shift, 0 = logical, 1 = arithmetic
       i_ALUsrc					 : in std_logic; -- '0' = readData2 '1' = sign extend
       i_ALU_Shift				 : in std_logic; -- 0 = ALU output, 1 = shift output
       i_ALU_control				 : in std_logic_vector(2 downto 0); -- Select what operation you want within the ALU
       i_shamt					 : in std_logic_vector(4 downto 0);
       i_mem_to_reg				 : in std_logic); --'0' = MemoryOutput '1' = ALU output to register file

end component;

signal s_WE, s_RST, s_CLK, s_memWE, s_rl, s_al, s_ALUsrc, s_ALU_Shift, s_mem_to_reg : std_logic;
signal s_shamt : std_logic_vector(4 downto 0);
signal s_ALU_control : std_logic_vector(2 downto 0);
signal s_rAddr1, s_rAddr2, s_wAddr : std_logic_vector(4 downto 0);
signal s_Immediate : std_logic_vector(15 downto 0);


begin

  fullALU: Second_MIPS_Application 
  port map(i_Immediate => s_Immediate,
        i_wAddr => s_wAddr,
        i_rAddr1 => s_rAddr1,
        i_rAddr2 => s_rAddr2,
        i_WE => s_WE,
	i_RST => s_RST,
	i_CLK => s_CLK,
        i_memWE => s_memWE,   
        i_rl => s_rl,
	i_al => s_al,
        i_ALUsrc => s_ALUsrc,		
        i_ALU_Shift => s_ALU_Shift,
        i_ALU_control => s_ALU_control,	
        i_shamt => s_shamt,
        i_mem_to_reg => s_mem_to_reg);

P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
 
P_TB: process
begin



--FILL REGISTERS
	s_WE   <= '1';
	s_memWE  <= '0';	
	s_mem_to_reg   <= '1';
	s_ALUsrc <= '0';
	s_Immediate     <= x"0000";
	s_ALU_Shift <= '0';
	s_RST	<= '1';
	s_rAddr1     <= "00001";
	s_rAddr2   <= "00001";
	s_wAddr  <= std_logic_vector(to_unsigned(0,5));
	s_ALU_Shift <= '0';
	s_ALU_control <= std_logic_vector(to_unsigned(0,3));
	wait for cCLK_PER;


--Show ADD Function -------------------ADD Functions Work--------------------------
--Fills Register 
--5
	s_WE   <= '1';
	s_RST <= '0';
	s_ALUsrc <= '1';
	s_ALU_control <= std_logic_vector(to_unsigned(1,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(0,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(0,5));
	s_Immediate <= std_logic_vector(to_unsigned(5,16));
	s_wAddr <= std_logic_vector(to_unsigned(1,5));
	wait for cCLK_PER;

--10
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(0,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(0,5));
	s_Immediate <= std_logic_vector(to_unsigned(10,16));
	s_wAddr <= std_logic_vector(to_unsigned(2,5));
	wait for cCLK_PER;
--15
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(2,5));
	s_Immediate <= std_logic_vector(to_unsigned(0,16));
	s_wAddr <= std_logic_vector(to_unsigned(3,5));
	wait for cCLK_PER;

--FFFF
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(0,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(2,5));
	s_Immediate <= x"FFFF";
	s_wAddr <= std_logic_vector(to_unsigned(7,5));
	wait for cCLK_PER;
--6
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= std_logic_vector(to_unsigned(7,16));
	s_wAddr <= std_logic_vector(to_unsigned(8,5));
	wait for cCLK_PER;

--FFBB
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(0,5));
	s_Immediate <= x"FFBB";
	s_wAddr <= std_logic_vector(to_unsigned(8,5));
	wait for cCLK_PER;

--Show SUB Function
--(5)
	s_ALUsrc <= '0';
	s_ALU_control <= std_logic_vector(to_unsigned(0,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(2,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(1,5));
	s_wAddr <= std_logic_vector(to_unsigned(4,5));
	wait for cCLK_PER;

--(-5)
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(2,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--(-32)
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(0,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= std_logic_vector(to_unsigned(32,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--(-27)
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(4,5)); --  5
	s_rAddr2   <= std_logic_vector(to_unsigned(5,5)); -- -32
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--1F
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= x"FFBA";
	s_wAddr <= std_logic_vector(to_unsigned(6,5));
	wait for cCLK_PER;


s_ALU_control      <= std_logic_vector(to_unsigned(3,3));
--AND 0 and F
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(2,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--AND reg1 and reg (FFFFFFFF) = whatever is in reg1
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--AND with imm (45)

	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= std_logic_vector(to_unsigned(69,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--OR(All Fs)
	s_ALUsrc <= '0';
	s_ALU_control      <= std_logic_vector(to_unsigned(2,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--OR (one F)
	
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_Immediate <= std_logic_vector(to_unsigned(10,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--XOR
--(~5)
	s_ALUsrc <= '0';
	s_ALU_control      <= std_logic_vector(to_unsigned(5,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--(E)
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_Immediate <= std_logic_vector(to_unsigned(11,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--NAND--
--ALL F's Except 0 at end
	s_ALUsrc <= '0';
	s_ALU_control      <= std_logic_vector(to_unsigned(4,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(3,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--0s
	s_ALUsrc <= '0';
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--Fs then 4
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= std_logic_vector(to_unsigned(11,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--NOR--
--0s
	s_ALUsrc <= '0';
	s_ALU_control      <= std_logic_vector(to_unsigned(6,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(3,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
--All Fs except 0 at end
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(2,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;
	

--Shift
--Shift right 1 bit of FFFFFFFF
	s_ALUsrc <= '0';
	s_ALU_shift <= '1';
	s_shamt <= std_logic_vector(to_unsigned(1,5));
	s_rl <= '1'; --0 = left shift, 1 = right shift
	s_al <= '0'; --0 = logical, 1 = arithmetic
	s_shamt <= std_logic_vector(to_unsigned(1,5));
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= std_logic_vector(to_unsigned(1,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--Register 3 holds the value to shift left 5 bits logical
	s_rl <= '0';
	s_al <= '0';
	s_shamt <= std_logic_vector(to_unsigned(5,5));
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(3,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--Shift right 3 bit arithmetic
	s_rl <= '1';
	s_al <= '1';
	s_shamt <= std_logic_vector(to_unsigned(3,5));
	s_rAddr1     <= std_logic_vector(to_unsigned(8,5));
	s_Immediate <= std_logic_vector(to_unsigned(38,16));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--SLT
--(5<A)
	s_ALU_shift <= '0';
	s_ALUsrc <= '0';
	s_ALU_control      <= std_logic_vector(to_unsigned(7,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(2,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--(5>-10)
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(1,5));
	s_Immediate <= x"FFF6";
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--(A>-1)
	s_ALUsrc <= '0';
	s_ALU_control      <= std_logic_vector(to_unsigned(7,3));
	s_rAddr1     <= std_logic_vector(to_unsigned(2,5));
	s_rAddr2   <= std_logic_vector(to_unsigned(7,5));
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

--(-1>-16)
	s_ALUsrc <= '1';
	s_rAddr1     <= std_logic_vector(to_unsigned(7,5));
	s_Immediate <= x"FFEA";
	s_wAddr <= std_logic_vector(to_unsigned(5,5));
	wait for cCLK_PER;

end process;
end behavior;