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

entity MUX is
		port ( TO_ALU : out std_logic_vector(7 downto 0);
				FROM_Y : in std_logic_vector(7 downto 0);
				FROM_IR : in std_logic_vector(7 downto 0);
				SEL : in std_logic );
			
end MUX;

architecture Behavioral of MUX is
begin
	with SEL select
	TO_ALU <= FROM_Y when '0',
				 FROM_IR when '1',
				 "00000000" when others;
			 
end Behavioral;

