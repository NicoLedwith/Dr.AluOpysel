----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:47:10 09/25/2015 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SingleMux is
		port ( 	TO_FLAG : out std_logic;
					FROM_ALU : in std_logic;
					FROM_SHAD_FLG : in std_logic;
					SEL : in std_logic);
end SingleMux;

architecture Behavioral of SingleMux is
begin
	with SEL select
	TO_FLAG <= FROM_ALU when '0',
				  FROM_SHAD_FLG when '1',
				  '0' when others;
				  
			 
end Behavioral;

