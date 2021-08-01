section "Level state memory",wram0

; Levels are divided into 16-block tall "subareas", which are further divided into 16-block wide "screens"
Engine_CurrentSubarea:          ; (shared with Engine_CurrentScreen)
Engine_CurrentScreen:       db  ; upper two bits = subarea, remaining bits = screen number
Engine_NumScreens:          db  ; number of screens per subarea (effectively "map width")
Engine_NumSubareas:         db  ; number of subareas
Engine_CollisionBank:       db  ; bank of current collision table
Engine_CollisionPointer:    dw  ; pointer to current collision table
Engine_LastRow:             db  ; last row drawn

Engine_CameraX:             db
Engine_CameraY:             db
Engine_CameraTargetX:       db
Engine_CameraTargetY:       db
Engine_BounceCamTarget:     db
Engine_LockCamera:          db
Engine_CameraIsTracking:    db

section "Level background buffer",wram0,align[8]
Engine_BackgroundBuffer:    ds  16*16

section "Level memory",wramx[$d000]
Engine_LevelData:       ds  256*16

section "Level routines",rom0

GM_Level:
    ; initialize variables
    xor     a
    ld      [Engine_CurrentScreen],a
    ld      [Engine_LastRow],a
    ; initialize player object
    call    InitPlayer

    ; TODO: Load palettes from level header
    ldfar   hl,Pal_TestMap
    ld      b,(Pal_TestMap_End-Pal_TestMap) / 8
    xor     a
.loop
    push    af
    push    bc
    call    LoadPal
    pop     bc
    pop     af
    inc     a
    dec     b
    jr      nz,.loop

    call    ConvertPals
    call    PalFadeInWhite

    ; TODO: Load "background" graphics from map header
    ldfar   hl,ParallaxTiles
    ld      de,Engine_ParallaxBuffer
    ld      b,0
    call    _CopyRAMSmall
    
    ; TODO: Load tileset from level header
    ld      a,low(ParallaxTileset)
    ld      [Engine_TilesetPointer],a
    ld      a,high(ParallaxTileset)
    ld      [Engine_TilesetPointer+1],a

    ; TODO: Load level graphics from level header
    CopyTileset TestMapTiles,0,(TestMapTiles_End-TestMapTiles)/16
    ld      hl,Map_TestMap
    call    LoadMap
    
    ld      a,$80
    ld      [Engine_ParallaxDest],a
    
    ; initialize camera
    xor     a
    ld      [Engine_CameraX],a
    ld      [Engine_CameraTargetX],a
    ld      [Engine_LockCamera],a
    ld      [Engine_CameraIsTracking],a
    ld      [Engine_BounceCamTarget],a
    ld      a,256-SCRN_Y
    ld      [Engine_CameraY],a
    ld      a,1
    ld      [sys_EnableHDMA],a      ; enable parallax HDMA transfer
    
    ; setup registers
    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a

    ; wait for VBlank to avoid VRAM access violations during palette copy
.w  ldh     a,[rLY]
    cp      144
    jr      nz,.w


    ei
    
LevelLoop::
    
.docamera
    ld      a,[Engine_LockCamera]
    and     a
    jp      nz,.nocamera
    
    ld      a,[Engine_CameraX]
    rra
    ld      d,a
    and     a
    ld      a,[Engine_CameraY]
    rra
    ld      e,a

    ld      a,[Player_XPos]
.checkleft
    sub     SCRN_X / 2
    jr      nc,.checkright
    ld      b,a
    ld      a,[Engine_CurrentScreen]
    and     a
    ld      a,b
    jr      nz,.setcamx
    xor     a
    jr      .setcamx
.checkright
    ld      a,[Engine_CurrentScreen]
    ld      b,a
    ld      a,[Engine_NumScreens]
    cp      b
    jr      nz,.skipright
    ld      a,[Player_XPos]
    sub     SCRN_X / 2
    cp      256 - SCRN_X
    jr      c,.setcamx
    ld      a,256 - SCRN_X
    jr      .setcamx
.skipright
    ld      a,[Player_XPos]
    sub     SCRN_X / 2
.setcamx
    ld      [Engine_CameraTargetX],a

    ld      a,[Player_YPos]
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
    ld      [Engine_CameraTargetY],a
    
    ; TODO: X following logic
    ld      a,[Engine_CameraTargetX]
    ld      [Engine_CameraX],a

    ; Vertical camera following logic:
    ; Whenever the player bounces on a floor higher than their last bounce, the camera
    ; moves to follow the player vertically. This helps to reduce motion sickness on big
    ; screens (i.e. Game Boy Player, emulators)

    ; if player is falling and Y position > Y position at last bounce, camera Y follows player directly
    ld      a,[Player_LastBounceY]
    ld      b,a
;   ld      a,[Player_YVelocity]
;   add     2
;   add     b                       ; add Y velocity + 1 to prevent camera following on bounce at same height
;   ld      b,a
    ld      a,[Player_YPos]
    cp      b
    jr      c,.checkhigher
    ld      a,[Engine_CameraTargetY]
    ld      [Engine_CameraY],a
    jr      .doparallax
.checkhigher
    ; if player bounces on higher surface than previous surface, then move camera vertically to follow player    
    ld      a,[Player_LastBounceY]
    ld      b,a
    ld      a,[Player_YPos]
    cp      b
    jr      nc,.doparallax
    ld      a,[Engine_CameraIsTracking]
    and     a
    jr      z,.doparallax           ; if camera isn't tracking the player, skip

    ld      a,[Engine_CameraY]
    sub     2
    jr      nc,.noreset             ; reset camera if overflow occurs
    xor     a
    ld      [Engine_CameraY],a
    ld      [Engine_CameraIsTracking],a
    jr      .doparallax
.noreset
    ld      [Engine_CameraY],a
    ld      b,a
    ld      a,[Engine_BounceCamTarget]
    cp      b                       ; is camera Y < target camera Y?
    jr      c,.doparallax           ; if not, skip

    ld      [Engine_CameraY],a
    xor     a
    ld      [Engine_CameraIsTracking],a
    
.doparallax
    and     a   ; clear carry
    push    de
    ld      a,[Engine_CameraX]
    rra
    sub     d
    jr      z,.skipX
    cpl
    inc     a
.check7F
    cp      $7f
    jr      nz,.check81
    ld      a,$ff
    jr      .dohoriz
.check81
    cp      $81
    jr      nz,.dohoriz
    ld      a,$01
    
.dohoriz
    call    Parallax_ShiftHorizontal

.skipX
    pop     de
    ld      a,[Engine_CameraY]
    srl     a
    sub     e
    jr      z,.skipY
    cpl
    inc     a
    ld      c,1
    call    Parallax_ShiftVertical
.skipY

.nocamera

    ld      a,[Player_XPos]
    push    af
    call    ProcessPlayer
    call    DrawPlayer
    pop     bc
    ld      a,[Player_XPos]
    cp      b
    jr      z,.skipload
    jr      nc,.loadright
.loadleft
    ld      a,[Engine_CurrentScreen]
    and     $30
    ld      c,a
    ld      a,[Engine_CurrentScreen]
    and     $0f
    ld      e,a

    ld      a,[Engine_LastRow]
    ld      b,a
    ld      a,[Player_XPos]
    sub     SCRN_X / 2
    jr      nc,.skipdecscreen
    dec     e
.skipdecscreen
    and     $f0
    ld      d,a
    cp      b
    jr      z,.skipload
    ld      [Engine_LastRow],a
    
    ld      a,e
    or      c
    ld      e,a
    jr      .doload
.loadright
    ld      a,[Engine_CurrentScreen]
    and     $30
    ld      c,a
    ld      a,[Engine_CurrentScreen]
    and     $0f
    ld      e,a

    ld      a,[Engine_LastRow]
    ld      b,a
    ld      a,[Player_XPos]
    add     SCRN_X / 2
    jr      nc,.skipincscreen
    inc     e
.skipincscreen
    and     $f0
    ld      d,a
    cp      b
    jr      z,.skipload
    ld      [Engine_LastRow],a
    
    ld      a,e
    or      c
    ld      e,a
    ; fall through
.doload
    call    Level_LoadMapRow
    ; fall through
.skipload
    halt
    jp      LevelLoop
    
; ================================================================

; Input:    HL = Pointer to map header
LoadMap:
    ld      a,[hl+] ; get screen count
    and     $f      ; maximum of 16 screens allowed
    ld      [Engine_NumScreens],a
    ld      a,[hl+] ; get subarea count
    and     $3      ; maximum of 4 subareas allowed
    ld      [Engine_NumSubareas],a
    
    ; load player start X position
    ld      a,[hl]  ; we'll need this byte again so don't inc hl yet
    and     $f0     ; \ convert to
    add     8       ; / correct format
    ld      [Player_XPos],a
    ; load player start Y position
    ld      a,[hl+]
    and     $0f     ; \ convert to 
    swap    a       ; | correct 
    add     8       ; / format
    ld      [Player_YPos],a
    add     16
    ld      [Player_LastBounceY],a
    ; load player starting screen + subarea
    ld      a,[hl+]
    ld      [Engine_CurrentScreen],a ; no need to convert to different format here
    
    
    ; TODO: load tileset
    inc     hl
    
    ; load music
    ld      a,[hl+]
    push    hl
    farcall DevSound_Init
    pop     hl
    resbank
    
    
    ; load map into mem
    lb      bc,4,0
.loop
    push    hl
    push    bc
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    
    ld      a,c
    add     2
    ld      [rSVBK],a
    
    ld      de,Engine_LevelData
    call    DecodeWLE
    
    pop     bc
    pop     hl
    inc     hl
    inc     hl
    inc     c
    dec     b
    jr      nz,.loop
    
    ld      a,[Engine_CurrentScreen]
    call    Level_LoadScreen
    
    ld      a,1
    ldh     [rSVBK],a
    ret
    
; ========

; INPUT: a = screen ID
Level_LoadScreen:
    ld      b,a
    and     $30
    swap    a
    add     2
    ldh     [rSVBK],a
    ld      hl,Engine_LevelData
    ld      a,b
    and     $0f
    add     h
    ld      h,a
    lb      bc,16,0
    ld      e,0
.loop
    push    bc
    push    de
    ld      a,[hl+]
    push    hl
    ld      b,a
    ; get Y coordinate
    ld      a,e
    and     $f
    swap    a
    ld      d,a
    ; get X coordinate
    ld      a,c
    and     $f
    or      d
    call    DrawMetatile
    
    pop     hl
    pop     de
    pop     bc
    inc     e
    dec     b
    jr      nz,.loop
    ld      b,16
    ld      e,0
    inc     c
    ld      a,c
    cp      16
    jr      nz,.loop
    ret
    
; ========

; INPUT: d = row to load
;        e = screen to load from
Level_LoadMapRow:
    ld      hl,Engine_LevelData
    ldh     a,[rSVBK]
    and     7
    ldh     [sys_TempSVBK],a
    ; get subarea
    ld      a,e
    and     $f0
    swap    a
    ; set correct WRAM bank
    add     2
    ldh     [rSVBK],a
    
    ; get screen
    ld      a,e
    and     $f
    add     h
    ld      h,a
    ; get row
    ld      a,d
    and     $f0
    add     l
    ld      l,a
    
    ld      b,16
.loop
    push    bc
    ld      a,[hl]
    push    hl
    ld      b,a
    
    ld      a,l ; L = tile coordinates
    swap    a   ; DrawMetatile expects unswapped coordinates
    call    DrawMetatile
    pop     hl
    inc     l
    pop     bc
    dec     b
    jr      nz,.loop

    ret
