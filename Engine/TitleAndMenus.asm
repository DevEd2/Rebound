section "Title screen + menu RAM",wram0

; ================

section "Title screen + menu routines",rom0

GM_TitleAndMenus:
    ; we're already in VBlank, don't wait before disabling LCD
    ; LY = 149 on entry (may change)
    xor     a
    ldh     [rLCDC],a

    ldfar   hl,TitleScreenTiles
    ld      de,$8000
    call    DecodeWLE

    ld      hl,TitleScreenMap
    ld      de,sys_TilemapBuffer
    call    DecodeWLE

    ld      hl,sys_TilemapBuffer
    call    LoadTilemapScreen

    ldfar   hl,Pal_TitleScreen
    xor     a
    call    LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call    UpdatePalettes

    xor     a   ; MUS_MENU
    call    DevSound_Init

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
    jp      GM_Level

.skip
    halt
    jr      TitleLoop
    
; ================================================================
    
section "Title screen + menu GFX",romx

; too lazy to properly convert the palette :V
Pal_TitleScreen:
    RGB (255>>3),(255>>3),(255>>3)
    RGB (  0>>3),(116>>3),(224>>3)
    RGB ( 32>>3),( 69>>3),(108>>3)
    RGB (  0>>3),(  0>>3),(  0>>3)

TitleScreenTiles:   incbin  "GFX/TitleScreen.2bpp.wle"
TitleScreenMap:     incbin  "GFX/TitleScreen.til.wle"
