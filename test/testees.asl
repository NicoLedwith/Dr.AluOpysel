

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;---------------------------------------------------------------------
(0002)                            || ; An expanded "draw_dot" program that includes subrountines to draw
(0003)                            || ; vertical lines, horizontal lines, and a full background. 
(0004)                            || ; 
(0005)                            || ; As written, this programs does the following: 
(0006)                            || ;   1) draws a the background blue (draws all the tiles)
(0007)                            || ;   2) draws a red dot
(0008)                            || ;   3) draws a red horizontal lines
(0009)                            || ;   4) draws a red vertical line
(0010)                            || ;
(0011)                            || ; Author: Bridget Benson 
(0012)                            || ; Modifications: bryan mealy
(0013)                            || ;   revsion 11-12-2013: simplified drawdot, added comments
(0014)                            || ;---------------------------------------------------------------------
(0015)                            || 
(0016)                            || ;---------------------------------------------------------------------
(0017)                            || ;Authors: Colton Sundstrom & Nico Ledwith
(0018)                            || ;Group:	Ledstrom Labs
(0019)                            || ;Project Name: Adventure time with Dr.Alu OpySel
(0020)                            || ;Description: A platform runner based on the RAT MCU architecture
(0021)                            || ;encorporating the VGA_Driver peripheral. 
(0022)                            || ;
(0023)                            || ;Version: 0.1(Condor)
(0024)                            || ;--------------------------------------------------------------------
(0025)                            || 
(0026)                            || .CSEG
(0027)                       016  || .ORG 0x10
(0028)                            || 
(0029)                            || ;---------------------------------------------------------------------
(0030)                            || ;- register definitions 
(0031)                            || ;---------------------------------------------------------------------
(0032)                       144  || .EQU VGA_HADD  = 0x90
(0033)                       145  || .EQU VGA_LADD  = 0x91
(0034)                       146  || .EQU VGA_COLOR = 0x92
(0035)                       037  || .EQU KEYBOARD  = 0x25
(0036)                       129  || .EQU SSEG      = 0x81
(0037)                       064  || .EQU LEDS      = 0x40
(0038)                            || ;---------------------------------------------------------------------
(0039)                            || 
(0040)                       000  || .EQU BG_COLOR       = 0x00             	;Background:  Black
(0041)                       063  || .equ Dr_ALU_OPYSEL	= 0x3F				;Player Color:Yellow
(0042)                       192  || .equ G_C			= 0xC0				;Ground Color:Blue
(0043)                            || 
(0044)                            || 
(0045)                       031  || .EQU MY_INSIDE_FOR_COUNT    = 0x1F		;Used for the Waitx SR
(0046)                       255  || .EQU MY_MIDDLE_FOR_COUNT    = 0xFF
(0047)                       255  || .EQU MY_OUTSIDE_FOR_COUNT   = 0xFF
(0048)                            || 
(0049)                            || ;---------------------------------------------------------------------
(0050)                            || ;- r6 is used for color
(0051)                            || ;- r7 is used for working Y coordinate
(0052)                            || ;- r8 is used for working X coordinate
(0053)                            || 
(0054)                            || ;- r13 holds Alu's Y position
(0055)                            || 
(0056)                            || ;- r18 holds Left Hole position
(0057)                            || ;- r19 holds Right Hole potition
(0058)                            || ;---------------------------------------------------------------------
(0059)                            || 
(0060)                            || ;---------------------------------------------------------------------
(0061)                     0x010  || init:
(0062)  CS-0x010  0x08779         || 			CALL   draw_background         ; draw using default color
(0063)                            || 
(0064)  CS-0x011  0x36711         || 			MOV    r7, 0x11                ; generic Y coordinate
(0065)  CS-0x012  0x04D39         || 			MOV	   r13, r7				   ; copy alu's y_pos
(0066)  CS-0x013  0x36812         || 			MOV    r8, 0x12                ; generic X coordinate
(0067)  CS-0x014  0x3663F         || 			MOV    r6, 0x3F                ; color
(0068)  CS-0x015  0x087C9         || 			CALL   draw_dot                ; draw yellow square 
(0069)                            || 
(0070)  CS-0x016  0x366C0         || 			MOV 	r6,0xC0
(0071)  CS-0x017  0x36800         || 			MOV    r8,0x00                 ; starting x coordinate
(0072)  CS-0x018  0x36712         || 			MOV    r7,0x12                 ; start y coordinate
(0073)  CS-0x019  0x36927         || 			MOV    r9,0x27                 ; ending x coordinate
(0074)  CS-0x01A  0x08719         || 			CALL   draw_horizontal_line
(0075)  CS-0x01B  0x1A000         || 			SEI
(0076)                            || 
(0077)  CS-0x01C  0x08179         || 			call	MakeHole				;Init Hole Placement
(0078)                            || 
(0079)  CS-0x01D  0x08109  0x01D  || main:	    call	MoveHole				
(0080)  CS-0x01E  0x081F1         || 			call	END_CHECK				
(0081)  CS-0x01F  0x086B9         || 			call	waitx
(0082)  CS-0x020  0x080E8         || 			BRN		main                    ; continuous loop 
(0083)                            || 
(0084)                            || 
(0085)                            || ;--------------------------------------------------------------------
(0086)  CS-0x021  0x04789  0x021  || MoveHole:	mov		r7, r17				;Moves the Hole left by subtracting
(0087)  CS-0x022  0x2D201         || 			sub 	r18, 0x01			;a X value, then fills the old hole
(0088)  CS-0x023  0x2D301         || 			sub 	r19, 0x01			;with the Ground Color.
(0089)  CS-0x024  0x0A178         || 			BRCS 	MakeHole
(0090)  CS-0x025  0x04899         || 			mov 	r8, r19
(0091)  CS-0x026  0x36600         || 			mov 	r6, bg_color
(0092)  CS-0x027  0x087C9         || 			call 	draw_dot
(0093)  CS-0x028  0x08151         || 			call 	fill_hole
(0094)  CS-0x029  0x18002         || 			ret
(0095)                            || 
(0096)  CS-0x02A  0x04891  0x02A  || fill_hole:	mov 	r8, r18				;Fills the Previous Hole
(0097)  CS-0x02B  0x28801         || 			add 	r8, 0x01
(0098)  CS-0x02C  0x366C0         || 			mov 	r6, g_c
(0099)  CS-0x02D  0x087C9         || 			call 	draw_dot
(0100)  CS-0x02E  0x18002         || 			ret
(0101)                            || 			
(0102)                            || ;'MakeHole' initializes the Hole placement to the right of the screen.
(0103)  CS-0x02F  0x36712  0x02F  || MakeHole:	MOV 	r7,0x12				; y		
(0104)  CS-0x030  0x36827         || 			MOV 	r8,0x27				; x (hole right side)
(0105)  CS-0x031  0x05139         || 			MOV 	r17, r7
(0106)  CS-0x032  0x05241         || 			MOV 	r18, r8				; copy coords
(0107)  CS-0x033  0x36600         || 			MOV 	r6, bg_color
(0108)  CS-0x034  0x087C9         || 			CALL 	draw_dot
(0109)                            || 
(0110)  CS-0x035  0x36826         || 			MOV 	r8,0x26
(0111)  CS-0x036  0x05341         || 			MOV 	r19, r8
(0112)  CS-0x037  0x087C9         || 			CALL 	draw_dot
(0113)                            || 
(0114)  CS-0x038  0x36800         || 			mov 	r8, 0x00
(0115)  CS-0x039  0x366C0         || 			mov 	r6, g_c
(0116)  CS-0x03A  0x087C9         || 			call 	draw_dot
(0117)                            || 
(0118)  CS-0x03B  0x36801         || 			mov 	r8, 0x01
(0119)  CS-0x03C  0x087C9         || 			call 	draw_dot
(0120)  CS-0x03D  0x18002         || 			ret
(0121)                            || ;------------------------------------------------------------------------
(0122)                            || ;Checks if the player is occupying the space above the hole.
(0123)  CS-0x03E  0x30D11  0x03E  || END_CHECK:	cmp 	r13, 0x11
(0124)  CS-0x03F  0x0822B         || 			brne 	safe
(0125)  CS-0x040  0x04D98         || 			CMP 	r13, r19
(0126)  CS-0x041  0x08232         || 			breq 	ALU_End
(0127)  CS-0x042  0x04D90         || 			cmp 	r13, r18
(0128)  CS-0x043  0x08232         || 			breq 	alu_end
(0129)  CS-0x044  0x08228         || 			brn 	safe
(0130)  CS-0x045  0x18002  0x045  || safe:		ret
(0131)                            || 
(0132)                            || ;-----------------------------------------------------------------------
(0133)                            || ;Draws an END that blinks, signifying the end of the game.
(0134)  CS-0x046  0x1A001  0x046  || ALU_END:	CLI
(0135)  CS-0x047  0x08779         || 			call 	draw_background
(0136)  CS-0x048  0x086B9         || 			call	waitx
(0137)  CS-0x049  0x08281         || 			call 	draw_E
(0138)  CS-0x04A  0x086B9         || 			CALL 	waitx
(0139)                            || 
(0140)  CS-0x04B  0x08311         || 			call 	draw_D
(0141)  CS-0x04C  0x086B9         || 			call 	waitx
(0142)                            || 			
(0143)  CS-0x04D  0x08421         || 			call 	draw_N
(0144)  CS-0x04E  0x086B9         || 			call	waitx
(0145)  CS-0x04F  0x08230         || 			brn		ALU_END
(0146)                            || 
(0147)                            || 			
(0148)                            || 
(0149)  CS-0x050  0x36607  0x050  || DRAW_E:		MOV 	r6,0x07
(0150)  CS-0x051  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0151)  CS-0x052  0x3670A         || 			MOV    	r7,0x0A                 ; start y coordinate
(0152)  CS-0x053  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0153)  CS-0x054  0x08749         || 			CALL   	draw_vertical_line
(0154)                            || 			
(0155)  CS-0x055  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0156)  CS-0x056  0x3670A         || 			MOV    	r7,0x0A                 ; start y coordinate
(0157)  CS-0x057  0x3690C         || 			MOV    	r9,0x0C                 ; ending x coordinate
(0158)  CS-0x058  0x08719         || 			CALL   	draw_HORIZONTAL_line
(0159)                            || 
(0160)  CS-0x059  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0161)  CS-0x05A  0x3670F         || 			MOV    	r7,0x0F                 ; start y coordinate
(0162)  CS-0x05B  0x3690C         || 			MOV    	r9,0x0C                 ; ending x coordinate
(0163)  CS-0x05C  0x08719         || 			CALL   	draw_HORIZONTAL_line
(0164)                            || 
(0165)  CS-0x05D  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0166)  CS-0x05E  0x36714         || 			MOV    	r7,0x14                 ; start y coordinate
(0167)  CS-0x05F  0x3690C         || 			MOV    	r9,0x0C                 ; ending x coordinate
(0168)  CS-0x060  0x08719         || 			CALL   	draw_HORIZONTAL_line
(0169)                            || 
(0170)  CS-0x061  0x18002         || 			ret
(0171)                            || 
(0172)  CS-0x062  0x36607  0x062  || DRAW_D:		MOV 	r6,0x07
(0173)  CS-0x063  0x36818         || 			MOV    	r8,0x18                 ; starting x coordinate
(0174)  CS-0x064  0x3670A         || 			MOV    	r7,0x0A                ; start y coordinate
(0175)  CS-0x065  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0176)  CS-0x066  0x08749         || 			CALL   	draw_vertical_line
(0177)                            || 
(0178)  CS-0x067  0x3681D         || 			MOV    	r8,0x1D                 ; starting x coordinate
(0179)  CS-0x068  0x3670D         || 			MOV    	r7,0x0D                 ; start y coordinate
(0180)  CS-0x069  0x36911         || 			MOV    	r9,0x11                 ; ending Y coordinate
(0181)  CS-0x06A  0x08749         || 			CALL   	draw_vertical_line
(0182)                            || 
(0183)  CS-0x06B  0x36819         || 			MOV 	R8, 0x19
(0184)  CS-0x06C  0x367CA         || 			MOV 	R7, 0xCA
(0185)  CS-0x06D  0x087C9         || 			CALL 	DRAW_DOT
(0186)                            || 
(0187)  CS-0x06E  0x3681A         || 			MOV 	R8, 0x1A
(0188)  CS-0x06F  0x3670A         || 			MOV 	R7, 0x0A
(0189)  CS-0x070  0x087C9         || 			CALL 	DRAW_DOT
(0190)                            || 
(0191)  CS-0x071  0x3681B         || 			MOV 	R8, 0x1B
(0192)  CS-0x072  0x3670B         || 			MOV 	R7, 0x0B
(0193)  CS-0x073  0x087C9         || 			CALL 	DRAW_DOT
(0194)                            || 
(0195)  CS-0x074  0x3681C         || 			MOV 	R8, 0x1C
(0196)  CS-0x075  0x3670C         || 			MOV 	R7, 0x0C
(0197)  CS-0x076  0x087C9         || 			CALL 	DRAW_DOT
(0198)                            || 
(0199)  CS-0x077  0x36819         || 			MOV 	R8, 0x19
(0200)  CS-0x078  0x36714         || 			MOV 	R7, 0x14
(0201)  CS-0x079  0x087C9         || 			CALL 	DRAW_DOT
(0202)                            || 
(0203)  CS-0x07A  0x3681A         || 			MOV 	R8, 0x1A
(0204)  CS-0x07B  0x36714         || 			MOV 	R7, 0x14
(0205)  CS-0x07C  0x087C9         || 			CALL 	DRAW_DOT
(0206)                            || 
(0207)  CS-0x07D  0x3681B         || 			MOV 	R8, 0x1B
(0208)  CS-0x07E  0x36713         || 			MOV 	R7, 0x13
(0209)  CS-0x07F  0x087C9         || 			CALL 	DRAW_DOT
(0210)                            || 
(0211)  CS-0x080  0x3681C         || 			MOV 	R8, 0x1C
(0212)  CS-0x081  0x36712         || 			MOV 	R7, 0x12
(0213)  CS-0x082  0x087C9         || 			CALL 	DRAW_DOT
(0214)                            || 
(0215)  CS-0x083  0x18002         || 			RET
(0216)                            || 
(0217)  CS-0x084  0x36607  0x084  || DRAW_N:		MOV 	r6,0x07
(0218)  CS-0x085  0x3680F         || 			MOV    	r8,0x0F                 ; starting x coordinate
(0219)  CS-0x086  0x3670A         || 			MOV    	r7,0x0A                ; start y coordinate
(0220)  CS-0x087  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0221)  CS-0x088  0x08749         || 			CALL   	draw_vertical_line
(0222)                            || 
(0223)  CS-0x089  0x36815         || 			MOV    	r8,0x15                 ; starting x coordinate
(0224)  CS-0x08A  0x3670A         || 			MOV    	r7,0x0A                 ; start y coordinate
(0225)  CS-0x08B  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0226)  CS-0x08C  0x08749         || 			CALL   	draw_vertical_line
(0227)                            || 
(0228)  CS-0x08D  0x36810         || 			MOV 	R8, 0x10
(0229)  CS-0x08E  0x3670B         || 			MOV 	R7, 0x0B
(0230)  CS-0x08F  0x087C9         || 			CALL 	DRAW_DOT
(0231)                            || 
(0232)  CS-0x090  0x36811         || 			MOV 	R8, 0x11
(0233)  CS-0x091  0x3670C         || 			MOV 	R7, 0x0C
(0234)  CS-0x092  0x087C9         || 			CALL 	DRAW_DOT
(0235)                            || 
(0236)  CS-0x093  0x36811         || 			MOV 	R8, 0x11
(0237)  CS-0x094  0x3670D         || 			MOV 	R7, 0x0D
(0238)  CS-0x095  0x087C9         || 			CALL 	DRAW_DOT
(0239)                            || 
(0240)  CS-0x096  0x36812         || 			MOV 	R8, 0x12
(0241)  CS-0x097  0x3670E         || 			MOV 	R7, 0x0E
(0242)  CS-0x098  0x087C9         || 			CALL 	DRAW_DOT
(0243)                            || 
(0244)  CS-0x099  0x36812         || 			MOV 	R8, 0x12
(0245)  CS-0x09A  0x3670F         || 			MOV 	R7, 0x0F
(0246)  CS-0x09B  0x087C9         || 			CALL 	DRAW_DOT
(0247)                            || 
(0248)  CS-0x09C  0x36813         || 			MOV 	R8, 0x13
(0249)  CS-0x09D  0x36710         || 			MOV 	R7, 0x10
(0250)  CS-0x09E  0x087C9         || 			CALL 	DRAW_DOT
(0251)                            || 
(0252)  CS-0x09F  0x36813         || 			MOV 	R8, 0x13
(0253)  CS-0x0A0  0x36711         || 			MOV 	R7, 0x11
(0254)  CS-0x0A1  0x087C9         || 			CALL 	DRAW_DOT
(0255)                            || 
(0256)  CS-0x0A2  0x36814         || 			MOV 	R8, 0x14
(0257)  CS-0x0A3  0x36712         || 			MOV 	R7, 0x12
(0258)  CS-0x0A4  0x087C9         || 			CALL 	DRAW_DOT
(0259)                            || 
(0260)  CS-0x0A5  0x36814         || 			MOV 	R8, 0x14
(0261)  CS-0x0A6  0x36713         || 			MOV 	R7, 0x13
(0262)  CS-0x0A7  0x087C9         || 			CALL 	DRAW_DOT
(0263)                            || 
(0264)  CS-0x0A8  0x18002         || 			RET
(0265)                            || ;-----------------------------------------------------------------------
(0266)                            || ;Section deals with moving the player, controlled from the ISR.
(0267)  CS-0x0A9  0x04E69  0x0A9  || MOVE_ALU_UP:MOV		r14, r13
(0268)  CS-0x0AA  0x2CD01         || 			SUB		r13, 0x01
(0269)  CS-0x0AB  0x04769         || 			MOV		r7, r13
(0270)  CS-0x0AC  0x36812         || 			MOV		r8, 0x12
(0271)  CS-0x0AD  0x3663F         || 			MOV		r6, dr_alu_opysel
(0272)  CS-0x0AE  0x087C9         || 			Call 	draw_dot
(0273)  CS-0x0AF  0x08589         || 			CALL	Fill_alu
(0274)  CS-0x0B0  0x18002         || 			RET
(0275)                            || 
(0276)  CS-0x0B1  0x04771  0x0B1  || Fill_alu:   MOV		r7, r14
(0277)  CS-0x0B2  0x36812         || 			mov		r8, 0x12
(0278)  CS-0x0B3  0x36600         || 			MOV		r6, bg_color
(0279)  CS-0x0B4  0x087C9         || 			Call	draw_dot
(0280)  CS-0x0B5  0x18002         || 			RET
(0281)                            || 
(0282)  CS-0x0B6  0x04E69  0x0B6  || MOVE_ALU_DN:MOV		r14, r13
(0283)  CS-0x0B7  0x28D01         || 			ADD		r13, 0x01
(0284)  CS-0x0B8  0x04769         || 			MOV		r7, r13
(0285)  CS-0x0B9  0x36812         || 			MOV		r8, 0x12
(0286)  CS-0x0BA  0x3663F         || 			MOV		r6, dr_alu_opysel
(0287)  CS-0x0BB  0x087C9         || 			Call 	draw_dot
(0288)  CS-0x0BC  0x08589         || 			CALL	Fill_Alu
(0289)  CS-0x0BD  0x18002         || 			RET
(0290)                            || 
(0291)                            || ;----------------------------------------------------------------------
(0292)                            || ;Due to Drawing errors, the masks cover the assigned color. 
(0293)  CS-0x0BE  0x3670C  0x0BE  || mask_up:	MOV		r7, 0x0c
(0294)  CS-0x0BF  0x36812         || 			mov		r8, 0x12
(0295)  CS-0x0C0  0x36600         || 			mov		r6, bg_color
(0296)  CS-0x0C1  0x087C9         || 			call 	draw_dot
(0297)  CS-0x0C2  0x18002         || 			ret
(0298)                            || 
(0299)                     0x0C3  || mask_dn:			
(0300)  CS-0x0C3  0x36713         || 			mov		r7, 0x13
(0301)  CS-0x0C4  0x36812         || 			mov		r8, 0x12
(0302)  CS-0x0C5  0x36600         || 			mov		r6, bg_color
(0303)  CS-0x0C6  0x087C9         || 			call 	draw_dot
(0304)  CS-0x0C7  0x18002         || 			ret	
(0305)                            || ;-----------------------------------------------------------------------
(0306)                            || ;ISR is called from the button press, causes Alu to 'jump'.
(0307)  CS-0x0C8  0x08549  0x0C8  || ISR:		CALL	move_alu_up
(0308)  CS-0x0C9  0x08109         || 			call    moveHole
(0309)  CS-0x0CA  0x086B9         || 			call 	waitx
(0310)                            || 
(0311)  CS-0x0CB  0x08549         || 			CALL	move_alu_up
(0312)  CS-0x0CC  0x08109         || 			call 	moveHole
(0313)  CS-0x0CD  0x086B9         || 			call 	waitx
(0314)                            || 
(0315)  CS-0x0CE  0x085B1         || 			CALL	move_alu_dn
(0316)  CS-0x0CF  0x085F1         || 			CALL	mask_up
(0317)  CS-0x0D0  0x08109         || 			call	moveHole
(0318)  CS-0x0D1  0x086B9         || 			call 	waitx
(0319)                            || 
(0320)                            || 
(0321)  CS-0x0D2  0x085B1         || 			CALL	move_alu_dn
(0322)  CS-0x0D3  0x08619         || 			CALL	mask_dn
(0323)  CS-0x0D4  0x08109         || 			call	moveHole
(0324)  CS-0x0D5  0x086B9         || 			call	waitx
(0325)                            || 	
(0326)  CS-0x0D6  0x1A003         || 			retie
(0327)                            || 
(0328)                            || ;------------------------------------------------------------------------
(0329)                            || ;Waitx causes a wait in the program. 
(0330)  CS-0x0D7  0x37DFF  0x0D7  || waitx:	     MOV     R29, MY_OUTSIDE_FOR_COUNT  ;set outside for loop count
(0331)  CS-0x0D8  0x2DD01  0x0D8  || outside_forx: SUB     R29, 0x01
(0332)                            || 
(0333)  CS-0x0D9  0x37CFF         || 			 MOV     R28, MY_MIDDLE_FOR_COUNT   ;set middle for loop count
(0334)  CS-0x0DA  0x2DC01  0x0DA  || middle_forx: SUB     R28, 0x01
(0335)                            || 			 
(0336)  CS-0x0DB  0x37B1F         || 			 MOV     R27, MY_INSIDE_FOR_COUNT   ;set inside for loop count
(0337)  CS-0x0DC  0x2DB01  0x0DC  || inside_forx: SUB     R27, 0x01
(0338)  CS-0x0DD  0x086E3         || 			 BRNE    inside_forx
(0339)                            || 			 
(0340)  CS-0x0DE  0x23C00         || 			 OR      R28, 0x00               ;load flags for middle for counter
(0341)  CS-0x0DF  0x086D3         || 			 BRNE    middle_forx
(0342)                            || 			 
(0343)  CS-0x0E0  0x23D00         || 			 OR      R29, 0x00               ;load flags for outsde for counter value
(0344)  CS-0x0E1  0x086C3         || 			 BRNE    outside_forx
(0345)  CS-0x0E2  0x18002         || 			 RET
(0346)                            || ;--------------------------------------------------------------------
(0347)                            || ;-  Subroutine: draw_horizontal_line
(0348)                            || ;-
(0349)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6.
(0350)                            || ;-   This subroutine works by consecutive calls to drawdot, meaning
(0351)                            || ;-   that a horizontal line is nothing more than a bunch of dots. 
(0352)                            || ;-
(0353)                            || ;-  Parameters:
(0354)                            || ;-   r8  = starting x-coordinate
(0355)                            || ;-   r7  = y-coordinate
(0356)                            || ;-   r9  = ending x-coordinate
(0357)                            || ;-   r6  = color used for line
(0358)                            || ;- 
(0359)                            || ;- Tweaked registers: r8,r9
(0360)                            || ;--------------------------------------------------------------------
(0361)                     0x0E3  || draw_horizontal_line:
(0362)  CS-0x0E3  0x28901         || 			ADD    r9,0x01          ; go from r8 to r9 inclusive
(0363)                            || 
(0364)                     0x0E4  || draw_horiz1:
(0365)  CS-0x0E4  0x087C9         || 			CALL   draw_dot         ; draw tile
(0366)  CS-0x0E5  0x28801         || 			ADD    r8,0x01          ; increment column (X) count
(0367)  CS-0x0E6  0x04848         || 			CMP    r8,r9            ; see if there are more columns
(0368)  CS-0x0E7  0x08723         || 			BRNE   draw_horiz1      ; branch if more columns
(0369)  CS-0x0E8  0x18002         || 			RET
(0370)                            || ;--------------------------------------------------------------------
(0371)                            || 
(0372)                            || 
(0373)                            || ;---------------------------------------------------------------------
(0374)                            || ;-  Subroutine: draw_vertical_line
(0375)                            || ;-
(0376)                            || ;-  Draws a horizontal line from (r8,r7) to (r8,r9) using color in r6. 
(0377)                            || ;-   This subroutine works by consecutive calls to drawdot, meaning
(0378)                            || ;-   that a vertical line is nothing more than a bunch of dots. 
(0379)                            || ;-
(0380)                            || ;-  Parameters:
(0381)                            || ;-   r8  = x-coordinate
(0382)                            || ;-   r7  = starting y-coordinate
(0383)                            || ;-   r9  = ending y-coordinate
(0384)                            || ;-   r6  = color used for line
(0385)                            || ;- 
(0386)                            || ;- Tweaked registers: r7,r9
(0387)                            || ;--------------------------------------------------------------------
(0388)                     0x0E9  || draw_vertical_line:
(0389)  CS-0x0E9  0x28901         || 			ADD    r9,0x01         ; go from r7 to r9 inclusive
(0390)                            || 
(0391)                     0x0EA  || draw_vert1:          
(0392)  CS-0x0EA  0x087C9         || 			CALL   draw_dot        ; draw tile
(0393)  CS-0x0EB  0x28701         || 			ADD    r7,0x01         ; increment row (y) count
(0394)  CS-0x0EC  0x04748         || 			CMP    r7,R9           ; see if there are more rows
(0395)  CS-0x0ED  0x08753         || 			BRNE   draw_vert1      ; branch if more rows
(0396)  CS-0x0EE  0x18002         || 			RET
(0397)                            || ;--------------------------------------------------------------------
(0398)                            || 
(0399)                            || ;---------------------------------------------------------------------
(0400)                            || ;-  Subroutine: draw_background
(0401)                            || ;-
(0402)                            || ;-  Fills the 30x40 grid with one color using successive calls to 
(0403)                            || ;-  draw_horizontal_line subroutine. 
(0404)                            || ;- 
(0405)                            || ;-  Tweaked registers: r13,r7,r8,r9
(0406)                            || ;----------------------------------------------------------------------
(0407)                     0x0EF  || draw_background: 
(0408)  CS-0x0EF  0x36600         || 			MOV   r6,BG_COLOR              ; use default color
(0409)  CS-0x0F0  0x36D00         || 			MOV   r13,0x00                 ; r13 keeps track of rows
(0410)  CS-0x0F1  0x04769  0x0F1  || start:  	MOV   r7,r13                   ; load current row count 
(0411)  CS-0x0F2  0x36800         || 			MOV   r8,0x00                  ; restart x coordinates
(0412)  CS-0x0F3  0x36927         || 			MOV   r9,0x27 
(0413)                            ||  
(0414)  CS-0x0F4  0x08719         || 			CALL  draw_horizontal_line     ; draw a complete line
(0415)  CS-0x0F5  0x28D01         || 			ADD   r13,0x01                 ; increment row count
(0416)  CS-0x0F6  0x30D1E         || 			CMP   r13,0x1E                 ; see if more rows to draw
(0417)  CS-0x0F7  0x0878B         || 			BRNE  start                    ; branch to draw more rows
(0418)  CS-0x0F8  0x18002         || 			RET
(0419)                            || ;---------------------------------------------------------------------
(0420)                            ||     
(0421)                            || ;---------------------------------------------------------------------
(0422)                            || ;- Subrountine: draw_dot
(0423)                            || ;- 
(0424)                            || ;- This subroutine draws a dot on the display the given coordinates: 
(0425)                            || ;- 
(0426)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6  
(0427)                            || ;- 
(0428)                            || ;- Tweaked registers: r4,r5
(0429)                            || ;---------------------------------------------------------------------
(0430)                     0x0F9  || draw_dot: 
(0431)  CS-0x0F9  0x04439         ||            MOV   r4,r7         ; copy Y coordinate
(0432)  CS-0x0FA  0x04541         ||            MOV   r5,r8         ; copy X coordinate
(0433)                            || 
(0434)  CS-0x0FB  0x2053F         ||            AND   r5,0x3F       ; make sure top 2 bits cleared
(0435)  CS-0x0FC  0x2041F         ||            AND   r4,0x1F       ; make sure top 3 bits cleared
(0436)                            || 
(0437)                            ||            ;--- you need bottom two bits of r4 into top two bits of r5
(0438)  CS-0x0FD  0x10401         ||            LSR   r4            ; shift LSB into carry 
(0439)  CS-0x0FE  0x0A809         ||            BRCC  bit7          ; no carry, jump to next bit
(0440)  CS-0x0FF  0x22540         ||            OR    r5,0x40       ; there was a carry, set bit
(0441)  CS-0x100  0x18000         ||            CLC                 ; freshen bit, do one more left shift
(0442)                            || 
(0443)  CS-0x101  0x10401  0x101  || bit7:      LSR   r4            ; shift LSB into carry 
(0444)  CS-0x102  0x0A821         ||            BRCC  dd_out        ; no carry, jump to output
(0445)  CS-0x103  0x22580         ||            OR    r5,0x80       ; set bit if needed
(0446)                            || 
(0447)  CS-0x104  0x34591  0x104  || dd_out:    OUT   r5,VGA_LADD   ; write low 8 address bits to register
(0448)  CS-0x105  0x34490         ||            OUT   r4,VGA_HADD   ; write hi 3 address bits to register
(0449)  CS-0x106  0x34692         ||            OUT   r6,VGA_COLOR  ; write data to frame buffer
(0450)  CS-0x107  0x18002         ||            RET
(0451)                            || ; --------------------------------------------------------------------
(0452)                       1023  || .ORG 0x3FF
(0453)  CS-0x3FF  0x08640  0x3FF  || INT:		BRN		ISR





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
ALU_END        0x046   (0134)  ||  0126 0128 0145 
BIT7           0x101   (0443)  ||  0439 
DD_OUT         0x104   (0447)  ||  0444 
DRAW_BACKGROUND 0x0EF   (0407)  ||  0062 0135 
DRAW_D         0x062   (0172)  ||  0140 
DRAW_DOT       0x0F9   (0430)  ||  0068 0092 0099 0108 0112 0116 0119 0185 0189 0193 
                               ||  0197 0201 0205 0209 0213 0230 0234 0238 0242 0246 
                               ||  0250 0254 0258 0262 0272 0279 0287 0296 0303 0365 
                               ||  0392 
DRAW_E         0x050   (0149)  ||  0137 
DRAW_HORIZ1    0x0E4   (0364)  ||  0368 
DRAW_HORIZONTAL_LINE 0x0E3   (0361)  ||  0074 0158 0163 0168 0414 
DRAW_N         0x084   (0217)  ||  0143 
DRAW_VERT1     0x0EA   (0391)  ||  0395 
DRAW_VERTICAL_LINE 0x0E9   (0388)  ||  0153 0176 0181 0221 0226 
END_CHECK      0x03E   (0123)  ||  0080 
FILL_ALU       0x0B1   (0276)  ||  0273 0288 
FILL_HOLE      0x02A   (0096)  ||  0093 
INIT           0x010   (0061)  ||  
INSIDE_FORX    0x0DC   (0337)  ||  0338 
INT            0x3FF   (0453)  ||  
ISR            0x0C8   (0307)  ||  0453 
MAIN           0x01D   (0079)  ||  0082 
MAKEHOLE       0x02F   (0103)  ||  0077 0089 
MASK_DN        0x0C3   (0299)  ||  0322 
MASK_UP        0x0BE   (0293)  ||  0316 
MIDDLE_FORX    0x0DA   (0334)  ||  0341 
MOVEHOLE       0x021   (0086)  ||  0079 0308 0312 0317 0323 
MOVE_ALU_DN    0x0B6   (0282)  ||  0315 0321 
MOVE_ALU_UP    0x0A9   (0267)  ||  0307 0311 
OUTSIDE_FORX   0x0D8   (0331)  ||  0344 
SAFE           0x045   (0130)  ||  0124 0129 
START          0x0F1   (0410)  ||  0417 
WAITX          0x0D7   (0330)  ||  0081 0136 0138 0141 0144 0309 0313 0318 0324 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BG_COLOR       0x000   (0040)  ||  0091 0107 0278 0295 0302 0408 
DR_ALU_OPYSEL  0x03F   (0041)  ||  0271 0286 
G_C            0x0C0   (0042)  ||  0098 0115 
KEYBOARD       0x025   (0035)  ||  
LEDS           0x040   (0037)  ||  
MY_INSIDE_FOR_COUNT 0x01F   (0045)  ||  0336 
MY_MIDDLE_FOR_COUNT 0x0FF   (0046)  ||  0333 
MY_OUTSIDE_FOR_COUNT 0x0FF   (0047)  ||  0330 
SSEG           0x081   (0036)  ||  
VGA_COLOR      0x092   (0034)  ||  0449 
VGA_HADD       0x090   (0032)  ||  0448 
VGA_LADD       0x091   (0033)  ||  0447 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
