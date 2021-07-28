; ==================
; Player RAM defines
; ==================

section "Player RAM",wram0
PlayerRAM:

Player_MovementFlags::  db  ; bit 0 = moving, bit 7 = dir (0 = left, 1 = right)
Player_XPos::           db  ; current X position
Player_XSubpixel::      db  ; current X subpixel
Player_YPos::           db  ; current Y position
Player_YSubpixel::      db  ; current Y subpixel
Player_XVelocity::      db  ; current X velocity
Player_XVelocityS::     db  ; current X fractional velocity
Player_YVelocity::      db  ; current Y velocity
Player_YVelocityS::     db  ; current Y fractional velocity
Player_LastBounceY::    db  ; last bounce Y position (absolute)
Player_AnimPointer::    dw  ; pointer to current animation sequence
Player_AnimTimer::      db  ; time until next animation frame is displayed (if -1, frame will be displayed indefinitely)
Player_CurrentFrame::   db  ; current animation frame being displayed

; the following are used for collision checks
Player_TopLeftTile:     db
Player_TopRightTile:    db
Player_BottomLeftTile:  db
Player_BottomRightTile: db
Player_CenterTile:      db

PlayerRAM_End:

Player_MaxSpeed         equ $180
Player_Accel            equ $30
Player_Decel            equ $15
Player_Gravity          equ $25
Player_BounceHeight     equ -$380
Player_HighBounceHeight equ -$440
Player_LowBounceHeight  equ -$200
Player_TerminalVelocity equ $600
Player_HitboxSize       equ 6

; ========================
; Player animation defines
; ========================

F_Player_Idle           equ 0
F_Player_Idle_Blink1    equ 1
F_Player_Idle_Blink2    equ 2
F_Player_Idle_Blink3    equ 3
F_Player_Idle_Blink4    equ 4

F_Player_Left1          equ 8
F_Player_Left1_Blink1   equ 9
F_Player_Left1_Blink2   equ 10
F_Player_Left1_Blink3   equ 11
F_Player_Left1_Blink4   equ 12

F_Player_Left2          equ 16
F_Player_Left2_Blink1   equ 17
F_Player_Left2_Blink2   equ 18
F_Player_Left2_Blink3   equ 19
F_Player_Left2_Blink4   equ 20

F_Player_Right1         equ 24
F_Player_Right1_Blink1  equ 25
F_Player_Right1_Blink2  equ 26
F_Player_Right1_Blink3  equ 27
F_Player_Right1_Blink4  equ 28

F_Player_Right2         equ 32
F_Player_Right2_Blink1  equ 33
F_Player_Right2_Blink2  equ 34
F_Player_Right2_Blink3  equ 35
F_Player_Right2_Blink4  equ 36

F_Player_Win            equ 5
F_Player_Hurt1          equ 6
F_Player_Hurt2          equ 7
F_Player_Angry          equ 13
F_Player_Sad            equ 14
F_Player_Surprise       equ 15
F_Player_LookUp         equ 21
F_Player_LookDown       equ 22

; ===============
; Player routines
; ===============

section "Player routines",rom0

InitPlayer:
    ; init RAM
    ld      hl,PlayerRAM
    ld      b,PlayerRAM_End-PlayerRAM
    xor     a
    call    _FillRAMSmall
    ; initialize animation pointer
    ld      a,low(Anim_Player_Idle)
    ld      [Player_AnimPointer],a
    ld      a,high(Anim_Player_Idle)
    ld      [Player_AnimPointer+1],a
    ; initialize animation timer
    ld      a,-1
    ld      [Player_AnimTimer],a
    ; load player palette
    ldfar   hl,Pal_Player
    ld      a,8
    call    LoadPal
    ret

; ========

ProcessPlayer:
    ; Player Input
    ld      b,0
    ld      a,[sys_btnHold]
    bit     btnLeft,a
    jr      z,.noLeft
    ld      b,-1
.noLeft:
    bit     btnRight,a
    jr      z,.noRight
    ld      b,1
.noRight:
    ld      a,b
    ld      [Player_XVelocity],a
    
    ld      a,[sys_btnHold]
    bit     btnStart,a
    jr      z,:+
    push    af
    call    PalFadeInBlack
    pop     af
:
    bit     btnSelect,a
    jr      z,:+
    call    PalFadeOutBlack
:

    ; Horizontal Movement
    ; Movement
    ld      a,[Player_XVelocity]
    ld      h,a
    ld      a,[Player_XVelocityS]
    ld      l,a
    ld      a,[Player_XPos]
    ld      d,a
    ld      a,[Player_XSubpixel]
    ld      e,a
    add     hl,de
    ld      a,h
    ld      [Player_XPos],a
    ld      a,l
    ld      [Player_XSubpixel],a
    ; Check Screen Crossing
    ld      a,[Player_XVelocity]
    bit     7,a
    jr      z,:+
    jr      c,.xMoveDone
    ; Left edge crossed, decrement current screen
    ld      a,[Engine_CurrentScreen]
    and     $30
    ld      b,a
    ld      a,[Engine_CurrentScreen]
    and     $f
    sub     1
    jr      c,.xMoveDone
    or      b
    ld      [Engine_CurrentScreen],a
    jr      .xMoveDone
:
    jr      nc,.xMoveDone
    ; Right edge crosses, increment current screen
    ld      a,[Engine_CurrentScreen]
    and     $30
    ld      b,a
    ld      a,[Engine_CurrentScreen]
    push    bc
    ld      b,a
    ld      a,[Engine_NumScreens]
    cp      b
    ld      a,b
    pop     bc
    jr      z,.xMoveDone
    inc     a
    or      b
    ld      [Engine_CurrentScreen],a
.xMoveDone:

    ; Horizontal Collision
    ld      a,[Player_XVelocity]
    bit     7,a
    jr      z,.rightCollision
    ; Check Left Collision
    ; Top Left
    ld      a,[Player_YPos]
    sub     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    sub     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileL
    cp      4
    jr      z,:+
    ; Bottom Left
    ld      a,[Player_YPos]
    add     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    sub     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileL
    cp      4
    jp      nz,.xCollideEnd
:
    ; Collision with left wall
    ; Clear Velocity
    xor     a
    ld      [Player_XVelocity],a
    ld      [Player_XVelocityS],a
    ; Calculate penetration depth
    ld      a,[Player_XPos]
    ld      c,a
    sub     Player_HitboxSize
    and     $f
    ld      b,a
    ld      a,16
    sub     b
    ; Push player out of tile
    add     c
    ld      [Player_XPos],a
    ; Check Screen Crossing
    jr      nc,.xCollideEnd
    ; Right edge crosses, increment current screen
    ld      a,[Engine_CurrentScreen]
    and     $30
    ld      b,a
    ld      a,[Engine_CurrentScreen]
    push    bc
    ld      b,a
    ld      a,[Engine_NumScreens]
    cp      b
    ld      a,b
    pop     bc
    jr      z,.xCollideEnd
    inc     a
    or      b
    ld      [Engine_CurrentScreen],a
    jr      .xCollideEnd
.rightCollision:
    ; Check Right Collision
    ; Top Right
    ld      a,[Player_YPos]
    sub     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    add     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileR
    cp      4
    jr      z,:+
    ; Bottom Right
    ld      a,[Player_YPos]
    add     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    add     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileR
    cp      4
    jr      nz,.xCollideEnd
:
    ; Collision with right wall
    ; Clear Velocity
    xor     a
    ld      [Player_XVelocity],a
    ld      [Player_XVelocityS],a
    ; Calculate penetration depth
    ld      a,[Player_XPos]
    push    af
    add     Player_HitboxSize
    and     $f
    inc     a
    ld      b,a
    pop     af
    ; Push player out of tile
    sub     b
    ld      [Player_XPos],a
    ; Check Screen Crossing
    jr      nc,.xCollideEnd
    ; Left edge crossed, decrement current screen
    ld      a,[Engine_CurrentScreen]
    and     $30
    ld      b,a
    ld      a,[Engine_CurrentScreen]
    and     $f
    sub     1
    jr      c,.xCollideEnd
    or      b
    ld      [Engine_CurrentScreen],a
.xCollideEnd:
    
    ; Vertical Movement
    ; Gravity Acceleration
    ld      a,[Player_YVelocity]
    ld      h,a
    ld      a,[Player_YVelocityS]
    ld      l,a
    ld      de,Player_Gravity
    add     hl,de
    ld      a,h
    bit     7,a
    jr      nz,:+
    ld      b,h
    ld      c,l
    ld      de,Player_TerminalVelocity
    call    Compare16
    jr      c,:+
    ld      hl,Player_TerminalVelocity
:
    ld      a,h
    ld      [Player_YVelocity],a
    ld      a,l
    ld      [Player_YVelocityS],a
    ; Velocity
    ld      a,[Player_YSubpixel]
    add     l
    ld      [Player_YSubpixel],a
    ld      a,[Player_YPos]
    adc     h
    ld      [Player_YPos],a
    
    ; Vertical Collision
    ld      a,[Player_YVelocity]
    bit     7,a
    jr      z,.bottomCollision
    ; Check Top Collision
    ; Top Left
    ld      a,[Player_YPos]
    sub     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    sub     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileL
    cp      4
    jr      z,:+
    ; Top Right
    ld      a,[Player_YPos]
    sub     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    add     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileR
    cp      4
    jr      nz,.yCollideEnd
:
    ; Collision with ceiling
    ; Clear Velocity
    xor     a
    ld      [Player_YVelocity],a
    ld      [Player_YVelocityS],a
    ; Calculate penetration depth
    ld      a,[Player_YPos]
    ld      c,a
    sub     Player_HitboxSize
    and     $f
    ld      b,a
    ld      a,16
    sub     b
    ; Push player out of tile
    add     c
    ld      [Player_YPos],a
    jr      .yCollideEnd
.bottomCollision:
    ; Check Bottom Collision
    ; Bottom Left
    ld      a,[Player_YPos]
    add     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    sub     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileL
    cp      4
    jr      z,:+
    ld      a,[Player_YPos]
    add     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    add     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileR
    cp      4
    jr      nz,.yCollideEnd
:
    ; Collision with floor
    ; Calculate penetration depth
    ld      a,[Player_YPos]
    push    af
    add     Player_HitboxSize
    and     $f
    inc     a
    ld      b,a
    pop     af
    ; Push player out of tile
    sub     b
    ld      [Player_YPos],a
    ; Bounce
    call    Player_Bounce
.yCollideEnd:
    jp    AnimatePlayer
    
Player_UpdateCollision::
    ; center tile
    ld      a,[Player_YPos]
    ld      l,a
    ld      a,[Player_XPos]
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    and     a   ; clear carry
    call    GetTileL
    ld      [Player_CenterTile],a
    ; top left corner
    ld      a,[Player_YPos]
    sub     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    sub     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileL
    ld      [Player_TopLeftTile],a
    ; top right corner
    ld      a,[Player_YPos]
    sub     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    add     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileR
    ld      [Player_TopRightTile],a
    ; bottom left corner
    ld      a,[Player_YPos]
    add     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    sub     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileL
    ld      [Player_BottomLeftTile],a
    ; bottom right corner
    ld      a,[Player_YPos]
    add     Player_HitboxSize
    ld      l,a
    ld      a,[Player_XPos]
    add     Player_HitboxSize
    push    af
    ld      h,a
    call    GetTileCoordinates
    ld      e,a
    pop     af
    call    GetTileR
    ld      [Player_BottomRightTile],a
    ret

Player_SpeedToPos::
    ; ld      a,[Player_XVelocityS]
    ; ld      b,a
    ; ld      a,[Player_XSubpixel]
    ; add     b
    ; ld      [Player_XSubpixel],a
    ; ld      a,[Player_XPos]
    ; jr      nc,.noincX
    ; inc     a
    ; ld      [Player_XPos],a
; .noincX
    ; ld      a,[Player_XVelocity]
    ; ld      b,a
    ; ld      a,[Player_XPos]
    ; add     b
    ; ld      b,a
    
    ; ; check for X pos overflow
    ; ld      a,[Player_MovementFlags]
    ; bit     7,a             ; are we moving right?
    ; jr      nz,.checkright
; .checkleft                  ; if we're moving left...
    ; jr      nc,.skipX
    ; ld      a,[Engine_CurrentSubarea]
    ; and     $30
    ; ld      b,a
    ; ld      a,[Engine_CurrentScreen]
    ; dec     a
    ; and     $f
    ; or      b
    ; ld      [Engine_CurrentScreen],a
    ; jr      .skipX
; .checkright                 ; if we're moving right...
    ; jr      nc,.skipX
    ; ld      a,[Engine_CurrentSubarea]
    ; and     $30
    ; ld      b,a
    ; ld      a,[Engine_CurrentScreen]
    ; inc     a
    ; and     $f
    ; or      b
    ; ld      [Engine_CurrentScreen],a
    ; ; fall through
    
; .skipX
    ; gravity
    ld      a,[Player_YVelocityS]
    add     Player_Gravity
    ld      b,a
    ld      [Player_YVelocityS],a
    jr      nc,.skipgrav
    ld      a,[Player_YVelocity]
    ld      b,a
    inc     a
    ld      [Player_YVelocity],a
.skipgrav
    ld      a,[Player_YSubpixel]
    add     b
    ld      [Player_YSubpixel],a
    ld      a,[Player_YPos]
    jr      nc,.noincY
    inc     a
.noincY
    ld      b,a
    ld      a,[Player_YVelocity]
    add     b
    ld      [Player_YPos],a
    
    ret
    
Player_Bounce:
    xor     a
    ld      [Player_YSubpixel],a    ; reset subpixel
    ld      a,[Player_LastBounceY]
    add     7
    ld      b,a
    ld      a,[Player_YPos]
    add     7
    ld      [Player_LastBounceY],a
    push    af
    cp      b                       ; compare previous bounce Y with current bounce Y
    jr      nc,.skipcamtrack        ; if old Y < new Y, skip tracking
    ld      a,1
    ld      [Engine_CameraIsTracking],a
.skipcamtrack
    pop     af
.checkup
    sub     SCRN_Y / 2
    jr      nc,.checkdown
    xor     a
    jr      .setcamy
.checkdown
    cp      256 - SCRN_Y
    jr      c,.setcamy
    ld      a,256 - SCRN_Y
.setcamy
    and     %11110000
    ld      [Engine_BounceCamTarget],a

    ld      a,[sys_btnHold]
    bit     btnA,a
    jr      nz,.highbounce
    bit     btnB,a
    jr      nz,.lowbounce
.normalbounce
    ld      a,high(Player_BounceHeight)
    ld      [Player_YVelocity],a
    ld      a,low(Player_BounceHeight)
    ld      [Player_YVelocityS],a
    ret
.lowbounce
    ld      a,high(Player_LowBounceHeight)
    ld      [Player_YVelocity],a
    ld      a,low(Player_LowBounceHeight)
    ld      [Player_YVelocityS],a
    ret
.highbounce
    ld      a,high(Player_HighBounceHeight)
    ld      [Player_YVelocity],a
    ld      a,low(Player_HighBounceHeight)
    ld      [Player_YVelocityS],a
    ret
    
; ========
    
DrawPlayer:
    ; load correct frame in player VRAM area
    ld      a,[Player_CurrentFrame]
    add     a
    add     a
    ld      l,a
    ld      h,0
    add     hl,hl   ; x2
    add     hl,hl   ; x4
    add     hl,hl   ; x8
    add     hl,hl   ; x16
    ldfar   de,PlayerTiles
    add     hl,de
    ld      b,$40
    ld      de,$8000
    ld      a,1
    ldh     [rVBK],a
.loadtiles
    ldh     a,[rSTAT]
    and     2
    jr      nz,.loadtiles
    ld      a,[hl+]
    ld      [de],a
    inc     e
    dec     b
    jr      nz,.loadtiles
    xor     a
    ldh     [rVBK],a

    ld      hl,OAMBuffer
    ld      a,[Engine_CameraY]
    ld      e,a
    ld      a,[Player_YPos]
    sub     e
    add     8
    ld      b,a
    ld      [hl+],a
    ld      a,[Engine_CameraX]
    ld      e,a
    ld      a,[Player_XPos]
    sub     e
    ld      c,a
    ld      [hl+],a
    xor     a
    ld      [hl+],a
    ld      a,%00001000
    ld      [hl+],a
    ld      a,b
    ld      [hl+],a
    ld      a,c
    add     8
    ld      [hl+],a
    ld      a,2
    ld      [hl+],a
    ld      a,%00001000
    ld      [hl],a
    
    ret

; ===================
; Animation constants
; ===================

C_SetAnim   equ $80

; ================
; Animation macros
; ================

NUM_ANIMS   set 0   ; no touchy!

defanim:        macro
AnimID_\1       equ NUM_ANIMS
NUM_ANIMS       set NUM_ANIMS+1
Anim_\1:
    endm

; ==================
; Animation routines
; ==================

Player_SetAnimation:
    ld      a,l
    ld      [Player_AnimPointer],a
    ld      a,h
    ld      [Player_AnimPointer+1],a
    ld      a,1
    ld      [Player_AnimTimer],a
    ret

AnimatePlayer:
    ld      a,[Player_AnimTimer]
    cp      -1
    ret     z   ; return if current frame time = -1
    dec     a
    ld      [Player_AnimTimer],a
    ret     nz  ; return if anim timer > 0

    ; get anim pointer
    ld      a,[Player_AnimPointer]
    ld      l,a
    ld      a,[Player_AnimPointer+1]
    ld      h,a
    
    ; get frame / command number
.getEntry
    ld      a,[hl+]
    bit     7,a
    jr      nz,.cmdProc
    ld      [Player_CurrentFrame],a
    ld      a,[hl+]
    ld      [Player_AnimTimer],a
.doneEntry
    ld      a,l
    ld      [Player_AnimPointer],a
    ld      a,h
    ld      [Player_AnimPointer+1],a
    ret
    
.cmdProc
    push    hl
    ld      hl,.cmdProcTable
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jp      hl
    
.cmdProcTable:
    dw      .setAnim
    
.setAnim
    pop     hl
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jr      .getEntry

; ==============
; Animation data
; ==============

; Animation format:
; XX YY
; XX = Frame ID / command (if bit 7 set)
; YY = Wait time (one byte) / command parameter (can be more than one byte)

    defanim Player_Left2
    db      F_Player_Left2,-1
    
    defanim Player_Left1
    db      F_Player_Left1,-1

    defanim Player_Idle
    db      F_Player_Idle,-1

    defanim Player_Right1
    db      F_Player_Right1,-1
    
    defanim Player_Right2
    db      F_Player_Right2,-1
    
    defanim Player_Left2Blink
    db      F_Player_Left2_Blink1,1
    db      F_Player_Left2_Blink2,1
    db      F_Player_Left2_Blink3,1
    db      F_Player_Left2_Blink4,4
    db      F_Player_Left2_Blink3,1
    db      F_Player_Left2_Blink2,1
    db      F_Player_Left2_Blink1,1
    dbw     C_SetAnim,Anim_Player_Left2
    
    defanim Player_Left1Blink
    db      F_Player_Left1_Blink1,1
    db      F_Player_Left1_Blink2,1
    db      F_Player_Left1_Blink3,1
    db      F_Player_Left1_Blink4,4
    db      F_Player_Left1_Blink3,1
    db      F_Player_Left1_Blink2,1
    db      F_Player_Left1_Blink1,1
    dbw     C_SetAnim,Anim_Player_Left1
    
    defanim Player_IdleBlink
    db      F_Player_Idle_Blink1,1
    db      F_Player_Idle_Blink2,1
    db      F_Player_Idle_Blink3,1
    db      F_Player_Idle_Blink4,4
    db      F_Player_Idle_Blink3,1
    db      F_Player_Idle_Blink2,1
    db      F_Player_Idle_Blink1,1
    dbw     C_SetAnim,Anim_Player_Idle
    
    defanim Player_Right1Blink
    db      F_Player_Right1_Blink1,1
    db      F_Player_Right1_Blink2,1
    db      F_Player_Right1_Blink3,1
    db      F_Player_Right1_Blink4,4
    db      F_Player_Right1_Blink3,1
    db      F_Player_Right1_Blink2,1
    db      F_Player_Right1_Blink1,1
    dbw     C_SetAnim,Anim_Player_Right1
    
    defanim Player_Right2Blink
    db      F_Player_Right2_Blink1,1
    db      F_Player_Right2_Blink2,1
    db      F_Player_Right2_Blink3,1
    db      F_Player_Right2_Blink4,4
    db      F_Player_Right2_Blink3,1
    db      F_Player_Right2_Blink2,1
    db      F_Player_Right2_Blink1,1
    dbw     C_SetAnim,Anim_Player_Right2
    
    defanim Player_Hurt
    db      F_Player_Hurt1,6
    db      F_Player_Hurt2,6
    dbw     C_SetAnim,Anim_Player_Hurt
    
    defanim Player_SMH
    db      F_Player_Left1,2
    db      F_Player_Left2,2
    db      F_Player_Left1,2
    db      F_Player_Idle,2
    db      F_Player_Right1,2
    db      F_Player_Right2,2
    db      F_Player_Right1,2
    db      F_Player_Idle,2
    db      F_Player_Left1,2
    db      F_Player_Left2,2
    db      F_Player_Left1,2
    db      F_Player_Idle,2
    db      F_Player_Right1,2
    db      F_Player_Right2,2
    db      F_Player_Right1,2
    db      F_Player_Idle,2
    db      F_Player_Left1,2
    db      F_Player_Left2,2
    db      F_Player_Left1,2
    db      F_Player_Idle,2
    db      F_Player_Right1,2
    db      F_Player_Right2,2
    db      F_Player_Right1,2
    dbw     C_SetAnim,Anim_Player_Idle

; ================================

section "Player tiles",romx,align[8]
PlayerTiles:
    incbin  "GFX/PlayerTiles.2bpp"
