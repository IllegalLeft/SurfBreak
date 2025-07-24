; Interrupts
.INCLUDE "nes.i"
.INCLUDE "rommap.i"
.INCLUDE "ram.i"


.BANK 0 SLOT 0
NMIHandler:
	; back-up registers
	pha
	txa
	pha
	tya
	pha
	
	lda #$00			; setup sprite DMA
	sta OAMADDR
	lda #>OAM
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


; Interrupt Vectors
.ORGA $FFFA
.DW NMIHandler
.DW Reset
.DW 0		; not used
