; Metatile format:
; 16x16, 2 bytes per tile
; - First byte of tile for tile ID
; - Second byte of tile for attributes

section "Test tileset",romx
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