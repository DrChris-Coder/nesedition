;===============================================================================
;                    RetroGameDev NES Edition - gameFlow
;===============================================================================
; Constants

FlowStateStart    = 0
FlowStateGame     = 1
FlowStatePause    = 2
FlowStateGameOver = 3
FlowPressA_X      = 100
FlowPressA_Y      = 120

;===============================================================================
; Jump Tables

gameFlowJumpTable:
  .word gameFlowUpdateStart
  .word gameFlowUpdateGame
  .word gameFlowUpdatePause
  .word gameFlowUpdateGameOver

;===============================================================================
; Subroutines

gameFlowInit:
  jsr gameFlowLoadGame
  jsr gameDataSpritesInit
  
  lda #255
  sta bGoCountDown ; set the countdown to max 255

  ; reset variables back to 0
  lda #0
  sta wTopScrollX
  sta wTopScrollX+1
  sta wTopScrollX+2
  sta wBottomScrollX
  sta wBottomScrollX+1
  sta wBottomScrollX+2
  sta wCPUTankXPos
  sta wCPUTankXPos+1
  sta wCPUTankXPos+2
  sta wCPUTankScreenXPos
  sta wCPUTankScreenXPos+1
  sta wCPUTankScreenXPos+2
  sta bPL1Acceleration
  sta wPL1Velocity
  sta wCPUAcceleration
  sta wCPUVelocity

  LIBSOUND_MUSICPLAY MUSIC_GAME

  rts

;===============================================================================  

gameFlowUpdate:
  lda bFlowState                  ; Get the current state into A
  asl                             ; Multiply by 2
  tay                             ; Copy A to Y
  lda gameFlowJumpTable,y         ; Lookup low byte
  sta bLibTemp1                   ; Store in a temporary variable
  lda gameFlowJumpTable+1,y       ; Lookup high byte
  sta bLibTemp2                   ; Store in temporary variable+1
  jmp (bLibTemp1)                 ; Indirect jump to subroutine 
  
;===============================================================================

gameFlowUpdateStart:

  lda bGoCountDown

  cmp #250
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $6A, 1 ; $6A = 5
  LIBSOUND_SFXPLAY SFX_COUNTDOWN, FAMISTUDIO_SFX_CH0
:  
  cmp #200
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $68, 1 ; $68 = 4
  LIBSOUND_SFXPLAY SFX_COUNTDOWN, FAMISTUDIO_SFX_CH0
:
  cmp #150
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $66, 1 ; $66 = 3
  LIBSOUND_SFXPLAY SFX_COUNTDOWN, FAMISTUDIO_SFX_CH0
:
  cmp #100
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $64, 1 ; $64 = 2
  LIBSOUND_SFXPLAY SFX_COUNTDOWN, FAMISTUDIO_SFX_CH0
:
  cmp #50
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $62, 1 ; $62 = 1
  LIBSOUND_SFXPLAY SFX_COUNTDOWN, FAMISTUDIO_SFX_CH0
:
  cmp #0
  bne :+
  LIBSOUND_SFXPLAY SFX_COUNTDOWNEND, FAMISTUDIO_SFX_CH0
  
  ; move all sprite y's for level # to $FF
  LIBSPRITE_SETPOSITIONY_VV 54, $FF
  LIBSPRITE_SETPOSITIONY_VV 55, $FF
  LIBSPRITE_SETPOSITIONY_VV 56, $FF
  LIBSPRITE_SETPOSITIONY_VV 57, $FF
  LIBSPRITE_SETPOSITIONY_VV 58, $FF
  LIBSPRITE_SETPOSITIONY_VV 59, $FF
  LIBSPRITE_SETPOSITIONY_VV 60, $FF

  ; move to game state
  lda #FlowStateGame
  sta bFlowState
:
  ; update start state here
  dec bGoCountDown

  rts

;===============================================================================

gameFlowLoadGame:
  LIBSCREEN_DISABLEPPU
     
  ; Load background & sprite palettes
  LIBSCREEN_LOADPALETTE_AA BGPALETTE, PaletteBG
  LIBSCREEN_LOADPALETTE_AA SPPALETTE, PaletteSP

  ; Load screen data to the left nametable
  LIBSCREEN_LOADNAMETABLE_AA NAMETABLE0, DesertLeft

  ; Load screen data to the right nametable
  LIBSCREEN_LOADNAMETABLE_AA NAMETABLE1, DesertRight
  
  LIBSCREEN_ENABLEPPU
  rts  

;===============================================================================

gameFlowUpdateGame:
  LIBINPUT_GETBLIP_V GameportSelectMask
  beq :+

  ; move to pause state
  lda #FlowStatePause
  sta bFlowState
  LIBSOUND_MUSICPAUSE MUSIC_PAUSE
  LIBSOUND_SFXPLAY SFX_BUTTON, FAMISTUDIO_SFX_CH1 ; also stops tank sfx
  rts
:
  ; update game state here
  jsr gameTanksUpdate

  ; check if PL1 reached finish
  lda wBottomScrollX+2 ; the nametable
  cmp #6
  bmi :+

  ; winner
  LIBSOUND_MUSICSTOP
  LIBSOUND_SFXPLAY SFX_WINNER, FAMISTUDIO_SFX_CH0
  jsr gameFlowWinText
  jsr gameFlowButtonText

  ; move to game over state
  lda #FlowStateGameOver
  sta bFlowState
  rts
:
  ; check if CPU reached finish
  lda wCPUTankXPos+2 ; the nametable
  cmp #6
  bmi :+

  ; loser
  LIBSOUND_MUSICSTOP
  LIBSOUND_SFXPLAY SFX_LOSER, FAMISTUDIO_SFX_CH0
  jsr gameFlowLoseText
  jsr gameFlowButtonText

  ; move to game over state
  lda #FlowStateGameOver
  sta bFlowState
:  
  rts

;===============================================================================  

gameFlowUpdatePause:
  LIBINPUT_GETBLIP_V GameportSelectMask
  beq :+
  
  ; move to game state
  lda #FlowStateGame
  sta bFlowState
  LIBSOUND_MUSICPAUSE MUSIC_UNPAUSE
  LIBSOUND_SFXPLAY SFX_BUTTON, FAMISTUDIO_SFX_CH0
:
  rts

;===============================================================================  

gameFlowUpdateGameOver:
  LIBINPUT_GETBLIP_V GameportAMask
  beq :+

  ; move to start state
  lda #FlowStateStart
  sta bFlowState
  jsr gameDataSpritesInit
  jsr gameFlowInit
:    
  rts

;===============================================================================  

gameFlowWinText:
  LIBSPRITE_SETPOSITIONX_VV 54, FlowPressA_X+8     ; w
  LIBSPRITE_SETPOSITIONY_VV 54, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 54, $EE, 1

  LIBSPRITE_SETPOSITIONX_VV 55, FlowPressA_X+16    ; i
  LIBSPRITE_SETPOSITIONY_VV 55, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 55, $D2, 1

  LIBSPRITE_SETPOSITIONX_VV 56, FlowPressA_X+24    ; n
  LIBSPRITE_SETPOSITIONY_VV 56, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 56, $DC, 1

  LIBSPRITE_SETPOSITIONX_VV 57, FlowPressA_X+32    ; n
  LIBSPRITE_SETPOSITIONY_VV 57, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 57, $DC, 1

  LIBSPRITE_SETPOSITIONX_VV 58, FlowPressA_X+40    ; e
  LIBSPRITE_SETPOSITIONY_VV 58, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 58, $CA, 1

  LIBSPRITE_SETPOSITIONX_VV 59, FlowPressA_X+48    ; r
  LIBSPRITE_SETPOSITIONY_VV 59, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 59, $E4, 1
  rts

;===============================================================================

gameFlowLoseText:
  LIBSPRITE_SETPOSITIONX_VV 54, FlowPressA_X+8     ; l
  LIBSPRITE_SETPOSITIONY_VV 54, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 54, $D8, 1

  LIBSPRITE_SETPOSITIONX_VV 55, FlowPressA_X+16    ; o
  LIBSPRITE_SETPOSITIONY_VV 55, FlowPressA_Y-16;
  LIBSPRITE_SETFRAME8x16_VVV 55, $DE, 1

  LIBSPRITE_SETPOSITIONX_VV 56, FlowPressA_X+24    ; s
  LIBSPRITE_SETPOSITIONY_VV 56, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 56, $E6, 1

  LIBSPRITE_SETPOSITIONX_VV 57, FlowPressA_X+32    ; e
  LIBSPRITE_SETPOSITIONY_VV 57, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 57, $CA, 1

  LIBSPRITE_SETPOSITIONX_VV 58, FlowPressA_X+40    ; r
  LIBSPRITE_SETPOSITIONY_VV 58, FlowPressA_Y-16
  LIBSPRITE_SETFRAME8x16_VVV 58, $E4, 1
  rts

;===============================================================================

gameFlowButtonText:
  LIBSPRITE_SETPOSITIONY_VV 41, FlowPressA_Y   ; b
  LIBSPRITE_SETPOSITIONY_VV 42, FlowPressA_Y   ; u
  LIBSPRITE_SETPOSITIONY_VV 43, FlowPressA_Y   ; t
  LIBSPRITE_SETPOSITIONY_VV 44, FlowPressA_Y   ; t
  LIBSPRITE_SETPOSITIONY_VV 45, FlowPressA_Y   ; o
  LIBSPRITE_SETPOSITIONY_VV 46, FlowPressA_Y   ; n
  rts