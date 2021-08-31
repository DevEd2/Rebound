; ================================================================
; DevSound Lite - a Game Boy music system by DevEd
;
; Copyright (c) 2020 DevEd
; 
; Permission is hereby granted, free of charge, to any person obtaining
; a copy of this software and associated documentation files (the
; "Software"), to deal in the Software without restriction, including
; without limitation the rights to use, copy, modify, merge, publish,
; distribute, sublicense, and/or sell copies of the Software, and to
; permit persons to whom the Software is furnished to do so, subject to
; the following conditions:
; 
; The above copyright notice and this permission notice shall be included
; in all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; ================================================================

; ================================================================
; DevSound defines
; ================================================================

if !def(incDSDefines)
incDSDefines    set 1

; ================================================================

; Note values

C_2     equ $00
C#2     equ $01
D_2     equ $02
D#2     equ $03
E_2     equ $04
F_2     equ $05
F#2     equ $06
G_2     equ $07
G#2     equ $08
A_2     equ $09
A#2     equ $0a
B_2     equ $0b
C_3     equ $0c
C#3     equ $0d
D_3     equ $0e
D#3     equ $0f
E_3     equ $10
F_3     equ $11
F#3     equ $12
G_3     equ $13
G#3     equ $14
A_3     equ $15
A#3     equ $16
B_3     equ $17
C_4     equ $18
C#4     equ $19
D_4     equ $1a
D#4     equ $1b
E_4     equ $1c
F_4     equ $1d
F#4     equ $1e
G_4     equ $1f
G#4     equ $20
A_4     equ $21
A#4     equ $22
B_4     equ $23
C_5     equ $24
C#5     equ $25
D_5     equ $26
D#5     equ $27
E_5     equ $28
F_5     equ $29
F#5     equ $2a
G_5     equ $2b
G#5     equ $2c
A_5     equ $2d
A#5     equ $2e
B_5     equ $2f
C_6     equ $30
C#6     equ $31
D_6     equ $32
D#6     equ $33
E_6     equ $34
F_6     equ $35
F#6     equ $36
G_6     equ $37
G#6     equ $38
A_6     equ $39
A#6     equ $3a
B_6     equ $3b
C_7     equ $3c
C#7     equ $3d
D_7     equ $3e
D#7     equ $3f
E_7     equ $40
F_7     equ $41
F#7     equ $42
G_7     equ $43
G#7     equ $44
A_7     equ $45
A#7     equ $46
B_7     equ $47
rest    equ $48

fix     equ C_2

; Command definitions

SetInstrument       equ $80
CallSection         equ $81
Goto                equ $82
PitchBendUp         equ $83
PitchBendDown       equ $84
SetSweep            equ $85
SetPan              equ $86
SetSpeed            equ $87
SetInsAlternate     equ $88
EnablePWM           equ $89
Arp                 equ $8a
LoopCount           equ $8b
Loop                equ $8c
DummyCommand        equ $8d
EndChannel          equ $ff

; ================================================================

Instrument:     macro
    db      \1
if "\2" == "_"
    dw      DummyTable
else
    dw      vol_\2
endc
if "\3" == "_"
    dw      DummyTable
else
    dw      arp_\3
endc
if "\4" == "_"
    dw      DummyTable
else
    dw      waveseq_\4
endc
if "\5" == "_"
    dw      vib_Dummy
else
    dw      vib_\5
endc
    endm

Drum:           macro
    db      SetInstrument,_\1,fix,\2
    endm

dins:           macro
    const   _\1
    dw  ins_\1
endm

; ================================================================

SECTION "DevSound varialbes",WRAM0

DS_RAMStart:

DS_GlobalVolume::       db
DS_GlobalSpeed1::       db
DS_GlobalSpeed2::       db
DS_GlobalTimer::        db
DS_TickCount::          db
DS_SoundEnabled::       db
DS_FadeType::           db
DS_FadeTimer::          db

DS_CH1Enabled::         db
DS_CH2Enabled::         db
DS_CH3Enabled::         db
DS_CH4Enabled::         db

DS_CH1Ptr::             dw
DS_CH1VolPtr::          dw
DS_CH1PulsePtr::        dw
DS_CH1ArpPtr::          dw
DS_CH1VibPtr::          dw
DS_CH1RetPtr::          dw
DS_CH1VolPos::          db
DS_CH1PulsePos::        db
DS_CH1ArpPos::          db
DS_CH1VibPos::          db
DS_CH1VibDelay::        db
DS_CH1Tick::            db
DS_CH1Reset::           db
DS_CH1Note::            db
DS_CH1Transpose::       db
DS_CH1FreqOffset::      db
DS_CH1Pan::             db
DS_CH1Sweep::           db
DS_CH1NoteCount::       db
DS_CH1InsMode::         db
DS_CH1Ins1::            db
DS_CH1Ins2::            db
DS_CH1LoopCount::       db

DS_CH2Ptr::             dw
DS_CH2VolPtr::          dw
DS_CH2PulsePtr::        dw
DS_CH2ArpPtr::          dw
DS_CH2VibPtr::          dw
DS_CH2RetPtr::          dw
DS_CH2VolPos::          db
DS_CH2PulsePos::        db
DS_CH2ArpPos::          db
DS_CH2VibPos::          db
DS_CH2VibDelay::        db
DS_CH2Tick::            db
DS_CH2Reset::           db
DS_CH2Note::            db
DS_CH2Transpose::       db
DS_CH2FreqOffset::      db
DS_CH2Pan::             db
DS_CH2NoteCount::       db
DS_CH2InsMode::         db
DS_CH2Ins1::            db
DS_CH2Ins2::            db
DS_CH2LoopCount::       db

DS_CH3Ptr::             dw
DS_CH3VolPtr::          dw
DS_CH3WavePtr::         dw
DS_CH3ArpPtr::          dw
DS_CH3VibPtr::          dw
DS_CH3RetPtr::          dw
DS_CH3VolPos::          db
DS_CH3WavePos::         db
DS_CH3ArpPos::          db
DS_CH3VibPos::          db
DS_CH3VibDelay::        db
DS_CH3Tick::            db
DS_CH3Reset::           db
DS_CH3Note::            db
DS_CH3Transpose::       db
DS_CH3FreqOffset::      db
DS_CH3Vol::             db
DS_CH3Wave::            db
DS_CH3Pan::             db
DS_CH3NoteCount::       db
DS_CH3InsMode::         db
DS_CH3Ins1::            db
DS_CH3Ins2::            db
DS_CH3LoopCount::       db

DS_CH4Ptr::             dw
DS_CH4VolPtr::          dw
DS_CH4NoisePtr::        dw
DS_CH4RetPtr::          dw
DS_CH4VolPos::          db
DS_CH4NoisePos::        db
DS_CH4Mode::            db
DS_CH4Tick::            db
DS_CH4Reset::           db
DS_CH4Transpose::       db
DS_CH4Pan::             db
DS_CH4NoteCount::       db
DS_CH4InsMode::         db
DS_CH4Ins1::            db
DS_CH4Ins2::            db
DS_CH4LoopCount::       db

DS_WaveBuffer::         ds  16
DS_WavePos::            db
DS_WaveUpdateFlag::     db
DS_PWMEnabled::         db
DS_PWMVol::             db
DS_PWMSpeed::           db
DS_PWMTimer::           db
DS_PWMDir::             db

DSVarsEnd:

arp_Buffer::            ds  8

DS_RAMEnd:

endc

; =====================

section "DevSound Lite",romx[$4000]

DevSound:

DevSound_JumpTable:

DS_Init:    jp  DevSound_Init
DS_Play:    jp  DevSound_Play
DS_Stop:    jp  DevSound_Stop
DS_Fade:    jp  DevSound_Fade

; Driver thumbprint
db  "DevSound Lite by DevEd | email: deved8@gmail.com"

; ================================================================
; Init routine
; INPUT: a = ID of song to init
; ================================================================

DevSound_Init:
    ld      c,a     ; Preserve song ID
    
    xor     a
    ldh     [rNR52],a   ; disable sound
    ld      [DS_PWMEnabled],a
    ld      [DS_WaveUpdateFlag],a

    ; init sound RAM area
    ld      hl,DS_RAMStart
    ld      b,DS_RAMEnd-DS_RAMStart
    xor     a
.initLoop
    ld      [hl+],a
    dec     b
    jr      nz,.initLoop
    
    ; initialize variables
    ld      a,$77
    ld      [DS_GlobalVolume],a
    ld      a,1
    ld      [DS_SoundEnabled],a
    ld      [DS_CH1Enabled],a
    ld      [DS_CH2Enabled],a
    ld      [DS_CH3Enabled],a
    ld      [DS_CH4Enabled],a
    
    ld      a,-1
    ld      [DS_CH3Wave],a
    
    ld      a,low(DummyTable)
    ld      [DS_CH1VolPtr],a
    ld      [DS_CH1PulsePtr],a
    ld      [DS_CH1ArpPtr],a
    ld      [DS_CH1RetPtr],a
    ld      [DS_CH2VolPtr],a
    ld      [DS_CH2PulsePtr],a
    ld      [DS_CH2ArpPtr],a
    ld      [DS_CH2RetPtr],a
    ld      [DS_CH3VolPtr],a
    ld      [DS_CH3WavePtr],a
    ld      [DS_CH3ArpPtr],a
    ld      [DS_CH3RetPtr],a
    ld      [DS_CH4VolPtr],a
    ld      [DS_CH4NoisePtr],a
    ld      [DS_CH4RetPtr],a
    ld      a,high(DummyTable)
    ld      [DS_CH1VolPtr+1],a
    ld      [DS_CH1PulsePtr+1],a
    ld      [DS_CH1ArpPtr+1],a
    ld      [DS_CH1RetPtr+1],a
    ld      [DS_CH2VolPtr+1],a
    ld      [DS_CH2PulsePtr+1],a
    ld      [DS_CH2ArpPtr+1],a
    ld      [DS_CH2RetPtr+1],a
    ld      [DS_CH3VolPtr+1],a
    ld      [DS_CH3WavePtr+1],a
    ld      [DS_CH3ArpPtr+1],a
    ld      [DS_CH3RetPtr+1],a
    ld      [DS_CH4VolPtr+1],a
    ld      [DS_CH4NoisePtr+1],a
    ld      [DS_CH4RetPtr+1],a
    ld      a,low(vib_Dummy)
    ld      [DS_CH1VibPtr],a
    ld      [DS_CH2VibPtr],a
    ld      [DS_CH3VibPtr],a
    ld      a,high(vib_Dummy)
    ld      [DS_CH1VibPtr+1],a
    ld      [DS_CH2VibPtr+1],a
    ld      [DS_CH3VibPtr+1],a
    
    ld      d,c     ; Transfer song ID

    ; load default waveform
    ld      hl,DefaultWave
    call    LoadWave
    call    ClearWaveBuffer
    call    ClearArpBuffer
    
    ; set up song pointers
    ld      hl,SongPointerTable
    ld      a,d
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry        ; HERE BE HACKS
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl+]
    ld      [DS_CH1Ptr],a
    ld      a,[hl+]
    ld      [DS_CH1Ptr+1],a    
    ld      a,[hl+]
    ld      [DS_CH2Ptr],a
    ld      a,[hl+]
    ld      [DS_CH2Ptr+1],a
    ld      a,[hl+]
    ld      [DS_CH3Ptr],a
    ld      a,[hl+]
    ld      [DS_CH3Ptr+1],a
    ld      a,[hl+]
    ld      [DS_CH4Ptr],a
    ld      a,[hl+]
    ld      [DS_CH4Ptr+1],a
    ld      hl,DummyChannel
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl+]
    ld      [DS_CH1RetPtr],a
    ld      [DS_CH2RetPtr],a
    ld      [DS_CH3RetPtr],a
    ld      [DS_CH4RetPtr],a
    ld      a,[hl]
    ld      [DS_CH1RetPtr+1],a
    ld      [DS_CH2RetPtr+1],a
    ld      [DS_CH3RetPtr+1],a
    ld      [DS_CH4RetPtr+1],a
    ld      a,$11
    ld      [DS_CH1Pan],a
    ld      [DS_CH2Pan],a
    ld      [DS_CH3Pan],a
    ld      [DS_CH4Pan],a
    ; get tempo
    ld      hl,SongSpeedTable
    ld      a,d     ; Retrieve song ID one last time
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed1],a
    ld      a,[hl]
    dec     a
    ld      [DS_GlobalSpeed2],a
    ld      a,%10000000
    ldh     [rNR52],a
    or      %01111111   ; a = $FF
    ldh     [rNR51],a
    xor     %10001000   ; a = $77
    ldh     [rNR50],a
    ret

; ================================================================
; Stop routine
; ================================================================

DevSound_Stop:
    xor     a
    ldh     [rNR52],a
    ld      [DS_CH1Enabled],a
    ld      [DS_CH2Enabled],a
    ld      [DS_CH3Enabled],a
    ld      [DS_CH4Enabled],a
    ld      [DS_SoundEnabled],a
    ret

; ================================================================
; Fade routine
; Note: if planning to call both this and DS_Init, call this first.
; ================================================================

DevSound_Fade:
    and     3
    cp      3
    ret     z   ; 3 is an invalid value, silently ignore it
    inc     a   ; Increment...
    set     2,a ; Mark this fade as the first
    ld      [DS_FadeType],a
    ld      a,7
    ld      [DS_FadeTimer],a
    ret
    
; ================================================================
; Play routine
; ================================================================

DevSound_Play:
    ; Since this routine is called during an interrupt (which may
    ; happen in the middle of a routine), preserve all register
    ; values just to be safe.
    ; Other registers are saved at `.doUpdate`.
    push    af
    ld      a,[DS_SoundEnabled]
    and     a
    jr      nz,.doUpdate        ; if sound is enabled, jump ahead
    pop     af
    ret
    
.doUpdate
    push    bc
    push    de
    push    hl
    ; get song timer
    ld      a,[DS_GlobalTimer]  ; get global timer
    and     a                   ; is DS_GlobalTimer non-zero?
    jr      nz,.noupdate        ; if yes, don't update
    ld      a,[DS_TickCount]    ; get current tick count
    inc     a                   ; add 1
    ld      [DS_TickCount],a    ; store it in RAM
    rra                         ; check if A is odd
    jr      c,.odd              ; if a is odd, jump
.even
    ld      a,[DS_GlobalSpeed1]
    jr      .setTimer
.odd
    ld      a,[DS_GlobalSpeed2]
.setTimer
    ld      [DS_GlobalTimer],a  ; store timer value
    jr      DS_UpdateCH1        ; continue ahead
    
.noupdate
    dec     a                   ; subtract 1 from timer
    ld      [DS_GlobalTimer],a  ; store timer value
    jp      DoneUpdating        ; done

; ================================================================
    
DS_UpdateCH1:
    ld      a,[DS_CH1Enabled]
    and     a
    jp      z,DS_UpdateCH2
    ld      a,[DS_CH1Tick]
    and     a
    jr      z,.continue
    dec     a
    ld      [DS_CH1Tick],a
    jp      DS_UpdateCH2       ; too far for jr
.continue
    ld      hl,DS_CH1Ptr       ; get pointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
DS_CH1_CheckByte:
    ld      a,[hl+]         ; get byte
    cp      $ff             ; if $ff...
    jr      z,.endChannel
    cp      $c9             ; if $c9...
    jr      z,.retSection
    bit     7,a             ; if command...
    jr      nz,.getCommand
    ; if we have a note...
.getNote
    ld      [DS_CH1Note],a     ; set note
    ld      a,[hl+]
    push    hl
    dec     a
    ld      [DS_CH1Tick],a     ; set tick
    xor     a
    ld      [DS_CH1VolPos],a
    ld      [DS_CH1ArpPos],a
    inc     a
    ld      [DS_CH1VibPos],a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH1,a
    jr      nz,.noupdate
    ldh     [rNR12],a
.noupdate
    ld      hl,DS_CH1VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl]
    ld      [DS_CH1VibDelay],a
    ld      a,[DS_CH1Reset]
    and     a
    jp      nz,.noreset
    xor     a
    ld      [DS_CH1PulsePos],a
.noreset
    ld      a,[DS_CH1NoteCount]
    inc     a
    ld      [DS_CH1NoteCount],a
    ld      b,a
    ; check if instrument mode is 1 (alternating)
    ld      a,[DS_CH1InsMode]
    and     a
    jr      z,.noInstrumentChange
    ld      a,b
    rra
    jr      nc,.notodd
    ld      a,[DS_CH1Ins1]
    jr      .odd
.notodd
    ld      a,[DS_CH1Ins2]
.odd
    call    DS_CH1_SetInstrument
.noInstrumentChange 
    jp      DS_CH1_DoneUpdating
.getCommand
    push    hl
    sub     $80             ; subtract 128 from command value
    cp      DummyCommand-$80
    jr      c,.nodummy
    pop     hl
    jp      DS_CH1_CheckByte
.nodummy
    add     a               ; multiply by 2
    add     a,DS_CH1_CommandTable%256
    ld      l,a
    adc     a,DS_CH1_CommandTable/256
    sub     l
    ld      h,a
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jp      hl
    
.endChannel
    xor     a
    ld      [DS_CH1Enabled],a
    jp      DS_UpdateCH2

.retSection
    ld      a,[DS_CH1RetPtr]
    ld      [DS_CH1Ptr],a
    ld      a,[DS_CH1RetPtr+1]
    ld      [DS_CH1Ptr+1],a
    jp      DS_UpdateCH1
    
DS_CH1_DoneUpdating:
    pop     hl
    ld      a,l
    ld      [DS_CH1Ptr],a
    ld      a,h
    ld      [DS_CH1Ptr+1],a
    jp      DS_UpdateCH2   ; too far for jr
        
DS_CH1_CommandTable:
    dw      .setInstrument
    dw      .callSection
    dw      .goto
    dw      .pitchBendUp
    dw      .pitchBendDown
    dw      .setSweep
    dw      .setPan
    dw      .setSpeed
    dw      .setInsAlternate
    dw      .enablePWM
    dw      .arp
    dw      .setLoopCount
    dw      .loop

.setInstrument
    pop     hl
    ld      a,[hl+]
    push    hl
    call    DS_CH1_SetInstrument
    xor     a
    ld      [DS_CH1InsMode],a
    pop     hl
    jp      DS_CH1_CheckByte   ; too far for jr
    
.callSection
    pop     hl
    push    hl
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      [DS_CH1Ptr],a
    ld      a,h
    ld      [DS_CH1Ptr+1],a
    pop     hl
    inc     hl
    inc     hl
    ld      a,l
    ld      [DS_CH1RetPtr],a
    ld      a,h
    ld      [DS_CH1RetPtr+1],a
    jp      DS_UpdateCH1   ; too far for jr
    
.goto
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH1Ptr],a
    ld      a,[hl]
    ld      [DS_CH1Ptr+1],a
    jp      DS_UpdateCH1

.pitchBendUp    ; TODO
    pop     hl
    inc     hl
    jp      DS_CH1_CheckByte   ; too far for jr
    
.pitchBendDown  ; TODO
    pop     hl
    inc     hl
    jp      DS_CH1_CheckByte   ; too far for jr

.setSweep       ; TODO
    pop     hl
    inc     hl
    jp      DS_CH1_CheckByte   ; too far for jr

.setPan
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH1Pan],a
    jp      DS_CH1_CheckByte   ; too far for jr

.setSpeed
    pop     hl
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed1],a
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed2],a
    jp      DS_CH1_CheckByte   ; too far for jr
    
.setInsAlternate
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH1Ins1],a
    ld      a,[hl+]
    ld      [DS_CH1Ins2],a
    ld      a,1
    ld      [DS_CH1InsMode],a
    jp      DS_CH1_CheckByte

.enablePWM
    pop     hl
    inc     hl
    inc     hl
    jp      DS_CH1_CheckByte
    
.arp
    pop     hl
    call    DoArp
    jp      DS_CH1_CheckByte

.setLoopCount
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH1LoopCount],a
    jp      DS_CH1_CheckByte

.loop
    pop     hl
    inc     hl
    inc     hl
    ld      a,[DS_CH1LoopCount]
    dec     a
    ld      [DS_CH1LoopCount],a
    and     a
    jp      z,DS_CH1_CheckByte
    dec     hl
    dec     hl
    ld      a,[hl+]
    ld      [DS_CH1Ptr],a
    ld      a,[hl]
    ld      [DS_CH1Ptr+1],a
    jp      DS_UpdateCH1

DS_CH1_SetInstrument:
    ld      hl,InstrumentTable
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ; no reset flag
    ld      a,[hl+]
    ld      [DS_CH1Reset],a
    ld      b,a
    ; vol table
    ld      a,[hl+]
    ld      [DS_CH1VolPtr],a
    ld      a,[hl+]
    ld      [DS_CH1VolPtr+1],a
    ; arp table
    ld      a,[hl+]
    ld      [DS_CH1ArpPtr],a
    ld      a,[hl+]
    ld      [DS_CH1ArpPtr+1],a
    ; pulse table
    ld      a,[hl+]
    ld      [DS_CH1PulsePtr],a
    ld      a,[hl+]
    ld      [DS_CH1PulsePtr+1],a
    ; vib table
    ld      a,[hl+]
    ld      [DS_CH1VibPtr],a
    ld      a,[hl+]
    ld      [DS_CH1VibPtr+1],a
    ld      hl,DS_CH1VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl]
    ld      [DS_CH1VibDelay],a
    ret
    
; ================================================================
    
DS_UpdateCH2:
    ld      a,[DS_CH2Enabled]
    and     a
    jp      z,DS_UpdateCH3
    ld      a,[DS_CH2Tick]
    and     a
    jr      z,.continue
    dec     a
    ld      [DS_CH2Tick],a
    jp      DS_UpdateCH3       ; too far for jr
.continue
    ld      hl,DS_CH2Ptr       ; get pointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
DS_CH2_CheckByte:
    ld      a,[hl+]         ; get byte
    cp      $ff             ; if $ff...
    jr      z,.endChannel
    cp      $c9             ; if $c9...
    jr      z,.retSection
    bit     7,a             ; if command...
    jr      nz,.getCommand
    ; if we have a note...
.getNote
    ld      [DS_CH2Note],a     ; set note
    ld      a,[hl+]
    push    hl
    dec     a
    ld      [DS_CH2Tick],a     ; set tick
    xor     a
    ld      [DS_CH2VolPos],a
    ld      [DS_CH2ArpPos],a
    inc     a
    ld      [DS_CH2VibPos],a    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH2,a
    jr      nz,.noupdate
    ldh     [rNR22],a
.noupdate
    ld      hl,DS_CH2VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl]
    ld      [DS_CH2VibDelay],a
    ld      a,[DS_CH2Reset]
    and     a
    jp      nz,.noreset
    xor     a
    ld      [DS_CH2PulsePos],a
.noreset
    ld      a,[DS_CH2NoteCount]
    inc     a
    ld      [DS_CH2NoteCount],a
    ld      b,a
    ; check if instrument mode is 1 (alternating)
    ld      a,[DS_CH2InsMode]
    and     a
    jr      z,.noInstrumentChange
    ld      a,b
    rra
    jr      nc,.notodd
    ld      a,[DS_CH2Ins1]
    jr      .odd
.notodd
    ld      a,[DS_CH2Ins2]
.odd
    call    DS_CH2_SetInstrument
.noInstrumentChange 
    jp      DS_CH2_DoneUpdating
.getCommand
    push    hl
    sub     $80             ; subtract 128 from command value
    cp      DummyCommand-$80
    jr      c,.nodummy
    pop     hl
    jp      DS_CH2_CheckByte
.nodummy
    add     a               ; multiply by 2
    add     a,DS_CH2_CommandTable%256
    ld      l,a
    adc     a,DS_CH2_CommandTable/256
    sub     l
    ld      h,a
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jp      hl
    
.endChannel
    xor     a
    ld      [DS_CH2Enabled],a
    jp      DS_UpdateCH3

.retSection
    ld      a,[DS_CH2RetPtr]
    ld      [DS_CH2Ptr],a
    ld      a,[DS_CH2RetPtr+1]
    ld      [DS_CH2Ptr+1],a
    jp      DS_UpdateCH2
    
DS_CH2_DoneUpdating:
    pop     hl
    ld      a,l
    ld      [DS_CH2Ptr],a
    ld      a,h
    ld      [DS_CH2Ptr+1],a
    jp      DS_UpdateCH3   ; too far for jr
        
DS_CH2_CommandTable:
    dw      .setInstrument
    dw      .callSection
    dw      .goto
    dw      .pitchBendUp
    dw      .pitchBendDown
    dw      .setSweep
    dw      .setPan
    dw      .setSpeed
    dw      .setInsAlternate
    dw      .enablePWM
    dw      .arp
    dw      .setLoopCount
    dw      .loop

.setInstrument
    pop     hl
    ld      a,[hl+]
    push    hl
    call    DS_CH2_SetInstrument
    xor     a
    ld      [DS_CH2InsMode],a
    pop     hl
    jp      DS_CH2_CheckByte   ; too far for jr
    
.callSection
    pop     hl
    push    hl
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      [DS_CH2Ptr],a
    ld      a,h
    ld      [DS_CH2Ptr+1],a
    pop     hl
    inc     hl
    inc     hl
    ld      a,l
    ld      [DS_CH2RetPtr],a
    ld      a,h
    ld      [DS_CH2RetPtr+1],a
    jp      DS_UpdateCH2   ; too far for jr
    
.goto
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH2Ptr],a
    ld      a,[hl]
    ld      [DS_CH2Ptr+1],a
    jp      DS_UpdateCH2

.pitchBendUp    ; TODO
    pop     hl
    inc     hl
    jp      DS_CH2_CheckByte   ; too far for jr
    
.pitchBendDown  ; TODO
    pop     hl
    inc     hl
    jp      DS_CH2_CheckByte   ; too far for jr

.setSweep       ; TODO
    pop     hl
    inc     hl
    jp      DS_CH2_CheckByte   ; too far for jr

.setPan
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH2Pan],a
    jp      DS_CH2_CheckByte   ; too far for jr

.setSpeed
    pop     hl
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed1],a
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed2],a
    jp      DS_CH2_CheckByte   ; too far for jr
    
.setInsAlternate
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH2Ins1],a
    ld      a,[hl+]
    ld      [DS_CH2Ins2],a
    ld      a,1
    ld      [DS_CH2InsMode],a
    jp      DS_CH2_CheckByte

.enablePWM
    pop     hl
    inc     hl
    inc     hl
    jp      DS_CH2_CheckByte
    
.arp
    pop     hl
    call    DoArp
    jp      DS_CH2_CheckByte

.setLoopCount
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH2LoopCount],a
    jp      DS_CH2_CheckByte

.loop
    pop     hl
    inc     hl
    inc     hl
    ld      a,[DS_CH2LoopCount]
    dec     a
    ld      [DS_CH2LoopCount],a
    and     a
    jp      z,DS_CH2_CheckByte
    dec     hl
    dec     hl
    ld      a,[hl+]
    ld      [DS_CH2Ptr],a
    ld      a,[hl]
    ld      [DS_CH2Ptr+1],a
    jp      DS_UpdateCH2
    
DS_CH2_SetInstrument:
    ld      hl,InstrumentTable
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ; no reset flag
    ld      a,[hl+]
    ld      [DS_CH2Reset],a
    ld      b,a
    ; vol table
    ld      a,[hl+]
    ld      [DS_CH2VolPtr],a
    ld      a,[hl+]
    ld      [DS_CH2VolPtr+1],a
    ; arp table
    ld      a,[hl+]
    ld      [DS_CH2ArpPtr],a
    ld      a,[hl+]
    ld      [DS_CH2ArpPtr+1],a
    ; pulse table
    ld      a,[hl+]
    ld      [DS_CH2PulsePtr],a
    ld      a,[hl+]
    ld      [DS_CH2PulsePtr+1],a
    ; vib table
    ld      a,[hl+]
    ld      [DS_CH2VibPtr],a
    ld      a,[hl+]
    ld      [DS_CH2VibPtr+1],a
    ld      hl,DS_CH2VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl]
    ld      [DS_CH2VibDelay],a
    ret
    
; ================================================================
    
DS_UpdateCH3:
    ld      a,[DS_CH3Enabled]
    and     a
    jp      z,DS_UpdateCH4
    ld      a,[DS_CH3Tick]
    and     a
    jr      z,.continue
    dec     a
    ld      [DS_CH3Tick],a
    jp      DS_UpdateCH4   ; too far for jr
.continue
    ld      hl,DS_CH3Ptr   ; get pointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
DS_CH3_CheckByte:
    ld      a,[hl+]     ; get byte
    cp      $ff
    jr      z,.endChannel
    cp      $c9
    jr      z,.retSection
    bit     7,a         ; check for command
    jr      nz,.getCommand
    ; if we have a note...
.getNote
    ld      [DS_CH3Note],a
    ld      a,[hl+]
    push    hl
    dec     a
    ld      [DS_CH3Tick],a
    xor     a
    ld      [DS_CH3VolPos],a
    ld      [DS_CH3ArpPos],a
    inc     a
    ld      [DS_CH3VibPos],a
    ld      hl,DS_CH3VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl]
    ld      [DS_CH3VibDelay],a
    ld      a,[DS_CH3Reset]
    and     a
    jp      nz,DS_CH3_DoneUpdating
    xor     a
    ld      [DS_CH3WavePos],a
    ld      a,[DS_CH3NoteCount]
    inc     a
    ld      [DS_CH3NoteCount],a
    ld      b,a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.noupdate
    ld      a,[DS_CH3Vol]
    ldh     [rNR32],a
.noupdate
    
    ; check if instrument mode is 1 (alternating)
    ld      a,[DS_CH3InsMode]
    and     a
    jr      z,.noInstrumentChange
    ld      a,b
    rra
    jr      nc,.notodd
    ld      a,[DS_CH3Ins1]
    jr      .odd
.notodd
    ld      a,[DS_CH3Ins2]
.odd
    call    DS_CH3_SetInstrument
.noInstrumentChange
    jp      DS_CH3_DoneUpdating
.getCommand
    push    hl
    sub     $80
    cp      DummyCommand-$80
    jr      c,.nodummy
    pop     hl
    jp      DS_CH3_CheckByte
.nodummy
    add     a
    add     a,DS_CH3_CommandTable%256
    ld      l,a
    adc     a,DS_CH3_CommandTable/256
    sub     l
    ld      h,a
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jp      hl
    
.endChannel
    xor     a
    ld      [DS_CH3Enabled],a
    jp      DS_UpdateCH4
    
.retSection
    ld      a,[DS_CH3RetPtr]
    ld      [DS_CH3Ptr],a
    ld      a,[DS_CH3RetPtr+1]
    ld      [DS_CH3Ptr+1],a
    jp      DS_UpdateCH3
    
DS_CH3_DoneUpdating:
    pop     hl
    ld      a,l
    ld      [DS_CH3Ptr],a
    ld      a,h
    ld      [DS_CH3Ptr+1],a
    jp      DS_UpdateCH4   ; too far for jr
        
DS_CH3_CommandTable:
    dw      .setInstrument
    dw      .callSection
    dw      .goto
    dw      .pitchBendUp
    dw      .pitchBendDown
    dw      .setSweep
    dw      .setPan
    dw      .setSpeed
    dw      .setInsAlternate
    dw      .enablePWM
    dw      .arp
    dw      .setLoopCount
    dw      .loop

.setInstrument
    pop     hl
    ld      a,[hl+]
    push    hl
    call    DS_CH3_SetInstrument
    pop     hl
    xor     a
    ld      [DS_CH3InsMode],a
    jp      DS_CH3_CheckByte   ; too far for jr
    
.callSection
    pop     hl
    push    hl
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      [DS_CH3Ptr],a
    ld      a,h
    ld      [DS_CH3Ptr+1],a
    pop     hl
    inc     hl
    inc     hl
    ld      a,l
    ld      [DS_CH3RetPtr],a
    ld      a,h
    ld      [DS_CH3RetPtr+1],a
    jp      DS_UpdateCH3   ; too far for jr
    
.goto
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH3Ptr],a
    ld      a,[hl]
    ld      [DS_CH3Ptr+1],a
    jp      DS_UpdateCH3

.pitchBendUp    ; TODO
    pop     hl
    inc     hl
    jp      DS_CH3_CheckByte   ; too far for jr
    
.pitchBendDown  ; TODO
    pop     hl
    inc     hl
    jp      DS_CH3_CheckByte   ; too far for jr

.setSweep
    pop     hl
    inc     hl
    jp      DS_CH3_CheckByte   ; too far for jr

.setPan
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH3Pan],a
    jp      DS_CH3_CheckByte   ; too far for jr

.setSpeed
    pop     hl
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed1],a
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed2],a
    jp      DS_CH3_CheckByte   ; too far for jr
    
.setInsAlternate
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH3Ins1],a
    ld      a,[hl+]
    ld      [DS_CH3Ins2],a
    ld      a,1
    ld      [DS_CH3InsMode],a
    jp      DS_CH3_CheckByte
.enablePWM
    call    ClearWaveBuffer
    pop     hl
    ld      a,[hl+]
    ld      [DS_PWMVol],a
    ld      a,[hl+]
    ld      [DS_PWMSpeed],a
    ld      a,$ff
    ld      [DS_WavePos],a
    xor     a
    ld      [DS_PWMDir],a
    inc     a
    ld      [DS_PWMEnabled],a
    ld      [DS_PWMTimer],a
    jp      DS_CH3_CheckByte
    
.arp
    pop     hl
    call    DoArp
    ld      a,c
    add     2
    ld      c,a
    jp      DS_CH3_CheckByte

.setLoopCount
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH3LoopCount],a
    jp      DS_CH3_CheckByte

.loop
    pop     hl
    inc     hl
    inc     hl
    ld      a,[DS_CH3LoopCount]
    dec     a
    ld      [DS_CH3LoopCount],a
    and     a
    jp      z,DS_CH3_CheckByte
    dec     hl
    dec     hl
    ld      a,[hl+]
    ld      [DS_CH3Ptr],a
    ld      a,[hl]
    ld      [DS_CH3Ptr+1],a
    jp      DS_UpdateCH3
    
DS_CH3_SetInstrument:
    ld      hl,InstrumentTable
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ; no reset flag
    ld      a,[hl+]
    ld      [DS_CH3Reset],a
    ld      b,a
    ; vol table
    ld      a,[hl+]
    ld      [DS_CH3VolPtr],a
    ld      a,[hl+]
    ld      [DS_CH3VolPtr+1],a
    ; arp table
    ld      a,[hl+]
    ld      [DS_CH3ArpPtr],a
    ld      a,[hl+]
    ld      [DS_CH3ArpPtr+1],a
    ; wave table
    ld      a,[hl+]
    ld      [DS_CH3WavePtr],a
    ld      a,[hl+]
    ld      [DS_CH3WavePtr+1],a
    ; vib table
    ld      a,[hl+]
    ld      [DS_CH3VibPtr],a
    ld      a,[hl+]
    ld      [DS_CH3VibPtr+1],a
    ld      hl,DS_CH3VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[hl]
    ld      [DS_CH3VibDelay],a
    ret

; ================================================================

DS_UpdateCH4:
    ld      a,[DS_CH4Enabled]
    and     a
    jp      z,DoneUpdating
    ld      a,[DS_CH4Tick]
    and     a
    jr      z,.continue
    dec     a
    ld      [DS_CH4Tick],a
    jp      DoneUpdating    ; too far for jr
.continue
    ld      hl,DS_CH4Ptr   ; get pointer
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
DS_CH4_CheckByte:
    ld      a,[hl+]     ; get byte
    inc     c           ; add 1 to offset
    cp      $ff
    jr      z,.endChannel
    cp      $c9
    jr      z,.retSection
    bit     7,a         ; check for command
    jr      nz,.getCommand  
    ; if we have a note...
.getNote
    ld      [DS_CH4Mode],a
    ld      a,[hl+]
    push    hl
    dec     a
    ld      [DS_CH4Tick],a
    ld      a,[DS_CH4Reset]
    jp      z,DS_CH4_DoneUpdating
    xor     a
    ld      [DS_CH4VolPos],a
    ld      [DS_CH4NoisePos],a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH4,a
    jr      nz,.noupdate
    ldh     [rNR42],a
.noupdate
    ld      a,[DS_CH4NoteCount]
    inc     a
    ld      [DS_CH4NoteCount],a
    ld      b,a
    ; check if instrument mode is 1 (alternating)
    ld      a,[DS_CH4InsMode]
    and     a
    jr      z,.noInstrumentChange
    ld      a,b
    rra
    jr      nc,.notodd
    ld      a,[DS_CH4Ins1]
    jr      .odd
.notodd
    ld      a,[DS_CH4Ins2]
.odd
    call    DS_CH4_SetInstrument
.noInstrumentChange
    jp      DS_CH4_DoneUpdating
.getCommand
    push    hl
    sub     $80
    cp      DummyCommand-$80
    jr      c,.nodummy
    pop     hl
    jp      DS_CH4_CheckByte
.nodummy
    add     a
    add     a,DS_CH4_CommandTable%256
    ld      l,a
    adc     a,DS_CH4_CommandTable/256
    sub     l
    ld      h,a
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    jp      hl

.endChannel
    xor     a
    ld      [DS_CH4Enabled],a
    jp      DoneUpdating
    
.retSection
    ld      a,[DS_CH4RetPtr]
    ld      [DS_CH4Ptr],a
    ld      a,[DS_CH4RetPtr+1]
    ld      [DS_CH4Ptr+1],a
    jp      DS_UpdateCH4
    
DS_CH4_DoneUpdating:
    pop     hl
    ld      a,l
    ld      [DS_CH4Ptr],a
    ld      a,h
    ld      [DS_CH4Ptr+1],a
    jp      DoneUpdating
        
DS_CH4_CommandTable:
    dw      .setInstrument
    dw      .callSection
    dw      .goto
    dw      .pitchBendUp
    dw      .pitchBendDown
    dw      .setSweep
    dw      .setPan
    dw      .setSpeed
    dw      .setInsAlternate
    dw      .enablePWM
    dw      .arp
    dw      .setLoopCount
    dw      .loop

.setInstrument
    pop     hl
    ld      a,[hl+]
    push    hl
    call    DS_CH4_SetInstrument
    pop     hl
    xor     a
    ld      [DS_CH4InsMode],a
    jp      DS_CH4_CheckByte   ; too far for jr
    
.callSection
    pop     hl
    push    hl
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      [DS_CH4Ptr],a
    ld      a,h
    ld      [DS_CH4Ptr+1],a
    pop     hl
    inc     hl
    inc     hl
    ld      a,l
    ld      [DS_CH4RetPtr],a
    ld      a,h
    ld      [DS_CH4RetPtr+1],a
    jp      DS_UpdateCH4   ; too far for jr
    
.goto
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH4Ptr],a
    ld      a,[hl]
    ld      [DS_CH4Ptr+1],a
    jp      DS_UpdateCH4

.pitchBendUp    ; unused for ch4
    pop     hl
    inc     hl
    jp      DS_CH4_CheckByte   ; too far for jr
    
.pitchBendDown  ; unused for ch4
    pop     hl
    inc     hl
    jp      DS_CH4_CheckByte   ; too far for jr

.setSweep       ; unused for ch4
    pop     hl
    inc     hl
    jp      DS_CH4_CheckByte   ; too far for jr

.setPan
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH4Pan],a
    jp      DS_CH4_CheckByte   ; too far for jr

.setSpeed
    pop     hl
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed1],a
    ld      a,[hl+]
    dec     a
    ld      [DS_GlobalSpeed2],a
    jp      DS_CH4_CheckByte   ; too far for jr
    
.setInsAlternate
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH4Ins1],a
    ld      a,[hl+]
    ld      [DS_CH4Ins2],a
    ld      a,1
    ld      [DS_CH4InsMode],a
    jp      DS_CH4_CheckByte

.enablePWM
    pop     hl
    inc     hl
    inc     hl
    jp      DS_CH4_CheckByte
    
.arp
    pop     hl
    inc     hl
    inc     hl
    jp      DS_CH4_CheckByte

.setLoopCount
    pop     hl
    ld      a,[hl+]
    ld      [DS_CH4LoopCount],a
    jp      DS_CH4_CheckByte

.loop
    pop     hl
    inc     hl
    inc     hl
    ld      a,[DS_CH4LoopCount]
    dec     a
    ld      [DS_CH4LoopCount],a
    and     a
    jp      z,DS_CH4_CheckByte
    dec     hl
    dec     hl
    ld      a,[hl+]
    ld      [DS_CH4Ptr],a
    ld      a,[hl]
    ld      [DS_CH4Ptr+1],a
    jp      DS_UpdateCH4

DS_CH4_SetInstrument:
    ld      hl,InstrumentTable
    add     a
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ; no reset flag
    ld      a,[hl+]
    ld      [DS_CH4Reset],a
    ld      b,a
    ; vol table
    ld      a,[hl+]
    ld      [DS_CH4VolPtr],a
    ld      a,[hl+]
    ld      [DS_CH4VolPtr+1],a
    ; noise mode pointer
    ld      a,[hl+]
    ld      [DS_CH4NoisePtr],a
    ld      a,[hl+]
    ld      [DS_CH4NoisePtr+1],a
    ret
    
; ================================================================

DoneUpdating:

UpdateRegisters:
    ; update panning
    ld      a,[DS_CH1Pan]
    ld      b,a
    ld      a,[DS_CH2Pan]
    rla
    add     b
    ld      b,a
    ld      a,[DS_CH3Pan]
    rla 
    rla
    add     b
    ld      b,a
    ld      a,[DS_CH4Pan]
    rla
    rla
    rla
    add     b
    ldh     [rNR51],a

    ; update global volume + fade system
    ld      a,[DS_FadeType]
    ld      b,a
    and     3                   ; Check if no fade
    jr      z,.updateVolume     ; Update volume

    bit     2,b ; Check if on first fade
    jr      z,.notfirstfade
    res     2,b
    ld      a,b
    ld      [DS_FadeType],a
    dec     a
    dec     a                   ; If fading in (value 2), volume is 0 ; otherwise, it's 7
    jr      z,.gotfirstfadevolume
    ld      a,7
.gotfirstfadevolume
    ld      [DS_GlobalVolume],a
.notfirstfade

    ld      a,[DS_FadeTimer]
    and     a
    jr      z,.doupdate
    dec     a
    ld      [DS_FadeTimer],a
    jr      .updateVolume
.fadeout
    ld      a,[DS_GlobalVolume]
    and     a
    jr      z,.fadeFinished
.decrementVolume
    dec     a
    ld      [DS_GlobalVolume],a
    jr      .directlyUpdateVolume
.fadein
    ld      a,[DS_GlobalVolume]
    cp      7
    jr      z,.fadeFinished
    inc     a
    ld      [DS_GlobalVolume],a
    jr      .directlyUpdateVolume
.doupdate
    ld      a,7
    ld      [DS_FadeTimer],a
    ld      a,[DS_FadeType]
    and     3
    dec     a
    jr      z,.fadeout
    dec     a
    jr      z,.fadein
    dec     a
    ld      a,[DS_GlobalVolume]
    jr      nz,.directlyUpdateVolume
.fadeoutstop
    and     a
    jr      nz,.decrementVolume
    call    DevSound_Stop
    xor a
.fadeFinished
    ; a is zero
    ld      [DS_FadeType],a
.updateVolume
    ld      a,[DS_GlobalVolume]
.directlyUpdateVolume
    and     7
    ld      b,a
    swap    a
    or      b
    ldh     [rNR50],a
    
DS_CH1_UpdateRegisters:
    ld      a,[DS_CH1Enabled]
    and     a
    jp      z,DS_CH2_UpdateRegisters
    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH1,a
    jr      nz,.norest

    ld      a,[DS_CH1Note]
    cp      rest
    jr      nz,.norest
    xor     a
    ldh     [rNR12],a
    ldh     a,[rNR14]
    or      %10000000
    ldh     [rNR14],a
    jp      .done
.norest

    ; update arps
.updatearp
    ld      hl,DS_CH1ArpPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH1ArpPos]
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop
    ld      a,[hl]
    ld      [DS_CH1ArpPos],a
    jr      .updatearp
.noloop
    cp      $ff
    jr      z,.continue
    ld      [DS_CH1Transpose],a
.noreset
    ld      a,[DS_CH1ArpPos]
    inc     a
    ld      [DS_CH1ArpPos],a
.continue
    
    
    ; update pulse
    ld      hl,DS_CH1PulsePtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH1PulsePos]
    add     l
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    ld      a,[hl+]
    cp      $ff
    jr      z,.updateNote
    ; convert pulse value
    and     3           ; make sure value does not exceed 3
    swap    a           ; swap lower and upper nybbles
    rla                 ; rotate left
    rla                 ;   ""    ""
    
    ld      e,a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH1,a
    jr      nz,.noreset2
    ld      a,e
    ldh     [rNR11],a   ; transfer to register
.noreset2
    ld      a,[DS_CH1PulsePos]
    inc     a
    ld      [DS_CH1PulsePos],a
    ld      a,[hl+]
    cp      $80
    jr      nz,.updateNote
    ld      a,[hl]
    ld      [DS_CH1PulsePos],a
    
; get note
.updateNote
    ld      a,[DS_CH1Transpose]
    ld      b,a
    ld      a,[DS_CH1Note]
    add     b
    
    ld      c,a
    ld      b,0
    
    ld      hl,FreqTable
    add     hl,bc
    add     hl,bc   

; get note frequency
    ld      a,[hl+]
    ld      d,a
    ld      a,[hl]
    ld      e,a
.updateVibTable
    ld      a,[DS_CH1VibDelay]
    and     a
    jr      z,.doVib
    dec     a
    ld      [DS_CH1VibDelay],a
    jr      .setFreq
.doVib
    ld      hl,DS_CH1VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH1VibPos]
    add     l
    ld      l,a
    jr      nc,.nocarry4
    inc     h
.nocarry4
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop2
    ld      a,[hl+]
    ld      [DS_CH1VibPos],a
    jr      .doVib
.noloop2
    ld      [DS_CH1FreqOffset],a
    ld      a,[DS_CH1VibPos]
    inc     a
    ld      [DS_CH1VibPos],a
    
.getPitchOffset
    ld      a,[DS_CH1FreqOffset]
    bit     7,a
    jr      nz,.sub
    add     d
    ld      d,a
    jr      nc,.setFreq
    inc     e
    jr      .setFreq
.sub
    ld      c,a
    ld      a,d
    add     c
    ld      d,a
.setFreq   
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH1,a
    jr      nz,.updateVolume
    ld      a,d
    ldh     [rNR13],a
    ld      a,e
    ldh     [rNR14],a
    
    ; update volume
.updateVolume
    ld      hl,DS_CH1VolPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH1VolPos]
    add     l
    ld      l,a
    jr      nc,.nocarry5
    inc     h
.nocarry5
    ld      a,[hl+]
    cp      $ff
    jr      z,.done
    swap    a
    ld      b,a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH1,a
    jr      nz,.noreset3
    ldh     a,[rNR12]
    cp      b
    jr      z,.noreset3
    ld      a,b
    ldh     [rNR12],a
    ld      a,e
    or      $80
    ldh     [rNR14],a
.noreset3
    ld      a,[DS_CH1VolPos]
    inc     a
    ld      [DS_CH1VolPos],a
    ld      a,[hl+]
    cp      $8f
    jr      nz,.done
    ld      a,[hl]
    ld      [DS_CH1VolPos],a
.done

; ================================================================

DS_CH2_UpdateRegisters:
    ld      a,[DS_CH2Enabled]
    and     a
    jp      z,DS_CH3_UpdateRegisters
    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH2,a
    jr      nz,.norest

    ld      a,[DS_CH2Note]
    cp      rest
    jr      nz,.norest
    xor     a
    ldh     [rNR22],a
    ldh     a,[rNR24]
    or      %10000000
    ldh     [rNR24],a
    jp      .done
.norest

    ; update arps
.updatearp
    ld      hl,DS_CH2ArpPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH2ArpPos]
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop
    ld      a,[hl]
    ld      [DS_CH2ArpPos],a
    jr      .updatearp
.noloop
    cp      $ff
    jr      z,.continue
    ld      [DS_CH2Transpose],a
.noreset
    ld      a,[DS_CH2ArpPos]
    inc     a
    ld      [DS_CH2ArpPos],a
.continue
    
    ; update pulse
    ld      hl,DS_CH2PulsePtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH2PulsePos]
    add     l
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    ld      a,[hl+]
    cp      $ff
    jr      z,.updateNote
    ; convert pulse value
    and     3       ; make sure value does not exceed 3
    swap    a       ; swap lower and upper nybbles
    rla             ; rotate left
    rla             ;   ""    ""

    ld      e,a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH2,a
    jr      nz,.noreset2
    ld      a,e
    ldh     [rNR21],a   ; transfer to register
.noreset2
    ld      a,[DS_CH2PulsePos]
    inc     a
    ld      [DS_CH2PulsePos],a
    ld      a,[hl+]
    cp      $80
    jr      nz,.updateNote
    ld      a,[hl]
    ld      [DS_CH2PulsePos],a
    
; get note
.updateNote
    ld      a,[DS_CH2Transpose]
    ld      b,a
    ld      a,[DS_CH2Note]
    add     b
    
    ld      c,a
    ld      b,0
    
    ld      hl,FreqTable
    add     hl,bc
    add     hl,bc
    
    ; get note frequency
    ld      a,[hl+]
    ld      d,a
    ld      a,[hl]
    ld      e,a
.updateVibTable
    ld      a,[DS_CH2VibDelay]
    and     a
    jr      z,.doVib
    dec     a
    ld      [DS_CH2VibDelay],a
    jr      .setFreq
.doVib
    ld      hl,DS_CH2VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH2VibPos]
    add     l
    ld      l,a
    jr      nc,.nocarry4
    inc     h
.nocarry4
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop2
    ld      a,[hl+]
    ld      [DS_CH2VibPos],a
    jr      .doVib
.noloop2
    ld      [DS_CH2FreqOffset],a
    ld      a,[DS_CH2VibPos]
    inc     a
    ld      [DS_CH2VibPos],a
    
.getPitchOffset
    ld      a,[DS_CH2FreqOffset]
    bit     7,a
    jr      nz,.sub
    add     d
    ld      d,a
    jr      nc,.setFreq
    inc     e
    jr      .setFreq
.sub
    ld      c,a
    ld      a,d
    add     c
    ld      d,a
.setFreq    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH2,a
    jr      nz,.updateVolume
    ld      a,d
    ldh     [rNR23],a
    ld      a,e
    ldh     [rNR24],a

    ; update volume
.updateVolume
    ld      hl,DS_CH2VolPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH2VolPos]
    add     l
    ld      l,a
    jr      nc,.nocarry5
    inc     h
.nocarry5
    ld      a,[hl+]
    cp      $ff
    jr      z,.done
    swap    a
    ld      b,a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH2,a
    jr      nz,.noreset3

    ldh     a,[rNR22]
    cp      b
    jr      z,.noreset3
    ld      a,b
    ldh     [rNR22],a
    ld      a,e
    or      $80
    ldh     [rNR24],a
.noreset3
    ld      a,[DS_CH2VolPos]
    inc     a
    ld      [DS_CH2VolPos],a
    ld      a,[hl+]
    cp      $8f
    jr      nz,.done
    ld      a,[hl]
    ld      [DS_CH2VolPos],a
.done

; ================================================================

DS_CH3_UpdateRegisters:
    ld      a,[DS_CH3Enabled]
    and     a
    jp      z,DS_CH4_UpdateRegisters

    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.norest
    
    ld      a,[DS_CH3Note]
    cp      rest
    jr      nz,.norest
    xor     a
    ldh     [rNR32],a
    ldh     [rNR30],a
    ld      [DS_CH3Vol],a
    jp      .done
.norest

    ; update arps
.updatearp
    ld      hl,DS_CH3ArpPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH3ArpPos]
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop
    ld      a,[hl]
    ld      [DS_CH3ArpPos],a
    jr      .updatearp
.noloop 
    cp      $ff
    jr      z,.continue
    ld      [DS_CH3Transpose],a
.noreset
    ld      a,[DS_CH3ArpPos]
    inc     a
    ld      [DS_CH3ArpPos],a
.continue
    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.updateNote
    
    xor     a
    ldh     [rNR31],a
    or      %10000000
    ldh     [rNR30],a
    
; get note
.updateNote
    ld      a,[DS_CH3Transpose]
    ld      b,a
    ld      a,[DS_CH3Note]
    add     b
    
    ld      c,a
    ld      b,0
    
    ld      hl,FreqTable
    add     hl,bc
    add     hl,bc
    
    ; get note frequency
    ld      a,[hl+]
    ld      d,a
    ld      a,[hl]
    ld      e,a
.updateVibTable
    ld      a,[DS_CH3VibDelay]
    and     a
    jr      z,.doVib
    dec     a
    ld      [DS_CH3VibDelay],a
    jr      .setFreq
.doVib
    ld      hl,DS_CH3VibPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH3VibPos]
    add     l
    ld      l,a
    jr      nc,.nocarry4
    inc     h
.nocarry4
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop2
    ld      a,[hl+]
    ld      [DS_CH3VibPos],a
    jr      .doVib
.noloop2
    ld      [DS_CH3FreqOffset],a
    ld      a,[DS_CH3VibPos]
    inc     a
    ld      [DS_CH3VibPos],a
    
.getPitchOffset
    ld      a,[DS_CH3FreqOffset]
    bit     7,a
    jr      nz,.sub
    add     d
    ld      d,a
    jr      nc,.setFreq
    inc     e
    jr      .setFreq
.sub
    ld      c,a
    ld      a,d
    add     c
    ld      d,a
.setFreq  
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.updateWave
    ld      a,d
    ldh     [rNR33],a
    ld      a,e
    ldh     [rNR34],a

.updateWave
    ld      hl,DS_CH3WavePtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH3WavePos]
    add     l
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    ld      a,[hl+]
    cp      $ff                 ; table end?
    jr      z,.updateVolume
    ld      b,a
    ld      a,[DS_CH3Wave]
    cp      b
    jr      z,.noreset2
    ld      a,b
    ld      [DS_CH3Wave],a
    cp      $fd                 ; if value = $fd, use wave buffer
    jr      nz,.notwavebuf
    ld      hl,DS_WaveBuffer
    jr      .loadwave
.notwavebuf
    add     a
    ld      hl,WaveTable
    add     l
    ld      l,a
    jr      nc,.nocarry3
    inc     h   
.nocarry3
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
.loadwave
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.noreset2
    
    call    LoadWave
    ld      a,e
    or      %10000000
    ldh     [rNR34],a
.noreset2
    ld      a,[DS_CH3WavePos]
    inc     a
    ld      [DS_CH3WavePos],a
    ld      a,[hl+]
    cp      $80
    jr      nz,.updateVolume
    ld      a,[hl]
    ld      [DS_CH3WavePos],a

.updateVolume
    ld      hl,DS_CH3VolPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH3VolPos]
    add     l
    ld      l,a
    jr      nc,.nocarry5
    inc     h
.nocarry5
    ld      a,[hl+]
    cp      $ff
    jr      z,.done
    ld      b,a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.noreset3
    
    ld      a,[DS_CH3Vol]
    cp      b
    jr      z,.noreset3
    ld      a,$80
    ldh     [rNR30],a
    ld      a,b
    ldh     [rNR32],a
    ld      [DS_CH3Vol],a
    ld      a,e
    set     7,a
    ldh     [rNR34],a
.noreset3
    ld      a,[DS_CH3VolPos]
    inc     a
    ld      [DS_CH3VolPos],a
    ld      a,[hl+]
    cp      $80
    jr      nz,.done
    ld      a,[hl]
    ld      [DS_CH3VolPos],a
.done
    call    DoPWM
    ld      a,[DS_CH3Wave]
    cp      $fd
    jr      nz,.noupdate
    ld      a,[DS_WaveUpdateFlag]
    and     a
    jr      z,.noupdate
    ld      hl,DS_WaveBuffer
    call    LoadWave
    xor     a
    ld      [DS_WaveUpdateFlag],a
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    jr      nz,.noupdate
    ld      a,e
    or      $80
    ldh     [rNR34],a
.noupdate

; ================================================================

DS_CH4_UpdateRegisters:
    ld      a,[DS_CH4Enabled]
    and     a
    jp      z,DoneUpdatingRegisters
    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH4,a
    jr      nz,.norest

    ld      a,[DS_CH4Mode]
    cp      rest
    jr      nz,.norest
    xor     a
    ldh     [rNR42],a
    ldh     a,[rNR44]
    or      %10000000
    ldh     [rNR44],a
    jp      .done
.norest

    ; update arps
.updatearp
    ld      hl,DS_CH4NoisePtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH4NoisePos]
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    ld      a,[hl+]
    cp      $80
    jr      nz,.noloop
    ld      a,[hl]
    ld      [DS_CH4NoisePos],a
    jr      .updatearp
.noloop
    cp      $ff
    jr      z,.continue
    ld      [DS_CH4Transpose],a
.noreset
    ld      a,[DS_CH4NoisePos]
    inc     a
    ld      [DS_CH4NoisePos],a
.continue
    
; get note
.updateNote
    ld      a,[DS_CH4Transpose]
    ld      b,a
    ld      a,[DS_CH4Mode]
    add     b
    
    ld      hl,NoiseTable
    add     l
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH4,a
    jr      nz,.updateVolume
    ld      a,[hl+]
    ldh     [rNR43],a   

    ; update volume
.updateVolume
    ld      hl,DS_CH4VolPtr
    ld      a,[hl+]
    ld      h,[hl]
    ld      l,a
    ld      a,[DS_CH4VolPos]
    add     l
    ld      l,a
    jr      nc,.nocarry3
    inc     h
.nocarry3
    ld      a,[hl+]
    cp      $ff
    jr      z,.done
    swap    a
    ld      b,a
   
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH4,a
    jr      nz,.noreset3
    
    ldh     a,[rNR42]
    cp      b
    jr      z,.noreset3
    ld      a,b
    ldh     [rNR42],a
    ld      a,%10000000
    ldh     [rNR44],a
.noreset3
    ld      a,[DS_CH4VolPos]
    inc     a
    ld      [DS_CH4VolPos],a
    ld      a,[hl+]
    cp      $8f
    jr      nz,.done
    ld      a,[hl]
    ld      [DS_CH4VolPos],a
.done
    
DoneUpdatingRegisters:
    pop     hl
    pop     de
    pop     bc
    pop     af
    ret

; ================================================================
; Wave routines
; ================================================================

LoadWave:
    ld      a,[VGMSFX_Flags]
    bit     bSFX_CH3,a
    ret     nz
    xor     a
    ldh     [rNR30],a   ; disable DS_CH3
    ld      bc,$1030    ; b = counter, c = HRAM address
.loop
    ld      a,[hl+]     ; get byte from hl
    ld      [c],a       ; copy to wave ram
    inc     c
    dec     b
    jr      nz,.loop    ; loop until done
    ld      a,%10000000
    ldh     [rNR30],a   ; enable DS_CH3
    ret
    
ClearWaveBuffer:
    ld      a,$10
    ld      b,a
    xor     a
    ld      hl,DS_WaveBuffer
.loop
    ld      [hl+],a     ; copy to wave ram
    dec     b
    jr      nz,.loop    ; loop until done
    ret

; Do PWM
; TODO: Optimize
DoPWM:
    ld      a,[DS_PWMEnabled]
    and     a
    ret     z   ; if PWM is not enabled, return
    ld      a,[DS_PWMTimer]
    dec     a
    ld      [DS_PWMTimer],a
    and     a
    ret     nz
    ld      a,[DS_PWMSpeed]
    ld      [DS_PWMTimer],a
    ld      a,[DS_PWMDir]
    and     a
    jr      nz,.decPos
.incPos 
    ld      a,[DS_WavePos]
    inc     a
    ld      [DS_WavePos],a
    cp      $1e
    jr      nz,.continue
    ld      a,[DS_PWMDir]
    xor     1
    ld      [DS_PWMDir],a
    jr      .continue
.decPos
    ld      a,[DS_WavePos]
    dec     a
    ld      [DS_WavePos],a
    and     a
    jr      nz,.continue2
    ld      a,[DS_PWMDir]
    xor     1
    ld      [DS_PWMDir],a
    jr      .continue2
.continue
    ld      hl,DS_WaveBuffer
    ld      a,[DS_WavePos]
    rra
    push    af
    and     $f
    add     l
    ld      l,a
    jr      nc,.nocarry
    inc     h
.nocarry
    pop     af
    jr      c,.odd
.even
    ld      a,[DS_PWMVol]
    swap    a
    ld      [hl],a
    jr      .done
.odd
    ld      a,[hl]
    ld      b,a
    ld      a,[DS_PWMVol]
    or      b
    ld      [hl],a
    jr      .done
    
.continue2
    ld      hl,DS_WaveBuffer
    ld      a,[DS_WavePos]
    inc     a
    rra
    push    af
    and     $f
    add     l
    ld      l,a
    jr      nc,.nocarry2
    inc     h
.nocarry2
    pop     af
    jr      nc,.odd2
.even2
    ld      a,[DS_PWMVol]
    swap    a
    ld      [hl],a
    jr      .done
.odd2
    xor     a
    ld      [hl],a
.done
    ld      a,1
    ld      [DS_WaveUpdateFlag],a
    ret

; ================================================================
; Misc routines
; ================================================================

ClearArpBuffer:
    ld      hl,arp_Buffer
    push    hl
    inc     hl
    ld      b,7
    xor     a
.loop
    ld      a,[hl+]
    dec     b
    jr      nz,.loop
    dec     a
    pop     hl
    ld      a,[hl]
    ret
    
; TODO: Rewrite
DoArp:
    ld      de,arp_Buffer
    ld      a,[hl+]
    and     a
    jr      nz,.slow
.fast
    xor     a
    ld      [de],a
    inc     de
    ld      a,[hl]
    swap    a
    and     $f
    ld      [de],a
    inc     de
    ld      a,[hl+]
    and     $f
    ld      [de],a
    inc     de
    ld      a,$80
    ld      [de],a
    inc     de
    xor     a
    ld      [de],a
    ret
.slow
    xor     a
    ld      [de],a
    inc     de
    ld      [de],a
    inc     de
    ld      a,[hl]
    swap    a
    and     $f
    ld      [de],a
    inc     de
    ld      [de],a
    inc     de
    ld      a,[hl+]
    and     $f
    ld      [de],a
    inc     de
    ld      [de],a
    inc     de
    ld      a,$80
    ld      [de],a
    inc     de
    xor     a
    ld      [de],a
    ret

; ================================================================
; Frequency table
; ================================================================

FreqTable:
;        C-x  C#x  D-x  D#x  E-x  F-x  F#x  G-x  G#x  A-x  A#x  B-x
    dw  $02c,$09c,$106,$16b,$1c9,$223,$277,$2c6,$312,$356,$39b,$3da ; octave 1
    dw  $416,$44e,$483,$4b5,$4e5,$511,$53b,$563,$589,$5ac,$5ce,$5ed ; octave 2
    dw  $60a,$627,$642,$65b,$672,$689,$69e,$6b2,$6c4,$6d6,$6e7,$6f7 ; octave 3
    dw  $706,$714,$721,$72d,$739,$744,$74f,$759,$762,$76b,$773,$77b ; octave 4
    dw  $783,$78a,$790,$797,$79d,$7a2,$7a7,$7ac,$7b1,$7b6,$7ba,$7be ; octave 5
    dw  $7c1,$7c4,$7c8,$7cb,$7ce,$7d1,$7d4,$7d6,$7d9,$7db,$7dd,$7df ; octave 6
    dw  $7e1,$7e3,$7e4,$7e6,$7e7,$7e9,$7ea,$7eb,$7ec,$7ed,$7ee,$7ef ; octave 7 (not used directly, is slightly out of tune)
    
NoiseTable: ; taken from deflemask
    db  $a4 ; 15 steps
    db  $97,$96,$95,$94,$87,$86,$85,$84,$77,$76,$75,$74,$67,$66,$65,$64
    db  $57,$56,$55,$54,$47,$46,$45,$44,$37,$36,$35,$34,$27,$26,$25,$24
    db  $17,$16,$15,$14,$07,$06,$05,$04,$03,$02,$01,$00
    db  $ac ; 7 steps
    db  $9f,$9e,$9d,$9c,$8f,$8e,$8d,$8c,$7f,$7e,$7d,$7c,$6f,$6e,$6d,$6c
    db  $5f,$5e,$5d,$5c,$4f,$4e,$4d,$4c,$3f,$3e,$3d,$3c,$2f,$2e,$2d,$2c
    db  $1f,$1e,$1d,$1c,$0f,$0e,$0d,$0c,$0b,$0a,$09,$08

; ================================================================
; misc stuff
; ================================================================
    
DefaultRegTable:
    ; global flags
    db  $77,0,0,0,0,1,1,1,1,1
    ; ch1
    dw  DummyTable,DummyTable,DummyTable,DummyTable,DummyTable
    db  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; ch2
    dw  DummyTable,DummyTable,DummyTable,DummyTable,DummyTable
    db  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; ch3
    dw  DummyTable,DummyTable,DummyTable,DummyTable,DummyTable
    db  0,0,0,0,0, 0,0, 0,0,0,0,0,0,0, $ff, 0,0,0,0,0
    ; ch4
    dw  DummyTable,DummyTable,DummyTable
    db  0,0, 0,0, 0,0,0,0,0,0,0,0,0
    
DefaultWave:    db  $01,$23,$45,$67,$89,$ab,$cd,$ef,$fe,$dc,$ba,$98,$76,$54,$32,$10
    
; ================================================================
; Dummy data
; ================================================================
    
DummyTable: db  $ff

DummyChannel:
    db  EndChannel
    
; ================================================================
; Song data
; ================================================================

    include "Audio/DevSound_SongData.asm"
