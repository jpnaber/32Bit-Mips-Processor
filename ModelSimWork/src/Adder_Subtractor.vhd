library IEEE;
use IEEE.std_logic_1164.all;

entity Adder_Subtractor is
  generic(N : integer := 32);
  port(i_A,i_B  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub  : in std_logic;
       o_Sum  : out std_logic_vector(N-1 downto 0);
       o_Cout : out std_logic);

end Adder_Subtractor;

architecture structure of Adder_Subtractor is

signal carryin, carryinsub : std_logic;
signal complementedB : std_logic_vector(N-1 downto 0);
signal FullAdderAdd : std_logic_vector(N-1 downto 0);
signal FullAdderSubtract : std_logic_vector(N-1 downto 0);
signal CarryOutAdd, CarryOutSub : std_logic;

component Full_Adder_Dataflow_N_Bit is
  generic(N : integer := 32);
  port(i_A,i_B  : in std_logic_vector(N-1 downto 0);
       i_Cin  : in std_logic;
       o_S  : out std_logic_vector(N-1 downto 0);
       o_Cout  : out std_logic);
end component;

component MUX_structural_N_bit is
  generic(N : integer := 32);
  port(i_X,i_Y  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

component ones_complementer_dataflow is
  generic(N : integer := 32);
  port(i_B  : in std_logic_vector(N-1 downto 0);
       o_G  : out std_logic_vector(N-1 downto 0));
end component;


begin

Set_Carry_to_zero: carryin <= '0';
Set_Sub_Carry_to_one: carryinsub <= '1';
Invert_B: ones_complementer_dataflow port map(i_B => i_B, o_G => complementedB);
Subtraction: Full_Adder_Dataflow_N_Bit port map(i_A => i_A, i_B => complementedB, i_Cin => carryinsub, o_S => FullAdderSubtract, o_Cout => CarryOutSub);
Addition: Full_Adder_Dataflow_N_Bit port map(i_A => i_A, i_B => i_B, i_Cin => carryin, o_S => FullAdderAdd, o_Cout => CarryOutAdd);
Mux_Sum: MUX_structural_N_bit port map(i_X => FullAdderSubtract, i_Y => FullAdderAdd, i_S => i_nAdd_Sub, o_F => o_Sum);


end structure;