;===============================================================================
;                     RetroGameDev NES Edition gameData
;===============================================================================
; Constants
Sprite0_X = 8
Sprite0_Y = 162
PL1_X     = 32
PL1_Y     = 187
CPU_X     = 32
CPU_Y     = 152
HUD_X     = 28
HUD_Y     = 5
HUD_WIDTH = 32

;===============================================================================
; Palette Data
PaletteBG:
  .incbin "../../content/tankracebackground.pal"

PaletteSP:
  .incbin "../../content/tankracesprites.pal"  

;===============================================================================
; Screen Data
DesertLeft:
  .incbin "../../content/tankracedesertleft.nam"

DesertRight:
  .incbin "../../content/tankracedesertright.nam"

;===============================================================================
; Sprite Data

bSpriteTiles:
/* 00-00 */ .byte $FE ; Sprite 0
/* 01-11 */ .byte $02, $04, $06, $08, $0a, $20, $22, $24, $26, $28, $2A ; PL1 Tank
/* 12-22 */ .byte $02, $04, $06, $08, $0a, $20, $22, $24, $26, $28, $2A ; CPU Tank
/* 23-24 */ .byte $12, $14                                              ; CPU Label
/* 25-26 */ .byte $0E, $10                                              ; PL1 Label
/* 27-31 */ .byte $16, $16, $16, $16, $16                               ; PL1 Power bar
/* 32-38 */ .byte $1A, $18, $18, $18, $18, $18, $1A                     ; HUD bar
/* 39-40 */ .byte $1C, $1C                                              ; HUD markers
/* 41-46 */ .byte $E0, $E4, $CA, $E6, $E6, $36                          ; press A
/* 47-53 */ .byte $E8, $DE, $E6, $E8, $C2, $E4, $E8                     ; to start
/* 54-60 */ .byte $D8, $CA, $EC, $CA, $D8, $62, $6A                     ; Level number & countdown number or you win/lose
/* end   */ .byte $FF ; end flag to terminate init loop

bSpritePalettes:
/* 00-00 */ .byte $00 ; Sprite 0
/* 01-11 */ .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ; PL1 Tank
/* 12-22 */ .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; CPU Tank
/* 23-24 */ .byte $02, $02                                              ; CPU Label
/* 25-26 */ .byte $02, $02                                              ; PL1 Label
/* 27-31 */ .byte $03, $03, $03, $03, $03                               ; PL1 Power bar
/* 32-38 */ .byte $01, $00, $00, $00, $00, $00, $02                     ; HUD bar
/* 39-40 */ .byte $00, $01                                              ; HUD markers
/* 41-46 */ .byte $02, $02, $02, $02, $02, $02                          ; press A
/* 47-53 */ .byte $02, $02, $02, $02, $02, $02, $02                     ; to start
/* 54-60 */ .byte $02, $02, $02, $02, $02, $02, $02                     ; Level number & countdown number or you win/lose   

bSpriteXPos:
/* 00-00 */ .byte Sprite0_X ; Sprite 0
/* 01-11 */ .byte PL1_X+8, PL1_X+16, PL1_X+24, PL1_X+32, PL1_X+40, PL1_X, PL1_X+8, PL1_X+16, PL1_X+24, PL1_X+32, PL1_X+40 ; PL1 Tank
/* 12-22 */ .byte CPU_X+8, CPU_X+16, CPU_X+24, CPU_X+32, CPU_X+40, CPU_X, CPU_X+8, CPU_X+16, CPU_X+24, CPU_X+32, CPU_X+40 ; CPU Tank
/* 23-24 */ .byte CPU_X+16, CPU_X+24 ; CPU Label
/* 25-26 */ .byte PL1_X+16, PL1_X+24 ; PL1 Label
/* 27-31 */ .byte PL1_X+3,  PL1_X+11, PL1_X+19, PL1_X+27, PL1_X+35 ; PL1 Power bar
/* 32-38 */ .byte HUD_X, HUD_X+(HUD_WIDTH*1), HUD_X+(HUD_WIDTH*2), HUD_X+(HUD_WIDTH*3), HUD_X+(HUD_WIDTH*4), HUD_X+(HUD_WIDTH*5), HUD_X+(HUD_WIDTH*6) ; HUD bar
/* 39-40 */ .byte HUD_X, HUD_X ; HUD markers
/* 41-46 */ .byte FlowPressA_X+4, FlowPressA_X+12, FlowPressA_X+20, FlowPressA_X+28, FlowPressA_X+36, FlowPressA_X+52 ; press A
/* 47-53 */ .byte FlowPressA_X+0, FlowPressA_X+8, FlowPressA_X+24, FlowPressA_X+32, FlowPressA_X+40, FlowPressA_X+48, FlowPressA_X+56 ; to start
/* 54-60 */ .byte FlowPressA_X+4, FlowPressA_X+12, FlowPressA_X+20, FlowPressA_X+28, FlowPressA_X+36, FlowPressA_X+52, FlowPressA_X+28 ; Level number & countdown number or you win/lose

bSpriteYPos:
/* 00-00 */ .byte Sprite0_Y ; Sprite 0
/* 01-11 */ .byte PL1_Y, PL1_Y, PL1_Y, PL1_Y, PL1_Y, PL1_Y+16, PL1_Y+16, PL1_Y+16, PL1_Y+16, PL1_Y+16, PL1_Y+16 ; PL1 Tank
/* 12-22 */ .byte CPU_Y, CPU_Y, CPU_Y, CPU_Y, CPU_Y, CPU_Y+16, CPU_Y+16, CPU_Y+16, CPU_Y+16, CPU_Y+16, CPU_Y+16 ; CPU Tank
/* 23-24 */ .byte CPU_Y, CPU_Y ; CPU Label
/* 25-26 */ .byte PL1_Y, PL1_Y ; PL1 Label
/* 27-31 */ .byte PL1_Y+30, PL1_Y+30, PL1_Y+30, PL1_Y+30, PL1_Y+30 ; PL1 Power bar
/* 32-38 */ .byte HUD_Y, HUD_Y, HUD_Y, HUD_Y, HUD_Y, HUD_Y, HUD_Y ; HUD bar
/* 39-40 */ .byte HUD_Y+3, HUD_Y+12 ; HUD markers
/* 41-46 */ .byte $FF, $FF, $FF, $FF, $FF, $FF ; press A
/* 47-53 */ .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF ; to start
/* 54-60 */ .byte FlowPressA_Y, FlowPressA_Y, FlowPressA_Y, FlowPressA_Y, FlowPressA_Y, FlowPressA_Y, FlowPressA_Y+24 ; Level number & countdown number or you win/lose

bSpriteXOffset:
/* 00-00 */ .byte 0 ; Not used
/* 01-11 */ .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Not used
/* 12-22 */ .byte 8, 16, 24, 32, 40, 0, 8, 16, 24, 32, 40 ; CPU Tank X Offsets
/* 23-24 */ .byte 16, 24 ; CPU Label X Offsets

bSpriteYOffset:
/* 00-00 */ .byte 0 ; Not used
/* 01-11 */ .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Not used
/* 12-22 */ .byte 0, 0, 0, 0, 0, 16, 16, 16, 16, 16, 16 ; CPU Tank Y Offsets
/* 23-24 */ .byte 0, 0 ; CPU Label Y Offsets

;===============================================================================

gameDataSpritesInit:
  ldx #0                 ; Initialize X register to 0 (starting index for sprites)
sprite_loop:
  stx bLibTemp1          ; Store sprite index in bLibTemp1 (used for sprite number)
  
  ; Set sprite pattern tile
  lda bSpriteTiles, x     ; Load sprite tile from array based on X index
  cmp #$FF                ; Check if tile is the terminator ($FF)
  beq sprite_done         ; If it's $FF, exit the loop
  sta bLibTemp2           ; Store tile in bLibTemp2 for later use
  LIBSPRITE_SETFRAME8x16_AAV bLibTemp1, bLibTemp2, 1 ; Set the sprite frame to 8x16 mode

  ; Set sprite palette
  lda bSpritePalettes, x  ; Load sprite palette from array based on X index
  sta bLibTemp2           ; Store palette in bLibTemp2
  LIBSPRITE_SETPALETTE_AA bLibTemp1, bLibTemp2 ; Set sprite palette

  ; Set sprite X and Y position
  lda bSpriteXPos, x      ; Load X position from array
  sta bLibTemp2           ; Store X position in bLibTemp2
  lda bSpriteYPos, x      ; Load Y position from array
  sta bLibTemp3           ; Store Y position in bLibTemp3
  LIBSPRITE_SETPOSITION_AAA bLibTemp1, bLibTemp2, bLibTemp3 ; Set sprite position (X, Y)

  inx                     ; Increment X to move to the next sprite
  jmp sprite_loop         ; Repeat the loop for the next sprite

sprite_done:
  rts                     ; Return from subroutine