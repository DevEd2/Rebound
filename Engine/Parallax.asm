section "Parallax RAM",wram0,align[8]
Engine_ParallaxBuffer:	ds	256
Engine_ParallaxDest:		db
Engine_ParallaxTemp1:		db
Engine_ParallaxTemp2:		db
Engine_ParallaxTemp3:		db
Engine_ParallaxTemp4:		db

section "Parallax routines",romx
; INPUT: a = amount to shift by
Parallax_ShiftHorizontal::
	push	de
	and		a
	ret		z
	bit		7,a
	jp		nz,Parallax_ShiftRight
	; fall through

Parallax_ShiftLeft::
	ld		b,a
	xor		a

.loop0
	push	bc
	ld		bc,0
.loop1
	push	bc
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	ld		c,a
	
	ld		hl,Engine_ParallaxBuffer + 16
	add		hl,bc
	ld		d,h
	ld		e,l
	ld		hl,Engine_ParallaxBuffer
	add		hl,bc
.loop2
	; first pass
	rept	8	; unrolled loop for speed
		and		a		; clear carry
		ld		a,[hl]	;
		rlca			; shift left (old MSB to carry, don't care about LSB)
		rl		b		; store old MSB in B
		ld		[hl+],a	; write byte back
		ld		a,[de]
		rlca			; same as above
		rl		c		; except store the old MSB in C instead
		ld		[de],a
		inc		e
	endr
	ld		a,b
	ld		[Engine_ParallaxTemp1],a
	ld		a,c
	ld		[Engine_ParallaxTemp2],a
	ld		bc,0
	rept	8	; unrolled loop for speed
		and		a		; clear carry
		ld		a,[hl]	;
		rlca			; shift left (old MSB to carry, don't care about LSB)
		rl		b		; store old MSB in B
		ld		[hl+],a	; write byte back
		ld		a,[de]
		rlca			; same as above
		rl		c		; except store the old MSB in C instead
		ld		[de],a
		inc		e
	endr
	ld		a,b
	ld		[Engine_ParallaxTemp3],a
	ld		a,c
	ld		[Engine_ParallaxTemp4],a
	
	dec		l
	dec		e
	
	; second pass
	rept	8
		ld		a,[hl]
		res		0,a
		rrc		c
		jr		nc,@+4
		set		0,a
		ld		[hl-],a
		ld		a,[de]
		res		0,a
		rrc		b
		jr		nc,@+4
		set		0,a
		ld		[de],a
		dec		e
	endr
	ld		a,[Engine_ParallaxTemp1]
	ld		b,a
	ld		a,[Engine_ParallaxTemp2]
	ld		c,a
	rept	8
		ld		a,[hl]
		res		0,a
		rrc		c
		jr		nc,@+4
		set		0,a
		ld		[hl-],a
		ld		a,[de]
		res		0,a
		rrc		b
		jr		nc,@+4
		set		0,a
		ld		[de],a
		dec		e
	endr
	
; fall through
.continue
	pop		bc
	inc		c
	ld		a,c
	cp		8
	jp		nz,.loop1
	
	pop		bc
	dec		b
	jp		nz,.loop0
	pop		de
	ret
	
Parallax_ShiftRight::
	cpl
	inc		a
	ld		b,a
	xor		a

.loop0
	push	bc
	ld		bc,0
.loop1
	push	bc
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	ld		c,a
	
	ld		hl,Engine_ParallaxBuffer + 16
	add		hl,bc
	ld		d,h
	ld		e,l
	ld		hl,Engine_ParallaxBuffer
	add		hl,bc
.loop2
	; first pass
	rept	8	; unrolled loop for speed
		and		a		; clear carry
		ld		a,[hl]	;
		rrca			; shift right (old LSB to carry, don't care about MSB)
		rl		b		; store old MSB in B
		ld		[hl+],a	; write byte back
		ld		a,[de]
		rrca			; same as above
		rl		c		; except store the old LSB in C instead
		ld		[de],a
		inc		e
	endr
	ld		a,b
	ld		[Engine_ParallaxTemp1],a
	ld		a,c
	ld		[Engine_ParallaxTemp2],a
	ld		bc,0
	rept	8	; unrolled loop for speed
		and		a		; clear carry
		ld		a,[hl]	;
		rrca			; shift right (old LSB to carry, don't care about MSB)
		rl		b		; store old MSB in B
		ld		[hl+],a	; write byte back
		ld		a,[de]
		rrca			; same as above
		rl		c		; except store the old LSB in C instead
		ld		[de],a
		inc		e
	endr
	ld		a,b
	ld		[Engine_ParallaxTemp3],a
	ld		a,c
	ld		[Engine_ParallaxTemp4],a
	
	dec		l
	dec		e
	
	; second pass
	rept	8
		ld		a,[hl]
		res		7,a
		rrc		c
		jr		nc,@+4
		set		7,a
		ld		[hl-],a
		ld		a,[de]
		res		7,a
		rrc		b
		jr		nc,@+4
		set		7,a
		ld		[de],a
		dec		e
	endr
	ld		a,[Engine_ParallaxTemp1]
	ld		b,a
	ld		a,[Engine_ParallaxTemp2]
	ld		c,a
	rept	8
		ld		a,[hl]
		res		7,a
		rrc		c
		jr		nc,@+4
		set		7,a
		ld		[hl-],a
		ld		a,[de]
		res		7,a
		rrc		b
		jr		nc,@+4
		set		7,a
		ld		[de],a
		dec		e
	endr
	
; fall through
.continue
	pop		bc
	dec		c
	ld		a,c
	cp		-8
	jp		nz,.loop1
	
	pop		bc
	dec		b
	jp		nz,.loop0
	pop		de
	ret

; ===============
; Vertical shifts
; ===============

doshiftup:		macro
	rept	14
		ld		a,[hl+]
		ld		[de],a
		inc		e
	endr
	endm

doshiftdown:	macro
	rept	14
		ld		a,[hl-]
		ld		[de],a
		dec		e
	endr
	endm


Parallax_ShiftVertical:
	push	de
	and		a
	ret		z
	bit		7,a
	jp		nz,Parallax_ShiftDown

Parallax_ShiftUp:
.loop
	push	bc
	lb		bc,2,0
	ld		h,high(Engine_ParallaxBuffer)
	ld		d,h
.loop2
	; rows 0 and 2
	ld		l,low(Engine_ParallaxBuffer)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp1],a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp2],a
	doshiftup
	ld		l,low(Engine_ParallaxBuffer + $20)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp3],a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp4],a
	doshiftup
	
	ld		l,low(Engine_ParallaxBuffer + $0e)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp3]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp4]
	ld		[hl],a
	ld		l,low(Engine_ParallaxBuffer + $2e)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp1]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp2]
	ld		[hl],a
	
	; rows 1 and 3
	ld		l,low(Engine_ParallaxBuffer + $10)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp1],a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp2],a
	doshiftup
	ld		l,low(Engine_ParallaxBuffer + $30)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp3],a
	ld		a,[hl+]
	ld		[Engine_ParallaxTemp4],a
	doshiftup
	
	ld		l,low(Engine_ParallaxBuffer + $1e)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp3]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp4]
	ld		[hl],a
	ld		l,low(Engine_ParallaxBuffer + $3e)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp1]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp2]
	ld		[hl],a
	
	inc		c
	dec		b
	jp		nz,.loop2
	
	pop		bc
	dec		c
	jp		nz,.loop
	pop		de
	ret
	
Parallax_ShiftDown:
	cpl
	inc		a
	ld		c,a
.loop
	push	bc
	lb		bc,2,0
	ld		h,high(Engine_ParallaxBuffer)
	ld		d,h
.loop2
	; rows 0 and 2
	ld		l,low(Engine_ParallaxBuffer + $0f)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp2],a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp1],a
	doshiftdown
	ld		hl,Engine_ParallaxBuffer + $2f ; H is trashed after row 0 is processed so we need to refresh it
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp4],a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp3],a
	doshiftdown
	
	ld		l,low(Engine_ParallaxBuffer + $00)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp3]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp4]
	ld		[hl],a
	ld		l,low(Engine_ParallaxBuffer + $20)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp1]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp2]
	ld		[hl],a
	
	; rows 1 and 3
	ld		l,low(Engine_ParallaxBuffer + $1f)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp2],a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp1],a
	doshiftdown
	ld		l,low(Engine_ParallaxBuffer + $3f)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		e,a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp4],a
	ld		a,[hl-]
	ld		[Engine_ParallaxTemp3],a
	doshiftdown
	
	ld		l,low(Engine_ParallaxBuffer + $10)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp3]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp4]
	ld		[hl],a
	ld		l,low(Engine_ParallaxBuffer + $30)
	ld		a,c
	add		a	; x2
	add		a	; x4
	add		a	; x8
	add		a	; x16
	add		a	; x32
	add		a	; x64
	add		l
	ld		l,a
	ld		a,[Engine_ParallaxTemp1]
	ld		[hl+],a
	ld		a,[Engine_ParallaxTemp2]
	ld		[hl],a
	
	inc		c
	dec		b
	jp		nz,.loop2
	
	pop		bc
	dec		c
	jp		nz,.loop
	pop		de
	ret