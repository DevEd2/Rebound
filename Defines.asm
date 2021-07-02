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

; ======
; Macros
; ======

; Copy a tileset to a specified VRAM address.
; USAGE: CopyTileset [tileset],[VRAM address],[number of tiles to copy]
CopyTileset:			macro
	ld		bc,$10*\3		; number of tiles to copy
	ld		hl,\1			; address of tiles to copy
	ld		de,$8000+\2		; address to copy to
	call	_CopyTileset
	endm
	
; Same as CopyTileset, but waits for VRAM accessibility.
CopyTilesetSafe:		macro
	ld		bc,$10*\3		; number of tiles to copy
	ld		hl,\1			; address of tiles to copy
	ld		de,$8000+\2		; address to copy to
	call	_CopyTilesetSafe
	endm
	
; Copy a 1BPP tileset to a specified VRAM address.
; USAGE: CopyTileset1BPP [tileset],[VRAM address],[number of tiles to copy]
CopyTileset1BPP:		macro
	ld		bc,$10*\3		; number of tiles to copy
	ld		hl,\1			; address of tiles to copy
	ld		de,$8000+\2		; address to copy to
	call	_CopyTileset1BPP
	endm

; Same as CopyTileset1BPP, but waits for VRAM accessibility.
CopyTileset1BPPSafe:	macro
	ld		bc,$10*\3		; number of tiles to copy
	ld		hl,\1			; address of tiles to copy
	ld		de,$8000+\2		; address to copy to
	call	_CopyTileset1BPPSafe
	endm

; Loads a DMG palette.
; USAGE: SetPal <rBGP/rOBP0/rOBP1>,(color 1),(color 2),(color 3),(color 4)
SetDMGPal:				macro
	ld		a,(\2 + (\3 << 2) + (\4 << 4) + (\5 << 6))
	ldh		[\1],a
	endm
	
; Defines a Game Boy Color RGB palette.
; USAGE: RGB	<red>,<green>,<blue>
RGB:					macro
	dw		\1+(\2<<5)+(\3<<10)
	endm
	
; Define ROM title.
romTitle:				macro
.str\@
	db		\1
.str\@_end
	rept 15-(.str\@_end-.str\@)
		db		0
	endr
	endm
endc

; Wait for VRAM accessibility.
WaitForVRAM:			macro
	ldh		a,[rSTAT]
	and		2
	jr		nz,@-4
	endm
	
string:					macro
	db		\1,0
	endm
	
ldfar:					macro
	ld		b,bank(\2)
	call	_Bankswitch
	ld		\1,\2
	endm
	
farcall:				macro
	ld		b,bank(\1)
	call	Bankswitch
	call	\1
	endm
	
resbank:				macro
	ldh		a,[sys_LastBank]
	ld		b,a
	ld		[rROMB0],a
	endm
	
djnz:					macro
	dec		b
	jr		nz,\1
	endm
	
lb:						macro
	ld		\1,\2<<8 | \3
	endm
	
; === Project-specific macros ===

; =========
; Variables
; =========

section	"Variables",wram0,align[8]

SpriteBuffer:		ds	40*4	; 40 sprites, 4 bytes each

sys_GBType:			db	; 0 = DMG, 1 = GBC, 2 = GBA
sys_ResetTimer:		db
sys_CurrentFrame:	db	; incremented each frame, used for timing
sys_btnPress:		db	; buttons pressed this frame
sys_btnHold:		db	; buttons held
sys_VBlankFlag:		db
sys_TimerFlag:		db
sys_LCDCFlag:		db
sys_EmuCheck:		db
; project-specific

Engine_TempSCX:		db
Engine_TempSCY:		db

section "Zeropage",hram

OAM_DMA:			ds	16
tempAF:				dw
tempBC:				dw
tempDE:				dw
tempHL:				dw
tempSP:				dw
sys_CurrentBank:	db
sys_LastBank:		db
sys_TempCounter:	db