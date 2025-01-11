;===============================================================================
;                     RetroGameDev NES Edition libInput
;===============================================================================
; Constants

; Port Masks (for player input buttons)
GameportRightMask    = %00000001  ; Right D-pad
GameportLeftMask     = %00000010  ; Left D-pad
GameportDownMask     = %00000100  ; Down D-pad
GameportUpMask       = %00001000  ; Up D-pad
GameportStartMask    = %00010000  ; Start button
GameportSelectMask   = %00100000  ; Select button
GameportBMask        = %01000000  ; B button (fire)
GameportAMask        = %10000000  ; A button (jump/confirm)

;===============================================================================
; Macros

.macro LIBINPUT_GETANY
    lda bLibButtonsLast  ; Load the previous button state
    bne @skip            ; If any button was pressed last frame, skip

    lda bLibButtons      ; Load the current button state
    jmp @done            ; Return the current state
@skip:
    lda #0               ; If no buttons were pressed, return 0
@done:
.endmacro

;===============================================================================

.macro LIBINPUT_GETBLIP_V bPortMask
    lda bLibButtonsLast  ; Load the previous button state
    and #bPortMask       ; Mask the previous state
    bne @skip            ; Skip if the button was pressed last frame

    lda bLibButtons      ; Load the current button state
    and #bPortMask       ; Mask the current state
    jmp @done            ; If pressed, skip to done
@skip:
    lda #0               ; Otherwise, set A to 0 (no button press)
@done:
.endmacro

;===============================================================================

.macro LIBINPUT_GET_V bPortMask
    lda bLibButtons      ; Load current button state into A
    and #bPortMask       ; Apply mask to isolate the desired button state
.endmacro

;===============================================================================

.macro LIBINPUT_UPDATE
    lda bLibButtons      ; Store the current state into the last state
    sta bLibButtonsLast

    lda #$01             ; Set the strobe bit to reload button states
    sta JOYPAD1          ; Begin reading from JOYPAD1
    sta bLibButtons      ; Store the state of the A button in bLibButtons
    lsr                  ; Clear A (strobe off)
    sta JOYPAD1          ; Stop button reloading

@loop:
    lda JOYPAD1          ; Read the current button state
    lsr                  ; Shift bit 0 into the carry flag
    rol bLibButtons      ; Rotate carry flag into bLibButtons (bit 0)
    bcc @loop            ; Repeat for all 8 buttons
.endmacro