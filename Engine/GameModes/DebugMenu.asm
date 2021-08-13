section "Debug menu RAM",wram0
Debug_MenuPos:      db
Debug_MenuMax:      db
Debug_MenuOffset:   db

section "Debug menu routines",rom0
GM_DebugMenu:
    call    ClearScreen

    ldfar   hl,Pal_DebugScreen
    xor     a
    call    LoadPal
    ld      a,8
    ld      hl,Pal_DebugScreen
    call    LoadPal
    call    CopyPalettes

    ld      hl,Font
    ld      de,$8000
    call    DecodeWLE
    ld      hl,Debug_MainMenuText
    call    LoadTilemapText

    ld      a,3
    ld      [Debug_MenuMax],a
    xor     a
    ld      [Debug_MenuPos],a
    ld      [sys_PauseGame],a
    farcall DS_Stop

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJON | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei
    
    ld      a,48
    ld      [Debug_MenuOffset],a

DebugLoop:
    xor     a
    ldh     [rSCX],a
    ldh     [rSCY],a

    ld      a,[sys_btnPress]
    bit     btnUp,a
    jr      z,.checkdown
    PlaySFX menucursor
    ld      hl,Debug_MenuPos
    dec     [hl]
    ld      a,[hl]
    cp      $ff
    jr      nz,.drawcursor
    ld      a,[Debug_MenuMax]
    ld      [hl],a
    jr      .drawcursor

.checkdown
    bit     btnDown,a
    jr      z,.checkA
    PlaySFX menucursor
    ld      hl,Debug_MenuPos
    inc     [hl]
    ld      b,[hl]
    ld      a,[Debug_MenuMax]
    inc     a
    cp      b
    jr      nz,.drawcursor
    xor     a
    ld      [hl],a
    jr      .drawcursor

.checkA
    bit     btnA,a
    jr      z,.drawcursor
    ld      hl,.menuitems
    ld      a,[Debug_MenuPos]
    add     a
    add     l
    ld      l,a
    jr      nc,:+
    inc     h
:   ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    bit     7,h ; is pointer in WRAM? (invalid)
    jr      nz,Debug_InvalidMenu
    jp      hl
        
.menuitems
    dw      Debug_ExitToGame
    dw      Debug_ExitToLevelSelect
    dw      Debug_ExitToSoundTest
    dw      Debug_ExitToSFXTest

.drawcursor
    call    Debug_DrawCursor

    halt
    jr      DebugLoop
    
Debug_DrawCursor:
    ; draw cursor
    ld      hl,OAMBuffer
    ; y pos
    ld      a,[Debug_MenuPos]
    and     $f
    add     a   ; x2
    add     a   ; x4
    add     a   ; x8
    ld      b,a
    ld      a,[Debug_MenuOffset]
    add     b
    and     $f8
    ld      [hl+],a
    ; x pos
    ld      a,16
    ld      [hl+],a
    ; tile
    ld      a,">"-32
    ld      [hl+],a
    ; attributes
    xor     a
    ld      [hl],a
    ret

Debug_ExitToGame:
    halt
    jp      GM_SplashScreens
    
Debug_ExitToLevelSelect:
    ; TODO: Actual level select menu
    halt
    xor     a
    ldh     [rLCDC],a
    
    ld      a,PLAYER_LIVES
    ld      [Player_LifeCount],a
    ld      a,MapID_TestMap
    jp      GM_Level
    
Debug_ExitToSoundTest:
    halt
    jp      GM_SoundTest

Debug_ExitToSFXTest:
    halt
    xor     a
    ldh     [rLCDC],a
    jp      GM_SFXTest

Debug_InvalidMenu:
    PlaySFX menudeny
    jp      DebugLoop.drawcursor

Debug_MainMenuText:
    db  "                    "
    db  "   - REBOUND GB -   "
    db  "     DEBUG MENU     "
    db  "                    "
    db  "   START GAME       "
    db  "   LEVEL SELECT     "
    db  "   SOUND TEST       "
    db  "   SFX TEST         "
    db  "                    "
    db  "                    "
    db  "                    "
    db  "                    "
    db  "                    "
    db  "                    "
    db  " BUILD DATE:        "
    db  " "
    dbp strupr(__DATE__),19," "
    db  " "
    dbp strupr(__TIME__),19," "
    db  "                    "
