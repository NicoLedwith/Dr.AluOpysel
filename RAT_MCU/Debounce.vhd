----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: James Ratner
-- 
-- Create Date:    19:42:08 11/28/2011 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: This is a RET debouncer with both one-shot and pulse output. 
--              The SIG is the signal to be debounced and the CLK is the system
--              clock. The level output remains asserted as long as the signal to
--              be debounced remains asserted once the signal is deemed "good" by
--              the debounce unit. The pulse output is a 2-clock wide signal 
--              that is output once the input signal passes the debounce
--              qualifications. 
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created: 03-12-2015
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ret_db_1shot is
    Port (   CLK   : in STD_LOGIC; 
			    SIG   : in STD_LOGIC;
             PULSE : out STD_LOGIC; 
             LEVEL : out STD_LOGIC);
end ret_db_1shot;

architecture Behavioral of ret_db_1shot is
	
   type state_type is (st_wait, st_count, st_hold);
	signal PS, NS : state_type;

   constant WAIT_COUNT : integer := 5;  -- debounce wait counter
   
   signal s_en  : std_logic; 
   signal s_rco : std_logic; 
   
   signal s_one_shot_1 : std_logic; 
   signal s_one_shot_2 : std_logic; 
   
begin
	
   --------------------------------------------------
   -- input FSM 
   --------------------------------------------------
   sync_proc : process (CLK, NS)
	begin
		if (rising_edge(CLK)) then 
		   PS <= NS;
		end if;
	end process sync_proc;
	
	comb_proc : process (PS, s_rco, SIG) 
	begin 
      s_en <= '0';  
      LEVEL <= '0'; 
		
		case PS is
			when st_wait => 
            s_en <= '0';  
            LEVEL <= '0'; 

    			if (SIG = '0') then 
				   NS <= st_wait; 
				else 
				   NS <= st_count; 
				end if; 

				
			when st_count => 
            s_en <= '1';  
            LEVEL <= '0'; 
    			
            if (s_rco = '0') then 
				   NS <= st_count; 
            elsif (s_RCO = '1' and SIG = '1') then 
               NS <= st_hold;  
				else 
				   NS <= st_wait; 
				end if; 
				
            
			when st_hold => 
            s_en <= '0';  
            LEVEL <= '1'; 

            if (SIG = '0') then 
				   NS <= st_wait; 
				else 
				   NS <= st_hold; 
				end if; 
				
            
			when others =>
				NS <= st_wait;				
		end case;
		
	end process comb_proc;
   --------------------------------------------------



   --------------------------------------------------
   -- debounce counter
   --------------------------------------------------
   process(CLK)
      variable v_pulse_cnt : integer := 0;   
   begin
      if (rising_edge(CLK)) then 
         if (s_en = '1') then   
            if (v_pulse_cnt = WAIT_COUNT) then   
               v_pulse_cnt := 0;     -- reset pulse count
               s_rco <= '1'; -- reset pulse flip flop 
            else 
               v_pulse_cnt := v_pulse_cnt + 1; 
               s_rco <= '0';             
            end if; 
          else -- reset count if s_en turns off
             v_pulse_cnt := 0;     
             s_rco <= '0';            
         end if; 
      end if;
   end process; 

   
   
   --------------------------------------------------
   -- debounce counter
   --------------------------------------------------   
   process(CLK, s_rco, SIG)
   begin
      if (rising_edge(CLK)) then
         if (s_rco = '1' and SIG = '1') then 
            s_one_shot_1 <= '1'; 
            s_one_shot_2 <= s_one_shot_1;          
         else 
            s_one_shot_1 <= '0'; 
            s_one_shot_2 <= s_one_shot_1; 
         end if; 
      end if; 
   end process; 

   PULSE <= s_one_shot_2 or s_one_shot_1;
   --------------------------------------------------

      
end Behavioral;
