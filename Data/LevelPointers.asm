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
    