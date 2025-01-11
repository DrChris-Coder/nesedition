;===============================================================================
;                     RetroGameDev NES Edition gameData
;===============================================================================
; Constants
Sprite0_X = 8
Sprite0_Y = 162  ; Y position for Sprite 0 on the screen

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
  /* 00-00 */ .byte $FE  ; Sprite 0 tile ID
  /* End flag */ .byte $FF  ; End of sprite tiles array (terminates init loop)

bSpritePalettes:
  /* 00-00 */ .byte $00  ; Palette for Sprite 0

bSpriteXPos:
  /* 00-00 */ .byte Sprite0_X  ; X position for Sprite 0

bSpriteYPos:
  /* 00-00 */ .byte Sprite0_Y  ; Y position for Sprite 0

;===============================================================================
; Sprite Initialization Subroutine

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
