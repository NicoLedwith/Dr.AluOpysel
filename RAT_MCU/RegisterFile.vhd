-- Comments and stuff

-- end comments


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterFile is
    Port ( DIN   : in     STD_LOGIC_VECTOR (7 downto 0);
           DX_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
           ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
           ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
			  RF_OE  : in     STD_LOGIC;
           RF_WR  : in     STD_LOGIC;
           CLK    : in     STD_LOGIC);
end RegisterFile;

architecture Behavioral of RegisterFile is
	TYPE memory is array (0 to 31) of std_logic_vector(7 downto 0);
	SIGNAL REG: memory := (others=>(others=>'0'));
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
	          if (RF_WR = '1') then
			REG(conv_integer(ADRX)) <= DIN;
		  end if;
		end if;
	end process;

	DX_OUT <= REG(conv_integer(ADRX)) when RF_OE='1' else (others=>'Z');
	DY_OUT <= REG(conv_integer(ADRY));
	
end Behavioral;
