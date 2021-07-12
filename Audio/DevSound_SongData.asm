; ================================================================
; DevSound song data
; ================================================================
    
; =================================================================
; Song speed table
; =================================================================

SongSpeedTable:
    db  4,3         ; menu
    db  4,5         ; desert
    
    
SongPointerTable:
    dw  PT_Menu
    dw  PT_Desert

; =================================================================
; Volume sequences
; =================================================================

; Wave volume values
w0          =   %00000000
w1          =   %01100000
w2          =   %01000000
w3          =   %00100000

; For pulse instruments, volume control is software-based by default.
; However, hardware volume envelopes may still be used by adding the
; envelope length * $10.
; Example: $3F = initial volume $F, env. length $3
; Repeat that value for the desired length.
; Note that using initial volume $F + envelope length $F will be
; interpreted as a "table end" command, use initial volume $F +
; envelope length $0 instead.
; Same applies to initial volume $F + envelope length $7 which
; is interpreted as a "loop" command, use initial volume $F +
; envelope length $0 instead.

vol_Bass1:          db  w3,$ff
vol_PulseBass:      db  15,15,14,14,13,13,12,12,11,11,10,10,9,9,8,8,8,7,7,7,6,6,6,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1,0,$ff

vol_Kick:           db  $1c,$1c,$18,$ff
vol_Snare:          db  $1d,$ff
vol_CHH:            db  $18,$ff
vol_OHH:            db  $48,$ff
vol_Cymbal:         db  $1e,$ff

vol_Echo1:          db  8,$ff   
vol_Echo2:          db  3,$ff

vol_DesertArp:      db  w3,w3,w3,w3,w3,w2,w2,w2,w2,w2,w1,$ff
vol_DesertLeadS:    db  w3,w3,w3,w3,w3
vol_DesertLeadF:    db  w2,w2,w2,w2,w2
                    db  w1,$ff              
vol_DesertLeadL:    db  w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3
                    db  w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3
                    db  w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2
                    db  w1,$ff
        
vol_TomEcho:        db  $1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
                    db  $18,$18,$18,$18,$18,$18,$18,$18,$18
                    db  $14,$14,$14,$14,$14,$14,$14,$14,$14
                    db  $12,$12,$12,$12,$12,$12,$12,$12,$12
                    db  $11,$11,$11,$11,$11,$11,$11,$11,$11
                    db  $ff
                    
; ========

vol_MenuLead:       db  w3,w3,w3,w3,w3,w3,w3,w2,w1,w2,w2,w2,w2,w2,w2,w1,$ff

vol_MenuOctave:     db  w3,w3,w3,w2,w2,w1,$ff
vol_MenuOctaveEcho: db  w1,$ff
vol_MenuBass:       db  $2f,$ff
vol_MenuArp:        db  $1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$53,$ff
                
; =================================================================
; Arpeggio sequences
; =================================================================

arp_Pluck:      db  12,0,$ff
arp_TomEcho:    db  22,20,18,16,14,12,10,9,7,$80,0
arp_Oct2:       db  12,12,0,0,$80,0

arp_940:        db  9,9,4,4,0,0,$80,0
arp_720:        db  7,7,2,2,0,0,$80,0
arp_520:        db  5,5,2,2,0,0,$80,0

arp_MenuTom:    db  12,11,10,9,8,7,6,5,4,3,2,1,0,$80,12

arp_MenuArp027: db  0,0,2,2,7,7,$80     ; last byte reads from next table
arp_MenuArp037: db  0,0,3,3,7,7,$80     ; last byte reads from next table
arp_MenuArp047: db  0,0,4,4,7,7,$80     ; last byte reads from next table
arp_MenuArp057: db  0,0,5,5,7,7,$80     ; last byte reads from next table
arp_MenuArp038: db  0,0,3,3,8,8,$80     ; last byte reads from next table
arp_MenuArp059: db  0,0,5,5,9,9,$80     ; last byte reads from next table
arp_MenuArp05A: db  0,0,5,5,10,10,$80,0

; =================================================================
; Noise sequences
; =================================================================

; Noise values are the same as Deflemask, but with one exception:
; To convert 7-step noise values (noise mode 1 in deflemask) to a
; format usable by DevSound, take the corresponding value in the
; arpeggio macro and add s7.
; Example: db s7+32 = noise value 32 with step lengh 7
; Note that each arpseq must be terminated with a loop command
; ($80) otherwise the noise value will reset!

s7 = $2d

arp_Kick:       db  s7+18,s7+18,43,$80,2
arp_Snare:      db  s7+29,s7+23,s7+20,35,$80,3
arp_Hat:        db  43,$80,0
arp_Cymbal:     db  35,40,43,$80,2 

; =================================================================
; Pulse sequences
; =================================================================

waveseq_Dummy:      db  0,$ff
waveseq_Arp:        db  2,2,2,1,1,1,0,0,0,3,3,3,$80,0
waveseq_OctArp:     db  2,2,2,1,1,2,$ff

waveseq_PulseBass:  db  1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,0,0,0,0,0,0,$80,0
waveseq_Pulse125:   db  0,$ff
waveseq_Pulse25:    db  1,$ff
waveseq_Pulse50:
waveseq_Square:     db  2,$ff
waveseq_Pulse75:    db  3,$ff
waveseq_Arp2:       db  0,0,0,0,1,1,1,2,2,2,2,3,3,3,2,2,2,2,1,1,1,$80,0

waveseq_DesertBass: db  0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,$80,0

waveseq_MenuArp:
    db  0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db  1,1,1,1,1,1,1,1,1,1,1,1,1,1
    db  2,2,2,2,2,2,2,2,2,2,2,2,2,2
    db  3,3,3,3,3,3,3,3,3,3,3,3,3,3
    db  $80,0

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:      db  $ff,0,$80,1
vib_BeachLead:  db  8,1,1,2,2,1,1,0,0,-1,-1,-2,-2,-1,-1,0,0,$80,1
vib_PWMLead:    db  24,2,3,3,2,0,0,-2,-3,-3,-2,0,0,$80,1

; =================================================================
; Wave sequences
; =================================================================

WaveTable:
    dw      DefaultWave
    dw      wave_DesertLead
    dw      wave_DesertSquare
    dw      wave_MenuLead1
    dw      wave_MenuLead2
    dw      wave_MenuTri
    
    dw      wave_ForestBass
    
wave_DesertLead:    db      $01,$23,$45,$67,$89,$ab,$cd,$ef,$ed,$b9,$75,$31,$02,$46,$8a,$ce
wave_DesertSquare:  db      $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$00,$00,$44,$44,$00,$00,$00

wave_MenuLead1:     db      $fe,$de,$11,$22,$22,$22,$22,$22,$22,$23,$33,$45,$44,$44,$32,$56
wave_MenuLead2:     db      $ce,$ff,$ff,$ff,$ff,$f0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$13
wave_MenuTri:       db      $68,$8c,$ef,$fd,$b9,$75,$32,$02,$68,$8c,$ef,$fd,$b9,$75,$32,$02

wave_ForestBass:    db      $54,$44,$44,$43,$20,$07,$a9,$9a,$ac,$ee,$aa,$96,$54,$44,$44,$45

waveseq_Tri:            db  0,$ff
waveseq_DesertLead:     db  1,$ff
waveseq_DesertSquare:   db  2,$ff

waveseq_MenuLead:       db  3,4,$ff
waveseq_MenuTri:        db  5,$ff

; =================================================================
; Instruments
; =================================================================

InstrumentTable:
    const_def
    
    dins    Kick
    dins    Snare
    dins    CHH
    dins    OHH
    dins    Cymbal
    
    dins    Echo1
    dins    Echo2
    dins    TomEcho
    dins    DesertBass
    dins    DesertLead
    dins    DesertLeadF
    dins    DesertLeadS
    dins    DesertLeadL
    dins    DesertOctArp
    dins    DesertArp720
    dins    DesertArp940
    dins    DesertArp520
    
    dins    MenuLead
    dins    MenuOctave
    dins    MenuOctaveEcho
    dins    MenuBass
    dins    MenuArp027
    dins    MenuArp037
    dins    MenuArp047
    dins    MenuArp057
    dins    MenuArp038
    dins    MenuArp059
    dins    MenuArp05A
    dins    MenuTom

; Instrument format: [no reset flag],[wave mode (ch3 only)],[voltable id],[arptable id],[pulsetable/wavetable id],[vibtable id]
; note that wave mode must be 0 for non-wave instruments
; !!! REMEMBER TO ADD INSTRUMENTS TO THE INSTRUMENT POINTER TABLE !!!
ins_Kick:           Instrument  0,Kick,Kick,_,_ ; pulse/waveseq and vibrato unused by noise instruments
ins_Snare:          Instrument  0,Snare,Snare,_,_
ins_CHH:            Instrument  0,CHH,Hat,_,_
ins_OHH:            Instrument  0,OHH,Hat,_,_
ins_Cymbal:         Instrument  0,Cymbal,Cymbal,_,_

ins_Echo1:          Instrument  0,Echo1,_,_,_
ins_Echo2:          Instrument  0,Echo2,_,_,_
ins_TomEcho:        Instrument  0,TomEcho,TomEcho,Square,_
ins_DesertBass:     Instrument  0,PulseBass,Pluck,DesertBass,_
ins_DesertLead:     Instrument  0,Bass1,Pluck,DesertLead,BeachLead
ins_DesertLeadF:    Instrument  0,DesertLeadF,_,DesertLead,_
ins_DesertLeadS:    Instrument  0,DesertLeadS,Pluck,DesertLead,_
ins_DesertLeadL:    Instrument  0,DesertLeadL,Pluck,DesertLead,BeachLead
ins_DesertOctArp:   Instrument  0,DesertArp,Oct2,Square,BeachLead
ins_DesertArp720:   Instrument  0,DesertArp,720,DesertSquare,_
ins_DesertArp940:   Instrument  0,DesertArp,940,DesertSquare,_
ins_DesertArp520:   Instrument  0,DesertArp,520,DesertSquare,_

ins_MenuLead:       Instrument  0,MenuLead,Pluck,MenuLead,BeachLead
ins_MenuOctave:     Instrument  0,MenuOctave,Oct2,MenuTri,_
ins_MenuOctaveEcho: Instrument  0,MenuOctaveEcho,Oct2,MenuTri,_
ins_MenuBass:       Instrument  0,MenuBass,Pluck,Pulse25,_
ins_MenuArp027:     Instrument  1,MenuArp,MenuArp027,MenuArp,_
ins_MenuArp037:     Instrument  1,MenuArp,MenuArp037,MenuArp,_
ins_MenuArp047:     Instrument  1,MenuArp,MenuArp047,MenuArp,_
ins_MenuArp057:     Instrument  1,MenuArp,MenuArp057,MenuArp,_
ins_MenuArp038:     Instrument  1,MenuArp,MenuArp038,MenuArp,_
ins_MenuArp059:     Instrument  1,MenuArp,MenuArp059,MenuArp,_
ins_MenuArp05A:     Instrument  1,MenuArp,MenuArp05A,MenuArp,_
ins_MenuTom:        Instrument  0,MenuArp,MenuTom,Pulse50,_

; =================================================================

PT_Desert:  dw  Desert_CH1,Desert_CH2,Desert_CH3,Desert_CH4

Desert_CH1:
    db  SetInstrument,_DesertBass
    db  F_2,2
    db  F_2,4
    db  F_2,2
    Drum    TomEcho,4
    db  SetInstrument,_DesertBass
    db  D#2,2
    db  F_2,4
    db  F_2,2
    db  D#2,2
    db  F_2,2
    Drum    TomEcho,6
    db  SetInstrument,_DesertBass
    db  F_2,2
    db  F#2,2
    db  F#2,4
    db  F#2,2
    Drum    TomEcho,4
    db  SetInstrument,_DesertBass
    db  F_2,2
    db  F#2,4
    db  F#2,2
    db  F_2,2
    db  F#2,2
    Drum    TomEcho,6
    db  SetInstrument,_DesertBass
    db  A_2,2
    dbw Goto,Desert_CH1
    
Desert_CH2:
    db  SetInsAlternate,_Echo1,_Echo2
.loop
    db  F_5,1,C#5,1
    db  C_5,1,F_5,1
    db  D#5,1,C_5,1
    db  C_5,1,D#5,1
    dbw CallSection,.block0
    dbw CallSection,.block0
    dbw CallSection,.block0
    db  F#5,1,C_5,1
    db  C#5,1,F#5,1
    db  E_5,1,C#5,1
    db  C#5,1,E_5,1
    dbw CallSection,.block1
    dbw CallSection,.block1
    dbw CallSection,.block1
    dbw Goto,.loop
.block0
    db  F_5,1,C_5,1
    db  C_5,1,F_5,1
    db  D#5,1,C_5,1
    db  C_5,1,D#5,1
    ret
.block1
    db  F#5,1,C#5,1
    db  C#5,1,F#5,1
    db  E_5,1,C#5,1
    db  C#5,1,E_5,1
    ret
    
Desert_CH3:
    db  SetInstrument,_DesertLead
    dbw CallSection,.block0
    dbw CallSection,.block0

    dbw CallSection,.block1
    db  C#5,18,C#5,2
    db  D#5,3,D#5,1
    db  SetInsAlternate,_DesertLead,_DesertLeadS
    db  C#5,2
    db  D#5,2
    db  C#5,2
    db  A#4,2
    dbw CallSection,.block1
    db  SetInsAlternate,_DesertLead,_DesertLeadS
    db  F#5,2
    db  G#5,2
    db  F#5,2
    db  G#5,2
    db  SetInstrument,_DesertLead
    db  F#5,4
    db  G#5,2
    db  SetInstrument,_DesertLeadF
    db  G#5,2
    db  SetInstrument,_DesertLead
    db  F#5,8
    db  A#5,6
    db  SetInstrument,_DesertLeadF
    db  A#5,2
    
    db  SetInstrument,_DesertLead
    db  C_6,10
    db  SetInstrument,_DesertLeadF
    db  C_6,2
    db  SetInstrument,_DesertLead
    db  G#5,4
    db  F_5,6
    db  SetInstrument,_DesertLeadF
    db  F_5,2
    db  SetInsAlternate,_DesertLeadS,_DesertLead
    db  G#5,2
    db  F_5,2
    db  C_5,2
    db  F_5,2
    db  F#5,2
    db  F_5,2
    db  F#5,2
    db  G#5,2
    db  SetInstrument,_DesertLead
    db  F#5,4
    db  G#5,2
    db  SetInstrument,_DesertLeadF
    db  G#5,2
    db  SetInsAlternate,_DesertLead,_DesertLeadF
    db  F#5,6,F#5,2
    db  D#5,6,D#5,2
    db  SetInstrument,_DesertLeadL
    db  F_5,32
    db  SetInstrument,_DesertArp720
    db  F#5,4
    db  F#5,4
    db  F#5,2
    db  F#5,4
    db  F#5,4
    db  F#5,4
    db  F#5,2
    db  SetInstrument,_DesertArp940
    db  F#5,2
    db  F#5,2
    db  SetInstrument,_DesertArp720
    db  F#5,2
    db  SetInstrument,_DesertArp520
    db  F#5,2
    db  SetInstrument,_DesertLead
    db  CallSection
    dw  .block0
    db  CallSection
    dw  .block0
    db  SetInstrument,_DesertOctArp
    db  CallSection
    dw  .block0
    db  CallSection
    dw  .block2
    dbw Goto,Desert_CH3

.block0
    db  F_5,2
    db  D#5,2
    db  F_5,2
    db  F#5,2
    db  F_5,2
    db  D#5,2
    db  F_5,2
    db  C_5,2
    db  F_5,2
    db  C_5,2
    db  F_5,2
    db  A_5,4
    db  F_5,2
    db  D#5,2
    db  F_5,2
    db  F#5,2
    db  C#5,2
    db  A#5,2
    db  G#5,2
    db  F#5,2
    db  F_5,2
    db  F#5,2
    db  C#5,2
    db  F#5,2
    db  C#5,2
    db  F#5,2
    db  A#5,4
    db  G#5,2
    db  F#5,2
    db  D#5,2
    ret
.block1
    db  SetInsAlternate,_DesertLead,_DesertLeadF
    db  C_5,14,C_5,2
    db  F_5,6,F_5,2
    db  C_5,6,C_5,2
    ret
.block2
    db  F_6,2
    db  D#6,2
    db  F_6,2
    db  F#6,2
    db  F_6,2
    db  D#6,2
    db  F_6,2
    db  C_6,2
    db  F_6,2
    db  C_6,2
    db  F_6,2
    db  A_6,4
    db  F_6,2
    db  D#6,2
    db  F_6,2
    db  F#6,2
    db  C#6,2
    db  A#6,2
    db  G#6,2
    db  F#6,2
    db  F_6,2
    db  F#6,2
    db  C#6,2
    db  F#6,2
    db  C#6,2
    db  F#6,2
    db  A#6,4
    db  G#6,2
    db  F#6,2
    db  D#6,2
    ret
    
Desert_CH4:
    Drum    Kick,2
    Drum    CHH,2
    Drum    OHH,2
    Drum    CHH,2
    Drum    Snare,4
    Drum    OHH,2
    Drum    CHH,2
    dbw     Goto,Desert_CH4
    
; =================================================================

PT_Menu:    dw  Menu_CH2,Menu_CH1,Menu_CH3,Menu_CH4

; ========

Menu_CH1:
    db      SetInstrument,_MenuBass
.loop
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    db      G_2,2
    db      A_2,4
    db      B_2,4
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    db      A_2,2
    db      G_2,4
    db      E_2,4
    db      F_2,8
    db      C_2,6
    db      G_2,4
    db      G_2,4
    db      G_2,6
    db      F_2,4   
    db      E_2,8
    db      C_2,6
    db      A_2,4
    db      A_2,4
    db      A_2,6
    db      E_2,4
    db      F_2,8
    db      C_2,6
    db      G_2,4
    db      G_2,4
    db      G_2,6
    db      B_2,4   
    db      C_3,8
    db      G_2,6
    db      C_3,4
    db      C_3,6
    db      B_2,4
    db      G_2,4
    db      F_2,8
    db      C_2,6
    db      G_2,4
    db      G_2,4
    db      G_2,6
    db      D_2,4
    db      E_2,8
    db      B_2,6
    db      A_2,4
    db      A_2,2
    db      E_2,4
    db      A_2,4
    db      E_2,4
    db      F_2,8
    db      C_2,6
    dbw     CallSection,.block2
    db      G_2,2
    db      A_2,4
    db      B_2,4
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    db      G_2,2
    db      A_2,4
    db      B_2,4
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block1 
    dbw     Goto,.loop
.block0
    db      C_3,8
    db      G_2,6
    db      C_3,4
    db      C_3,2
    db      G_2,4
    db      C_3,4
    db      B_2,4
    db      A_2,8
    db      E_2,6
    db      A_2,4
    db      A_2,2
    db      E_2,4
    db      A_2,4
    db      G_2,4
    db      F_2,8
    db      C_2,6
    ret
.block1
    db      F_2,4
    db      F_2,2
    db      C_2,4
    db      F_2,4
    db      F#2,4
    db      G_2,8
    db      D_3,6
    db      G_2,4
    db      G_2,2
    db      D_2,4
    db      A_2,4
    db      B_2,4
    ret
.block2
    db      G_2,4
    db      G_2,6
    db      A_2,4
    db      B_2,4
    db      C_3,6
    db      G_2,6
    db      C_3,10
    ret

; ========

Menu_CH2:
.loop
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     CallSection,.block3
    db      SetInstrument,_MenuArp047
    db      F_4,4
    db      F_4,6
    db      G_4,4
    db      G_4,6
    db      G_4,4
    db      G_4,8
    db      SetInstrument,_MenuArp057
    db      C_5,4
    db      C_5,6
    db      SetInstrument,_MenuArp047
    db      C_5,4
    db      C_5,6
    db      C_5,4
    db      C_5,4
    dbw     CallSection,.block3
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     Goto,.loop
.block0
    db      rest,4
    db      SetInstrument,_MenuArp047
    db      C_5,4
    db      C_5,6
    db      C_5,4
    db      C_5,6
    db      C_5,4
    db      C_5,8
    db      SetInstrument,_MenuArp037
    db      A_4,4
    db      A_4,6
    db      A_4,4
    db      A_4,6
    db      SetInstrument,_MenuArp057
    db      A_4,4
    db      SetInstrument,_MenuArp037
    db      A_4,8
    ret
.block1
    db      SetInstrument,_MenuArp059
    db      C_4,4
    db      C_4,6
    db      C_4,4
    db      C_4,6
    db      SetInstrument,_MenuArp057
    db      C_4,4
    db      SetInstrument,_MenuArp059
    db      C_4,8
    db      D_4,4
    db      D_4,6
    db      SetInstrument,_MenuArp05A
    db      D_4,4
    db      SetInstrument,_MenuArp059
    db      D_4,6
    db      SetInstrument,_MenuArp057
    db      D_4,4
    db      SetInstrument,_MenuArp059
    db      D_4,4
    ret
.block2
    db      SetInstrument,_MenuArp047
    db      F_4,4
    db      F_4,6
    db      SetInstrument,_MenuArp057
    db      G_4,4
    db      SetInstrument,_MenuArp047
    db      G_4,6
    db      SetInstrument,_MenuArp027
    db      G_4,4
    db      SetInstrument,_MenuArp047
    db      G_4,4
    db      SetInstrument,_MenuArp057
    db      C_5,6
    db      C_5,6
    db      SetInstrument,_MenuArp047
    db      C_5,12
    db      SetInstrument,_MenuTom
    db      C_3,2
    db      C_3,2
    db      F_2,2
    db      F_2,2
    ret
.block3
    db      SetInstrument,_MenuArp047
    db      rest,4
    db      F_4,4
    db      F_4,6
    db      G_4,4
    db      G_4,6
    db      G_4,4
    db      G_4,8
    db      SetInstrument,_MenuArp037
    db      E_4,4
    db      E_4,6
    db      SetInstrument,_MenuArp038
    db      E_4,4
    db      E_4,6
    db      E_4,4
    db      E_4,8
    ret
    
; ========

Menu_CH3:
    db      SetInstrument,_MenuLead
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     CallSection,.block3
    db      G_5,2
    db      A_5,4
    db      B_5,4
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     CallSection,.block3
    db      C_6,2
    db      B_5,4
    db      G_5,4
    dbw     CallSection,.block4
    db      A_5,4
    db      G_5,4
    db      E_5,4
    db      G_5,4
    db      E_5,2
    db      A_5,4
    db      A_5,4
    db      A_5,6
    db      E_5,4
    db      F_5,4
    db      C_5,4
    db      F_5,4
    db      C_5,2
    db      G_5,4
    db      G_5,4
    db      F_5,6
    db      D_5,4
    db      E_5,4
    db      F_5,4
    db      F#5,4
    db      G_5,8
    db      E_5,4
    db      G_5,4
    db      E_5,4
    dbw     CallSection,.block4
    db      F_5,4
    db      E_5,4
    db      G_5,4
    db      D_6,4
    db      C_6,6
    db      G_5,2
    db      A_5,2
    db      C_6,2
    db      E_6,4
    db      C_6,4
    db      F_6,4
    db      E_6,4
    db      C_6,4
    db      A_5,2
    db      F_6,4
    db      F_6,2
    db      E_6,4
    db      C_6,4
    db      A_5,4
    dbw     CallSection,.block3
    db      G_5,2
    db      A_5,4
    db      B_5,4
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     CallSection,.block3
    db      rest,10
    db      SetInstrument,_MenuOctave
    dbw     CallSection,.block5
    dbw     CallSection,.block5 
    dbw     Goto,Menu_CH3
.block0
    db      C_6,4
    db      C_6,2
    db      G_5,2
    db      C_6,2
    db      G_5,4
    db      F_5,4
    db      G_5,4
    db      C_6,2
    db      B_5,4
    db      G_5,4
    db      A_5,4
    db      G_5,4
    db      A_5,2
    db      B_5,4
    db      A_5,8
    db      G_5,2
    db      A_5,4
    db      B_5,4
    ret
.block1
    db      C_6,4
    db      C_6,2
    db      A_5,2
    db      C_6,2
    db      D_6,4
    db      C_6,4
    db      C_6,2
    db      A_5,4
    db      C_6,4
    db      A_5,4
    db      G_5,4
    db      F_5,4
    db      G_5,2
    db      A_5,4
    db      G_5,8
    db      G_5,2
    db      A_5,4
    db      B_5,4
    ret
.block2
    db      C_6,4
    db      F_5,2
    db      A_5,2
    db      C_6,2
    db      E_6,4
    db      F_6,4
    db      F_6,2
    db      E_6,4
    db      C_6,4
    db      A_5,4
    ret
.block3
    db      C_6,6
    db      D_6,6
    db      C_6,6
    db      rest,4
    ret
.block4
    db      A_5,4
    db      F_5,4
    db      A_5,4
    db      F_5,2
    db      B_5,4
    db      B_5,4
    db      B_5,6
    ret
.block5 
    db      C_5,2,E_5,2,G_5,2,C_6,2
    db      SetInstrument,_MenuOctaveEcho
    db      G_5,2
    db      SetInstrument,_MenuOctave
    db      C_6,2,G_5,2,E_5,2
    db      C_5,2,E_5,2,G_5,2,C_6,2
    db      SetInstrument,_MenuOctaveEcho
    db      G_5,2
    db      SetInstrument,_MenuOctave
    db      C_6,2,G_5,2,E_5,2
    db      A_4,2,C_5,2,E_5,2,A_5,2
    db      SetInstrument,_MenuOctaveEcho
    db      E_5,2
    db      SetInstrument,_MenuOctave
    db      A_5,2,E_5,2,C_5,2
    db      A_4,2,C_5,2,E_5,2,A_5,2
    db      SetInstrument,_MenuOctaveEcho
    db      E_5,2
    db      SetInstrument,_MenuOctave
    db      A_5,2,E_5,2,C_5,2
    db      C_5,2,F_5,2,A_5,2,C_6,2
    db      SetInstrument,_MenuOctaveEcho
    db      A_5,2
    db      SetInstrument,_MenuOctave
    db      C_6,2,A_5,2,F_5,2
    db      C_5,2,F_5,2,A_5,2,C_6,2
    db      SetInstrument,_MenuOctaveEcho
    db      A_5,2
    db      SetInstrument,_MenuOctave
    db      C_6,2,A_5,2,F_5,2
    db      D_5,2,G_5,2,B_5,2,D_6,2
    db      SetInstrument,_MenuOctaveEcho
    db      B_5,2
    db      SetInstrument,_MenuOctave
    db      D_6,2,B_5,2,G_5,2
    db      D_5,2,G_5,2,B_5,2,D_6,2
    db      SetInstrument,_MenuOctaveEcho
    db      B_5,2
    db      SetInstrument,_MenuOctave
    db      D_6,2,B_5,2,G_5,2
    ret
    
; ========
    
Menu_CH4:
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block2
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     Goto,Menu_CH4
.block0
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Snare,4
    Drum    CHH,2
    Drum    Kick,2
    Drum    CHH,2
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Snare,4
    Drum    CHH,2
    Drum    CHH,2
    ; fall through
.block1
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Snare,4
    Drum    CHH,2
    Drum    Kick,2
    Drum    CHH,2
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Snare,4
    Drum    CHH,2
    Drum    CHH,2
    ret
.block2
    Drum    Snare,4
    Drum    Kick,2
    Drum    Snare,4
    Drum    Kick,2
    Drum    Snare,4
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Cymbal,2
    Drum    Cymbal,2
    Drum    Cymbal,2
    Drum    Cymbal,2
    ret