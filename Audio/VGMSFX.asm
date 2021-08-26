; VGMSFX sound effect system

section "VGMSFX RAM",wram0
VGMSFX_Bank:            db  ; bank of currently playing sound effect
VGMSFX_Pointer:         dw  ; pointer of currently playing sound effect
VGMSFX_Flags:           db
; VGMSFX_Flags bits:
; 0 - CH1 registers (NR1x) in use
; 1 - CH2 registers (NR2x) in use
; 2 - CH3 registers (NR3x + wave RAM) in use
; 3 - CH4 registers (NR4x) in use
; 4 - Control registers (NR5x) in use
; 5 - Unused
; 6 - Unused
; 7 - SFX playing

SFX_CH1     equ $0001
SFX_CH2     equ %0010
SFX_CH3     equ %0100
SFX_CH4     equ %1000

bSFX_CH1    equ 0
bSFX_CH2    equ 1
bSFX_CH3    equ 2
bSFX_CH4    equ 3
bSFX_Ctrl   equ 4
bSFX_Enable equ 7

section "VGMSFX",rom0

;  A = SFX bank
; HL = SFX pointer
; Destroys: a, hl
VGMSFX_Init:
    ; selectively clear sound channels
    push    af
    ld      a,[VGMSFX_Flags]
    ld      b,a
    rr      b
    call    c,VGMSFX_ClearCH1
    rr      b
    call    c,VGMSFX_ClearCH2
    rr      b
    call    c,VGMSFX_ClearCH3
    rr      b
    call    c,VGMSFX_ClearCH4
    pop     af

    ld      [VGMSFX_Bank],a     ; set ROM bank
    ld      b,a
    call    _Bankswitch
    ld      a,[hl+]             ; get channel flags
    set     bSFX_Enable,a       ; set "enable SFX" flag
    ld      [VGMSFX_Flags],a
    ; write pointer
    ld      a,l
    ld      [VGMSFX_Pointer],a
    ld      a,h
    ld      [VGMSFX_Pointer+1],a
    xor     a
    ldh     [rNR10],a           ; reset sweep
	resbank
    ret                         ; done!
    
VGMSFX_ClearCH1:
    xor     a
    ldh     [rNR12],a   ; volume envelope
    ld      a,%10000000
    ldh     [rNR14],a   ; reset volume envelope
    ret
VGMSFX_ClearCH2:
    xor     a
    ldh     [rNR22],a   ; volume envelope
    ld      a,%10000000
    ldh     [rNR24],a   ; reset volume envelope
    ret
VGMSFX_ClearCH3:
    xor     a
    ldh     [rNR30],a   ; disable wave channel
    ret
VGMSFX_ClearCH4:
    xor     a
    ldh     [rNR42],a   ; volume envelope
    ld      a,%10000000
    ldh     [rNR44],a   ; reset volume envelope
    ret
    
; Destroys: a, bc, hl
VGMSFX_Update:
    ld      a,[VGMSFX_Flags]
    bit     bSFX_Enable,a       ; is a sound effect playing?
    ret     z                   ; if not, exit
    ld      a,[VGMSFX_Bank]     ; get ROM bank
    ld      b,a
    call    _Bankswitch         ; do a bankswitch
    ; get pointer
    ld      hl,VGMSFX_Pointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ; fall through
.getbyte
    ld      a,[hl+]
    cp      $b3             ; $B3 - write to register
    jr      z,.writereg
    cp      $62             ; $62 - wait one tick
    jr      z,.waitframe
    ; all other commands are interpreted as end of stream
.endstream
    xor     a
    ld      [VGMSFX_Flags],a
    ldh     [rNR10],a   ; reset sweep (prevents glitches)
    ret
.writereg
    ld      a,[hl+]
    add     low(rNR10) ; VGM specs state 00 = NR10
    ld      c,a
    ld      a,[hl+]
    ld      [c],a
    jr      .getbyte
.waitframe
    ld      a,l
    ld      [VGMSFX_Pointer],a
    ld      a,h
    ld      [VGMSFX_Pointer+1],a
    ret
    
; ================================================================

include "Audio/VGMSFX_SFXData.asm"
