; ===================
; Basic Sprite System
; ===================

section "Sprite Variables",wram0
Sprite_NextSprite:  db

section "Sprite Routines",rom0

; Reset sprite counter
BeginSprites:
  xor a
  ld  [Sprite_NextSprite],a
  ret
  
; Add sprite entry
; INPUT:  b = Tile ID
;         c = Attributes
;         d = Y Position
;         e = X Position
AddSprite:
  ld  a,[Sprite_NextSprite]
  cp  40
  ret z
  ld  hl,OAMBuffer
  push  bc
  ld  c,a
  xor a
  ld  b,a
  sla c
  rl  b
  sla c
  rl  b
  add hl,bc
  pop bc
  ld  a,d
  ld  [hl+],a
  ld  a,e
  ld  [hl+],a
  ld  a,b
  ld  [hl+],a
  ld  a,c
  ld  [hl],a
  ld  hl,Sprite_NextSprite
  inc [hl]
  ret
  
; Clear remaining sprites
EndSprites:
  ld  a,[Sprite_NextSprite]
  cp  40
  ret z
  ld  d,a
  ld  c,a
  xor a
  ld  b,a
  sla c
  rl  b
  sla c
  rl  b
  ld  hl,OAMBuffer
  add hl,bc
  ld  bc,4
:
  xor a
  ld  [hl],a
  add hl,bc
  inc d
  ld  a,d
  cp  40
  jr   nz,:-
  ret
  
; Load dynamic tiles
; INPUT:  hl = Tile Data Pointer
;          a = Tile ID
;          b = Byte Count
LoadSpriteTiles:
  ld  de,$8000
  swap  a
  ld  c,a
  and $f0
  add e
  push  af
  ld  e,a
  ld  a,c
  and $0f
  ld  c,a
  pop af
  ld  a,c
  adc d
  ld  d,a
  ld  a,1
  ldh [rVBK],a
.loadLoop:
  ldh a,[rSTAT]
  and 2
  jr  nz,.loadLoop
  ld  a,[hl+]
  ld  [de],a
  inc de
  dec b
  jr  nz,.loadLoop
  xor a
  ldh [rVBK],a
  ret