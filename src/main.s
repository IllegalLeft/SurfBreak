.INCLUDE "nes.i"
.INCLUDE "rommap.i"


.STRUCT plyr
	x		db
	y		db
	velx	db
	vely	db
.ENDST

.ENUM $0000
	sleeping			db		; nonzero if sleeping
	joypadState			db
	joypadStateOld  	db
	player INSTANCEOF 	plyr
.ENDE

.STRUCT OAMentry
	y		db
	tile	db
	attr	db
	x		db
.ENDST

.DEFINE OAMbuffer	$0200 EXPORT
.ENUM $0200
	OAM INSTANCEOF OAMentry 64
.ENDE


.DEFINE joy_right		1 << 0
.DEFINE joy_left		1 << 1
.DEFINE joy_down		1 << 2
.DEFINE joy_up			1 << 3
.DEFINE joy_start		1 << 4
.DEFINE joy_select		1 << 5
.DEFINE joy_b			1 << 6
.DEFINE joy_a			1 << 7



.BANK 0 SLOT 0
.ORG $0000
RESET:
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

	lda #$00			; setup sprite DMA
	sta OAMADDR
	lda #$02
	sta OAMDMA			; $0200-02ff for sprite OAM

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
WaitVBlank:
	inc sleeping
-	lda sleeping
	bne -
	rts

LoadPalette:
	lda PPUSTATUS
	lda #$3F
	sta PPUADDR
	lda #$00
	sta PPUADDR

	ldx #$00
-   lda Palette.w, x
	sta PPUDATA
	inx
	cpx #$20
	bne -
	rts

ReadJoypad:
	lda joypadState
	sta joypadStateOld		; save old state
	lda #1
	sta joypadState
	sta $4016
	lda #0
	sta $4016
	lsr a
	sta $4016
-	lda $4016
	lsr a
	rol joypadState
	bcc -
	rts
	
HandleJoypad:
	lda joypadState
	and #joy_up
	beq +
	; if up
	dec player.y

+	lda joypadState
	and #joy_down
	beq +
	; if down
	inc player.y
+	rts

InitPlayerSprite:
	; set tile IDs
	lda #0
	sta OAM.1.tile
	lda #1
	sta OAM.2.tile
	lda #2
	sta OAM.3.tile
	lda #3
	sta OAM.4.tile
	
	; set attributes
	lda #%00000000
	sta OAM.1.attr
	sta OAM.2.attr
	sta OAM.3.attr
	sta OAM.4.attr
	
UpdatePlayerPos:
	clc
	; set y ordinate
	lda player.y
	sta OAM.1.y
	sta OAM.3.y
	adc #7
	sta OAM.2.y
	sta OAM.4.y
	
	clc
	; set x ordinate
	lda player.x
	sta OAM.1.x
	sta OAM.2.x
	adc #8
	sta OAM.3.x
	sta OAM.4.x
	rts

NMI:
	; back-up registers
	pha
	txa
	pha
	tya
	pha
	
	lda #$00			; setup sprite DMA
	sta OAMADDR
	lda #$02
	sta OAMDMA			; $0200-02ff for sprite OAM
	
	lda #0				; reset sleeping status
	sta sleeping
	
	; retrieve registers
	pla
	tay
	pla
	tax
	pla
	rti


.SECTION "Graphics"

Palette:
.DB $00, $00, $00, $00
.DB $0f, $00, $00, $00
.DB $0f, $00, $00, $00
.DB $0f, $00, $00, $00
.DB $0f, $29, $36, $15
.DB $0f, $00, $00, $00
.DB $0f, $00, $00, $00
.DB $0f, $00, $00, $00

.ENDS


; Interrupt Vectors
.ORGA $FFFA
.DW NMI
.DW RESET
.DW 0		; not used

;vim: filetype=wla
