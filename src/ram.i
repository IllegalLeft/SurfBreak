; RAM Variables

.STRUCT plyr
	x		dw		; unsigned, fixed 12.4
	y		dw		; unsigned, fixed 12.4
	velx	db		; signed, fixed 4.4
	vely	db		; signed, fixed 4.4
	accel	db		; unsigned, fixed 4.4
.ENDST


; Zero Page ($0000 - $00FF)
.ENUM $0000
	scratch				ds 8	; scratch pad
	sleeping			db		; nonzero if sleeping
	joypadState			db
	joypadStateOld  	db
	cloudsx				db
	cloudscounter		db
	mapx				db
	player INSTANCEOF 	plyr
.ENDE

.DEFINE JOY_RIGHT		1 << 0
.DEFINE JOY_LEFT		1 << 1
.DEFINE JOY_DOWN		1 << 2
.DEFINE JOY_UP			1 << 3
.DEFINE JOY_START		1 << 4
.DEFINE JOY_SELECT		1 << 5
.DEFINE JOY_B			1 << 6
.DEFINE JOY_A			1 << 7

; Enemy Buffer ($0100 - $01FF)
.DEFINE ENEMY_COUNT		10
.ENUM $0100
	EnemyState 			ds ENEMY_COUNT
	EnemyTiles			ds 2*ENEMY_COUNT
	EnemyX				ds ENEMY_COUNT
	EnemyY				ds ENEMY_COUNT
.ENDE


; OAM Buffer ($0200 - $02FF)
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