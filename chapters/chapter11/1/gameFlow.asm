;===============================================================================
;                    RetroGameDev NES Edition - gameFlow
;===============================================================================
; Constants

FlowStateStart  = 0
FlowStateGame   = 1
FlowPressA_X    = 100
FlowPressA_Y    = 120

;===============================================================================
; Jump Tables

gameFlowJumpTable:
  .word gameFlowUpdateStart
  .word gameFlowUpdateGame

;===============================================================================
; Subroutines

gameFlowInit:
  jsr gameFlowLoadGame
  jsr gameDataSpritesInit
  
  lda #255
  sta bGoCountDown ; set the countdown to max 255
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
:  
  cmp #200
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $68, 1 ; $68 = 4
:
  cmp #150
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $66, 1 ; $66 = 3
:
  cmp #100
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $64, 1 ; $64 = 2
:
  cmp #50
  bne :+
  LIBSPRITE_SETFRAME8x16_VVV 60, $62, 1 ; $62 = 1
:
  cmp #0
  bne :+
  
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

  lda #0
  sta wTopScrollX
  sta wTopScrollX+1
  sta wTopScrollX+2
  sta wBottomScrollX
  sta wBottomScrollX+1
  sta wBottomScrollX+2
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
  ; update game state here
  jsr gameTanksUpdate
  rts