library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPSRegister is port(
	i_cl : in std_logic;				--Clock
	i_re : in std_logic_vector(31 downto 0);        --Reset
	i_wr : in std_logic_vector(31 downto 0);	--Write data
	i_se : in std_logic_vector(4 downto 0);		--Write select
	i_en : in std_logic; 				--Write enable
	i_rs : in std_logic_vector(4 downto 0);		--Select for output rs
	i_rt : in std_logic_vector(4 downto 0);		--Select for output rt
	o_rs : out std_logic_vector(31 downto 0);	--Output rs
	o_rt : out std_logic_vector(31 downto 0));	--Output rt
end MIPSRegister;

architecture mixed of MIPSRegister is

signal s_RST,s_dffEn,s_00,s_01,s_02,s_03,s_04,s_05,s_06,s_07,s_08,s_09,s_10,s_11,s_12,s_13,s_14,s_15,s_16,s_17,s_18,s_19,s_20,s_21,s_22,s_23,s_24,s_25,s_26,s_27,s_28,s_29,s_30,s_31 : std_logic_vector(31 downto 0);


component decode32 port(
	i_in  : in std_logic_vector(4 downto 0);
	i_en  : in std_logic;
	o_out : out std_logic_vector(31 downto 0));
end component;

component dffNbit port(
	i_CLK     : in std_logic;     -- Clock input
        i_RST     : in std_logic;     -- Reset input
        i_WE      : in std_logic;     -- Write enable input
        i_D      : in std_logic_vector(31 downto 0);     -- Data value input
        o_Q      : out std_logic_vector(31 downto 0));   -- Data value output
end component;	

component mux4to32 port(
i_in0   : in std_logic_vector(31 downto 0);
i_in1   : in std_logic_vector(31 downto 0);
i_in2   : in std_logic_vector(31 downto 0);
i_in3   : in std_logic_vector(31 downto 0);
i_in4   : in std_logic_vector(31 downto 0);
i_in5   : in std_logic_vector(31 downto 0);
i_in6   : in std_logic_vector(31 downto 0);
i_in7   : in std_logic_vector(31 downto 0);
i_in8   : in std_logic_vector(31 downto 0);
i_in9   : in std_logic_vector(31 downto 0);
i_in10  : in std_logic_vector(31 downto 0);
i_in11  : in std_logic_vector(31 downto 0);
i_in12  : in std_logic_vector(31 downto 0);
i_in13  : in std_logic_vector(31 downto 0);
i_in14  : in std_logic_vector(31 downto 0);
i_in15  : in std_logic_vector(31 downto 0);
i_in16  : in std_logic_vector(31 downto 0);
i_in17  : in std_logic_vector(31 downto 0);
i_in18  : in std_logic_vector(31 downto 0);
i_in19  : in std_logic_vector(31 downto 0);
i_in20  : in std_logic_vector(31 downto 0);
i_in21  : in std_logic_vector(31 downto 0);
i_in22  : in std_logic_vector(31 downto 0);
i_in23  : in std_logic_vector(31 downto 0);
i_in24  : in std_logic_vector(31 downto 0);
i_in25  : in std_logic_vector(31 downto 0);
i_in26  : in std_logic_vector(31 downto 0);
i_in27  : in std_logic_vector(31 downto 0);
i_in28  : in std_logic_vector(31 downto 0);
i_in29  : in std_logic_vector(31 downto 0);
i_in30  : in std_logic_vector(31 downto 0);
i_in31  : in std_logic_vector(31 downto 0);
i_sel   : in std_logic_vector(04 downto 0);
o_out  : out std_logic_vector(31 downto 0));
end component;

begin

s_RST <= i_re;

dec:decode32 port map(
i_in  => i_se,
i_en  => i_en,
o_out => s_dffEn);

rs:mux4to32 port map(
i_in0   => s_00,
i_in1   => s_01,
i_in2   => s_02,
i_in3   => s_03,
i_in4   => s_04,
i_in5   => s_05,
i_in6   => s_06,
i_in7   => s_07,
i_in8   => s_08,
i_in9   => s_09,
i_in10  => s_10,
i_in11  => s_11,
i_in12  => s_12,
i_in13  => s_13,
i_in14  => s_14,
i_in15  => s_15,
i_in16  => s_16,
i_in17  => s_17,
i_in18  => s_18,
i_in19  => s_19,
i_in20  => s_20,
i_in21  => s_21,
i_in22  => s_22,
i_in23  => s_23,
i_in24  => s_24,
i_in25  => s_25,
i_in26  => s_26,
i_in27  => s_27,
i_in28  => s_28,
i_in29  => s_29,
i_in30  => s_30,
i_in31  => s_31,
i_sel   => i_rs,
o_out   => o_rs);

rt:mux4to32 port map(
i_in0   => s_00,
i_in1   => s_01,
i_in2   => s_02,
i_in3   => s_03,
i_in4   => s_04,
i_in5   => s_05,
i_in6   => s_06,
i_in7   => s_07,
i_in8   => s_08,
i_in9   => s_09,
i_in10  => s_10,
i_in11  => s_11,
i_in12  => s_12,
i_in13  => s_13,
i_in14  => s_14,
i_in15  => s_15,
i_in16  => s_16,
i_in17  => s_17,
i_in18  => s_18,
i_in19  => s_19,
i_in20  => s_20,
i_in21  => s_21,
i_in22  => s_22,
i_in23  => s_23,
i_in24  => s_24,
i_in25  => s_25,
i_in26  => s_26,
i_in27  => s_27,
i_in28  => s_28,
i_in29  => s_29,
i_in30  => s_30,
i_in31  => s_31,
i_sel   => i_rt,
o_out   => o_rt);

--r0:dffNbit port map(
--	i_CLK => i_cl,
	--i_RST => s_RST(0),
	--i_WE  => s_dffEn(0),
	--i_D   => x"00000000",
	--o_Q   => s_00);	
s_00 <= x"00000000";
r1:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(1),
	i_WE  => s_dffEn(1),
	i_D   => i_wr,
	o_Q   => s_01);	
r2:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(2),
	i_WE  => s_dffEn(2),
	i_D   => i_wr,
	o_Q   => s_02);	
r3:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(3),
	i_WE  => s_dffEn(3),
	i_D   => i_wr,
	o_Q   => s_03);	
r4:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(4),
	i_WE  => s_dffEn(4),
	i_D   => i_wr,
	o_Q   => s_04);	
r5:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(5),
	i_WE  => s_dffEn(5),
	i_D   => i_wr,
	o_Q   => s_05);	
r6:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(6),
	i_WE  => s_dffEn(6),
	i_D   => i_wr,
	o_Q   => s_06);	
r7:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(7),
	i_WE  => s_dffEn(7),
	i_D   => i_wr,
	o_Q   => s_07);	
r8:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(8),
	i_WE  => s_dffEn(8),
	i_D   => i_wr,
	o_Q   => s_08);	
r9:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(9),
	i_WE  => s_dffEn(9),
	i_D   => i_wr,
	o_Q   => s_09);	
r10:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(10),
	i_WE  => s_dffEn(10),
	i_D   => i_wr,
	o_Q   => s_10);	
r11:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(11),
	i_WE  => s_dffEn(11),
	i_D   => i_wr,
	o_Q   => s_11);	
r12:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(12),
	i_WE  => s_dffEn(12),
	i_D   => i_wr,
	o_Q   => s_12);	
r13:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(13),
	i_WE  => s_dffEn(13),
	i_D   => i_wr,
	o_Q   => s_13);	
r14:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(14),
	i_WE  => s_dffEn(14),
	i_D   => i_wr,
	o_Q   => s_14);	
r15:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(15),
	i_WE  => s_dffEn(15),
	i_D   => i_wr,
	o_Q   => s_15);	
r16:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(16),
	i_WE  => s_dffEn(16),
	i_D   => i_wr,
	o_Q   => s_16);	
r17:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(17),
	i_WE  => s_dffEn(17),
	i_D   => i_wr,
	o_Q   => s_17);	
r18:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(18),
	i_WE  => s_dffEn(18),
	i_D   => i_wr,
	o_Q   => s_18);	
r19:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(19),
	i_WE  => s_dffEn(19),
	i_D   => i_wr,
	o_Q   => s_19);	
r20:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(20),
	i_WE  => s_dffEn(20),
	i_D   => i_wr,
	o_Q   => s_20);	
r21:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(21),
	i_WE  => s_dffEn(21),
	i_D   => i_wr,
	o_Q   => s_21);	
r22:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(22),
	i_WE  => s_dffEn(22),
	i_D   => i_wr,
	o_Q   => s_22);	
r23:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(23),
	i_WE  => s_dffEn(23),
	i_D   => i_wr,
	o_Q   => s_23);	
r24:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(24),
	i_WE  => s_dffEn(24),
	i_D   => i_wr,
	o_Q   => s_24);	
r25:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(25),
	i_WE  => s_dffEn(25),
	i_D   => i_wr,
	o_Q   => s_25);	
r26:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(26),
	i_WE  => s_dffEn(26),
	i_D   => i_wr,
	o_Q   => s_26);	
r27:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(27),
	i_WE  => s_dffEn(27),
	i_D   => i_wr,
	o_Q   => s_27);	
r28:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(28),
	i_WE  => s_dffEn(28),
	i_D   => i_wr,
	o_Q   => s_28);	
r29:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(29),
	i_WE  => s_dffEn(29),
	i_D   => i_wr,
	o_Q   => s_29);
r30:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(30),
	i_WE  => s_dffEn(30),
	i_D   => i_wr,
	o_Q   => s_30);
r31:dffNbit port map(
	i_CLK => i_cl,
	i_RST => s_RST(31),
	i_WE  => s_dffEn(31),
	i_D   => i_wr,
	o_Q   => s_31);
end mixed;