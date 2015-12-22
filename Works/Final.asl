

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
(0016)                            || .CSEG
(0017)                       016  || .ORG 0x10
(0018)                            || 
(0019)                            || ;---------------------------------------------------------------------
(0020)                            || ;- register definitions 
(0021)                            || ;---------------------------------------------------------------------
(0022)                       144  || .EQU VGA_HADD  = 0x90
(0023)                       145  || .EQU VGA_LADD  = 0x91
(0024)                       146  || .EQU VGA_COLOR = 0x92
(0025)                       037  || .EQU KEYBOARD  = 0x25
(0026)                       129  || .EQU SSEG      = 0x81
(0027)                       064  || .EQU LEDS      = 0x40
(0028)                            || ;---------------------------------------------------------------------
(0029)                            || 
(0030)                       000  || .EQU BG_COLOR       = 0x00             ; Background:  blue
(0031)                       063  || .equ Dr_ALU_OPYSEL	= 0x3F			;Player Color
(0032)                       192  || .equ G_C			= 0xC0				;Ground Color
(0033)                            || 
(0034)                            || 
(0035)                       031  || .EQU MY_INSIDE_FOR_COUNT    = 0x1F
(0036)                       255  || .EQU MY_MIDDLE_FOR_COUNT    = 0xFF
(0037)                       255  || .EQU MY_OUTSIDE_FOR_COUNT   = 0xFF
(0038)                            || 
(0039)                            || ;---------------------------------------------------------------------
(0040)                            || ;- r6 is used for color
(0041)                            || ;- r7 is used for working Y coordinate
(0042)                            || ;- r8 is used for working X coordinate
(0043)                            || ;---------------------------------------------------------------------
(0044)                            || 
(0045)                            || ;---------------------------------------------------------------------
(0046)                     0x010  || init:
(0047)  CS-0x010  0x08781         || 			CALL   draw_background         ; draw using default color
(0048)                            || 
(0049)  CS-0x011  0x36711         || 			MOV    r7, 0x11                ; generic Y coordinate
(0050)  CS-0x012  0x04D39         || 			MOV	   r13, r7				   ; copy alu's y_pos
(0051)  CS-0x013  0x36812         || 			MOV    r8, 0x12                ; generic X coordinate
(0052)  CS-0x014  0x3663F         || 			MOV    r6, 0x3F                ; color
(0053)  CS-0x015  0x087D1         || 			CALL   draw_dot                ; draw yellow square 
(0054)                            || 
(0055)  CS-0x016  0x366C0         || 			MOV 	r6,0xC0
(0056)  CS-0x017  0x36800         || 			MOV    r8,0x00                 ; starting x coordinate
(0057)  CS-0x018  0x36712         || 			MOV    r7,0x12                 ; start y coordinate
(0058)  CS-0x019  0x36927         || 			MOV    r9,0x27                 ; ending x coordinate
(0059)  CS-0x01A  0x08721         || 			CALL   draw_horizontal_line
(0060)  CS-0x01B  0x1A000         || 			SEI
(0061)                            || 
(0062)  CS-0x01C  0x08179         || 			call	MakeHole
(0063)                            || 
(0064)  CS-0x01D  0x08109  0x01D  || main:	    call	MoveHole
(0065)  CS-0x01E  0x081F1         || 			call	END_CHECK
(0066)  CS-0x01F  0x086C1         || 			call	waitx
(0067)  CS-0x020  0x080E8         || 			BRN		main                    ; continuous loop 
(0068)                            || 
(0069)                            || 
(0070)                            || ;--------------------------------------------------------------------
(0071)  CS-0x021  0x04789  0x021  || MoveHole:	mov r7, r17
(0072)  CS-0x022  0x2D201         || 			sub r18, 0x01
(0073)  CS-0x023  0x2D301         || 			sub r19, 0x01
(0074)  CS-0x024  0x0A178         || 			BRCS MakeHole
(0075)  CS-0x025  0x04899         || 			mov r8, r19
(0076)  CS-0x026  0x36600         || 			mov r6, bg_color
(0077)  CS-0x027  0x087D1         || 			call draw_dot
(0078)  CS-0x028  0x08151         || 			call fill_hole
(0079)  CS-0x029  0x18002         || 			ret
(0080)                            || 
(0081)  CS-0x02A  0x04891  0x02A  || fill_hole:	mov r8, r18
(0082)  CS-0x02B  0x28801         || 			add r8, 0x01
(0083)  CS-0x02C  0x366C0         || 			mov r6, g_c
(0084)  CS-0x02D  0x087D1         || 			call draw_dot
(0085)  CS-0x02E  0x18002         || 			ret
(0086)                            || 			
(0087)  CS-0x02F  0x36712  0x02F  || MakeHole:	MOV r7,0x12					; y		
(0088)  CS-0x030  0x36827         || 			MOV r8,0x27					; x (hole right side)
(0089)  CS-0x031  0x05139         || 			MOV r17, r7
(0090)  CS-0x032  0x05241         || 			MOV r18, r8					; copy coords
(0091)  CS-0x033  0x36600         || 			MOV r6, bg_color
(0092)  CS-0x034  0x087D1         || 			CALL draw_dot
(0093)                            || 
(0094)  CS-0x035  0x36826         || 			MOV r8,0x26
(0095)  CS-0x036  0x05341         || 			MOV r19, r8
(0096)  CS-0x037  0x087D1         || 			CALL draw_dot
(0097)                            || 
(0098)  CS-0x038  0x36800         || 			mov r8, 0x00
(0099)  CS-0x039  0x366C0         || 			mov r6, g_c
(0100)  CS-0x03A  0x087D1         || 			call draw_dot
(0101)                            || 
(0102)  CS-0x03B  0x36801         || 			mov r8, 0x01
(0103)  CS-0x03C  0x087D1         || 			call draw_dot
(0104)  CS-0x03D  0x18002         || 			ret
(0105)                            || ;------------------------------------------------------------------------
(0106)                            || 
(0107)  CS-0x03E  0x30D11  0x03E  || END_CHECK:	cmp r13, 0x11
(0108)  CS-0x03F  0x0822B         || 			brne safe
(0109)  CS-0x040  0x04D98         || 			CMP r13, r19
(0110)  CS-0x041  0x08232         || 			breq ALU_End
(0111)  CS-0x042  0x04D90         || 			cmp r13, r18
(0112)  CS-0x043  0x08232         || 			breq alu_end
(0113)  CS-0x044  0x08228         || 			brn safe
(0114)  CS-0x045  0x18002  0x045  || safe:		ret
(0115)                            || 
(0116)                            || ;-----------------------------------------------------------------------
(0117)  CS-0x046  0x1A001  0x046  || ALU_END:	CLI
(0118)  CS-0x047  0x08781         || 			call 	draw_background
(0119)  CS-0x048  0x086C1         || 			call	waitx
(0120)  CS-0x049  0x08281         || 			call 	draw_E
(0121)  CS-0x04A  0x086C1         || 			CALL 	waitx
(0122)                            || 
(0123)  CS-0x04B  0x08311         || 			call 	draw_D
(0124)  CS-0x04C  0x086C1         || 			call 	waitx
(0125)                            || 			
(0126)  CS-0x04D  0x08421         || 			call 	draw_N
(0127)  CS-0x04E  0x086C1         || 			call	waitx
(0128)  CS-0x04F  0x08230         || 			brn		ALU_END
(0129)                            || 
(0130)                            || 			
(0131)                            || 
(0132)  CS-0x050  0x36607  0x050  || DRAW_E:		MOV 	r6,0x07
(0133)  CS-0x051  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0134)  CS-0x052  0x3670A         || 			MOV    	r7,0x0A                 ; start y coordinate
(0135)  CS-0x053  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0136)  CS-0x054  0x08751         || 			CALL   	draw_vertical_line
(0137)                            || 			
(0138)  CS-0x055  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0139)  CS-0x056  0x3670A         || 			MOV    	r7,0x0A                 ; start y coordinate
(0140)  CS-0x057  0x3690C         || 			MOV    	r9,0x0C                 ; ending x coordinate
(0141)  CS-0x058  0x08721         || 			CALL   	draw_HORIZONTAL_line
(0142)                            || 
(0143)  CS-0x059  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0144)  CS-0x05A  0x3670F         || 			MOV    	r7,0x0F                 ; start y coordinate
(0145)  CS-0x05B  0x3690C         || 			MOV    	r9,0x0C                 ; ending x coordinate
(0146)  CS-0x05C  0x08721         || 			CALL   	draw_HORIZONTAL_line
(0147)                            || 
(0148)  CS-0x05D  0x36808         || 			MOV    	r8,0x08                 ; starting x coordinate
(0149)  CS-0x05E  0x36714         || 			MOV    	r7,0x14                 ; start y coordinate
(0150)  CS-0x05F  0x3690C         || 			MOV    	r9,0x0C                 ; ending x coordinate
(0151)  CS-0x060  0x08721         || 			CALL   	draw_HORIZONTAL_line
(0152)                            || 
(0153)  CS-0x061  0x18002         || 			ret
(0154)                            || 
(0155)  CS-0x062  0x36607  0x062  || DRAW_D:		MOV 	r6,0x07
(0156)  CS-0x063  0x36818         || 			MOV    	r8,0x18                 ; starting x coordinate
(0157)  CS-0x064  0x3670A         || 			MOV    	r7,0x0A                ; start y coordinate
(0158)  CS-0x065  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0159)  CS-0x066  0x08751         || 			CALL   	draw_vertical_line
(0160)                            || 
(0161)  CS-0x067  0x3681D         || 			MOV    	r8,0x1D                 ; starting x coordinate
(0162)  CS-0x068  0x3670D         || 			MOV    	r7,0x0D                 ; start y coordinate
(0163)  CS-0x069  0x36911         || 			MOV    	r9,0x11                 ; ending Y coordinate
(0164)  CS-0x06A  0x08751         || 			CALL   	draw_vertical_line
(0165)                            || 
(0166)  CS-0x06B  0x36819         || 			MOV 	R8, 0x19
(0167)  CS-0x06C  0x367CA         || 			MOV 	R7, 0xCA
(0168)  CS-0x06D  0x087D1         || 			CALL 	DRAW_DOT
(0169)                            || 
(0170)  CS-0x06E  0x3681A         || 			MOV 	R8, 0x1A
(0171)  CS-0x06F  0x3670A         || 			MOV 	R7, 0x0A
(0172)  CS-0x070  0x087D1         || 			CALL 	DRAW_DOT
(0173)                            || 
(0174)  CS-0x071  0x3681B         || 			MOV 	R8, 0x1B
(0175)  CS-0x072  0x3670B         || 			MOV 	R7, 0x0B
(0176)  CS-0x073  0x087D1         || 			CALL 	DRAW_DOT
(0177)                            || 
(0178)  CS-0x074  0x3681C         || 			MOV 	R8, 0x1C
(0179)  CS-0x075  0x3670C         || 			MOV 	R7, 0x0C
(0180)  CS-0x076  0x087D1         || 			CALL 	DRAW_DOT
(0181)                            || 
(0182)  CS-0x077  0x36819         || 			MOV 	R8, 0x19
(0183)  CS-0x078  0x36714         || 			MOV 	R7, 0x14
(0184)  CS-0x079  0x087D1         || 			CALL 	DRAW_DOT
(0185)                            || 
(0186)  CS-0x07A  0x3681A         || 			MOV 	R8, 0x1A
(0187)  CS-0x07B  0x36714         || 			MOV 	R7, 0x14
(0188)  CS-0x07C  0x087D1         || 			CALL 	DRAW_DOT
(0189)                            || 
(0190)  CS-0x07D  0x3681B         || 			MOV 	R8, 0x1B
(0191)  CS-0x07E  0x36713         || 			MOV 	R7, 0x13
(0192)  CS-0x07F  0x087D1         || 			CALL 	DRAW_DOT
(0193)                            || 
(0194)  CS-0x080  0x3681C         || 			MOV 	R8, 0x1C
(0195)  CS-0x081  0x36712         || 			MOV 	R7, 0x12
(0196)  CS-0x082  0x087D1         || 			CALL 	DRAW_DOT
(0197)                            || 
(0198)  CS-0x083  0x18002         || 			RET
(0199)                            || 
(0200)  CS-0x084  0x36607  0x084  || DRAW_N:		MOV 	r6,0x07
(0201)  CS-0x085  0x3680F         || 			MOV    	r8,0x0F                 ; starting x coordinate
(0202)  CS-0x086  0x3670A         || 			MOV    	r7,0x0A                ; start y coordinate
(0203)  CS-0x087  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0204)  CS-0x088  0x08751         || 			CALL   	draw_vertical_line
(0205)                            || 
(0206)  CS-0x089  0x36815         || 			MOV    	r8,0x15                 ; starting x coordinate
(0207)  CS-0x08A  0x3670A         || 			MOV    	r7,0x0A                 ; start y coordinate
(0208)  CS-0x08B  0x36914         || 			MOV    	r9,0x14                 ; ending Y coordinate
(0209)  CS-0x08C  0x08751         || 			CALL   	draw_vertical_line
(0210)                            || 
(0211)  CS-0x08D  0x36810         || 			MOV 	R8, 0x10
(0212)  CS-0x08E  0x3670B         || 			MOV 	R7, 0x0B
(0213)  CS-0x08F  0x087D1         || 			CALL 	DRAW_DOT
(0214)                            || 
(0215)  CS-0x090  0x36811         || 			MOV 	R8, 0x11
(0216)  CS-0x091  0x3670C         || 			MOV 	R7, 0x0C
(0217)  CS-0x092  0x087D1         || 			CALL 	DRAW_DOT
(0218)                            || 
(0219)  CS-0x093  0x36811         || 			MOV 	R8, 0x11
(0220)  CS-0x094  0x3670D         || 			MOV 	R7, 0x0D
(0221)  CS-0x095  0x087D1         || 			CALL 	DRAW_DOT
(0222)                            || 
(0223)  CS-0x096  0x36812         || 			MOV 	R8, 0x12
(0224)  CS-0x097  0x3670E         || 			MOV 	R7, 0x0E
(0225)  CS-0x098  0x087D1         || 			CALL 	DRAW_DOT
(0226)                            || 
(0227)  CS-0x099  0x36812         || 			MOV 	R8, 0x12
(0228)  CS-0x09A  0x3670F         || 			MOV 	R7, 0x0F
(0229)  CS-0x09B  0x087D1         || 			CALL 	DRAW_DOT
(0230)                            || 
(0231)  CS-0x09C  0x36813         || 			MOV 	R8, 0x13
(0232)  CS-0x09D  0x36710         || 			MOV 	R7, 0x10
(0233)  CS-0x09E  0x087D1         || 			CALL 	DRAW_DOT
(0234)                            || 
(0235)  CS-0x09F  0x36813         || 			MOV 	R8, 0x13
(0236)  CS-0x0A0  0x36711         || 			MOV 	R7, 0x11
(0237)  CS-0x0A1  0x087D1         || 			CALL 	DRAW_DOT
(0238)                            || 
(0239)  CS-0x0A2  0x36814         || 			MOV 	R8, 0x14
(0240)  CS-0x0A3  0x36712         || 			MOV 	R7, 0x12
(0241)  CS-0x0A4  0x087D1         || 			CALL 	DRAW_DOT
(0242)                            || 
(0243)  CS-0x0A5  0x36814         || 			MOV 	R8, 0x14
(0244)  CS-0x0A6  0x36713         || 			MOV 	R7, 0x13
(0245)  CS-0x0A7  0x087D1         || 			CALL 	DRAW_DOT
(0246)                            || 
(0247)  CS-0x0A8  0x18002         || 			RET
(0248)                            || ;-----------------------------------------------------------------------
(0249)  CS-0x0A9  0x04E69  0x0A9  || MOVE_ALU_UP:MOV		r14, r13
(0250)  CS-0x0AA  0x2CD01         || 			SUB		r13, 0x01
(0251)  CS-0x0AB  0x04769         || 			MOV		r7, r13
(0252)  CS-0x0AC  0x36812         || 			MOV		r8, 0x12
(0253)  CS-0x0AD  0x3663F         || 			MOV		r6, dr_alu_opysel
(0254)  CS-0x0AE  0x087D1         || 			Call 	draw_dot
(0255)                            || 
(0256)  CS-0x0AF  0x04771  0x0AF  || Fill_alu:   MOV		r7, r14
(0257)  CS-0x0B0  0x36812         || 			mov		r8, 0x12
(0258)  CS-0x0B1  0x36600         || 			MOV		r6, bg_color
(0259)  CS-0x0B2  0x087D1         || 			Call	draw_dot
(0260)  CS-0x0B3  0x18002         || 			RET
(0261)                            || 
(0262)  CS-0x0B4  0x04E69  0x0B4  || MOVE_ALU_DN:MOV		r14, r13
(0263)  CS-0x0B5  0x28D01         || 			ADD		r13, 0x01
(0264)  CS-0x0B6  0x04769         || 			MOV		r7, r13
(0265)  CS-0x0B7  0x36812         || 			MOV		r8, 0x12
(0266)  CS-0x0B8  0x3663F         || 			MOV		r6, dr_alu_opysel
(0267)  CS-0x0B9  0x087D1         || 			Call 	draw_dot
(0268)                            || 
(0269)  CS-0x0BA  0x04771         || 			MOV		r7, r14
(0270)  CS-0x0BB  0x36812         || 			mov		r8, 0x12
(0271)  CS-0x0BC  0x36600         || 			MOV		r6, bg_color
(0272)  CS-0x0BD  0x087D1         || 			Call	draw_dot
(0273)  CS-0x0BE  0x18002         || 			RET
(0274)                            || 
(0275)  CS-0x0BF  0x3670C  0x0BF  || mask_up:	MOV		r7, 0x0c
(0276)  CS-0x0C0  0x36812         || 			mov		r8, 0x12
(0277)  CS-0x0C1  0x36600         || 			mov		r6, bg_color
(0278)  CS-0x0C2  0x087D1         || 			call 	draw_dot
(0279)  CS-0x0C3  0x18002         || 			ret
(0280)                            || 
(0281)                     0x0C4  || mask_dn:			
(0282)  CS-0x0C4  0x36713         || 			mov		r7, 0x13
(0283)  CS-0x0C5  0x36812         || 			mov		r8, 0x12
(0284)  CS-0x0C6  0x36600         || 			mov		r6, bg_color
(0285)  CS-0x0C7  0x087D1         || 			call 	draw_dot
(0286)  CS-0x0C8  0x18002         || 			ret	
(0287)                            || 
(0288)  CS-0x0C9  0x08549  0x0C9  || ISR:		CALL	move_alu_up
(0289)  CS-0x0CA  0x08109         || 			call    moveHole
(0290)  CS-0x0CB  0x086C1         || 			call 	waitx
(0291)                            || 
(0292)  CS-0x0CC  0x08549         || 			CALL	move_alu_up
(0293)  CS-0x0CD  0x08109         || 			call 	moveHole
(0294)  CS-0x0CE  0x086C1         || 			call 	waitx
(0295)                            || 
(0296)  CS-0x0CF  0x085A1         || 			CALL	move_alu_dn
(0297)  CS-0x0D0  0x085F9         || 			CALL	mask_up
(0298)  CS-0x0D1  0x08109         || 			call	moveHole
(0299)  CS-0x0D2  0x086C1         || 			call 	waitx
(0300)                            || 
(0301)                            || 
(0302)  CS-0x0D3  0x085A1         || 			CALL	move_alu_dn
(0303)  CS-0x0D4  0x08621         || 			CALL	mask_dn
(0304)  CS-0x0D5  0x08109         || 			call	moveHole
(0305)  CS-0x0D6  0x086C1         || 			call	waitx
(0306)                            || 	
(0307)  CS-0x0D7  0x1A003         || 			retie
(0308)                            || 
(0309)                            || ;------------------------------------------------------------------------
(0310)  CS-0x0D8  0x37DFF  0x0D8  || waitx:	     MOV     R29, MY_OUTSIDE_FOR_COUNT  ;set outside for loop count
(0311)  CS-0x0D9  0x2DD01  0x0D9  || outside_forx: SUB     R29, 0x01
(0312)                            || 
(0313)  CS-0x0DA  0x37CFF         || 			 MOV     R28, MY_MIDDLE_FOR_COUNT   ;set middle for loop count
(0314)  CS-0x0DB  0x2DC01  0x0DB  || middle_forx: SUB     R28, 0x01
(0315)                            || 			 
(0316)  CS-0x0DC  0x37B1F         || 			 MOV     R27, MY_INSIDE_FOR_COUNT   ;set inside for loop count
(0317)  CS-0x0DD  0x2DB01  0x0DD  || inside_forx: SUB     R27, 0x01
(0318)  CS-0x0DE  0x086EB         || 			 BRNE    inside_forx
(0319)                            || 			 
(0320)  CS-0x0DF  0x23C00         || 			 OR      R28, 0x00               ;load flags for middle for counter
(0321)  CS-0x0E0  0x086DB         || 			 BRNE    middle_forx
(0322)                            || 			 
(0323)  CS-0x0E1  0x23D00         || 			 OR      R29, 0x00               ;load flags for outsde for counter value
(0324)  CS-0x0E2  0x086CB         || 			 BRNE    outside_forx
(0325)  CS-0x0E3  0x18002         || 			 RET
(0326)                            || ;--------------------------------------------------------------------
(0327)                            || ;-  Subroutine: draw_horizontal_line
(0328)                            || ;-
(0329)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6.
(0330)                            || ;-   This subroutine works by consecutive calls to drawdot, meaning
(0331)                            || ;-   that a horizontal line is nothing more than a bunch of dots. 
(0332)                            || ;-
(0333)                            || ;-  Parameters:
(0334)                            || ;-   r8  = starting x-coordinate
(0335)                            || ;-   r7  = y-coordinate
(0336)                            || ;-   r9  = ending x-coordinate
(0337)                            || ;-   r6  = color used for line
(0338)                            || ;- 
(0339)                            || ;- Tweaked registers: r8,r9
(0340)                            || ;--------------------------------------------------------------------
(0341)                     0x0E4  || draw_horizontal_line:
(0342)  CS-0x0E4  0x28901         ||         ADD    r9,0x01          ; go from r8 to r9 inclusive
(0343)                            || 
(0344)                     0x0E5  || draw_horiz1:
(0345)  CS-0x0E5  0x087D1         ||         CALL   draw_dot         ; draw tile
(0346)  CS-0x0E6  0x28801         ||         ADD    r8,0x01          ; increment column (X) count
(0347)  CS-0x0E7  0x04848         ||         CMP    r8,r9            ; see if there are more columns
(0348)  CS-0x0E8  0x0872B         ||         BRNE   draw_horiz1      ; branch if more columns
(0349)  CS-0x0E9  0x18002         ||         RET
(0350)                            || ;--------------------------------------------------------------------
(0351)                            || 
(0352)                            || 
(0353)                            || ;---------------------------------------------------------------------
(0354)                            || ;-  Subroutine: draw_vertical_line
(0355)                            || ;-
(0356)                            || ;-  Draws a horizontal line from (r8,r7) to (r8,r9) using color in r6. 
(0357)                            || ;-   This subroutine works by consecutive calls to drawdot, meaning
(0358)                            || ;-   that a vertical line is nothing more than a bunch of dots. 
(0359)                            || ;-
(0360)                            || ;-  Parameters:
(0361)                            || ;-   r8  = x-coordinate
(0362)                            || ;-   r7  = starting y-coordinate
(0363)                            || ;-   r9  = ending y-coordinate
(0364)                            || ;-   r6  = color used for line
(0365)                            || ;- 
(0366)                            || ;- Tweaked registers: r7,r9
(0367)                            || ;--------------------------------------------------------------------
(0368)                     0x0EA  || draw_vertical_line:
(0369)  CS-0x0EA  0x28901         ||          ADD    r9,0x01         ; go from r7 to r9 inclusive
(0370)                            || 
(0371)                     0x0EB  || draw_vert1:          
(0372)  CS-0x0EB  0x087D1         ||          CALL   draw_dot        ; draw tile
(0373)  CS-0x0EC  0x28701         ||          ADD    r7,0x01         ; increment row (y) count
(0374)  CS-0x0ED  0x04748         ||          CMP    r7,R9           ; see if there are more rows
(0375)  CS-0x0EE  0x0875B         ||          BRNE   draw_vert1      ; branch if more rows
(0376)  CS-0x0EF  0x18002         ||          RET
(0377)                            || ;--------------------------------------------------------------------
(0378)                            || 
(0379)                            || ;---------------------------------------------------------------------
(0380)                            || ;-  Subroutine: draw_background
(0381)                            || ;-
(0382)                            || ;-  Fills the 30x40 grid with one color using successive calls to 
(0383)                            || ;-  draw_horizontal_line subroutine. 
(0384)                            || ;- 
(0385)                            || ;-  Tweaked registers: r13,r7,r8,r9
(0386)                            || ;----------------------------------------------------------------------
(0387)                     0x0F0  || draw_background: 
(0388)  CS-0x0F0  0x36600         ||          MOV   r6,BG_COLOR              ; use default color
(0389)  CS-0x0F1  0x36D00         ||          MOV   r13,0x00                 ; r13 keeps track of rows
(0390)  CS-0x0F2  0x04769  0x0F2  || start:   MOV   r7,r13                   ; load current row count 
(0391)  CS-0x0F3  0x36800         ||          MOV   r8,0x00                  ; restart x coordinates
(0392)  CS-0x0F4  0x36927         ||          MOV   r9,0x27 
(0393)                            ||  
(0394)  CS-0x0F5  0x08721         ||          CALL  draw_horizontal_line     ; draw a complete line
(0395)  CS-0x0F6  0x28D01         ||          ADD   r13,0x01                 ; increment row count
(0396)  CS-0x0F7  0x30D1E         ||          CMP   r13,0x1E                 ; see if more rows to draw
(0397)  CS-0x0F8  0x08793         ||          BRNE  start                    ; branch to draw more rows
(0398)  CS-0x0F9  0x18002         ||          RET
(0399)                            || ;---------------------------------------------------------------------
(0400)                            ||     
(0401)                            || ;---------------------------------------------------------------------
(0402)                            || ;- Subrountine: draw_dot
(0403)                            || ;- 
(0404)                            || ;- This subroutine draws a dot on the display the given coordinates: 
(0405)                            || ;- 
(0406)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6  
(0407)                            || ;- 
(0408)                            || ;- Tweaked registers: r4,r5
(0409)                            || ;---------------------------------------------------------------------
(0410)                     0x0FA  || draw_dot: 
(0411)  CS-0x0FA  0x04439         ||            MOV   r4,r7         ; copy Y coordinate
(0412)  CS-0x0FB  0x04541         ||            MOV   r5,r8         ; copy X coordinate
(0413)                            || 
(0414)  CS-0x0FC  0x2053F         ||            AND   r5,0x3F       ; make sure top 2 bits cleared
(0415)  CS-0x0FD  0x2041F         ||            AND   r4,0x1F       ; make sure top 3 bits cleared
(0416)                            || 
(0417)                            ||            ;--- you need bottom two bits of r4 into top two bits of r5
(0418)  CS-0x0FE  0x10401         ||            LSR   r4            ; shift LSB into carry 
(0419)  CS-0x0FF  0x0A811         ||            BRCC  bit7          ; no carry, jump to next bit
(0420)  CS-0x100  0x22540         ||            OR    r5,0x40       ; there was a carry, set bit
(0421)  CS-0x101  0x18000         ||            CLC                 ; freshen bit, do one more left shift
(0422)                            || 
(0423)  CS-0x102  0x10401  0x102  || bit7:      LSR   r4            ; shift LSB into carry 
(0424)  CS-0x103  0x0A829         ||            BRCC  dd_out        ; no carry, jump to output
(0425)  CS-0x104  0x22580         ||            OR    r5,0x80       ; set bit if needed
(0426)                            || 
(0427)  CS-0x105  0x34591  0x105  || dd_out:    OUT   r5,VGA_LADD   ; write low 8 address bits to register
(0428)  CS-0x106  0x34490         ||            OUT   r4,VGA_HADD   ; write hi 3 address bits to register
(0429)  CS-0x107  0x34692         ||            OUT   r6,VGA_COLOR  ; write data to frame buffer
(0430)  CS-0x108  0x18002         ||            RET
(0431)                            || ; --------------------------------------------------------------------
(0432)                       1023  || .ORG 0x3FF
(0433)  CS-0x3FF  0x08648  0x3FF  || INT:	BRN ISR





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
ALU_END        0x046   (0117)  ||  0110 0112 0128 
BIT7           0x102   (0423)  ||  0419 
DD_OUT         0x105   (0427)  ||  0424 
DRAW_BACKGROUND 0x0F0   (0387)  ||  0047 0118 
DRAW_D         0x062   (0155)  ||  0123 
DRAW_DOT       0x0FA   (0410)  ||  0053 0077 0084 0092 0096 0100 0103 0168 0172 0176 
                               ||  0180 0184 0188 0192 0196 0213 0217 0221 0225 0229 
                               ||  0233 0237 0241 0245 0254 0259 0267 0272 0278 0285 
                               ||  0345 0372 
DRAW_E         0x050   (0132)  ||  0120 
DRAW_HORIZ1    0x0E5   (0344)  ||  0348 
DRAW_HORIZONTAL_LINE 0x0E4   (0341)  ||  0059 0141 0146 0151 0394 
DRAW_N         0x084   (0200)  ||  0126 
DRAW_VERT1     0x0EB   (0371)  ||  0375 
DRAW_VERTICAL_LINE 0x0EA   (0368)  ||  0136 0159 0164 0204 0209 
END_CHECK      0x03E   (0107)  ||  0065 
FILL_ALU       0x0AF   (0256)  ||  
FILL_HOLE      0x02A   (0081)  ||  0078 
INIT           0x010   (0046)  ||  
INSIDE_FORX    0x0DD   (0317)  ||  0318 
INT            0x3FF   (0433)  ||  
ISR            0x0C9   (0288)  ||  0433 
MAIN           0x01D   (0064)  ||  0067 
MAKEHOLE       0x02F   (0087)  ||  0062 0074 
MASK_DN        0x0C4   (0281)  ||  0303 
MASK_UP        0x0BF   (0275)  ||  0297 
MIDDLE_FORX    0x0DB   (0314)  ||  0321 
MOVEHOLE       0x021   (0071)  ||  0064 0289 0293 0298 0304 
MOVE_ALU_DN    0x0B4   (0262)  ||  0296 0302 
MOVE_ALU_UP    0x0A9   (0249)  ||  0288 0292 
OUTSIDE_FORX   0x0D9   (0311)  ||  0324 
SAFE           0x045   (0114)  ||  0108 0113 
START          0x0F2   (0390)  ||  0397 
WAITX          0x0D8   (0310)  ||  0066 0119 0121 0124 0127 0290 0294 0299 0305 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BG_COLOR       0x000   (0030)  ||  0076 0091 0258 0271 0277 0284 0388 
DR_ALU_OPYSEL  0x03F   (0031)  ||  0253 0266 
G_C            0x0C0   (0032)  ||  0083 0099 
KEYBOARD       0x025   (0025)  ||  
LEDS           0x040   (0027)  ||  
MY_INSIDE_FOR_COUNT 0x01F   (0035)  ||  0316 
MY_MIDDLE_FOR_COUNT 0x0FF   (0036)  ||  0313 
MY_OUTSIDE_FOR_COUNT 0x0FF   (0037)  ||  0310 
SSEG           0x081   (0026)  ||  
VGA_COLOR      0x092   (0024)  ||  0429 
VGA_HADD       0x090   (0022)  ||  0428 
VGA_LADD       0x091   (0023)  ||  0427 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
