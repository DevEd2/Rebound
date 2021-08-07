; ==============
; Object System
; ==============

; TODO
; - Object Behaviors

section "Object Memory",wram0

MONSTER_COUNT     equ 16
MONSTER_WRAMSIZE  equ 16

MONSTER_FLAG_HITPLAYER    equ 0
MONSTER_FLAG_HITBYPLAYER  equ 1
MONSTER_FLAG_FLIPH        equ 5
MOSNTER_FLAG_FLIPV        equ 6

; Monster IDs
MONSTER_NULL        equ 0
MONSTER_TEST        equ 1

Monster_ID:           ds  MONSTER_COUNT
Monster_Pointer:      ds  MONSTER_COUNT
Monster_ParentScreen: ds  MONSTER_COUNT ; Parent Object = High Nibble, Screen Index = Low Nibble
Monster_Flags:        ds  MONSTER_COUNT
Monster_XPosition:    ds  MONSTER_COUNT
Monster_XPositionS:   ds  MONSTER_COUNT
Monster_YPosition:    ds  MONSTER_COUNT
Monster_YPositionS:   ds  MONSTER_COUNT
Monster_XVelocity:    ds  MONSTER_COUNT
Monster_XVelocityS:   ds  MONSTER_COUNT
Monster_YVelocity:    ds  MONSTER_COUNT
Monster_YVelocityS:   ds  MONSTER_COUNT
Monster_AnimBank:     ds  MONSTER_COUNT
Monster_AnimPtrHi:    ds  MONSTER_COUNT
Monster_AnimPtrLo:    ds  MONSTER_COUNT
Monster_AnimTimer:    ds  MONSTER_COUNT

PARTICLE_COUNT  equ 6

PARTICLE_FLICKERTIME      equ 30

PARTICLE_FLAG_DSOLID      equ 0
PARTICLE_FLAG_DWATER      equ 1

PARTICLE_COLLIDES         equ %00000011

Particle_Sprite:      ds  PARTICLE_COUNT
Particle_Attribute:   ds  PARTICLE_COUNT
Particle_Flags:       ds  PARTICLE_COUNT
Particle_Screen:      ds  PARTICLE_COUNT
Particle_Lifetime:    ds  PARTICLE_COUNT ; 0 = Infinite
Particle_XPosition:   ds  PARTICLE_COUNT
Particle_XPositionS:  ds  PARTICLE_COUNT
Particle_YPosition:   ds  PARTICLE_COUNT
Particle_YPositionS:  ds  PARTICLE_COUNT
Particle_XVelocity:   ds  PARTICLE_COUNT
Particle_XVelocityS:  ds  PARTICLE_COUNT
Particle_YVelocity:   ds  PARTICLE_COUNT
Particle_YVelocityS:  ds  PARTICLE_COUNT

OFFSCREEN_THRESHOLD   equ 32

section "Object WRAM",wram0,align[8]
Monster_WRAM: ds MONSTER_WRAMSIZE*MONSTER_COUNT

section "Temp Variables",hram
Temp0:  db
Temp1:  db

section "Object Routines",rom0

; Clear Monster List
; TRASHES:  a,b,hl
ClearMonsters:
  ld  hl,Monster_ID
  ld  b,MONSTER_COUNT
  xor a
:
  ld  [hl+],a
  dec b
  jr  nz,:-
  ret
  
; Get Free Monster Slot
; OUTPUT:   bc = Monster Slot Number or $00FF if no slots left
;           hl = Pointer to Monster ID
; TRASHES:  a
GetMonsterSlot:
  ld  hl,Monster_ID+MONSTER_COUNT-1
  ld  c,MONSTER_COUNT-1
  ld  b,0
:
  ld  a,[hl]
  or  a
  ret z
  dec hl
  dec c
  bit 7,c
  jr  z,:-
  ret
  
; Update all Monsters
UpdateMonsters:
  ld  b,0
  ld  c,MONSTER_COUNT-1
.updateLoop:
  ld  hl,Monster_ID   ; Monster ID Pointer
  add hl,bc           ; Point to this Monster
  ld  a,[hl]          ; Get ID
  or  a
  jp  z,.nextMonster  ; 0 = No Monster
  ; Type Specific Update - TODO
  
  ; Check Parent
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]                ; Get Parent/Screen byte
  swap  a                   ; Move Parent to low nibble
  and $0f                   ; Mask out screen value
  cp  c                     ; Compare to current slot number
  jp  nz,.nextMonster       ; If this is a child object, don't do movement
  
  ; Horizontal Movement
  ld  hl,Monster_XVelocityS ; Monster X Velocity Sub Pointer
  add hl,bc                 ; Point to this Monster
  ld  a,[hl]                ; Get X Velocity Sub
  ld  hl,Monster_XPositionS ; Monster X Position Sub Pointer
  add hl,bc                 ; Point to this Monster
  add a,[hl]                ; Add X Position Sub
  ld  [hl],a                ; Store new X Position Sub
  push  af                  ; Save Carry Flag
  ld  hl,Monster_XVelocity  ; Monster X Velocity Pointer
  add hl,bc                 ; Point to this Monster
  ld  a,[hl]                ; Get X Velocity
  ld  d,a                   ; Save X Velocity
  ld  hl,Monster_XPosition  ; Monster X Position Pointer
  add hl,bc                 ; Point to this Monster
  pop af                    ; Restore Carry Flag
  ld  a,d                   ; Restore X Velocity
  adc a,[hl]                ; Add X Position + Carry
  ld  [hl],a                ; Store new X Position
  ; Check Screen Crossing
  bit 7,d                   ; Check Velocity Direction
  jr  z,:+
  jr  c,.xMoveDone
  ; Left edge crossed, decrement screen
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]                ; Get Parent/Screen byte
  and $0f
  jr  z,.xMoveDone
  dec a
  ld  d,a
  ld  a,[hl]
  and $f0
  or  d
  ld  [hl],a
  jr  .xMoveDone
:
  jr  nc,.xMoveDone
  ; Right edge crossed, increment screen
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]
  and $0f
  ld  d,a
  ld  a,[Engine_NumScreens]
  cp  d
  jr  z,.xMoveDone
  inc d
  ld  a,[hl]
  and $f0
  or  d
  ld  [hl],a
.xMoveDone:
  
  ; Vertical Movement
  ld  hl,Monster_YVelocityS ; Monster Y Velocity Sub Pointer
  add hl,bc                 ; Point to this Monster
  ld  a,[hl]                ; Get Y Velocity Sub
  ld  hl,Monster_YPositionS ; Monster Y Position Sub Pointer
  add hl,bc                 ; Point to this Monster
  add a,[hl]                ; Add Y Position Sub
  ld  [hl],a                ; Store new Y Position Sub
  push  af                  ; Save Carry Flag
  ld  hl,Monster_YVelocity  ; Monster Y Velocity Pointer
  add hl,bc                 ; Point to this Monster
  ld  a,[hl]                ; Get Y Velocity
  ld  d,a                   ; Save Y Velocity
  ld  hl,Monster_YPosition  ; Monster Y Position Pointer
  add hl,bc                 ; Point to this Monster
  pop af                    ; Restore Carry Flag
  ld  a,d                   ; Restore Y Velocity
  adc a,[hl]                ; Add Y Position + Carry
  ld  [hl],a                ; Store new Y Position
  
  ; On Screen Check
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[Engine_CameraX]
  ld  d,a
  ld  a,[hl]
  sub d
  cp  SCRN_X+OFFSCREEN_THRESHOLD
  jr  c,.checkY
  cp  -OFFSCREEN_THRESHOLD
  jr  nc,.checkY
  call  DeleteMonster
  jr  .nextMonster
.checkY:
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[Engine_CameraY]
  ld  d,a
  ld  a,[hl]
  sub d
  cp  SCRN_Y+OFFSCREEN_THRESHOLD
  jr  c,.nextMonster
  cp  -OFFSCREEN_THRESHOLD
  jr  nc,.nextMonster
  call  DeleteMonster
  
.nextMonster
  dec c
  bit 7,c
  jp  z,.updateLoop
  ret
  
; Generate Monster sprite entries
; TODO - Remove placeholder sprite
RenderMonsters:
  ld  b,0
  ld  c,MONSTER_COUNT-1
.renderLoop:
  ld  hl,Monster_ID
  add hl,bc
  ld  a,[hl]
  or  a
  jr  z,.nextMonster
  ld  de,0
  push  bc
:
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  add e
  ld  e,a
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  add d
  ld  d,a
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]
  swap  a
  and $0f
  cp  c
  jr  z,:+
  ld  c,a
  jr  :-
:
  ld  hl,Engine_CameraX
  ld  a,e
  sub [hl]
  ld  e,a
  ld  hl,Engine_CameraY
  ld  a,d
  sub [hl]
  add 8
  ld  d,a
  ld  hl,Monster_Flags
  pop bc
  add hl,bc
  ld  a,[hl]
  and %01100000
  or  %00001000
  push  bc
  ld  c,a
  ld  b,0
  bit MONSTER_FLAG_FLIPH,c
  jr  z,:+
  ld  b,2
:
  call  AddSprite
  ld  a,e
  add 8
  ld  e,a
  bit MONSTER_FLAG_FLIPH,c
  jr  nz,:+
  inc b
  inc b
  jr  :++
:
  dec b
  dec b
:
  call  AddSprite
  pop bc
.nextMonster:
  dec c
  bit 7,c
  jr  z,.renderLoop
  ret
  
; Delete a Monster and all children
; INPUT:  bc = Monster Slot Number
DeleteMonster:
  ld  hl,Monster_ID
  add hl,bc
  xor a
  ld  [hl],a
  ld  de,MONSTER_COUNT-1
.childLoop
  ld  hl,Monster_ID
  add hl,de
  ld  a,[hl]
  or  a
  jr  z,:+
  ld  hl,Monster_ParentScreen
  add hl,de
  ld  a,[hl]
  swap  a
  and $0f
  cp  c
  jr  nz,:+
  push  de
  push  bc
  ld  c,e
  call  DeleteMonster
  pop bc
  pop de
:
  dec e
  bit 7,e
  jr  z,.childLoop
  ret
  
; Clear Particle List
; TRASHES:  a,b,hl
ClearParticles:
  ld  hl,Particle_Sprite
  ld  b,PARTICLE_COUNT
  xor a
:
  ld  [hl+],a
  dec b
  jr  nz,:-
  ret
  
; Get Free Particle Slot
; OUTPUT:   bc  = Particle Slot Number or -1 if no slots left
;           hl = Pointer to Particle ID
; TRASHES:  a
GetParticleSlot:
  ld  hl,Particle_Sprite+PARTICLE_COUNT-1
  ld  c,PARTICLE_COUNT-1
  ld  b,0
:
  ld  a,[hl]
  or  a
  ret z
  dec hl
  dec c
  bit 7,c
  jr  z,:-
  ret
  
; Update all Particles
UpdateParticles:
  ld  b,0
  ld  c,PARTICLE_COUNT-1
.updateLoop:
  ld  hl,Particle_Sprite
  add hl,bc
  ld  a,[hl]
  jp  z,.nextParticle
  
  ; Lifetime Update
  ld  hl,Particle_Lifetime
  add hl,bc
  ld  a,[hl]
  or  a
  jr  z,:+    ; 0 = Infinite Lifetime
  dec a
  ld  [hl],a
  jr  nz,:+   ; If decrement to 0, delete particle
.deleteParticle
  ld  hl,Particle_Sprite
  add hl,bc
  xor a
  ld  [hl],a
  jp  .nextParticle
:
  
  ; Horizontal Movement
  ld  hl,Particle_XVelocityS
  add hl,bc
  ld  a,[hl]
  ld  hl,Particle_XPositionS
  add hl,bc
  add a,[hl]
  ld  [hl],a
  push  af
  ld  hl,Particle_XVelocity
  add hl,bc
  ld  a,[hl]
  ld  d,a
  ld  hl,Particle_XPosition
  add hl,bc
  pop af
  ld  a,d
  adc a,[hl]
  ld  [hl],a
  ; Check Screen Crossing
  bit 7,d                   ; Check Velocity Direction
  jr  z,:+
  jr  c,.xMoveDone
  ; Left edge crossed, decrement screen
  ld  hl,Particle_Screen
  add hl,bc
  ld  a,[hl]                ; Get Parent/Screen byte
  jr  z,.xMoveDone
  dec a
  ld  [hl],a
  jr  .xMoveDone
:
  jr  nc,.xMoveDone
  ; Right edge crossed, increment screen
  ld  hl,Particle_Screen
  add hl,bc
  ld  a,[hl]
  ld  d,a
  ld  a,[Engine_NumScreens]
  cp  d
  jr  z,.xMoveDone
  inc d
  ld  a,d
  ld  [hl],a
.xMoveDone:
  
  ; Vertical Movement
  ld  hl,Particle_YVelocityS
  add hl,bc
  ld  a,[hl]
  ld  hl,Particle_YPosition
  add hl,bc
  add a,[hl]
  ld  [hl],a
  push  af
  ld  hl,Particle_YVelocity
  add hl,bc
  ld  a,[hl]
  ld  d,a
  ld  hl,Particle_YPosition
  add hl,bc
  pop af
  ld  a,d
  adc a,[hl]
  ld  [hl],a
  
  ; On Screen Check
  ld  hl,Particle_XPosition
  add hl,bc
  ld  a,[Engine_CameraX]
  ld  d,a
  ld  a,[hl]
  sub d
  cp  SCRN_X+OFFSCREEN_THRESHOLD
  jr  c,.checkY
  cp  -OFFSCREEN_THRESHOLD
  jr  c,.deleteParticle
.checkY:
  ld  hl,Particle_YPosition
  add hl,bc
  ld  a,[Engine_CameraY]
  ld  d,a
  ld  a,[hl]
  sub d
  cp  SCRN_Y+OFFSCREEN_THRESHOLD
  jr  c,.onScreen
  cp  -OFFSCREEN_THRESHOLD
  jp  c,.deleteParticle
.onScreen:

  ; Collision Check
  ld  hl,Particle_Flags
  add hl,bc
  ld  a,[hl]
  and PARTICLE_COLLIDES
  jr  z,.nextParticle
  ldh [Temp0],a
  
  ; Collision functions use Engine_CurrentScreen when indexing tiles
  ; So this must be set to the screen the particle is in and then
  ; restored after collision is done
  ld  a,[Engine_CurrentScreen]
  ldh [Temp1],a
  and $f0
  ld  d,a
  ld  hl,Particle_Screen
  add hl,bc
  ld  a,[hl]
  or  d
  ld  [Engine_CurrentScreen],a
  
  ld  hl,Particle_XPosition
  add hl,bc
  ld  a,[hl]
  ld  e,a
  ld  hl,Particle_YPosition
  add hl,bc
  ld  a,[hl]
  ld  h,e
  ld  l,a
  push  bc
  call  GetTileCoordinates
  or  a
  ld  e,a
  call  GetTileL
  pop bc
  
  cp  COLLISION_SOLID
  jr  nz,.checkWater
  ldh a,[Temp0]
  bit PARTICLE_FLAG_DSOLID,a
  jr  z,.collideEnd
  ld  hl,Particle_Sprite
  add hl,bc
  xor a
  ld  [hl],a
  jr  .collideEnd
.checkWater:
  cp  COLLISION_WATER
  jr  nz,.collideEnd
  ldh a,[Temp0]
  bit PARTICLE_FLAG_DWATER,a
  jr  z,.collideEnd
  ld  hl,Particle_Sprite
  add hl,bc
  xor a
  ld  [hl],a
.collideEnd:
  ldh a,[Temp1]
  ld  [Engine_CurrentScreen],a
  
.nextParticle:
  dec c
  bit 7,c
  jp  z,.updateLoop
  ret
  
; Generate Particle sprite entries
RenderParticles:
  ld  b,0
  ld  c,PARTICLE_COUNT-1
.renderLoop:
  ld  hl,Particle_Sprite
  add hl,bc
  ld  a,[hl]
  or  a
  jr  z,.nextParticle
  
  ld  hl,Particle_Lifetime
  add hl,bc
  ld  a,[hl]
  cp  PARTICLE_FLICKERTIME
  jr  nc,:+
  bit 0,a
  jr  nz,.nextParticle
:
  
  ld  a,[Engine_CameraY]
  ld  d,a
  ld  hl,Particle_YPosition
  add hl,bc
  ld  a,[hl]
  sub d
  add 8
  ld  d,a
  ld  a,[Engine_CameraX]
  ld  e,a
  ld  hl,Particle_XPosition
  add hl,bc
  ld  a,[hl]
  sub e
  add 4
  ld  e,a
  ld  hl,Particle_Sprite
  add hl,bc
  ld  a,[hl]
  push  bc
  ld  b,a
  ld  c,%00001000
  call  AddSprite
  pop bc
  
.nextParticle:
  dec c
  bit 7,c
  jr  z,.renderLoop
  ret
