; ==============
; Object System
; ==============

; TODO
; - Object Rendering
; - Object Behaviors
; - Particle Update
; - Particle Rendering
; - Off Screen Check
; - Object Deletion

section "Object Memory",wram0

MONSTER_COUNT     equ 16
MONSTER_WRAMSIZE  equ 16

MONSTER_FLAG_HITPLAYER    equ 0
MONSTER_FLAG_HITBYPLAYER  equ 1
MONSTER_FLAG_FLIPH        equ 5
MOSNTER_FLAG_FLIPV        equ 6

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

PARTICLE_FLAG_DSOLID      equ 0
PARTICLE_FLAG_DWATER      equ 1

Particle_Sprite:      ds  PARTICLE_COUNT
Particle_Attribute:   ds  PARTICLE_COUNT
Particle_Flags:       ds  PARTICLE_COUNT
Particle_Screen:      ds  PARTICLE_COUNT
Particle_Lifetime:    ds  PARTICLE_COUNT ; 0 = Infinite
Particle_XPosition:   ds  PARTICLE_COUNT
Partcile_XPositionS:  ds  PARTICLE_COUNT
Particle_YPosition:   ds  PARTICLE_COUNT
Particle_YPositionS:  ds  PARTICLE_COUNT
Particle_XVelocity:   ds  PARTICLE_COUNT
Particle_XVelocityS:  ds  PARTICLE_COUNT
Particle_YVelocity:   ds  PARTICLE_COUNT
Particle_YVelocityS:  ds  PARTICLE_COUNT

section "Object WRAM",wram0,align[256]
Monster_WRAM: ds MONSTER_WRAMSIZE*MONSTER_COUNT

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
  xor a
  ld  b,a
  ld  c,MONSTER_COUNT-1
.updateLoop:
  ld  hl,Monster_ID   ; Monster ID Pointer
  add hl,bc           ; Point to this Monster
  ld  a,[hl]          ; Get ID
  or  a
  jr  z,.nextMonster  ; 0 = No Monster
  ; Type Specific Update - TODO
  
  ; Check Parent
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]                ; Get Parent/Screen byte
  swap  a                   ; Move Parent to low nibble
  and $0f                   ; Mask out screen value
  cp  c                     ; Compare to current slot number
  jr  nz,.nextMonster       ; If this is a child object, don't do movement
  
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
  
  ; On Screen Check - TODO
.nextMonster
  dec c
  bit 7,c
  jr  z,.updateLoop
  ret
  
; Generate Monster sprite entries
; TODO - Remove placeholder sprite
RenderMonsters:
  xor a
  ld  b,a
  ld  c,MONSTER_COUNT-1
.renderLoop:
  ld  hl,Monster_ID
  add hl,bc
  ld  a,[hl]
  or  a
  jr  z,.nextMonster
  ld  a,[Engine_CameraY]
  ld  d,a
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  sub d
  add 8
  ld  d,a
  ld  a,[Engine_CameraX]
  ld  e,a
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  sub e
  ld  e,a
  push  bc
  ld  b,0
  ld  c,%00001000
  push  hl
  call  AddSprite
  ld  a,e
  add 8
  ld  e,a
  inc b
  inc b
  call  AddSprite
  pop hl
  pop bc
.nextMonster:
  dec c
  bit 7,c
  jr  z,.renderLoop
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
; OUTPUT:   c  = Particle Slot Number or -1 if no slots left
;           hl = Pointer to Particle ID
; TRASHES:  a
GetParticleSlot:
  ld  hl,Particle_Sprite+PARTICLE_COUNT-1
  ld  c,PARTICLE_COUNT-1
:
  ld  a,[hl]
  or  a
  ret z
  dec hl
  dec c
  bit 7,c
  jr  z,:-
  ret 
