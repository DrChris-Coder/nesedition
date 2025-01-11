;===============================================================================
;                     RetroGameDev NES Edition chapter12_1
;===============================================================================
; NES ROM Header
.segment "HEADER"
  .byte "NES"           ; 'NES' identifier - tells the system it's a valid NES ROM
  .byte $1a             ; Control byte for NES compatibility
  .byte 2               ; Number of 16KB PRG-ROM banks (2 x 16KB = 32KB of code)
  .byte 1               ; Number of 8KB CHR-ROM banks (1 x 8KB = 8KB of graphics)
  .byte 1 | (0 << 4)    ; Vertical mirroring
  .byte 0 & $f0         ; Using mapper 0 (no extra memory mappers)
  .byte 0,0,0,0,0,0,0,0 ; Padding bytes to complete the header

;===============================================================================
; Zero Page Segment
.segment "ZEROPAGE"
; The zero page is a special area of memory that's faster for the CPU to access.
  ; Variables
  .include "../../library/libVariables.asm"
  .include "gameVariables.asm"

;===============================================================================
.segment "CODE"
  ; Include library code and definitions
  .include "../../library/libDefines.asm"  ; This file includes constants like color codes
  .include "../../library/libInput.asm"    ; This file includes functions to handle player input
  .include "../../library/libMath.asm"     ; This file includes math-related functions
  .include "../../library/libScreen.asm"   ; This file includes functions to manage the screen
  .include "../../library/libSprite.asm"   ; This file includes functions to manage sprites
  .include "../../library/libSound.asm"    ; This file includes functions to manage music & sfx

  ; Include game code
  .include "gameTanks.asm"
  .include "gameFlow.asm"

;===============================================================================
; Game Initialization
gameMainInit:
  LIBSCREEN_INIT                      ; Initialize the screen and PPU
  LIBSPRITE_INIT                          ; Initialize sprites
  LIBSCREEN_SETSPRITESIZE8x16             ; Set sprites to 8x16 pixel mode for larger character sizes
  LIBSCREEN_LEFT8PIXELSSPRITESDISABLE     ; Disable sprite rendering in the leftmost 8 pixels of the screen
  LIBSOUND_INIT music_data_music, sounds  ; Initialize the music and sound effects for the game
  jsr gameFlowInit                        ; Initialize game flow for the game
  ; note no rts here so that code flows straight into gameMainUpdate

;===============================================================================
; gameMain Game Update Loop
gameMainUpdate:
  lda bFrameReady ; Load the bFrameReady flag
  beq gameMainUpdate  ; If it's 0, keep waiting (loop)

  ; game code
  LIBINPUT_UPDATE       ; update input
  jsr gameFlowUpdate    ; Update the game flow subroutines
  LIBSCREEN_WAITSPRITE0 ; wait for sprite 0 hit
  jsr gameMainUpdateBottomScroll

  lda #0          ; Reset bFrameReady to 0
  sta bFrameReady
  jmp gameMainUpdate  ; Infinite loop

;===============================================================================
; NMI (Vertical Blank) Interrupt Handler
gameMainNMI:
  LIBSPRITE_UPDATE ; update sprites oam

  jsr gameMainUpdateTopScroll

  jsr famistudio_update ; update the sound engine

  lda #1 ; Set bFrameReady flag to 1
  sta bFrameReady
  rti  ; Return from interrupt (used to update graphics once per frame)

;===============================================================================

gameMainUpdateBottomScroll:
  ; Set the scroll for the bottom of the screen
  LIBSCREEN_SETSCROLL_AA wBottomScrollX+1, wBottomScrollY+1
  rts

;===============================================================================

gameMainUpdateTopScroll:
  ; Set the scroll for the top of the screen
  LIBSCREEN_SETSCROLL_AA wTopScrollX+1, wTopScrollY+1
  rts

;===============================================================================
; Data
  .include "gameData.asm"

;===============================================================================
; Character Segment (CHR-ROM)
.segment "CHARS"
  ; ROM chars start at PPU address $0000
  .incbin "../../content/tankracebackground.chr"
  .incbin "../../content/tankracesprites.chr"

;===============================================================================
; Interrupt Vectors
.segment "VECTORS" ; This section tells the NES where to jump on specific events.
  .word gameMainNMI    ; NMI (Non-Maskable Interrupt) - triggers once per frame, jump to vblank
  .word gameMainInit   ; Reset - when the system starts, jump to gameMainInit
  .word 0          ; IRQ - Not used in this project