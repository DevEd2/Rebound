section "Splash screen RAM",wram0

Splash_Timer:	db

; ================

section "Splash screen routines",rom0

GM_SplashScreens:
	; we're already in VBlank, don't wait before disabling LCD
	; LY = 149 on entry (may change)
	xor		a
	ldh		[rLCDC],a

	ldfar	hl,LicenseScreenTiles
	ld		de,$8000
	call	DecodeWLE

	ld		hl,LicenseScreenMap
	ld		de,sys_TilemapBuffer
	call	DecodeWLE

	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen

	ldfar	hl,Pal_GrayscaleInverted
	xor		a
	call	LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call	UpdatePalettes

	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei

	ld		a,240
	ld		[Splash_Timer],a
	call	SplashScreensLoop
	halt
	xor		a
	ldh		[rLCDC],a

	; --------

	ldfar	hl,GBCompo2021Tiles
	ld		de,$8000
	call	DecodeWLE

	ld		hl,GBCompo2021Map
	ld		de,sys_TilemapBuffer
	call	DecodeWLE

	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen

	ld		hl,Pal_GBCompo2021
	xor		a
	call	LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call	UpdatePalettes

	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei

	ld		a,240
	ld		[Splash_Timer],a
	call	SplashScreensLoop
	halt
	xor		a
	ldh		[rLCDC],a

	; --------

	ldfar	hl,DevEdPresentsTiles
	ld		de,$8000
	call	DecodeWLE

	ld		hl,DevEdPresentsMap
	ld		de,sys_TilemapBuffer
	call	DecodeWLE

	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen

	ldfar	hl,Pal_GrayscaleInverted
	xor		a
	call	LoadPal
    call    ConvertPals
    call    PalFadeInWhite
    call	UpdatePalettes

	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei

	ld		a,240
	ld		[Splash_Timer],a
	call	SplashScreensLoop
	halt
	xor		a
	ldh		[rLCDC],a

	jp		GM_TitleAndMenus

SplashScreensLoop:
	ld		a,[Splash_Timer]
	dec		a
	ld		[Splash_Timer],a
	jr		nz,.skipfade
	call	PalFadeOutWhite
.dofadeout
	ld		a,[sys_FadeState]
	bit		0,a
	ret		z
	halt
	jr		.dofadeout
.skipfade
	halt
	jr		SplashScreensLoop

; ================

section "Splash screen GFX",romx

; too lazy to properly convert the palette :V
Pal_GBCompo2021:
	RGB	 (32>>3), (70>>3), (49>>3)
	RGB	(103>>3),(158>>3), (71>>3)
	RGB	(174>>3),(196>>3), (64>>3)
	RGB	(215>>3),(232>>3),(148>>3)

LicenseScreenTiles:	incbin	"GFX/LicenseScreen.2bpp.wle"
GBCompo2021Tiles:	incbin	"GFX/GBCompo2021.2bpp.wle"
DevEdPresentsTiles:	incbin	"GFX/DevEdPresents.2bpp.wle"

LicenseScreenMap:	incbin	"GFX/LicenseScreen.til.wle"
GBCompo2021Map:		incbin	"GFX/GBCompo2021.til.wle"
DevEdPresentsMap:	incbin	"GFX/DevEdPresents.til.wle"
