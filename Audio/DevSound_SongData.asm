; ================================================================
; DevSound song data
; ================================================================
	
; =================================================================
; Song speed table
; =================================================================

SongSpeedTable:
	db	4,5			; desert
	
	
SongPointerTable:
	dw	PT_Desert

; =================================================================
; Volume sequences
; =================================================================

; Wave volume values
w0			=	%00000000
w1			=	%01100000
w2			=	%01000000
w3			=	%00100000

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

vol_Bass1:			db	w3,$ff
vol_PulseBass:		db	15,15,14,14,13,13,12,12,11,11,10,10,9,9,8,8,8,7,7,7,6,6,6,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1,0,$ff

vol_Kick:			db	$1f,$1f,$18,$ff
vol_Snare:			db	$1d,$ff
vol_OHH:			db	$48,$ff
vol_CymbQ:			db	$6a,$ff
vol_CymbL:			db	$3f,$ff

vol_Echo1:			db	8,$ff	
vol_Echo2:			db	3,$ff

vol_DesertArp:		db	w3,w3,w3,w3,w3,w2,w2,w2,w2,w2,w1,$ff
vol_DesertLeadS:	db	w3,w3,w3,w3,w3
vol_DesertLeadF:	db	w2,w2,w2,w2,w2
					db	w1,$ff				
vol_DesertLeadL:	db	w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3
					db	w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3
					db	w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2,w2
					db	w1,$ff
		
vol_TomEcho:		db	$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
					db	$18,$18,$18,$18,$18,$18,$18,$18,$18
					db	$14,$14,$14,$14,$14,$14,$14,$14,$14
					db	$12,$12,$12,$12,$12,$12,$12,$12,$12
					db	$11,$11,$11,$11,$11,$11,$11,$11,$11
					db	$ff
					
; =================================================================
; Arpeggio sequences
; =================================================================

arp_Pluck:		db	12,0,$ff
arp_TomEcho:	db	22,20,18,16,14,12,10,9,7,$80,0
arp_Oct2:		db	12,12,0,0,$80,0

arp_940:		db	9,9,4,4,0,0,$80,0
arp_720:		db	7,7,2,2,0,0,$80,0
arp_520:		db	5,5,2,2,0,0,$80,0

; =================================================================
; Noise sequences
; =================================================================

; Noise values are the same as Deflemask, but with one exception:
; To convert 7-step noise values (noise mode 1 in deflemask) to a
; format usable by DevSound, take the corresponding value in the
; arpeggio macro and add s7.
; Example: db s7+32 = noise value 32 with step lengh 7
; Note that each noiseseq must be terminated with a loop command
; ($80) otherwise the noise value will reset!

s7 = $2d

noiseseq_Kick:	db	s7+18,s7+18,43,$80,2
noiseseq_Snare:	db	s7+29,s7+23,s7+20,35,$80,3
noiseseq_Hat:	db	41,43,$80,1

; =================================================================
; Pulse sequences
; =================================================================

pulse_Dummy:	db	0,$ff
pulse_Arp:		db	2,2,2,1,1,1,0,0,0,3,3,3,$80,0
pulse_OctArp:	db	2,2,2,1,1,2,$ff

pulse_Bass:		db	1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,0,0,0,0,0,0,$80,0
pulse_Square:	db	2,$ff
pulse_Arp2:		db	0,0,0,0,1,1,1,2,2,2,2,3,3,3,2,2,2,2,1,1,1,$80,0

pulse_BeachLead:	
	db	0,0,0,0,0,0,0,0,0,0
	db	1,1,1,1,1,1,1,1,1,1
	db	2,2,2,2,2,2,2,2,2,2
	db	3,3,3,3,3,3,3,3,3,3
	db	$80,0
	
pulse_BeachOct:
	db	2,2,1,1,0,0,$ff

pulse_DesertBass:	db	0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,$80,0

pulse_SnowBass:		db	1,$ff

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:		db	0,0,$80,1
vib_BeachLead:	db	8,1,1,2,2,1,1,0,0,-1,-1,-2,-2,-1,-1,0,0,$80,1
vib_PWMLead:	db	24,2,3,3,2,0,0,-2,-3,-3,-2,0,0,$80,1

; =================================================================
; Wave sequences
; =================================================================

WaveTable:
	dw	DefaultWave
	dw	wave_Bass
	dw	wave_DesertLead
	dw	wave_DesertSquare
	
wave_Bass:			db	$00,$01,$11,$11,$22,$11,$00,$02,$57,$76,$7a,$cc,$ee,$fc,$b1,$23
wave_DesertLead:	db	$01,$23,$45,$67,$89,$ab,$cd,$ef,$ed,$b9,$75,$31,$02,$46,$8a,$ce
wave_DesertSquare:	db	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$00,$00,$44,$44,$00,$00,$00

waveseq_Tri:		db	0,$ff
waveseq_Bass:		db	1,$ff
waveseq_DesertLead:	db	2,$ff
waveseq_Square:		db	3,$ff

; =================================================================
; Instruments
; =================================================================

InstrumentTable:
	dw	ins_Kick
	dw	ins_Snare
	dw	ins_CHH
	dw	ins_OHH
	dw	ins_CymbQ
	dw	ins_CymbL
	
	dw	ins_Echo1
	dw	ins_Echo2
	dw	ins_TomEcho
	dw	ins_DesertBass
	dw	ins_DesertLead
	dw	ins_DesertLeadF
	dw	ins_DesertLeadS
	dw	ins_DesertLeadL
	dw	ins_DesertOctArp
	dw	ins_DesertArp720
	dw	ins_DesertArp940
	dw	ins_DesertArp520

; Instrument format: [no reset flag],[wave mode (ch3 only)],[voltable id],[arptable id],[pulsetable/wavetable id],[vibtable id]
; note that wave mode must be 0 for non-wave instruments
; !!! REMEMBER TO ADD INSTRUMENTS TO THE INSTRUMENT POINTER TABLE !!!
ins_Kick:			Instrument	0,vol_Kick,noiseseq_Kick,DummyTable,DummyTable	; pulse/waveseq and vibrato unused by noise instruments
ins_Snare:			Instrument	0,vol_Snare,noiseseq_Snare,DummyTable,DummyTable
ins_CHH:			Instrument	0,vol_Kick,noiseseq_Hat,DummyTable,DummyTable
ins_OHH:			Instrument	0,vol_OHH,noiseseq_Hat,DummyTable,DummyTable
ins_CymbQ:			Instrument	0,vol_CymbQ,noiseseq_Hat,DummyTable,DummyTable
ins_CymbL:			Instrument	0,vol_CymbL,noiseseq_Hat,DummyTable,DummyTable

ins_Echo1:			Instrument	0,vol_Echo1,DummyTable,pulse_Dummy,vib_Dummy
ins_Echo2:			Instrument	0,vol_Echo2,DummyTable,pulse_Dummy,vib_Dummy
ins_TomEcho:		Instrument	0,vol_TomEcho,arp_TomEcho,pulse_Square,vib_Dummy
ins_DesertBass:		Instrument	0,vol_PulseBass,arp_Pluck,pulse_DesertBass,vib_Dummy
ins_DesertLead:		Instrument	0,vol_Bass1,arp_Pluck,waveseq_DesertLead,vib_BeachLead
ins_DesertLeadF:	Instrument	0,vol_DesertLeadF,DummyTable,waveseq_DesertLead,vib_Dummy
ins_DesertLeadS:	Instrument	0,vol_DesertLeadS,arp_Pluck,waveseq_DesertLead,vib_Dummy
ins_DesertLeadL:	Instrument	0,vol_DesertLeadL,arp_Pluck,waveseq_DesertLead,vib_BeachLead
ins_DesertOctArp:	Instrument	0,vol_DesertArp,arp_Oct2,waveseq_Square,vib_BeachLead
ins_DesertArp720:	Instrument	0,vol_DesertArp,arp_720,waveseq_Square,vib_Dummy
ins_DesertArp940:	Instrument	0,vol_DesertArp,arp_940,waveseq_Square,vib_Dummy
ins_DesertArp520:	Instrument	0,vol_DesertArp,arp_520,waveseq_Square,vib_Dummy

_ins_Kick			equ	0
_ins_Snare			equ	1
_ins_CHH			equ	2
_ins_OHH			equ	3
_ins_CymbQ			equ	4
_ins_CymbL			equ	5

_ins_Echo1			equ	6
_ins_Echo2			equ	7
_ins_TomEcho		equ	8
_ins_DesertBass		equ	9
_ins_DesertLead		equ	10
_ins_DesertLeadF	equ	11
_ins_DesertLeadS	equ	12
_ins_DesertLeadL	equ	13
_ins_DesertOctArp	equ	14
_ins_DesertArp720	equ	15
_ins_DesertArp940	equ	16
_ins_DesertArp520	equ	17

Kick				equ	_ins_Kick
Snare				equ	_ins_Snare
CHH					equ	_ins_CHH
OHH					equ	_ins_OHH
CymbQ				equ	_ins_CymbQ
CymbL				equ	_ins_CymbL
	
; =================================================================

PT_Desert:	dw	Desert_CH1,Desert_CH2,Desert_CH3,Desert_CH4

Desert_CH1:
	db	SetInstrument,_ins_DesertBass
	db	F_2,2
	db	F_2,4
	db	F_2,2
	Drum	_ins_TomEcho,4
	db	SetInstrument,_ins_DesertBass
	db	D#2,2
	db	F_2,4
	db	F_2,2
	db	D#2,2
	db	F_2,2
	Drum	_ins_TomEcho,6
	db	SetInstrument,_ins_DesertBass
	db	F_2,2
	db	F#2,2
	db	F#2,4
	db	F#2,2
	Drum	_ins_TomEcho,4
	db	SetInstrument,_ins_DesertBass
	db	F_2,2
	db	F#2,4
	db	F#2,2
	db	F_2,2
	db	F#2,2
	Drum	_ins_TomEcho,6
	db	SetInstrument,_ins_DesertBass
	db	A_2,2
	dbw	Goto,Desert_CH1
	
Desert_CH2:
	db	SetInsAlternate,_ins_Echo1,_ins_Echo2
.loop
	db	F_5,1,C#5,1
	db	C_5,1,F_5,1
	db	D#5,1,C_5,1
	db	C_5,1,D#5,1
	dbw	CallSection,.block0
	dbw	CallSection,.block0
	dbw	CallSection,.block0
	db	F#5,1,C_5,1
	db	C#5,1,F#5,1
	db	E_5,1,C#5,1
	db	C#5,1,E_5,1
	dbw	CallSection,.block1
	dbw	CallSection,.block1
	dbw	CallSection,.block1
	dbw	Goto,.loop
.block0
	db	F_5,1,C_5,1
	db	C_5,1,F_5,1
	db	D#5,1,C_5,1
	db	C_5,1,D#5,1
	ret
.block1
	db	F#5,1,C#5,1
	db	C#5,1,F#5,1
	db	E_5,1,C#5,1
	db	C#5,1,E_5,1
	ret
	
Desert_CH3:
	db	SetInstrument,_ins_DesertLead
	dbw	CallSection,.block0
	dbw	CallSection,.block0

	dbw	CallSection,.block1
	db	C#5,18,C#5,2
	db	D#5,3,D#5,1
	db	SetInsAlternate,_ins_DesertLead,_ins_DesertLeadS
	db	C#5,2
	db	D#5,2
	db	C#5,2
	db	A#4,2
	dbw	CallSection,.block1
	db	SetInsAlternate,_ins_DesertLead,_ins_DesertLeadS
	db	F#5,2
	db	G#5,2
	db	F#5,2
	db	G#5,2
	db	SetInstrument,_ins_DesertLead
	db	F#5,4
	db	G#5,2
	db	SetInstrument,_ins_DesertLeadF
	db	G#5,2
	db	SetInstrument,_ins_DesertLead
	db	F#5,8
	db	A#5,6
	db	SetInstrument,_ins_DesertLeadF
	db	A#5,2
	
	db	SetInstrument,_ins_DesertLead
	db	C_6,10
	db	SetInstrument,_ins_DesertLeadF
	db	C_6,2
	db	SetInstrument,_ins_DesertLead
	db	G#5,4
	db	F_5,6
	db	SetInstrument,_ins_DesertLeadF
	db	F_5,2
	db	SetInsAlternate,_ins_DesertLeadS,_ins_DesertLead
	db	G#5,2
	db	F_5,2
	db	C_5,2
	db	F_5,2
	db	F#5,2
	db	F_5,2
	db	F#5,2
	db	G#5,2
	db	SetInstrument,_ins_DesertLead
	db	F#5,4
	db	G#5,2
	db	SetInstrument,_ins_DesertLeadF
	db	G#5,2
	db	SetInsAlternate,_ins_DesertLead,_ins_DesertLeadF
	db	F#5,6,F#5,2
	db	D#5,6,D#5,2
	db	SetInstrument,_ins_DesertLeadL
	db	F_5,32
	db	SetInstrument,_ins_DesertArp720
	db	F#5,4
	db	F#5,4
	db	F#5,2
	db	F#5,4
	db	F#5,4
	db	F#5,4
	db	F#5,2
	db	SetInstrument,_ins_DesertArp940
	db	F#5,2
	db	F#5,2
	db	SetInstrument,_ins_DesertArp720
	db	F#5,2
	db	SetInstrument,_ins_DesertArp520
	db	F#5,2
	db	SetInstrument,_ins_DesertLead
	db	CallSection
	dw	.block0
	db	CallSection
	dw	.block0
	db	SetInstrument,_ins_DesertOctArp
	db	CallSection
	dw	.block0
	db	CallSection
	dw	.block2
	dbw	Goto,Desert_CH3

.block0
	db	F_5,2
	db	D#5,2
	db	F_5,2
	db	F#5,2
	db	F_5,2
	db	D#5,2
	db	F_5,2
	db	C_5,2
	db	F_5,2
	db	C_5,2
	db	F_5,2
	db	A_5,4
	db	F_5,2
	db	D#5,2
	db	F_5,2
	db	F#5,2
	db	C#5,2
	db	A#5,2
	db	G#5,2
	db	F#5,2
	db	F_5,2
	db	F#5,2
	db	C#5,2
	db	F#5,2
	db	C#5,2
	db	F#5,2
	db	A#5,4
	db	G#5,2
	db	F#5,2
	db	D#5,2
	ret
.block1
	db	SetInsAlternate,_ins_DesertLead,_ins_DesertLeadF
	db	C_5,14,C_5,2
	db	F_5,6,F_5,2
	db	C_5,6,C_5,2
	ret
.block2
	db	F_6,2
	db	D#6,2
	db	F_6,2
	db	F#6,2
	db	F_6,2
	db	D#6,2
	db	F_6,2
	db	C_6,2
	db	F_6,2
	db	C_6,2
	db	F_6,2
	db	A_6,4
	db	F_6,2
	db	D#6,2
	db	F_6,2
	db	F#6,2
	db	C#6,2
	db	A#6,2
	db	G#6,2
	db	F#6,2
	db	F_6,2
	db	F#6,2
	db	C#6,2
	db	F#6,2
	db	C#6,2
	db	F#6,2
	db	A#6,4
	db	G#6,2
	db	F#6,2
	db	D#6,2
	ret
	
Desert_CH4:
	Drum	Kick,2
	Drum	CHH,2
	Drum	OHH,2
	Drum	CHH,2
	Drum	Snare,4
	Drum	OHH,2
	Drum	CHH,2
	dbw		Goto,Desert_CH4
	