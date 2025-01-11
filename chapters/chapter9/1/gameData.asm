;===============================================================================
;                     RetroGameDev NES Edition gameData
;===============================================================================
; Constants
Sprite0_X      = 0
Sprite0_Y      = 162
PL1_X = 32
PL1_Y = 187
CPU_X = 32
CPU_Y = 151

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
/* end   */ .byte $FF ; end flag to terminate init loop

bSpritePalettes:
/* 00-00 */ .byte $00 ; Sprite 0
/* 01-11 */ .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ; PL1 Tank
/* 12-22 */ .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; CPU Tank

bSpriteXPos:
/* 00-00 */ .byte Sprite0_X ; Sprite 0
/* 01-11 */ .byte PL1_X+8, PL1_X+16, PL1_X+24, PL1_X+32, PL1_X+40, PL1_X, PL1_X+8, PL1_X+16, PL1_X+24, PL1_X+32, PL1_X+40 ; PL1 Tank
/* 12-22 */ .byte CPU_X+8, CPU_X+16, CPU_X+24, CPU_X+32, CPU_X+40, CPU_X, CPU_X+8, CPU_X+16, CPU_X+24, CPU_X+32, CPU_X+40 ; CPU Tank

bSpriteYPos:
/* 00-00 */ .byte Sprite0_Y ; Sprite 0
/* 01-11 */ .byte PL1_Y, PL1_Y, PL1_Y, PL1_Y, PL1_Y, PL1_Y+16, PL1_Y+16, PL1_Y+16, PL1_Y+16, PL1_Y+16, PL1_Y+16 ; PL1 Tank
/* 12-22 */ .byte CPU_Y, CPU_Y, CPU_Y, CPU_Y, CPU_Y, CPU_Y+16, CPU_Y+16, CPU_Y+16, CPU_Y+16, CPU_Y+16, CPU_Y+16 ; CPU Tank

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