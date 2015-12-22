----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:52:01 10/14/2015 
-- Design Name: 
-- Module Name:    subractor - Behavioral 
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity subraptor is
    Port ( Food : in  STD_LOGIC_vector(7 downto 0);
           Feces : out  STD_LOGIC_vector(7 downto 0));
end subraptor;

architecture Behavioral of subraptor is

begin
		Feces <= Food - '1';

end Behavioral;

