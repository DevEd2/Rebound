
; ================

section "End screen routines",rom0

GM_EndScreen:
	call    ClearScreen
    
	ldfar	hl,EndScreenTiles
	ld		de,$8000
	call	DecodeWLE

	ld		hl,EndScreenMap
	ld		de,sys_TilemapBuffer
	call	DecodeWLE

	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen

	ldfar	hl,Pal_DevEdPresents
	xor		a
	call	LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call	UpdatePalettes

	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei

.loop
	halt
    ld      a,[sys_btnPress]
    and     a           ; are any buttons pressed?
    jr      nz,:+
    jr      .loop
:   call    PalFadeOutWhite
:   halt
    ld		a,[sys_FadeState]
	bit		0,a
    jr      nz,:-
	xor		a
	ldh		[rLCDC],a
    jp      GM_TitleAndMenus

; ================

section "End screen GFX",romx

EndScreenTiles:	incbin	"GFX/EndScreen.2bpp.wle"
EndScreenMap:	incbin	"GFX/EndScreen.til.wle"