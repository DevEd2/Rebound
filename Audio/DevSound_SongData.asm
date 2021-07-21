; ================================================================
; DevSound song data
; ================================================================

; Song constants


    const_def

    const   MUS_MENU
    const   MUS_PLAINS
;   const   MUS_CITY
    const   MUS_PYRAMID
;   const   MUS_CAVE
;   const   MUS_FOREST
;   const   MUS_TEMPLE
    const   MUS_PLAINS_CLEAR
;   const   MUS_CITY_CLEAR
;   const   MUS_PYRAMID_CLEAR
;   const   MUS_FOREST_CLEAR
;   const   MUS_CAVE_CLEAR
;   const   MUS_TEMPLE_CLEAR
;   const   MUS_PLAYER_DOWN
;   const   MUS_BONUS
;   const   MUS_CREDITS

NUM_SONGS   equ const_value
    
; =================================================================
; Song speed table
; =================================================================

SongSpeedTable:
    db  4,3 ; menu
    db  6,6 ; plains
;   db  3,3 ; city
    db  4,5 ; pyramid
;   db  3,3 ; cave
;   db  3,3 ; forest
;   db  3,3 ; temple
    db  6,6 ; plains stage clear
;   db  3,3 ; city stage clear
;   db  3,3 ; pyramid stage clear
;   db  3,3 ; forest stage clear
;   db  3,3 ; cave stage clear
;   db  3,3 ; temple stage clear
;   db  3,3 ; player down
;   db  3,3 ; bonus stage
;   db  3,3 ; credits

SongPointerTable:
    dw  PT_Menu
    dw  PT_Plains
;   dw  PT_City
    dw  PT_Pyramid
;   dw  PT_Cave
;   dw  PT_Forest
;   dw  PT_Temple
    dw  PT_PlainsClear
;   dw  PT_CityClear
;   dw  PT_PyramidClear
;   dw  PT_ForestClear
;   dw  PT_CaveClear
;   dw  PT_TempleClear
;   dw  PT_PlayerDown
;   dw  PT_Bonus
;   dw  PT_Credits

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

vol_PyramidArp:     db  w3,w3,w3,w3,w3,w2,w2,w2,w2,w2,w1,$ff
vol_PyramidLeadS:   db  w3,w3,w3,w3,w3
vol_PyramidLeadF:   db  w2,w2,w2,w2,w2
                    db  w1,$ff              
vol_PyramidLeadL:   db  w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3
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
vol_MenuBass:       db  $2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$38,$ff
vol_MenuArp:        db  $1b,$1b,$1b,$1b,$27,$27,$27,$27,$27,$27,$27,$27,$27,$27,$53,$ff

; ========

vol_PlainsBass:     db  w3,w3,w3,w3,w3,w3,w3,w2,w2,w2,w2,w2,w2,w2,w1,$ff
vol_PlainsLead:     db  $5a,$ff
vol_PlainsEcho:     db  2,$ff
vol_PlainsHarmony:  db  $59,$ff
vol_PlainsHarmonyR: db  4,$ff

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

arp_PlainsBass: db  12,12,0,$ff

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

waveseq_PlainsHarmonyR:
waveseq_Dummy:
waveseq_Pulse125:       db  0,$ff
waveseq_Pulse25:        db  1,$ff
waveseq_Pulse50:
waveseq_Square:         db  2,$ff
waveseq_Pulse75:        db  3,$ff

waveseq_PyramidBass:    db  0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,$80,0

waveseq_MenuArp:
    db  0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db  1,1,1,1,1,1,1,1,1,1,1,1,1,1
    db  2,2,2,2,2,2,2,2,2,2,2,2,2,2
    db  3,3,3,3,3,3,3,3,3,3,3,3,3,3
    db  $80,0

waveseq_PlainsLead:     db  0,0,0,0,1,$ff
waveseq_PlainsHarmony:  db  2,2,0,$ff

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:          db  $ff,0,$80,1
vib_BeachLead:      db  8,1,1,2,2,1,1,0,0,-1,-1,-2,-2,-1,-1,0,0,$80,1
vib_PWMLead:        db  24,2,3,3,2,0,0,-2,-3,-3,-2,0,0,$80,1

vib_PlainsLead:     db  18,2,4,6,4,2,0,-2,-4,-6,-4,-2,0,$80,1
vib_PlainsEcho:     db  0,-2,$80,1
vib_PlainsHarmonyR: db  0,2,4,6,4,2,0,-2,-4,-6,-4,-2,0,$80,1

; =================================================================
; Wave sequences
; =================================================================

WaveTable:
    dw      DefaultWave
    dw      wave_PyramidLead
    dw      wave_PyramidSquare
    dw      wave_MenuLead1
    dw      wave_MenuLead2
    dw      wave_MenuTri
    dw      wave_ForestBass
    dw      wave_DirtyOctTri
    dw      wave_PlainsBass

wave_PyramidLead:   db      $01,$23,$45,$67,$89,$ab,$cd,$ef,$ed,$b9,$75,$31,$02,$46,$8a,$ce
wave_PyramidSquare: db      $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$00,$00,$44,$44,$00,$00,$00
wave_MenuLead1:     db      $cb,$ab,$11,$22,$22,$22,$22,$22,$22,$23,$33,$45,$44,$44,$32,$56
wave_MenuLead2:     db      $9a,$cc,$cc,$cc,$cc,$c0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$13
wave_MenuTri:       db      $68,$8c,$ef,$fd,$b9,$75,$32,$02,$68,$8c,$ef,$fd,$b9,$75,$32,$02
wave_ForestBass:    db      $54,$44,$44,$43,$20,$07,$a9,$9a,$ac,$ee,$aa,$96,$54,$44,$44,$45
wave_DirtyOctTri:   db      $11,$36,$9b,$de,$ec,$98,$75,$53,$21,$26,$9c,$ee,$dc,$99,$85,$43 
wave_PlainsBass:    db      $ff,$ff,$ff,$ff,$ee,$d7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03

waveseq_Tri:            db  0,$ff
waveseq_PyramidLead:     db  1,$ff
waveseq_PyramidSquare:   db  2,$ff
waveseq_MenuLead:       db  3,4,$ff
waveseq_MenuTri:        db  5,$ff
waveseq_PlainsBass:     db  8,$ff

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
    dins    PyramidBass
    dins    PyramidLead
    dins    PyramidLeadF
    dins    PyramidLeadS
    dins    PyramidLeadL
    dins    PyramidOctArp
    dins    PyramidArp720
    dins    PyramidArp940
    dins    PyramidArp520
    
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

    dins    PlainsBass
    dins    PlainsLead
    dins    PlainsEcho
    dins    PlainsHarmony
    dins    PlainsHarmonyR

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
ins_PyramidBass:    Instrument  0,PulseBass,Pluck,PyramidBass,_
ins_PyramidLead:    Instrument  0,Bass1,Pluck,PyramidLead,BeachLead
ins_PyramidLeadF:   Instrument  0,PyramidLeadF,_,PyramidLead,_
ins_PyramidLeadS:   Instrument  0,PyramidLeadS,Pluck,PyramidLead,_
ins_PyramidLeadL:   Instrument  0,PyramidLeadL,Pluck,PyramidLead,BeachLead
ins_PyramidOctArp:  Instrument  0,PyramidArp,Oct2,Square,BeachLead
ins_PyramidArp720:  Instrument  0,PyramidArp,720,PyramidSquare,_
ins_PyramidArp940:  Instrument  0,PyramidArp,940,PyramidSquare,_
ins_PyramidArp520:  Instrument  0,PyramidArp,520,PyramidSquare,_

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

ins_PlainsBass:     Instrument  0,PlainsBass,PlainsBass,PlainsBass,_
ins_PlainsLead:     Instrument  0,PlainsLead,_,PlainsLead,PlainsLead
ins_PlainsEcho:     Instrument  0,PlainsEcho,_,Pulse25,PlainsEcho
ins_PlainsHarmony:  Instrument  0,PlainsHarmony,_,PlainsHarmony,PlainsLead
ins_PlainsHarmonyR: Instrument  0,PlainsHarmonyR,_,Pulse125,PlainsHarmonyR

; =================================================================

PT_Pyramid: dw  Pyramid_CH1,Pyramid_CH2,Pyramid_CH3,Pyramid_CH4

Pyramid_CH1:
    db  SetInstrument,_PyramidBass
    db  F_2,2
    db  F_2,4
    db  F_2,2
    Drum    TomEcho,4
    db  SetInstrument,_PyramidBass
    db  D#2,2
    db  F_2,4
    db  F_2,2
    db  D#2,2
    db  F_2,2
    Drum    TomEcho,6
    db  SetInstrument,_PyramidBass
    db  F_2,2
    db  F#2,2
    db  F#2,4
    db  F#2,2
    Drum    TomEcho,4
    db  SetInstrument,_PyramidBass
    db  F_2,2
    db  F#2,4
    db  F#2,2
    db  F_2,2
    db  F#2,2
    Drum    TomEcho,6
    db  SetInstrument,_PyramidBass
    db  A_2,2
    dbw Goto,Pyramid_CH1
    
Pyramid_CH2:
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
    
Pyramid_CH3:
    db  SetInstrument,_PyramidLead
    dbw CallSection,.block0
    dbw CallSection,.block0

    dbw CallSection,.block1
    db  C#5,18,C#5,2
    db  D#5,3,D#5,1
    db  SetInsAlternate,_PyramidLead,_PyramidLeadS
    db  C#5,2
    db  D#5,2
    db  C#5,2
    db  A#4,2
    dbw CallSection,.block1
    db  SetInsAlternate,_PyramidLead,_PyramidLeadS
    db  F#5,2
    db  G#5,2
    db  F#5,2
    db  G#5,2
    db  SetInstrument,_PyramidLead
    db  F#5,4
    db  G#5,2
    db  SetInstrument,_PyramidLeadF
    db  G#5,2
    db  SetInstrument,_PyramidLead
    db  F#5,8
    db  A#5,6
    db  SetInstrument,_PyramidLeadF
    db  A#5,2
    
    db  SetInstrument,_PyramidLead
    db  C_6,10
    db  SetInstrument,_PyramidLeadF
    db  C_6,2
    db  SetInstrument,_PyramidLead
    db  G#5,4
    db  F_5,6
    db  SetInstrument,_PyramidLeadF
    db  F_5,2
    db  SetInsAlternate,_PyramidLeadS,_PyramidLead
    db  G#5,2
    db  F_5,2
    db  C_5,2
    db  F_5,2
    db  F#5,2
    db  F_5,2
    db  F#5,2
    db  G#5,2
    db  SetInstrument,_PyramidLead
    db  F#5,4
    db  G#5,2
    db  SetInstrument,_PyramidLeadF
    db  G#5,2
    db  SetInsAlternate,_PyramidLead,_PyramidLeadF
    db  F#5,6,F#5,2
    db  D#5,6,D#5,2
    db  SetInstrument,_PyramidLeadL
    db  F_5,32
    db  SetInstrument,_PyramidArp720
    db  F#5,4
    db  F#5,4
    db  F#5,2
    db  F#5,4
    db  F#5,4
    db  F#5,4
    db  F#5,2
    db  SetInstrument,_PyramidArp940
    db  F#5,2
    db  F#5,2
    db  SetInstrument,_PyramidArp720
    db  F#5,2
    db  SetInstrument,_PyramidArp520
    db  F#5,2
    db  SetInstrument,_PyramidLead
    db  CallSection
    dw  .block0
    db  CallSection
    dw  .block0
    db  SetInstrument,_PyramidOctArp
    db  CallSection
    dw  .block0
    db  CallSection
    dw  .block2
    dbw Goto,Pyramid_CH3

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
    db  SetInsAlternate,_PyramidLead,_PyramidLeadF
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
    
Pyramid_CH4:
    Drum    Kick,2
    Drum    CHH,2
    Drum    OHH,2
    Drum    CHH,2
    Drum    Snare,4
    Drum    OHH,2
    Drum    CHH,2
    dbw     Goto,Pyramid_CH4
    
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

; =================================================================

PT_Plains:  dw  Plains_CH1,Plains_CH2,Plains_CH3,Plains_CH4

; ========

Plains_CH1:
    db      SetInstrument,_PlainsEcho
    db      rest,4
.loop
    dbw     CallSection,Plains_CH2.block0
    dbw     CallSection,Plains_CH2.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    db      F_4,2
    db      E_4,2
    db      F_4,2
    db      C_4,4
    db      F_4,2
    db      SetInstrument,_PlainsHarmony
    db      B_4,2
    db      G_4,4
    db      C_5,2
    db      B_4,2
    db      G_4,2
    db      A_4,2
    db      E_4,2    
    db      A_4,4
    db      SetInstrument,_PlainsHarmonyR
    db      A_4,2
    db      SetInstrument,_PlainsHarmony
    db      G_4,4
    db      SetInstrument,_PlainsHarmonyR
    db      G_4,2
    db      SetInstrument,_PlainsHarmony
    db      F_4,4
    db      G_4,4
    db      SetInstrument,_PlainsHarmonyR
    db      G_4,6
    db      SetInstrument,_PlainsEcho
    db      G_3,4
    db      F_4,2
    db      G_4,4

    db      F_4,2
    db      E_4,2
    db      F_4,2
    db      C_4,4
    db      F_4,2
    db      SetInstrument,_PlainsHarmony
    db      B_4,2
    db      G_4,4
    db      C_5,4
    db      B_4,2
    db      A_4,2
    db      G_4,2
    db      A#4,4
    db      SetInstrument,_PlainsHarmonyR
    db      A#4,12
    db      SetInstrument,_PlainsHarmony
    db      A_4,4
    db      SetInstrument,_PlainsHarmonyR
    db      A_4,2
    db      SetInstrument,_PlainsEcho 
    db      A#4,2
    db      A_4,2
    db      F_4,4
    db      D_4,2
    db      C_4,2
    db      D_4,2 
    dbw     Goto,.loop
.block0
    db      SetInstrument,_PlainsEcho
    db      G_4,2
    db      F_4,2
    db      G_4,2
    db      B_4,4
    db      C_5,2
    db      SetInstrument,_PlainsHarmony
    db      G_4,2
    db      D_4,4
    db      B_3,4
    db      D_4,4
    db      G_4,4
    db      SetInstrument,_PlainsEcho
    db      D_4,2
    db      F_4,4
    db      F_4,4
    db      F_4,2
    db      E_4,4
    db      D_4,4
    db      G_3,4
    db      B_3,4
    db      D_4,2
    db      F_4,2
    db      D_4,2
    db      G_4,2
    db      F_4,2
    db      G_4,2
    db      B_4,4
    db      C_5,2
    db      SetInstrument,_PlainsHarmony
    db      G_4,2
    db      D_4,4
    db      B_3,4
    db      D_4,4
    db      G_4,2
    db      A_4,4
    db      A_4,4
    db      A_4,2
    db      A#4,4
    db      B_4,4
    db      SetInstrument,_PlainsHarmonyR
    db      B_4,4
    db      SetInstrument,_PlainsHarmony
    db      C_5,4
    db      B_4,2
    db      G_4,4
    db      SetInstrument,_PlainsEcho
    db      C_4,2
    db      D_4,2
    ret

; ========

Plains_CH2:
    db      SetInstrument,_PlainsLead
.loop
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    db      E_4,4
    db      D_4,4
    db      G_3,4
    db      B_3,4
    db      D_4,2
    db      F_4,2
    db      D_4,2
    dbw     CallSection,.block1
    db      F#4,4
    db      G_4,4
    db      D_4,4
    db      F_4,4
    db      D_4,2
    db      C_4,2
    db      D_4,2
    dbw     CallSection,.block1
    db      E_4,4
    db      D_4,4
    db      G_3,4
    db      B_3,4
    db      D_4,2
    db      F_4,2
    db      D_4,2
    dbw     CallSection,.block1
    db      F#4,4
    db      G_4,4
    db      D_4,4
    db      F_4,4
    db      D_4,2
    db      C_4,2
    db      D_4,2
    dbw     CallSection,.block2
    db      F_4,2
    db      E_4,2
    db      F_4,2
    db      C_4,4
    db      F_4,2
    db      E_4,2
    db      C_4,2
    db      D_4,2
    db      C_4,2
    db      B_3,2
    db      G_3,4
    db      F_4,2
    db      G_4,4
    dbw     CallSection,.block2
    db      D#4,2
    db      D_4,2
    db      D#4,2
    db      A#4,4
    db      A_4,2
    db      G_4,2
    db      A#4,2
    db      C_5,2
    db      A#4,2
    db      A_4,2
    db      F_4,4
    db      D_4,2
    db      C_4,2
    db      D_4,2    
    dbw     Goto,.loop

.block0
    db      G_4,4
    db      G_4,2
    db      D_4,2
    db      F_4,2
    db      D_4,4
    db      C_4,4
    db      D_4,4
    db      F_4,2
    db      G_4,4
    db      B_4,4
    db      C_5,4
    db      B_4,2
    db      G_4,4
    db      D_4,4
    db      F_4,4
    db      D_4,4
    db      C_4,4
    db      D_4,2
    db      F_4,2
    db      D_4,2
    ret
.block1
    db      G_4,2
    db      F_4,2
    db      G_4,2
    db      B_4,4
    db      C_5,2
    db      B_4,2
    db      G_4,2
    db      B_4,2
    db      G_4,4
    db      D_4,4
    db      G_4,4
    db      D_4,2
    db      F_4,4
    db      F_4,4
    db      F_4,2
    ret
.block2
    db      F_4,2
    db      E_4,2
    db      F_4,2
    db      C_4,4
    db      F_4,2
    db      E_4,2
    db      F_4,2
    db      G_4,2
    db      D_4,4
    db      A_4,4
    db      G_4,2
    db      D_4,2
    db      G_4,2
    ret

; ========

Plains_CH3:
    db      SetInstrument,_PlainsBass
.loop
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block1
    dbw     CallSection,.block1
    db      D#2,2
    db      D#3,2
    db      D#2,2
    db      G#2,4
    db      A#2,2
    db      C#3,2
    db      A#2,2
    db      F_2,2
    db      F_3,2
    db      F_2,2
    db      D#3,4
    db      C_3,2
    db      A#2,2
    db      C_3,2
    dbw     Goto,.loop

.block0
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      C_3,4
    db      D_3,2
    db      F_3,2
    db      D_3,2
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      C_3,4
    db      D_3,2
    db      F_3,2
    db      D_3,2
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      C_3,4
    db      D_3,2
    db      F_3,2
    db      D_3,2
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      F_3,4
    db      D_3,2
    db      C_3,2
    db      D_3,2
    ret
.block1
    db      F_2,2
    db      F_3,2
    db      F_2,2
    db      A#2,4
    db      D_3,2
    db      F_3,2
    db      D_3,2
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      F_3,4
    db      D_3,2
    db      C_3,2
    db      D_3,2
    ret
    
; ========

Plains_CH4:
    Drum    Kick,2
    Drum    Kick,2
    Drum    Snare,2
    Drum    Kick,2
    dbw     Goto,Plains_CH4

; =================================================================

PT_PlainsClear: dw  PlainsClear_CH1,PlainsClear_CH2,PlainsClear_CH3,PlainsClear_CH4

PlainsClear_CH1:
    db      SetInstrument,_PlainsEcho
    db      rest,4
    dbw     Goto,PlainsClear_CH2.skipinit

PlainsClear_CH2:
    db      SetInstrument,_PlainsLead
.skipinit
    db      G_4,4
    db      G_4,2
    db      D_4,2
    db      F_4,2
    db      D_4,4
    db      C_4,4
    db      D_4,4
    db      F_4,2
    db      G_4,4
    db      B_4,2
    db      G_4,2
    db      rest,2
    db      EndChannel

PlainsClear_CH3:
    db      SetInstrument,_PlainsBass
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      C_3,4
    db      D_3,2
    db      F_3,2
    db      D_3,2
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      F_3,4
    db      D_3,2
    db      C_3,2
    db      D_3,2
    db      G_3,4
    db      rest,2
    db      EndChannel

PlainsClear_CH4:
    Drum    Kick,2
    Drum    Kick,2
    Drum    Snare,2
    Drum    Kick,2
    Drum    Kick,2
    Drum    Kick,2
    Drum    Snare,2
    Drum    Kick,2
    Drum    Kick,2
    Drum    Kick,2
    Drum    Snare,2
    Drum    Kick,2
    Drum    Kick,2
    Drum    Kick,2
    Drum    Snare,2
    Drum    Kick,2
    Drum    Kick,2
    db      EndChannel