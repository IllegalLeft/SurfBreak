; RAM Variables

.STRUCT plyr
	x		dw		; unsigned, fixed 12.4
	y		dw		; unsigned, fixed 12.4
	velx	db		; signed, fixed 4.4
	vely	db		; signed, fixed 4.4
	accel	db		; unsigned, fixed 4.4
.ENDST


; Zero Page
.ENUM $0000
	sleeping			db		; nonzero if sleeping
	joypadState			db
	joypadStateOld  	db
	cloudsx				db
	cloudscounter		db
	mapx				db
	player INSTANCEOF 	plyr
	scratch				ds 8	; scratchpad
.ENDE

.DEFINE JOY_RIGHT		1 << 0
.DEFINE JOY_LEFT		1 << 1
.DEFINE JOY_DOWN		1 << 2
.DEFINE JOY_UP			1 << 3
.DEFINE JOY_START		1 << 4
.DEFINE JOY_SELECT		1 << 5
.DEFINE JOY_B			1 << 6
.DEFINE JOY_A			1 << 7


.STRUCT OAMentry
	y		db
	tile	db
	attr	db
	x		db
.ENDST

.DEFINE OAMbuffer	$0200
.ENUM $0200
	OAM INSTANCEOF OAMentry 64
.ENDE