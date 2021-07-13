; VGMSFX sound effect data

defsfx: macro
section "SFX Data - \1",romx
SFX_\1: db \2
incbin "Audio/SFX/\1.vgm",$c0
db $ff
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
    defsfx  wavetest,SFX_CH3