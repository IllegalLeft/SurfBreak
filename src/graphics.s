; Graphics Routines
.INCLUDE "nes.i"
.INCLUDE "rommap.i"
.INCLUDE "ram.i"

.SECTION "Graphics Routines"

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

.ENDS
    

.SECTION "Graphics Data"

Palette:
.DB $21, $00, $00, $00
.DB $00, $00, $00, $00
.DB $00, $00, $00, $00
.DB $00, $00, $00, $00
.DB $21, $29, $36, $15
.DB $00, $00, $00, $00
.DB $00, $00, $00, $00
.DB $00, $00, $00, $00

.ENDS