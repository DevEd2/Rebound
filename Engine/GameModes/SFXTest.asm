section "SFX test RAM",wram0

section "SFX test routines",rom0
GM_SFXTest:
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

    ld      a,NUM_SFX-1
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
    
    call    SFXTest_DrawNames

SFXLoop:
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
:   call    SFXTest_DrawNames
    jr      .drawcursor
    
.checkdown
    bit     btnDown,a
    jr      z,.checkA
    ld      hl,Debug_MenuPos
    inc     [hl]
    ld      b,[hl]
    ld      a,[Debug_MenuMax]
    inc     a
    cp      b
    jr      nz,:+
    xor     a
    ld      [hl],a
:   call    SFXTest_DrawNames
    jr      .drawcursor

.checkA
    bit     btnA,a
    jr      z,.checkB
    ld      a,[Debug_MenuPos]
    ld      b,a
    call    SFX_GetSound
    inc     hl
    ld      a,[hl+]
    ld      b,a
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,b
    call    VGMSFX_Init
    jr      .drawcursor

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
    jp      SFXLoop

SFXTest_DrawNames:
    ld      hl,$9800
    ld      bc,$400
:   WaitForVRAM
    xor     a
    ld      [hl+],a
    dec     bc
    ld      a,b
    or      c
    jr      nz,:-

    ld      a,[Debug_MenuPos]
    and     $f0
    ld      b,16
    ld      de,$9822
.loadloop
    push    af
    push    bc
    push    de
    ld      b,a
    call    SFX_GetSound
    ld      a,[hl+]
    and     a
    jr      z,.exit
    inc     hl
    inc     hl
    inc     hl
    call    PrintString
    pop     de
    ld      a,e
    add     $20
    ld      e,a
    jr      nc,:+
    inc     d
:   pop     bc
    pop     af
    inc     a
    dec     b
    jr      nz,.loadloop
    ret
.exit
    pop     de
    pop     bc
    pop     af
    ret

; INPUT:    b = sound ID
; OUTPUT:  hl = pointer to SFX info (bank, pointer, name)
; DESTROYS: a, b
SFX_GetSound:
    ld      hl,SFXTest_Pointers
    xor     a
    cp      b
    ret     z
.getnext
    ld      a,[hl]
    add     l
    ld      l,a
    jr      nc,:+
    inc     h
:   dec     b
    ret     z
    jr      .getnext
