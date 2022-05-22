section "Tileset editor RAM",wram0

TileEdit_PaletteBank:       db
TileEdit_PalettePointer:    dw

section "Tileset editor routines",rom0

GM_TileEdit:
    xor     a
    ld      [TileEdit_PaletteBank],a

TileEdit_MainMenu:
;    call    ClearScreen

    ldfar   hl,Pal_DebugScreen
    xor     a
    call    LoadPal
    ld      a,8
    ld      hl,Pal_DebugScreen
    call    LoadPal
    call    CopyPalettes

;    ldfar   hl,Font
;    ld      de,$8000
;    call    DecodeWLE

    ld      a,4
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
    
    call    TileEdit_DrawMainMenu

TileEdit_MainMenuLoop:
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
:   call    TileEdit_DrawMainMenu
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
:   call    TileEdit_DrawMainMenu
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
    call    TileEdit_DrawMainMenu
    jp      .drawcursor

.checkRight
    bit     btnRight,a
    jr      z,.checkB
    PlaySFX menucursor
    ld      a,[Debug_MenuPos]
    add     16
    cp      3
    jr      c,:+
    ld      a,[Debug_MenuMax]
:   ld      [Debug_MenuPos],a
    call    TileEdit_DrawMainMenu
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
    ld      hl,.gotolist
    ld      a,[Debug_MenuPos]
    ld      b,a
    ld      a,[Debug_MenuMax]
    cp      b
    jr      c,.going_nowhere
    ld      e,b
    ld      d,0
    add     hl,de
    add     hl,de
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jp      hl
    
.gotolist
    dw      .goto_gfxmenu
    dw      .goto_load
    dw      .goto_save
    dw      .goto_editor
    dw      .goto_debugmenu
.goto_gfxmenu:
    halt
    xor     a
    ldh     [rLCDC],a
    jp      TileEdit_GFXMenu
.goto_debugmenu
    halt
    xor     a
    ldh     [rLCDC],a
    jp      GM_DebugMenu
.goto_editor
    ld      a,[TileEdit_PaletteBank]
    and     a
    jr      z,.cant_goto_editor
    halt
    xor     a
    ldh     [rLCDC],a
    jp      TileEdit_Editor
.cant_goto_editor
    ld      hl,str_NoTileset
    call    TileEdit_PrintString
    ; fall through to going_nowhere

.goto_load
    ; TODO
.goto_save
    ; TODO
.going_nowhere
    PlaySFX menudeny

.drawcursor
    call    Debug_DrawCursor
    halt
    jp      TileEdit_MainMenuLoop

TileEdit_DrawMainMenu:
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

    ld      b,bank(TileEdit_MainMenuText)
    rst     Bankswitch
    ld      a,[Debug_MenuPos]
    and     $f0 
    ld      b,16
    ld      de,$9822
:   push    af
    ld      hl,TileEdit_MainMenuText
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
    cp      5
    ret     z
    dec     b
    jr      nz,:---
    ret

; ================================================================    

TileEdit_GFXMenu:
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
    
    call    TileEdit_DrawGFXMenu

TileEdit_GFXMenuLoop:
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
:   call    TileEdit_DrawGFXMenu
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
:   call    TileEdit_DrawGFXMenu
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
    call    TileEdit_DrawGFXMenu
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
    call    TileEdit_DrawGFXMenu
    jr      .drawcursor

.checkB
    bit     btnB,a
    jr      z,.checkA
    PlaySFX menuback
    halt
    xor     a
    ldh     [rLCDC],a
    jp      TileEdit_MainMenu

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
    jp      TileEdit_MainMenu
:
    halt
    xor     a
    ldh     [rLCDC],a
    ld      a,1
    ldh     [rVBK],a
    
    ld      hl,TileEdit_GFXPointers
    ld      a,[Debug_MenuPos]
    ld      e,a
    ld      d,0
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    add     hl,de
    ld      a,[hl+]
    ld      b,a
    call    _Bankswitch
    ld      a,[hl+]
    push    hl
    ld      h,[hl]
    ld      l,a
    ld      de,$8000
    call    DecodeWLE
    pop     hl
    inc     hl
    ld      a,[hl+]
    ld      [TileEdit_PaletteBank],a
    ld      a,[hl+]
    ld      h,[hl]
    ld      [TileEdit_PalettePointer],a
    ld      a,h
    ld      [TileEdit_PalettePointer+1],a
    
    xor     a
    ldh     [rVBK],a
    
    jp      TileEdit_MainMenu

.drawcursor
    call    Debug_DrawCursor
    halt
    jp      TileEdit_GFXMenuLoop

TileEdit_DrawGFXMenu:
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

    ld      b,bank(TileEdit_GFXMenuText)
    call    _Bankswitch
    ld      a,[Debug_MenuPos]
    and     $f0 
    ld      b,16
    ld      de,$9822
:   push    af
    ld      hl,TileEdit_GFXMenuText
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

TileEdit_Editor:
    call    ClearScreen2
    ld      a,[TileEdit_PaletteBank]
    ld      b,a
    rst     Bankswitch
    ld      hl,TileEdit_PalettePointer
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

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJON | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei
    
TileEdit_EditorLoop:
    ld      a,[sys_CurrentFrame]
    ld      b,$40
    call    TileEdit_DrawHex4x8
    WaitForVRAM
    ld      a,$40
    ld      [_SCRN0],a
    
    
    ld      a,[sys_btnPress]
    bit     btnB,a
    jr      z,:+
    halt
    xor     a
    ldh     [rLCDC],a
    call    ClearScreen2
    jp      TileEdit_MainMenu

:   halt
    jr      TileEdit_EditorLoop

; ================================================================

TileEdit_PrintString:
    ld      b,bank(TileEdit_Strings)
    rst     Bankswitch
    ld      de,$9a20
:   ld      a,[hl+]
    and     a
    ret     z
    sub     " "
    ld      b,a
    WaitForVRAM
    ld      a,b
    ld      [de],a
    inc     de
    jr      :-
    ret

; A = number to draw
; B = tile ID

TileEdit_DrawHex4x8:

    push    bc
    ld      b,bank(HexFont4x8)
    rst     Bankswitch 
    pop     bc
    
    push    af
    push    bc
    and     $f0
    swap    a
    ld      l,a
    ld      h,0
    add     hl,hl   ; x2
    add     hl,hl   ; x4
    add     hl,hl   ; x8
    ld      de,HexFont4x8
    add     hl,de
    ld      d,h
    ld      e,l
    
    ; get tile address
    pop     af  ; A = old B (destroys flags but they aren't needed)
    ld      c,a
    and     $f0
    swap    a
    or      $80
    ld      h,a
    ld      a,c
    and     $f
    swap    a
    ld      l,a
    push    hl
    
    ld      b,8
:   ld      a,[de]
    ld      c,a
    WaitForVRAM
    ld      [hl],c
    inc     l
    WaitForVRAM
    ld      [hl],c
    inc     l
    inc     de
    dec     b
    jr      nz,:-
    
    pop     hl
    pop     af
    
    push    hl
    and     $0f
    ld      l,a
    ld      h,0
    add     hl,hl   ; x2
    add     hl,hl   ; x4
    add     hl,hl   ; x8
    ld      de,HexFont4x8
    add     hl,de
    ld      d,h
    ld      e,l
    pop     hl

    ld      b,8
:   ld      a,[de]
    swap    a
    push    af
    WaitForVRAM
    pop     af
    or      [hl]
    ld      [hl+],a
    ld      a,[de]
    swap    a
    push    af
    WaitForVRAM
    pop     af
    or      [hl]
    ld      [hl+],a
    inc     de
    dec     b
    jr      nz,:-
 
    ret

; ================================================================

TileEdit_GFXPointers:
    dwb2    TestMapTiles,Pal_TestMap
    dwb2    PlainsTiles,Pal_Plains
    dwb2    ForestTiles,Pal_Forest
    dwb2    TestMapTiles,Pal_TestMap
    dwb2    TestMapTiles,Pal_TestMap
    dwb2    TestMapTiles,Pal_TestMap
    dwb2    TestMapTiles,Pal_TestMap

; ================================================================

section "Tile editor - Main menu text",romx
TileEdit_MainMenuText:
    dw  .loadgfx
    dw  .loadtileset
    dw  .save
    dw  .starteditor
    dw  .exit

.loadgfx        db  "LOAD GRAPHICS SET",0
.loadtileset    db  "LOAD TILESET",0
.save           db  "SAVE TILESET",0
.starteditor    db  "START EDITOR",0
.exit           db  "EXIT",0

; ================================================================

section "Tile editor - Graphics set selector text",romx
TileEdit_GFXMenuText:
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

; ================================================================

section "Tile editor - Editor text",romx
TileEdit_Strings:
str_TileID:     db  "TILE ID",0
str_Palette:    db  "PALETTE",0
str_FlipX:      db  "HORIZ. FLIP",0
str_FlipY:      db  "VERT. FLIP",0
str_Priority:   db  "PRIORITY",0
str_Saved:      db  "TILESET SAVED",0
str_Loaded:     db  "TILESET LOADED",0
str_SaveError:  db  "COULD NOT SAVE!",0
str_LoadError:  db  "COULD NOT LOAD!",0
str_NoTileset:  db  "LOAD TILESET FIRST!",0

; ================================================================

section "Tile editor - 4x8 hex font",romx

HexFont4x8:     incbin  "GFX/HexFont4.1bpp"
