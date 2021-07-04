section "Color RAM",wram0,align[8]
sys_BGPalBuffer::		ds	4*8
sys_ObjPalBuffer::		ds	4*8
sys_FadeState::			db	; 0 = not fading, 1 = fade in from white, 2 = fade out to white
sys_FadeBGPals::		db	; which BG palettes are fading (bitmask)
sys_FadeOBJPals::		db	; which OBJ palettes are fading (bitmask)
sys_FadeSpeed::			db	; fade speed in ticks
sys_FadeTimer::			db	; used in conjunction with above
sys_FadeLevel::			db	; current intensity level

section "Color routines",rom0

; INPUT:     a = color index to modify
;           hl = color 
; DESTROYS:  a, b, hl
SetColor::
	push	de
	and	15
	bit	3,a
	jr	nz,.obj
	add	a	; x2
	ld	b,a
	ld	de,sys_BGPalBuffer
	add	e
	ld	e,a
	WaitForVRAM
	ld	a,b
	set	7,b	; auto-increment
	ldh	[rBCPS],a
	WaitForVRAM
	ld	a,h
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	WaitForVRAM
	ld	a,l
	ldh	[rBCPD],a
	ld	[de],a
	pop	de
	ret
.obj
	add	a	; x2
	add	a	; x4
	add	a	; x8
	ld	b,a
	ld	de,sys_ObjPalBuffer
	add	e
	ld	e,a
	WaitForVRAM
	ld	a,b
	set	7,b	; auto-increment
	ldh	[rOCPS],a
	WaitForVRAM
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	WaitForVRAM
	ld	a,[hl]
	ldh	[rOCPD],a
	ld	[de],a
	pop	de
	ret

; Routines to initialize palette fading
; INPUT:    b = BG palette mask
;           c = OBJ palette mask
;           e = fade speed (minus 1)
; DESTROYS: a
PalFadeInWhite:
	ld	a,1
	jr	_InitFade

PalFadeOutWhite:
	ld	a,2
	jr	_InitFade
	
PalFadeInBlack:
	ret
	
PalFadeOutBlack:
	ret
	
_InitFade:
	ld	[sys_FadeState],a
	ld	a,31
	ld	[sys_FadeLevel],a
	ld	a,b
	ld	[sys_FadeBGPals],a
	ld	a,c
	ld	[sys_FadeOBJPals],a
	ld	a,e
	ld	[sys_FadeSpeed],a
	ret

; Called each VBlank
Pal_DoFade:
	ld	a,[sys_FadeState]
	ld	b,a
	and	a
	ret	z
	ld	a,[sys_FadeLevel]
	dec	a
	cp	-1
	jp	z,_DoneFade
	ld	[sys_FadeLevel],a
	ld	hl,.fadeproc
	ld	a,b
	dec	a
	and	1
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
.fadeproc
	dw	_PalFadeInWhite
	dw	_PalFadeOutWhite
	
_PalFadeInWhite:
	ret
	
_PalFadeOutWhite:
	ret	; nope, fuck this shit
;	ld	d,0
;	ld	hl,sys_BGPalBuffer
;	ld	a,[sys_FadeBGPals]
;	ld	e,a
;	call	_FadeOutProc
;	ld	a,[sys_FadeOBJPals]
;	ld	e,a
;	; fall trough
; _FadeOutProc:
	; ld	b,b
	; bit	0,e
	; jr	z,.skip1
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop0
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop0
	; pop	bc
	; pop	de
	; ld	d,c
; .skip1
	; bit	1,e
	; jr	z,.skip2
	; push	de
	; ld	a,d
	; add	4
	; ld	c,a
	; ld	a,d
	; add	4
	; ld	c,a
	; ld	e,4
	; push	bc
; .loop1
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop1
	; pop	bc
	; pop	de
	; ld	d,c
; .skip2
	; bit	2,e
	; jr	z,.skip3
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop2
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop2
	; pop	bc
	; pop	de
	; ld	d,c
; .skip3
	; bit	3,e
	; jr	z,.skip4
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop3
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop3
	; pop	bc
	; pop	de
	; ld	d,c
; .skip4
	; bit	4,e
	; jr	z,.skip5
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop4
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop4
	; pop	bc
	; pop	de
	; ld	d,c
; .skip5
	; bit	5,e
	; jr	z,.skip6
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop5
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop5
	; pop	bc
	; pop	de
	; ld	d,c
; .skip6
	; bit	6,e
	; jr	z,.skip7
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop6
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop6
	; pop	bc
	; pop	de
	; ld	d,c
; .skip7
	; bit	7,e
	; jr	z,.skip8
	; push	de
	; ld	a,d
	; ld	b,d
	; add	4
	; ld	c,a
	; ld	d,b
	; ld	e,4
	; push	bc
; .loop7
	; ld	a,[hl+]
	; ld	b,a
	; ld	a,[hl+]
	; push	hl
	; ld	h,a
	; ld	l,b
	; call	_IncColor
	; ld	a,d
	; call	SetColor
	; pop	hl
	; dec	e
	; jr	nz,.loop7
	; pop	bc
	; pop	de
	; ld	d,c
; .skip8
	; ret
	
_DecColor:
	call	SplitColors
	dec	a
	jr	nz,.skip1
	xor	a
.skip1
	push	af
	dec	b
	jr	nz,.skip2
	ld	b,0
.skip2
	dec	c
	jr	nz,.skip3
	ld	c,0
.skip3
	pop	af
	jp	CombineColors
	
_IncColor:
	call	SplitColors
	inc	a
	cp	$1f
	jr	c,.skip1
	ld	a,$1f
.skip1
	push	af
	inc	b
	ld	a,b
	cp	$1f
	jr	c,.skip2
	ld	b,$1f
.skip2
	inc	c
	ld	a,c
	cp	$1f
	jr	c,.skip3
	ld	c,$1f
.skip3
	pop	af
	jp	CombineColors
	
_DoneFade:
	xor	a
	ld	[sys_FadeState],a
	ret

; INPUT:     a = palette number to load into (bit 3 for object palette)
;           hl = palette pointer
; DESTROYS:  a, b, de, hl
LoadPal:
	and	15
	bit	3,a
	jr	nz,.obj
	add	a	; x2
	add	a	; x4
	add	a	; x8
	ld	b,a
	ld	de,sys_BGPalBuffer
	add	e
	ld	e,a
	ld	a,b
	set	7,a	; auto-increment
	ldh	[rBCPS],a
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rBCPD],a
	ld	[de],a
	inc	e
	ret
.obj
	add	a	; x2
	add	a	; x4
	add	a	; x8
	ld	b,a
	ld	de,sys_ObjPalBuffer
	add	e
	ld	e,a
	ld	a,b
	set	7,a	; auto-increment
	ldh	[rOCPS],a
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ld	a,[hl+]
	ldh	[rOCPD],a
	ld	[de],a
	inc	e
	ret
	
; Takes a palette color and splits it into its RGB components.
; INPUT:    hl = color
; OUTPUT:    a = red
;            b = green
;            c = blue
SplitColors:
	push	de
	ld	a,l			; GGGRRRRR
	and	%00011111	; xxxRRRRR
	ld	e,a
	ld	a,l
	and	%11100000	; GGGxxxxx
	swap	a		; xxxxGGGx
	rra				; xxxxxGGG
	ld	b,a
	ld	a,h			; xBBBBBGG
	and	%00000011	; xxxxxxGG
	swap	a		; xxGGxxxx
	rra				; xxxGGxxx
	or	b			; xxxGGGGG
	ld	b,a
	ld	a,h			; xBBBBBGG
	and	%01111100	; xBBBBBxx
	rra				; xxBBBBBx
	rra				; xxxBBBBB
	ld	c,a
	ld	a,e
	pop	de
	ret
	
; Takes a set of RGB components and converts it to a palette color.
; INPUT:     a = red
;            b = green
;            c = blue
; OUTPUT:   hl = color
; DESTROYS:  a
CombineColors:
	ld	h,0			; hl = xxxxxxxx ????????
	ld	l,a			; hl = xxxxxxxx xxxRRRRR
	ld	a,b			;  a = xxxGGGGG
	and	%00000111	;  a = xxxxxGGG
	swap	a		;  a = xGGGxxxx
	rla				;  a = GGGxxxxx
	or	l			;  a = GGGRRRRR
	ld	l,a			; hl = xxxxxxxx GGGRRRRR
	ld	a,b			;  a = xxxGGGGG
	and	%00011000	;  a = xxxGGxxx
	rla				;  a = xxGGxxxx
	swap	a		;  a = xxxxxxGG
	ld	h,a			; hl = xxxxxxGG GGGRRRRR
	ld	a,c			;  a = xxxBBBBB
	rla				;  a = xxBBBBBx
	rla				;  a = xBBBBBxx
	or	h			;  a = xBBBBBGG
	ld	h,a			; hl = xBBBBBGG GGGRRRRR
	ret