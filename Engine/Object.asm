; ==============
; Object System
; ==============

; TODO
; - Object Behaviors
; - Object Sprites
; - Particle Gravity

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
Monster_WRAMPointer:  ds  MONSTER_COUNT
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
Monster_ListIndex:    ds  MONSTER_COUNT

PARTICLE_COUNT  equ 6

PARTICLE_FLICKERTIME      equ 30

PARTICLE_FLAG_DSOLID      equ 0
PARTICLE_FLAG_DWATER      equ 1
PARTICLE_FLAG_GRAVITY     equ 2

PARTICLE_COLLIDES         equ %00000011

PARTICLE_GRAVITY          equ $25

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
SPAWN_THRESHOLD_LEFT  equ 8
SPAWN_THRESHOLD_RIGHT equ 32

section "Object WRAM",wram0,align[8]
Monster_WRAM: ds MONSTER_WRAMSIZE*MONSTER_COUNT

section "Temp Variables",hram
Temp0:
TempID: db
Temp1:
TempS:  db
TempX:  db
TempY:  db

; Monster Behavior functions and behavior jump table
; All behavior functions must preserve bc
section "Object Behvaiors",romx
BehaviorTable:
  dw  Monster_NoBehavior  ; MONSTER_NULL
  dw  Monster_NoBehavior  ; MONSTER_TEST

BehaviorDispatch:
  jp  hl
  
Monster_NoBehavior:
  ret

section "Object System Routines",rom0

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
  
; Spawn initial set of monsters on level load
InitSpawnMonsters:
  ld  a,[Engine_CurrentScreen]    ; Get current screen number
  and $0f                         ; Mask out subarea
  ld  e,a                         ; Save in E
  ld  d,0                         ; Set List Index to 0
  ld  a,[Engine_MapBank]
  ld  b,a
  call  _Bankswitch
  ld  hl,Engine_ObjPointer
  ld  a,[hl+]
  ld  h,[hl]
  ld  l,a
.spawnLoop:
  ld  a,[hl+]           ; Get Object ID
  or  a                 ; Test for 0
  ret z                 ; 0 = End of Object Data
  ldh [TempID],a        ; Save Object ID
  ld  a,[hl+]           ; Get Object Screen
  cp  e                 ; Same as current screen?
  jr  nz,.offScreen     ; If no, don't spawn this object
  ldh [TempS],a         ; Save Screen
  ld  a,[hl+]           ; Get X Position
  ldh [TempX],a         ; Save X Position
  ld  a,[hl+]           ; Get Y Position
  ldh [TempY],a         ; Save Y Position
  push  hl              ; Save object data pointer
  call  GetMonsterSlot  ; Get empty object
  bit 7,c               ; Valid slot number?
  jr  z,:+
  pop hl
  ret                   ; If not, can't spawn more objects
:
  call  InitMonster     ; Set monster fields
  pop hl                ; Restore object data pointer
  inc d                 ; Next object
  jr  .spawnLoop
.offScreen:
  inc hl                ; Advance pointer to next object
  inc hl
  inc d
  jr  .spawnLoop
  
; Spawn monsters from the object list that are currently on screen
SpawnMonsters:
  ld  a,[Engine_MapBank]
  ld  b,a
  call  _Bankswitch
  ld  hl,Engine_ObjPointer
  ld  a,[hl+]
  ld  h,[hl]
  ld  l,a
  ld  d,0                   ; Set List Index to 0
.spawnLoop:
  ld  a,[hl+]               ; Get Object ID
  or  a                     ; Test for 0
  ret z                     ; 0 = End of Object Data
  ldh [TempID],a            ; Save Object ID
  push  hl                  ; Save object data pointer
  ld  bc,MONSTER_COUNT-1
.existLoop:
  ld  hl,Monster_ID         ; Get Monster ID
  add hl,bc
  ld  a,[hl]
  or  a                     ; Is ID 0?
  jr  z,.existNext          ; If yes, is empty object
  ld  hl,Monster_ListIndex  ; Get List Index
  add hl,bc
  ld  a,[hl]
  cp  d                     ; Compare to current list index
  jr  z,.existFound         ; If object already exists don't spawn a copy
.existNext:
  dec c                     ; Next Object slot
  bit 7,c
  jr  z,.existLoop
  jr  .existEnd             ; Object does not already exist
.existFound:
  pop hl                    ; Restore object data pointer
  inc hl                    ; Advance to next entry
  inc hl
  inc hl
  inc d
  jr  .spawnLoop
.existEnd:
  pop hl                    ; Restore object data pointer
  ld  a,[hl+]               ; Get Screen Number
  ldh [TempS],a             ; Save Screen Number
  ld  b,a
  ld  a,[hl+]               ; Get X Position
  ldh [TempX],a             ; Save X Position
  ld  c,a
  ld  a,[Player_XPos]       ; Calculate Player.X - Object.X
  sub c
  push  af
  ld  c,a
  ld  a,[Engine_CurrentScreen]
  and $0f
  ld  e,a
  pop af
  ld  a,e
  sbc b
  ld  b,a
  bit 7,a                   ; Take absolute value if negative
  jr  z,:+
  ld  a,c
  cpl
  add 1
  ld  c,a
  ld  a,b
  cpl
  adc 0
  ld  b,a
:
  or  a
  jr  nz,.noSpawn           ; If distance is over one screen, don't spawn
  ld  a,c                   ; Spawn if distance is between SCRN_X/2+8 and SCRN_X/2+32
  cp  SCRN_X/2+SPAWN_THRESHOLD_LEFT          
  jr  c,.noSpawn
  cp  SCRN_X/2+SPAWN_THRESHOLD_RIGHT
  jr  nc,.noSpawn
  ld  a,[hl+]               ; Get Y Position
  ldh [TempY],a             ; Save Y Position
  push  hl                  ; Save object data pointer
  call  GetMonsterSlot      ; Get free monster slot
  bit 7,c                   ; Slot valid?
  jr  z,:+
  pop hl
  ret                       ; Slot not valid, can't spawn more objects
:
  call InitMonster          ; Set monster fields
  pop hl                    ; Restore object data pointer
  inc d
  jr  .spawnLoop            ; Next entry
.noSpawn:
  inc hl                    ; Advance to next entry
  inc d
  jr  .spawnLoop
  
; Initialize a monster slot
; INPUT:    bc    = Slot Number
;            d    = List Index
;           Temp* = Object ID, X, Y, Screen
InitMonster:
  ldh a,[TempID]        ; Restore Object ID
  ld  [hl],a            ; Set Object ID
  ld  hl,Monster_ParentScreen
  add hl,bc
  ldh a,[TempS]         ; Restore Object Screen
  swap  c               ; Move slot index to top nibble
  or  c                 ; Combine with screen number
  ld  [hl],a            ; Set Parent/Screen byte
  ld  a,c               ; Get shifted slot index (WRAM Pointer)
  swap  c               ; Restore C
  ld  hl,Monster_WRAMPointer
  add hl,bc
  ld  [hl],a            ; Set WRAM Pointer
  ld  hl,Monster_XPosition
  add hl,bc
  ldh a,[TempX]         ; Restore X Position
  ld  [hl],a            ; Set X Position
  ld  hl,Monster_YPosition
  add hl,bc
  ldh a,[TempY]         ; Restore Y Position
  ld  [hl],a            ; Set Y Position
  ld  hl,Monster_ListIndex
  add hl,bc
  ld  a,d               ; Get current list index
  ld  [hl],a            ; Set list index
  xor a                 ; Clear all remaining fields
  ld  hl,Monster_XPositionS
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_YPositionS
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_XVelocity
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_XVelocityS
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_YVelocity
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_YVelocityS
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_Flags
  add hl,bc
  ld  [hl],a
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
  
  ; Type Specific Update
  
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
  jr  c,.nextMonster
  cp  -OFFSCREEN_THRESHOLD
  jr  nc,.nextMonster
  call  DeleteMonster
  jr  .nextMonster
  
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
; OUTPUT:   bc  = Particle Slot Number or $00FF if no slots left
;           hl = Pointer to Particle ID
; TRASHES:  a
GetParticleSlot:
  ld  hl,Particle_Sprite+PARTICLE_COUNT-1
  lb  bc,0,PARTICLE_COUNT-1
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
  or  a
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
  ld  hl,Particle_Flags
  add hl,bc
  ld  a,[hl]
  bit PARTICLE_FLAG_GRAVITY,a
  jr  z,:+
  ld  hl,Particle_YVelocityS
  add hl,bc
  ld  a,[hl]
  add PARTICLE_GRAVITY
  ld  [hl],a
  jr  nc,:+
  ld  hl,Particle_YVelocity
  add hl,bc
  inc [hl]
:
  ld  hl,Particle_YVelocityS
  add hl,bc
  ld  a,[hl]
  ld  hl,Particle_YPositionS
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
  ld  hl,Particle_Attribute
  add hl,bc
  ld  a,[hl]
  ldh [Temp0],a
  ld  hl,Particle_Sprite
  add hl,bc
  ld  a,[hl]
  push  bc
  ld  b,a
  ldh a,[Temp0]
  ld  c,a
  call  AddSprite
  pop bc
  
.nextParticle:
  dec c
  bit 7,c
  jr  z,.renderLoop
  ret
