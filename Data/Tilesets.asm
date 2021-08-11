; Metatile format:
; 16x16, 2 bytes per tile
; - First byte of tile for tile ID
; - Second byte of tile for attributes

; ================================================================
section "Test tileset - Graphics",romx
TestMapTiles:
    incbin  "GFX/TestTiles.2bpp.wle"

section "Test tileset - Collision map + metatiles",romx
; Valid collision types:
; 00 = None
; 01 = Solid (all sides)
; 02 = Solid (top only)
; 03 = Water
ColMap_Test:
	db	0,1,0,2,3,3,3,3,3,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Tileset_Test:
	; collision pointer
	dw	ColMap_Test
    dbw bank(TestMapTiles),TestMapTiles
    ; background 1 (horizontal + vertical parallax)
    db  $00,%00000000,$01,%00000000
    db  $02,%00000000,$03,%00000000
    ; solid tile
    db  $10,%00000001,$12,%00000001
    db  $11,%00000001,$13,%00000001
    ; foreground tile
    db  $17,%10000001,$17,%10100001
    db  $17,%11000001,$17,%11100001
    ; topsolid tile (background 1)
    db  $14,%00000001,$15,%00000001
    db  $02,%00000000,$03,%00000000
    ; water w/ sunbeam 1 (horizontal parallax)
    db  $08,%00100001,$09,%00100001
    db  $0a,%00100001,$0b,%00100001
    ; water w/ sunbeam 2 (horizontal parallax)
    db  $09,%00100001,$08,%00100001
    db  $0b,%00100001,$0a,%00100001
    ; water surface 1 (horizontal parallax
    db  $18,%00000001,$19,%00000001
    db  $0a,%00100001,$0b,%00100001
    ; water surface 1 (horizontal parallax
    db  $18,%00000001,$19,%00000001
    db  $0b,%00100001,$0a,%00100001
    ; water w/ no sunbeam
    db  $16,%00000001,$16,%00000001
    db  $16,%00000001,$16,%00000001

; ================================================================

section "Plains tileset - Graphics",romx
PlainsTiles:
    incbin  "GFX/PlainsTiles.2bpp.wle"

section "Plains tileset - Collision map + metatiles",romx
; Valid collision types:
; 00 = None
; 01 = Solid (all sides)
; 02 = Solid (top only)
; 03 = Water
ColMap_Plains:
	db	0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0
	db	3,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0
	db	3,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Tileset_Plains:
	; collision pointer
	dw	ColMap_Plains
    dbw bank(PlainsTiles),PlainsTiles
    ; sky
    db  $00,%00000011,$01,%00000011
    db  $02,%00000011,$03,%00000011
    ; top left corner
    db  $10,%00000001,$11,%00000001
    db  $13,%00000000,$14,%00000000
    ; top
    db  $11,%00000001,$11,%00000001
    db  $15,%00000000,$14,%00000000
    ; top right corner
    db  $11,%00000001,$12,%00000001
    db  $15,%00000000,$16,%00000000
    ; top left inner corner
    db  $15,%00000000,$14,%00000000
    db  $15,%00000000,$21,%00000000
    ; top right inner corner
    db  $15,%00000000,$14,%00000000
    db  $22,%00000000,$14,%00000000
    ; cave background (horizontal + vertical parallax)
    db  $04,%00000000,$05,%00000000
    db  $06,%00000000,$07,%00000000
    ; reserved
    rept 9
        db  0,0,0,0
        db  0,0,0,0
    endr
    ; water surface
    db  $23,%00000011,$24,%00000011
    db  $25,%00000011,$26,%00000011
    ; left
    db  $13,%00000000,$14,%00000000
    db  $13,%00000000,$14,%00000000
    ; middle (no rocks)
    db  $15,%00000000,$14,%00000000
    db  $15,%00000000,$14,%00000000
    ; right
    db  $15,%00000000,$16,%00000000
    db  $15,%00000000,$16,%00000000
    ; bottom left inner corner
    db  $1d,%00000000,$1e,%00000001
    db  $15,%00000000,$14,%00000000
    ; bottom right inner corner
    db  $1f,%00000001,$20,%00000000
    db  $15,%00000000,$14,%00000000
    ; reserved
    rept 10
        db  0,0,0,0
        db  0,0,0,0
    endr
    ; water
    db  $27,%00000011,$27,%00000011
    db  $27,%00000011,$27,%00000011
    ; bottom left
    db  $13,%00000000,$14,%00000000
    db  $19,%00000000,$1a,%00000000
    ; bottom
    db  $15,%00000000,$14,%00000000
    db  $1b,%00000000,$1a,%00000000
    ; bottom right
    db  $15,%00000000,$16,%00000000
    db  $1b,%00000000,$1c,%00000000
    ; middle (rocks 1)
    db  $17,%00000010,$14,%00000000
    db  $15,%00000000,$14,%00000000
    ; middle (rocks 2)
    db  $15,%00000000,$14,%00000000
    db  $15,%00000000,$18,%00000010