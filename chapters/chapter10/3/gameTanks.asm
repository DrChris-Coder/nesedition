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
PL1HUDSprite         = 40
CPUTankMaxSpeed      = 120
CPUTankStartSprite   = 12
CPUTankEndSprite     = 24
CPUHUDSprite         = 39

;===============================================================================
; Subroutines

gameTanksUpdate:
  ; Update the player
  jsr gameTanksUpdatePositionPL1
  jsr gameTanksUpdateAnimationPL1
  jsr gameTanksUpdatePowerPL1
  jsr gameTanksUpdateHUDPL1

  ; Update the CPU
  jsr gameTanksUpdatePositionCPU
  jsr gameTanksUpdateAnimationCPU
  jsr gameTanksUpdateHUDCPU
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

;-------------------------------------------------------------------------------
; Subroutine: gameTanksUpdatePowerPL1
; Updates the power bar display for Player 1 by changing the palette of sprites
; 27 to 31 based on Player 1's velocity.
; - The power bar is initially red, and turns green as the player's power increases.
;-------------------------------------------------------------------------------

gameTanksUpdatePowerPL1:
  ; Set all power bar sprites (27-31) to red initially (palette 3 = red)
  LIBSPRITE_SETPALETTE_VV 27, 3   ; Set sprite 27 to red
  LIBSPRITE_SETPALETTE_VV 28, 3   ; Set sprite 28 to red
  LIBSPRITE_SETPALETTE_VV 29, 3   ; Set sprite 29 to red
  LIBSPRITE_SETPALETTE_VV 30, 3   ; Set sprite 30 to red
  LIBSPRITE_SETPALETTE_VV 31, 3   ; Set sprite 31 to red

  ; Get Player 1's velocity
  ldx wPL1Velocity

  ; If velocity >= TankPower*2, change sprite 27 to green
  cpx #(TankPower*2)
  bcc @update_done                 ; If velocity < TankPower*2, no need to update
  LIBSPRITE_SETPALETTE_VV 27, 1    ; Set sprite 27 to green

  ; If velocity >= TankPower*3, change sprite 28 to green
  cpx #(TankPower*3)
  bcc @update_done
  LIBSPRITE_SETPALETTE_VV 28, 1    ; Set sprite 28 to green

  ; If velocity >= TankPower*4, change sprite 29 to green
  cpx #(TankPower*4)
  bcc @update_done
  LIBSPRITE_SETPALETTE_VV 29, 1    ; Set sprite 29 to green

  ; If velocity >= TankPower*5, change sprite 30 to green
  cpx #(TankPower*5)
  bcc @update_done
  LIBSPRITE_SETPALETTE_VV 30, 1    ; Set sprite 30 to green

  ; If velocity >= TankPower*6, change sprite 31 to green
  cpx #(TankPower*6)
  bcc @update_done
  LIBSPRITE_SETPALETTE_VV 31, 1    ; Set sprite 31 to green

@update_done:
  rts                              ; Return from subroutine

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

;===============================================================================

gameTanksUpdatePositionCPU:
    ; Update CPU Tank Acceleration
    ; Add TankPower to CPU acceleration
    LIBMATH_ADD8TO16_AVA wCPUAcceleration, TankPower, wCPUAcceleration
    
    ; Clamp CPU acceleration to a maximum of TankPower * 256
    LIBMATH_MIN16BIT_AV wCPUAcceleration, (TankPower * 256)

    ; Update CPU Tank Velocity
    ; Add acceleration to velocity (velocity = velocity + acceleration)
    LIBMATH_ADD8TO16_AAA wCPUVelocity, wCPUAcceleration+1, wCPUVelocity
    
    ; Clamp velocity to maximum speed (CPUTankMaxSpeed)
    LIBMATH_MIN16BIT_AV wCPUVelocity, CPUTankMaxSpeed

    ; Apply Friction
    ; Ensure velocity doesn't go below 0 due to friction
    LIBMATH_MAX16BIT_AV wCPUVelocity, TankFriction

    ; Subtract friction from velocity
    LIBMATH_SUB8FROM16_AVA wCPUVelocity, TankFriction, wCPUVelocity

    ; Update CPU Tank Position
    ; Update the 24-bit position using velocity (subpixels, pixels, nametable)
    LIBMATH_ADD16TO24_AAA wCPUTankXPos, wCPUVelocity, wCPUTankXPos

    ; Update CPU Tank Sprites (handling 8x16 sprites)
    ldx #CPUTankStartSprite    ; Start at the first CPU tank sprite

@loop:
    stx bLibTemp1              ; Store the current sprite number

    ; Calculate X Position of the Sprite
    ; Subtract the bottom scroll position from the tank's position
    LIBMATH_SUB24FROM24_AAA wCPUTankXPos, wBottomScrollX, wCPUTankScreenXPos

    ; Load the result into wLibTemp1 (sprite X position)
    lda wCPUTankScreenXPos+1
    sta wLibTemp1
    lda wCPUTankScreenXPos+2
    sta wLibTemp1+1

    ; Add the sprite X offset (indexed by sprite number)
    lda bSpriteXOffset, x
    sta wLibTemp2
    lda #0                     ; Clear the high byte of the offset
    sta wLibTemp2+1
    LIBMATH_ADD16TO16_AAA wLibTemp1, wLibTemp2, wLibTemp1

    ; Add CPU_X to adjust for the CPU's base X position
    LIBMATH_ADD16TO16_AVA wLibTemp1, CPU_X, wLibTemp1

    ; Calculate Y Position of the Sprite
    ; Get the Y offset (indexed by sprite number)
    lda bSpriteYOffset, x
    sta bLibTemp2

    ; Add the base Y position (CPU_Y)
    LIBMATH_ADD8TO8_AVA bLibTemp2, CPU_Y, bLibTemp2

    ; Clipping - If sprite x not on the same nametable page as scroll then set y to 255
    lda wLibTemp1+1
    beq @noclip
    lda #$FF
    sta bLibTemp2
@noclip:

    ; Set Sprite X and Y Positions
    ; Set the calculated sprite positions (X and Y)
    LIBSPRITE_SETPOSITION_AAA bLibTemp1, wLibTemp1, bLibTemp2

    ; Increment Loop Counter
    inx                        ; Increment sprite number (for next sprite)
    cpx #CPUTankEndSprite+1    ; Check if all sprites have been processed
    bne @loop                  ; If not, repeat the loop for the next sprite

    rts                        ; Return from subroutine

;===============================================================================
    
gameTanksUpdateAnimationCPU:
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+0, $02, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+6, $22, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+7, $24, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+8, $26, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+9, $28, 1
  lda wCPUTankXPos+1
  and #%00000010
  beq :++

  lda wCPUVelocity
  beq :+
  ; only set arial to not be upright if velocity > 0
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+0, $0C, 1
:  
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+6, $2C, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+7, $2E, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+8, $30, 1
  LIBSPRITE_SETFRAME8x16_VVV CPUTankStartSprite+9, $32, 1
:
  rts

;===============================================================================

gameTanksUpdateHUDPL1:
  ; Set sprite number
  ldx #PL1HUDSprite
  stx bLibTemp1

  ; load in the bottom scroll 16 bit position
  lda wBottomScrollX+1
  sta wLibTemp1
  lda wBottomScrollX+2
  sta wLibTemp1+1

  ; divided by 2
  lsr wLibTemp1+1
  ror wLibTemp1 

  ; divided by 4
  lsr wLibTemp1+1
  ror wLibTemp1 

  ; divided by 8
  lsr wLibTemp1+1
  ror wLibTemp1

  ; add hudx start offset
  LIBMATH_ADD8TO8_AVA wLibTemp1, HUD_X, wLibTemp1
  
  ; set sprite x position
  LIBSPRITE_SETPOSITIONX_AA bLibTemp1, wLibTemp1
  rts

;===============================================================================  

gameTanksUpdateHUDCPU: 
  ; Set sprite number
  ldx #CPUHUDSprite
  stx bLibTemp1

  ; load in the bottom scroll 16 bit position
  lda wCPUTankXPos+1
  sta wLibTemp1
  lda wCPUTankXPos+2
  sta wLibTemp1+1

  ; divided by 2
  lsr wLibTemp1+1
  ror wLibTemp1 

  ; divided by 4
  lsr wLibTemp1+1
  ror wLibTemp1 

  ; divided by 8
  lsr wLibTemp1+1
  ror wLibTemp1

  ; add hudx start offset
  LIBMATH_ADD8TO8_AVA wLibTemp1, HUD_X, wLibTemp1
  
  ; set sprite x position
  LIBSPRITE_SETPOSITIONX_AA bLibTemp1, wLibTemp1
  rts