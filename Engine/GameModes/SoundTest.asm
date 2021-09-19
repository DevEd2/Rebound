section "Sound test RAM",wram0

SoundTest_SongID:           db
SoundTest_MarqueeScroll:    db
SoundTest_MarqueePos:       db
SoundTest_DoFade:           db

SoundTest_CH1Vol:           db
SoundTest_CH2Vol:           db
SoundTest_CH3Vol:           db
SoundTest_CH4Vol:           db
SoundTest_CH1DecayTime:     db
SoundTest_CH2DecayTime:     db
SoundTest_CH4DecayTime:     db

; ================

section "Sound test routines",rom0

GM_SoundTest:
    ; we're already in VBlank, don't wait before disabling LCD
    ; LY = 149 on entry (may change)
    xor     a
    ldh     [rLCDC],a

    ldfar   hl,SoundTestTiles
    ld      de,$8000
    ld      bc,SoundTestTiles.end-SoundTestTiles
    call    _CopyRAM

    ; load bottom half of font
    ld      a,1
    ldh     [rVBK],a
    ld      hl,SoundTestFontBottom
    ld      de,$8000 + (" " * 16)
    push    de
    call    DecodeWLE
    ; load top half of font
    xor     a
    ldh     [rVBK],a
    ld      hl,SoundTestFontTop
    pop     de
    call    DecodeWLE

    ld      hl,SoundTestMap
    ld      de,sys_TilemapBuffer
    ld      bc,SoundTestMap.end-SoundTestMap
    call    _CopyRAM

    ld      hl,sys_TilemapBuffer
    call    LoadTilemapScreen

    ld      a,1
    ldh     [rVBK],a
    ld      hl,SoundTest_AttributeMap
    ld      de,$9800
    ld      bc,SoundTest_AttributeMap.end-SoundTest_AttributeMap
    call    _CopyRAM

    ld      hl,Pal_SoundTest
    ld      a,0
    call    LoadPal
    ld      a,1
    call    LoadPal
    ld      a,2
    call    LoadPal
    ld      a,3
    call    LoadPal
    ld      a,8
    call    LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call    UpdatePalettes

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK | IEF_LCDC
    ldh     [rIE],a
    ld      a,SCRN_Y-16
    ldh     [rLYC],a
    ld      a,STATF_LYC
    ldh     [rSTAT],a
    ei

    xor     a
    ld      [SoundTest_MarqueeScroll],a
    ld      [SoundTest_MarqueePos],a
    ld      [SoundTest_SongID],a
    ld      [SoundTest_CH1Vol],a
    ld      [SoundTest_CH2Vol],a
    ld      [SoundTest_CH4Vol],a
    ld      [SoundTest_CH1DecayTime],a
    ld      [SoundTest_CH2DecayTime],a
    ld      [SoundTest_CH4DecayTime],a
    push    af
    farcall DS_Init
    pop     af
    call    SoundTest_DrawSongName

SoundTestLoop:
    
    ld      hl,sys_TilemapBuffer+103
    ld      de,$98a3
    ld      b,8
    ld      c,$14
:
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    inc     de
    dec     c
    jr      nz,:-
    ld      c,$14
    ld      a,e
    add     $C
    jr      nc,:+
    inc     d
:
    ld      e,a
    dec     b
    jr      nz,:--

    ld      a,[sys_btnPress]
    bit     btnB,a
    jp      nz,.exit
    ld      e,a
    ld      a,[SoundTest_MarqueeScroll]
    and     a
    jr      nz,.continue
    ld      a,e
    bit     btnLeft,a
    jr      nz,.prevsong
    bit     btnRight,a
    jr      nz,.nextsong
    jr      .continue
.prevsong
    ld      a,1
    ld      [SoundTest_DoFade],a
    inc     a
    farcall DS_Fade
    ld      a,%10000001
    ld      [SoundTest_MarqueeScroll],a
    ld      a,[SoundTest_SongID]
    dec     a
    ld      [SoundTest_SongID],a
    cp      $ff
    jr      nz,.continue
    ld      a,NUM_SONGS-1
    ld      [SoundTest_SongID],a
    jr      .continue
.nextsong
    ld      a,1
    ld      [SoundTest_DoFade],a
    inc     a
    farcall DS_Fade
    ld      a,%00000001
    ld      [SoundTest_MarqueeScroll],a
    ld      a,[SoundTest_SongID]
    inc     a
    ld      [SoundTest_SongID],a
    cp      NUM_SONGS
    jr      c,.continue
    xor     a
    ld      [SoundTest_SongID],a
    jr      .continue
    
.exit
    farcall DS_Stop
    halt
    xor     a
    ldh     [rLCDC],a
    call    ClearScreen
    jp      GM_DebugMenu

.continue
    ; update visualizer vars
    ; ch1
    ld      a,[DS_CH1Retrig]
    and     a
    jr      z,:+
    ld      a,[DS_CH1Vol]
    and     $f0
    swap    a
    ld      [SoundTest_CH1Vol],a
    ld      a,[DS_CH1Vol]
    and     $f
    ld      [SoundTest_CH1DecayTime],a
    jr      :+++
:   ld      a,[SoundTest_CH1DecayTime]
    dec     a
    ld      [SoundTest_CH1DecayTime],a
    jr      nz,:++
    ld      a,[DS_CH1Vol]
    and     $f
    ld      [SoundTest_CH1DecayTime],a
    ld      a,[SoundTest_CH1Vol]
    sub     1   ; dec a doesn't set carry
    jr      nc,:+
    xor     a
:   ld      [SoundTest_CH1Vol],a
:
    ; ch2
    ld      a,[DS_CH2Retrig]
    and     a
    jr      z,:+
    ld      a,[DS_CH2Vol]
    and     $f0
    swap    a
    ld      [SoundTest_CH2Vol],a
    ld      a,[DS_CH2Vol]
    and     $f
    ld      [SoundTest_CH2DecayTime],a
    jr      :+++
:   ld      a,[SoundTest_CH2DecayTime]
    dec     a
    ld      [SoundTest_CH2DecayTime],a
    jr      nz,:++
    ld      a,[DS_CH2Vol]
    and     $f
    ld      [SoundTest_CH2DecayTime],a
    ld      a,[SoundTest_CH2Vol]
    sub     1   ; dec a doesn't set carry
    jr      nc,:+
    xor     a
:   ld      [SoundTest_CH2Vol],a
:
    ; ch3 (TODO)
    ld      a,[DS_CH3Vol]
    and     a
    jr      z,.setvol3
    cp      $20
    jr      nz,:+
    ld      a,$f
    jr      .setvol3
:   cp      $40
    jr      nz,:+
    ld      a,$8
    jr      .setvol3
:   cp      $60
    jr      nz,:+
    ld      a,$4
    ; fall through
.setvol3
    ld      [SoundTest_CH3Vol],a
:   ; ch4
    ld      a,[DS_CH4Retrig]
    and     a
    jr      z,:+
    ld      a,[DS_CH4Vol]
    and     $f0
    swap    a
    ld      [SoundTest_CH4Vol],a
    ld      a,[DS_CH4Vol]
    and     $f
    ld      [SoundTest_CH4DecayTime],a
    jr      :+++
:   ld      a,[SoundTest_CH4DecayTime]
    dec     a
    ld      [SoundTest_CH4DecayTime],a
    jr      nz,:++
    ld      a,[DS_CH4Vol]
    and     $f
    ld      [SoundTest_CH4DecayTime],a
    ld      a,[SoundTest_CH4Vol]
    sub     1   ; dec a doesn't set carry
    jr      nc,:+
    xor     a
:   ld      [SoundTest_CH4Vol],a
:
    
    ; update cursor
    ld      hl,OAMBuffer
    ; left cursor Y pos
    ld      a,144
    ld      [hl+],a
    ; left cursor X pos
    ld      a,[sys_CurrentFrame]
    and     $1f
    ld      de,SoundTest_CursorOscillationTable
    add     e
    ld      e,a
    jr      nc,.nocarry
    inc     d
.nocarry
    ld      a,[de]
    add     8
    ld      [hl+],a
    ; left cursor tile
    ld      a,4
    ld      [hl+],a
    ; left cursor attributes
    xor     a
    ld      [hl+],a

    ; right cursor Y pos
    ld      a,144
    ld      [hl+],a
    ; right cursor X pos
    ld      a,[de]
    cpl
    add     162
    ld      [hl+],a
    ; right cursor tile
    ld      a,6
    ld      [hl+],a
    ; left cursor attributes
    xor     a
    ld      [hl+],a
    
    tmcoord 3,5
    ld      b,160
    xor     a
    call    _FillRAMSmall

    ; CH1 volume meter
.v1
    ld      a,[SoundTest_CH1Vol]
    inc     a
    ld      c,a
    tmcoord 3,12
    ld      b,16
.v1a
    ld      a,8
    ld      [hl+],a
    ld      [hl-],a
    dec     c
    jr      z,:+
    dec     b
    jr      z,:+
.v1b
    ld      a,9
    ld      [hl+],a
    ld      [hl-],a
    ld      a,l
    sub     20
    ld      l,a
    dec     c
    jr      z,:+
    dec     b
    jr      nz,.v1a
:   ; CH2 volume meter
.v2
    ld      a,[SoundTest_CH2Vol]
    inc     a
    ld      c,a
    tmcoord 7,12
    ld      b,16
.v2a
    ld      a,8
    ld      [hl+],a
    ld      [hl-],a
    dec     c
    jr      z,:+
    dec     b
    jr      z,:+
.v2b
    ld      a,9
    ld      [hl+],a
    ld      [hl-],a
    ld      a,l
    sub     20
    ld      l,a
    dec     c
    jr      z,:+
    dec     b
    jr      nz,.v2a
:   ; CH3 volume meter
.v3
    ld      a,[SoundTest_CH3Vol]
    inc     a
    ld      c,a
    tmcoord 11,12
    ld      b,16
.v3a
    ld      a,8
    ld      [hl+],a
    ld      [hl-],a
    dec     c
    jr      z,:+
    dec     b
    jr      z,:+
.v3b
    ld      a,9
    ld      [hl+],a
    ld      [hl-],a
    ld      a,l
    sub     20
    ld      l,a
    dec     c
    jr      z,:+
    dec     b
    jr      nz,.v3a
:    ; CH4 volume meter
.v4
    ld      a,[SoundTest_CH4Vol]
    inc     a
    ld      c,a
    tmcoord 15,12
    ld      b,16
.v4a
    ld      a,8
    ld      [hl+],a
    ld      [hl-],a
    dec     c
    jr      z,:+
    dec     b
    jr      z,:+
.v4b
    ld      a,9
    ld      [hl+],a
    ld      [hl-],a
    ld      a,l
    sub     20
    ld      l,a
    dec     c
    jr      z,:+
    dec     b
    jr      nz,.v4a
:
.wait
    rst     WaitLCDC
    call    SoundTest_RunMarquee
    
:   rst     WaitVBlank
    xor     a
    ldh     [rSCX],a    
    jp      SoundTestLoop

SoundTest_CursorOscillationTable:
    db       0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0
    db       0, 0, 0, 0,-1,-1,-1,-1,-1,-1,-1,-1, 0, 0, 0, 0

; ================

; a = song ID
; b = offset
SoundTest_DrawSongNameChar:
    ld      de,SoundTest_SongNames
    ld      l,a
    ld      h,0
    add     hl,hl   ; x2
    add     hl,hl   ; x4
    add     hl,hl   ; x8
    add     hl,hl   ; x16
    add     hl,hl   ; x32
    add     hl,de
    ld      a,l
    add     b
    ld      l,a
    jr      nc,:+
    inc     h
:   ld      d,$9a
    ld      e,b
    xor     a
    ldh     [rVBK],a

    WaitForVRAM
    ld      a,[hl]
    ld      [de],a
    ld      a,e
    add     32
    ld      e,a
    WaitForVRAM
    ld      a,[hl]
    ld      [de],a
    ret

; a = song ID
SoundTest_DrawSongName:
    ld      de,$9a00
    ld      hl,SoundTest_SongNames
    add     a   ; x2
    add     a   ; x4
    add     a   ; x8
    add     a   ; x16
    add     a   ; x32
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    push    hl
    xor     a
    ldh     [rVBK],a
    ld      b,32
.loop1
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    inc     e
    dec     b
    jr      nz,.loop1
    pop     hl
    ld      b,32
.loop2
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    inc     e
    dec     b
    jr      nz,.loop2
    ret

SoundTest_RunMarquee:
    ; run marquee
    ld      a,[SoundTest_MarqueeScroll]
    and     a
    ret     z
    bit     7,a
    jr      nz,.reverse
.forward
    ld      b,bank(SoundTest_MarqueeScrollTable)
    call    _Bankswitch
    ld      a,[SoundTest_MarqueePos]
    add     2
    bit     7,a
    jr      z,.noreset
    xor     a
    ld      [SoundTest_MarqueePos],a
    ld      [SoundTest_MarqueeScroll],a
    ; play new song
    ld      a,[SoundTest_SongID]
    farcall DS_Init
    ret
.noreset
    ld      [SoundTest_MarqueePos],a
    ld      e,a
    ld      h,high(SoundTest_MarqueeScrollTable)
    ld      l,e
    ld      a,[hl]
    ldh     [rSCX],a
    ; update marquee string
    sub     8
    rra     ; /2
    rra     ; /4
    rra     ; /8
    and     $1f
    ld      b,a
    ld      a,[SoundTest_SongID]
    jp      SoundTest_DrawSongNameChar

.reverse
    ld      b,bank(SoundTest_MarqueeScrollTable)
    call    _Bankswitch
    ld      a,[SoundTest_MarqueePos]
    sub     2
    res     7,a
    and     a
    jr      nz,.noreset2
    xor     a
    ld      [SoundTest_MarqueePos],a
    ld      [SoundTest_MarqueeScroll],a
    ; play new song
    ld      a,[SoundTest_SongID]
    farcall DS_Init
    ret
.noreset2
    ld      [SoundTest_MarqueePos],a
    ld      e,a
    ld      h,high(SoundTest_MarqueeScrollTable)
    ld      l,e
    ld      a,[hl]
    ldh     [rSCX],a
    ; update marquee string
    inc     a
    rra     ; /2
    rra     ; /4
    rra     ; /8
    and     $1f
    ld      b,a
    ld      a,[SoundTest_SongID]
    jp      SoundTest_DrawSongNameChar

SoundTest_SongNames:
;        -##################-------------
    db  "     Main Theme                 "
    db  " Humble  Beginnings             "
    db  "   Rock the Block               "
    db  "   Mystic  Medley               "
    db  "    Pyramid Jams                "
    db  "   Cave Cacophony               "
    db  "    Temple Tunes                " ; TODO: Come up with better name for the temple tune
    db  "    Stage Clear!                "
    db  "   Down 'n  Dirty               "
    db  "     Game  Over                 "
    db  "    Bonus  Time!                "
    db  "       Museum                   "
    db  "     Staff Roll                 "
;        -##################-------------
.end

; ================

section "Sound test - Marquee scroll table",romx,align[8]

SoundTest_MarqueeScrollTable::
    db      $00,$00,$00,$00,$00,$00,$01,$01,$02,$03,$03,$04,$05,$06,$07,$08
    db      $09,$0A,$0C,$0D,$0F,$10,$12,$13,$15,$17,$19,$1B,$1D,$1F,$21,$23
    db      $25,$27,$2A,$2C,$2E,$31,$33,$36,$38,$3B,$3E,$40,$43,$46,$49,$4C
    db      $4F,$51,$54,$57,$5A,$5D,$60,$63,$67,$6A,$6D,$70,$73,$76,$79,$7C
    db      $80,$83,$86,$89,$8C,$8F,$92,$95,$98,$9C,$9F,$A2,$A5,$A8,$AB,$AE
    db      $B0,$B3,$B6,$B9,$BC,$BF,$C1,$C4,$C7,$C9,$CC,$CE,$D1,$D3,$D5,$D8
    db      $DA,$DC,$DE,$E0,$E2,$E4,$E6,$E8,$EA,$EC,$ED,$EF,$F0,$F2,$F3,$F5
    db      $F6,$F7,$F8,$F9,$FA,$FB,$FC,$FC,$FD,$FE,$FE,$FF,$FF,$FF,$FF,$FF

; ================

section "Sound test GFX",romx

SoundTestTiles:
    incbin  "GFX/SoundTest.2bpp"
.end

Pal_SoundTest:
    RGB      0, 0, 0
    RGB     15,15,15
    RGB     28,28,28
    RGB     31,31,31
    
    RGB      0, 0, 0
    RGB      0,15, 0
    RGB      0,31, 0
    RGB     31,31, 0

    RGB      0, 0, 0
    RGB     15,15, 0
    RGB     31,31, 0
    RGB     31,31,31
    
    RGB      0, 0, 0
    RGB     15, 0, 0
    RGB     31, 0, 0
    RGB     31,15, 0

Pal_SoundTestOBJ:
    RGB     31, 0,31
    RGB      5, 5, 5
    RGB     10,10,10
    RGB     15,15,15


SoundTest_AttributeMap:
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      8,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $23,$03,$23,$03,$23,$03,$23,$03,$23,$03,$23,$03,$23,$03,$23,$03,$23,$03,$23,$03,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $22,$02,$22,$02,$22,$02,$22,$02,$22,$02,$22,$02,$22,$02,$22,$02,$22,$02,$22,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      $21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$21,$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
.end

SoundTestMap:
    ;       # # # # # # # # # # # # # # # # # # # # 
    db      "SOUND TEST",       2,3,3,3,3,3,3,3,3,3
    db      "SOUND TEST",       1,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db      "                    "
    db      "                    "
;            -##################-------------
.end

SoundTestFontTop:       incbin  "GFX/SoundTestFontTop.2bpp.wle"
SoundTestFontBottom:    incbin  "GFX/SoundTestFontBottom.2bpp.wle"
