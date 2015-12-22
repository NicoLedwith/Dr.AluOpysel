-------------------------------------------------------------------------------
-- Company:  RAT Technologies
-- Engineer:  Various RAT rats
-- 
-- Create Date:    1/31/2012
-- Design Name: 
-- Module Name:    RAT_wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Wrapper for RAT MCU. This model provides a template to 
--    interface the RAT MCU to the Nexys2 development board. 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAT_wrapper is
    Port ( LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
           SEGMENTS : out   STD_LOGIC_VECTOR (7 downto 0); 
           DISP_EN  : out   STD_LOGIC_VECTOR (3 downto 0); 
           SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
           BUTTONS  : in    STD_LOGIC_VECTOR (3 downto 0); 
           RESET    : in    STD_LOGIC;
           CLK      : in    STD_LOGIC;
			  
			   -- VGA support signals -----------------------------
           VGA_RGB  : out std_logic_vector(7 downto 0);
           VGA_HS   : out std_logic;
           VGA_VS   : out std_logic);
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

   -------------------------------------------------------------------------------
   -- INPUT PORT IDS -------------------------------------------------------------
   CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
   CONSTANT BUTTONS_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"24";
	CONSTANT VGA_READ_ID : STD_LOGIC_VECTOR(7 downto 0) := x"93";
   -------------------------------------------------------------------------------
   
   -------------------------------------------------------------------------------
   -- OUTPUT PORT IDS ------------------------------------------------------------
   CONSTANT LEDS_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"40";
   CONSTANT SEGMENTS_ID   : STD_LOGIC_VECTOR (7 downto 0) := X"82";
   CONSTANT DISP_EN_ID    : STD_LOGIC_VECTOR (7 downto 0) := X"83";
	
		
	CONSTANT VGA_HADDR_ID  : STD_LOGIC_VECTOR(7 downto 0) := x"90";
   CONSTANT VGA_LADDR_ID  : STD_LOGIC_VECTOR(7 downto 0) := x"91";
   CONSTANT VGA_WRITE_ID  : STD_LOGIC_VECTOR(7 downto 0) := x"92"; 
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- Declare RAT_MCU ------------------------------------------------------------
   component RAT_MCU 
       Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
              OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
              PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
              IO_STRB  : out STD_LOGIC;
              RESET    : in  STD_LOGIC;
              INT      : in  STD_LOGIC;
              CLK      : in  STD_LOGIC);
   end component RAT_MCU;
   -------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------
   -- Declare VGA Driver ---------------------------------------------------------
   component vgaDriverBuffer is
      Port (CLK, we : in std_logic;
            wa   : in std_logic_vector (10 downto 0);
            wd   : in std_logic_vector (7 downto 0);
            Rout : out std_logic_vector(2 downto 0);
            Gout : out std_logic_vector(2 downto 0);
            Bout : out std_logic_vector(1 downto 0);
            HS   : out std_logic;
            VS   : out std_logic;
            pixelData : out std_logic_vector(7 downto 0));
   end component;

   -- Signals for connecting RAT_MCU to RAT_wrapper -------------------------------
   signal s_input_port  : std_logic_vector (7 downto 0);
   signal s_output_port : std_logic_vector (7 downto 0);
   signal s_port_id     : std_logic_vector (7 downto 0);
   signal s_load        : std_logic;
   --signal s_interrupt   : std_logic; -- not yet used
   
	  -- VGA signals
   signal s_vga_we   : std_logic;                       -- Write enable
   signal r_vga_wa   : std_logic_vector(10 downto 0);   -- Address to read from/write to  
   signal r_vga_wd   : std_logic_vector(7 downto 0);    -- Pixel data to write to framebuffer
   signal r_vgaData  : std_logic_vector(7 downto 0);    -- Pixel data read from framebuffer
	
   -- Register definitions for output devices ------------------------------------
   signal r_LEDS        : std_logic_vector (7 downto 0) := (others => '0'); 
   signal r_SEGMENTS    : std_logic_vector (7 downto 0) := (others => '0'); 
   signal r_DISP_EN     : std_logic_vector (3 downto 0) := (others => '0'); 
   -------------------------------------------------------------------------------

begin
   -- Instantiate RAT_MCU --------------------------------------------------------
   MCU: RAT_MCU
   port map(  IN_PORT  => s_input_port,
              OUT_PORT => s_output_port,
              PORT_ID  => s_port_id,
              RESET    => RESET,  
              IO_STRB  => s_load,
              INT      => BUTTONS(3),
              CLK      => CLK);         
   -------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
   -- Instantiate the VGA Driver
   VGA: vgaDriverBuffer
      port map(CLK => CLK,
               WE => s_vga_we,
               WA => r_vga_wa,
               WD => r_vga_wd,
               Rout => VGA_RGB(7 downto 5),
               Gout => VGA_RGB(4 downto 2),
               Bout => VGA_RGB(1 downto 0),
               HS => VGA_HS,
               VS => VGA_VS,
               pixelData => r_vgaData);

   ------------------------------------------------------------------------------- 
   -- MUX for selecting what input to read 
   -------------------------------------------------------------------------------
   inputs: process(s_port_id, SWITCHES, BUTTONS)
   begin
      if (s_port_id = SWITCHES_ID) then
         s_input_port <= SWITCHES;
      elsif (s_port_id = VGA_READ_ID) then 
         s_input_port <= r_vgaData; 
      else
         s_input_port <= x"00";
      end if;
   end process inputs;
   -------------------------------------------------------------------------------


   -------------------------------------------------------------------------------
   -- Decoder for updating output registers
   -- Register updates depend on rising clock edge and asserted load signal
   -------------------------------------------------------------------------------
   outputs: process(CLK, s_load, s_port_id) 
   begin   
      if (rising_edge(CLK)) then
         if (s_load = '1') then 
           
            if (s_port_id = LEDS_ID) then
               r_LEDS <= s_output_port;
            elsif (s_port_id = SEGMENTS_ID) then
               r_SEGMENTS <= s_output_port;
            elsif (s_port_id = DISP_EN_ID) then
               r_DISP_EN <= s_output_port(3 downto 0);
				elsif (s_port_id = VGA_HADDR_ID) then
               r_vga_wa(10 downto 8) <= s_output_port(2 downto 0);
				elsif (s_port_id = VGA_LADDR_ID) then
               r_vga_wa(7 downto 0) <= s_output_port;
				elsif (s_port_id = VGA_WRITE_ID) then
               r_vga_wd <= s_output_port;
					if(s_port_id = VGA_WRITE_ID) then
						s_vga_we <= '1';
					else
						s_vga_we <= '0';
					end if;
            end if;
           
         end if; 
      end if;
   end process outputs;      
   -------------------------------------------------------------------------------

   -- Register Interface Assignments ---------------------------------------------
   LEDS <= r_LEDS; 
   SEGMENTS <= r_SEGMENTS; 
   DISP_EN <= r_DISP_EN; 
   -------------------------------------------------------------------------------
--   VGA_RGB <= "11111111";
--	s_vga_we <= '1';
--	r_vga_wa <= "00000000000";
--	r_vga_wd <= "00000011";
--	VGA_HS <= '1';
--	VGA_VS <= '1';
   
end Behavioral;
