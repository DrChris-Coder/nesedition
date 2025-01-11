;===============================================================================
;                     RetroGameDev NES Edition chapter2_1
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
result: .byte 0           ; Temporary result storage

;===============================================================================
; RAM Segment
.segment "RAM"
; Defines a RAM segment to avoid assembler warnings in chapters not using FamiStudio.

;===============================================================================
; Code Segment
.segment "CODE"

; Macro definition
.macro IncrementMacro address
  lda address             ; Load value from address
  clc                     ; Clear carry before addition
  adc #$01                ; Add 1 to the value
  sta address             ; Store result back in address
.endmacro

gameMainInit:
  sei                     ; Disable interrupts for stable environment
  cld                     ; Clear decimal mode

  ; Load, Store, Arithmetic, and Stack
  lda #$05                ; Load 5 into A
  sta result              ; Store A into result (Zero Page)
  pha                     ; Push A onto stack
  lda #$10                ; Load 16 into A
  adc result              ; Add result (5) to A
  pla                     ; Pull previous value (5) from stack into A

  ; Branching and Loop
  ldx #$03                ; Loop 3 times
loopStart:
  jsr IncrementSubroutine ; Call subroutine
  dex                     ; Decrement X
  bne loopStart           ; Repeat until X = 0

  ; Addressing Modes and Macros
  lda #$12                ; Immediate mode: Load 18
  sta $0200               ; Absolute mode: Store at $0200
  ldx #$02                ; Load 2 into X
  lda $0200, X            ; Indexed mode: Load from $0202
  IncrementMacro result   ; Use macro to increment result

infiniteLoop:
  jmp infiniteLoop        ; Loop indefinitely to allow inspection

IncrementSubroutine:
  lda result              ; Load current result
  clc                     ; Clear carry
  adc #$02                ; Add 2 to result
  sta result              ; Store updated result
  rts                     ; Return from subroutine

;===============================================================================

.segment "CHARS"
.segment "VECTORS"
  .word 0
  .word gameMainInit
  .word 0