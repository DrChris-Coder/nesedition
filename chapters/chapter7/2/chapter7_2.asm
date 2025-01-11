;===============================================================================
;                     RetroGameDev NES Edition chapter7_2
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

;===============================================================================
; Game Initialization
gameMainInit:
  LIBSCREEN_INIT                         ; Initialize the screen and PPU settings

  ; Load background palette
  LIBSCREEN_LOADPALETTE_AA BGPALETTE, PaletteBG
  
  ; Load screen data to the left nametable
  LIBSCREEN_LOADNAMETABLE_AA NAMETABLE0, DesertLeft

  ; Load screen data to the right nametable
  LIBSCREEN_LOADNAMETABLE_AA NAMETABLE1, DesertRight
  
  LIBSCREEN_ENABLEPPU                    ; Enable PPU rendering (sprites, background)
  ; No 'rts' (return) here, so the code will flow directly into the main game loop

;===============================================================================
; Main Game Update Loop
gameMainUpdate:
  lda bFrameReady      ; Load the frame-ready flag
  beq gameMainUpdate   ; If frame not ready (bFrameReady = 0), loop and wait

  ; Game logic goes here (currently empty for this section)

  lda #0               ; Reset the bFrameReady flag back to 0
  sta bFrameReady      ; This prevents the game logic from running more than once per frame
  jmp gameMainUpdate   ; Infinite loop - returns to the beginning of the update loop

;===============================================================================
; NMI (Non-Maskable Interrupt) Handler
gameMainNMI:
  jsr gameMainUpdateBottomScroll ; Update bottom scroll

  lda #1                 ; Set bFrameReady flag to 1 to signal the game update loop
  sta bFrameReady        ; Store the flag in memory
  rti                    ; Return from interrupt - graphics update happens after this

;===============================================================================
; Update Bottom Scroll Subroutine
gameMainUpdateBottomScroll:
  ; Add 100 subpixels to the horizontal scroll position every frame
  LIBMATH_ADD8TO24_AVA wBottomScrollX, 100, wBottomScrollX

  ; Set the bottom scroll for the screen (based on the current scroll values)
  LIBSCREEN_SETSCROLL_AA wBottomScrollX+1, wBottomScrollY+1
  rts                    ; Return from subroutine

;===============================================================================
; Data Segment
  .include "gameData.asm" ; Include external game data (background map, palettes, etc.)

;===============================================================================
; Character Segment (CHR-ROM)
.segment "CHARS"
  ; ROM chars start at PPU address $0000
  .incbin "../../content/tankracebackground.chr"

;===============================================================================
; Interrupt Vectors
.segment "VECTORS"
  ; This segment defines what happens during specific events:
  .word gameMainNMI     ; NMI (VBlank) - triggered every frame to handle graphics
  .word gameMainInit    ; Reset - called when the game is first started
  .word 0               ; IRQ - not used in this simple project
