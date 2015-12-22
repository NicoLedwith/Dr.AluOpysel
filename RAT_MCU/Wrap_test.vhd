--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:50:47 11/13/2015
-- Design Name:   
-- Module Name:   C:/Users/nledwith/Desktop/Exp8/Exp8_actual/Wrap_test.vhd
-- Project Name:  Exp8_actual
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RAT_wrapper
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Wrap_test IS
END Wrap_test;
 
ARCHITECTURE behavior OF Wrap_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RAT_wrapper
    PORT(
         LEDS : OUT  std_logic_vector(7 downto 0);
         SEGMENTS : OUT  std_logic_vector(7 downto 0);
         DISP_EN : OUT  std_logic_vector(3 downto 0);
         SWITCHES : IN  std_logic_vector(7 downto 0);
         BUTTONS : IN  std_logic_vector(3 downto 0);
         RESET : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SWITCHES : std_logic_vector(7 downto 0) := (others => '0');
   signal BUTTONS : std_logic_vector(3 downto 0) := (others => '0');
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal LEDS : std_logic_vector(7 downto 0);
   signal SEGMENTS : std_logic_vector(7 downto 0);
   signal DISP_EN : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAT_wrapper PORT MAP (
          LEDS => LEDS,
          SEGMENTS => SEGMENTS,
          DISP_EN => DISP_EN,
          SWITCHES => SWITCHES,
          BUTTONS => BUTTONS,
          RESET => RESET,
          CLK => CLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here
--		RESET <= '1';
--		wait for 10 ns;
--		RESET <= '0';

      wait;
   end process;

END;
