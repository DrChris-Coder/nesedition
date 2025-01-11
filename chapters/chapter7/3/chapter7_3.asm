;===============================================================================
;                     RetroGameDev NES Edition chapter7_3
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
  ; Variables stored in zero page for faster access
  .include "../../library/libVariables.asm"

;===============================================================================
; RAM Segment
.segment "RAM"
; Defines a RAM segment to avoid assembler warnings in chapters not using FamiStudio.

;===============================================================================
; Code Segment
.segment "CODE"
  ; Include necessary library code for handling screen, math, and sprites
  .include "../../library/libDefines.asm"    ; Includes constants like color codes
  .include "../../library/libMath.asm"       ; Includes math-related functions
  .include "../../library/libScreen.asm"     ; Includes screen management functions
  .include "../../library/libSprite.asm"     ; Includes sprite management functions

;===============================================================================
; Game Initialization
gameMainInit:
  LIBSCREEN_INIT                          ; Initialize the screen and PPU settings

  ; Load background & sprite palettes
  LIBSCREEN_LOADPALETTE_AA BGPALETTE, PaletteBG
  LIBSCREEN_LOADPALETTE_AA SPPALETTE, PaletteSP
  
  ; Load screen data to the left nametable
  LIBSCREEN_LOADNAMETABLE_AA NAMETABLE0, DesertLeft

  ; Load screen data to the right nametable
  LIBSCREEN_LOADNAMETABLE_AA NAMETABLE1, DesertRight

  LIBSPRITE_INIT                          ; Initialize sprites
  LIBSCREEN_SETSPRITESIZE8x16             ; Set sprites to 8x16 pixel mode for larger character sizes
  jsr gameDataSpritesInit                 ; Initialize sprite data for the game
  
  LIBSCREEN_ENABLEPPU                     ; Enable PPU rendering (sprites, background)
  ; No 'rts' (return) here, so the code will flow directly into the main game loop

;===============================================================================
; Main Game Update Loop
gameMainUpdate:
  lda bFrameReady      ; Load the frame-ready flag
  beq gameMainUpdate   ; If frame not ready (bFrameReady = 0), loop and wait

  ; Game logic goes here (currently waiting for sprite 0 hit)
  LIBSCREEN_WAITSPRITE0              ; Wait for sprite 0 hit (sync game events)
  jsr gameMainUpdateBottomScroll     ; Update bottom scroll values

  lda #0               ; Reset the bFrameReady flag back to 0
  sta bFrameReady      ; Prevents game logic from running more than once per frame
  jmp gameMainUpdate   ; Infinite loop - returns to the beginning of the update loop

;===============================================================================
; NMI (Non-Maskable Interrupt) Handler
gameMainNMI:
  LIBSPRITE_UPDATE     ; Update sprites in OAM (Object Attribute Memory)
  jsr gameMainUpdateTopScroll ; Update top scroll values

  lda #1               ; Set bFrameReady flag to 1 to signal the game update loop
  sta bFrameReady      ; Store the flag in memory
  rti                  ; Return from interrupt - graphics update happens after this

;===============================================================================
; Bottom Scroll Update Subroutine
gameMainUpdateBottomScroll:
  ; Add 100 subpixels to the horizontal scroll position every frame
  LIBMATH_ADD8TO24_AVA wBottomScrollX, 100, wBottomScrollX

  ; Set the bottom scroll for the screen (based on the current scroll values)
  LIBSCREEN_SETSCROLL_AA wBottomScrollX+1, wBottomScrollY+1
  rts                    ; Return from subroutine

;===============================================================================
; Top Scroll Update Subroutine
gameMainUpdateTopScroll:
  ; Add 50 subpixels to the horizontal scroll position every frame (half the speed of the bottom)
  LIBMATH_ADD8TO24_AVA wTopScrollX, 50, wTopScrollX

  ; Set the top scroll for the screen (based on the current scroll values)
  LIBSCREEN_SETSCROLL_AA wTopScrollX+1, wTopScrollY+1
  rts                    ; Return from subroutine

;===============================================================================
; Data Segment
  .include "gameData.asm" ; Include external game data (background map, palettes, etc.)

;===============================================================================
; Character Segment (CHR-ROM)
.segment "CHARS"
  ; ROM chars start at PPU address $0000
  .incbin "../../content/tankracebackground.chr"
  .incbin "../../content/tankracesprites.chr"

;===============================================================================
; Interrupt Vectors
.segment "VECTORS"
  ; This segment defines what happens during specific events:
  .word gameMainNMI     ; NMI (VBlank) - triggered every frame to handle graphics
  .word gameMainInit    ; Reset - called when the game is first started
  .word 0               ; IRQ - not used in this simple project
