----------------------------------------------------------------------------------
-- Company:   CPE 233 Productions partnered with Colto Ledstrom
-- Engineer:  Various Engineers and Coltron Sundstrom, Nico Ledwith
-- 
-- Create Date:    20:59:29 02/04/2013 
-- Design Name: 
-- Module Name:    RAT Control Unit
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  Control unit (FSM) for RAT CPU
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


Entity CONTROL_UNIT is
    Port ( CLK           : in   STD_LOGIC;
           C             : in   STD_LOGIC;
           Z             : in   STD_LOGIC;
           INT           : in   STD_LOGIC;
           RESET         : in   STD_LOGIC;
           OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
           OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
              
           PC_LD         : out  STD_LOGIC;
           PC_INC        : out  STD_LOGIC;
           PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           PC_OE         : out  STD_LOGIC;			  

           SP_LD         : out  STD_LOGIC;
           SP_INCR       : out  STD_LOGIC;
           SP_DECR       : out  STD_LOGIC;
 
           RF_WR         : out  STD_LOGIC;
           RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
           RF_OE         : out  STD_LOGIC;

           ALU_OPY_SEL   : out  STD_LOGIC;
           ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);

           SCR_WR        : out  STD_LOGIC;
           SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
           SCR_OE        : out  STD_LOGIC;

           FLG_C_LD      : out  STD_LOGIC;
           FLG_C_SET     : out  STD_LOGIC;
           FLG_C_CLR     : out  STD_LOGIC;
           FLG_SHAD_LD   : out  STD_LOGIC;
           FLG_LD_SEL    : out  STD_LOGIC;
           FLG_Z_LD      : out  STD_LOGIC;
              
           I_FLAG_SET    : out  STD_LOGIC;
           I_FLAG_CLR    : out  STD_LOGIC;

           RST           : out  STD_LOGIC;
           IO_STRB       : out  STD_LOGIC);
end;

architecture Behavioral of CONTROL_UNIT is

   type state_type is (ST_init, ST_fet, ST_exec, ST_Interrupt);
   signal PS,NS : state_type;
   signal sig_OPCODE_7: std_logic_vector (6 downto 0);

begin
   
   -- concatenate the all opcodes into a 7-bit complete opcode for
	-- easy instruction decoding.
   sig_OPCODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;

   sync_p: process (CLK, NS, RESET)
   begin
      if (RESET = '1') then
	   PS <= ST_init;
	elsif (rising_edge(CLK)) then 
         PS <= NS;
 	end if;
   end process sync_p;


   comb_p: process (sig_OPCODE_7, PS, NS, C, Z, INT)
   begin
   
    	-- schedule everything to known values -----------------------
      PC_LD      <= '0';   
      PC_MUX_SEL <= "00";   	  
      PC_OE      <= '0';   
      PC_INC     <= '0';		  			      				

      SP_LD   <= '0';   
      SP_INCR <= '0'; 
      SP_DECR <= '0'; 
 
		RF_WR     <= '0';   
      RF_WR_SEL <= "00";   
      RF_OE     <= '0';
  
      ALU_OPY_SEL <= '0';  
      ALU_SEL     <= "0000";       			

      SCR_WR       <= '0';       
      SCR_OE       <= '0';    
      SCR_ADDR_SEL <= "00";  
      
      FLG_C_SET  <= '0';   FLG_C_CLR   <= '0'; 
      FLG_C_LD   <= '0';   FLG_Z_LD    <= '0'; 
      FLG_LD_SEL <= '0';   FLG_SHAD_LD <= '0';    

		I_FLAG_SET <= '0';        
      I_FLAG_CLR <= '0';    

      IO_STRB <= '0';      
      RST     <= '0'; 
            
   case PS is
      
      -- STATE: the init cycle ------------------------------------
	-- Initialize all control outputs to non-active states and 
      --   Reset the PC and SP to all zeros.
	when ST_init => 
         RST <= '1'; 
	   NS <= ST_fet;
						 	
				
      -- STATE: the fetch cycle -----------------------------------
      when ST_fet => 
			RST <= '0';
         NS <= ST_exec;
         PC_INC <= '1';  -- increment PC
			
			
		-- STATE: interrupt cycle ----------------------------------
		when ST_Interrupt =>
			PC_LD <= '1';
			PC_INC <= '0';
			PC_OE <= '1';
			RST <= '0';
			PC_MUX_SEL <= "10"; --3ff
			
			SP_LD <= '0';
			SP_INCR <= '0';
			SP_DECR <= '1';
			RST <= '0';
			
			SCR_OE <= '0';
			SCR_WR <= '1';
			SCR_ADDR_SEL <= "11";
			
			RF_OE <= '0';
			
			I_FLAG_CLR <= '1';
			I_FLAG_SET <= '0';
			
			FLG_SHAD_LD <= '1';
            
			NS <= ST_fet;
			
      -- STATE: the execute cycle ---------------------------------
      when ST_exec => 
			  if (INT = '1') then
					NS <= ST_Interrupt;
			  else
					NS <= ST_fet;
			  end if;
           PC_INC <= '0';  -- don't increment PC
				
	     case sig_OPCODE_7 is		

		  -- BRN -------------------
              when "0010000" =>
						PC_LD <= '1';
						PC_INC <= '0';
						PC_OE <= '0';
						RST <= '0';
						PC_MUX_SEL <= "00";
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';

		  -- SUB reg-reg  --------
              when "0000110" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0010";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
		 -- SUB reg-imm ----------
				  when "1011000" | "1011001" | "1011010" | "1011011" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0010";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';

		  -- IN reg-immed  ------
              when "1100100" | "1100101" | "1100110" | "1100111" =>		                     
						RF_WR_SEL <= "11";
						RF_WR <= '1';
						RF_OE <= '0';
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';

		  -- OUT reg-immed  ------
              when "1101000" | "1101001" | "1101010" | "1101011" =>		               
						RF_OE <= '1';
						RF_WR <= '0';
						RF_WR_SEL <= "10";	-- not used
						IO_STRB <= '1';
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';

		  -- MOV reg-immed  ------
              when "1101100" | "1101101" | "1101110" | "1101111" =>
						RF_WR <= '1';
						RF_OE <= '0';
						RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "1110";
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- MOV reg-reg -----
				when "0001001" =>
						RF_WR <= '1';
						RF_OE <= '0';
						RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1110";
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
	
						
			-- ADD reg-reg ------
              when "0000100" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0000";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
			
			-- ADD reg-imm ------
              when "1010000" | "1010001" | "1010010" | "1010011" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0000";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- ADDC reg-reg ------
              when "0000101" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0001";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- ADDC reg-imm ------
              when "1010100" | "1010101" | "1010110" | "1010111" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0001";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- AND reg-reg -----
				when "0000000" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0101";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- AND reg-imm -----
				when "1000000" | "1000001" | "1000010" | "1000011" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0101";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- ASR reg -----
				when "0100100" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1101";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- BRCC imm -----
				when "0010101" =>
					if( C = '0') then
						PC_LD <= '1';
						PC_INC <= '0';
						PC_OE <= '0';
						RST <= '0';
						PC_MUX_SEL <= "00";
					end if;
					
					FLG_Z_LD <= '0'; 
					FLG_C_LD <= '0';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- BRCS imm -----
				when "0010100" =>
					if( C = '1') then
						PC_LD <= '1';
						PC_INC <= '0';
						PC_OE <= '0';
						RST <= '0';
						PC_MUX_SEL <= "00";
					end if;
					
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- BREQ imm ------
				when "0010010" =>
					if( Z = '1') then
						PC_LD <= '1';
						PC_INC <= '0';
						PC_OE <= '0';
						RST <= '0';
						PC_MUX_SEL <= "00";
					end if;
					
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- BRNE imm ------
				when "0010011" =>
					if( Z = '0') then
						PC_LD <= '1';
						PC_INC <= '0';
						PC_OE <= '0';
						RST <= '0';
						PC_MUX_SEL <= "00";
					end if;
					
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';

			-- CALL imm -------
				when "0010001" =>
					PC_LD <= '1';  -- pc
					PC_INC <= '0';
					PC_OE <= '1';
					RST <= '0';		-- PC <- imm
					
					SCR_WR <= '1';		-- (SP-1) <- PC
					SCR_OE <= '0';
					SCR_ADDR_SEL <= "11";
					
					SP_LD <= '0';		-- SP <- SP - 1
					SP_INCR <= '0';
					SP_DECR <= '1';
					RST <= '0';
					
					FLG_Z_LD <= '0'; 
					FLG_C_LD <= '0';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- CLC non ------
				when "0110000" =>
					FLG_C_CLR <= '1';
					FLG_C_SET <= '0';
					FLG_C_LD <= '0';
					FLG_Z_LD <= '0';
					FLG_LD_SEL <= '0';
					FLG_SHAD_LD <= '0';
				
			-- CLI non ------
			when "0110101" =>
					I_FLAG_SET <= '0';
					I_FLAG_CLR <= '1';
			
			-- CMP reg-reg ------
				when "0001000" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0100";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '0';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- CMP reg-imm ------
				when "1100000" | "1100001" | "1100010" | "1100011" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0100";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '0';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- EXOR reg-reg ----
				when "0000010" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0111";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
		
			-- EXOR reg-imm -----
				when "1001000" | "1001001" | "1001010" | "1001011" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0111";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- LD reg-reg -----
				when "0001010" =>
						-- Rs <- (RD)
						RF_WR_SEL <= "01";
						RF_WR <= '1';
						RF_OE <= '0';
						
						SCR_WR <= '0';
						SCR_OE <= '1';
						SCR_ADDR_SEL <= "00";
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- LD reg-imm -----
				when "1110000" | "1110001" | "1110010" | "1110011" =>
						-- Rs <- (imm)
						RF_WR_SEL <= "01";
						RF_WR <= '1';
						RF_OE <= '0';
						
						SCR_WR <= '0';
						SCR_OE <= '1';
						SCR_ADDR_SEL <= "01";
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- LSL reg ------
				when "0100000" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1001";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- LSR reg ------
				when "0100001" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1010";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- OR reg-reg ----
				when "0000001" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0110";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- OR reg-imm ----
				when "1000100" | "1000101" | "1000110" | "1000111" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0110";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- POP reg ----
				when "0100110" =>
					SP_INCR <= '1';
					SP_DECR <= '0';
					SP_LD <= '0';
					RST <= '0';
					
					SCR_OE <= '1';
					SCR_WR <= '0';
					SCR_ADDR_SEL <= "10";
					
					RF_WR_SEL <= "01";
					RF_OE <= '0';
					RF_WR <= '1';
					
					FLG_Z_LD <= '0'; 
					FLG_C_LD <= '0';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- PUSH reg ----
				when "0100101" =>
					SCR_ADDR_SEL <= "11";
					SCR_WR <= '1';
					SCR_OE <= '0';
					
					RF_OE <= '1';
					RF_WR <= '0';
					RF_WR_SEL <= "00";
					
					SP_INCR <= '0';
					SP_DECR <= '1';
					SP_LD <= '0';
					RST <= '0';
					
					FLG_Z_LD <= '0'; 
					FLG_C_LD <= '0';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- RET non ----
				when "0110010" =>
					PC_LD <= '1';
					PC_INC <= '0';
					PC_OE <= '0';
					PC_MUX_SEL <= "01";
					
					SCR_ADDR_SEL <= "10";
					SCR_OE <= '1';
					SCR_WR <= '0';
					
					SP_INCR <= '1';
					SP_DECR <= '0';
					SP_LD <= '0';
					RST <= '0';
					
					FLG_Z_LD <= '0'; 
					FLG_C_LD <= '0';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
					
			-- RETID --
				when "0110110" =>
					PC_LD <= '1';
					PC_INC <= '0';
					PC_OE <= '0';
					PC_MUX_SEL <= "01";
					
					SCR_ADDR_SEL <= "10";
					SCR_OE <= '1';
					SCR_WR <= '0';
					
					SP_INCR <= '1';
					SP_DECR <= '0';
					SP_LD <= '0';
					RST <= '0';
					
					FLG_Z_LD <= '1'; 
					FLG_C_LD <= '1';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
					FLG_LD_SEL <= '1';
					FLG_SHAD_LD <= '0';
					
					I_FLAG_SET <= '0';
					I_FLAG_CLR <= '1';
			
			-- RETIE --
				when "0110111" =>
					PC_LD <= '1';
					PC_INC <= '0';
					PC_OE <= '0';
					PC_MUX_SEL <= "01";
					
					SCR_ADDR_SEL <= "10";
					SCR_OE <= '1';
					SCR_WR <= '0';
					
					SP_INCR <= '1';
					SP_DECR <= '0';
					SP_LD <= '0';
					RST <= '0';
					
					FLG_Z_LD <= '1'; 
					FLG_C_LD <= '1';
					FLG_C_SET <= '0';
					FLG_C_CLR <= '0';
					FLG_LD_SEL <= '1';
					FLG_SHAD_LD <= '0';
					
					I_FLAG_SET <= '1';
					I_FLAG_CLR <= '0';
			
			-- ROL reg ----
				when "0100010" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1011";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';

			-- ROR reg ----
				when "0100011" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1100";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- SEC non -----
				when "0110001" =>
					FLG_C_CLR <= '0';
					FLG_C_SET <= '1';
					FLG_C_LD <= '0';
					FLG_Z_LD <= '0';
					
			-- SEI
				when "0110100" =>
					I_FLAG_SET <= '1';
					I_FLAG_CLR <= '0';
					
			-- ST reg-reg ----
				when "0001011" =>
						RF_OE <= '1';
						RF_WR <= '0';
						RF_WR_SEL <= "00";
						
						SCR_ADDR_SEL <= "00";
						SCR_WR <= '1';
						SCR_OE <= '0';
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- ST reg-imm ----
				when "1110100" | "1110101" | "1110110" | "1110111" =>
						RF_OE <= '1';
						RF_WR <= '0';
						RF_WR_SEL <= "00";
						
						SCR_ADDR_SEL <= "01";
						SCR_WR <= '1';
						SCR_OE <= '0';
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- SUBC reg-reg ----
				when "0000111" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "0011";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
			-- SUBC reg-imm -----
				when "1011100" | "1011101" | "1011110" | "1011111" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "0011";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '1';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- TEST reg-reg ------
				when "0000011" =>
						ALU_OPY_SEL <= '0';
						ALU_SEL <= "1000";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '0';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
						
			-- TEST reg-imm -----
				when "1001100" | "1001101" | "1001110" | "1001111" =>
						ALU_OPY_SEL <= '1';
						ALU_SEL <= "1000";
						RF_OE <= '1';
						RF_WR_SEL <= "00";
						RF_WR <= '0';
						
						FLG_Z_LD <= '1'; 
						FLG_C_LD <= '1';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
	
			-- WSP reg -----
				when "0101000" =>
						RF_OE <= '1';
						RF_WR <= '0';
						RF_WR_SEL <= "00";
						
						SP_LD <= '1';
						SP_INCR <= '0';
						SP_DECR <= '0';
						
						SCR_OE <= '0';
						PC_OE <= '0';
						
						FLG_Z_LD <= '0'; 
						FLG_C_LD <= '0';
						FLG_C_SET <= '0';
						FLG_C_CLR <= '0';
						FLG_LD_SEL <= '0';
						FLG_SHAD_LD <= '0';
			
              when others =>		-- for inner case
                  NS <= ST_fet;       

            end case; -- inner execute case statement


          when others =>    -- for outer case
               NS <= ST_fet;		    
			 
				 
	    end case;  -- outer init/fetch/execute case
       
   end process comb_p;
    
end Behavioral;

