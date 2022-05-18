Pal_Grayscale:
    RGB 31,31,31
    RGB 20,20,20
    RGB 10,10,10
    RGB  0, 0, 0

; ================

Pal_GrayscaleInverted:
    RGB  0, 0, 0
    RGB 10,10,10
    RGB 20,20,20
    RGB 31,31,31

; ================

Pal_DebugScreen:
    RGB  0,15,31
    RGB  0, 0, 0
    RGB  0, 0, 0
    RGB 31,31,31

; ================
    
Pal_Player:
    RGB 31, 0,31
    RGB  0, 0, 0
    RGB  0,15,31
    RGB 31,31,31
Pal_PlainsObjects:
    RGB 31, 0,31
    RGB  0, 0, 0
    RGB  0,31, 0
    RGB 31,31,31
    
    RGB 31, 0,31
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31,31

    RGB 31, 0,31
    RGB  0, 0, 0
    RGB 20,20,20
    RGB 31,31,31
    
    RGB 31, 0,31
    RGB  0, 0, 0
    RGB  0, 0,31
    RGB  0,31,31
    
    RGB 31, 0,31
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31
    
    RGB 31, 0,31
    RGB 31, 0, 0
    RGB 31,15, 0
    RGB 31,31, 0
    
    RGB 31, 0,31
    RGB  0, 0, 0
    RGB 10,10,10
    RGB 20,20,20
    
Pal_TestMap:
    RGB  0, 0, 0
    RGB  3, 3, 3
    RGB  7, 7, 7
    RGB 15,15,15
    
    RGB  0, 0, 0
    RGB  0,15,31
    RGB 15,31,31
    RGB 31,31,31
    
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31
    
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31
    
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31
    
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31
    
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31
    
    RGB  0, 0, 0
    RGB 31, 0, 0
    RGB 31,31, 0
    RGB 31,31,31

; ================

Pal_Plains:
    ; dirt
    RGB   0>>3,  0>>3,  0>>3
    RGB 102>>3, 48>>3,  0>>3
    RGB 139>>3, 64>>3,  0>>3
    RGB 176>>3, 80>>3,  0>>3
    ; dirt + grass
    RGB 102>>3, 48>>3,  0>>3
    RGB 176>>3, 80>>3,  0>>3
    RGB   0>>3,160>>3,  0>>3
    RGB   0>>3,200>>3,  0>>3
    ; dirt + rocks
    RGB 111>>3,111>>3,111>>3
    RGB 192>>3,192>>3,192>>3
    RGB 139>>3, 64>>3,  0>>3
    RGB 176>>3, 80>>3,  0>>3
    ; water
    RGB   0>>3,  0>>3,  0>>3
    RGB   0>>3, 88>>3,255>>3
    RGB   0>>3,255>>3,255>>3
    RGB 255>>3,255>>3,255>>3
    ; signs
    RGB 128>>3,160>>3,255>>3
    RGB   0>>3,  0>>3,  0>>3
    RGB 176>>3, 80>>3,  0>>3
    RGB 255>>3,216>>3,  0>>3
	; spikes (above ground)
    RGB 128>>3,160>>3,255>>3
    RGB 136>>3,136>>3,136>>3
    RGB 198>>3,198>>3,198>>3
    RGB 255>>3,255>>3,255>>3
    ; flowers + grass
    RGB 128>>3,160>>3,255>>3
    RGB   0>>3,160>>3,  0>>3
    RGB 255>>3,216>>3,  0>>3
    RGB 255>>3,255>>3,255>>3
	; spikes (underground)
    RGB   0>>3,  0>>3,  0>>3
    RGB  78>>3, 78>>3, 78>>3
    RGB 162>>3,162>>3,162>>3
    RGB 255>>3,255>>3,255>>3

Pal_Forest:
    incbin  "GFX/Tilesets/Forest.pal"
