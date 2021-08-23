; ==============
; Object System
; ==============

; TODO
; - Object Behaviors
; - Object Sprites

section "Object Memory",wram0

MONSTER_COUNT               equ 16 ; maximum number of monster slots
MONSTER_WRAMSIZE            equ 16 ; dedicated memory for each monster

MONSTER_FLAG_CPLAYER        equ 0 ; Collides with player
MONSTER_FLAG_CWORLD         equ 1 ; Collides with world
MONSTER_FLAG_GRAVITY        equ 2 ; Affected by gravity
MONSTER_FLAG_FLIPH          equ 5 ; Horizontal mirroring
MOSNTER_FLAG_FLIPV          equ 6 ; Vertical mirroring

MONSTER_HITBOXSIZE          equ 6

MONSTER_GRAVITY             equ $25

MONSTER_COLLISION_LEFT      equ 0 ; Colliding with a wall to the left
MONSTER_COLLISION_RIGHT     equ 1 ; Colliding with a wall to the right
MONSTER_COLLISION_UP        equ 2 ; Colliding with a ceiling
MONSTER_COLLISION_DOWN      equ 3 ; Colliding with a floor
MONSTER_COLLISION_PLAYER    equ 4 ; Colliding with the player

MONSTER_COLLISION_HORIZ     equ %00000011 ; Colliding with a wall
MONSTER_COLLISION_VERT      equ %00001100 ; Colliding with a floor or ceiling

; Monster IDs
MONSTER_NULL                equ 0
MONSTER_TEST                equ 1
MONSTER_TEST2               equ 2

Monster_ID:                 ds  MONSTER_COUNT
Monster_WRAMPointer:        ds  MONSTER_COUNT
Monster_ParentScreen:       ds  MONSTER_COUNT ; Parent Object = High Nibble, Screen Index = Low Nibble
Monster_Flags:              ds  MONSTER_COUNT
Monster_Collision:          ds  MONSTER_COUNT
Monster_XPosition:          ds  MONSTER_COUNT
Monster_XPositionS:         ds  MONSTER_COUNT
Monster_YPosition:          ds  MONSTER_COUNT
Monster_YPositionS:         ds  MONSTER_COUNT
Monster_XVelocity:          ds  MONSTER_COUNT
Monster_XVelocityS:         ds  MONSTER_COUNT
Monster_YVelocity:          ds  MONSTER_COUNT
Monster_YVelocityS:         ds  MONSTER_COUNT
Monster_AnimBank:           ds  MONSTER_COUNT
Monster_AnimPtrHi:          ds  MONSTER_COUNT
Monster_AnimPtrLo:          ds  MONSTER_COUNT
Monster_AnimTimer:          ds  MONSTER_COUNT
Monster_ListIndex:          ds  MONSTER_COUNT

PARTICLE_COUNT              equ 6 ; maximum number of particle slots

PARTICLE_FLICKERTIME        equ 30 ; particles will flicker when their lifetime is smaller than this

PARTICLE_FLAG_DSOLID        equ 0 ; Destroyed when colliding with a solid tile
PARTICLE_FLAG_DWATER        equ 1 ; Destroyed when colliding with water
PARTICLE_FLAG_GRAVITY       equ 2 ; Affected by gravity

PARTICLE_COLLIDES           equ %00000011 ; Destroyed when colliding with water or a solid tile

PARTICLE_GRAVITY            equ $25

Particle_Sprite:            ds  PARTICLE_COUNT
Particle_Attribute:         ds  PARTICLE_COUNT
Particle_Flags:             ds  PARTICLE_COUNT
Particle_Screen:            ds  PARTICLE_COUNT
Particle_Lifetime:          ds  PARTICLE_COUNT ; 0 = Infinite
Particle_XPosition:         ds  PARTICLE_COUNT
Particle_XPositionS:        ds  PARTICLE_COUNT
Particle_YPosition:         ds  PARTICLE_COUNT
Particle_YPositionS:        ds  PARTICLE_COUNT
Particle_XVelocity:         ds  PARTICLE_COUNT
Particle_XVelocityS:        ds  PARTICLE_COUNT
Particle_YVelocity:         ds  PARTICLE_COUNT
Particle_YVelocityS:        ds  PARTICLE_COUNT

OFFSCREEN_THRESHOLD         equ 32 ; Number of pixels until object is considered offscreen
SPAWN_THRESHOLD_LEFT        equ 8 ; Number of pixels objects will spawn offscreen to the left
SPAWN_THRESHOLD_RIGHT       equ 32 ; Number of pixels objects will spawn offscreen to the right

section "Object WRAM",wram0,align[8]
Monster_WRAM: ds MONSTER_WRAMSIZE*MONSTER_COUNT

section "Temp Variables",hram
Temp0:
TempID: db
Temp1:
TempS:  db
TempX:  db
TempY:  db

minit:  macro
    dw  \1,\2
    db  \3
    endm

; Monster type init data
; Format: XVelocityS, XVelocity, YVelocityS, YVelocity, Flags
section "Object Init Data",romx
ObjectInit:
    minit   $100,$000,1<<MONSTER_FLAG_CWORLD | 1<<MONSTER_FLAG_GRAVITY ; MONSTER_TEST
    minit   $080,$000,1<<MONSTER_FLAG_CWORLD | 1<<MONSTER_FLAG_CPLAYER | 1<<MONSTER_FLAG_GRAVITY ; MONSTER_TEST2

; Monster Behavior functions and behavior jump table
; All behavior functions must preserve bc
; INPUT:  bc = Slot Number
section "Object Behvaiors",romx
BehaviorTable:
    dw      Monster_NoBehavior      ; MONSTER_NULL
    dw      Monster_TestBehavior    ; MONSTER_TEST
    dw      Monster_MoveLeftRight   ; MONSTER_TEST2

BehaviorDispatch:
    bit     7,h
    ret     nz  ; return if pointer is outside ROM
    jp      hl
  
Monster_NoBehavior:
    ret
  
Monster_TestBehavior:
    ld      hl,Monster_Collision
    add     hl,bc
    ld      a,[hl]
    ld      e,a
    and     MONSTER_COLLISION_HORIZ
    jr      z,:+
    xor     a
    ld      hl,Monster_XVelocity
    add     hl,bc 
    ld      [hl],a
    ld      hl,Monster_XVelocityS
    add     hl,bc
    ld      [hl],a
:
    ld      a,e
    and     MONSTER_COLLISION_VERT
    jr      z,:+
    xor     a
    ld      hl,Monster_YVelocity
    add     hl,bc
    ld      [hl],a
    ld      hl,Monster_YVelocityS
    add     hl,bc
    ld      [hl],a
:
    ret
  
Monster_MoveLeftRight:
    ld      hl,Monster_Collision
    add     hl,bc
    ld      a,[hl]
    ld      e,a
    and     MONSTER_COLLISION_HORIZ
    jr      z,:+
    ld      hl,Monster_XVelocity
    add     hl,bc
    ld      a,[hl]
    cpl
    ld      [hl+],a
    ld      a,[hl]
    cpl
    inc     a
    ld      [hl],a
:
    ld      a,e
    and     MONSTER_COLLISION_VERT
    jr      z,:+
    xor     a
    ld      hl,Monster_YVelocity
    add     hl,bc
    ld      [hl],a
    ld      hl,Monster_YVelocityS
    add     hl,bc
    ld      [hl],a
:
    bit     MONSTER_COLLISION_PLAYER,e
    jr      z,:+
    ld      b,b
:
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
  ld  b,a
  ld  a,[Engine_CameraX]; Get Camera X
  add SCRN_X/2          ; Find center
  sub b                 ; Calculate x distance
  bit 7,a
  jr  z,:+
  cpl
  inc a
:
  cp  SCRN_X/2+SPAWN_THRESHOLD_LEFT
  jr  c,:+
  inc hl
  inc d
  jr  .spawnLoop
:
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
  ld  a,[Engine_CameraX]    ; Calculate Camera Center - Object X
  add SCRN_X/2
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
  push  de
  ldh a,[TempID]        ; Get Object ID
  dec a                 ; Init data starts at Object 1
  ld  e,a               ; Calculate ID * 5
  sla a
  sla a
  add e
  push  bc
  ldfar de,ObjectInit   ; Load fields from object type init data
  pop bc
  add e
  ld  e,a
  jr  nc,:+
  inc d
:
  ld  a,[de]
  ld  hl,Monster_XVelocityS
  add hl,bc
  ld  [hl],a
  inc de
  ld  a,[de]
  ld  hl,Monster_XVelocity
  add hl,bc
  ld  [hl],a
  inc de
  ld  a,[de]
  ld  hl,Monster_YVelocityS
  add hl,bc
  ld  [hl],a
  inc de
  ld  a,[de]
  ld  hl,Monster_YVelocity
  add hl,bc
  ld  [hl],a
  inc de
  ld  a,[de]
  ld  hl,Monster_Flags
  add hl,bc
  ld  [hl],a
  pop de
  xor a                 ; Clear all remaining fields
  ld  hl,Monster_XPositionS
  add hl,bc
  ld  [hl],a
  ld  hl,Monster_YPositionS
  add hl,bc
  ld  [hl],a
  resbank
  ret
  
; Update all Monsters
UpdateMonsters:
  ; Save current screen
  ld  a,[Engine_CurrentScreen]
  ldh [Temp0],a

  ld  b,0
  ld  c,MONSTER_COUNT-1
.updateLoop:
  ld  hl,Monster_ID   ; Monster ID Pointer
  add hl,bc           ; Point to this Monster
  ld  a,[hl]          ; Get ID
  or  a
  jp  z,.nextMonster  ; 0 = No Monster
  
  ; Type Specific Update
  ldfar hl,BehaviorTable
  ld  b,0
  ld  d,0
  sla a
  ld  e,a
  jr  nc,:+
  inc d
:
  add hl,de
  ld  a,[hl+]
  ld  e,a
  ld  d,[hl]
  ld  h,d
  ld  l,e
  call  BehaviorDispatch
  
  ; Clear Collision Flags
  ld  hl,Monster_Collision
  add hl,bc
  ld  [hl],0
  
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

  ; Set current screen for this monster
  ld  hl,Monster_ParentScreen
  add hl,bc
  ldh a,[Temp0]
  xor [hl]
  and $f0
  xor [hl]
  ld  [Engine_CurrentScreen],a

  ; Horizontal Collision
  ld  hl,Monster_Flags
  add hl,bc
  bit MONSTER_FLAG_CWORLD,[hl]
  jp  z,.xCollideEnd
  
  ld  hl,Monster_XVelocity
  add hl,bc
  bit 7,[hl]
  jr  z,.checkRight
  ; Check Left Collision
  ; Top Left
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileL
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jr  z,:+
  ; Bottom Left
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileL
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jp  nz,.xCollideEnd
:
  ; Collision with left wall
  ; Set collision flag
  ld  hl,Monster_Collision
  add hl,bc
  set MONSTER_COLLISION_LEFT,[hl]
  ; Calculate penetration depth
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  and $0f
  ld  e,a
  ld  a,16
  sub e
  ; Push out of tile
  add [hl]
  ld  [hl],a
  ; Check screen crossing
  jp  nc,.xCollideEnd
  ; Right edge crossed
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]
  and $0f
  ld  e,a
  ld  a,[Engine_NumScreens]
  cp  e
  jr  z,.xCollideEnd
  inc [hl]
  jr  .xCollideEnd
.checkRight:
  ; Check Right Collision
  ; Top Right
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileR
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jr  z,:+
  ; Bottom Right
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileR
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jr  nz,.xCollideEnd
:
  ; Collision with right wall
  ; Set collision flag
  ld  hl,Monster_Collision
  add hl,bc
  set MONSTER_COLLISION_RIGHT,[hl]
  ; Calculate penetration depth
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  and $0f
  inc a
  ld  e,a
  ld  a,[hl]
  ; Push out of tile
  sub e
  ld  [hl],a
  ; Check screen crossing
  jr  nc,.xCollideEnd
  ; Left edge crossed
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]
  and $0f
  jr  z,.xCollideEnd
  dec [hl]
.xCollideEnd:
  
  ; Vertical Movement
  ld  hl,Monster_Flags          ; Monster Flags Pointer
  add hl,bc                     ; Point to this Monster
  bit MONSTER_FLAG_GRAVITY,[hl] ; Apply Gravity?
  jr  z,:+
  ld  hl,Monster_YVelocityS
  add hl,bc
  ld  a,[hl]
  add MONSTER_GRAVITY
  push  af
  ld  [hl],a
  ld  hl,Monster_YVelocity
  add hl,bc
  pop af
  jr  nc,:+
  inc [hl]
:
  ld  hl,Monster_YVelocityS     ; Monster Y Velocity Sub Pointer
  add hl,bc                     ; Point to this Monster
  ld  a,[hl]                    ; Get Y Velocity Sub
  ld  hl,Monster_YPositionS     ; Monster Y Position Sub Pointer
  add hl,bc                     ; Point to this Monster
  add a,[hl]                    ; Add Y Position Sub
  ld  [hl],a                    ; Store new Y Position Sub
  push  af                      ; Save Carry Flag
  ld  hl,Monster_YVelocity      ; Monster Y Velocity Pointer
  add hl,bc                     ; Point to this Monster
  ld  a,[hl]                    ; Get Y Velocity
  ld  d,a                       ; Save Y Velocity
  ld  hl,Monster_YPosition      ; Monster Y Position Pointer
  add hl,bc                     ; Point to this Monster
  pop af                        ; Restore Carry Flag
  ld  a,d                       ; Restore Y Velocity
  adc a,[hl]                    ; Add Y Position + Carry
  ld  [hl],a                    ; Store new Y Position
  
  ; Vertical Collision
  ld  hl,Monster_Flags
  add hl,bc
  bit MONSTER_FLAG_CWORLD,[hl]
  jp  z,.yCollideEnd
  
  ld  hl,Monster_YVelocity
  add hl,bc
  bit 7,[hl]
  jr  z,.checkDown
  ; Check Top Collision
  ; Top Left
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileL
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jr  z,:+
  ; Top Right
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileR
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jp  nz,.yCollideEnd
:
  ; Collision with ceiling
  ; Set collision flag
  ld  hl,Monster_Collision
  add hl,bc
  set MONSTER_COLLISION_UP,[hl]
  ; Calculate penetration depth
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  and $0f
  ld  e,a
  ld  a,16
  sub e
  ; Push out of tile
  add [hl]
  ld  [hl],a
  jr  .yCollideEnd
.checkDown:
  ; Check Bottom Collision
  ; Bottom Left
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  sub MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileL
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jr  z,:+
  cp  COLLISION_TOPSOLID
  jr  z,:+
  ; Bottom Right
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  e,a
  push  af
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  ld  h,e
  ld  l,a
  ld  a,c
  ldh [Temp1],a
  call  GetTileCoordinates
  ld  e,a
  pop af
  call  GetTileL
  ld  e,a
  ldh a,[Temp1]
  ld  c,a
  ld  b,0
  ld  a,e
  cp  COLLISION_SOLID
  jr  z,:+
  cp  COLLISION_TOPSOLID
  jr  nz,.yCollideEnd
:
  ; Collision with floor
  ; Set collision flag
  ld  hl,Monster_Collision
  add hl,bc
  set MONSTER_COLLISION_DOWN,[hl]
  ; Calculate penetration depth
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[hl]
  add MONSTER_HITBOXSIZE
  and $0f
  inc a
  ld  e,a
  ld  a,[hl]
  ; Push out of tile
  sub e
  ld  [hl],a
.yCollideEnd:
  
  ; On Screen Check
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[Engine_CameraX]
  ld  d,a
  ld  a,[hl]
  sub d
  cp  SCRN_X+OFFSCREEN_THRESHOLD
  jr  c,:+
  cp  -OFFSCREEN_THRESHOLD
  jr  nc,:+
  call  DeleteMonster
:
  
  ; Player Collision
  ld  hl,Monster_Flags
  add hl,bc
  bit MONSTER_FLAG_CPLAYER,[hl]
  jr  z,.nextMonster
  
  ld  hl,Monster_XPosition
  add hl,bc
  ld  a,[Player_XPos]
  sub [hl]
  push  af
  ld  e,a
  ld  hl,Monster_ParentScreen
  add hl,bc
  ld  a,[hl]
  and $0f
  ld  d,a
  ldh a,[Temp0]
  and $0f
  ldh [Temp1],a
  pop af
  ldh a,[Temp1]
  sbc d
  bit 7,a
  jr  z,:+
  ld  d,a
  ld  a,e
  cpl
  add 1
  ld  e,a
  ld  a,d
  cpl
  adc 0
:
  or  a
  jr  nz,.nextMonster
  ld  a,e
  cp  MONSTER_HITBOXSIZE+Player_HitboxSize
  jr  nc,.nextMonster
  ld  hl,Monster_YPosition
  add hl,bc
  ld  a,[Player_YPos]
  sub [hl]
  bit 7,a
  jr  z,:+
  cpl
  add 1
:
  cp  MONSTER_HITBOXSIZE+Player_HitboxSize
  jr  nc,.nextMonster
  ld  hl,Monster_Collision
  add hl,bc
  set MONSTER_COLLISION_PLAYER,[hl]
  
.nextMonster
  dec c
  bit 7,c
  jp  z,.updateLoop
  ldh a,[Temp0]
  ld  [Engine_CurrentScreen],a
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
