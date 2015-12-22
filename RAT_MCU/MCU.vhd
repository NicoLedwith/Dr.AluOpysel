----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: James Ratner
-- 
-- Create Date:    20:59:29 02/04/2013 
-- Design Name: 
-- Module Name:    RAT_MCU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Starter MCU file for RAT MCU. 
--
-- Dependencies: 
--
-- Revision: 3.00
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAT_MCU is
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           RESET    : in  STD_LOGIC;
           CLK      : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB  : out  STD_LOGIC);
end RAT_MCU;



architecture Behavioral of RAT_MCU is

   component prog_rom  
      port (     ADDRESS : in std_logic_vector(9 downto 0); 
             INSTRUCTION : out std_logic_vector(17 downto 0); 
                     CLK : in std_logic);  
   end component;

   component ALU
       Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
              B : in  STD_LOGIC_VECTOR (7 downto 0);
              Cin : in  STD_LOGIC;
              SEL : in  STD_LOGIC_VECTOR(3 downto 0);
              C : out  STD_LOGIC;
              Z : out  STD_LOGIC;
              RESULT : out  STD_LOGIC_VECTOR (7 downto 0));
   end component;
	
	component MUX
		Port ( TO_ALU : out std_logic_vector(7 downto 0);
				FROM_Y : in std_logic_vector(7 downto 0);
				FROM_IR : in std_logic_vector(7 downto 0);
				SEL : in std_logic );
	end component;

	component MUX_4in
		Port ( TO_REG : out std_logic_vector(7 downto 0);
				FROM_IN : in std_logic_vector(7 downto 0);
				FROM_BUS : in std_logic_vector(7 downto 0);
				FROM_ALU : in std_logic_vector(7 downto 0);
				SEL : in std_logic_vector(1 downto 0));
	end component;
	
	component FLAGS
		Port ( FLG_C_SET : in  STD_LOGIC;
           FLG_C_CLR : in  STD_LOGIC;
           FLG_C_LD : in  STD_LOGIC;
           FLG_Z_LD : in  STD_LOGIC;
           FLG_LD_SEL : in  STD_LOGIC;
           FLG_SHAD_LD : in  STD_LOGIC;
           C : in  STD_LOGIC;
           Z : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           C_FLAG : out  STD_LOGIC;
           Z_FLAG : out  STD_LOGIC);
	end component;

   component CONTROL_UNIT 
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
   end component;

   component RegisterFile 
       Port ( DIN   : in     STD_LOGIC_VECTOR (7 downto 0);
              DX_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
              DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
              ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
              RF_OE  : in     STD_LOGIC;
              RF_WR     : in     STD_LOGIC;
              CLK    : in     STD_LOGIC);
   end component;

   component PC 
      port ( RST,CLK,PC_LD,PC_OE,PC_INC : in std_logic; 
             FROM_IMMED : in std_logic_vector (9 downto 0); 
             FROM_STACK : in std_logic_vector (9 downto 0); 
             FROM_INTRR : in std_logic_vector (9 downto 0); 
             PC_MUX_SEL : in std_logic_vector (1 downto 0); 
             PC_COUNT : out std_logic_vector (9 downto 0); 
             PC_TRI : out std_logic_vector(9 downto 0)); 
   end component; 
	
	component SCR
		Port ( DATA : inout STD_LOGIC_VECTOR (9 downto 0);
				 ADDR : in STD_LOGIC_VECTOR (7 downto 0);
				 OE : in STD_LOGIC;
				 WE : in STD_LOGIC;
				 CLK : in STD_LOGIC);
	end component;
	
	component SP
		port ( RST,CLK,LD,INCR,DECR: in std_logic; 
             DATA_IN : in std_logic_vector (7 downto 0); 
             DATA_OUT : out std_logic_vector(7 downto 0));
	end component;


	component FourRealMux
		port ( 	TO_SCR : out std_logic_vector(7 downto 0);
					FROM_Reg : in std_logic_vector(7 downto 0);
					FROM_Insta : in std_logic_vector(7 downto 0);
					FROM_SP : in std_logic_vector(7 downto 0);
					FROM_Subraptor : in std_logic_vector(7 downto 0);
					SEL : in std_logic_vector(1 downto 0));
	end component;
	
	component Subraptor
		port	(	Food : in std_logic_vector(7 downto 0);
					Feces : out std_logic_vector(7 downto 0));
	end component;
	
	component AND_GATE
		Port ( 	INT : in  STD_LOGIC;
					MASK : in  STD_LOGIC;
					CU_INT : out  STD_LOGIC);
	end component;
	
	component IMask
		Port ( 	i_SET : in  STD_LOGIC;
					I_CLR : in  STD_LOGIC;
					clk : in  STD_LOGIC;
					oot : out  STD_LOGIC);
	end component;	

	component ret_db_1shot
		Port ( CLK: in std_logic;
				 SIG: in std_logic;
				 pulse: out std_logic;
				 level: out std_logic);
	end component;

   -- intermediate signals ----------------------------------
   signal s_pc_ld : std_logic := '0'; 
   signal s_pc_inc : std_logic := '0'; 
   signal s_pc_oe : std_logic := '0'; 
   signal s_rst : std_logic := '0';
	
		--flag sigs
	signal s_cu_flags_cset,s_cu_flags_cclr,s_cu_flags_cld,s_cu_flags_zld,s_cu_flags_ldsel : std_logic := '0';
	signal s_cu_flags_shadld, s_flags_alu : std_logic := '0';
	signal s_flags_cu_z, s_alu_flags_c, s_alu_flags_z : std_logic := '0';
	
		--cu sigs
	signal s_cu_reg_wr, s_cu_reg_oe, s_cu_alu_mux_sel, s_scr_we, s_scr_oe : std_logic := '0';
	
   signal s_pc_mux_sel, s_cu_reg_mux, s_scr_addr_sel: std_logic_vector(1 downto 0) := "00"; 
   signal s_pc_count : std_logic_vector(9 downto 0) := (others => '0');   
   signal s_inst_reg : std_logic_vector(17 downto 0) := (others => '0');
	signal s_reg_alu_mux, s_alu_mux_alu, s_alu_reg_mux, s_reg_mux_reg : std_logic_vector(7 downto 0) := (others => '0');
	signal s_cu_alu_sel : std_logic_vector(3 downto 0) := (others => '0');
	
	signal s_scr_mux_scr : std_logic_vector(7 downto 0) := "00000000";
--		sp signals
	signal s_sp_ld, s_sp_incr, s_sp_decr: std_logic := '0';
	signal s_SP_SCR_MUX, S_sp_SCR_MUX_MINUS : std_logic_vector(7 downto 0) := "00000000";
	
   signal s_multi_bus : std_logic_vector(9 downto 0) := (others => '0'); 

--		INT_MASKING
	signal s_MASK_AND, s_AND_CU_INT, s_i_set, s_i_clr: std_logic;
	
-- debounce
	signal s_debounce_and : std_logic;
   

   -- helpful aliases ------------------------------------------------------------------
   alias s_ir_immed_bits : std_logic_vector(9 downto 0) is s_inst_reg(12 downto 3); 
   
   

begin

	OUT_PORT <= s_multi_bus (7 downto 0);
	PORT_ID <= s_inst_reg (7 downto 0);

   my_prog_rom: prog_rom  
   port map(     ADDRESS => s_pc_count, 
             INSTRUCTION => s_inst_reg, 
                     CLK => CLK); 

   my_alu: ALU
   port map ( A => s_multi_bus(7 downto 0),       
              B => s_alu_mux_alu,       
              Cin => s_flags_alu,     
              SEL => s_cu_alu_sel,     
              C => s_alu_flags_c,        
              Z => s_alu_flags_z,       
              RESULT => s_alu_reg_mux);

	alu_mux: MUX
	port map ( TO_ALU => s_alu_mux_alu,
				  FROM_Y => s_reg_alu_mux,
				  FROM_IR => s_inst_reg(7 downto 0),
				  SEL => s_cu_alu_mux_sel
					);
					
	reg_mux: MUX_4in
	port map (TO_REG => s_reg_mux_reg,
				 FROM_BUS => s_multi_bus(7 downto 0),
				 FROM_IN => IN_PORT,
				 FROM_ALU => s_alu_reg_mux,
				 SEL => s_cu_reg_mux);

	my_flags: FLAGS
	port map ( FLG_C_SET => s_cu_flags_cset,
				  FLG_C_CLR => s_cu_flags_cclr,
				  FLG_C_LD  => s_cu_flags_cld,
				  FLG_Z_LD  => s_cu_flags_zld,
				  FLG_LD_SEL => s_cu_flags_ldsel,
				  FLG_SHAD_LD => s_cu_flags_shadld,
				  C_FLAG => s_flags_alu,
				  Z_FLAG => s_flags_cu_z,
				  C => s_alu_flags_c,
				  Z => s_alu_flags_z,
				  CLK => CLK);

   my_cu: CONTROL_UNIT 
   port map ( CLK           => CLK, 
              C             => s_flags_alu, 
              Z             => s_flags_cu_z, 
              INT           => s_and_cu_int, 
              RESET         => RESET, 
              OPCODE_HI_5   => s_inst_reg(17 downto 13), 
              OPCODE_LO_2   => s_inst_reg(1 downto 0), 
              
              PC_LD         => s_pc_ld, 
              PC_INC        => s_pc_inc,  
              PC_OE         => s_pc_oe, 
              PC_MUX_SEL    => s_pc_mux_sel, 
              SP_LD         => s_sp_ld, 
              SP_INCR       => s_sp_incr, 
              SP_DECR       => s_sp_decr, 
              RF_WR         => s_cu_reg_wr, 
              RF_WR_SEL     => s_cu_reg_mux, 
              RF_OE         => s_cu_reg_oe, 
              ALU_OPY_SEL   => s_cu_alu_mux_sel, 
              ALU_SEL       => s_cu_alu_sel, 
              SCR_WR        => s_scr_wE, 
              SCR_OE        => s_scr_oe, 
              SCR_ADDR_SEL  => s_scr_addr_sel ,   
              FLG_C_LD      => s_cu_flags_cld, 
              FLG_C_SET     => s_cu_flags_cset, 
              FLG_C_CLR     => s_cu_flags_cclr, 
              FLG_SHAD_LD   => s_cu_flags_shadld, 
              FLG_LD_SEL    => s_cu_flags_ldsel, 
              FLG_Z_LD      => s_cu_flags_zld, 
              I_FLAG_SET    => s_i_set, 
              I_FLAG_CLR    => s_i_clr,  

              RST           => s_rst,
              IO_STRB       => IO_STRB);
              

   my_regfile: RegisterFile 
   port map ( DIN   => s_reg_mux_reg,   
              DX_OUT => s_multi_bus(7 downto 0),   
              DY_OUT => s_reg_alu_mux,   
              ADRX   => s_inst_reg(12 downto 8),   
              ADRY   => s_inst_reg(7 downto 3),   
              RF_OE  => s_cu_reg_oe,   
              RF_WR     => s_cu_reg_wr,   
              CLK    => CLK); 


   my_PC: PC 
   port map ( RST        => s_rst,
              CLK        => CLK,
              PC_LD      => s_pc_ld,
              PC_OE      => s_pc_oe,
              PC_INC     => s_pc_inc,
              FROM_IMMED => s_inst_reg(12 downto 3),
              FROM_STACK => s_multi_bus,
              FROM_INTRR => "1111111111",
              PC_MUX_SEL => s_pc_mux_sel,
              PC_COUNT   => s_pc_count,
              PC_TRI     => s_multi_bus); 

	my_SP: SP
	port map (  RST => s_RST,
					LD => s_sp_ld,
					INCR => s_sp_incr,
					DECR => s_sp_decr,
					DATA_IN => s_multi_bus(7 downto 0),
					CLK => CLK,
					DATA_OUT => s_sp_SCR_mux);
					
	SCR_MUX: FourRealMux
	port map (	FROM_REG => S_REG_ALU_MUX,
					From_Insta => S_INST_REG(7 downto 0),
					From_SP => s_sp_scr_mux,
					From_SUBRAPTOR => s_sp_scr_mux_minus,
					SEL => s_scr_addr_sel,
					TO_SCR => s_scr_mux_scr);
	
	my_SCR: SCR
	port map (	DATA => s_multi_bus,
					ADDR => s_scr_mux_scr,
					OE => s_scr_oe,
					WE => s_scr_we,
					CLK => CLK);
					
	my_raptor: Subraptor
	port map ( Food => s_sp_SCR_mux,
				  Feces => s_sp_scr_mux_minus);
				  
	JimCarry: IMASK
	port map ( 	i_SET => s_i_set,
					I_CLR => s_i_clr,
					clk => clk,
					oot => s_Mask_and);
				
	AND_Gator: AND_GATE
	port map (	int => INT,
					mask => s_mask_and,
					cu_int => s_and_cu_int);
					
--	Debounce: ret_db_1shot
--	port map ( clk => clk,
--				  sig => INT,
--				  pulse => s_debounce_and,
--				  level => open);

end Behavioral;

