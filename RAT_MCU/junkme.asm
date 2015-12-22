.DSEG
.ORG 0x00

seg_data: .DB 0x03, 0x9F, 0x25, 0x0D, 0x99  ; 0-4 
		  .DB 0x49, 0x41, 0x1F, 0x01, 0x09  ; 5-9

.CSEG
.EQU SEGS = 0x82
.EQU NODES = 0x83

.ORG 0x20

Init:		Mov r1, 0x00			; init interrupt count to 0
		Mov r2, 0x00			; init 10s dig to 0
		Mov r3, 0x00			; init 1s dig to 0
		Mov r10, 0x07			; nodes for 1s
		Mov r11, 0x0B			; nodes for 10s
		Mov r13, 0x00			; init temp reg to 0
		Mov r14, 0x00			; init 2nd temp reg
		Mov r15, 0x00			;Change Checker
		SEI
		mov r16, 0x01
		out r16, 0x40			; turn on first led, test

Main:		CMP r2, 0x00			
		BREQ DispOne			; if no tens, display ones
		Ld r14, (r2)			; display 10s
		OUT r14, SEGS
		OUT r11, NODES
		
DispOne:	LD r14, (r3)			; displays ones
		OUT r14, SEGS
		OUT r10, NODES
		BRN Main

;------------------------------------------
; decodes count to Ones and tens registers|
;------------------------------------------

PreTen: 	Mov r2, 0x00
		Mov r13, r1

Tens:		Sub r13, 0x0A
		BRCS Ones
		ADD r2, 0x01
		BRN Tens

Ones:		Add r13, 0x0A
		Mov r3, r13
		RETIE
		
ISR:	mov  r0,0x34
        OUT  r0,0x40
junk:   brn junk


        Add r1, 0x01
		OUT r1, 0x40
		CMP r1, 0x32
		BRNE Good
		Mov r1, 0x00

Good:	BRN PreTen


.ORG 0x3FF
INT:	BRN ISR
