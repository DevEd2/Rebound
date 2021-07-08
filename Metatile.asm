section "Metatile RAM defines",wram0,align[8]

Engine_TilesetPointer:	ds	2

section "Metatile routines",rom0

; Input:    H = Y pos
;           L = X pos
; Output:   A = Tile coordinates
; Destroys: B
GetTileCoordinates:
	ld		a,l
	and		$f
	ld		b,a
	ld		a,h
	and		$f
	swap	a
	add		b
	ret

; Input:    A = Tile coordinates
;			B = Tile ID
; Output:   Metatile to screen RAM
; Destroys: BC, DE, HL
DrawMetatile:
	push	af
	ld		e,a
	; get tile ID
;	ld		hl,Engine_ScreenMap
;	add		l
;	ld		l,a
;	ld		a,[hl]
;	ld		b,a
	; get VRAM coordinates
	ld		a,e
	and		$0f
	rla
	ld		l,a
	ld		a,e
	and		$f0
	ld		e,a
	rla
	rla
	and		%11000000
	or		l
	ld		l,a
	ld		a,e
	rra
	rra
	swap	a
	and		$3
	ld		h,a
	
	ld		de,_SCRN0
	add		hl,de
	ld		d,h
	ld		e,l
	; get tile data pointer
	ld		hl,Engine_TilesetPointer
	ld		a,[hl+]
	ld		h,[hl]
	ld		l,a
	ld		c,b
	ld		b,0
	add		hl,bc
	add		hl,bc
	add		hl,bc
	add		hl,bc
	add		hl,bc
	add		hl,bc
	add		hl,bc
	add		hl,bc
	; write to screen memory
	xor		a
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	ld		a,1
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	inc		de
	
	xor		a
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	ld		a,1
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	ld		a,e
	add		$1f
	jr		nc,.nocarry3
	inc		d
.nocarry3
	ld	e,a
	
	xor		a
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	ld		a,1
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	inc		de
	
	xor		a
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	ld		a,1
	ldh		[rVBK],a
	WaitForVRAM
	ld		a,[hl+]
	ld		[de],a
	pop		af
	ret

