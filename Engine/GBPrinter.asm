; Game Boy Printer routines

Printer_Magic       =   $3388

Printer_Initialize  =   $01
Printer_Start       =   $02
Printer_FillBuffer  =   $04
Printer_Status      =   $0f

; Returns carry flag if GB Printer is detected.
GBPrinter_Detect::
    ld      hl,.bytes
    ld      b,8
.loop
    ld      a,[hl+]     ; get byte
    call    Serial_SendByte
    dec     b
    jr      nz,.loop
    cp      $81
    jr      nz,.notfound
    xor     a
    call    Serial_SendByte
    and     a
    ret     nz
    scf
    ret
.notfound
    and     a
    ret
.bytes
    dw      Printer_Magic
    db      Printer_Status
    db      0
    dw      0
    db      $0f ; checksum
    db      0

GBPrinter_TestPrint:
    call    GBPrinter_Detect
    ret     nz
    ; TODO
    ret

; INPUT:  A = data
; OUTPUT: A = response
Serial_SendByte:
    ldh     [rSB],a
    ld      a,%10000001
    ldh     [rSC],a     ; start transfer
.wait
    ldh     a,[rSC]
    bit     7,a         ; is transfer in progress?
    jr      nz,.wait    ; if yes, wait
    ldh     a,[rSB]     ; get return byte
    ret
    