; =======================
; Rebound GBC main source
; =======================

; If set to 1, enable debugging features.
DebugMode   = 1

; Defines
include "Defines.asm"

; =============
; Reset vectors
; =============
section "Reset $00",rom0[$00]
Trap00::        jr  @
    
section "Reset $08",rom0[$08]
FillRAM::       jp  _FillRAM
    
section "Reset $10",rom0[$10]
WaitVBlank::    jp  _WaitVBlank

section "Reset $18",rom0[$18]
WaitTimer::     jp  _WaitTimer

section "Reset $20",rom0[$20]
WaitLCDC::      jp  _WaitLCDC
    
section "Reset $30",rom0[$30]
DoOAMDMA::      jp  $ff80

section "Reset $38",rom0[$38]
Trap::          jr  @
    
    
; ==================
; Interrupt handlers
; ==================

section "VBlank IRQ",rom0[$40]
IRQ_VBlank::    jp  DoVBlank

section "STAT IRQ",rom0[$48]
IRQ_Stat::      jp  DoStat

section "Timer IRQ",rom0[$50]
IRQ_Timer::     jp  DoTimer

section "Serial IRQ",rom0[$58]
IRQ_Serial::    jp  DoSerial

section "Joypad IRQ",rom0[$60]
IRQ_Joypad::    jp  DoJoypad

; ===============
; System routines
; ===============
    
; ================================================================
; Call HL
; ================================================================

_CallHL:
    ld      a,h
    bit     7,a
    jr      nz,@    ; trap
.skip
    jp      hl

; ==========
; ROM header
; ==========

section "ROM header",rom0[$100]

EntryPoint::
    nop
    jp  ProgramStart
if !def(BUILD_POCKET)
NintendoLogo:   ds  48,0                        ; Nintendo logo bitmap (handled by post-linking tool)
else
AnalogueLogo:   
    db      $01,$10,$CE,$EF,$00,$00,$44,$AA,$00,$74,$00,$18,$11,$95,$00,$34
    db      $00,$1A,$00,$D5,$00,$22,$00,$69,$6F,$F6,$F7,$73,$09,$90,$E1,$10
    db      $44,$40,$9A,$90,$D5,$D0,$44,$30,$A9,$21,$5D,$48,$22,$E0,$F8,$60
endc
ROMTitle:       dbp "REBOUND",15,0              ; ROM title (15 bytes)
GBCSupport:     db  $C0                         ; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
NewLicenseCode: db  "56"                        ; new license code (2 bytes)
SGBSupport:     db  0                           ; SGB support
CartType:       db  $19                         ; Cart type, see hardware.inc for a list of values
ROMSize:        db  0                           ; ROM size (handled by post-linking tool)
RAMSize:        db  0                           ; RAM size
DestCode:       db  1                           ; Destination code (0 = Japan, 1 = All others)
OldLicenseCode: db  $33                         ; Old license code (if $33, check new license code)
ROMVersion:     db  0                           ; ROM version
HeaderChecksum: db  0                           ; Header checksum (handled by post-linking tool)
ROMChecksum:    dw  0                           ; ROM checksum (2 bytes) (handled by post-linking tool)

; =====================
; Start of program code
; =====================

section fragment "Program code",rom0[$150]
ProgramStart::
    di
    ld      sp,$d000
    ; preserve A and B for later to determine console type
    push    bc
    push    af

    ; wait for VBlank before disabling LCD
    ld      hl,rLY
    ld      a,SCRN_Y
.wait
    cp      [hl]
    jr      nz,.wait
    xor     a
    ldh     [rLCDC],a   ; disable LCD
    
    ld      [sys_PauseGame],a
    ld      a,60
    ld      [sys_SleepModeTimer],a
    ld      [sys_SecondsUntilSleep],a

    farcall DevSound_Stop   ; prevent glitch music from playing
    
    ; clear HRAM    
    ld      bc,$7f80
    xor     a
.loop
    ld      [c],a
    inc     c
    dec     b
    jr      nz,.loop
    call    CopyDMARoutine
    
    call    ClearScreen
    
; check GB type
; sets sys_GBType to 0 if DMG/SGB/GBP/GBL/SGB2, 1 if GBC, 2 if GBA/GBA SP/GB Player
    pop     af
    pop     bc
    cp      $11
    jp      nz,GBCOnlyScreen
.gbc
    and     1       ; a = 1
    add     b       ; b = 1 if on GBA
    ld      [sys_GBType],a
    ; spoof check!
    ; makes use of a register that only exists in CGB mode (namely the VRAM bank register)
    ld      hl,_VRAM
    ld      [hl],a
    ld      b,a
    ld      a,1
    ldh     [rVBK],a    ; rVBK is not supported on DMG
    ld      a,b
    cp      [hl]
    jr      z,GBCOnlyScreen
    xor     a
    ld      [rVBK],a
    ; emulator check!
    ; uses echo RAM - any write to WRAM will reflect in echo RAM and vice versa
    ld      a,b
    ld      [sys_EmuCheck],a        ; store value
    ld      a,[sys_EmuCheck+$2000]  ; read value back from echo RAM
    cp      b                       ; do they match?
    jp      z,SkipGBCScreen         ; if yes, emulator check passed
EmuScreen:                          ; otherwise, emulator check failed
    ldfar   hl,Pal_DebugScreen
    xor     a
    call    LoadPal
    call    CopyPalettes
    
    ldfar   hl,Font
    ld      de,$8000
    call    DecodeWLE
    
    ldfar   hl,EmuText
    call    LoadTilemapText

    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a
    ei

:   halt    
    jr      :-          ; infinite loop

GBCOnlyScreen:
    xor     a
    ld      [sys_GBType],a
    
    ; GBC only screen
    SetDMGPal   rBGP,0,3,3,0
    
    ldfar   hl,Font
    ld      de,$8000
    call    DecodeWLE
    
    ldfar   hl,GBCOnlyText
    call    LoadTilemapText
    
    ld      a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
    ldh     [rLCDC],a
    ld      a,IEF_VBLANK
    ldh     [rIE],a

:   halt    
    jr      :-          ; infinite loop

section	"DMG and emulator lockout screen text",romx
GBCOnlyText:    ; 20x18 char tilemap
    db  "                    "
    db  "    - REBOUND! -    "
    db  "                    "
    db  "   THIS GAME WILL   "
    db  "   ONLY WORK ON A   "
    db  "   GAME BOY COLOR   "
    db  "    OR A GAME BOY   "
    db  "      ADVANCE.      "
    db  "                    "
    db  "    PLEASE USE A    "
    db  "   GAME BOY COLOR   "
    db  "    OR A GAME BOY   "
    db  "     ADVANCE TO     "
    db  "   PLAY THIS GAME.  "
    db  "                    "
    db  "                    "
    db  "                    "
    db  "                    "
EmuText:
    db  "                    "
    db  "    - REBOUND! -    "
    db  "                    "
    db  "                    "
    db  "                    "
    db  "   THIS GAME WILL   "
    db  "  NOT WORK IN YOUR  "
    db  "      EMULATOR.     "
    db  "                    "
    db  "    PLEASE USE A    "
    db  "   NEWER EMULATOR   "
    db  " SUCH AS SAMEBOY OR "
    db  "  BGB TO PLAY THIS  "
    db  "        GAME.       "
    db  "                    "
    db  "                    "
    db  "                    "
    db  "                    "

section fragment "Program code",rom0

; ========================================================================

SkipGBCScreen:
    ; clear vars
    xor     a
    ld      [sys_ResetTimer],a
    ld      [sys_CurrentFrame],a
    ld      [sys_btnPress],a
    ld      [sys_btnHold],a
    ld      [sys_VBlankFlag],a
    ld      [sys_TimerFlag],a
    ld      [sys_LCDCFlag],a
    ld      [VGMSFX_Flags],a
    ld      [Engine_CameraX],a
    ld      [Engine_CameraY],a
    ld      [sys_EnableHDMA],a
    ld      [Player_CoinCount],a
    ld      [Player_CoinCount+1],a
    
    call    DoubleSpeed
    if      !DebugMode
        jp  GM_SplashScreens
    else
        jp  GM_DebugMenu
    endc
    
; ================================

include "Engine/GameModes/DebugMenu.asm"

; ================================

include "Engine/GameModes/SplashScreens.asm"

; ================================

include "Engine/GameModes/TitleAndMenus.asm"

; ================================

include "Engine/GameModes/SoundTest.asm"

; ================================

include "Engine/GameModes/SFXTest.asm"

; ================================

include "Engine/GameModes/LevelSelect.asm"

; ================================

include "Engine/GameModes/Level.asm"

; ================================

include "Engine/GameModes/Credits.asm"

; ================================

include "Engine/GameModes/EndScreen.asm"

; ================================

include "Engine/GameModes/GameOverScreen.asm"

; ================================

; include "Engine/GameModes/Gallery.asm"

; ================================

; ==================
; Interrupt handlers
; ==================

section "Interrupt handlers",rom0

DoVBlank::
    push    af
    push    bc
    push    de
    push    hl
    ld  a,1
    ld  [sys_VBlankFlag],a      ; set VBlank flag
    
    call    UpdatePalettes
    ld      a,[sys_PauseGame]
    and     a                   ; is game paused?
    jr      nz,:+               ; if yes, skip frame counter tick
    ld  a,[sys_CurrentFrame]
    inc a
    ld  [sys_CurrentFrame],a    ; tick frame counter
:
    ; check input
    ld      a,[sys_btnHold]
    ld      c,a
    ld      a,P1F_5
    ldh     [rP1],a
    ldh     a,[rP1]
    ldh     a,[rP1]
    cpl
    and     $f
    swap    a
    ld      b,a
    
    ld      a,P1F_4
    ldh     [rP1],a
    ldh     a,[rP1]
    ldh     a,[rP1]
    ldh     a,[rP1]
    ldh     a,[rP1]
    ldh     a,[rP1]
    ldh     a,[rP1]
    cpl
    and     $f
    or      b
    ld      b,a
    
    ld      a,[sys_btnHold]
    xor     b
    and     b
    ld      [sys_btnPress],a    ; store buttons pressed this frame
    ld      e,a
    ld      a,b
    ld      [sys_btnHold],a     ; store held buttons
    xor     c
    xor     e
    ld      [sys_btnRelease],a  ; store buttons released this frame
    ld      a,P1F_5|P1F_4
    ld      [rP1],a
    
:   ; setup HDMA for parallax GFX transfer
    ld      a,[sys_EnableHDMA]
    and     a
    jr      z,.skiphdma ; skip ahead if HDMA is disabled
    xor     a
    ldh     [rVBK],a
    ld      a,high(Engine_ParallaxBuffer)
    ldh     [rHDMA1],a  ; HDMA source high
    ld      a,low(Engine_ParallaxBuffer)
    ldh     [rHDMA2],a  ; HDMA source low
    ld      a,[Engine_ParallaxDest]
    ldh     [rHDMA3],a  ; HDMA dest high
    xor     a
    ldh     [rHDMA4],a  ; HDMA dest low
    ld      a,%00001111
    ldh     [rHDMA5],a  ; HDMA length + type (length 256, hblank wait)
    ; wait for transfer to finish
:   ldh     a,[rHDMA5]
    inc     a           ; rHDMA5 = $FF? (indicates HDMA transfer is finished)
    jr      nz,:-       ; if not, wait until it is
    ; setup HDMA for player GFX transfer    
    ld      a,[sys_HDMABank]
    ld      b,a
    call    _Bankswitch
    ld      a,1
    ldh     [rVBK],a
    ld      a,[sys_HDMA1]
    ldh     [rHDMA1],a
    ld      a,[sys_HDMA2]
    ldh     [rHDMA2],a
    ld      a,[sys_HDMA3]
    ldh     [rHDMA3],a
    ld      a,[sys_HDMA4]
    ldh     [rHDMA4],a
    ld      a,[sys_HDMA5]
    ldh     [rHDMA5],a
.skiphdma
    ; set camera position
    ld      a,[Engine_CameraX]
    ldh     [rSCX],a
    ld      a,[Engine_CameraY]
    ldh     [rSCY],a
    rst     DoOAMDMA

    ; A+B+Start+Select restart sequence
    ld      a,[sys_btnHold]
    cp      _A+_B+_Start+_Select    ; is A+B+Start+Select pressed?
    jr      nz,.noreset             ; if not, skip
    ld      a,[sys_ResetTimer]      ; get reset timer
    inc     a
    ld      [sys_ResetTimer],a      ; store reset timer
    cp      60                      ; has 1 second passed?
    jr      nz,.continue            ; if not, skip
    ld      a,[sys_GBType]          ; get current GB model
    dec     a                       ; GBC?
    jr      z,.gbc                  ; if yes, jump
    dec     a                       ; GBA?
    jr      z,.gba                  ; if yes, jump
.dmg                                ; default case: assume DMG
    xor     a                       ; a = 0, b = whatever
    jr      .dorestart
.gbc                                ; a = $11, b = 0
    ld      a,$11
    ld      b,0
    jr      .dorestart
.gba                                ; a = $11, b = 1
    ld      a,$11
    ld      b,1
    ; fall through to .dorestart
.dorestart
    ld      hl,rHDMA5
    set     0,[hl]                  ; cancel any pending HDMA transfers
    jp      ProgramStart            ; restart game
.noreset                            ; if A+B+Start+Select aren't held...
    xor     a
    ld      [sys_ResetTimer],a      ; reset timer
.continue                           ; done
    
    ; sound update
    ld      a,[sys_PauseGame]
    and     a
    jr      nz,:+                   ; don't update music if game is paused
    farcall DevSound_Play
:   call    VGMSFX_Update           ; *do* update SFX while game is paused (for pause sound)
   
    call    Pal_DoFade              ; do palette fading

    pop     hl
    pop     de
    pop     bc
    pop     af
    reti                            ; done!
   
DoStat::
    push    af
    ld      a,1
    ld      [sys_LCDCFlag],a
    pop     af
    reti

; Currently not used
DoTimer::
    push    af
    ld      a,1
    ld      [sys_TimerFlag],a
    pop     af
    reti

; Currently not used
DoSerial::
    push    af
    ld      a,1
    ld      [sys_SerialFlag],a
    pop     af
    reti

; Currently not used
DoJoypad::
    push    af
    ld      a,1
    ld      [sys_JoypadFlag],a
    pop     af
    reti
    
; =======================
; Interrupt wait routines
; =======================

; Wait for vertical blank.
_WaitVBlank::
    push    af
    ldh     a,[rIE]
    bit     0,a
    jr      z,.done
.wait
    halt
    ld      a,[sys_VBlankFlag]
    and     a
    jr      z,.wait
    xor     a
    ld      [sys_VBlankFlag],a
.done
    pop     af
    ret

; Wait for LCD status interrupt.
_WaitLCDC::
    push    af
    ldh     a,[rIE]
    bit     1,a
    jr      z,.done
.wait
    halt
    ld      a,[sys_LCDCFlag]
    and     a
    jr      z,.wait
    xor     a
    ld      [sys_LCDCFlag],a
.done
    pop     af
    ret

; Wait for timer interrupt. (Currently unused)
_WaitTimer::
    push    af
    ldh     a,[rIE]
    bit     2,a
    jr      z,.done
.wait
    halt
    ld      a,[sys_TimerFlag]
    and     a
    jr      z,.wait
    xor     a
    ld      [sys_VBlankFlag],a
.done
    pop     af
    ret

; Wait for serial transfer interrupt. (Currently unused)
_WaitSerial::
    push    af
    ldh     a,[rIE]
    bit     3,a
    jr      z,.done
.wait
    halt
    ld      a,[sys_SerialFlag]
    and     a
    jr      z,.wait
    xor     a
    ld      [sys_SerialFlag],a
.done
    pop     af
    ret

; Wait for joypad interrupt. (Currently unused)
_WaitJoypad: 
    push    af
    ldh     a,[rIE]
    bit     4,a
    jr      z,.done
.wait
    halt
    ld      a,[sys_JoypadFlag]
    and     a
    jr      z,.wait
    xor     a
    ld      [sys_JoypadFlag],a
.done
    pop     af
    ret
    
; =================
; Graphics routines
; =================

include "Engine/PerFade.asm"    ; Palette routines

; =========

; Clear the screen.
; TRASHES: a, bc, hl
; RESTRICTIONS: Requires the LCD to be disabled, otherwise screen will not be properly cleared.
ClearScreen:
    ; clear VRAM bank 0
    xor     a
    ldh     [rVBK],a
    ld      hl,_VRAM        ; clear from start of VRAM...
    ld      bc,_SRAM-_VRAM   ; ...to end of VRAM.
    rst     FillRAM
    
    ; clear VRAM bank 1
    ld      a,1
    ldh     [rVBK],a
    ldh     [sys_TempSVBK],a
    xor     a
    ld      hl,_VRAM        ; clear from start of VRAM...
    ld      bc,_SRAM-_VRAM   ; ...to end of VRAM.
    rst     FillRAM
    xor     a
    ldh     [rVBK],a
    
    ; clear OAM
    ld      hl,OAMBuffer
    ld      b,OAMBuffer.end-OAMBuffer
    xor     a
    call    _FillRAMSmall
    
    ; clear palette buffers
    xor     a
    ld      hl,sys_PalTransferBuf
    ld      bc,sys_PalBuffersEnd-sys_PalTransferBuf
    rst     FillRAM

    ; reset scrolling
    xor     a
    ldh     [rSCX],a
    ldh     [rSCY],a
    ld      [Engine_CameraX],a
    ld      [Engine_CameraY],a
    ld      [sys_EnableHDMA],a
    ldh     [rHDMA5],a  ; cancel pending HDMA transfers
    ret

; Loads a 20x18 tilemap to VRAM.
; INPUT:   hl = source
; TRASHES: a, bc, de, hl
; RESTRICTIONS: Must run during VBlank or while VRAM is accessible, otherwise written data will be corrupted
LoadTilemapScreen:
    ld  de,_SCRN0
    lb  bc,$12,$14
.loop
    ld  a,[hl+]
    ld  [de],a
    inc de
    dec c
    jr  nz,.loop
    ld  c,$14
    ld  a,e
    add $c
    jr  nc,.continue
    inc d
.continue
    ld  e,a
    dec b
    jr  nz,.loop
    ret

; Same as LoadTilemapScreen, but performs ASCII conversion.
; INPUT:   hl = source
; TRASHES: a, bc, de, hl
; RESTRICTIONS: Must run during VBlank or while VRAM is accessible, otherwise written data will be corrupted
LoadTilemapText:
    ld  de,_SCRN0
    lb  bc,$12,$14
.loop
    ld  a,[hl+]
    sub " "
    ld  [de],a
    inc de
    dec c
    jr  nz,.loop
    ld  c,$14
    ld  a,e
    add $C
    jr  nc,.continue
    inc d
.continue
    ld  e,a
    dec b
    jr  nz,.loop
    ret

; Prints a null-terminated string.
; INPUT:   hl = source
;          de = destination
PrintString:
    WaitForVRAM
    ld      a,[hl+]
    and     a           ; terminator byte reached?
    ret     z           ; if yes, return
    sub     " "
    ld      [de],a
    inc     de
    jr      PrintString    

; ============
; Sprite stuff
; ============

; Copies OAM DMA routine to HRAM.
; Called once during startup sequence.
; TRASHES: a, bc, hl
CopyDMARoutine::
    ld  bc,low(OAM_DMA) + ((_OAM_DMA_End-_OAM_DMA) << 8)
    ld  hl,_OAM_DMA
.loop
    ld  a,[hl+]
    ld  [c],a
    inc c
    dec b
    jr  nz,.loop
    ret

; OAM DMA routine.
; This is copied to HRAM by CopyDMARoutine and run from there.
; TRASHES: a
_OAM_DMA::
    ld  a,high(OAMBuffer)
    ldh [rDMA],a
    ld  a,$28
.wait   ; wait for OAM DMA to finish
    dec a
    jr  nz,.wait
    ret
_OAM_DMA_End:

include "Engine/Sprite.asm" ; Sprite routines

; =============
; Misc routines
; =============

; include "Engine/GBPrinter.asm"

; ================

; Performs a bankswitch to bank B, preserving previous ROM bank.
; INPUT:    b = bank
_Bankswitch:
    push    af
    ldh     a,[sys_CurrentBank]
    ldh     [sys_LastBank],a        ; preserve old ROM bank
    ld      a,b
    ldh     [sys_CurrentBank],a     ; set new ROM bank
    ld      [rROMB0],a              ; perform bankswitch
    pop     af
    ret
    
; Fill RAM with a value.
; INPUT:    a = value
;          hl = address
;          bc = size
; TRASHES: a, bc, e, hl
_FillRAM::
    ld  e,a
.loop
    ld  [hl],e
    inc hl
    dec bc
    ld  a,b
    or  c
    jr  nz,.loop
    ret
    
; Fill up to 256 bytes of RAM with a value.
; INPUT:    a = value
;          hl = address
;           b = size
; TRASHES: a, b, e, hl
_FillRAMSmall::
    ld  e,a
.loop
    ld  [hl],e
    inc hl
    dec b
    jr  nz,.loop
    ret

; ================
    
; Copy up to 65536 bytes to RAM.
; INPUT:   hl = source
;          de = destination
;          bc = size
; TRASHES: a, bc, de, hl
_CopyRAM::
    ld  a,[hl+]
    ld  [de],a
    inc de
    dec bc
    ld  a,b
    or  c
    jr  nz,_CopyRAM
    ret
    
; Copy up to 256 bytes to RAM.
; INPUT:   hl = source
;          de = destination
;           b = size
; TRASHES: a, b, de, hl
_CopyRAMSmall::
    ld  a,[hl+]
    ld  [de],a
    inc de
    dec b
    jr  nz,_CopyRAMSmall
    ret

; ================

; Switches double speed mode on.
; TRASHES: a
DoubleSpeed:
    ldh a,[rKEY1]
    bit 7,a         ; already in double speed?
    ret nz          ; if yes, return
    ld  a,%00110000
    ldh [rP1],a
    xor %00110001   ; a = %00000001
    ldh [rKEY1],a   ; prepare speed switch
    stop
    ret

include "Engine/WLE_Decode.asm"
    
; =============
; Misc routines
; =============

; Calculate a sine wave.
; INPUT:    a = angle
; OUTPUT:   d = cosine
;           e = sine
; TRASHES:  bc, hl, flags, ROM bank
GetSine:
	ldfar	hl,SineTable
	ld		c,a
	ld		b,0
	add		hl,bc
	ld		d,[hl]
    ld      hl,CosineTable
	add		hl,bc
	ld		e,[hl]
    resbank
	ret

section "Sine table",romx
SineTable:
    db         0,   3,   6,   9,  12,  16,  19,  22,  25,  28,  31,  34,  37,  40,  43,  46
    db        49,  52,  55,  57,  60,  63,  66,  68,  71,  73,  76,  78,  81,  83,  86,  88
    db        90,  92,  94,  97,  99, 101, 102, 104, 106, 108, 109, 111, 112, 114, 115, 117
    db       118, 119, 120, 121, 122, 123, 124, 124, 125, 126, 126, 127, 127, 127, 127, 127
CosineTable:
    db       127, 127, 127, 127, 127, 127, 126, 126, 125, 124, 124, 123, 122, 121, 120, 119
    db       118, 117, 115, 114, 112, 111, 109, 108, 106, 104, 102, 101,  99,  97,  94,  92
    db        90,  88,  86,  83,  81,  78,  76,  73,  71,  68,  66,  63,  60,  57,  55,  52
    db        49,  46,  43,  40,  37,  34,  31,  28,  25,  22,  19,  16,  12,   9,   6,   3
    db         0,  -3,  -6,  -9, -12, -16, -19, -22, -25, -28, -31, -34, -37, -40, -43, -46
    db       -49, -52, -55, -57, -60, -63, -66, -68, -71, -73, -76, -78, -81, -83, -86, -88
    db       -90, -92, -94, -97, -99,-101,-102,-104,-106,-108,-109,-111,-112,-114,-115,-117
    db      -118,-119,-120,-121,-122,-123,-124,-124,-125,-126,-126,-127,-127,-127,-127,-127
    db      -127,-127,-127,-127,-127,-127,-126,-126,-125,-124,-124,-123,-122,-121,-120,-119
    db      -118,-117,-115,-114,-112,-111,-109,-108,-106,-104,-102,-101, -99, -97, -94, -92
    db       -90, -88, -86, -83, -81, -78, -76, -73, -71, -68, -66, -63, -60, -57, -55, -52
    db       -49, -46, -43, -40, -37, -34, -31, -28, -25, -22, -19, -16, -12,  -9,  -6,  -3
    db         0,   3,   6,   9,  12,  16,  19,  22,  25,  28,  31,  34,  37,  40,  43,  46
    db        49,  52,  55,  57,  60,  63,  66,  68,  71,  73,  76,  78,  81,  83,  86,  88
    db        90,  92,  94,  97,  99, 101, 102, 104, 106, 108, 109, 111, 112, 114, 115, 117
    db       118, 119, 120, 121, 122, 123, 124, 124, 125, 126, 126, 127, 127, 127, 127, 127


section "Misc routines",rom0

include "Engine/Metatile.asm"
include "Engine/Parallax.asm"
include "Engine/Player.asm"
include "Engine/Object.asm"
	
; 16-bit Compare
; INPUT:   bc = value 1
;          de = value 2
; OUTPUT:  zero = set if equal
;          carry = set if bc < de
; TRASHES: a
Compare16:
    ld  a,b
    cp  d
    ret nz
    ld  a,c
    cp  e
    ret

; INPUT:                  a = hexadecimal number
; OUTPUT:  sys_StringBuffer = converted number
; TRASHES: bc, hl
; Adapted from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Other:DispA
Hex2Dec8:
    ld      hl,sys_StringBuffer
    ld      c,-100
    call    :+      ; hundreds place
    ld      c,-10
    call    :+      ; tens place
    ld      c,-1
:   ld      b,-1
:   inc     b
    add     c
    jr      c,:-
    sub     c
    push    af
    ld      a,b
    ld      [hl+],a
    pop     af
    ret
    
; INPUT:                 hl = decimal number
; OUTPUT:  sys_StringBuffer = hexadecimal number
; TRASHES: a, bc, de, hl
; Adapted from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Other:DispHL
Hex2Dec16:
    ld      de,sys_StringBuffer
    ld      bc,-10000
    call    :+          ; ten-thousands place
    ld      bc,-1000
    call    :+          ; thousands place
    ld      bc,-100
    call    :+          ; hundreds place
    ld      bc,-10
    call    :+          ; tens place
    ld      c,b
:   ld      a,-1
:   inc     a
    add     hl,bc
    jr      c,:-
    ldh     [sys_TempCounter],a
    ; equivalent to sbc hl,bc - thanks to ISSOtm for this!
    ld      a,l
    sub     c ; or `sbc c` for `sbc hl, bc` instead of `sub hl, bc`
    ld      l,a
    ld      a,h
    sbc     b
    ld      h,a
    ; end of sbc hl,bc
    ldh     a,[sys_TempCounter]
    ld      [de],a
    inc     de
    ret
    
; ==============
; Sound routines
; ==============

include "Audio/VGMSFX.asm"
include "Audio/DevSound.asm"

; =============
; Graphics data
; =============

section "Font",romx
Font::          incbin  "GFX/Font.bin.wle"

include	"GFX/Sprites/Goony/Goony.inc"
include "GFX/Sprites/Fish.inc"
include "GFX/Sprites/1up.inc"
include "GFX/Sprites/StageClear.inc"

section "Particle tiles",romx
ParticleTiles:  incbin  "GFX/Particles.2bpp.wle"
    
section "HUD graphics",romx
HUDTiles:       incbin  "GFX/HUD.2bpp.wle"

section "Palette data",romx
include "Data/Palettes.asm"
