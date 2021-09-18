
; ================

section "Game over screen routines",rom0

GM_GameOver:
	call    ClearScreen
    
	ldfar	hl,GameOverTiles
	ld		de,$8000
	call	DecodeWLE

	ld		hl,GameOverMap
	ld		de,sys_TilemapBuffer
	call	DecodeWLE
	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen
    
    ld      a,1
    ldh     [rVBK],a
    
	ld		hl,GameOverAttr
	ld		de,sys_TilemapBuffer
	call	DecodeWLE
	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen
    
    xor     a
    ldh     [rVBK],a

	ldfar	hl,Pal_GameOver
    ld      b,6
    xor     a
:   push    af
    push    bc
    call    LoadPal
    pop     bc
    pop     af
    inc     a
    dec     b
    jr      nz,:-
    call    ConvertPals
    call    PalFadeInWhite
    call	UpdatePalettes

    ld      a,MUS_GAME_OVER
    farcall DS_Init

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

section "Game over screen GFX",romx

GameOverTiles:  incbin	"GFX/Screens/GameOver.2bpp.wle"
GameOverMap:	incbin	"GFX/Screens/GameOver.til.wle"
GameOverAttr:   incbin  "GFX/Screens/GameOver.atr.wle"
Pal_GameOver:   incbin  "GFX/Screens/GameOver.pal"