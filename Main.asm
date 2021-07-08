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
Trap00::		jp	Trap00
	
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
IRQ_Stat::		jp	DoStat

section	"Timer IRQ",rom0[$50]
IRQ_Timer::		jp	DoTimer

section	"Serial IRQ",rom0[$58]
IRQ_Serial::	jp	DoSerial

section	"Joypad IRQ",rom0[$60]
IRQ_Joypad::	jp	DoJoypad

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
ROMTitle:		dbp	"REBOUND",15,0				; ROM title (15 bytes)
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
	ld		sp,$d000
	push	bc
	push	af
	
; init memory
;	ld		hl,$c000	; start of WRAM
;	ld		bc,$1ffa	; don't clear stack
;	xor		a
;	rst		FillRAM
		
	ld		bc,$7f80
	xor		a
.loop
	ld		[c],a
	inc		c
	dec		b
	jr		nz,.loop
	call	CopyDMARoutine
;	rst		DoOAMDMA
	
	; wait for VBlank
	ld	hl,rLY
	ld	a,144
.wait
	cp	[hl]
	jr	nz,.wait
	xor	a
	ldh	[rLCDC],a	; disable LCD
	
	; clear VRAM
	ldh		[rVBK],a
	ld		hl,$8000
	ld		bc,$2000
	rst		FillRAM
	
	ld		a,1
	ldh		[rVBK],a
	xor		a
	ld		hl,$8000
	ld		bc,$2000
	rst		FillRAM
	xor		a
	ldh		[rVBK],a
	
	
; check GB type
; sets sys_GBType to 0 if DMG/SGB/GBP/GBL/SGB2, 1 if GBC, 2 if GBA/GBA SP/GB Player
	pop		af
	pop		bc
	cp		$11
	jp		nz,GBCOnlyScreen
.gbc
	and		1		; a = 1
	add		b		; b = 1 if on GBA
	ld		[sys_GBType],a
	; spoof check!
	ld		hl,$8000
	ld		a,$56
	ld		[hl],a
	ld		b,a
	ld		a,1
	ldh		[rVBK],a	; rVBK is not supported on DMG
	ld		a,b
	cp		[hl]
	jr		z,GBCOnlyScreen
	xor		a
	ld		[rVBK],a
	; emu check!
	; layer 1: echo RAM
	ld		a,$56
	ld		[sys_EmuCheck],a
	ld		b,a
	ld		a,[sys_EmuCheck+$2000]	; read from echo RAM
	cp		b
	jp		z,SkipGBCScreen
EmuScreen:
	; since we're on an emulator we don't need to wait for VBlank before disabling the LCD	
	xor		a
	ldh		[rLCDC],a	; disable LCD
	ld		a,bank(Pal_EmuScreen)
	ld		[rROMB0],a
	ld		hl,Pal_EmuScreen
	xor		a
	call	LoadPal
	ld		hl,Font
	ld		de,$8000
	call	DecodeWLE
	ld		hl,EmuText
	call	LoadTilemapText
	ld		a,%10010001
	ldh		[rLCDC],a
	ld		a,IEF_VBLANK
	ldh		[rIE],a
	ei
EmuLoop:
	halt
	jr		EmuLoop
GBCOnlyScreen:
	xor		a
	ld		[sys_GBType],a
	
	; GBC only screen
	SetDMGPal	rBGP,0,3,3,0
	ld		hl,Font
	ld		de,$8000
	call	DecodeWLE
	ld		hl,GBCOnlyText
	call	LoadTilemapText
	
	ld		a,%10010001
	ldh		[rLCDC],a
	
	ld		a,IEF_VBLANK
	ldh		[rIE],a
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
	
; ========================================================================

SkipGBCScreen:
	; clear vars
	xor		a
	ld		[sys_ResetTimer],a
	ld		[sys_CurrentFrame],a
	ld		[sys_btnPress],a
	ld		[sys_btnHold],a
	ld		[sys_VBlankFlag],a
	ld		[sys_TimerFlag],a
	ld		[sys_LCDCFlag],a
	; clear OAM buffer
	ld		hl,OAMBuffer
	ld		b,40*4
	xor		a
	call	_FillRAMSmall
	
	; clear GHX's RAM
	ld		hl,$de00
	ld		b,0
	xor		a
	call	_FillRAMSmall
	
	call	DoubleSpeed
	
	jp		GM_Level
	; fall through
	
; ================================

include	"Engine/DebugMenu.asm"

; ================================

GM_SplashScreens:
	; TODO
	ret
	
; ================================

GM_TitleAndMenus:
	; TODO
	ret

; ================================

include	"Engine/Level.asm"
	
; Metatile format:
; 16x16, 2 bytes per tile
; - First byte of tile for tile ID
; - Second byte of tile for attributes
	
ParallaxTileset:
	; background 1 (horizontal + vertical parallax)
	db	$00,%00000000,$01,%00000000
	db	$02,%00000000,$03,%00000000
	; background 2 (horizontal + vertical parallax)
	db	$04,%00000000,$05,%00000000
	db	$06,%00000000,$07,%00000000
	; background 3 (horizontal parallax)
	db	$08,%00000000,$09,%00000000
	db	$0a,%00000000,$0b,%00000000
	; background 4 (horizontal parallax)
	db	$0c,%00000000,$0d,%00000000
	db	$0e,%00000000,$0f,%00000000
	; solid tile
	db	$10,%00000001,$12,%00000001
	db	$11,%00000001,$13,%00000001
	; foreground tile
	db	$17,%10000010,$17,%10100010
	db	$17,%11000010,$17,%11100010
	; topsolid tile (background 1)
	db	$14,%00000001,$15,%00000001
	db	$02,%00000001,$03,%00000001
	; topsolid tile (background 2)
	db	$14,%00000001,$15,%00000001
	db	$06,%00000001,$07,%00000001
	; topsolid tile (background 3)
	db	$14,%00000001,$15,%00000001
	db	$0a,%00000001,$0b,%00000001
	; topsolid tile (background 4)
	db	$14,%00000001,$15,%00000001
	db	$0e,%00000001,$0f,%00000001

; ==================
; Interrupt handlers
; ==================

DoVBlank::
	push	af
	push	bc
	push	de
	push	hl
	ld	a,1
	ld	[sys_VBlankFlag],a		; set VBlank flag
	
	ld	a,[sys_CurrentFrame]
	inc	a
	ld	[sys_CurrentFrame],a	; increment current frame
	call	CheckInput
	rst		DoOAMDMA
	
	; setup HDMA for parallax GFX transfer
	xor		a
	ldh		[rVBK],a
	ld		a,high(Engine_ParallaxBuffer)
	ldh		[rHDMA1],a	; HDMA source high
	ld		a,low(Engine_ParallaxBuffer)
	ldh		[rHDMA2],a	; HDMA source low
	ld		a,[Engine_ParallaxDest]
	ldh		[rHDMA3],a	; HDMA dest high
	xor		a
	ldh		[rHDMA4],a	; HDMA dest low
	ld		a,%00001111
	ldh		[rHDMA5],a	; HDMA length + type (length 256, hblank wait)
	
	ld		a,[Engine_CameraX]
	ldh		[rSCX],a
	ld		a,[Engine_CameraY]
	ldh		[rSCY],a
	
;	call	Pal_DoFade

	; A+B+Start+Select restart sequence
	ld		a,[sys_btnHold]
	cp		_A+_B+_Start+_Select	; is A+B+Start+Select pressed
	jr		nz,.noreset				; if not, skip
	ld		a,[sys_ResetTimer]		; get reset timer
	inc		a
	ld		[sys_ResetTimer],a		; store reset timer
	cp		60						; has 1 second passed?
	jr		nz,.continue			; if not, skip
	ld		a,[sys_GBType]			; get current GB model
	dec		a						; GBC?
	jr		z,.gbc					; if yes, jump
	dec		a						; GBA?
	jr		z,.gba					; if yes, jump
.dmg								; default case: assume DMG
	xor		a						; a = 0, b = whatever
	jr		.dorestart
.gbc								; a = $11, b = 0
	ld		a,$11
	ld		b,0
	jr		.dorestart
.gba								; a = $11, b = 1
	ld		a,$11
	ld		b,1
	; fall through to .dorestart
.dorestart
	jp		ProgramStart			; restart game
.noreset							; if A+B+Start+Select aren't held...
	xor		a
	ld		[sys_ResetTimer],a		; reset timer
.continue							; done

	ldh		a,[rSVBK]
	ldh		[sys_TempSVBK],a
	ld		a,1
	ldh		[rSVBK],a
	farcall	GHX_Update
	ldh		a,[sys_TempSVBK]
	ldh		[rSVBK],a

	pop		hl
	pop		de
	pop		bc
	pop		af
	reti
	
DoStat::
	push	af
	ld		a,1
	ld		[sys_LCDCFlag],a
	pop		af
	reti
	
DoTimer::
	push	af
	ld		a,1
	ld		[sys_TimerFlag],a
	pop		af
	reti
	
DoSerial::
	push	af
	ld		a,1
	ld		[sys_SerialFlag],a
	pop		af
	reti
	
DoJoypad::
	push	af
	ld		a,1
	ld		[sys_JoypadFlag],a
	pop		af
	reti
	
; =======================
; Interrupt wait routines
; =======================

_WaitVBlank::
	push	af
	ldh		a,[rIE]
	bit		0,a
	jr		z,.done
.wait
	halt
	ld		a,[sys_VBlankFlag]
	and		a
	jr		z,.wait
	xor		a
	ld		[sys_VBlankFlag],a
.done
	pop		af
	ret

_WaitLCDC::
	push	af
	ldh		a,[rIE]
	bit		1,a
	jr		z,.done
.wait
	halt
	ld		a,[sys_LCDCFlag]
	and		a
	jr		z,.wait
	xor		a
	ld		[sys_LCDCFlag],a
.done
	pop		af
	ret
	
_WaitTimer::
	push	af
	ldh		a,[rIE]
	bit		2,a
	jr		z,.done
.wait
	halt
	ld		a,[sys_TimerFlag]
	and		a
	jr		z,.wait
	xor		a
	ld		[sys_VBlankFlag],a
.done
	pop		af
	ret

_WaitSerial::
	push	af
	ldh		a,[rIE]
	bit		3,a
	jr		z,.done
.wait
	halt
	ld		a,[sys_SerialFlag]
	and		a
	jr		z,.wait
	xor		a
	ld		[sys_SerialFlag],a
.done
	pop		af
	ret
	
_WaitJoypad:
	push	af
	ldh		a,[rIE]
	bit		4,a
	jr		z,.done
.wait
	halt
	ld		a,[sys_JoypadFlag]
	and		a
	jr		z,.wait
	xor		a
	ld		[sys_JoypadFlag],a
.done
	pop		af
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
	ld	bc,low(OAM_DMA) + ((_OAM_DMA_End-_OAM_DMA) << 8)
	ld	hl,_OAM_DMA
.loop
	ld	a,[hl+]
	ld	[c],a
	inc	c
	dec	b
	jr	nz,.loop
	ret
	
_OAM_DMA::
	ld	a,high(OAMBuffer)
	ldh	[rDMA],a
	ld	a,$28
.wait	; wait for OAM DMA to finish
	dec	a
	jr	nz,.wait
	ret
_OAM_DMA_End:

; =============
; Misc routines
; =============

; INPUT: b = bank
_Bankswitch:
	push	af
	ldh		a,[sys_CurrentBank]
	ldh		[sys_LastBank],a
	ld		a,b
	ldh		[sys_CurrentBank],a
	ld		[rROMB0],a
	pop		af
	ret
	
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
angle=0.0
	rept	256
	db	mul(127.0,cos(angle)+1.0)>>16
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
include	"Parallax.asm"
include	"Player.asm"

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
	
Pal_TestMap:
	RGB	 0, 0, 0
	RGB	 3, 3, 3
	RGB	 7, 7, 7
	RGB	15,15,15
	
	RGB	 0, 0, 0
	RGB	 0,15,31
	RGB	15,31,31
	RGB	31,31,31
	
	RGB	 0, 0, 0
	RGB	31, 0, 0
	RGB	31,31, 0
	RGB	31,31,31
	
	RGB	 0, 0, 0
	RGB	31, 0, 0
	RGB	31,31, 0
	RGB	31,31,31
	
	RGB	 0, 0, 0
	RGB	31, 0, 0
	RGB	31,31, 0
	RGB	31,31,31
	
	RGB	 0, 0, 0
	RGB	31, 0, 0
	RGB	31,31, 0
	RGB	31,31,31
	
	RGB	 0, 0, 0
	RGB	31, 0, 0
	RGB	31,31, 0
	RGB	31,31,31
	
	RGB	 0, 0, 0
	RGB	31, 0, 0
	RGB	31,31, 0
	RGB	31,31,31
Pal_TestMap_End:

Pal_Player:
	RGB	31, 0,31
	RGB	 0, 0, 0
	RGB	 0,15,31
	RGB	31,31,31
Pal_Player_End:

TestMapTiles:
ParallaxTiles:
	incbin	"GFX/ParallaxTiles.2bpp"
ParallaxTiles_End:

	incbin	"GFX/TestTiles.2bpp"
TestMapTiles_End:

section "Player tiles",romx,align[8]
PlayerTiles:
	incbin	"GFX/PlayerTiles.2bpp"

; ==========
; Level data
; ==========

include "Levels/TestMap.inc"

; ==========
; Sound data
; ==========

section "GHX sound driver + data",romx
GHX_Play:	incbin	"Music.bin",$0,3	; $4000
GHX_Update:	incbin	"Music.bin",$3,3	; $4003
GHX_Unk1:	incbin	"Music.bin",$6,3	; $4006
GHX_Unk2:	incbin	"Music.bin",$9,3	; $4009
GHX_Init:	incbin	"Music.bin",$c,3	; $400c
GHX_Unk3:	incbin	"Music.bin",$f,3	; $400f
GHX_Data:	incbin	"Music.bin",$12