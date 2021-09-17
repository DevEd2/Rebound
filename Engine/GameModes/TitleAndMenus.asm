section "Title screen + menu RAM",wram0

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
	
    ldfar   hl,TitleScreenTiles2
    ld      de,$8000
    call    DecodeWLE
	
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
    call    ConvertPals
    call    PalFadeInWhite
    call    UpdatePalettes

    xor     a   ; MUS_MENU
	ldh		[rVBK],a
    farcall DevSound_Init

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
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
    halt
    jr      TitleLoop
    
; ================================================================
    
section "Title screen + menu GFX",romx

Pal_TitleScreen:	incbin	"GFX/TitleScreen.pal"

TitleScreenTiles1:  incbin  "GFX/TitleScreen_Block1.2bpp.wle"
TitleScreenTiles2:  incbin  "GFX/TitleScreen_Block2.2bpp.wle"
TitleScreenMap:     incbin  "GFX/TitleScreen.til.wle"
TitleScreenAttr:    incbin  "GFX/TitleScreen.atr.wle"
