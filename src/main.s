.INCLUDE "nes.i"
.INCLUDE "rommap.i"
.INCLUDE "ram.i"


.BANK 0 SLOT 0
.ORGA $C000
.SECTION "Main"
Reset:
	sei					; disable IRQs
	cld					; disable decimal mode
	ldx #$40
	stx APUFRAMECNTR	; disable APU frame IRQ
	ldx #$FF
	txs					; set stack up
	inx					; zero x
	stx PPUCTRL			; disable NMI
	stx PPUMASK			; disable rendering
	stx APUSTATUS		; disable DMC IRQs

-	bit PPUSTATUS		; wait for vblank
	bpl -

-	lda #$00			; clear mem
	sta $0000, x
	sta $0100, x
	sta $0200, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	lda #$FE
	sta $0300, x
	inx
	bne -

-	bit PPUSTATUS		; wait for vblank
	bpl -

	jsr LoadPalette
	jsr LoadScreen

	; setup sprite
	lda #$20
	sta player.x
	lda #$00			; centering player y ($70 is center so store $0700)
	sta player.y
	lda #$07
	sta player.y+1
	lda #$00
	sta player.velx
	sta player.vely
	lda #$02
	sta player.accel
	jsr InitPlayerSprite

	lda #%10001000
	sta PPUCTRL			; enable nmi, sprites from table 0

	lda #%00011110
	sta PPUMASK			; no intensify, enable sprites

	lda #0				; reset nametable scroll to 0, 0
	sta PPUSCROLL
	sta PPUSCROLL


GameLoop:
	jsr ReadJoypad
	jsr HandleJoypad

	jsr LimitPlayerVel
	jsr ApplyPlayerVel
	jsr UpdatePlayerPos

	jsr WaitVBlank
	jmp GameLoop


; Subroutines
ReadJoypad:
	lda joypadState
	sta joypadStateOld		; save old state
	lda #1
	sta joypadState
	sta JOY1
	lda #0
	sta JOY1
	lsr a
	sta JOY1
-	lda JOY1
	lsr a
	rol joypadState
	bcc -
	rts
	
HandleJoypad:
	lda joypadState
	and #JOY_UP
	beq +
	; if up
	lda player.vely
	sec
	sbc player.accel
	sta player.vely

+	lda joypadState
	and #JOY_DOWN
	beq +
	; if down
	lda player.vely
	clc
	adc player.accel
	sta player.vely
+	rts

.DEFINE MAX_VEL_Y	50
LimitPlayerVel:
	lda player.vely
	bmi @negativevel
	; velocity is positive
	cmp #MAX_VEL_Y
	bcc ++					; it's below the limit
	; limit velocity to max
	lda #MAX_VEL_Y
	jmp +

	; velocity is negative
@negativevel:
	cmp #-MAX_VEL_Y
	bcs ++					; it's below the limit
	lda #-MAX_VEL_Y
+	sta player.vely
++	rts

ApplyPlayerVel:
	lda player.vely
	bmi @negativevel		; check if the velocity is negative
	clc
	adc player.y
	sta player.y
	lda #0
	adc player.y+1
	sta player.y+1
	rts
@negativevel:
	sec						; convert to absolute magnitude (remove negative)
	eor #$FF
	sta scratch
	lda player.y
	sbc scratch
	sta player.y
	lda player.y+1
	sbc #0
	sta player.y+1
	rts

.ENDS

;vim: filetype=wla