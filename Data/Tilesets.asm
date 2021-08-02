; Metatile format:
; 16x16, 2 bytes per tile
; - First byte of tile for tile ID
; - Second byte of tile for attributes

section "Test tileset",romx
ColMap_Test:
	db	0,0,0,0,1,0,2,2,2,2
Tileset_Test:
	; collision pointer
	dw	ColMap_Test
    dbw bank(TestMapTiles),TestMapTiles
    ; background 1 (horizontal + vertical parallax)
    db  $00,%00000000,$01,%00000000
    db  $02,%00000000,$03,%00000000
    ; background 2 (horizontal + vertical parallax)
    db  $04,%00000000,$05,%00000000
    db  $06,%00000000,$07,%00000000
    ; background 3 (horizontal parallax)
    db  $08,%00000000,$09,%00000000
    db  $0a,%00000000,$0b,%00000000
    ; background 4 (horizontal parallax)
    db  $0c,%00000000,$0d,%00000000
    db  $0e,%00000000,$0f,%00000000
    ; solid tile
    db  $10,%00000001,$12,%00000001
    db  $11,%00000001,$13,%00000001
    ; foreground tile
    db  $17,%10000001,$17,%10100001
    db  $17,%11000001,$17,%11100001
    ; topsolid tile (background 1)
    db  $14,%00000001,$15,%00000001
    db  $02,%00000000,$03,%00000000
    ; topsolid tile (background 2)
    db  $14,%00000001,$15,%00000001
    db  $06,%00000000,$07,%00000000
    ; topsolid tile (background 3)
    db  $14,%00000001,$15,%00000001
    db  $0a,%00000000,$0b,%00000000
    ; topsolid tile (background 4)
    db  $14,%00000001,$15,%00000001
    db  $0e,%00000000,$0f,%00000000
	