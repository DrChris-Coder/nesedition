;===============================================================================
;                     RetroGameDev NES Edition chapter1_1
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
  ; Zero Page memory is quicker to access, making it ideal for variables that are 
  ; frequently used in your program.
  .include "../../library/libVariables.asm" ; Include variables (defined in external file)

;===============================================================================
; RAM Segment
.segment "RAM"
; Defines a RAM segment to avoid assembler warnings in chapters not using FamiStudio.

;===============================================================================
; Code Segment
.segment "CODE"
  ; Include essential library functions and constants
  .include "../../library/libDefines.asm"  ; Include color codes and other constants
  .include "../../library/libScreen.asm"   ; Include functions for managing the screen

;===============================================================================
; Game Initialization
gameMainInit:
  LIBSCREEN_INIT                      ; Initialize the screen and PPU settings
  LIBSCREEN_SETBACKGROUNDCOLOR_V RED ; Set background color to RED
  ; Note: You can uncomment the line below to set the background to CYAN instead
  ; jsr gameMainSetBackgroundColor    ; Calls subroutine that sets background to CYAN
  LIBSCREEN_ENABLEPPU ; Enable PPU rendering (sprites, background)
  ; No 'rts' (return) here, so the code will flow directly into the main game loop

;===============================================================================
; Main Game Update Loop
gameMainUpdate:
  lda bFrameReady      ; Load the frame-ready flag
  beq gameMainUpdate   ; If frame not ready (bFrameReady = 0), loop and wait

  ; Game logic would go here (currently empty for this chapter)

  lda #0               ; Reset the bFrameReady flag back to 0
  sta bFrameReady      ; This prevents the game logic from running more than once per frame
  jmp gameMainUpdate   ; Infinite loop - returns to the beginning of the update loop

;===============================================================================
; NMI (Non-Maskable Interrupt) Handler
gameMainNMI:
  lda #1               ; Set bFrameReady flag to 1 to signal the game update loop
  sta bFrameReady      ; Store the flag in memory
  rti                  ; Return from interrupt - graphics update happens after this

;===============================================================================
; Set Background Color Subroutine
gameMainSetBackgroundColor:
  LIBSCREEN_SETPPUADDRESS_A BGPALETTE ; Set PPU address to background palette
  LIBSCREEN_SETPPUDATA_V CYAN         ; Set the first color entry in the palette to Cyan
  rts                                 ; Return from subroutine

;===============================================================================
; Character Segment (CHR-ROM)
.segment "CHARS"
  ; ROM chars start at PPU address $0000
  ; This segment will hold sprite and tile graphics. Currently empty, but will be
  ; filled with graphic data in later chapters.

;===============================================================================
; Interrupt Vectors
.segment "VECTORS"
  ; This segment defines what happens during specific events:
  .word gameMainNMI     ; NMI (VBlank) - triggered every frame to handle graphics
  .word gameMainInit    ; Reset - called when the game is first started
  .word 0               ; IRQ - not used in this simple project