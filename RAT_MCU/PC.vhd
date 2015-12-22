library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity PC is
		port ( RST,CLK,PC_LD,PC_OE,PC_INC : in std_logic; 
             FROM_IMMED : in std_logic_vector (9 downto 0); 
             FROM_STACK : in std_logic_vector (9 downto 0); 
             FROM_INTRR : in std_logic_vector (9 downto 0); 
             PC_MUX_SEL : in std_logic_vector (1 downto 0); 
             PC_COUNT : out std_logic_vector (9 downto 0); 
             PC_TRI : out std_logic_vector(9 downto 0));
end PC;

architecture my_count of PC is
	signal s_cnt : std_logic_vector(9 downto 0);
	begin
		process (CLK, RST, PC_LD, PC_INC)
			begin
				if (RST = '1') then
					s_cnt <= "0000000000"; -- asynchronous clear
				elsif (rising_edge(CLK)) then
					if (PC_LD = '1') then
						case PC_MUX_SEL is
							when "00" =>
								s_cnt <= FROM_IMMED;
							when "01" =>
								s_cnt <= FROM_STACK;
							when "10" =>
								s_cnt <= FROM_INTRR;
							when others => s_cnt <= "0000000000";
						end case;
					else
						if (PC_INC = '1') then
							s_cnt <= s_cnt + 1; -- increment
						else
							s_cnt <= s_cnt;	  -- hold
						end if;
					end if;
				end if;
				
end process;

process (PC_OE, s_cnt)
	begin
		if(PC_OE = '1') then
			PC_TRI <= s_cnt;
		else
			PC_TRI <= "ZZZZZZZZZZ";
		end if;
			
end process;

	PC_COUNT <= s_cnt;
end my_count;