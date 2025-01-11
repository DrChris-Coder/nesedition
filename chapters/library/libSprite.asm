;===============================================================================
;                     RetroGameDev NES Edition libSprite
;===============================================================================
; Macros

.macro LIBSPRITE_INIT
  ; Set all 64 sprites' Y positions to 255 (off-screen)
  lda #255
  sta bLibTemp2  
  ldx #0
@loop:
  stx bLibTemp1
  LIBSPRITE_SETPOSITIONY_AA bLibTemp1, bLibTemp2
  inx
  cpx #64
  bne @loop
.endmacro

;===============================================================================

.macro LIBSPRITE_SETFRAME8x16_AAV bSprite, bIndex, bPatternTable
  ; Every 4th byte from 1
  lda bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  iny ; +1
  lda bIndex ; Load bIndex
  ora #bPatternTable
  sta SPRITERAM,y ; Set the calculated address to bIndex
.endmacro

;===============================================================================

.macro LIBSPRITE_SETFRAME8x16_VVV bSprite, bIndex, bPatternTable
  ; Every 4th byte from 1
  lda #bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  iny ; +1
  lda #bIndex     ; Load bIndex
  ora #bPatternTable
  sta SPRITERAM,y ; Set the calculated address to bIndex
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPALETTE_AA bSprite, bPalette
  ; Every 4th byte from 2
  lda bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  iny ; +1
  iny ; +2
  lda SPRITERAM,y ; Load from calculated address
  and #%11111100  ; Clear bits 0 & 1
  ora bPalette    ; Merge with bPalette
  sta SPRITERAM,y ; Set back to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPALETTE_VV bSprite, bPalette
  ; Every 4th byte from 2
  lda #bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  iny ; +1
  iny ; +2
  lda SPRITERAM,y ; Load from calculated address
  and #%11111100  ; Clear bits 0 & 1
  ora #bPalette   ; Merge with bPalette
  sta SPRITERAM,y ; Set back to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPOSITIONX_AA bSprite, bXPos
  ; Every 4th byte from 3
  lda bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  iny ; +1
  iny ; +2
  iny ; +3
  lda bXPos           ; Load X position
  sta SPRITERAM,y     ; Set to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPOSITIONX_VV bSprite, bXPos
  ; Every 4th byte from 3
  lda #bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  iny ; +1
  iny ; +2
  iny ; +3
  lda #bXPos          ; Load X position
  sta SPRITERAM,y     ; Set to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPOSITIONY_AA bSprite, bYPos
  ; Every 4th byte from 0
  lda bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  lda bYPos           ; Load Y position
  sta SPRITERAM,y     ; Set to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPOSITIONY_VV bSprite, bYPos
  ; Every 4th byte from 0
  lda #bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  lda #bYPos          ; Load Y position
  sta SPRITERAM,y     ; Set to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_SETPOSITION_AAA bSprite, bXPos, bYPos
  ; Every 4th byte from 0 (Y position)
  lda bSprite
  asl ; Multiply by 2
  asl ; Multiply by 4
  tay
  lda bYPos           ; Load Y position
  sta SPRITERAM,y     ; Set to calculated address
  
  ; Every 4th byte from 3 (X position)
  iny ; +1
  iny ; +2
  iny ; +3
  lda bXPos           ; Load X position
  sta SPRITERAM,y     ; Set to calculated address
.endmacro

;===============================================================================

.macro LIBSPRITE_UPDATE
  lda #>SPRITERAM     ; Load high byte of SPRITERAM address
  sta OAMDMA          ; Trigger OAM DMA to copy sprite data
.endmacro