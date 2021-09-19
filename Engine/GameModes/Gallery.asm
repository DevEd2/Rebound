
; ================

section "Gallery routines",rom0

GM_Gallery:
	call    ClearScreen
    
	ldfar	hl,GalleryTiles
	ld		de,$8000
	call	DecodeWLE

	ld		hl,GalleryMap
	ld		de,sys_TilemapBuffer
	call	DecodeWLE
	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen
    
    ld      a,1
    ldh     [rVBK],a
    
	ld		hl,GalleryAttr
	ld		de,sys_TilemapBuffer
	call	DecodeWLE
	ld		hl,sys_TilemapBuffer
	call	LoadTilemapScreen
    
    xor     a
    ldh     [rVBK],a

	ldfar	hl,Pal_Gallery
    ld      b,6
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
    call	UpdatePalettes

	ld		a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei

.loop
	halt
    ld      a,[sys_btnPress]
    and     a           ; are any buttons pressed?
    jr      nz,:+
    jr      .loop
:   call    PalFadeOutWhite
:   halt
    ld		a,[sys_FadeState]
	bit		0,a
    jr      nz,:-
	xor		a
	ldh		[rLCDC],a
    jp      GM_TitleAndMenus

; ================

section "Gallery GFX",romx

GalleryTiles:	        incbin	"GFX/Screens/NYI.2bpp.wle"
GalleryMap:	            incbin	"GFX/Screens/NYI.til.wle"
GalleryAttr:            incbin  "GFX/Screens/NYI.atr.wle"
Pal_Gallery:            incbin  "GFX/Screens/NYI.pal"

section "Gallery text",romx

GalleryText_Title1_Name:    string  "Title screen 1"
GalleryText_Title2_Name:    string  "Title screen 2"
GalleryText_TitleCard_Name: string  "Title card"
GalleryText_City1_Name:     string  "City world concept 1"
GalleryText_City2_Name:     string  "City world concept 2"
GalleryText_Boss2_Name:     string  "City world boss"

GalleryText_Title1_Desc:    string  "A proposed title screen image by Twoflower. This was used as the basis for the demo's title screen."
GalleryText_Title2_Desc:    string  "A second proposed title screen image by Twoflower. This design was eventually rejected."
GalleryText_TitleCard_Desc: string  "Concept for a title card by DevEd. This didn't make it into the demo due to time constraints."
GalleryText_City1_Desc:     string  "Proposed design for the second world, Central City, by Twoflower. The second world was cut from the demo due to time constraints."
GalleryText_City2_Desc:     string  "Another proposed design for the city level by DevEd."
GalleryText_Boss2_Desc:     string  "Sketch of Central City's boss, \"The Don\", by DevEd. Medium: Ink on paper."

section "Gallery GFX - Title concept 1",romx
Gallery_Title1Tiles:    incbin  "GFX/ConceptArt/TitleConcept1.2bpp.wle"
Gallery_Title1Map:      incbin  "GFX/ConceptArt/TitleConcept1.til.wle"
Gallery_Title1Attr:     incbin  "GFX/ConceptArt/TitleConcept1.atr.wle"
Pal_Gallery_Title1:     incbin  "GFX/ConceptArt/TitleConcept1.pal"

section "Gallery GFX - Title concept 2",romx
Gallery_Title2Tiles:    incbin  "GFX/ConceptArt/TitleConcept2.2bpp.wle"
Gallery_Title2Map:      incbin  "GFX/ConceptArt/TitleConcept2.til.wle"
Gallery_Title2Attr:     incbin  "GFX/ConceptArt/TitleConcept2.atr.wle"
Pal_Gallery_Title2:     incbin  "GFX/ConceptArt/TitleConcept2.pal"

section "Gallery GFX - Title card",romx
Gallery_TitleCardTiles: incbin  "GFX/ConceptArt/TitleCardConcept.2bpp.wle"
Gallery_TitleCardMap:   incbin  "GFX/ConceptArt/TitleCardConcept.til.wle"
Gallery_TitleCardAttr:  incbin  "GFX/ConceptArt/TitleCardConcept.atr.wle"
Pal_Gallery_TitleCard:  incbin  "GFX/ConceptArt/TitleCardConcept.pal"

section "Gallery GFX - City mockup 1",romx
Gallery_City1Tiles:     incbin  "GFX/ConceptArt/CityConcept1.2bpp.wle"
Gallery_City1Map:       incbin  "GFX/ConceptArt/CityConcept1.til.wle"
Gallery_City1Attr:      incbin  "GFX/ConceptArt/CityConcept1.atr.wle"
Pal_Gallery_City1:      incbin  "GFX/ConceptArt/CityConcept1.pal"

section "Gallery GFX - City mockup 2",romx
Gallery_City2Tiles:     incbin  "GFX/ConceptArt/CityConcept2.2bpp.wle"
Gallery_City2Map:       incbin  "GFX/ConceptArt/CityConcept2.til.wle"
Gallery_City2Attr:      incbin  "GFX/ConceptArt/CityConcept2.atr.wle"
Pal_Gallery_City2:      incbin  "GFX/ConceptArt/CityConcept2.pal"

section "Gallery GFX - City boss",romx
Gallery_Boss2Tiles:     incbin  "GFX/ConceptArt/World2Boss.2bpp.wle"
Gallery_Boss2Map:       incbin  "GFX/ConceptArt/World2Boss.til.wle"
Gallery_Boss2Attr:      incbin  "GFX/ConceptArt/World2Boss.atr.wle"
Pal_Gallery_Boss2:      incbin  "GFX/ConceptArt/World2Boss.pal"
