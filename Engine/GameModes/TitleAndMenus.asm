section "Title screen + menu RAM",wram0

Title_PressStartX:	db
Title_PressStartY:	db

; ================

section "Title screen + menu routines",rom0

GM_TitleAndMenus:
    call    ClearScreen
    ldfar   hl,TitleScreenTiles1
    ld      de,$8000
    call    DecodeWLE

    ld      hl,TitleScreenMap
    ld      de,sys_TilemapBuffer
    call    DecodeWLE
    ld      hl,sys_TilemapBuffer
    call    LoadTilemapScreen

	ld		a,1
	ldh		[rVBK],a
	
    ld		hl,TitleScreenTiles2
    ld      de,$8000
    call    DecodeWLE
	
	ld		hl,Title_PressStartTiles
	ld		de,$8270
	ld		b,Title_PressStartTiles.end-Title_PressStartTiles
:
	ld		a,[hl+]
	ld		[de],a
	inc		e
	dec		b
	jr		nz,:-
	
	ld		hl,TitleScreenAttr
    ld      de,sys_TilemapBuffer
    call    DecodeWLE
    ld      hl,sys_TilemapBuffer
    call    LoadTilemapScreen

    ld      hl,Pal_TitleScreen
	ld		b,7
	xor		a
:	push	af
	push	bc
    call    LoadPal
	pop		bc
	pop		af
	inc		a
	dec		b
	jr		nz,:-
	ld		hl,Pal_Title_PressStart
	ld		a,8
	call	LoadPal
	
    call    ConvertPals
    call    PalFadeInWhite
    call    UpdatePalettes

    xor     a   ; MUS_MENU
	ldh		[rVBK],a
    farcall DevSound_Init

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON |LCDCF_OBJON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    
	ld		a,52
	ld		[Title_PressStartX],a
	ld		a,144
	ld		[Title_PressStartY],a
	ei

TitleLoop:
    ld      a,[sys_btnPress]
    bit     btnStart,a
    jr      z,.skip

    call    DevSound_Stop
    PlaySFX menuselect
    call    PalFadeOutWhite
    ; wait for fade to finish
:   halt
    ld      a,[sys_FadeState]
    bit     0,a
    jr      nz,:-
    call    AllPalsWhite
    call    UpdatePalettes
    
    ; wait for SFX to finish
:   halt
    ld      a,[VGMSFX_Flags]
    and     a
    jr      nz,:-
    xor     a
    ldh     [rLCDC],a
    
    ld      a,PLAYER_LIVES
    ld      [Player_LifeCount],a
    
    ld      a,MapID_Plains1
    jp      GM_Level

.skip
	; draw "PRESS START" text
	ld		hl,Metasprite_PressStart
	ld		b,(Metasprite_PressStart.end-Metasprite_PressStart)/4
	call	BeginSprites
:
	push	bc
	ld		a,[hl+]
	ld		d,a
	ld		a,[Title_PressStartY]
	add		d
	ld		d,a
	ld		a,[hl+]
	ld		e,a
	ld		a,[Title_PressStartX]
	add		e
	ld		e,a
	ld		a,[hl+]
	ld		b,a
	ld		a,[hl+]
	ld		c,a
	push	hl
	call	AddSprite
	pop		hl
	pop		bc
	dec		b
	jr		nz,:-
	call	EndSprites

    halt
    jr      TitleLoop
    
Metasprite_PressStart:
	db	$00,$00,$27,%00001000
	db	$00,$08,$28,%00001000
	db	$00,$10,$29,%00001000
	db	$00,$18,$2A,%00001000
	db	$00,$20,$2B,%00001000
	db	$00,$28,$2C,%00001000
	db	$00,$30,$2D,%00001000
	db	$00,$38,$2E,%00001000
	db	$00,$40,$2F,%00001000
.end
	
; ================================================================
    
section "Title screen + menu GFX",romx

Pal_TitleScreen:		incbin	"GFX/TitleScreen.pal"

TitleScreenTiles1:  	incbin  "GFX/TitleScreen_Block1.2bpp.wle"
TitleScreenTiles2:  	incbin  "GFX/TitleScreen_Block2.2bpp.wle"
TitleScreenMap:     	incbin  "GFX/TitleScreen.til.wle"
TitleScreenAttr:    	incbin  "GFX/TitleScreen.atr.wle"

Title_PressStartTiles:	incbin	"GFX/Sprites/PressStart.2bpp"	; storing this uncompressed because the WLE "packer" decided to inflate it by 3 bytes instead
.end
Pal_Title_PressStart:
	RGB	31, 0,31
	RGB	 0, 0, 0
	RGB 15,24,31
	RGB	31,31,31