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

entity MUX_4in is
		port ( TO_REG : out std_logic_vector(7 downto 0);
				FROM_IN : in std_logic_vector(7 downto 0);
				FROM_BUS : in std_logic_vector(7 downto 0);
				FROM_ALU : in std_logic_vector(7 downto 0);
				SEL : in std_logic_vector(1 downto 0));
			
end MUX_4in;

architecture Behavioral of MUX_4in is
begin
	with SEL select
	TO_REG <= FROM_ALU when "00",
				 FROM_BUS when "01",
				 FROM_IN when "11",
				 "00000000" when others;
			 
end Behavioral;

