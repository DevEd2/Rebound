section "Sound test RAM",wram0

SoundTest_SongID:   db

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
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei

;    xor     a
    ld      a,1
    ld      [SoundTest_SongID],a
    farcall DS_Init

SoundTestLoop:
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

    halt
    jr      SoundTestLoop

SoundTest_CursorOscillationTable:
    db       0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1
    db       0, 0,-1,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1

; ================

SoundTest_SongNames:
;        -##################-------------
    db  "     Main Theme                 "
    db  " Humble  Beginnings             "
    db  "   Rock the Block               "
    db  "    Pyramid Jams                "
    db  "   Mystic  Medley               "
    db  "   Temple of ????               " ; TODO: Come up with a name for the temple tune
    db  "    Bonus  Time!                "
    db  "    Happy Ending                "
.end

NUM_SONGS   equ (SoundTest_SongNames.end-SoundTest_SongNames)/32

; ================

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
    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
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
.end

SoundTestFontTop:       incbin  "GFX/SoundTestFontTop.2bpp.wle"
SoundTestFontBottom:    incbin  "GFX/SoundTestFontBottom.2bpp.wle"
