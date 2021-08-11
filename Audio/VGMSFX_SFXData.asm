; VGMSFX sound effect data

NUM_SFX = 0

section fragment "SFX pointers",rom0
SFXTest_Pointers:

defsfx: macro
section "SFX Data - \1",romx
SFX_\1: db \2
incbin "Audio/SFX/\1.vgm",$c0
db $ff
section fragment "SFX pointers",rom0
SFXPtr_\1:
    db  SFXPtr_\1.end-SFXPtr_\1
    db  bank(SFX_\1)
    dw  SFX_\1
    db  strupr("\1"),0
.end
NUM_SFX = NUM_SFX+1
endm

endsfx: macro
section fragment "SFX pointers",rom0
SFXPtr_End: db 0
endm

    defsfx  menucursor,SFX_CH1
    defsfx  menuselect,SFX_CH1
    defsfx  menuback,SFX_CH1
    defsfx  menudeny,SFX_CH1
    defsfx  pause,SFX_CH1
    defsfx  coin,SFX_CH1
    defsfx  death,SFX_CH1
    defsfx  jump,SFX_CH1
    defsfx  impact1,SFX_CH1
    defsfx  splash,SFX_CH4
    defsfx  spring,SFX_CH1
    defsfx  bosshit,SFX_CH1|SFX_CH3
    endsfx