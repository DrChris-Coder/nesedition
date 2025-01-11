;===============================================================================
;                    RetroGameDev NES Edition - gameTanks
;===============================================================================
; Main Tank Update Subroutine
gameTanksUpdate:
  jsr gameTanksUpdatePositionPL1  ; Update the position of Player 1's tank
  rts                             ; Return from subroutine

;===============================================================================
; Player 1 Tank Position Update
; This subroutine checks for input to move Player 1's tank and updates the
; screen scroll values accordingly.
gameTanksUpdatePositionPL1:
  LIBINPUT_GET_V(GameportRightMask) ; Check if the right D-pad button is pressed
  beq no_movement                    ; If not pressed, skip position update

  ; If the player pressed right, update the tank position and scroll

  ; Update scroll variables
  ; 24-bit number for scroll positions (split into subpixel, pixel, and nametable)
  ; 8 bits for subpixel, 8 bits for pixel, and 1 bit for nametable (X scrolling)

  ; Add 50 subpixels per frame for the top scroll
  LIBMATH_ADD8TO24_AVA wTopScrollX, 50, wTopScrollX

  ; Add 100 subpixels per frame for the bottom scroll
  LIBMATH_ADD8TO24_AVA wBottomScrollX, 100, wBottomScrollX

no_movement:
  rts                               ; Return from subroutine
