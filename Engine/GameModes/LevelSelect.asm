section "Level select RAM",wram0

NUM_LEVEL_SELECT_ENTRIES = 11

section "Level select routines",rom0
GM_LevelSelect:
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

    ld      a,NUM_LEVEL_SELECT_ENTRIES-1
    ld      [Debug_MenuMax],a
    xor     a
    ld      [Debug_MenuPos],a
    ld      [sys_PauseGame],a
    farcall DS_Stop

    ld      a,$18
    ld      [Debug_MenuOffset],a

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJON | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei
    
    call    LevelSelect_DrawNames

LevelSelectLoop:
    ld      a,[sys_btnPress]
    bit     btnUp,a
    jr      z,.checkdown
    ld      hl,Debug_MenuPos
    dec     [hl]
    ld      a,[hl]
    cp      $ff
    jr      nz,:+
    ld      a,[Debug_MenuMax]
    ld      [hl],a
:   call    LevelSelect_DrawNames
    jr      .drawcursor
    
.checkdown
    bit     btnDown,a
    jr      z,.checkLeft
    ld      hl,Debug_MenuPos
    inc     [hl]
    ld      b,[hl]
    ld      a,[Debug_MenuMax]
    inc     a
    cp      b
    jr      nz,:+
    xor     a
    ld      [hl],a
:   call    LevelSelect_DrawNames
    jr      .drawcursor

.checkLeft
    bit     btnLeft,a
    jr      z,.checkRight
    ld      a,[Debug_MenuPos]
    sub     16
    jr      nc,:+
    xor     a
:   ld      [Debug_MenuPos],a
    call    LevelSelect_DrawNames
    jr      .drawcursor

.checkRight
    bit     btnRight,a
    jr      z,.checkA
    ld      a,[Debug_MenuPos]
    add     16
    cp      NUM_LEVEL_SELECT_ENTRIES-1
    jr      c,:+
    ld      a,NUM_LEVEL_SELECT_ENTRIES-1
:   ld      [Debug_MenuPos],a
    call    LevelSelect_DrawNames
    jr      .drawcursor

.checkA
    bit     btnA,a
    jr      z,.checkB
    ; TODO
    halt
    xor     a
    ldh     [rLCDC],a
    ld      a,PLAYER_LIVES
    ld      [Player_LifeCount],a
    xor     a
    ld      [Player_CoinCount],a
    ld      [Player_CoinCount+1],a
    ld      [Player_CoinCountHUD],a
    ld      [Player_CoinCountHUD+1],a
    ld      a,[Debug_MenuPos]
    jp      GM_Level

.checkB
    bit     btnB,a
    jr      z,.drawcursor
    halt
    xor     a
    ldh     [rLCDC],a
    jp      GM_DebugMenu

.drawcursor
    call    Debug_DrawCursor
    halt
    jp      LevelSelectLoop

LevelSelect_DrawNames:
    ld      hl,$9800
    ld      bc,$400
:   WaitForVRAM
    xor     a
    ld      [hl+],a
    dec     bc
    ld      a,b
    or      c
    jr      nz,:-

    ld      b,bank(LevelSelect_LevelNames)
    call    _Bankswitch
    ld      a,[Debug_MenuPos]
    and     $f0 
    ld      b,16
    ld      de,$9822
:   push    af
    ld      hl,LevelSelect_LevelNames
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
    cp      NUM_LEVEL_SELECT_ENTRIES
    ret     z
    dec     b
    jr      nz,:---
    ret

section "Level names",romx
LevelSelect_LevelNames:
    dw       .0
    dw       .1, .2, .3, .4, .5, .6,; .7
    dw       .8, .9,.10,.11,.12,.13,.14
    dw      .15,.16,.17,.18,.19,.20,.21
    dw      .22,.23,.24,.25,.26,.27,.28
    dw      .29,.30,.31,.32,.33,.34,.35
    dw      .36,.37,.38,.39,.40,.41,.42
    
.0  db          "TEST MAP",0
.1  db          "PLAIN PLAINS 1",0
.2  db          "PLAIN PLAINS 2",0
.3  db          "PLAIN PLAINS 3",0
.4  db          "PLAIN PLAINS 4",0
.5  db          "PLAIN PLAINS 5",0
.6  db          "PLAIN PLAINS 6",0
;.7  db          "BOSS 1",0
.8  db          "FORLORN FOREST 1",0
.9  db          "FORLORN FOREST 2",0
.10 db          "FORLORN FOREST 3",0
.11 db          "FORLORN FOREST 4",0
.12 db          "FORLORN FOREST 5",0
.13 db          "FORLORN FOREST 6",0
.14 db          "BOSS 2",0
.15 db          "CENTRAL CITY 1",0
.16 db          "CENTRAL CITY 2",0
.17 db          "CENTRAL CITY 3",0
.18 db          "CENTRAL CITY 4",0
.19 db          "CENTRAL CITY 5",0
.20 db          "CENTRAL CITY 6",0
.21 db          "BOSS 3",0
.22 db          "PYRAMID POWER 1",0
.23 db          "PYRAMID POWER 2",0
.24 db          "PYRAMID POWER 3",0
.25 db          "PYRAMID POWER 4",0
.26 db          "PYRAMID POWER 5",0
.27 db          "PYRAMID POWER 6",0
.28 db          "BOSS 4",0
.29 db          "GREAT GROTTO 1",0
.30 db          "GREAT GROTTO 2",0
.31 db          "GREAT GROTTO 3",0
.32 db          "GREAT GROTTO 4",0
.33 db          "GREAT GROTTO 5",0
.34 db          "GREAT GROTTO 6",0
.35 db          "BOSS 5",0
.36 db          "TRAP TEMPLE 1",0
.37 db          "TRAP TEMPLE 2",0
.38 db          "TRAP TEMPLE 3",0
.39 db          "TRAP TEMPLE 4",0
.40 db          "TRAP TEMPLE 5",0
.41 db          "TRAP TEMPLE 6",0
.42 db          "FINAL BOSS",0
