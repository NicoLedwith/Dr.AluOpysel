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

entity FourRealMux is
		port ( 	TO_SCR : out std_logic_vector(7 downto 0);
					FROM_Reg : in std_logic_vector(7 downto 0);
					FROM_Insta : in std_logic_vector(7 downto 0);
					FROM_SP : in std_logic_vector(7 downto 0);
					FROM_Subraptor : in std_logic_vector(7 downto 0);
					SEL : in std_logic_vector(1 downto 0));
end FourRealMux;

architecture Behavioral of FourRealMux is
begin
	with SEL select
	TO_SCR <= FROM_Reg when "00",
				 FROM_Insta when "01",
				 FROM_SP when "10",
				 From_SUBRAPTOR when "11",
				 "00000000" when others;
			 
end Behavioral;

