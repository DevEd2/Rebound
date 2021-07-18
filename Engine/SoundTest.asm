section "Sound test RAM",wram0

; ================

section "Sound test routines",rom0

GM_SoundTest:
	; we're already in VBlank, don't wait before disabling LCD
	; LY = 149 on entry (may change)
	xor		a
	ldh		[rLCDC],a

	ldfar	hl,SoundTestTiles
	ld		de,$8000
	ld		bc,SoundTestTiles.end-SoundTestTiles
	call	_CopyTileset

	ld		hl,SoundTestMap
	ld		de,sys_TilemapBuffer
	ld		bc,SoundTestMap.end-SoundTestMap
	call	_CopyRAM

	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen

	ld		hl,Pal_SoundTest
	xor		a
	call	LoadPal
	ld		a,1
	call	LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call	UpdatePalettes

	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei

SoundTestLoop:
	halt
	jr		SoundTestLoop

; ================

Gradient_VolumeMeterLimit:
	db		1
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
	db		0
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
	db		0
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
	db		1
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
	incbin	"GFX/SoundTest.2bpp"
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

SoundTest_AttributeMap:
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1	
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.end

SoundTestMap:
	;       # # # # # # # # # # # # # # # # # # # # 
	db		1,1,1,1,1,1,1,1,1,1,3,4,4,4,4,4,4,4,4,4
	db		1,1,1,1,1,1,1,1,1,1,2,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.end