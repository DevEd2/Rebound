NUM_LEVELS = 0

addlevel:       macro
include "Levels/\1.inc"
    levelptr    \1
endm

levelptr:       macro
section fragment "Level pointers",rom0
MapID_\1 = NUM_LEVELS
    bankptr Map_\1
NUM_LEVELS = NUM_LEVELS + 1
endm

LevelPointers:
    addlevel    TestMap
    
    addlevel    Plains1
    addlevel    Plains2
    addlevel    Plains3
    addlevel    Plains4
	addlevel	Plains5
    addlevel    Plains6
;   addlevel    Plains7
;   addlevel    PlainsBoss
        
;   addlevel    City1
;   addlevel    City2
;   addlevel    City3
;   addlevel    City4
;	addlevel	City5
;   addlevel    City6
;   addlevel    City7
;   addlevel    CityBoss
        
;   addlevel    Forest1
;   addlevel    Forest2
;   addlevel    Forest3
;   addlevel    Forest4
;	addlevel	Forest5
;   addlevel    Forest6
;   addlevel    Forest7
;   addlevel    ForestBoss
        
;   addlevel    Pyramid1
;   addlevel    Pyramid2
;   addlevel    Pyramid3
;   addlevel    Pyramid4
;	addlevel	Pyramid5
;   addlevel    Pyramid6
;   addlevel    Pyramid7
;   addlevel    PyramidBoss
        
;   addlevel    Cave1
;   addlevel    Cave2
;   addlevel    Cave3
;   addlevel    Cave4
;	addlevel	Cave5
;   addlevel    Cave6
;   addlevel    Cave7
;   addlevel    CaveBoss
        
;   addlevel    Temple1
;   addlevel    Temple2
;   addlevel    Temple3
;   addlevel    Temple4
;	addlevel	Temple5
;   addlevel    Temple6
;   addlevel    Temple7
;   addlevel    TempleBoss
