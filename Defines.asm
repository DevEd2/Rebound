; ===============
; Project defines
; ===============

if	!def(definesIncluded)
definesIncluded	set	1

; Hardware defines
include	"hardware.inc"

; ================
; Global constants
; ================

sys_DMG			equ	0
sys_GBP			equ	1
sys_SGB			equ	2
sys_SGB2		equ	3
sys_GBC			equ	4
sys_GBA			equ	5

btnA			equ	0
btnB			equ	1
btnSelect		equ	2
btnStart		equ	3
btnRight		equ	4
btnLeft			equ	5
btnUp			equ	6
btnDown			equ	7

_A				equ	1
_B				equ	2
_Select			equ	4
_Start			equ	8
_Right			equ	16
_Left			equ	32
_Up				equ	64
_Down			equ	128


; ==========================
; Project-specific constants
; ==========================

FXHammer_Trig		equ     $4000   ; a = sound FX number (0 - 59)
FXHammer_Stop		equ     $4003
FXHammer_Update		equ     $4006   ; call once every frame

SFX_Jump			equ	0
SFX_Step			equ	1
SFX_Death			equ	2
SFX_GetGem			equ	3
SFX_Magic			equ	4
SFX_Pause			equ	5
SFX_Break			equ	6
SFX_Bump			equ	7
SFX_Fuse			equ	8
SFX_Explosion		equ	9
SFX_SpikeTrap		equ	10
SFX_Cursor			equ	11
SFX_Denied			equ	12
SFX_MenuSelect		equ	13
SFX_Correct			equ	14

; ======
; Macros
; ======

; Copy a tileset to a specified VRAM address.
; USAGE: CopyTileset [tileset],[VRAM address],[number of tiles to copy]
CopyTileset:			macro
	ld	bc,$10*\3		; number of tiles to copy
	ld	hl,\1			; address of tiles to copy
	ld	de,$8000+\2		; address to copy to
	call	_CopyTileset
	endm
	
; Same as CopyTileset, but waits for VRAM accessibility.
CopyTilesetSafe:		macro
	ld	bc,$10*\3		; number of tiles to copy
	ld	hl,\1			; address of tiles to copy
	ld	de,$8000+\2		; address to copy to
	call	_CopyTilesetSafe
	endm
	
; Copy a 1BPP tileset to a specified VRAM address.
; USAGE: CopyTileset1BPP [tileset],[VRAM address],[number of tiles to copy]
CopyTileset1BPP:		macro
	ld	bc,$10*\3		; number of tiles to copy
	ld	hl,\1			; address of tiles to copy
	ld	de,$8000+\2		; address to copy to
	call	_CopyTileset1BPP
	endm

; Same as CopyTileset1BPP, but waits for VRAM accessibility.
CopyTileset1BPPSafe:	macro
	ld	bc,$10*\3		; number of tiles to copy
	ld	hl,\1			; address of tiles to copy
	ld	de,$8000+\2		; address to copy to
	call	_CopyTileset1BPPSafe
	endm

; Loads a DMG palette.
; USAGE: SetPal <rBGP/rOBP0/rOBP1>,(color 1),(color 2),(color 3),(color 4)
SetDMGPal:				macro
	ld	a,(\2 + (\3 << 2) + (\4 << 4) + (\5 << 6))
	ldh	[\1],a
	endm
	
; Defines a Game Boy Color RGB palette.
; USAGE: RGB	<red>,<green>,<blue>
RGB:					macro
	dw	\1+(\2<<5)+(\3<<10)
	endm
	
; Define ROM title.
romTitle:				macro
.str\@
	db	\1
.str\@_end
	rept	15-(.str\@_end-.str\@)
		db	0
	endr
	endm
endc

; Wait for VRAM accessibility.
WaitForVRAM:			macro
	ldh	a,[rSTAT]
	and	2
	jr	nz,@-4
	endm
	
string:					macro
	db	\1,0
	endm
	
; === Project-specific macros ===

; =========
; Variables
; =========

section	"Variables",wram0,align[8]

SpriteBuffer:		ds	40*4	; 40 sprites, 4 bytes each

sys_GBType:			ds	1	; 0 = DMG, 1 = GBC, 2 = GBA
sys_ResetTimer:		ds	1
sys_CurrentFrame:	ds	1	; incremented each frame, used for timing
sys_btnPress:		ds	1	; buttons pressed this frame
sys_btnHold:		ds	1	; buttons held
sys_VBlankFlag:		ds	1
sys_TimerFlag:		ds	1
sys_LCDCFlag:		ds	1
sys_EmuCheck:		ds	1

; project-specific

PlayerX:			dw	; high byte = pixel, low byte = subpixel
PlayerY:			dw	; high byte = pixel, low byte = subpixel
PlayerOffX:			db	; offset relative to center of screen
PlayerOffY:			db	; offset relative to center of screen


PlayerVelX:			dw	; high byte = pixel, low byte = subpixel
PlayerVelY:			dw	; high byte = pixel, low byte = subpixel

PlayerAnimFrame:	ds	1
PlayerAnimTimer:	ds	1

PlayerCoords:		ds	1
PlayerTile:			ds	1


Player_MaxSpeed		= 1
Player_Accel		= 16
Player_Decel		= 12

section "Zeropage",hram

OAM_DMA:			ds	16
tempAF:				ds	2
tempBC:				ds	2
tempDE:				ds	2
tempHL:				ds	2
tempSP:				ds	2