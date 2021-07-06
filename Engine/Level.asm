section "Level state memory",wram0

; Levels are divided into 16-block tall "subareas", which are further divided into 16-block wide "screens"
Engine_CurrentSubarea:
Engine_CurrentScreen:	db	; upper two bits = subarea, remaining bits = screen number
Engine_ActiveScreens:	dw	; up to two screens can be "active" at once (note that the subscreen is ignored here)

Engine_NumScreens1:		db	; number of screens in first subarea
Engine_NumScreens2:		db	; number of screens in second subarea
Engine_NumScreens3:		db	; number of screens in third subarea
Engine_NumScreens4:		db	; number of screens in fourth subarea

section	"Level memory",wramx[$d000]
Engine_LevelData:		ds	256*32

section "Level routines",rom0

GM_Level:
	; initialize variables
	xor		a
	ld		[Engine_CurrentScreen],a	
	; mark first and second screens as "active"
	ld		[Engine_ActiveScreens],a
	inc		a
	ld		[Engine_ActiveScreens+1],a
	
	; TODO: Initialize these during level loading, then remove
	ld		[Engine_NumScreens1],a
	ld		[Engine_NumScreens2],a
	ld		[Engine_NumScreens3],a
	ld		[Engine_NumScreens4],a
	
	; initialize player object
	call	InitPlayer
	
	; start playing music
	; TODO: load music ID from level header
	ld		a,1
	farcall	GHX_Play

	; TODO: Load palettes from level header
	ldfar	hl,Pal_TestMap
	ld		b,(Pal_TestMap_End-Pal_TestMap) / 8
	xor		a
.loop
	push	af
	push	bc
	call	LoadPal
	pop		bc
	pop		af
	inc		a
	dec		b
	jr		nz,.loop

	; TODO: Load "background" graphics from map header
	ldfar	hl,ParallaxTiles
	ld		de,Engine_ParallaxBuffer
	ld		b,0
	call	_CopyRAMSmall
	
	; TODO: Load tileset from level header
	ld		a,low(ParallaxTileset)
	ld		[Engine_TilesetPointer],a
	ld		a,high(ParallaxTileset)
	ld		[Engine_TilesetPointer+1],a

	; TODO: Load level graphics from level header
	CopyTileset	TestMapTiles,0,(TestMapTiles_End-TestMapTiles)/16
	ld		hl,ParallaxMap
	call	LoadMap
	
	ld		a,$80
	ld		[Engine_ParallaxDest],a
	
	; initialize camera
	xor		a
	ld		[Engine_CameraX],a
	ld		[Engine_CameraY],a
	ld		[Engine_CameraOdd],a
	
	; setup registers
	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	
	; TODO: Load player start position from level header
	ld		a,8
	ld		[Player_XPos],a
	ld		[Player_YPos],a
	
	ei
	
LevelLoop::
	; update music
	
.docamera
	ld		a,[Engine_CameraX]
	ld		d,a
	ld		a,[Engine_CameraY]
	ld		e,a

	ld		a,[Player_XPos]
.checkleft
	sub		SCRN_X / 2
	jr		nc,.checkright
	xor		a
	jr		.setcamx
.checkright
	cp		256 - SCRN_X
	jr		c,.setcamx
	ld		a,256 - SCRN_X
.setcamx
	ld		[Engine_CameraX],a

	ld		a,[Player_YPos]
.checkup
	sub		SCRN_Y / 2
	jr		nc,.checkdown
	xor		a
	jr		.setcamy
.checkdown
	cp		256 - SCRN_Y
	jr		c,.setcamy
	ld		a,256 - SCRN_Y
.setcamy
	ld		[Engine_CameraY],a
	
	; do parallax
	; TODO: Replace with proper implementation
	ld		a,[Engine_CameraOdd]
	xor		1
	ld		[Engine_CameraOdd],a
	jr		nz,.skipXY
	ld		a,[Engine_CameraX]
	sub		d
	jr		z,.skipX
	cpl
	inc		a
	ld		b,1
	call	Parallax_ShiftHorizontal
.skipX
	ld		a,[Engine_CameraY]
	sub		e
	jr		z,.skipY
	cpl
	inc		a
	ld		c,1
	call	Parallax_ShiftVertical
.skipY
.skipXY

	call	ProcessPlayer
	call	DrawPlayer

	halt
	jp		LevelLoop
	
; ========

; Input:    HL = Pointer to map header
; TODO: Replace this
LoadMap:
	ld		de,Engine_ScreenMap
	call	DecodeWLE
	xor		a
.loop
	call	DrawMetatile
	inc		a
	jr		nz,.loop
	ret
	
; ========

; INPUT: d = row to load
;        e = screen to load from
Level_LoadMapRow:
	ld		b,b
	; store current RAM bank
	ldh		a,[rSVBK]
	ldh		[sys_TempSVBK],a
	; get area ID	
	ld		a,[CurrentScreen]	; AaxxSSSS
	rla							; AxxSSSSA
	rla							; xxSSSSAA
	and		3					; 000000AA
	add		2
	ldh		[rSVBK],a	; set RAM bank
	; TODO
	
	ld		hl,
	
.done
	; restore SVBK
	ldh		a,[sys_TempSVBK],a
	ldh		[rSVBK],a
	ret