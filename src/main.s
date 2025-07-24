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

	; setup sprite
	lda #$20
	sta player.x
	lda #(SCR_H/2 - 8)
	sta player.y
	lda #$00
	sta player.velx
	sta player.vely
	jsr InitPlayerSprite

	lda #%10000000
	sta PPUCTRL			; enable nmi, sprites from table 0

	lda #%00010000
	sta PPUMASK			; no intensify, enable sprites


GameLoop:
	jsr ReadJoypad
	jsr HandleJoypad
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
	dec player.y

+	lda joypadState
	and #JOY_DOWN
	beq +
	; if down
	inc player.y
+	rts

.ENDS

;vim: filetype=wla
