library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity SP is
		port ( RST,CLK,LD,INCR,DECR: in std_logic; 
             DATA_IN : in std_logic_vector (7 downto 0); 
             DATA_OUT : out std_logic_vector(7 downto 0));
end SP;

architecture my_count of SP is
	signal s_cnt : std_logic_vector(7 downto 0);
	begin
		process (CLK, RST, LD, INCR, DECR)
			begin
				if (RST = '1') then
					s_cnt <= "00000000"; -- asynchronous clear
				elsif (rising_edge(CLK)) then
					if (LD = '1') then
						s_cnt <= DATA_IN; -- Load Condition
					else
						if (INCR = '1') then
							s_cnt <= s_cnt + 1; -- increment
						else
							if (DECR = '1') then
								s_cnt <= s_cnt - 1; -- Decrement
							else
								s_cnt <= S_cnt; -- Hold
							end if;
						end if;
					end if;
				end if;
				
end process;


	DATA_OUT <= s_cnt;
end my_count;