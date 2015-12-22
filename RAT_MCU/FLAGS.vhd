----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:14:49 11/02/2015 
-- Design Name: 
-- Module Name:    FLAGS - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FLAGS is
    Port ( FLG_C_SET : in  STD_LOGIC;
           FLG_C_CLR : in  STD_LOGIC;
           FLG_C_LD : in  STD_LOGIC;
           FLG_Z_LD : in  STD_LOGIC;
           FLG_LD_SEL : in  STD_LOGIC;
           FLG_SHAD_LD : in  STD_LOGIC;
           C : in  STD_LOGIC;
           Z : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           C_FLAG : out  STD_LOGIC;
           Z_FLAG : out  STD_LOGIC);
end FLAGS;

architecture Behavioral of FLAGS is

	component FlagReg
		Port ( D    : in  STD_LOGIC; --flag input
           LD   : in  STD_LOGIC; --load Q with the D value
           SET  : in  STD_LOGIC; --set the flag to '1'
           CLR  : in  STD_LOGIC; --clear the flag to '0'
           CLK  : in  STD_LOGIC; --system clock
           Q    : out  STD_LOGIC); --flag output
	end component;
	
	component SingleMux
		port ( 	TO_FLAG : out std_logic;
					FROM_ALU : in std_logic;
					FROM_SHAD_FLG : in std_logic;
					SEL : in std_logic);
	end component;

	signal SHAD_z_Z_MUX, SHAD_C_C_MUX, Z_Mux_flg, C_Mux_flg, Z_flg_Shad_Flg, C_flg_Shad_Flg: std_logic;

begin

	C_FLAG <= C_flg_shad_flg;
	Z_FLAG <= Z_flg_shad_flg;

	C_FLG: FlagReg
		port map (  D => c_mux_flg,
						LD => FLG_C_LD,
						SET => FLG_C_SET,
						CLR => FLG_C_CLR,
						CLK => CLK,
						Q => C_flg_shad_flg);
						
	Z_FLG: FlagReg
		port map (  D => z_mux_flg,
						LD => FLG_Z_LD,
						SET => '0',
						CLR => '0',
						CLK => CLK,
						Q => Z_flg_shad_flg);
						
	SHAD_Z: FlagReg
		port map (  D => z_flg_shad_flg,
						LD => flg_shad_ld,
						SET => '0',
						CLR => '0',
						CLK => CLK,
						Q => shad_z_z_mux);
	
	SHAD_C: FlagReg
		port map (  D => c_flg_shad_flg,
						LD => flg_shad_ld,
						SET => '0',
						CLR => '0',
						CLK => CLK,
						Q => shad_c_c_mux);
	
	Z_MUX: SingleMux
		port map (	TO_FLAG => z_mux_flg,
						FROM_ALU =>  z,
						FROM_SHAD_FLG => shad_z_z_mux,
						SEL => 	flg_ld_sel);
						
	C_MUX: SingleMux
		port map (	TO_FLAG => c_mux_flg,
						FROM_ALU => c, 
						FROM_SHAD_FLG => shad_c_c_mux,
						SEL =>	flg_ld_sel);


end Behavioral;

