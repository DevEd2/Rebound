; VGMSFX sound effect system

section "VGMSFX RAM",wram0
VGMSFX_Bank:            db  ; bank of currently playing sound effect
VGMSFX_Pointer:         dw  ; pointer of currently playing sound effect
VGMSFX_Flags:           db  ; bit 0 - 3 denote whether a sound effect is playing on CH1-CH4; bit 7 = playing

SFX_CH1     equ %00000001
SFX_CH2     equ %00000010
SFX_CH3     equ %00000100
SFX_CH4     equ %00001000

bSFX_CH1    equ 0
bSFX_CH2    equ 1
bSFX_CH3    equ 2
bSFX_CH4    equ 3

section "VGMSFX",rom0

;  A = SFX bank
; HL = SFX pointer
; Destroys: a, b, hl
VGMSFX_Init:
    ld      [VGMSFX_Bank],a
    ld      b,a
    call    _Bankswitch
    ld      a,[hl+]
    or      %10000000
    ld      [VGMSFX_Flags],a
    ld      a,l
    ld      [VGMSFX_Pointer],a
    ld      a,h
    ld      [VGMSFX_Pointer+1],a
    ret
    
; Destroys: a, bc, hl
VGMSFX_Update:
    ld      a,[VGMSFX_Flags]
    bit     7,a                 ; is a sound effect playing?
    ret     z                   ; if not, exit
    ld      a,[VGMSFX_Bank]
    ld      b,a
    call    _Bankswitch
    ld      hl,VGMSFX_Pointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    
.getbyte
    ld      a,[hl+]
    cp      $b3             ; $B3 - DMG write to register
    jr      z,.writereg
    cp      $62             ; $62 - wait a 60th of a second (one frame @60hz)
    jr      z,.waitframe
    ; all other commands are interpreted as end of stream
.endstream
    xor     a
    ld      [VGMSFX_Flags],a
    ldh     [rNR10],a   ; reset sweep
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
