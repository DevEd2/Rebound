section "Sound test RAM",wram0

SoundTest_SongID:           db
SoundTest_MarqueeScroll:    db
SoundTest_MarqueePos:       db

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
    call    _CopyTileset

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
    xor     a
    call    LoadPal
    ld      a,1
    call    LoadPal
    ; hl = Pal_SoundTestCursor
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
    ld      [SoundTest_SongID],a
    ld      [SoundTest_MarqueeScroll],a
    ld      [SoundTest_MarqueePos],a
    push    af
    farcall DS_Init
    pop     af
    call    SoundTest_DrawSongName

SoundTestLoop:
    ld      a,[sys_btnPress]
    bit     btnB,a
    jp      nz,.exit
    bit     btnA,a
    jr      nz,.playsong

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
.playsong
    ld      a,[SoundTest_SongID]
    farcall DS_Init
    jr      .continue
.exit
    call    DS_Stop
    halt
    xor     a
    ldh     [rLCDC],a
    call    ClearScreen
    jp      GM_DebugMenu

.continue
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

.wait
    rst     WaitLCDC
    call    SoundTest_RunMarquee
    
    rst     WaitVBlank
    xor     a
    ldh     [rSCX],a
    jp      SoundTestLoop

SoundTest_CursorOscillationTable:
    db       0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1
    db       0, 0,-1,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1

; ================

; a = song ID
; b = offset
SoundTest_DrawSongNameChar:  
    ld      hl,SoundTest_SongNames
    add     a   ; x2
    add     a   ; x4
    add     a   ; x8
    add     a   ; x16
    add     a   ; x32
    add     l
    ld      l,a
    jr      nc,.nocarry1
    inc     h
.nocarry1
    add     b
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    ld      d,$9a
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
    ld      a,[SoundTest_MarqueePos]
    add     2
    bit     7,a
    jr      z,.noreset
    xor     a
    ld      [SoundTest_MarqueePos],a
    ld      [SoundTest_MarqueeScroll],a
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
    ld      a,[SoundTest_MarqueePos]
    sub     2
    res     7,a
    and     a
    jr      nz,.noreset2
    xor     a
    ld      [SoundTest_MarqueePos],a
    ld      [SoundTest_MarqueeScroll],a
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
;   db  "   Rock the Block               "
    db  "    Pyramid Jams                "
;   db  "   Mystic  Medley               "
;   db  "   Cave Cacophony               "
;   db  "    Temple Tunes                " ; TODO: Come up with better name for the temple tune
    db  "  Plains Perfected              "
;   db  "   City Completed               "
;   db  "   Pyramid Passed               "
;   db  "  Forest  Flourish              "
;   db  "   Temple Triumph               "
;   db  "    Bonus  Time!                "
;   db  "     Staff Roll                 "
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

section "Sound test - Gradient data",romx

Gradient_VolumeMeterLimit:
    db      1
    RGB     31, 0, 0
    RGB     31, 2, 0
    RGB     31, 4, 0
    RGB     31, 6, 0
    RGB     31, 8, 0
    RGB     31,10, 0
    RGB     31,12, 0
    RGB     31,14, 0
    RGB     31,16, 0
    RGB     31,18, 0
    RGB     31,20, 0
    RGB     31,22, 0
    RGB     31,24, 0
    RGB     31,26, 0
    RGB     31,28, 0
    RGB     31,30, 0
    RGB     31,31, 0
    RGB     30,31, 0
    RGB     28,31, 0
    RGB     26,31, 0
    RGB     24,31, 0
    RGB     22,31, 0
    RGB     20,31, 0
    RGB     18,31, 0
    RGB     16,31, 0
    RGB     14,31, 0
    RGB     12,31, 0
    RGB     10,31, 0
    RGB      8,31, 0
    RGB      6,31, 0
    RGB      4,31, 0
    RGB      2,31, 0
    RGB      0,31, 0
.end

Gradient_GlassSurface:
    db      0
    RGB      1, 1, 1
    RGB      2, 2, 2
    RGB      3, 3, 3
    RGB      4, 4, 4
    RGB      5, 5, 5
    RGB      6, 6, 6
    RGB      7, 7, 7
    RGB      8, 8, 8
    RGB      9, 9, 9
    RGB     10,10,10
    RGB     11,11,11
    RGB     12,12,12
    RGB     13,13,13
    RGB     14,14,14
    RGB     15,15,15
    RGB     16,16,16

Gradient_GlassReflect:
    db      0
    RGB      8, 8, 8
    RGB      8, 8, 8
    RGB      7, 7, 7
    RGB      7, 7, 7
    RGB      6, 6, 6
    RGB      6, 6, 6
    RGB      5, 5, 5
    RGB      5, 5, 5
    RGB      4, 4, 4
    RGB      4, 4, 4
    RGB      3, 3, 3
    RGB      3, 3, 3
    RGB      2, 2, 2
    RGB      2, 2, 2
    RGB      1, 1, 1
    RGB      1, 1, 1
    RGB      0, 0, 0

Gradient_VolumeMeterReflect:
    db      1
    RGB      0, 8, 0
    RGB      0, 8, 0
    RGB      0, 7, 0
    RGB      0, 7, 0
    RGB      0, 6, 0
    RGB      0, 6, 0
    RGB      0, 5, 0
    RGB      0, 5, 0
    RGB      0, 4, 0
    RGB      0, 4, 0
    RGB      0, 3, 0
    RGB      0, 3, 0
    RGB      0, 2, 0
    RGB      0, 2, 0
    RGB      0, 1, 0
    RGB      0, 1, 0
    RGB      0, 0, 0

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
    RGB      0,31, 0
    RGB     31,31, 0
    RGB     31,31,31

Pal_SoundTestCursor:
    RGB     31, 0,31
    RGB      5, 5, 5
    RGB     10,10,10
    RGB     15,15,15

SoundTest_AttributeMap:
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      8,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
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
