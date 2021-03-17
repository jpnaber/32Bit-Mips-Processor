Library IEEE;
use IEEE.std_logic_1164.all;


entity shift_logic is
  port(i_data_input  : in std_logic_vector(31 downto 0); 
       i_shift : in std_logic_vector(4 downto 0);
       i_rl : in std_logic; --0 = left shift, 1 = right shift
       i_al : in std_logic; --0 = logical, 1 = arithmetic
       o_data_output  : out std_logic_vector(31 downto 0)); 

end shift_logic;

architecture dataflow of shift_logic is

signal sign1 : std_logic;
signal sign2 : std_logic_vector(1 downto 0);
signal sign4 : std_logic_vector(3 downto 0);
signal sign8 : std_logic_vector(7 downto 0);
signal sign16 : std_logic_vector(15 downto 0);
signal holder : std_logic_vector(31 downto 0);
signal holder2 : std_logic_vector(31 downto 0);
signal holder4 : std_logic_vector(31 downto 0);
signal holder8 : std_logic_vector(31 downto 0);
signal holder16 : std_logic_vector(31 downto 0);


begin


z0:sign1 <= i_data_input(31);
z1:sign2 <= sign1 & sign1;
z2:sign4 <= sign2 & sign2;
z3:sign8 <= sign4 & sign4;
z4:sign16 <= sign8 & sign8;
    	




B1: process (i_shift, i_al, i_data_input, i_rl, sign1)
	begin
	  if (i_shift(0) = '1' and i_al = '0' and i_rl = '1') then

		holder <= '0' & i_data_input(31 downto 1);

	  elsif( i_shift(0) = '1' and i_al = '1' and i_rl = '1') then

		holder <= sign1 & i_data_input(31 downto 1);

	  elsif( i_shift(0) = '1' and i_al = '0' and i_rl = '0') then

		holder <= i_data_input(30 downto 0) & '0';

	  else 
		holder <= i_data_input;
	  end if;
    end process;


B2: process (i_shift, i_al, holder, i_rl, sign2)
	begin
	  if (i_shift(1) = '1' and i_al = '0' and i_rl = '1') then

		holder2 <= "00" & holder(31 downto 2);

	  elsif( i_shift(1) = '1' and i_al = '1' and i_rl = '1')then

		holder2 <= sign2 & holder(31 downto 2);

	  elsif( i_shift(1) = '1' and i_al = '0' and i_rl = '0') then

		holder2 <= holder(29 downto 0) & "00";

	  else 
		holder2 <= holder;
	  end if;
    end process;

B3: process (i_shift, i_al, holder2, i_rl, sign4)
	begin
	  if (i_shift(2) = '1' and i_al = '0' and i_rl = '1') then

		holder4<= "0000" & holder2(31 downto 4);

	  elsif( i_shift(2) = '1' and i_al = '1' and i_rl = '1')then

		holder4 <= sign4 & holder2(31 downto 4);

 	  elsif( i_shift(2) = '1' and i_al = '0' and i_rl = '0') then

		holder4 <= holder2(27 downto 0) & "0000";

	  else 
		holder4 <= holder2;
	  end if;
    end process;

B4: process (i_shift, i_al, holder4, i_rl, sign8)
	begin
	  if (i_shift(3) = '1' and i_al = '0' and i_rl = '1') then

		holder8 <= "00000000" & holder4(31 downto 8);

	  elsif( i_shift(3) = '1' and i_al = '1' and i_rl = '1')then

		holder8 <= sign8 & holder4(31 downto 8);

	  elsif( i_shift(3) = '1' and i_al = '0' and i_rl = '0') then

		holder8 <= holder4(23 downto 0) & "00000000";

	  else 
		holder8 <= holder4;
	  end if;
    end process;


B5: process (i_shift, i_al, holder8, i_rl, sign16)
	begin
	  if (i_shift(4) = '1' and i_al = '0' and i_rl = '1') then

		holder16 <= "0000000000000000" & holder8(31 downto 16);

	  elsif( i_shift(4) = '1' and i_al = '1' and i_rl = '1')then

		holder16 <= sign16 & holder8(31 downto 16);

	  elsif( i_shift(4) = '1' and i_al = '0' and i_rl = '0') then

		holder16 <= holder8(15 downto 0) & "0000000000000000";

	  else 
		holder16 <= holder8;
	  end if;
    end process;




B6: o_data_output <= holder16;

end dataflow;