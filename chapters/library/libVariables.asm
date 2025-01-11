;===============================================================================
;                     RetroGameDev NES Edition libVariables
;===============================================================================
; Variables

; Scroll Variables
wBottomScrollX: .word 0 ; 1st byte = subpixels, 2nd byte = pixels
                .byte 0 ; 3rd byte = nametable
wBottomScrollY: .word 0

wTopScrollX:    .word 0 ; 1st byte = subpixels, 2nd byte = pixels
                .byte 0 ; 3rd byte = nametable
wTopScrollY:    .word 0

; Render Flags
bFrameReady:    .byte 0
bLoadRequested: .byte 0
bLoadMenu:      .byte 0
bLoadDesert:    .byte 0

; PPU Register Shadows (used to mirror and track changes to the PPU registers)
PPUCTRL_SHADOW:     .byte 0
PPUMASK_SHADOW:     .byte 0

; Controller Variables
bLibButtons:        .byte 0  ; Current state of controller buttons
bLibButtonsLast:    .byte 0  ; Previous state of controller buttons

; Temporary Variables (used for various calculations)
bLibTemp1:          .byte 0  ; General purpose temp variable (8-bit)
bLibTemp2:          .byte 0  ; General purpose temp variable (8-bit)
bLibTemp3:          .byte 0  ; General purpose temp variable (8-bit)
bLibTemp4:          .byte 0  ; General purpose temp variable (8-bit)
wLibTemp1:          .word 0  ; General purpose temp variable (16-bit)
wLibTemp2:          .word 0  ; General purpose temp variable (16-bit)