section "Level pointers",rom0

NUM_LEVELS = 0

levelptr:       macro
MapID_\1 = NUM_LEVELS
    bankptr Map_\1
NUM_LEVELS = NUM_LEVELS + 1
endm

LevelPointers:
    levelptr    TestMap
    levelptr    Plains1
