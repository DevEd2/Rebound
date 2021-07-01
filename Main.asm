; ======================
; Retroboyz GB/GBC shell
; ======================

; If set to 1, enable debugging features.
DebugMode	= 1

; Defines
include "Defines.asm"

; =============
; Reset vectors
; =============
section "Reset $00",rom0[$00]
ResetGame::		jp	EntryPoint
	
section	"Reset $08",rom0[$08]
FillRAM::		jp	_FillRAM
	
section	"Reset $10",rom0[$10]
WaitVBlank::	jp	_WaitVBlank

section	"Reset $18",rom0[$18]
WaitTimer::		jp	_WaitTimer

section	"Reset $20",rom0[$20]
WaitLCDC::		jp	_WaitLCDC
	
section	"Reset $30",rom0[$30]
DoOAMDMA::		jp	$ff80

section	"Reset $38",rom0[$38]
Trap::			jr	Trap
	
	
; ==================
; Interrupt handlers
; ==================

section	"VBlank IRQ",rom0[$40]
IRQ_VBlank::	jp	DoVBlank

section	"STAT IRQ",rom0[$48]
IRQ_Stat::	jp	DoStat

section	"Timer IRQ",rom0[$50]
IRQ_Timer::	jp	DoTimer

section	"Serial IRQ",rom0[$58]
IRQ_Serial::	reti	; not needed

section	"Joypad IRQ",rom0[$60]
IRQ_Joypad::	reti	; not needed

; ===============
; System routines
; ===============

include	"SystemRoutines.asm"

; ==========
; ROM header
; ==========

section	"ROM header",rom0[$100]

EntryPoint::
	nop
	jp	ProgramStart
NintendoLogo:	; DO NOT MODIFY OR ROM WILL NOT BOOT!!!
	db	$ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
	db	$00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
	db	$bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e
ROMTitle:		romTitle	"REBOUND"	; ROM title (15 bytes)
GBCSupport:		db	$C0							; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
NewLicenseCode:	db	"DV"						; new license code (2 bytes)
SGBSupport:		db	0							; SGB support
CartType:		db	$19							; Cart type, see hardware.inc for a list of values
ROMSize:		db								; ROM size (handled by post-linking tool)
RAMSize:		db	0							; RAM size
DestCode:		db	1							; Destination code (0 = Japan, 1 = All others)
OldLicenseCode:	db	$33							; Old license code (if $33, check new license code)
ROMVersion:		db	0							; ROM version
HeaderChecksum:	db								; Header checksum (handled by post-linking tool)
ROMChecksum:	dw								; ROM checksum (2 bytes) (handled by post-linking tool)

; =====================
; Start of program code
; =====================

ProgramStart::
	di
	ld	sp,$e000
	push	bc
	push	af
	
; init memory
;	ld	hl,$c000	; start of WRAM
;	ld	bc,$1ffa	; don't clear stack
;	xor	a
;	rst	$08
		
	ld	bc,$7f80
	xor	a
.loop
	ld	[c],a
	inc	c
	dec	b
	jr	nz,.loop
	call	CopyDMARoutine
	call	$ff80	; clear OAM
	
	; wait for VBlank
	ld	hl,rLY
	ld	a,144
.wait
	cp	[hl]
	jr	nz,.wait
	xor	a
	ldh	[rLCDC],a	; disable LCD
	
	; clear VRAM
	ldh	[rVBK],a
	ld	hl,$8000
	ld	bc,$2000
	rst	$08	; fill RAM
	ld	a,1
	ldh	[rVBK],a
	xor	a
	ld	hl,$8000
	ld	bc,$2000
	rst	$08	; fill RAM
	xor	a
	ldh	[rVBK],a
	
	
; check GB type
; sets sys_GBType to 0 if DMG/SGB/GBP/GBL/SGB2, 1 if GBC, 2 if GBA/GBA SP/GB Player
	pop	af
	pop	bc
	cp	$11
	jp	nz,GBCOnlyScreen
.gbc
	and	1		; a = 1
	add	b		; b = 1 if on GBA
	ld	[sys_GBType],a
	; spoof check!
	ld	hl,$8000
	ld	a,$56
	ld	[hl],a
	ld	b,a
	ld	a,1
	ldh	[rVBK],a	; rVBK is not supported on DMG
	ld	a,b
	cp	[hl]
	jr	z,GBCOnlyScreen
	xor	a
	ld	[rVBK],a
	; emu check!
	; layer 1: echo RAM
	ld	a,$56
	ld	[sys_EmuCheck],a
	ld	b,a
	ld	a,[sys_EmuCheck+$2000]	; read from echo RAM
	cp	b
	jp	z,SkipGBCScreen
EmuScreen:
	; since we're on an emulator we don't need to wait for VBlank before disabling the LCD	
	xor	a
	ldh	[rLCDC],a	; disable LCD
	ld	a,bank(Pal_EmuScreen)
	ld	[rROMB0],a
	ld	hl,Pal_EmuScreen
	xor	a
	call	LoadPal
	ld	hl,Font
	ld	de,$8000
	call	DecodeWLE
	ld	hl,EmuText
	call	LoadTilemapText
	ld	a,%10010001
	ldh	[rLCDC],a
	ld	a,IEF_VBLANK
	ldh	[rIE],a
	ei
EmuLoop:
	halt
	jr	EmuLoop
GBCOnlyScreen:
	xor	a
	ld	[sys_GBType],a
	
	; GBC only screen
	SetDMGPal	rBGP,0,3,3,0
	ld	hl,Font
	ld	de,$8000
	call	DecodeWLE
	ld	hl,GBCOnlyText
	call	LoadTilemapText
	
	ld	a,%10010001
	ldh	[rLCDC],a
	
	ld	a,IEF_VBLANK
	ldh	[rIE],a
	ei
	
GBCOnlyLoop:
	halt
	jr		GBCOnlyLoop

GBCOnlyText:	; 20x18 char tilemap
	db	"                    "
	db	"                    "
	db	"                    "
	db	"   THIS GAME WILL   "
	db	"   ONLY WORK ON A   "
	db	"   GAME BOY COLOR   "
	db	"    OR A GAME BOY   "
	db	"      ADVANCE.      "
	db	"                    "
	db	"    PLEASE USE A    "
	db	"   GAME BOY COLOR   "
	db	"    OR A GAME BOY   "
	db	"     ADVANCE TO     "
	db	"   RUN THIS GAME.   "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
EmuText:
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"   THIS GAME WILL   "
	db	"  NOT WORK IN THIS  "
	db	"      EMULATOR.     "
	db	"                    "
	db	"    PLEASE USE A    "
	db	"   NEWER EMULATOR   "
	db	"   SUCH AS BGB OR   "
	db	"   SAMEBOY TO RUN   "
	db	"      THIS GAME.    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	
SkipGBCScreen::
	
	ld		a,%10010001
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei
	
MainLoop::
	halt		
	jr		MainLoop

; ==================
; Interrupt handlers
; ==================

DoVBlank::
	push	af
	push	bc
	ld	a,[sys_CurrentFrame]
	inc	a
	ld	[sys_CurrentFrame],a	; increment current frame
	call	CheckInput
	ld	a,1
	ld	[sys_VBlankFlag],a		; set VBlank flag
	rst	$30	; do OAM DMA
	push	de
	push	hl
	call	Pal_DoFade
	pop	hl
	pop	de
	pop	bc
	
	; A+B+Start+Select restart sequence
	ld	a,[sys_btnHold]
	cp	_A+_B+_Start+_Select	; is A+B+Start+Select pressed
	jr	nz,.noreset				; if not, skip
	ld	a,[sys_ResetTimer]		; get reset timer
	inc	a
	ld	[sys_ResetTimer],a		; store reset timer
	cp	60						; has 1 second passed?
	jr	nz,.continue			; if not, skip
	ld	a,[sys_GBType]			; get current GB model
	dec	a						; GBC?
	jr	z,.gbc					; if yes, jump
	dec	a						; GBA?
	jr	z,.gba					; if yes, jump
.dmg							; default case: assume DMG
	xor	a						; a = 0, b = whatever
	jr	.dorestart
.gbc							; a = $11, b = 0
	ld	a,$11
	ld	b,0
	jr	.dorestart
.gba							; a = $11, b = 1
	ld	a,$11
	ld	b,1
	; fall through to .dorestart
.dorestart
	jp	ProgramStart			; restart game
.noreset						; if A+B+Start+Select aren't held...
	xor	a
	ld	[sys_ResetTimer],a		; reset timer
.continue						; done
	
	pop	af
	reti
	
DoStat::
	push	af
	ld	a,1
	ld	[sys_LCDCFlag],a
	pop	af
	reti
	
DoTimer::
	push	af
	ld	a,1
	ld	[sys_TimerFlag],a
	pop	af
	reti
	
; =======================
; Interrupt wait routines
; =======================

_WaitVBlank::
	push	af
	ldh	a,[rIE]
	bit	0,a
	jr	z,.done
.wait
	halt
	ld	a,[sys_VBlankFlag]
	and	a
	jr	z,.wait
	xor	a
	ld	[sys_VBlankFlag],a
.done
	pop	af
	ret

_WaitTimer::
	push	af
	ldh	a,[rIE]
	bit	2,a
	jr	z,.done
.wait
	halt
	ld	a,[sys_TimerFlag]
	and	a
	jr	z,.wait
	xor	a
	ld	[sys_VBlankFlag],a
.done
	pop	af
	ret

_WaitLCDC::
	push	af
	ldh	a,[rIE]
	bit	1,a
	jr	z,.done
.wait
	halt
	ld	a,[sys_LCDCFlag]
	and	a
	jr	z,.wait
	xor	a
	ld	[sys_LCDCFlag],a
.done
	pop	af
	ret
	
; =================
; Graphics routines
; =================

include	"GBCPal.asm"

; =========

_CopyTileset::						; WARNING: Do not use while LCD is on!
	ld	a,[hl+]						; get byte
	ld	[de],a						; write byte
	inc	de
	dec	bc
	ld	a,b							; check if bc = 0
	or	c
	jr	nz,_CopyTileset				; if bc != 0, loop
	ret
	
_CopyTilesetSafe::					; same as _CopyTileset, but waits for VRAM accessibility before writing data
	ldh	a,[rSTAT]
	and	2							; check if VRAM is accessible
	jr	nz,_CopyTilesetSafe			; if it isn't, loop until it is
	ld	a,[hl+]						; get byte
	ld	[de],a						; write byte
	inc	de
	dec	bc
	ld	a,b							; check if bc = 0
	or	c
	jr	nz,_CopyTilesetSafe			; if bc != 0, loop
	ret
	
_CopyTileset1BPP::					; WARNING: Do not use while LCD is on!
	ld	a,[hl+]						; get byte
	ld	[de],a						; write byte
	inc	de							; increment destination address
	ld	[de],a						; write byte again
	inc	de							; increment destination address again
	dec	bc
	dec	bc							; since we're copying two bytes, we need to dec bc twice
	ld	a,b							; check if bc = 0
	or	c
	jr	nz,_CopyTileset1BPP			; if bc != 0, loop
	ret

_CopyTileset1BPPSafe::				; same as _CopyTileset1BPP, but waits for VRAM accessibility before writing data
	ldh	a,[rSTAT]
	and	2							; check if VRAM is accessible
	jr	nz,_CopyTileset1BPPSafe		; if it isn't, loop until it is
	ld	a,[hl+]						; get byte
	ld	[de],a						; write byte
	inc	de							; increment destination address
	ld	[de],a						; write byte again
	inc	de							; increment destination address again
	dec	bc
	dec	bc							; since we're copying two bytes, we need to dec bc twice
	ld	a,b							; check if bc = 0
	or	c
	jr	nz,_CopyTileset1BPP			; if bc != 0, loop
	ret

LoadTilemapText:
	ld	de,_SCRN0
	ld	b,$12
	ld	c,$14
.loop
	ld	a,[hl+]
	sub 32	
	ld	[de],a
	inc	de
	dec	c
	jr	nz,.loop
	ld	c,$14
	ld	a,e
	add	$C
	jr	nc,.continue
	inc	d
.continue
	ld	e,a
	dec	b
	jr	nz,.loop
	ret

; ============
; Sprite stuff
; ============

CopyDMARoutine::
	ld	bc,$80 + ((_OAM_DMA_End-_OAM_DMA) << 8)
	ld	hl,_OAM_DMA
.loop
	ld	a,[hl+]
	ld	[c],a
	inc	c
	dec	b
	jr	nz,.loop
	ret
	
_OAM_DMA::
	ld	a,high(SpriteBuffer)
	ldh	[rDMA],a
	ld	a,$28
.wait
	dec	a
	jr	nz,.wait
	ret
_OAM_DMA_End:

; =============
; Misc routines
; =============
	
; Fill RAM with a value.
; INPUT:  a = value
;        hl = address
;        bc = size
_FillRAM::
	ld	e,a
.loop
	ld	[hl],e
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,.loop
	ret
	
; Fill up to 256 bytes of RAM with a value.
; INPUT:  a = value
;        hl = address
;         b = size
_FillRAMSmall::
	ld	e,a
.loop
	ld	[hl],e
	inc	hl
	dec	b
	jr	nz,.loop
	ret
	
; Copy up to 65536 bytes to RAM.
; INPUT: hl = source
;        de = destination
;        bc = size
_CopyRAM::
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,_CopyRAM
	ret
	
; Copy up to 256 bytes to RAM.
; INPUT: hl = source
;        de = destination
;         b = size
_CopyRAMSmall::
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	b
	jr	nz,_CopyRAMSmall
	ret
	
DoubleSpeed:
	ldh	a,[rKEY1]
	bit	7,a			; already in double speed?
	ret	nz			; if yes, return
	ld	a,%00110000
	ldh	[rP1],a
	xor	%00110001	; a = %00000001
	ldh	[rKEY1],a	; prepare speed switch
	stop
	ret

include	"WLE_Decode.asm"

; =========
; Misc data
; =========

section	"Sine table",rom0,align[8]
SineTable:
angle=0.0
	rept	256
	db	mul(127.0,sin(angle)+1.0)>>16
angle=angle+256.0
	endr
CosTable:
angle=mul(67.5,256.0)
	rept	256
	db	mul(127.0,sin(angle)+1.0)>>16
angle=angle+256.0
	endr

; =============
; Graphics data
; =============

Font::				incbin	"GFX/Font.bin.wle"
	
; =============
; Misc routines
; =============

include	"Metatile.asm"	

; ========
; SFX data
; ========

; =============
; Graphics data
; =============

section "GFX bank 1",romx

Pal_Grayscale:
	RGB	31,31,31
	RGB	20,20,20
	RGB	10,10,10
	RGB	 0, 0, 0

Pal_EmuScreen:
	RGB	31,31,31
	RGB	 0, 0, 0
	RGB  0, 0, 0
	RGB	31,31,31

; ==========
; Level data
; ==========

include "Levels/TestMap.inc"