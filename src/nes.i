; NES System Definitions
; For WLA-DX

.DEFINE SCR_W		256
.DEFINE SCR_H		240

;PPU Registers
.ENUM $2000
	PPUCTRL		db
	PPUMASK		db
	PPUSTATUS	db
	OAMADDR		db
	OAMDATA		db
	PPUSCROLL	db
	PPUADDR		db
	PPUDATA		db
.ENDE
.DEFINE OAMDMA	$4014

; I/O Devices
.DEFINE JOY1	$4016
.DEFINE JOY2	$4017

;APU Registers
.ENUM $4000
	SQ1_VOL			db
	SQ1_SWEEP		db
	SQ1_LO			db
	SQ1_HI			db
	
	SQ2_VOL			db
	SQ2_SWEEP		db
	SQ2_LO			db
	SQ2_HI			db
	
	TRI_LINEAR		ds 2
	; byte unused
	TRI_LO			db
	TRI_HI			db
	
	NOISE_VOL		ds 2
	; byte unused
	NOISE_LO		db
	NOISE_HI		db
	
	DMC_FREQ		db
	DMC_RAW			db
	DMC_START		db
	DMC_LEN			db
.ENDE
	
.ENUM $4015
	APUSTATUS		ds 2
	; byte unused
	APUFRAMECNTR	db
.ENDE