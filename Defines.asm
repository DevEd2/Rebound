; ===============
; Project defines
; ===============

if  !def(definesIncluded)
definesIncluded set 1

; Hardware defines
include "hardware.inc"

; ================
; Global constants
; ================

sys_DMG         equ 0
sys_GBP         equ 1
sys_SGB         equ 2
sys_SGB2        equ 3
sys_GBC         equ 4
sys_GBA         equ 5

btnA            equ 0
btnB            equ 1
btnSelect       equ 2
btnStart        equ 3
btnRight        equ 4
btnLeft         equ 5
btnUp           equ 6
btnDown         equ 7

_A              equ 1
_B              equ 2
_Select         equ 4
_Start          equ 8
_Right          equ 16
_Left           equ 32
_Up             equ 64
_Down           equ 128

; ==========================
; Project-specific constants
; ==========================

TILESET_TEST    equ 0

MUSIC_TEST1     equ 0
MUSIC_TEST2     equ 1

; ======
; Macros
; ======

; Copy a tileset to a specified VRAM address.
; USAGE: CopyTileset [tileset],[VRAM address],[number of tiles to copy]
CopyTileset:            macro
    ld      bc,$10*\3       ; number of tiles to copy
    ld      hl,\1           ; address of tiles to copy
    ld      de,$8000+\2     ; address to copy to
    call    _CopyRAM
endm
    
; Same as CopyTileset, but waits for VRAM accessibility.
CopyTilesetSafe:        macro
    ld      bc,$10*\3       ; number of tiles to copy
    ld      hl,\1           ; address of tiles to copy
    ld      de,$8000+\2     ; address to copy to
    call    _CopyTilesetSafe
endm
    
; Copy a 1BPP tileset to a specified VRAM address.
; USAGE: CopyTileset1BPP [tileset],[VRAM address],[number of tiles to copy]
CopyTileset1BPP:        macro
    ld      bc,$10*\3       ; number of tiles to copy
    ld      hl,\1           ; address of tiles to copy
    ld      de,$8000+\2     ; address to copy to
    call    _CopyTileset1BPP
endm

; Same as CopyTileset1BPP, but waits for VRAM accessibility.
CopyTileset1BPPSafe:    macro
    ld      bc,$10*\3       ; number of tiles to copy
    ld      hl,\1           ; address of tiles to copy
    ld      de,$8000+\2     ; address to copy to
    call    _CopyTileset1BPPSafe
endm

; Loads a DMG palette.
; USAGE: SetPal <rBGP/rOBP0/rOBP1>,(color 1),(color 2),(color 3),(color 4)
SetDMGPal:              macro
    ld      a,(\2 + (\3 << 2) + (\4 << 4) + (\5 << 6))
    ldh     [\1],a
endm
    
; Defines a Game Boy Color RGB palette.
; USAGE: RGB    <red>,<green>,<blue>
RGB:                    macro
    dw      \1+(\2<<5)+(\3<<10)
endm

; Wait for VRAM accessibility.
WaitForVRAM:            macro
    ldh     a,[rSTAT]
    and     2
    jr      nz,@-4
endm
    
string:                 macro
    db      \1,0
endm

; Loads appropriate ROM bank for a block of data and loads its pointer into a given register.
; Trashes B.
ldfar:                  macro
    ld      b,bank(\2)
    call    _Bankswitch
    ld      \1,\2
endm
    
; Loads appropriate ROM bank for a routine and executes it.
; Trashes B.
farcall:                macro
    ld      b,bank(\1)
    call    _Bankswitch
    call    \1
endm
    
resbank:                macro
    ldh     a,[sys_LastBank]
    ld      [rROMB0],a
endm
    
djnz:                   macro
    dec     b
    jr      nz,\1
endm
    
lb:                     macro
    ld      \1,\2<<8 | \3
endm
    
dbp:                    macro
.str\@
    db      \1
.str\@_end
    rept    \2-(.str\@_end-.str\@)
        db  \3
    endr
endm

dbw:                    macro
    db      \1
    dw      \2
endm

if DebugMode
debugmsg:               macro
    ld      d,d
    jr      .\@
    dw      $6464
    dw      0
    db      \1,0
    dw      0
    dw      0
.\@
endm
endc

const_def:      macro
const_value = 0
endm

const:          macro
if "\1" != "skip"
\1  equ const_value
endc
const_value = const_value + 1
ENDM

PlaySFX:    macro
    ld      a,bank(SFX_\1)
    ld      hl,SFX_\1
    call    VGMSFX_Init
endm
    
; === Project-specific macros ===

; =========
; Variables
; =========

section "Variables",wram0,align[8]

OAMBuffer:          ds  40*4    ; 40 sprites, 4 bytes each
.end

sys_GBType:         db  ; 0 = DMG, 1 = GBC, 2 = GBA
sys_ResetTimer:     db
sys_CurrentFrame:   db  ; incremented each frame, used for timing
sys_btnPress:       db  ; buttons pressed this frame
sys_btnHold:        db  ; buttons held

sys_VBlankFlag:     db
sys_LCDCFlag:       db
sys_TimerFlag:      db
sys_SerialFlag:     db
sys_JoypadFlag:     db

sys_EmuCheck:       db

sys_EnableHDMA:     db
sys_TilemapBuffer:  ds  20*18

; project-specific

section "Zeropage",hram

OAM_DMA:            ds  16
tempAF:             dw
tempBC:             dw
tempDE:             dw
tempHL:             dw
tempSP:             dw
sys_CurrentBank:    db
sys_LastBank:       db
sys_TempCounter:    db
sys_TempSVBK:       db

endc