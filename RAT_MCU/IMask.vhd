----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:48 11/30/2015 
-- Design Name: 
-- Module Name:    IMask - Behavioral 
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



entity IMask is
    Port ( i_SET : in  STD_LOGIC;
           I_CLR : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           oot : out  STD_LOGIC);
end IMask;

architecture Behavioral of IMask is

   signal s_oot: std_logic;

begin
---------------------------------------------
process(i_set, I_CLR, CLK, s_oot)
	begin 
		if (rising_edge(clk)) then 
		   if (I_CLR = '1') then 
			   s_oot <= '0'; 
			elsif (I_SET = '1') then 
			   s_oot <= '1';
			end if;
		end if;
end process;
---------------------------------------------
	oot <= s_oot;

end Behavioral;

