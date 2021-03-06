library IEEE;
use IEEE.std_logic_1164.all;

entity control_logic_module is
    port(op_field : in std_logic_vector(5 downto 0);
	 funct_field : in std_logic_vector(5 downto 0);
	 RegDst, ALUSrc, i_ALU_shift, MemReg, RegWr, MemWr, Branch, LUI, Jump, zeroextend, jr : out std_logic;
	 shiftVariable : out std_logic;
	 ALU_Control_Bits : out std_logic_vector(4 downto 0)); --bit(4) = i_rl | bit(3) = i_al | bit(2-0) = ALU control bits

end control_logic_module;

architecture behaviorial of control_logic_module is

signal control_bits : std_logic_vector(11 downto 0);
begin


process (op_field, funct_field)
begin
	case op_field is
	
		--R-Type Instructions
	   when "000000" => 
		if funct_field = "000000" then --sll
			control_bits <= "000010101000";
			ALU_Control_Bits <= "00000";

		elsif funct_field = "000010" then --srl
			control_bits <= "000010101000";
			ALU_Control_Bits <= "10000";
		
		elsif funct_field = "000011" then --sra
			control_bits <= "000010101000";
			ALU_Control_Bits <= "11000";
			
		elsif funct_field = "000100" then --sllv
			control_bits <= "001010101000";
			ALU_Control_Bits <= "00000";

		elsif funct_field = "000110" then --srlv
			control_bits <= "001010101000";
			ALU_Control_Bits <= "10000";

		elsif funct_field = "000111" then --srav
			control_bits <= "001010101000";
			ALU_Control_Bits <= "11000";

		elsif funct_field = "001000" then --Jump Register (jr)
			control_bits <= "100000000001";
			ALU_Control_Bits <= "00000";
			
		elsif funct_field = "100000" then --add
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00001";
			
		elsif funct_field = "100001" then --addu
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00001";
			
		elsif funct_field = "100010" then --sub
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00000";
			
		elsif funct_field = "100011" then --subu
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00000";
			
		elsif funct_field = "100100" then --and
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00011";
			
		elsif funct_field = "100101" then --or
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00010";
			
		elsif funct_field = "100110" then --xor
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00101";
			
		elsif funct_field = "100111" then --nor
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00110";
			
		elsif funct_field = "101010" then --slt
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00111";
			
		elsif funct_field = "101011" then --sltu
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00111";
		else 
			control_bits <= "000010001000";
			ALU_Control_Bits <= "00001";
			
		end if;
		
		--I-type Instructions
 	   when "000100" => --beq
			control_bits <= "010000000010";
			ALU_Control_Bits <= "00000";
			
	   when "000101" => --bne
			control_bits <= "000000000010";
			ALU_Control_Bits <= "00000";

	   when "001000" => --addi
			control_bits <= "000001001000";
			ALU_Control_Bits <= "00001";
			
	   when "001001" => --addiu
			control_bits <= "000001001000";
			ALU_Control_Bits <= "00001";
			
	   when "001010" => --slti
			control_bits <= "000001001000";
			ALU_Control_Bits <= "00111";
			
	   when "001011" => --sltiu
			control_bits <= "010001001000";
			ALU_Control_Bits <= "00111";
			
	   when "001100" => --andi
			control_bits <= "000001001000";
			ALU_Control_Bits <= "00011";
			
	   when "001101" => --ori
			control_bits <= "010001001000";
			ALU_Control_Bits <= "00010";
			
	   when "001110"=> --xori
			control_bits <= "000001001000";
			ALU_Control_Bits <= "00101";
			
	   when "100011" => --lw
			control_bits <= "000001011000";
			ALU_Control_Bits <= "00001";
			
	   when "101011" => --sw
			control_bits <= "000001000100";
			ALU_Control_Bits <= "00001";

	   when "001111" => --LUI
			control_bits <= "000101001000";
			ALU_Control_Bits <= "00000";
			
		--J-Type Instructions
	   when "000010" => -- j
			control_bits <= "000001000001";
			ALU_Control_Bits <= "00000";
			
	   when "000011" => -- jal
			control_bits <= "000001001001";
			ALU_Control_Bits <= "00000";
			
	   when others =>
			control_bits <= "000010101000";
			ALU_Control_Bits <= "00001";
	end case;
end process;

jr <= control_bits(11);
zeroextend <= control_bits(10);
shiftVariable <= control_bits(9);
LUI         <= control_bits(8);
RegDst      <= control_bits(7);
ALUSrc 	    <= control_bits(6);
i_ALU_shift <= control_bits(5);
MemReg      <= control_bits(4);
RegWr       <= control_bits(3);
MemWr       <= control_bits(2);
Branch      <= control_bits(1);
Jump	    <= control_bits(0);

end behaviorial;

