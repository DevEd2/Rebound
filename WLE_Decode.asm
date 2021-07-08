DecodeWLE:
; Walle Length Encoding decoder
	ld	c,0
DecodeWLELoop:
	ld	a,[hl+]
	ld	b,a
	and	$c0
	jr	z,.literal
	cp	$40
	jr	z,.repeat
	cp	$80
	jr	z,.increment

.copy
	ld	a,b
	inc	b
	ret	z

	and	$3f
	inc	a
	ld	b,a
	ld	a,[hl+]
	push	hl
	ld	l,a
	ld	a,e
	scf
	sbc	l
	ld	l,a
	ld	a,d
	sbc	0
	ld	h,a
	call	_CopyRAMSmall
	pop	hl
	jr	DecodeWLELoop

.literal
	ld	a,b
	and	$1f
	bit	5,b
	ld	b,a
	jr	nz,.longl
	inc	b
	call	_CopyRAMSmall
	jr	DecodeWLELoop

.longl
	push	bc
	ld	a,[hl+]
	ld	c,a
	inc	bc
	call	_CopyRAM
	pop	bc
	jr	DecodeWLELoop

.repeat
	call	.repeatIncrementCommon
.loopr
	ld	[de],a
	inc	de
	dec	b
	jr	nz,.loopr
	jr	DecodeWLELoop

.increment
	call	.repeatIncrementCommon
.loopi
	ld	[de],a
	inc	de
	inc	a
	dec	b
	jr	nz,.loopi
	ld	c,a
	jr	DecodeWLELoop

.repeatIncrementCommon
	bit	5,b
	jr	z,.nonewr
	ld	c,[hl]
	inc	hl
.nonewr
	ld	a,b
	and	$1f
	inc	a
	ld	b,a
	ld	a,c
	ret
