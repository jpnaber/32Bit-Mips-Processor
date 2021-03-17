library IEEE;
use IEEE.std_logic_1164.all;

entity Barrel_Shifter is
  port(i_data_input  : in std_logic_vector(31 downto 0); 
       i_shamt  : in std_logic_vector(4 downto 0); 
       i_rl : in std_logic; --0 = left shift, 1 = right shift
       i_al : in std_logic; --0 = logical, 1 = arithmetic
       o_data_output  : out std_logic_vector(31 downto 0)); 

end Barrel_Shifter;

architecture structure of Barrel_Shifter is

component MUX_dataflow 
  generic(N : integer := 32);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

component shift_logic
  port(i_data_input  : in std_logic_vector(31 downto 0); 
       i_shift : in std_logic_vector(4 downto 0);
       i_rl : in std_logic; --0 = left shift, 1 = right shift
       i_al : in std_logic; --0 = logical, 1 = arithmetic
       o_data_output  : out std_logic_vector(31 downto 0)); 

end component shift_logic;


signal mux1_output : std_logic_vector(31 downto 0);
signal mux2_output : std_logic_vector(31 downto 0);
signal mux3_output : std_logic_vector(31 downto 0);
signal mux4_output : std_logic_vector(31 downto 0);

signal log1_output : std_logic_vector(31 downto 0);
signal log2_output : std_logic_vector(31 downto 0);
signal log3_output : std_logic_vector(31 downto 0);
signal log4_output : std_logic_vector(31 downto 0);
signal log5_output : std_logic_vector(31 downto 0);

begin


--First MUX
A0: shift_logic port map(i_data_input => i_data_input,
			 i_shift => "00001",
			 i_rl => i_rl,
			 i_al => i_al,
			 o_data_output => log1_output); 

B0: MUX_dataflow port map(i_X => i_data_input,
			 i_Y => log1_output,
			 i_S => i_shamt(0),
			 o_F => mux1_output);
						  
						  
						  
						  
--Second MUX					  
A1: shift_logic port map(i_data_input => mux1_output,
			 i_shift => "00010",
			 i_rl => i_rl,
			 i_al => i_al,
			 o_data_output => log2_output); 

B1: MUX_dataflow port map(i_X => mux1_output,
			  i_Y => log2_output,
			  i_S => i_shamt(1),
			  o_F => mux2_output);
						  
						  
						  
						  
						  
--Third MUX		
A2: shift_logic port map(i_data_input => mux2_output,
			 i_shift => "00100",
			 i_rl => i_rl,
			 i_al => i_al,
			 o_data_output => log3_output); 

B2: MUX_dataflow port map(i_X => mux2_output,
			  i_Y => log3_output,
			  i_S => i_shamt(2),
			  o_F => mux3_output);
						  
						  
						  
						  
--Fourth Mux						  
A3: shift_logic port map(i_data_input => mux3_output,
			 i_shift => "01000",
			 i_rl => i_rl,
			 i_al => i_al,
			 o_data_output => log4_output); 

B3: MUX_dataflow port map(i_X => mux3_output,
			  i_Y => log4_output,
			  i_S => i_shamt(3),
			  o_F => mux4_output);
						  
						  
						  
--Fifth Mux					  
A4: shift_logic port map(i_data_input => mux4_output,
			 i_shift => "10000",
			 i_rl => i_rl,
			 i_al => i_al,
		         o_data_output => log5_output); 

B4: MUX_dataflow port map(i_X => mux4_output,
			  i_Y => log5_output,
			  i_S => i_shamt(4),
			  o_F => o_data_output);
						  
end structure;
						  






