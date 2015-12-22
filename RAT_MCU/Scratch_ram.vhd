library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity SCR is
	Port ( DATA : inout STD_LOGIC_VECTOR (9 downto 0);
			ADDR : in STD_LOGIC_VECTOR (7 downto 0);
			OE : in STD_LOGIC;
			WE : in STD_LOGIC;
			CLK : in STD_LOGIC);
end SCR;

architecture SCR of SCR is

	TYPE memory is array (0 to 255) of std_logic_vector(9 downto 0);
	-----------------------------------------------------------(1)	
	SIGNAL BD_RAM : memory := (others => (others =>'0') );
	
	begin
		my_bi_dir: process(CLK,OE,WE,DATA,ADDR,BD_RAM)
		begin
		--------------------------------------------------------(2)
			if (OE = '1') then
			DATA <= BD_RAM(conv_integer(ADDR));
			--------------------------------------------------------(3)
			else
			-----------------------------------------------------(4)
			DATA <= (others => 'Z');
			-----------------------------------------------------(5)
			if (WE = '1') then
				if (rising_edge(CLK)) then
					BD_RAM(conv_integer(ADDR)) <= DATA;
				end if;
			end if;
		end if;
		
end process my_bi_dir;

end SCR;
