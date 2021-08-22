section "Level select RAM",wram0

NUM_LEVEL_SELECT_ENTRIES = 49

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

    ld      hl,Font
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
    dw      .0,.1,.2,.3,.4,.5,.6,.7,.8,.9
    dw      .10,.11,.12,.13,.14,.15,.16,.17,.18,.19
    dw      .20,.21,.22,.23,.24,.25,.26,.27,.28,.29
    dw      .30,.31,.32,.33,.34,.35,.36,.37,.38,.39
    dw      .40,.41,.42,.43,.44,.45,.46,.47,.48
    
.0  db          "TEST MAP",0
.1  db          "PLAIN PLAINS 1",0
.2  db          "PLAIN PLAINS 2",0
.3  db          "PLAIN PLAINS 3",0
.4  db          "PLAIN PLAINS 4",0
.5  db          "PLAIN PLAINS 5",0
.6  db          "PLAIN PLAINS 6",0
.7  db          "PLAIN PLAINS 7",0
.8  db          "BOSS 1",0
.9  db          "CENTRAL CITY 1",0
.10 db          "CENTRAL CITY 2",0
.11 db          "CENTRAL CITY 3",0
.12 db          "CENTRAL CITY 4",0
.13 db          "CENTRAL CITY 5",0
.14 db          "CENTRAL CITY 6",0
.15 db          "CENTRAL CITY 7",0
.16 db          "BOSS 2",0
.17 db          "FORLORN FOREST 1",0
.18 db          "FORLORN FOREST 2",0
.19 db          "FORLORN FOREST 3",0
.20 db          "FORLORN FOREST 4",0
.21 db          "FORLORN FOREST 5",0
.22 db          "FORLORN FOREST 6",0
.23 db          "FORLORN FOREST 7",0
.24 db          "BOSS 3",0
.25 db          "PYRAMID POWER 1",0
.26 db          "PYRAMID POWER 2",0
.27 db          "PYRAMID POWER 3",0
.28 db          "PYRAMID POWER 4",0
.29 db          "PYRAMID POWER 5",0
.30 db          "PYRAMID POWER 6",0
.31 db          "PYRAMID POWER 7",0
.32 db          "BOSS 4",0
.33 db          "GREAT GROTTO 1",0
.34 db          "GREAT GROTTO 2",0
.35 db          "GREAT GROTTO 3",0
.36 db          "GREAT GROTTO 4",0
.37 db          "GREAT GROTTO 5",0
.38 db          "GREAT GROTTO 6",0
.39 db          "GREAT GROTTO 7",0
.40 db          "BOSS 5",0
.41 db          "TRAP TEMPLE 1",0
.42 db          "TRAP TEMPLE 2",0
.43 db          "TRAP TEMPLE 3",0
.44 db          "TRAP TEMPLE 4",0
.45 db          "TRAP TEMPLE 5",0
.46 db          "TRAP TEMPLE 6",0
.47 db          "TRAP TEMPLE 7",0
.NUM_LEVEL_SELECT_ENTRIES db          "FINAL BOSS",0
