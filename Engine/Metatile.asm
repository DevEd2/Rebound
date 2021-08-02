section "Metatile RAM defines",wram0,align[8]

Engine_TilesetPointer:  dw
Engine_TilesetBank:     db

section "Metatile routines",rom0

; Input:    H = Y pos
;           L = X pos
; Output:   A = Tile coordinates
; Destroys: B
GetTileCoordinates:
    ld      a,l
    and     $f0
    swap    a
    ld      b,a
    ld      a,h
    and     $f0
    add     b
    ret
    
; Input:        E = Tile coordinates
;           Carry = Subtract 1 from screen 
; Output:       A = Tile ID
; Destroys:    HL
GetTileL:
    push    af
    ldh     a,[rSVBK]
    and     $7
    ldh     [sys_TempSVBK],a
    ld      a,[Engine_CurrentSubarea]
    and     $30
    swap    a
    add     2
    ldh     [rSVBK],a
    ld      a,[Engine_CurrentScreen]
    and     $f
    ld      hl,Engine_LevelData
    add     h
    ld      h,a
    pop     af
    jr      nc,.nocarry
    dec     h
.nocarry
    ld      l,e
    ld      a,[hl]
    ret
    
; Input:        E = Tile coordinates
;           Carry = Add 1 to screen 
; Output:       A = Tile ID
; Destroys:    HL
GetTileR:
    push    af
    ldh     a,[rSVBK]
    and     $7
    ldh     [sys_TempSVBK],a
    ld      a,[Engine_CurrentSubarea]
    and     $30
    swap    a
    add     2
    ldh     [rSVBK],a
    ld      a,[Engine_CurrentScreen]
    and     $f
    ld      hl,Engine_LevelData
    add     h
    ld      h,a
    pop     af
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      l,e
    ld      a,[hl]
    ret

; Input:    A = Tile coordinates
;           B = Tile ID
; Output:   Metatile to screen RAM
; Destroys: BC, DE, HL
DrawMetatile:
    push    af
    ld      e,a
    and     $0f
    rla
    ld      l,a
    ld      a,e
    and     $f0
    ld      e,a
    rla
    rla
    and     %11000000
    or      l
    ld      l,a
    ld      a,e
    rra
    rra
    swap    a
    and     $3
    ld      h,a
    
    ld      de,_SCRN0
    add     hl,de
    ld      d,h
    ld      e,l
    ; get tile data pointer
    push    bc
    ld      a,[Engine_TilesetBank]
    ld      b,a
    call    _Bankswitch
    pop     bc
    ld      hl,Engine_TilesetPointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ; skip collision pointer + gfx bank & pointer
    push    de
    ld      de,5
    add     hl,de
    pop     de
    ld      c,b
    ld      b,0
    add     hl,bc
    add     hl,bc
    add     hl,bc
    add     hl,bc
    add     hl,bc
    add     hl,bc
    add     hl,bc
    add     hl,bc
    ; write to screen memory
    xor     a
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    ld      a,1
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    inc     de
    
    xor     a
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    ld      a,1
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    ld      a,e
    add     $1f
    jr      nc,.nocarry3
    inc     d
.nocarry3
    ld  e,a
    
    xor     a
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    ld      a,1
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    inc     de
    
    xor     a
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    ld      a,1
    ldh     [rVBK],a
    WaitForVRAM
    ld      a,[hl+]
    ld      [de],a
    pop     af
    ret

