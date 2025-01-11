;===============================================================================
;                    RetroGameDev NES Edition - gameVariables
;===============================================================================
; Variables

bLeftPressRequired: .byte 0
bPL1Acceleration:   .byte 0
wPL1Velocity:       .word 0
wCPUAcceleration:   .word 0
wCPUVelocity:       .word 0
wCPUTankXPos:       .word 0 ; 1st byte = subpixels, 2nd byte = pixels
                    .byte 0 ; 3rd byte = nametable
wCPUTankScreenXPos: .word 0 ; 1st byte = subpixels, 2nd byte = pixels
                    .byte 0 ; 3rd byte = nametable
bFlowState:         .byte 0
bGoCountDown:       .byte 0                    