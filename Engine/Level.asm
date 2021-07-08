section "Level state memory",wram0

; Levels are divided into 16-block tall "subareas", which are further divided into 16-block wide "screens"
Engine_CurrentSubarea:
Engine_CurrentScreen:	db	; upper two bits = subarea, remaining bits = screen number
Engine_ActiveScreens:	dw	; up to two screens can be "active" at once (note that the subscreen is ignored here)
Engine_NumScreens:		db	; number of screens per subarea (effectively "map width")
Engine_NumSubareas:		db	; number of subareas

Engine_CameraX:		db
Engine_CameraY:		db
Engine_LockCamera:	db

section	"Level memory",wramx[$d000]
Engine_LevelData:		ds	256*16

section "Level routines",rom0

GM_Level:
	; initialize variables
	xor		a
	ld		[Engine_CurrentScreen],a
	; mark first and second screens as "active"
	ld		[Engine_ActiveScreens],a
	inc		a
	ld		[Engine_ActiveScreens+1],a
	; initialize player object
	call	InitPlayer

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
	ld		hl,Map_TestMap
	call	LoadMap
	
	ld		a,$80
	ld		[Engine_ParallaxDest],a
	
	; initialize camera
	xor		a
	ld		[Engine_CameraX],a
	ld		[Engine_CameraY],a
	ld		[Engine_LockCamera],a
	
	; setup registers
	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	
	ei
	
LevelLoop::
	
.docamera
	ld		a,[Engine_LockCamera]
	and		a
	jr		nz,.nocamera

	ld		a,[Engine_CameraX]
	rra
	ld		d,a
	and		a
	ld		a,[Engine_CameraY]
	rra
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
	and		a	; clear carry
	push	de
	ld		a,[Engine_CameraX]
	rra
	sub		d
	jr		z,.skipX
	cpl
	inc		a
	ld		b,1
	call	Parallax_ShiftHorizontal

.skipX
	pop		de
	ld		a,[Engine_CameraY]
	rra
	sub		e
	jr		z,.skipY
	cpl
	inc		a
	ld		c,1
	call	Parallax_ShiftVertical
.skipY

.nocamera

	call	ProcessPlayer
	call	DrawPlayer

	halt
	jp		LevelLoop
	
; ================================================================

; Input:    HL = Pointer to map header
LoadMap:
	ld		a,[hl+]	; get screen count
	and		$f		; maximum of 16 screens allowed
	ld		[Engine_NumScreens],a
	ld		a,[hl+]	; get subarea count
	and		$3		; maximum of 4 subareas allowed
	ld		[Engine_NumSubareas],a
	
	; load player start X position
	ld		a,[hl]	; we'll need this byte again so don't inc hl yet
	and		$f0		; \ convert to
	add		8		; / correct format
	ld		[Player_XPos],a
	; load player start Y position
	ld		a,[hl+]
	and		$0f		; \ convert to 
	swap	a		; | correct 
	add		8		; / format
	ld		[Player_YPos],a
	; load player starting screen + subarea
	ld		a,[hl+]
	ld		[Player_ScreenID],a	; no need to convert to different format here
	
	
	; TODO: load tileset
	inc		hl
	
	; load music
	ld		a,[hl+]
	push	hl
	farcall	GHX_Play
	pop		hl
	resbank
	
	
	; load map into mem
	lb		bc,4,0
.loop
	push	hl
	push	bc
	ld		a,[hl+]
	ld		h,[hl]
	ld		l,a
	
	ld		a,c
	add		2
	ld		[rSVBK],a
	
	ld		de,Engine_LevelData
	call	DecodeWLE
	
	pop		bc
	pop		hl
	inc		hl
	inc		hl
	inc		c
	dec		b
	jr		nz,.loop
	
	ld		a,[Player_ScreenID]
	call	Level_LoadScreen
	
	ld		a,1
	ldh		[rSVBK],a
	ret
	
; ========

; INPUT: a = screen ID
Level_LoadScreen:
	ld		b,a
	and		$30
	swap	a
	add		2
	ldh		[rSVBK],a
	ld		hl,Engine_LevelData
	ld		a,b
	and		$0f
	add		h
	ld		h,a
	lb		bc,16,0
	ld		e,0
.loop
	push	bc
	push	de
	xor		a
	ldh		[rVBK],a
	ld		a,[hl+]
	push	hl
	ld		b,a
	; get Y coordinate
	ld		a,e
	and		$f
	swap	a
	ld		d,a
	; get X coordinate
	ld		a,c
	and		$f
	or		d
	call	DrawMetatile
	
	pop		hl
	pop		de
	pop		bc
	inc		e
	dec		b
	jr		nz,.loop
	ld		b,16
	ld		e,0
	inc		c
	ld		a,c
	cp		16
	jr		nz,.loop
	ret
	
; ========

; INPUT: d = row to load
;        e = screen to load from
Level_LoadMapRow:
	ld		hl,Engine_LevelData

	ret
