;===============================================================================
;                     RetroGameDev NES Edition libMath
;===============================================================================
; Macros

.macro LIBMATH_ADD8TO8_AAA num1_8, num2_8, sum8
  clc                 ; Clear carry before addition
  lda num1_8          ; Load the first 8-bit value
  adc num2_8          ; Add the second 8-bit value
  sta sum8            ; Store the result in sum8
.endmacro

;===============================================================================

.macro LIBMATH_ADD8TO8_AVA num1_8, num2_8, sum8
  clc                 ; Clear carry before addition
  lda num1_8          ; Load the first 8-bit value
  adc #num2_8         ; Add the 8-bit immediate value
  sta sum8            ; Store the result in sum8
.endmacro

;===============================================================================

.macro LIBMATH_ADD8TO16_AAA num16, num8, sum16
  clc                 ; Clear carry before the addition
  lda num16           ; Load the LSB of the 16-bit number
  adc num8            ; Add the 8-bit number to it
  sta sum16           ; Store the result in the LSB of sum16

  lda num16+1         ; Load the MSB of the 16-bit number
  adc #0              ; Add carry (if any) from the LSB addition
  sta sum16+1         ; Store the result in the MSB of sum16
.endmacro

;===============================================================================

.macro LIBMATH_ADD8TO16_AVA num16, num8, sum16
  clc                 ; Clear carry before the addition
  lda num16           ; Load the LSB of the 16-bit number
  adc #num8           ; Add the 8-bit immediate value
  sta sum16           ; Store the result in the LSB of sum16

  lda num16+1         ; Load the MSB of the 16-bit number
  adc #0              ; Add carry (if any) from the LSB addition
  sta sum16+1         ; Store the result in the MSB of sum16
.endmacro

;===============================================================================

.macro LIBMATH_ADD8TO24_AAA num24, num8, sum24
  clc                 ; Clear carry before the addition
  lda num24           ; Load the LSB of the 24-bit number
  adc num8            ; Add the 8-bit number to it
  sta sum24           ; Store the result in the LSB of sum24

  lda num24+1         ; Load the middle byte of the 24-bit number
  adc #0              ; Add carry (if any) from the LSB addition
  sta sum24+1         ; Store the result in the middle byte of sum24

  lda num24+2         ; Load the MSB of the 24-bit number
  adc #0              ; Add carry (if any)
  sta sum24+2         ; Store the result in the MSB of sum24
.endmacro

;===============================================================================

.macro LIBMATH_ADD8TO24_AVA num24, num8, sum24
  clc                 ; Clear carry before the addition
  lda num24           ; Load the LSB of the 24-bit number
  adc #num8           ; Add the 8-bit immediate value to it
  sta sum24           ; Store the result in the LSB of sum24

  lda num24+1         ; Load the middle byte of the 24-bit number
  adc #0              ; Add carry (if any)
  sta sum24+1         ; Store the result in the middle byte of sum24

  lda num24+2         ; Load the MSB of the 24-bit number
  adc #0              ; Add carry (if any)
  sta sum24+2         ; Store the result in the MSB of sum24
.endmacro

;===============================================================================

.macro LIBMATH_ADD16TO16_AAA num1_16, num2_16, sum16
  clc                 ; Clear carry before the addition
  lda num1_16         ; Load the LSB of the first 16-bit number
  adc num2_16         ; Add the LSB of the second 16-bit number
  sta sum16           ; Store the result in the LSB of sum16

  lda num1_16+1       ; Load the MSB of the first 16-bit number
  adc num2_16+1       ; Add the MSB of the second 16-bit number (with carry)
  sta sum16+1         ; Store the result in the MSB of sum16
.endmacro

;===============================================================================

.macro LIBMATH_ADD16TO16_AVA num1_16, num2_16, sum16
  clc                 ; Clear carry before the addition

  ; Add the least significant byte (LSB)
  lda num1_16         ; Load LSB of num1_16
  adc #<num2_16       ; Add the LSB of the 16-bit immediate value
  sta sum16           ; Store the result in LSB of sum16

  ; Add the most significant byte (MSB)
  lda num1_16+1       ; Load MSB of num1_16
  adc #>num2_16       ; Add the MSB of the 16-bit immediate value
  sta sum16+1         ; Store the result in MSB of sum16
.endmacro

;===============================================================================

.macro LIBMATH_ADD16TO24_AAA num16, num24, sum24
  clc                      ; Clear carry before first addition

  ; Add the low byte of the 16-bit number to the low byte of the 24-bit number
  lda num16                ; Load the LSB of the 16-bit number
  adc num24                ; Add to the LSB of the 24-bit number
  sta sum24                ; Store the result in the LSB of sum24

  ; Add the high byte of the 16-bit number to the middle byte of the 24-bit number
  lda num16+1              ; Load the MSB of the 16-bit number
  adc num24+1              ; Add to the middle byte of the 24-bit number (with carry)
  sta sum24+1              ; Store the result in the middle byte of sum24

  ; Add carry to the highest byte of the 24-bit number
  lda sum24+2              ; Load the highest byte of the 24-bit sum
  adc #0                   ; Add carry from the previous addition
  sta sum24+2              ; Store the result in the highest byte of sum24
.endmacro

;===============================================================================

.macro LIBMATH_ADD16TO24_AVA num24, num16, sum24
  clc                      ; Clear carry before the addition

  ; Add the low byte of the 16-bit immediate value to the low byte of the 24-bit value
  lda num24                ; Load the LSB of the 24-bit value
  adc #<num16              ; Add the LSB of the 16-bit immediate value
  sta sum24                ; Store the result in the LSB of sum24

  ; Add the high byte of the 16-bit immediate value to the middle byte of the 24-bit value
  lda num24+1              ; Load the middle byte of the 24-bit value
  adc #>num16              ; Add the MSB of the 16-bit immediate value
  sta sum24+1              ; Store the result in the middle byte of sum24

  ; Add carry to the highest byte of the 24-bit number
  lda num24+2              ; Load the highest byte of the 24-bit value
  adc #0                   ; Add carry from the previous addition
  sta sum24+2              ; Store the result in the highest byte of sum24
.endmacro

;===============================================================================

.macro LIBMATH_MAX16BIT_AV num1, num2
  ; High byte comparison
  lda #>num2          ; Load high byte of num2
  cmp num1+1          ; Compare with high byte of num1
  bcc @end            ; If num2 < num1, skip to the end

  bne @isHigher

  ; Low byte comparison
  lda #<num2          ; Load low byte of num2
  cmp num1            ; Compare with low byte of num1
  bcc @end            ; If num2 < num1, skip to the end

@isHigher:
  ; Replace num1 with num2
  lda #>num2
  sta num1+1
  lda #<num2
  sta num1

@end:
.endmacro

;===============================================================================

.macro LIBMATH_MIN16BIT_AV num1, num2
  ; High byte comparison
  lda num1+1          ; Load high byte of num1
  cmp #>num2          ; Compare with high byte of num2
  bmi :+              ; If num1 < num2, skip replacement
  lda #>num2
  sta num1+1          ; Replace high byte of num1 with num2

  ; Low byte comparison
  lda #<num2          ; Load low byte of num2
  cmp num1            ; Compare with low byte of num1
  bcs :+              ; If num2 >= num1, skip replacement
  sta num1            ; Replace low byte of num1 with num2
:
.endmacro

;===============================================================================

.macro LIBMATH_SUB8FROM16_AVA num16, num8, result16
  sec                 ; Set carry to indicate subtraction (this is equivalent to "no borrow")
  lda num16           ; Load LSB of 16-bit number
  sbc #num8           ; Subtract the 8-bit immediate value
  sta result16        ; Store the result in LSB of result16

  lda num16+1         ; Load MSB of 16-bit number
  sbc #0              ; Subtract carry from the MSB
  sta result16+1      ; Store the result in MSB of result16
.endmacro

;===============================================================================

.macro LIBMATH_SUB24FROM24_AAA num1_24, num2_24, result24
  sec                 ; Set carry to indicate subtraction (equivalent to clearing the borrow)

  ; Subtract the least significant byte (LSB)
  lda num1_24         ; Load LSB of num1_24
  sbc num2_24         ; Subtract LSB of num2_24
  sta result24        ; Store the result in LSB of result24

  ; Subtract the middle byte
  lda num1_24+1       ; Load middle byte of num1_24
  sbc num2_24+1       ; Subtract middle byte of num2_24
  sta result24+1      ; Store the result in the middle byte of result24

  ; Subtract the most significant byte (MSB)
  lda num1_24+2       ; Load MSB of num1_24
  sbc num2_24+2       ; Subtract MSB of num2_24
  sta result24+2      ; Store the result in MSB of result24
.endmacro