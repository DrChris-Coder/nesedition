;===============================================================================
;                    RetroGameDev NES Edition - gameTanks
;===============================================================================
; Constants

ButtonLeft           = GameportBMask
ButtonRight          = GameportAMask
;ButtonLeft           = GameportLeftMask
;ButtonRight          = GameportRightMask
TankPower            = 20
TankFriction         = 1
PL1TankMaxSpeed      = 125
PL1TankStartSprite   = 1

;===============================================================================
; Subroutines

gameTanksUpdate:
  jsr gameTanksUpdatePositionPL1
  jsr gameTanksUpdateAnimationPL1
  rts

;===============================================================================

gameTanksUpdatePositionPL1:
    ; Initialize Player 1 acceleration to 0
    lda #0
    sta bPL1Acceleration

    ; Check if left press is required
    lda bLeftPressRequired
    beq check_right_press ; Skip to right press check if not required

    ; Left press required
    LIBINPUT_GETBLIP_V ButtonLeft  ; Check for left input
    beq handle_input_end ; Skip if left not pressed
    ; Left was pressed
    lda #0              ; Set left press not required
    sta bLeftPressRequired
    lda #TankPower      ; Load tank power value
    sta bPL1Acceleration ; Apply acceleration based on TankPower
    jmp handle_input_end ; Skip the right press handling

check_right_press:
    ; Check if right press is required
    LIBINPUT_GETBLIP_V ButtonRight ; Check for right input
    beq handle_input_end ; Skip if right not pressed
    ; Right was pressed
    lda #1              ; Set left press required again
    sta bLeftPressRequired
    lda #TankPower      ; Load tank power value
    sta bPL1Acceleration ; Apply acceleration based on TankPower

handle_input_end:

    ; Update Player 1 Velocity
    LIBMATH_ADD8TO16_AAA wPL1Velocity, bPL1Acceleration, wPL1Velocity ; Add acceleration to velocity
    LIBMATH_MIN16BIT_AV wPL1Velocity, PL1TankMaxSpeed ; Clamp velocity to MaxSpeed

    ; Apply Friction to Velocity
    LIBMATH_MAX16BIT_AV wPL1Velocity, TankFriction ; Ensure velocity doesn't go below 0
    LIBMATH_SUB8FROM16_AVA wPL1Velocity, TankFriction, wPL1Velocity ; Subtract friction

    ; Update Bottom Scroll (Player 1's position) 
    LIBMATH_ADD16TO24_AAA wBottomScrollX, wPL1Velocity, wBottomScrollX ; Add velocity to bottom scroll position

    ; Update Top Scroll (Half speed of bottom scroll)
    lda wPL1Velocity
    sta wLibTemp1
    lda wPL1Velocity+1
    sta wLibTemp1+1

    ; Divide velocity by 2
    lsr wLibTemp1+1      ; Shift right the most significant byte
    ror wLibTemp1        ; Rotate right the least significant byte
    
    LIBMATH_ADD16TO24_AAA wTopScrollX, wLibTemp1, wTopScrollX ; Add halved velocity to top scroll

    rts                   ; Return from subroutine

;===============================================================================
    
gameTanksUpdateAnimationPL1:
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+0, $02, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+6, $22, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+7, $24, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+8, $26, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+9, $28, 1
  lda wBottomScrollX+1
  and #%00000010
  beq :++

  lda wPL1Velocity
  beq :+
  ; only set arial to not be upright if velocity > 0
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+0, $0C, 1
:  
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+6, $2C, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+7, $2E, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+8, $30, 1
  LIBSPRITE_SETFRAME8x16_VVV PL1TankStartSprite+9, $32, 1
:
  rts