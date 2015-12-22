

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


(0001)                            || .DSEG
(0002)                       000  || .ORG 0x00
(0003)                            || 
(0004)  DS-0x000             005  || seg_data: .DB 0x03, 0x9F, 0x25, 0x0D, 0x99  ; 0-4 
(0005)  DS-0x005             005  || 		  .DB 0x49, 0x41, 0x1F, 0x01, 0x09  ; 5-9
(0006)                            || 
(0007)                            || .CSEG
(0008)                       130  || .EQU SEGS = 0x82
(0009)                       131  || .EQU NODES = 0x83
(0010)                            || 
(0011)                       032  || .ORG 0x20
(0012)                            || 
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x36003  0x003  ||              MOV     r0,0x03     ; write dseg data to reg
-STUP-  CS-0x001  0x3A000  0x000  ||              LD      r0,0x00     ; place reg data in mem 
-STUP-  CS-0x002  0x3609F  0x09F  ||              MOV     r0,0x9F     ; write dseg data to reg
-STUP-  CS-0x003  0x3A001  0x001  ||              LD      r0,0x01     ; place reg data in mem 
-STUP-  CS-0x004  0x36025  0x025  ||              MOV     r0,0x25     ; write dseg data to reg
-STUP-  CS-0x005  0x3A002  0x002  ||              LD      r0,0x02     ; place reg data in mem 
-STUP-  CS-0x006  0x3600D  0x00D  ||              MOV     r0,0x0D     ; write dseg data to reg
-STUP-  CS-0x007  0x3A003  0x003  ||              LD      r0,0x03     ; place reg data in mem 
-STUP-  CS-0x008  0x36099  0x099  ||              MOV     r0,0x99     ; write dseg data to reg
-STUP-  CS-0x009  0x3A004  0x004  ||              LD      r0,0x04     ; place reg data in mem 
-STUP-  CS-0x00A  0x36049  0x049  ||              MOV     r0,0x49     ; write dseg data to reg
-STUP-  CS-0x00B  0x3A005  0x005  ||              LD      r0,0x05     ; place reg data in mem 
-STUP-  CS-0x00C  0x36041  0x041  ||              MOV     r0,0x41     ; write dseg data to reg
-STUP-  CS-0x00D  0x3A006  0x006  ||              LD      r0,0x06     ; place reg data in mem 
-STUP-  CS-0x00E  0x3601F  0x01F  ||              MOV     r0,0x1F     ; write dseg data to reg
-STUP-  CS-0x00F  0x3A007  0x007  ||              LD      r0,0x07     ; place reg data in mem 
-STUP-  CS-0x010  0x36001  0x001  ||              MOV     r0,0x01     ; write dseg data to reg
-STUP-  CS-0x011  0x3A008  0x008  ||              LD      r0,0x08     ; place reg data in mem 
-STUP-  CS-0x012  0x36009  0x009  ||              MOV     r0,0x09     ; write dseg data to reg
-STUP-  CS-0x013  0x3A009  0x009  ||              LD      r0,0x09     ; place reg data in mem 
-STUP-  CS-0x014  0x08100  0x100  ||              BRN     0x20        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0013)  CS-0x020  0x36100  0x020  || Init:		Mov r1, 0x00			; init interrupt count to 0
(0014)  CS-0x021  0x36200         || 		Mov r2, 0x00			; init 10s dig to 0
(0015)  CS-0x022  0x36300         || 		Mov r3, 0x00			; init 1s dig to 0
(0016)  CS-0x023  0x36A07         || 		Mov r10, 0x07			; nodes for 1s
(0017)  CS-0x024  0x36B0B         || 		Mov r11, 0x0B			; nodes for 10s
(0018)  CS-0x025  0x36D00         || 		Mov r13, 0x00			; init temp reg to 0
(0019)  CS-0x026  0x36E00         || 		Mov r14, 0x00			; init 2nd temp reg
(0020)  CS-0x027  0x36F00         || 		Mov r15, 0x00			;Change Checker
(0021)  CS-0x028  0x1A000         || 		SEI
(0022)  CS-0x029  0x37001         || 		mov r16, 0x01
(0023)  CS-0x02A  0x35040         || 		out r16, 0x40			; turn on first led, test
(0024)                            || 
(0025)  CS-0x02B  0x30200  0x02B  || Main:		CMP r2, 0x00			
(0026)  CS-0x02C  0x08182         || 		BREQ DispOne			; if no tens, display ones
(0027)  CS-0x02D  0x04E12         || 		Ld r14, (r2)			; display 10s
(0028)  CS-0x02E  0x34E82         || 		OUT r14, SEGS
(0029)  CS-0x02F  0x34B83         || 		OUT r11, NODES
(0030)                            || 		
(0031)  CS-0x030  0x04E1A  0x030  || DispOne:	LD r14, (r3)			; displays ones
(0032)  CS-0x031  0x34E82         || 		OUT r14, SEGS
(0033)  CS-0x032  0x34A83         || 		OUT r10, NODES
(0034)  CS-0x033  0x08158         || 		BRN Main
(0035)                            || 
(0036)                            || ;------------------------------------------
(0037)                            || ; decodes count to Ones and tens registers|
(0038)                            || ;------------------------------------------
(0039)                            || 
(0040)  CS-0x034  0x36200  0x034  || PreTen: 	Mov r2, 0x00
(0041)  CS-0x035  0x04D09         || 		Mov r13, r1
(0042)                            || 
(0043)  CS-0x036  0x2CD0A  0x036  || Tens:		Sub r13, 0x0A
(0044)  CS-0x037  0x0A1D0         || 		BRCS Ones
(0045)  CS-0x038  0x28201         || 		ADD r2, 0x01
(0046)  CS-0x039  0x081B0         || 		BRN Tens
(0047)                            || 
(0048)  CS-0x03A  0x28D0A  0x03A  || Ones:		Add r13, 0x0A
(0049)  CS-0x03B  0x04369         || 		Mov r3, r13
(0050)  CS-0x03C  0x1A003         || 		RETIE
(0051)                            || 		
(0052)  CS-0x03D  0x36034  0x03D  || ISR:	mov  r0,0x34
(0053)  CS-0x03E  0x34040         ||         OUT  r0,0x40
(0054)  CS-0x03F  0x081F8  0x03F  || junk:   brn junk
(0055)                            || 
(0056)                            || 
(0057)  CS-0x040  0x28101         ||         Add r1, 0x01
(0058)  CS-0x041  0x34140         || 		OUT r1, 0x40
(0059)  CS-0x042  0x30132         || 		CMP r1, 0x32
(0060)  CS-0x043  0x0822B         || 		BRNE Good
(0061)  CS-0x044  0x36100         || 		Mov r1, 0x00
(0062)                            || 
(0063)  CS-0x045  0x081A0  0x045  || Good:	BRN PreTen
(0064)                            || 
(0065)                            || 
(0066)                       1023  || .ORG 0x3FF
(0067)  CS-0x3FF  0x081E8  0x3FF  || INT:	BRN ISR





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
DISPONE        0x030   (0031)  ||  0026 
GOOD           0x045   (0063)  ||  0060 
INIT           0x020   (0013)  ||  
INT            0x3FF   (0067)  ||  
ISR            0x03D   (0052)  ||  0067 
JUNK           0x03F   (0054)  ||  0054 
MAIN           0x02B   (0025)  ||  0034 
ONES           0x03A   (0048)  ||  0044 
PRETEN         0x034   (0040)  ||  0063 
TENS           0x036   (0043)  ||  0046 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
NODES          0x083   (0009)  ||  0029 0033 
SEGS           0x082   (0008)  ||  0028 0032 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
SEG_DATA       0x005   (0004)  ||  
