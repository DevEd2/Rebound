section "Tileset Viewer RAM",wram0

MetatileViewer_PaletteBank:       db
MetatileViewer_PalettePointer:    dw

section "Tileset Viewer routines",rom0

GM_MetatileViewer:
    xor     a
    ld      [MetatileViewer_PaletteBank],a


MetatileViewer_GFXMenu:
    call    ClearScreen

    ldfar   hl,Pal_DebugScreen
    xor     a
    call    LoadPal
    ld      a,8
    ld      hl,Pal_DebugScreen
    call    LoadPal
    call    CopyPalettes

    ldfar   hl,Font
    ld      de,$8000
    call    DecodeWLE
    
    ld      a,7
    ld      [Debug_MenuMax],a
    xor     a
    ld      [Debug_MenuPos],a
    ld      [sys_PauseGame],a

    ld      a,$18
    ld      [Debug_MenuOffset],a

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJON | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei
    
    call    MetatileViewer_DrawGFXMenu

MetatileViewer_GFXMenuLoop:
    ld      a,[sys_btnPress]
    bit     btnUp,a
    jr      z,.checkdown
    PlaySFX menucursor
    ld      hl,Debug_MenuPos
    dec     [hl]
    ld      a,[hl]
    cp      $ff
    jr      nz,:+
    ld      a,[Debug_MenuMax]
    ld      [hl],a
:   call    MetatileViewer_DrawGFXMenu
    jp      .drawcursor
    
.checkdown
    bit     btnDown,a
    jr      z,.checkLeft
    PlaySFX menucursor
    ld      hl,Debug_MenuPos
    inc     [hl]
    ld      b,[hl]
    ld      a,[Debug_MenuMax]
    inc     a
    cp      b
    jr      nz,:+
    xor     a
    ld      [hl],a
:   call    MetatileViewer_DrawGFXMenu
    jp      .drawcursor

.checkLeft
    bit     btnLeft,a
    jr      z,.checkRight
    PlaySFX menucursor
    ld      a,[Debug_MenuPos]
    sub     16
    jr      nc,:+
    xor     a
:   ld      [Debug_MenuPos],a
    call    MetatileViewer_DrawGFXMenu
    jp      .drawcursor

.checkRight
    bit     btnRight,a
    jr      z,.checkB
    PlaySFX menucursor
    ld      a,[Debug_MenuPos]
    add     16
    cp      7
    jr      c,:+
    ld      a,7
:   ld      [Debug_MenuPos],a
    call    MetatileViewer_DrawGFXMenu
    jr      .drawcursor

.checkB
    bit     btnB,a
    jr      z,.checkA
    PlaySFX menuback
    halt
    xor     a
    ldh     [rLCDC],a
    jp      GM_DebugMenu

.checkA
    bit     btnA,a
    jr      z,.drawcursor
    PlaySFX menuselect
    ld      a,[Debug_MenuPos]
    ld      b,a
    ld      a,[Debug_MenuMax]
    cp      b
    jr      nz,:+
    halt
    xor     a
    ldh     [rLCDC],a
    jp      GM_DebugMenu
:
    halt
    xor     a
    ldh     [rLCDC],a
    
    ld      hl,MetatileViewer_GFXPointers
    ld      a,[Debug_MenuPos]
    ld      e,a
    ld      d,0
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    ld      a,[hl+]
    ld      b,a
    rst     Bankswitch
    ld      a,[hl+]
    push    hl
    ld      h,[hl]
    ld      l,a
    ld      de,$8000
    call    DecodeWLE
    pop     hl
    inc     hl
    ld      a,[hl+]
    ld      [MetatileViewer_PaletteBank],a
    ld      a,[hl+]
    push    hl
    ld      [MetatileViewer_PalettePointer],a
    ld      a,[hl]
    ld      [MetatileViewer_PalettePointer+1],a
    pop     hl
    inc     hl
    ld      a,[hl+]
    ld      [Engine_TilesetBank],a
    ld      a,[hl+]
    ld      [Engine_TilesetPointer],a
    ld      a,[hl]
    ld      [Engine_TilesetPointer+1],a

    jp      MetatileViewer_Viewer

.drawcursor
    call    Debug_DrawCursor
    halt
    jp      MetatileViewer_GFXMenuLoop

MetatileViewer_DrawGFXMenu:
    ld      hl,$9800
    ld      bc,$400
:   xor     a
    push    af
    WaitForVRAM
    pop     af
    ld      [hl+],a
    dec     bc
    ld      a,b
    or      c
    jr      nz,:-

    ld      b,bank(MetatileViewer_GFXMenuText)
    call    _Bankswitch
    ld      a,[Debug_MenuPos]
    and     $f0 
    ld      b,16
    ld      de,$9822
:   push    af
    ld      hl,MetatileViewer_GFXMenuText
    add     a
    add     l
    ld      l,a
    jr      nc,:+
    inc     h
:   ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    push    de
    call    PrintString
    pop     de
    ld      a,e
    add     32
    ld      e,a
    jr      nc,:+
    inc     d
:   pop     af
    inc     a
    cp      8
    ret     z
    dec     b
    jr      nz,:---
    ret

; ================================================================

MetatileViewer_Viewer:
    call    ClearScreen2
    ld      a,[MetatileViewer_PaletteBank]
    ld      b,a
    rst     Bankswitch
    ld      hl,MetatileViewer_PalettePointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a

    ld      b,8
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
    
    xor     a
:   ld      b,a
    call    DrawMetatile
    inc     a
    jr      nz,:-

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJON | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei
    
    xor     a
    ld      [Engine_CameraX],a
    ld      [Engine_CameraY],a
    
MetatileViewer_ViewerLoop:
    ld      a,[sys_btnHold]
    ld      hl,Engine_CameraY
    bit     btnUp,a
    call    nz,.up
    bit     btnDown,a
    call    nz,.down
    ld      hl,Engine_CameraX
    bit     btnLeft,a
    call    nz,.left
    bit     btnRight,a
    call    nz,.right

    ld      a,[sys_btnPress]
    bit     btnB,a
    jr      z,:+
    halt
    xor     a
    ldh     [rLCDC],a
    call    ClearScreen2
    jp      MetatileViewer_GFXMenu

:   halt
    jr      MetatileViewer_ViewerLoop

.up
.left
    push    af
    ld      a,[hl]
    and     a
    jr      z,:+
    dec     [hl]
:   pop     af
    ret
.down
    push    af
    ld      a,[hl]
    cp      256-SCRN_Y
    jr      z,:+
    inc     [hl]
:   pop     af
    ret
.right
    push    af
    ld      a,[hl]
    cp      256-SCRN_X
    jr      z,:+
    inc     [hl]
:   pop     af
    ret

; ================================================================

MetatileViewer_GFXPointers:
    dwb3    TestMapTiles,Pal_TestMap,Tileset_Test
    dwb3    PlainsTiles,Pal_Plains,Tileset_Plains
    dwb3    ForestTiles,Pal_Forest,Tileset_Forest
    dwb3    TestMapTiles,Pal_TestMap,Tileset_Test
    dwb3    TestMapTiles,Pal_TestMap,Tileset_Test
    dwb3    TestMapTiles,Pal_TestMap,Tileset_Test
    dwb3    TestMapTiles,Pal_TestMap,Tileset_Test

; ================================================================

section "Tile Viewer - Graphics set selector text",romx
MetatileViewer_GFXMenuText:
    dw  .testmap
    dw  .plains
    dw  .forest
    dw  .city
    dw  .pyramid
    dw  .cave
    dw  .temple
    dw  .cancel

.testmap        db  "TEST MAP",0
.plains         db  "PLAINS",0
.forest         db  "FOREST",0
.city           db  "CITY (NYI)",0
.pyramid        db  "PYRAMID (NYI)",0
.cave           db  "CAVE (NYI)",0
.temple         db  "TEMPLE (NYI)",0
.cancel         db  "CANCEL",0
