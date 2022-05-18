; ================================================================
; DevSound song data
; ================================================================

; Song constants


    const_def

    const   MUS_MENU
    const   MUS_PLAINS
    const   MUS_CITY
    const   MUS_FOREST
    const   MUS_PYRAMID
    const   MUS_CAVE
    const   MUS_TEMPLE
    const   MUS_STAGE_CLEAR
    const   MUS_BOSS
    const   MUS_GAME_OVER
    const   MUS_BONUS
    const   MUS_GALLERY
    const   MUS_CREDITS

NUM_SONGS   equ const_value
    
; =================================================================
; Song speed table
; =================================================================

SongSpeedTable:
    db  3,4 ; menu
    db  6,6 ; plains
    db  3,3 ; city
    db  8,8 ; forest
    db  5,4 ; pyramid
    db  3,3 ; cave
    db  3,3 ; temple
    db  6,6 ; stage clear
    db  4,4 ; boss battle
    db  4,3 ; game over
    db  3,3 ; bonus stage
    db  5,4 ; gallery
    db  3,3 ; credits

SongPointerTable:
    dw  PT_Menu
    dw  PT_Plains
    dw  PT_City
    dw  PT_Forest
    dw  PT_Pyramid
    dw  PT_Cave
    dw  PT_Temple
    dw  PT_StageClear
    dw  PT_Boss
    dw  PT_GameOver
    dw  PT_Bonus
    dw  PT_Gallery
    dw  PT_Credits

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

vol_Bass1:              db  w3,TableEnd
vol_PulseBass:          db  $2f,TableWait,12,$38,TableWait,11,$44,TableWait,7,$27,TableEnd

vol_Kick:               db  $1c,$1c,$18,TableEnd
vol_Snare:              db  $1d,TableEnd
vol_CHH:                db  $18,TableEnd
vol_OHH:                db  $48,TableEnd
vol_Cymbal:             db  $7e,TableEnd

vol_Echo1:              db  8,TableEnd   
vol_Echo2:              db  3,TableEnd

vol_PyramidArp:         db  w3,TableWait,4,w2,w2,TableWait,3,w1,TableEnd
vol_PyramidLeadS:       db  w3,TableWait,4
vol_PyramidLeadF:       db  w2,TableWait,4
                        db  w1,TableEnd              
vol_PyramidLeadL:       db  w3,TableWait,71,w2,TableWait,35,w1,TableEnd
        
vol_TomEcho:            db  $1f,TableWait,8
                        db  $18,TableWait,8
                        db  $14,TableWait,8
                        db  $12,TableWait,8
                        db  $11,TableWait,8
                        db  TableEnd

; ========

vol_MenuLead:           db  w3,TableWait,6,w2,w1,w2,TableWait,5,w1,TableEnd

vol_MenuOctave:         db  w3,w3,w3,w2,w2,w1,TableEnd
vol_MenuOctaveEcho:     db  w1,TableEnd
vol_MenuBass:           db  $2c,TableWait,7,$38,TableEnd
vol_MenuArp:            db  $1b,TableWait,3,$27,TableWait,9,$53,TableEnd

; ========

vol_PlainsBass:         db  w3,TableWait,6,w2,TableWait,6,w1,TableEnd
vol_PlainsLead:         db  $5a,TableEnd
vol_PlainsEcho:         db  2,TableEnd
vol_PlainsHarmony:      db  $59,TableEnd
vol_PlainsHarmonyR:     db  4,TableEnd

; ========

vol_CityArp:            db  $1b,TableWait,3,$48,TableEnd
vol_CityLead:           db  w3,TableWait,9,w2,TableWait,4,w1,TableEnd
vol_CityLead2:          db  w3,TableWait,12,w2,TableWait,5,w1,TableEnd
vol_CityLeadL:          db  w3,TableWait,8,w2,TableWait,22,w1,TableEnd

; ========

vol_GameOverLead:       db  w3,TableWait,16,w2,TableWait,16,w1,TableEnd
vol_GameOverGuitarA:    db  $7a,TableEnd
vol_GameOverGuitarB:    db  $4a,TableEnd

; ========

vol_BossIntro1a:        db  $3a,TableEnd
vol_BossKick:           ; fall through to next sequence
vol_BossOHH:            ; fall through to next sequence
vol_BossIntro1b:        db  $1a,TableEnd
vol_BossIntro2a:        db  $46,TableEnd
vol_BossIntro2b:        db  $16,TableEnd
vol_BossLead:           db  $5a,TableEnd
vol_BossTomKick:        db  w3,TableWait,3,w2,w1,w0,TableEnd
vol_BossTomSnare:       db  w3,TableWait,7,w2,TableWait,7,w1,TableWait,7,w0,TableEnd
vol_BossCHH:            db  $1a,TableWait,3,0,TableEnd
vol_BossOHHRoll:        db  $1a,$1a,$1a,0,$1a,$1a,$1a,0,$1a,$1a,$1a,0,TableEnd

; ========

vol_ForestPluck         equ vol_GameOverGuitarB
vol_ForestLead:
    db      $2c,TableWait,7
    db        5,TableWait,15
    db        6,TableWait,15
    db        7,TableWait,15
    db        8,TableWait,15
    db        9,TableWait,15
    db       10,TableWait,23
    db        9,TableWait,23
    db        8,TableWait,23
    db        7,TableWait,23
    db        6,TableWait,23
    db        5,TableWait,23
    db        4,TableWait,23
    db        3,TableWait,23
    db        2,TableWait,47
    db        1,TableWait,55
    db        0,TableEnd
vol_ForestArp:
    db        6,TableWait,11
    db        7,TableWait,11
    db        8,TableWait,11
    db        9,TableWait,11
    db       10,TableWait,11
    db        9,TableWait,15
    db        8,TableWait,23
    db        7,TableWait,31
    db        6,TableWait,39
    db        5,TableWait,47
    db        4,TableWait,55
    db        3,TableWait,63
    db        2,TableWait,71
    db        1,TableWait,79
    db        0,TableEnd
vol_ForestEcho1:    db  $3a,TableEnd
vol_ForestEcho2:    db  $44,TableEnd
vol_ForestBass:     db  w3,TableWait,15,w2,w1,TableEnd
vol_ForestBassSustain   equ vol_Bass1
vol_ForestBassDecay:
    db       w2,TableWait,56
    db       w1,TableWait,56
    db       w0,TableEnd
vol_ForestPercussion1:
    db      $1e,TableWait,15
    db      $15,TableWait,15
    db      $1b,TableWait,15
    db      $14,TableWait,15
    db      $18,TableWait,15
    db      $13,TableWait,15
    db      TableEnd
vol_ForestPercussion2:
    db      $2e,TableWait,31
vol_ForestPercussion3:
    db      $47,TableWait,31
    db      $73,TableWait,31
    db      $71,TableWait,31
    db      TableEnd
vol_ForestPercussionV8: db  $8,TableWait,7,2,TableEnd
vol_ForestPercussionV9: db  $9,TableWait,7,2,TableEnd
vol_ForestPercussionVA: db  $a,TableWait,7,3,TableEnd
vol_ForestPercussionVB: db  $b,TableWait,7,3,TableEnd
vol_ForestPercussionVC: db  $c,TableWait,7,3,TableEnd
vol_ForestPercussionVD: db  $d,TableWait,7,4,TableEnd
vol_ForestPercussionVE: db  $e,TableWait,7,4,TableEnd

; ========

vol_GalleryEcho1:       db  $31,TableEnd
vol_GalleryEcho2:       db  $32,TableEnd
vol_GalleryEcho3:       db  $33,TableEnd
vol_GalleryEcho4:       db  $34,TableEnd
vol_GalleryEcho5:       db  $35,TableEnd
vol_GalleryEcho6:       db  $36,TableEnd
vol_GalleryEcho7:       db  $37,TableEnd
vol_GalleryEcho8:       db  $38,TableEnd
vol_GalleryEcho9:       db  $39,TableEnd
vol_GalleryEchoA:       db  $3a,TableEnd

vol_GalleryLead:        db  $3a,TableWait,17,$74,TableEnd

; =================================================================
; Arpeggio sequences
; =================================================================

arp_PluckDelay:         db  0 ; fall through to next sequence
arp_Pluck:              db  12,0,TableEnd
arp_TomEcho:            db  22,20,18,16,14,12,10,9,7,TableLoop,0
arp_Oct2:               db  12,12,0,0,TableLoop,0

arp_940:                db  9,9,4,4,0,0,TableLoop,0
arp_720:                db  7,7,2,2,0,0,TableLoop,0
arp_520:                db  5,5,2,2,0,0,TableLoop,0

arp_MenuTom:            db  12,11,10,9,8,7,6,5,4,3,2,1,0,TableLoop,12

arp_MenuArp027:         db  0,0,2,2,7,7,TableLoop     ; last byte reads from next table
arp_MenuArp037:         db  0,0,3,3,7,7,TableLoop     ; last byte reads from next table
arp_MenuArp047:         db  0,0,4,4,7,7,TableLoop     ; last byte reads from next table
arp_MenuArp057:         db  0,0,5,5,7,7,TableLoop     ; last byte reads from next table
arp_MenuArp038:         db  0,0,3,3,8,8,TableLoop     ; last byte reads from next table
arp_MenuArp059:         db  0,0,5,5,9,9,TableLoop     ; last byte reads from next table
arp_MenuArp05A:         db  0,0,5,5,10,10,TableLoop,0

arp_PlainsBass:         db  12,12,0,TableEnd

arp_BassOctave:         db  12,0,TableWait,9,12,TableEnd

arp_BossTomKick:        db  24,21,18,15,12,09,06,03,00,TableEnd
arp_BossTomSnare:       db  36,34,32,30,28,26,24,22,20,TableLoop,0
arp_BossBass:           db  0,TableLoop,0

arp_ForestPluck:        db  1,0,TableEnd

; =================================================================
; Noise sequences
; =================================================================

; Noise values are the same as Deflemask, but with one exception:
; To convert 7-step noise values (noise mode 1 in deflemask) to a
; format usable by DevSound, take the corresponding value in the
; arpeggio macro and add s7.
; Example: db s7+32 = noise value 32 with step lengh 7
; Note that each arpseq must be terminated with a loop command
; (TableLoop) otherwise the noise value will reset!

s7 = $2d

arp_Kick:               db  s7+18,s7+18,43,TableLoop,2
arp_Snare:              db  s7+29,s7+23,s7+20,35,TableLoop,3
arp_BossCHH:            ; fall through to next sequence
arp_Hat:                db  43,TableLoop,0
arp_Cymbal:             db  35,40,43,TableLoop,2

arp_BossKick:           db  40,23,17,28,20,12,TableLoop,5
arp_BossOHH:            db  42,TableLoop,0

arp_ForestPercussion1   equ arp_BossOHH
arp_ForestPercussion2:  db  40,TableLoop,0

; =================================================================
; Pulse sequences
; =================================================================

waveseq_PlainsHarmonyR:
waveseq_Dummy:
waveseq_Pulse125:       db  0,TableEnd
waveseq_Pulse25:        db  1,TableEnd
waveseq_Pulse50:
waveseq_Square:         db  2,TableEnd
waveseq_Pulse75:        db  3,TableEnd

waveseq_PyramidBass:    db  0,TableWait,3,1,TableWait,3,2,TableWait,3,3,TableWait,3,TableLoop,0

waveseq_MenuArp         equ waveseq_Pulse25

waveseq_PlainsLead:     db  0,0,0,0,1,TableEnd
waveseq_PlainsHarmony:  db  2,2,0,TableEnd

waveseq_CityArp:
    db  0,0,0,1,1,1,2,2,2,3,3,3,2,2,2,1,1,1,TableLoop,0

waveseq_GameOverGuitarA:
    db  1,0,TableEnd
    
waveseq_ForestArp:
    db  0,0,0,0,0,0,0,0
    db  1,1,1,1,1,1,1,1
    db  2,2,2,2,2,2,2,2
    db  3,3,3,3,3,3,3,3
    db  2,2,2,2,2,2,2,2
    db  1,1,1,1,1,1,1,1
    db  TableLoop,0

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:          db  $ff,0,TableLoopVib,1
vib_BeachLead:      db  8,1,1,2,2,1,1,0,0,-1,-1,-2,-2,-1,-1,0,0,TableLoopVib,1
vib_PWMLead:        db  24,2,3,3,2,0,0,-2,-3,-3,-2,0,0,TableLoopVib,1

vib_PlainsLead:     db  18,2,4,6,4,2,0,-2,-4,-6,-4,-2,0,TableLoopVib,1
vib_PlainsEcho:     db  0,-2,TableLoopVib,1
vib_PlainsHarmonyR: db  0,2,4,6,4,2,0,-2,-4,-6,-4,-2,0,TableLoopVib,1
vib_CityLead:       db  9,1,2,2,1,0,-1,-2,-2,-1,0,TableLoopVib,1
vib_ForestPluck:    db  6,3,7,10,7,3,0,-3,-7,-10,-7,-3,0,TableLoopVib,1

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
    dw      wave_PlainsBass
    dw      wave_CityLead
    dw      wave_SoftSquare
    dw      wave_BossTom
    dw      wave_BossBass
    dw      wave_GalleryBass

wave_PyramidLead:       db  $01,$23,$45,$67,$89,$ab,$cd,$ef,$ed,$b9,$75,$31,$02,$46,$8a,$ce
wave_PyramidSquare:     db  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$00,$00,$44,$44,$00,$00,$00
wave_MenuLead1:         db  $cb,$ab,$11,$22,$22,$22,$22,$22,$22,$23,$33,$45,$44,$44,$32,$56
wave_MenuLead2:         db  $9a,$cc,$cc,$cc,$cc,$c0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$13
wave_MenuTri:           db  $68,$8c,$ef,$fd,$b9,$75,$32,$02,$68,$8c,$ef,$fd,$b9,$75,$32,$02
wave_ForestBass:        db  $54,$44,$44,$43,$20,$07,$a9,$9a,$ac,$ee,$aa,$96,$54,$44,$44,$45 
wave_PlainsBass:        db  $ff,$ff,$ff,$ff,$ee,$d7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
wave_CityLead:          db  $bb,$cc,$cd,$dd,$dd,$ba,$29,$54,$56,$76,$55,$43,$24,$14,$11,$00
wave_SoftSquare:        db  $ab,$cc,$cc,$cc,$cc,$cc,$cc,$cc,$00,$00,$00,$00,$00,$00,$00,$12
wave_BossTom:           db  $ac,$cc,$cc,$cc,$cc,$cc,$cc,$ca,$20,$00,$00,$00,$00,$00,$00,$02
wave_BossBass:          db  $66,$60,$6c,$cc,$66,$60,$66,$60,$00,$06,$06,$66,$60,$00,$60,$00
wave_GalleryBass:       db  $00,$11,$23,$45,$66,$78,$89,$aa,$bb,$cc,$cc,$cc,$a9,$89,$bc,$cc

waveseq_Tri:            db  0,TableEnd
waveseq_PyramidLead:    db  1,TableEnd
waveseq_PyramidSquare:  db  2,TableEnd
waveseq_MenuLead:       db  3,4,TableEnd
waveseq_MenuTri:        db  5,TableEnd
waveseq_PlainsBass:     db  7,TableEnd
waveseq_CityLead:       db  8,TableEnd
waveseq_ForestBass:     db  6,TableEnd
waveseq_WaveBuffer:     db  $fd,TableEnd
waveseq_SoftSquare:     db  9,TableEnd
waveseq_BossTom:        db  10,TableEnd
waveseq_BossBass:       db  11,TableEnd
waveseq_GalleryBass:    db  12,TableEnd

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
    
    dins    BassOctave
    dins    CityArp
    dins    CityLead
    dins    CityLead2
    dins    CityLeadL

    dins    GameOverLead
    dins    GameOverGuitarA
    dins    GameOverGuitarB
    
    dins    BossIntro1a
    dins    BossIntro1b
    dins    BossIntro2a
    dins    BossIntro2b
    dins    BossIntro3a
    dins    BossIntro3b
    dins    BossLead
    dins    BossTomKick
    dins    BossTomSnare
    dins    BossBass
    dins    BossKick
    dins    BossCHH
    dins    BossOHH
    dins    BossOHHRoll
    
    dins    ForestPluck0
    dins    ForestPluck1
    dins    ForestPluck2
    dins    ForestPluck3
    dins    ForestLead
    dins    ForestArp
    dins    ForestEcho1
    dins    ForestEcho2
    dins    ForestBass
    dins    ForestBassSustain
    dins    ForestBassDecay
    dins    ForestPercussion1
    dins    ForestPercussion2
    dins    ForestPercussion3
    dins    ForestPercussionV8
    dins    ForestPercussionV9
    dins    ForestPercussionVA
    dins    ForestPercussionVB
    dins    ForestPercussionVC
    dins    ForestPercussionVD
    dins    ForestPercussionVE
    
    dins    GalleryEcho1
    dins    GalleryEcho2
    dins    GalleryEcho3
    dins    GalleryEcho4
    dins    GalleryEcho5
    dins    GalleryEcho6
    dins    GalleryEcho7
    dins    GalleryEcho8
    dins    GalleryEcho9
    dins    GalleryEchoA
    dins    GalleryBack
    dins    GalleryLead
    dins    GalleryBass

; Instrument format: [no reset flag],[wave mode (ch3 only)],[voltable id],[arptable id],[pulsetable/wavetable id],[vibtable id]
; !!! REMEMBER TO ADD INSTRUMENTS TO THE INSTRUMENT POINTER TABLE !!!
ins_Kick:               Instrument  0,Kick,Kick,_,_ ; pulse/waveseq and vibrato unused by noise instruments
ins_Snare:              Instrument  0,Snare,Snare,_,_
ins_CHH:                Instrument  0,CHH,Hat,_,_
ins_OHH:                Instrument  0,OHH,Hat,_,_
ins_Cymbal:             Instrument  0,Cymbal,Cymbal,_,_

ins_Echo1:              Instrument  0,Echo1,_,_,_
ins_Echo2:              Instrument  0,Echo2,_,_,_
ins_TomEcho:            Instrument  0,TomEcho,TomEcho,Square,_
ins_PyramidBass:        Instrument  0,PulseBass,Pluck,PyramidBass,_
ins_PyramidLead:        Instrument  0,Bass1,Pluck,PyramidLead,BeachLead
ins_PyramidLeadF:       Instrument  0,PyramidLeadF,_,PyramidLead,_
ins_PyramidLeadS:       Instrument  0,PyramidLeadS,Pluck,PyramidLead,_
ins_PyramidLeadL:       Instrument  0,PyramidLeadL,Pluck,PyramidLead,BeachLead
ins_PyramidOctArp:      Instrument  0,PyramidArp,Oct2,Square,BeachLead
ins_PyramidArp720:      Instrument  0,PyramidArp,720,PyramidSquare,_
ins_PyramidArp940:      Instrument  0,PyramidArp,940,PyramidSquare,_
ins_PyramidArp520:      Instrument  0,PyramidArp,520,PyramidSquare,_

ins_MenuLead:           Instrument  0,MenuLead,Pluck,MenuLead,BeachLead
ins_MenuOctave:         Instrument  0,MenuOctave,Oct2,MenuTri,_
ins_MenuOctaveEcho:     Instrument  0,MenuOctaveEcho,Oct2,MenuTri,_
ins_MenuBass:           Instrument  0,MenuBass,Pluck,Pulse25,_
ins_MenuArp027:         Instrument  0,MenuArp,MenuArp027,CityArp,_
ins_MenuArp037:         Instrument  0,MenuArp,MenuArp037,CityArp,_
ins_MenuArp047:         Instrument  0,MenuArp,MenuArp047,CityArp,_
ins_MenuArp057:         Instrument  0,MenuArp,MenuArp057,CityArp,_
ins_MenuArp038:         Instrument  0,MenuArp,MenuArp038,CityArp,_
ins_MenuArp059:         Instrument  0,MenuArp,MenuArp059,CityArp,_
ins_MenuArp05A:         Instrument  0,MenuArp,MenuArp05A,CityArp,_
ins_MenuTom:            Instrument  0,MenuArp,MenuTom,Pulse50,_

ins_PlainsBass:         Instrument  0,PlainsBass,PlainsBass,PlainsBass,_
ins_PlainsLead:         Instrument  0,PlainsLead,_,PlainsLead,PlainsLead
ins_PlainsEcho:         Instrument  0,PlainsEcho,_,Pulse25,PlainsEcho
ins_PlainsHarmony:      Instrument  0,PlainsHarmony,_,PlainsHarmony,PlainsLead
ins_PlainsHarmonyR:     Instrument  0,PlainsHarmonyR,_,Pulse125,PlainsHarmonyR

ins_BassOctave:         Instrument  0,MenuBass,BassOctave,Pulse25,_
ins_CityArp:            Instrument  0,CityArp,Buffer,CityArp,_
ins_CityLead:           Instrument  0,CityLead,PluckDelay,CityLead,CityLead
ins_CityLead2:          Instrument  0,CityLead2,PluckDelay,CityLead,CityLead
ins_CityLeadL:          Instrument  0,CityLeadL,_,CityLead,CityLead

ins_GameOverLead:       Instrument  0,GameOverLead,PluckDelay,SoftSquare,CityLead
ins_GameOverGuitarA:    Instrument  0,GameOverGuitarA,_,GameOverGuitarA,_
ins_GameOverGuitarB:    Instrument  0,GameOverGuitarB,PluckDelay,Pulse25,_

ins_BossIntro1a:        Instrument  0,BossIntro1a,Pluck,Pulse125,_
ins_BossIntro1b:        Instrument  0,BossIntro1b,Pluck,Pulse125,_
ins_BossIntro2a:        Instrument  0,BossIntro2a,Pluck,Pulse25,_
ins_BossIntro2b:        Instrument  0,BossIntro2b,Pluck,Pulse25,_
ins_BossIntro3a:        Instrument  0,BossIntro1a,Pluck,Pulse125,PlainsEcho
ins_BossIntro3b:        Instrument  0,BossIntro1b,Pluck,Pulse125,PlainsEcho
ins_BossLead:           Instrument  0,BossLead,_,Pulse125,PlainsLead
ins_BossTomKick:        Instrument  0,BossTomKick,BossTomKick,BossTom,_
ins_BossTomSnare:       Instrument  0,BossTomSnare,BossTomSnare,BossTom,_
ins_BossBass:           Instrument  0,Bass1,BossBass,BossBass,_
ins_BossKick:           Instrument  0,BossKick,BossKick,_,_
ins_BossCHH:            Instrument  0,BossCHH,BossCHH,_,_
ins_BossOHH:            Instrument  0,BossOHH,BossOHH,_,_
ins_BossOHHRoll:        Instrument  0,BossOHHRoll,BossOHH,_,_

ins_ForestPluck0:       Instrument  0,ForestPluck,ForestPluck,Pulse125,ForestPluck
ins_ForestPluck1:       Instrument  0,ForestPluck,ForestPluck,Pulse25,ForestPluck
ins_ForestPluck2:       Instrument  0,ForestPluck,ForestPluck,Pulse50,ForestPluck
ins_ForestPluck3:       Instrument  0,ForestPluck,ForestPluck,Pulse75,ForestPluck
ins_ForestLead:         Instrument  0,ForestLead,_,Pulse50,CityLead
ins_ForestArp:          Instrument  0,ForestArp,Buffer,ForestArp,_
ins_ForestEcho1:        Instrument  0,ForestEcho1,_,Pulse50,_
ins_ForestEcho2:        Instrument  0,ForestEcho2,_,Pulse50,_
ins_ForestBass:         Instrument  0,ForestBass,_,ForestBass,_
ins_ForestBassSustain:  Instrument  0,ForestBassSustain,_,ForestBass,_
ins_ForestBassDecay:    Instrument  0,ForestBassDecay,_,ForestBass,_
ins_ForestPercussion1:  Instrument  0,ForestPercussion1,ForestPercussion1,_,_
ins_ForestPercussion2:  Instrument  0,ForestPercussion2,ForestPercussion2,_,_
ins_ForestPercussion3:  Instrument  0,ForestPercussion3,ForestPercussion2,_,_
ins_ForestPercussionV8: Instrument  0,ForestPercussionV8,ForestPercussion1,_,_
ins_ForestPercussionV9: Instrument  0,ForestPercussionV9,ForestPercussion1,_,_
ins_ForestPercussionVA: Instrument  0,ForestPercussionVA,ForestPercussion1,_,_
ins_ForestPercussionVB: Instrument  0,ForestPercussionVB,ForestPercussion1,_,_
ins_ForestPercussionVC: Instrument  0,ForestPercussionVC,ForestPercussion1,_,_
ins_ForestPercussionVD: Instrument  0,ForestPercussionVD,ForestPercussion1,_,_
ins_ForestPercussionVE: Instrument  0,ForestPercussionVE,ForestPercussion1,_,_

ins_GalleryEcho1:       Instrument  0,GalleryEcho1,_,Pulse125,_
ins_GalleryEcho2:       Instrument  0,GalleryEcho2,_,Pulse125,_
ins_GalleryEcho3:       Instrument  0,GalleryEcho3,_,Pulse125,_
ins_GalleryEcho4:       Instrument  0,GalleryEcho4,_,Pulse125,_
ins_GalleryEcho5:       Instrument  0,GalleryEcho5,_,Pulse125,_
ins_GalleryEcho6:       Instrument  0,GalleryEcho6,_,Pulse125,_
ins_GalleryEcho7:       Instrument  0,GalleryEcho7,_,Pulse125,_
ins_GalleryEcho8:       Instrument  0,GalleryEcho8,_,Pulse125,_
ins_GalleryEcho9:       Instrument  0,GalleryEcho9,_,Pulse125,_
ins_GalleryEchoA:       Instrument  0,GalleryEchoA,_,Pulse125,_
ins_GalleryBack:        Instrument  0,GalleryLead,Pluck,Pulse125,ForestPluck
ins_GalleryLead:        Instrument  0,GalleryLead,PluckDelay,Pulse50,CityLead
ins_GalleryBass:        Instrument  0,Bass1,PlainsBass,GalleryBass,ForestPluck

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
    db      LoopCount,2
:   dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     Loop,:-
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
    db      LoopCount,2
:   dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block2
    dbw     Loop,:-
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
    db      LoopCount,2
:   dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     Loop,:-
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
    db      LoopCount,2
:   db      C_5,2,E_5,2,G_5,2,C_6,2
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
    dbw     Loop,:-
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
    
; ========
    
Menu_CH4:
    db      LoopCount,4
:   dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block2
    dbw     Loop,:-
    db      LoopCount,4
:   dbw     CallSection,.block0
    dbw     Loop,:-
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
    db      LoopCount,6
:   dbw     CallSection,.block0
    dbw     Loop,:-
    db      LoopCount,3
:   dbw     CallSection,.block1
    dbw     Loop,:-
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

PT_StageClear: dw  StageClear_CH1,StageClear_CH2,StageClear_CH3,StageClear_CH4

StageClear_CH1:
    db      SetInstrument,_PlainsEcho
    db      rest,4
    dbw     Goto,StageClear_CH2.skipinit

StageClear_CH2:
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

StageClear_CH3:
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

StageClear_CH4:
    db      LoopCount,4
:   Drum    Kick,2
    Drum    Kick,2
    Drum    Snare,2
    Drum    Kick,2
    dbw     Loop,:-
    Drum    Kick,2
    db      EndChannel
    
; =================================================================

PT_City:    dw  City_CH1,City_CH2,City_CH3,City_CH4

City_CH1:
    db      rest,198
    db      SetInstrument,_MenuArp047
    db      LoopCount,2
:   db      C_5,12
    db      C_5,12
    db      A#4,12
    db      A#4,12
    db      C_5,12
    db      C_5,12
    db      C_5,12
    db      C_5,12
    dbw     Loop,:-
.loop
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    db      SetInstrument,_CityArp

    db      LoopCount,3
:   dbw     CallSection,.block1
    db      Arp,2,$38
    db      C_5,10
    db      C_5,8
    db      D_5,10
    db      D_5,8
    db      D_5,12
    dbw     CallSection,.block1
    db      Arp,2,$47
    db      G#4,10
    db      G#4,8
    db      A#4,10
    db      A#4,8
    db      A#4,12
    dbw     Loop,:-
    
    db      SetInstrument,_MenuArp047
    dbw     Goto,.loop

.block0
    db      LoopCount,2
:   db      C_5,12
    db      C_5,12
    db      A#4,12
    db      A#4,12
    db      C_5,12
    db      C_5,12
    db      C_5,12
    db      C_5,12
    dbw     Loop,:-
    db      LoopCount,2
:   db      D_5,12
    db      D_5,12
    db      C_5,12
    db      C_5,12
    db      D_5,12
    db      D_5,12
    db      D_5,12
    db      D_5,12
    dbw     Loop,:-
    db      LoopCount,2
:   db      C_5,12
    db      C_5,12
    db      A#4,12
    db      A#4,12
    db      C_5,12
    db      C_5,12
    db      C_5,12
    db      C_5,12
    dbw     Loop,:-
    ret
.block1
    db      Arp,2,$37
    db      C_5,10
    db      C_5,8
    db      C_5,10
    db      C_5,8
    db      C_5,12
    db      Arp,2,$59
    db      A#4,10
    db      A#4,8
    db      A#4,10
    db      A#4,8
    db      A#4,12
    db      Arp,2,$38
    db      A_4,10
    db      A_4,8
    db      A_4,10
    db      A_4,8
    db      A_4,12
    ret

; ================

City_CH2:
    dbw     CallSection,.block0
    db      C_2,6
    db      C_2,6
    db      C_3,6
    db      C_2,4
    db      A#2,8
    db      A_2,4
    db      A#2,2
    db      A_2,4
    db      F_2,2
    db      G_2,6
    db      C_2,6
    db      C_2,6
    db      C_3,6
    db      C_2,4
    db      A#2,8
    db      F_2,6
    db      SetInstrument,_BassOctave
    db      A#2,6
    db      B_2,6    
    dbw     CallSection,.block0
    dbw     CallSection,.block0
.loop
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    dbw     CallSection,.block0
    db      C_2,6
    db      C_2,6
    db      C_3,6
    db      C_2,4
    db      A#2,8
    db      A_2,4
    db      A#2,2
    db      A_2,4
    db      F_2,2
    db      G_2,6
    db      C_2,6
    db      C_2,6
    db      C_3,6
    db      C_2,4
    db      A#2,6
    db      C_2,2
    db      C_3,18
    
    db      LoopCount,3
:   dbw     CallSection,.block2
    db      D#2,4
    db      F_2,2
    db      G#2,6
    db      G#3,4
    db      G#2,2
    db      G_3,4
    db      G#3,2
    db      G#2,4
    db      A#2,6
    db      A#2,2
    db      F_2,4
    db      D#2,2
    db      F_2,4
    db      D#2,2
    db      C_2,4
    db      D_2,2
    dbw     CallSection,.block2
    db      F_2,4
    db      C_2,2
    db      D#2,6
    db      D#3,4
    db      D#2,2
    db      D_3,4
    db      D#3,2
    db      D#2,4
    db      D_2,6
    db      D_2,2
    db      D_3,4
    db      D_2,2
    db      C_3,4
    db      D_3,2
    db      A#2,4
    db      G_2,2
    dbw     Loop,:-
    dbw     Goto,.loop

.block0
    db      SetInstrument,_MenuBass
    db      C_2,6
    db      C_2,6
    db      C_3,6
    db      C_2,4
    db      A#2,8
    db      A_2,4
    db      A#2,2
    db      A_2,4
    db      F_2,2
    db      G_2,6
    db      C_2,6
    db      C_2,6
    db      C_3,6
    db      C_2,4
    db      A#2,8
    db      F_3,4
    db      F_2,2
    db      E_3,4
    db      C_2,2
    db      A#2,6
    ret
.block1
    db      LoopCount,2
:   db      D_2,6
    db      D_2,6
    db      D_3,6
    db      D_2,4
    db      C_3,8
    db      B_2,4
    db      C_3,2
    db      B_2,4
    db      G_2,2
    db      A_2,6
    db      D_2,6
    db      D_2,6
    db      D_3,6
    db      D_2,4
    db      C_3,8
    db      D_3,4
    db      D_2,2
    db      G_3,4
    db      D_2,2
    db      F#3,6
    dbw     Loop,:-
    ret
.block2
    db      C_2,6
    db      C_3,4
    db      C_2,2
    db      A#2,4
    db      C_3,2
    db      C_2,4
    db      C_2,6
    db      C_2,2
    db      C_3,4
    db      C_2,2
    db      A#2,4
    db      C_3,2
    db      C_2,4
    db      D_2,2
    db      D#2,6
    db      D#3,4
    db      D#2,2
    db      D_3,4
    db      D#3,2
    db      D_2,4
    db      D#2,6
    db      D#2,2
    db      D#3,4
    db      D#2,2
    db      D_3,4
    db      D#3,2
    db      D#2,4
    db      E_2,2
    
    db      F_2,6
    db      F_3,4
    db      F_2,2
    db      D#3,4
    db      F_3,2
    db      D#2,4
    db      F_2,6
    db      F_2,2
    db      F_3,4
    db      F_2,2
    db      D#3,4
    db      F_3,2
    ret

; ================

City_CH3:
    db      rest,192
    db      rest,192
.loop
    db      SetInstrument,_CityLead
    db      LoopCount,2
:   dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block1
    db      C_6,14
    db      C_5,6
    db      C#5,6
    dbw     CallSection,.block1
    db      C_6,18
    db      D_5,2
    db      F#5,4
    db      D_5,2
    db      C_5,9
    db      rest,183
    dbw     Loop,:-
    db      rest,192
    db      rest,192
 
    db      LoopCount,2
:   dbw     CallSection,.block2
    db      D#6,6
    db      A#5,12
    db      G_5,12
    db      G_5,6
    db      A#5,6
    db      G_5,6
    db      F_5,6
    db      D#5,6
    db      C_5,6
    db      A#4,1
    db      SetInstrument,_CityLeadL
    db      B_4,1
    db      C_5,28
    db      rest,48
    dbw     CallSection,.block2
    db      F_6,1
    db      SetInstrument,_CityLeadL
    db      F#6,1
    db      G_6,4
    db      SetInstrument,_CityLead2
    db      F_6,6
    db      D#6,6
    db      A#5,12
    db      A#5,6
    db      C_6,6
    db      D#6,6
    db      A#5,1
    db      SetInstrument,_CityLeadL
    db      B_5,1
    db      C_6,40
    db      SetInstrument,_CityLead2
    db      D_6,6
    db      D#6,6
    db      D_6,6
    db      C_6,6
    db      A#5,12
    db      G_5,6
    db      F_5,6
    db      G_5,6
    dbw     Loop,:-
    dbw     Goto,.loop
    
.block0
    db      C_6,6
    db      C_6,4
    db      G_5,2
    db      A#5,4
    db      G_5,6
    db      F_5,6
    db      G_5,14
    db      A#4,6
    db      A#4,4
    db      C_5,6
    db      C_5,8
    db      rest,30
    ret
.block1
    db      D_6,6
    db      D_6,4
    db      A_5,2
    db      C_6,4
    db      A_5,6
    db      G_5,6
    db      A_5,6
    db      C_6,2
    db      D_6,6
    db      F#6,6
    db      G_6,6
    db      F#6,4
    db      D_6,6
    db      A_5,6
    ret
.block2
    db      SetInstrument,_CityLead2
    db      C_6,6
    db      A#5,6
    db      C_6,6
    db      D#6,12
    db      F_6,6
    db      D#6,6
    db      C_6,6
    ret

; ================

City_CH4:
    db      LoopCount,15
:   Drum    Kick,4
    Drum    CHH,2
    Drum    OHH,4
    Drum    CHH,2
    dbw     Loop,:-
    dbw     CallSection,.block0
    db      LoopCount,4
:   dbw     CallSection,.block1
    dbw     Loop,:-
.loop
    db      LoopCount,23
:   dbw     CallSection,.block1
    dbw     Loop,:-
    Drum    Kick,4
    Drum    CHH,2
    Drum    Kick,4
    Drum    CHH,2
    Drum    Cymbal,24
    dbw     CallSection,.block0
    db      LoopCount,24
:   dbw     CallSection,.block1
    dbw     Loop,:-
    dbw     Goto,.loop

.block0
    Drum    Snare,4
    Drum    CHH,2
    Drum    Snare,4
    Drum    Snare,2
    ret    
.block1
    Drum    Kick,4
    Drum    CHH,2
    Drum    Kick,4
    Drum    CHH,2
    Drum    Snare,4
    Drum    CHH,2
    Drum    OHH,4
    Drum    Kick,2
    Drum    CHH,4
    Drum    Kick,2
    Drum    Kick,4
    Drum    CHH,2
    Drum    Snare,4
    Drum    CHH,2
    Drum    OHH,4
    Drum    CHH,2
    ret

; =================================================================

PT_GameOver:    dw  GameOver_CH1,GameOver_CH2,GameOver_CH3,GameOver_CH4

GameOver_CH1:
    db      SetInstrument,_GameOverGuitarA
    db      B_3,2
    db      F#4,30
    db      A_3,2
    db      E_4,22
    db      SetInstrument,_GameOverGuitarB
    db      A_2,8
    
    db      G_2,4
    db      G_2,4
    db      G_2,4
    db      A_2,8
    db      A_2,4
    db      A_2,4
    db      A_2,8
    db      B_2,4
    db      B_2,16
    db      EndChannel

GameOver_CH2:
    db      SetInstrument,_GameOverGuitarA
    db      rest,1
    db      D_4,2
    db      B_4,30
    db      C#4,2
    db      A_4,21
    db      SetInstrument,_GameOverGuitarB
    db      C#3,8

    db      D_3,4
    db      D_3,4
    db      D_3,4
    db      C#3,8
    db      C#3,4
    db      C#3,4
    db      C#3,8
    db      D_3,4
    db      D_3,16
    db      EndChannel

GameOver_CH3:
    db      SetInstrument,_GameOverLead
    db      B_5,8
    db      B_5,4
    db      F#5,4
    db      A_5,4
    db      F#5,8
    db      E_5,8
    db      F#5,16
    db      F#5,4
    db      A_5,4
    db      C#6,4
    db      D_6,8
    db      D_6,4
    db      C#6,8
    db      B_5,4
    db      A_5,4
    db      A_5,8
    db      B_5,4
    db      B_5,16
    db      rest,1
    db      EndChannel

GameOver_CH4:
    Drum    Cymbal,32
    Drum    Cymbal,20
    Drum    Snare,4
    Drum    Snare,4
    Drum    Snare,4
    Drum    Cymbal,8
    Drum    Snare,4
    Drum    Kick,4
    Drum    CHH,4
    Drum    Kick,4
    Drum    Snare,4
    Drum    Kick,4
    Drum    CHH,4
    Drum    Snare,4
    Drum    Cymbal,24
    db      EndChannel
    
    
; =================================================================

PT_Boss:    dw  Boss_CH1,Boss_CH2,Boss_CH3,Boss_CH4

; ========

Boss_CH1:
    db      SetInstrument,_BossIntro1a
    db      C_2,4
    db      SetInstrument,_BossIntro1b
    dbw     CallSection,Boss_Shared1
    db      SetInstrument,_BossIntro1a
    db      C_3,6
    db      SetInstrument,_BossIntro1b
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossIntro1a
    db      A#2,4
    db      SetInstrument,_BossIntro1b
    dbw     CallSection,Boss_Shared2
    db      SetInstrument,_BossIntro1a
    db      A#3,6
    db      SetInstrument,_BossIntro1b
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossIntro1a
    db      F_2,4
    db      SetInstrument,_BossIntro1b
    dbw     CallSection,Boss_Shared3
    db      SetInstrument,_BossIntro1a
    db      F_3,6
    db      SetInstrument,_BossIntro1b
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossIntro1a
    db      G_2,4
    db      SetInstrument,_BossIntro1b
    dbw     CallSection,Boss_Shared4
    db      SetInstrument,_BossIntro1a
    db      G_3,6
    db      SetInstrument,_BossIntro1b
    db      F_3,2
    db      G_3,2
    dbw     Goto,Boss_CH1
    
; ========

Boss_CH2:
    db      LoopCount,2
:   db      SetInstrument,_BossIntro2a
    db      C_2,4
    db      SetInstrument,_BossIntro2b
    dbw     CallSection,Boss_Shared1
    db      SetInstrument,_BossIntro2a
    db      C_3,6
    db      SetInstrument,_BossIntro2b
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossIntro2a
    db      A#2,4
    db      SetInstrument,_BossIntro2b
    dbw     CallSection,Boss_Shared2
    db      SetInstrument,_BossIntro2a
    db      A#3,6
    db      SetInstrument,_BossIntro2b
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossIntro2a
    db      F_2,4
    db      SetInstrument,_BossIntro2b
    dbw     CallSection,Boss_Shared3
    db      SetInstrument,_BossIntro2a
    db      F_3,6
    db      SetInstrument,_BossIntro2b
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossIntro2a
    db      G_2,4
    db      SetInstrument,_BossIntro2b
    dbw     CallSection,Boss_Shared4
    db      SetInstrument,_BossIntro2a
    db      G_3,6
    db      SetInstrument,_BossIntro2b
    db      F_3,2
    db      G_3,2
    dbw     Loop,:-
    db      LoopCount,2
:   
    db      SetInstrument,_BossIntro3a
    db      C_2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared1
.loop
    db      SetInstrument,_BossIntro3a
    db      C_3,6
    db      SetInstrument,_BossIntro3b
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossIntro3a
    db      A#2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared2
    db      SetInstrument,_BossIntro3a
    db      A#3,6
    db      SetInstrument,_BossIntro3b
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossIntro3a
    db      F_2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared3
    db      SetInstrument,_BossIntro3a
    db      F_3,6
    db      SetInstrument,_BossIntro3b
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossIntro3a
    db      G_2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared4
    db      SetInstrument,_BossIntro3a
    db      G_3,6
    db      SetInstrument,_BossIntro3b
    db      F_3,2
    db      G_3,2
    dbw     Loop,:-
    
    db      SetInstrument,_BossLead
    db      C_4,12
    db      C_4,4
    db      D#4,6
    db      C_4,6
    db      F_4,1
    db      G_4,11
    db      A#4,4
    db      G_4,4
    db      F_4,2
    db      D#4,4
    db      C_4,4
    db      D#4,2
    db      C_4,2
    db      A#3,2
    dbw     CallSection,.block0
    db      D#4,4
    db      D_4,2
    db      D#4,2
    db      D_4,2
    db      A#3,4
    db      G_3,4
    db      A#3,2
    db      C_4,12
    db      D_4,4
    db      D#4,6
    db      C_4,6
    db      A#4,1
    db      C_5,7
    db      A#4,4
    db      G_4,4
    db      F#4,4
    db      D#4,2
    db      F_4,2
    db      D#4,2
    db      C_4,2
    db      D#4,2
    db      C_4,2
    db      A#3,2
    db      G_3,2
    db      A#3,1
    db      C_4,3
    db      D_4,4
    db      D#4,2
    db      C_4,4
    db      D_4,1
    db      D#4,5
    db      F_4,4
    db      D#4,2
    db      D_4,2
    db      A#3,2
    db      G_3,2
    db      D#4,2
    db      D_4,4
    db      A#3,6
    db      D#4,2
    db      D_4,4
    db      A#3,6
    db      F_3,4
    db      G_3,4
    
    dbw     CallSection,.block2
    dbw     Goto,:++
:   
    db      SetInstrument,_BossIntro3a
    db      C_2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared1
:
    db      SetInstrument,_BossIntro3a
    db      C_3,6
    db      SetInstrument,_BossIntro3b
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossIntro3a
    db      A#2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared2
    db      SetInstrument,_BossIntro3a
    db      A#3,6
    db      SetInstrument,_BossIntro3b
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossIntro3a
    db      F_2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared3
    db      SetInstrument,_BossIntro3a
    db      F_3,6
    db      SetInstrument,_BossIntro3b
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossIntro3a
    db      G_2,4
    db      SetInstrument,_BossIntro3b
    dbw     CallSection,Boss_Shared4
    db      SetInstrument,_BossIntro3a
    db      G_3,6
    db      SetInstrument,_BossIntro3b
    db      F_3,2
    db      G_3,2
    dbw     Loop,:--
    
    dbw     CallSection,.block1
    db      F_4,2
    db      D#4,4
    db      C_4,4
    db      A#3,4
    db      D#4,2
    db      C_4,2
    db      A#3,2
    dbw     CallSection,.block0
    db      G_4,4
    db      F_4,2
    db      G_4,4
    db      A#4,4
    db      G_4,6
    dbw     CallSection,.block1
    db      A#4,4
    db      C_5,8
    db      D#5,8
    db      F_5,8
    db      D#5,4
    db      C_5,8
    db      D#5,8
    db      A#4,8
    db      G_4,4
    db      F_4,4
    db      D#4,4
    db      C_4,4
    db      A#3,2
    db      D#4,4
    db      C_4,2
    db      A#3,2
    db      G_3,2
    dbw     CallSection,.block2
    dbw     Goto,.loop
    
.block0
    db      A#3,2
    db      C_4,4
    db      C_4,22
    db      C_4,4
    db      D_4,2
    db      D#4,4
    db      F_4,6
    ret
.block1
    db      SetInstrument,_BossLead
    db      B_4,1
    db      C_5,7
    db      C_5,4
    db      G_4,4
    db      A#4,4
    db      G_4,8
    db      F_4,8
    db      F#4,1
    db      G_4,7
    ret
.block2
    db      A#3,1
    db      C_4,7
    db      SetInstrument,_BossIntro3b
    db      C_2,2
    db      C_3,4
    db      C_2,2
    db      C_3,2
    db      C_2,2
    db      C_2,2
    db      LoopCount,2
    ret

; ========
Boss_CH3:
    db      SetInstrument,_BossTomKick
    db      LoopCount,31
:   db      fix,8
    dbw     Loop,:-
    db      fix,4
    db      SetInstrument,_BossTomSnare
    db      fix,2
    db      fix,2
.loop
    db      SetInstrument,_BossTomKick,fix,4,SetInstrument,_BossBass
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossTomSnare,fix,2,SetInstrument,_BossBass
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      C_2,2
    db      C_3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      C_2,2
    db      SetInstrument,_BossTomSnare,fix,4,SetInstrument,_BossBass
    db      C_3,2
    db      C_2,2
    db      SetInstrument,_BossTomKick,fix,4,SetInstrument,_BossBass
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossTomSnare,fix,2,SetInstrument,_BossBass
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      A#2,2
    db      A#3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      A#2,2
    db      SetInstrument,_BossTomSnare,fix,4,SetInstrument,_BossBass
    db      A#3,2
    db      A#2,2
    db      SetInstrument,_BossTomKick,fix,4,SetInstrument,_BossBass
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossTomSnare,fix,2,SetInstrument,_BossBass
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      F_2,2
    db      F_3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      F_2,2
    db      SetInstrument,_BossTomSnare,fix,4,SetInstrument,_BossBass
    db      F_3,2
    db      F_2,2
    db      SetInstrument,_BossTomKick,fix,4,SetInstrument,_BossBass
    db      G_2,2
    db      G_3,2
    db      SetInstrument,_BossTomSnare,fix,2,SetInstrument,_BossBass
    db      G_2,2
    db      G_3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      G_2,2
    db      G_3,2
    db      SetInstrument,_BossTomKick,fix,2,SetInstrument,_BossBass
    db      G_2,2
    db      SetInstrument,_BossTomSnare,fix,4,SetInstrument,_BossBass
    db      G_3,2
    db      G_2,2
    dbw     Goto,.loop

; ========

Boss_CH4:
    db      LoopCount,31
:   Drum    BossKick,2
    Drum    BossCHH,2
    Drum    BossOHH,2
    Drum    BossCHH,2
    dbw     Loop,:-
    Drum    BossKick,2
    Drum    BossCHH,2
    Drum    Snare,2
    Drum    Snare,2
.loop
    Drum    BossKick,2
    Drum    BossCHH,2
    Drum    BossOHHRoll,4
    Drum    Snare,2
    Drum    BossCHH,2
    Drum    BossCHH,2
    Drum    BossKick,2
    Drum    BossCHH,2
    Drum    BossOHHRoll,2
    Drum    BossKick,2
    Drum    BossCHH,2
    Drum    Snare,2
    Drum    BossCHH,2
    Drum    BossOHHRoll,4
    dbw     Goto,.loop
    
; ========

Boss_Shared1:
    db      C_3,2
    db      C_2,2
    db      C_2,2
    db      C_3,4
    db      C_2,2
    db      C_3,2
    db      C_2,2
    db      C_2,2
    ret
    
Boss_Shared2:
    db      A#3,2
    db      A#2,2
    db      A#2,2
    db      A#3,4
    db      A#2,2
    db      A#3,2
    db      A#2,2
    db      A#2,2
    ret
    
Boss_Shared3:
    db      F_3,2
    db      F_2,2
    db      F_2,2
    db      F_3,4
    db      F_2,2
    db      F_3,2
    db      F_2,2
    db      F_2,2
    ret
    
Boss_Shared4:
    db      G_3,2
    db      G_2,2
    db      G_2,2
    db      G_3,4
    db      G_2,2
    db      G_3,2
    db      G_2,2
    db      G_2,2
    ret
    
; =================================================================

PT_Forest:  dw  Forest_CH1,Forest_CH2,Forest_CH3,Forest_CH4

Forest_CH1:
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    db      LoopCount,14
:   db      SetInstrument,_ForestPluck0,SetPan,$10,D#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$01,C#4,2
    db      SetInstrument,_ForestPluck3,SetPan,$11,D#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$10,F#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C#4,2
    db      SetInstrument,_ForestPluck0,SetPan,$01,D#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$10,C#4,2
    db      SetInstrument,_ForestPluck3,SetPan,$11,D#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$01,F#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C#4,2
    db      SetInstrument,_ForestPluck0,SetPan,$10,D#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F#3,2
    dbw     Loop,:-          
    dbw     CallSection,.block0
    
    dbw     CallSection,.block1
    db      SetInstrument,_ForestPluck2,SetPan,$01,C_4,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F_4,2
    db      SetInstrument,_ForestPluck0,SetPan,$10,G#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C_4,2
    dbw     CallSection,.block1
    db      SetInstrument,_ForestPluck2,SetPan,$01,C#4,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,G#4,2
    db      SetInstrument,_ForestPluck0,SetPan,$10,G#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,D#4,2
    
    db      SetInsAlternate,_ForestEcho1,_ForestEcho2
    db      LoopCount,10
:
    db      SetPan,$11,F#6,1,SetPan,$10,F#6,1
    db      SetPan,$11,A#5,1,SetPan,$01,F#6,1
    db      SetPan,$11,F#5,1,SetPan,$10,A#5,1
    db      SetPan,$11,F_6,1,SetPan,$01,F#5,1
    db      SetPan,$11,A#5,1,SetPan,$10,F_6,1
    db      SetPan,$11,F#5,1,SetPan,$01,A#5,1
    db      SetPan,$11,D#6,1,SetPan,$10,F#5,1
    db      SetPan,$11,A#5,1,SetPan,$01,D#6,1
    db      SetPan,$11,F#5,1,SetPan,$10,A#5,1
    db      SetPan,$11,C#6,1,SetPan,$01,F#5,1
    db      SetPan,$11,G#5,1,SetPan,$10,C#6,1
    db      SetPan,$11,F_5,1,SetPan,$01,G#5,1
    db      SetPan,$11,D#6,1,SetPan,$10,F_5,1
    db      SetPan,$11,F_6,1,SetPan,$01,D#6,1
    dbw     Loop,:-
    dbw     Goto,Forest_CH1

.block0
    db      SetInstrument,_ForestPluck0,SetPan,$10,D#3,4
    db      SetInstrument,_ForestPluck2,SetPan,$01,C#4,4
    db                                  SetPan,$10,F#3,4
    db      SetInstrument,_ForestPluck0,SetPan,$01,D#3,4
    db      SetInstrument,_ForestPluck2,SetPan,$10,C#4,4
    db                                  SetPan,$01,F#3,4
    db      SetInstrument,_ForestPluck0,SetPan,$10,D#3,4
    db      SetInstrument,_ForestPluck2,SetPan,$01,D#3,4
    db                                  SetPan,$10,C#4,4
    db      SetInstrument,_ForestPluck0,SetPan,$01,F#3,4
    db      SetInstrument,_ForestPluck2,SetPan,$10,D#3,4
    db                                  SetPan,$01,C#4,4
    db      SetInstrument,_ForestPluck0,SetPan,$10,F#3,4
    db      SetInstrument,_ForestPluck2,SetPan,$01,D#3,4
    ret
.block1
    db      SetInstrument,_ForestPluck0,SetPan,$10,D#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$01,C#4,2
    db      SetInstrument,_ForestPluck3,SetPan,$11,D#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$10,F#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C#4,2
    db      SetInstrument,_ForestPluck0,SetPan,$01,G#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C#4,2
    db      SetInstrument,_ForestPluck2,SetPan,$10,F#4,2
    db      SetInstrument,_ForestPluck3,SetPan,$11,G#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$01,C_4,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F_4,2
    db      SetInstrument,_ForestPluck0,SetPan,$10,G#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C_4,2
    db      SetInstrument,_ForestPluck0,SetPan,$10,B_2,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,F#3,2
    db      SetInstrument,_ForestPluck2,SetPan,$01,B_3,2
    db      SetInstrument,_ForestPluck3,SetPan,$11,B_2,2
    db      SetInstrument,_ForestPluck2,SetPan,$10,F#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,B_3,2
    db      SetInstrument,_ForestPluck0,SetPan,$01,G#3,2
    db      SetInstrument,_ForestPluck1,SetPan,$11,C#4,2
    db      SetInstrument,_ForestPluck2,SetPan,$10,F#4,2
    db      SetInstrument,_ForestPluck3,SetPan,$11,G#3,2

    ret
    
; ========

Forest_CH2:
    db      rest,2
    dbw     CallSection,.block0
    db      SetInstrument,_ForestPluck3,F#3,4
    dbw     CallSection,.block0
    db      SetInstrument,_ForestPluck3,F#3,2
    
    dbw     CallSection,.block1
    db      F#4,56
    dbw     CallSection,.block1
    db      D#5,50
    db      F_5,6
    
    db      F#5,24
    db      F_5,2
    db      C#5,2
    db      D#5,16
    db      C#5,6
    db      F#4,6
    db      C#5,22
    db      D#5,6
    db      F_5,22
    db      C#5,6
    db      D#5,58
    dbw     CallSection,.block0
    db      SetInstrument,_ForestPluck3,F#3,2
    db      SetInstrument,_ForestArp
    db      LoopCount,3
:   db      Arp,2,$37,D#4,12
    db      Arp,2,$47,C#4, 6
    db                C#4,10
    db                B_3,12
    db                C#4, 6
    db                C#4,10
    db      Arp,2,$37,D#4,12
    db      Arp,2,$47,C#4, 6
    db                C#4,10
    db                B_3,12
    db      Arp,2,$5a,G#3, 6
    db      Arp,2,$59,G#3,10
    dbw     Loop,:-
    db      Arp,2,$37,D#4,56
    dbw     Goto,Forest_CH2
    
.block0
    db      SetInstrument,_ForestPluck1,F#3,4
    db      SetInstrument,_ForestPluck3,D#3,4
    db      SetInstrument,_ForestPluck1,C#4,4
    db                                  F#3,4
    db      SetInstrument,_ForestPluck3,D#3,4
    db      SetInstrument,_ForestPluck1,C#4,4
    db                                  F#3,4
    db      SetInstrument,_ForestPluck3,F#3,4
    db      SetInstrument,_ForestPluck1,D#3,4
    db                                  C#4,4
    db      SetInstrument,_ForestPluck3,F#3,4
    db      SetInstrument,_ForestPluck1,D#3,4
    db                                  C#4,4
    ret
    
.block1
    db      SetInstrument,_ForestLead
    db      A#4,24
    db      G#4,2
    db      F#4,2
    db      A#4,22
    db      C#5,6
    ret

; ========

Forest_CH3:
    db      SetInstrument,_ForestBass
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    dbw     CallSection,.block0
    db      LoopCount,6
  
:   db      D#3,2
    db      D#4,4
    db      D#3,2
    db      D#4,4
    db      C#3,2
    db      C#4,4
    db      C#3,2
    db      C#4,4
    db      C#3,2
    db      G#3,2
    db      B_2,2
    db      B_3,4
    db      B_2,2
    db      B_3,4
    db      C#3,2
    db      C#4,4
    db      C#3,2
    db      C#4,4
    db      C#3,2
    db      G#3,2
    dbw     Loop,:-
    db      SetInstrument,_ForestBassSustain,D#2,14
    db      SetInstrument,_ForestBassDecay,D#2,42
    dbw     Goto,Forest_CH3
    
.block0
    db      LoopCount,3
:   db      D#3,2
    db      D#4,4
    db      D#3,2
    db      D#4,4
    db      C#3,2
    dbw     Loop,:-
    db      D#3,2
    db      D#4,4
    db      D#3,2
    db      D#4,4
    db      F#4,2
    db      LoopCount,3
:   db      B_2,2
    db      B_3,4
    db      B_2,2
    db      B_3,4
    db      A#2,2
    dbw     Loop,:-
    db      B_2,2
    db      B_3,4
    db      B_2,2
    db      B_3,4
    db      C#4,2
    ret
    
; ========

Forest_CH4:
    db      LoopCount,20
:   Drum    ForestPercussion1,12
    Drum    ForestPercussion2,16
    dbw     Loop,:-
    db      LoopCount,14
:
    Drum    ForestPercussionV9,2
    Drum    ForestPercussionVA,2
    Drum    ForestPercussionVB,2
    Drum    ForestPercussionVC,2
    Drum    ForestPercussionVD,2
    Drum    ForestPercussionVE,2
    Drum    ForestPercussion2,2
    Drum    ForestPercussionV8,2
    Drum    ForestPercussion3,2
    Drum    ForestPercussionVA,2
    Drum    ForestPercussionV9,2
    Drum    ForestPercussionV8,2
    Drum    ForestPercussionV9,2
    Drum    ForestPercussionVA,2
    dbw     Loop,:-
    dbw     Goto,Forest_CH4

; =================================================================

PT_Gallery: dw  Gallery_CH1,Gallery_CH2,Gallery_CH3,Gallery_CH4

Gallery_CH1:
    dbw     CallSection,.block1
    dbw     CallSection,.block1
:   dbw     CallSection,.block1
    dbw     CallSection,.block1
    dbw     CallSection,.block2
    dbw     CallSection,.block2
    dbw     Goto,:-
    
.block1
    db      SetInstrument,_GalleryEchoA,D_5,1
    db      SetInstrument,_GalleryEcho4,D_5,1
    db      SetInstrument,_GalleryEchoA,E_5,1
    db      SetInstrument,_GalleryEcho4,D_5,1
    db      SetInstrument,_GalleryEchoA,G_5,1
    db      SetInstrument,_GalleryEcho4,E_5,1
    db      SetInstrument,_GalleryEcho9,D_5,1
    db      SetInstrument,_GalleryEcho4,G_5,1
    db      SetInstrument,_GalleryEcho8,E_5,1
    db      SetInstrument,_GalleryEcho3,D_5,1
    db      SetInstrument,_GalleryEcho7,G_5,1
    db      SetInstrument,_GalleryEcho3,E_5,1
    db      SetInstrument,_GalleryEcho6,D_5,1
    db      SetInstrument,_GalleryEcho2,G_5,1
    db      SetInstrument,_GalleryEcho5,E_5,1
    db      SetInstrument,_GalleryEcho2,D_5,1
    db      SetInstrument,_GalleryEcho4,G_5,1
    db      SetInstrument,_GalleryEcho1,E_5,1
    db      SetInstrument,_GalleryEcho3,D_5,1
    db      SetInstrument,_GalleryEcho1,G_5,1
    db      SetInstrument,_GalleryEcho2,E_5,2
    db      SetInstrument,_GalleryEcho1,G_5,10
    db      SetInstrument,_GalleryBack
    db      C_3,6
    db      E_3,6
    db      G_3,20
    ret
.block2
    db      SetInstrument,_GalleryEchoA,E_5,1
    db      SetInstrument,_GalleryEcho4,E_5,1
    db      SetInstrument,_GalleryEchoA,F#5,1
    db      SetInstrument,_GalleryEcho4,E_5,1
    db      SetInstrument,_GalleryEchoA,A_5,1
    db      SetInstrument,_GalleryEcho4,F#5,1
    db      SetInstrument,_GalleryEcho9,E_5,1
    db      SetInstrument,_GalleryEcho4,A_5,1
    db      SetInstrument,_GalleryEcho8,F#5,1
    db      SetInstrument,_GalleryEcho3,E_5,1
    db      SetInstrument,_GalleryEcho7,A_5,1
    db      SetInstrument,_GalleryEcho3,F#5,1
    db      SetInstrument,_GalleryEcho6,E_5,1
    db      SetInstrument,_GalleryEcho2,A_5,1
    db      SetInstrument,_GalleryEcho5,F#5,1
    db      SetInstrument,_GalleryEcho2,E_5,1
    db      SetInstrument,_GalleryEcho4,A_5,1
    db      SetInstrument,_GalleryEcho1,F#5,1
    db      SetInstrument,_GalleryEcho3,E_5,1
    db      SetInstrument,_GalleryEcho1,A_5,1
    db      SetInstrument,_GalleryEcho2,F#5,2
    db      SetInstrument,_GalleryEcho1,A_5,10
    db      SetInstrument,_GalleryBack
    db      D_3,6
    db      F#3,6
    db      A_3,20
    ret

Gallery_CH2:
    db      SetInstrument,_GalleryLead
    db      rest,128
.loop
    db      C_5,8
    db      C_5,4
    db      G_4,4
    db      A#4,4
    db      G_4,8
    db      F_4,8
    db      G_4,92
    db      D_5,8
    db      D_5,4
    db      A_4,4
    db      C_5,4
    db      A_4,8
    db      G_4,8
    db      A_4,92
    dbw     Goto,.loop

Gallery_CH3:
    db      SetInstrument,_GalleryBass
    db      LoopCount,3
:
    db      C_3,32
    db      C_3,6
    db      C_4,4
    db      C_3,2
    db      C_4,4
    db      C_3,8
    db      G_3,4
    db      G_2,4
    dbw     Loop,:-
    db      C_3,32
    db      C_3,6
    db      C_4,4
    db      C_3,2
    db      C_4,4
    db      C_3,8
    db      C_3,4
    db      C#3,4
    db      D_3,32
    db      D_3,6
    db      D_4,4
    db      D_3,2
    db      D_4,4
    db      D_3,8
    db      A_3,4
    db      A_2,4
    db      D_3,32
    db      D_3,6
    db      D_4,4
    db      D_3,2
    db      D_4,4
    db      D_3,8
    db      D_3,4
    db      C#3,4
    db      LoopCount,1
    dbw     Goto,:-
    
Gallery_CH4:
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Snare,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Kick,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    Kick,2
    Drum    CHH,2
    Drum    Snare,2
    Drum    CHH,2
    Drum    CHH,2
    Drum    CHH,2
    dbw     Goto,Gallery_CH4
    
; =================================================================

PT_Cave:

; =================================================================

PT_Temple:

; =================================================================

PT_Bonus:

; =================================================================

PT_Credits:

; =================================================================

PT_Blank:   dw  DummyChannel,DummyChannel,DummyChannel,DummyChannel

    db      "END"