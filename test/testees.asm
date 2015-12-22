;---------------------------------------------------------------------
; An expanded "draw_dot" program that includes subrountines to draw
; vertical lines, horizontal lines, and a full background. 
; 
; As written, this programs does the following: 
;   1) draws a the background blue (draws all the tiles)
;   2) draws a red dot
;   3) draws a red horizontal lines
;   4) draws a red vertical line
;
; Author: Bridget Benson 
; Modifications: bryan mealy
;   revsion 11-12-2013: simplified drawdot, added comments
;---------------------------------------------------------------------

;---------------------------------------------------------------------
;Authors: Colton Sundstrom & Nico Ledwith
;Group:	Ledstrom Labs
;Project Name: Adventure time with Dr.Alu OpySel
;Description: A platform runner based on the RAT MCU architecture
;encorporating the VGA_Driver peripheral. 
;
;Version: 0.1(Condor)
;--------------------------------------------------------------------

.CSEG
.ORG 0x10

;---------------------------------------------------------------------
;- register definitions 
;---------------------------------------------------------------------
.EQU VGA_HADD  = 0x90
.EQU VGA_LADD  = 0x91
.EQU VGA_COLOR = 0x92
.EQU KEYBOARD  = 0x25
.EQU SSEG      = 0x81
.EQU LEDS      = 0x40
;---------------------------------------------------------------------

.EQU BG_COLOR       = 0x00             	;Background:  Black
.equ Dr_ALU_OPYSEL	= 0x3F				;Player Color:Yellow
.equ G_C			= 0xC0				;Ground Color:Blue


.EQU MY_INSIDE_FOR_COUNT    = 0x1F		;Used for the Waitx SR
.EQU MY_MIDDLE_FOR_COUNT    = 0xFF
.EQU MY_OUTSIDE_FOR_COUNT   = 0xFF

;---------------------------------------------------------------------
;- r6 is used for color
;- r7 is used for working Y coordinate
;- r8 is used for working X coordinate

;- r13 holds Alu's Y position

;- r18 holds Left Hole position
;- r19 holds Right Hole potition
;---------------------------------------------------------------------

;---------------------------------------------------------------------
init:
			CALL   draw_background         ; draw using default color

			MOV    r7, 0x11                ; generic Y coordinate
			MOV	   r13, r7				   ; copy alu's y_pos
			MOV    r8, 0x12                ; generic X coordinate
			MOV    r6, 0x3F                ; color
			CALL   draw_dot                ; draw yellow square 

			MOV 	r6,0xC0
			MOV    r8,0x00                 ; starting x coordinate
			MOV    r7,0x12                 ; start y coordinate
			MOV    r9,0x27                 ; ending x coordinate
			CALL   draw_horizontal_line
			SEI

			call	MakeHole				;Init Hole Placement

main:	    call	MoveHole				
			call	END_CHECK				
			call	waitx
			BRN		main                    ; continuous loop 


;--------------------------------------------------------------------
MoveHole:	mov		r7, r17				;Moves the Hole left by subtracting
			sub 	r18, 0x01			;a X value, then fills the old hole
			sub 	r19, 0x01			;with the Ground Color.
			BRCS 	MakeHole
			mov 	r8, r19
			mov 	r6, bg_color
			call 	draw_dot
			call 	fill_hole
			ret

fill_hole:	mov 	r8, r18				;Fills the Previous Hole
			add 	r8, 0x01
			mov 	r6, g_c
			call 	draw_dot
			ret
			
;'MakeHole' initializes the Hole placement to the right of the screen.
MakeHole:	MOV 	r7,0x12				; y		
			MOV 	r8,0x27				; x (hole right side)
			MOV 	r17, r7
			MOV 	r18, r8				; copy coords
			MOV 	r6, bg_color
			CALL 	draw_dot

			MOV 	r8,0x26
			MOV 	r19, r8
			CALL 	draw_dot

			mov 	r8, 0x00
			mov 	r6, g_c
			call 	draw_dot

			mov 	r8, 0x01
			call 	draw_dot
			ret
;------------------------------------------------------------------------
;Checks if the player is occupying the space above the hole.
END_CHECK:	cmp 	r13, 0x11
			brne 	safe
			CMP 	r13, r19
			breq 	ALU_End
			cmp 	r13, r18
			breq 	alu_end
			brn 	safe
safe:		ret

;-----------------------------------------------------------------------
;Draws an END that blinks, signifying the end of the game.
ALU_END:	CLI
			call 	draw_background
			call	waitx
			call 	draw_E
			CALL 	waitx

			call 	draw_D
			call 	waitx
			
			call 	draw_N
			call	waitx
			brn		ALU_END

			

DRAW_E:		MOV 	r6,0x07
			MOV    	r8,0x08                 ; starting x coordinate
			MOV    	r7,0x0A                 ; start y coordinate
			MOV    	r9,0x14                 ; ending Y coordinate
			CALL   	draw_vertical_line
			
			MOV    	r8,0x08                 ; starting x coordinate
			MOV    	r7,0x0A                 ; start y coordinate
			MOV    	r9,0x0C                 ; ending x coordinate
			CALL   	draw_HORIZONTAL_line

			MOV    	r8,0x08                 ; starting x coordinate
			MOV    	r7,0x0F                 ; start y coordinate
			MOV    	r9,0x0C                 ; ending x coordinate
			CALL   	draw_HORIZONTAL_line

			MOV    	r8,0x08                 ; starting x coordinate
			MOV    	r7,0x14                 ; start y coordinate
			MOV    	r9,0x0C                 ; ending x coordinate
			CALL   	draw_HORIZONTAL_line

			ret

DRAW_D:		MOV 	r6,0x07
			MOV    	r8,0x18                 ; starting x coordinate
			MOV    	r7,0x0A                ; start y coordinate
			MOV    	r9,0x14                 ; ending Y coordinate
			CALL   	draw_vertical_line

			MOV    	r8,0x1D                 ; starting x coordinate
			MOV    	r7,0x0D                 ; start y coordinate
			MOV    	r9,0x11                 ; ending Y coordinate
			CALL   	draw_vertical_line

			MOV 	R8, 0x19
			MOV 	R7, 0xCA
			CALL 	DRAW_DOT

			MOV 	R8, 0x1A
			MOV 	R7, 0x0A
			CALL 	DRAW_DOT

			MOV 	R8, 0x1B
			MOV 	R7, 0x0B
			CALL 	DRAW_DOT

			MOV 	R8, 0x1C
			MOV 	R7, 0x0C
			CALL 	DRAW_DOT

			MOV 	R8, 0x19
			MOV 	R7, 0x14
			CALL 	DRAW_DOT

			MOV 	R8, 0x1A
			MOV 	R7, 0x14
			CALL 	DRAW_DOT

			MOV 	R8, 0x1B
			MOV 	R7, 0x13
			CALL 	DRAW_DOT

			MOV 	R8, 0x1C
			MOV 	R7, 0x12
			CALL 	DRAW_DOT

			RET

DRAW_N:		MOV 	r6,0x07
			MOV    	r8,0x0F                 ; starting x coordinate
			MOV    	r7,0x0A                ; start y coordinate
			MOV    	r9,0x14                 ; ending Y coordinate
			CALL   	draw_vertical_line

			MOV    	r8,0x15                 ; starting x coordinate
			MOV    	r7,0x0A                 ; start y coordinate
			MOV    	r9,0x14                 ; ending Y coordinate
			CALL   	draw_vertical_line

			MOV 	R8, 0x10
			MOV 	R7, 0x0B
			CALL 	DRAW_DOT

			MOV 	R8, 0x11
			MOV 	R7, 0x0C
			CALL 	DRAW_DOT

			MOV 	R8, 0x11
			MOV 	R7, 0x0D
			CALL 	DRAW_DOT

			MOV 	R8, 0x12
			MOV 	R7, 0x0E
			CALL 	DRAW_DOT

			MOV 	R8, 0x12
			MOV 	R7, 0x0F
			CALL 	DRAW_DOT

			MOV 	R8, 0x13
			MOV 	R7, 0x10
			CALL 	DRAW_DOT

			MOV 	R8, 0x13
			MOV 	R7, 0x11
			CALL 	DRAW_DOT

			MOV 	R8, 0x14
			MOV 	R7, 0x12
			CALL 	DRAW_DOT

			MOV 	R8, 0x14
			MOV 	R7, 0x13
			CALL 	DRAW_DOT

			RET
;-----------------------------------------------------------------------
;Section deals with moving the player, controlled from the ISR.
MOVE_ALU_UP:MOV		r14, r13
			SUB		r13, 0x01
			MOV		r7, r13
			MOV		r8, 0x12
			MOV		r6, dr_alu_opysel
			Call 	draw_dot
			CALL	Fill_alu
			RET

Fill_alu:   MOV		r7, r14
			mov		r8, 0x12
			MOV		r6, bg_color
			Call	draw_dot
			RET

MOVE_ALU_DN:MOV		r14, r13
			ADD		r13, 0x01
			MOV		r7, r13
			MOV		r8, 0x12
			MOV		r6, dr_alu_opysel
			Call 	draw_dot
			CALL	Fill_Alu
			RET

;----------------------------------------------------------------------
;Due to Drawing errors, the masks cover the assigned color. 
mask_up:	MOV		r7, 0x0c
			mov		r8, 0x12
			mov		r6, bg_color
			call 	draw_dot
			ret

mask_dn:			
			mov		r7, 0x13
			mov		r8, 0x12
			mov		r6, bg_color
			call 	draw_dot
			ret	
;-----------------------------------------------------------------------
;ISR is called from the button press, causes Alu to 'jump'.
ISR:		CALL	move_alu_up
			call    moveHole
			call 	waitx

			CALL	move_alu_up
			call 	moveHole
			call 	waitx

			CALL	move_alu_dn
			CALL	mask_up
			call	moveHole
			call 	waitx


			CALL	move_alu_dn
			CALL	mask_dn
			call	moveHole
			call	waitx
	
			retie

;------------------------------------------------------------------------
;Waitx causes a wait in the program. 
waitx:	     MOV     R29, MY_OUTSIDE_FOR_COUNT  ;set outside for loop count
outside_forx: SUB     R29, 0x01

			 MOV     R28, MY_MIDDLE_FOR_COUNT   ;set middle for loop count
middle_forx: SUB     R28, 0x01
			 
			 MOV     R27, MY_INSIDE_FOR_COUNT   ;set inside for loop count
inside_forx: SUB     R27, 0x01
			 BRNE    inside_forx
			 
			 OR      R28, 0x00               ;load flags for middle for counter
			 BRNE    middle_forx
			 
			 OR      R29, 0x00               ;load flags for outsde for counter value
			 BRNE    outside_forx
			 RET
;--------------------------------------------------------------------
;-  Subroutine: draw_horizontal_line
;-
;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6.
;-   This subroutine works by consecutive calls to drawdot, meaning
;-   that a horizontal line is nothing more than a bunch of dots. 
;-
;-  Parameters:
;-   r8  = starting x-coordinate
;-   r7  = y-coordinate
;-   r9  = ending x-coordinate
;-   r6  = color used for line
;- 
;- Tweaked registers: r8,r9
;--------------------------------------------------------------------
draw_horizontal_line:
			ADD    r9,0x01          ; go from r8 to r9 inclusive

draw_horiz1:
			CALL   draw_dot         ; draw tile
			ADD    r8,0x01          ; increment column (X) count
			CMP    r8,r9            ; see if there are more columns
			BRNE   draw_horiz1      ; branch if more columns
			RET
;--------------------------------------------------------------------


;---------------------------------------------------------------------
;-  Subroutine: draw_vertical_line
;-
;-  Draws a horizontal line from (r8,r7) to (r8,r9) using color in r6. 
;-   This subroutine works by consecutive calls to drawdot, meaning
;-   that a vertical line is nothing more than a bunch of dots. 
;-
;-  Parameters:
;-   r8  = x-coordinate
;-   r7  = starting y-coordinate
;-   r9  = ending y-coordinate
;-   r6  = color used for line
;- 
;- Tweaked registers: r7,r9
;--------------------------------------------------------------------
draw_vertical_line:
			ADD    r9,0x01         ; go from r7 to r9 inclusive

draw_vert1:          
			CALL   draw_dot        ; draw tile
			ADD    r7,0x01         ; increment row (y) count
			CMP    r7,R9           ; see if there are more rows
			BRNE   draw_vert1      ; branch if more rows
			RET
;--------------------------------------------------------------------

;---------------------------------------------------------------------
;-  Subroutine: draw_background
;-
;-  Fills the 30x40 grid with one color using successive calls to 
;-  draw_horizontal_line subroutine. 
;- 
;-  Tweaked registers: r13,r7,r8,r9
;----------------------------------------------------------------------
draw_background: 
			MOV   r6,BG_COLOR              ; use default color
			MOV   r13,0x00                 ; r13 keeps track of rows
start:  	MOV   r7,r13                   ; load current row count 
			MOV   r8,0x00                  ; restart x coordinates
			MOV   r9,0x27 
 
			CALL  draw_horizontal_line     ; draw a complete line
			ADD   r13,0x01                 ; increment row count
			CMP   r13,0x1E                 ; see if more rows to draw
			BRNE  start                    ; branch to draw more rows
			RET
;---------------------------------------------------------------------
    
;---------------------------------------------------------------------
;- Subrountine: draw_dot
;- 
;- This subroutine draws a dot on the display the given coordinates: 
;- 
;- (X,Y) = (r8,r7)  with a color stored in r6  
;- 
;- Tweaked registers: r4,r5
;---------------------------------------------------------------------
draw_dot: 
           MOV   r4,r7         ; copy Y coordinate
           MOV   r5,r8         ; copy X coordinate

           AND   r5,0x3F       ; make sure top 2 bits cleared
           AND   r4,0x1F       ; make sure top 3 bits cleared

           ;--- you need bottom two bits of r4 into top two bits of r5
           LSR   r4            ; shift LSB into carry 
           BRCC  bit7          ; no carry, jump to next bit
           OR    r5,0x40       ; there was a carry, set bit
           CLC                 ; freshen bit, do one more left shift

bit7:      LSR   r4            ; shift LSB into carry 
           BRCC  dd_out        ; no carry, jump to output
           OR    r5,0x80       ; set bit if needed

dd_out:    OUT   r5,VGA_LADD   ; write low 8 address bits to register
           OUT   r4,VGA_HADD   ; write hi 3 address bits to register
           OUT   r6,VGA_COLOR  ; write data to frame buffer
           RET
; --------------------------------------------------------------------
.ORG 0x3FF
INT:		BRN		ISR
