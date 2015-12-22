----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:00 10/26/2015 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_UNSIGNED.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           SEL : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           RESULT : out  STD_LOGIC_VECTOR (7 downto 0);
           C : out  STD_LOGIC;
           Z : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

begin
	process(A, B, Cin, SEL)
		variable v_res : std_logic_vector(8 downto 0);
		variable tmp : std_logic_vector(8 downto 0);
	begin 
	case SEL is
		when "0000" => --Add
			v_res := ('0' & A) + ('0' & B);
			C <= v_res(8);
		when "0001" => --AddC
			v_res := ('0' & A) + ('0' & B) + Cin;
			C <= v_res(8);
		when "0010" => --Sub
			v_res := ('0' & A) - ('0' & B);
			C <= v_res(8);
		when "0011" => --SubC
			v_res := ('0' & A) - ('0' & B) - Cin;
			C <= v_res(8);
		when "0100" => --Cmp
			tmp := ('0' & A) - ('0' & B);
			v_res := tmp;
			C <= tmp(8);
			if(tmp = "000000000") then z <= '1';
			end if;
		when "0101" => --And
			v_res := '0' & (A and B);
			C <= '0';
		when "0110" => --Or
			v_res := '0' & (A or B);
			C <= '0';
		when "0111" => --Exor
			v_res := '0' & (A xor B);
			C <= '0';
		when "1000" => --Test
			tmp := '0' & (A and B);
			v_res := tmp;
			C <= '0';
			if(tmp = "000000000") then z <= '1';
			end if;
		when "1001" => --LSL
			v_res := A & Cin;
			C <= v_res(8);
		when "1010" => --LSR
			tmp := Cin & A;
			v_res := '0' & tmp(8 downto 1);
			c <= A(0);
		when "1011" => --ROL
			v_res := '0' & A(6 downto 0) & A(7);
			c <= A(7);
		when "1100" => --ROAR
			v_res := '0' & A(0) & A(7 downto 1);
			C <= A(0);
		when "1101" => --ASR
			v_res := '0' & A(7) & A(7 downto 1);
			C <= A(0);
		when "1110" => --MOV
			v_res := '0' & B;
			C <= Cin;
		when others => 
			v_res := (others => '1');
			c <= Cin;
	end case;
	
	if (v_res(7 downto 0) = x"00") then
			z <= '1';
	else
			z <= '0';
	end if;
	
	Result <= v_res(7 downto 0);
end process;
		
end Behavioral;

