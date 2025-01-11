;===============================================================================
;                     RetroGameDev NES Edition libScreen
;===============================================================================
; Macros

.macro LIBSCREEN_DISABLEPPU
  ; PPUMASK: Disable background and sprites, while preserving custom settings
  lda PPUMASK_SHADOW      ; Load the current PPUMASK_SHADOW value
  and #%11100111          ; Clear Bit 2 and Bit 3 (disable background and sprites)
  sta PPUMASK             ; Store the updated value into the PPUMASK register
  sta PPUMASK_SHADOW      ; Update the shadow register

  ; PPUCTRL: Clear only the NMI enable bit (bit 7) and preserve existing settings
  lda PPUCTRL_SHADOW      ; Load the current PPUCTRL_SHADOW value
  and #%01111111          ; Clear Bit 7 (disable NMI)
  sta PPUCTRL             ; Store the updated value into PPUCTRL
  sta PPUCTRL_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_ENABLEPPU
  ; PPUMASK: Ensure background and sprites are enabled, while preserving custom settings
  lda PPUMASK_SHADOW      ; Load the current PPUMASK_SHADOW value
  ora #%00011000          ; Ensure background and sprites are enabled
  sta PPUMASK             ; Store the updated value into the PPUMASK register
  sta PPUMASK_SHADOW      ; Update the shadow register

  ; PPUCTRL: Set only the NMI enable bit (bit 7) and merge with existing settings
  lda PPUCTRL_SHADOW      ; Load the current PPUCTRL_SHADOW value
  ora #%10000000          ; Set Bit 7 (enable NMI)
  sta PPUCTRL             ; Store the updated value into PPUCTRL
  sta PPUCTRL_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_INIT
.scope
  sei             ; Disable interrupts (IRQs)
  cld             ; Disable decimal mode
  ldx #$40
  stx APUFRAME    ; Disable APU frame IRQ
  ldx #$ff
  txs             ; Set up stack
  inx             ; Now X = 0
  stx PPUCTRL     ; Disable NMI (Non-maskable interrupt)
  stx PPUMASK     ; Disable rendering
  stx DMCFREQ     ; Disable DMC IRQs

  ; Clear the vblank flag to ensure LIBSCREEN_WAITVSYNC doesn't exit immediately
  bit PPUSTATUS

  ; Wait for vertical blank to make sure the PPU has stabilized
  LIBSCREEN_WAITVSYNC

  ; Fill RAM with $00 to initialize memory
  txa             ; Conveniently, X is 0, which matches what we need for filling RAM
clrmem:
  sta $000,x
  sta $100,x
  sta $200,x
  sta $300,x
  sta $400,x
  sta $500,x
  sta $600,x
  sta $700,x
  inx
  bne clrmem

  ; Wait for another VSYNC, PPU is now fully ready
  LIBSCREEN_WAITVSYNC

  ; Choose some sensible PPU defaults here:

  ; Enable background rendering in the leftmost 8 pixels
  LIBSCREEN_LEFT8PIXELSBACKGROUNDENABLE

  ; Disable sprite rendering in the leftmost 8 pixels
  LIBSCREEN_LEFT8PIXELSSPRITESDISABLE
.endscope
.endmacro

;===============================================================================

.macro LIBSCREEN_LEFT8PIXELSBACKGROUNDDISABLE
  lda PPUMASK_SHADOW      ; Load the current PPUMASK settings from the shadow register
  and #%11111101          ; Clear Bit 1 (disable background in leftmost 8 pixels)
  sta PPUMASK             ; Store the updated value in PPUMASK
  sta PPUMASK_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_LEFT8PIXELSBACKGROUNDENABLE
  lda PPUMASK_SHADOW      ; Load the current PPUMASK settings from the shadow register
  ora #%00000010          ; Set Bit 1 (enable background in leftmost 8 pixels)
  sta PPUMASK             ; Store the updated value in PPUMASK
  sta PPUMASK_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_LEFT8PIXELSSPRITESDISABLE
  lda PPUMASK_SHADOW      ; Load the current PPUMASK settings from the shadow register
  and #%11111011          ; Clear Bit 2 (disable sprites in leftmost 8 pixels)
  sta PPUMASK             ; Store the updated value in PPUMASK
  sta PPUMASK_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_LEFT8PIXELSSPRITESENABLE
  lda PPUMASK_SHADOW      ; Load the current PPUMASK settings from the shadow register
  ora #%00000100          ; Set Bit 2 (enable sprites in leftmost 8 pixels)
  sta PPUMASK             ; Store the updated value in PPUMASK
  sta PPUMASK_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_LOADNAMETABLE_AA nametable, screen
.scope

  ; Set the PPU address to the starting position of the nametable
  LIBSCREEN_SETPPUADDRESS_A nametable

  ; Set source pointer to the start of screen data
  LIBSCREEN_SETADDRESS_AA screen, wLibTemp1
  
  ; Copy 1024 bytes (4 pages) from mapStart to the PPU
  ldx #0                    ; Initialize X for page counter (0 to 3)
copy_page:
  ldy #0                    ; Start from the beginning of each page
copy_row:
  lda (wLibTemp1), y        ; Load data from mapStart + (X * 256) + Y
  sta PPUDATA               ; Write data to the PPU
  iny
  bne copy_row              ; Repeat until Y overflows back to 0 (256 bytes per page)
  
  inc wLibTemp1+1           ; Increment high byte of source to move to the next page
  inx
  cpx #4                    ; Loop until 4 pages are copied (1024 bytes)
  bne copy_page

.endscope
.endmacro

;===============================================================================

.macro LIBSCREEN_LOADPALETTEENTRY_AVV palette, entry, color
.scope
  lda #>palette          ; High byte of palette address
  sta PPUADDR            ; Set high byte of PPU address
  lda #<palette + entry  ; Low byte with offset
  sta PPUADDR            ; Set low byte of PPU address
  lda #color             ; Load the color value
  sta PPUDATA            ; Write the color to the PPU
.endscope
.endmacro

;===============================================================================

.macro LIBSCREEN_LOADPALETTE_AA palette, colorData
.scope
  LIBSCREEN_SETPPUADDRESS_A palette

  ; Set palette data (16 bytes)
  ldy #0
palette_loop:
  lda colorData,y
  sta PPUDATA
  iny
  cpy #16
  bne palette_loop

.endscope
.endmacro

;===============================================================================

.macro LIBSCREEN_SETADDRESS_AA address, var16
  lda #>address 
  sta var16+1
  lda #<address
  sta var16
.endmacro

;===============================================================================

.macro LIBSCREEN_SETBACKGROUNDCOLOR_V color
  LIBSCREEN_SETPPUADDRESS_A BGPALETTE
  LIBSCREEN_SETPPUDATA_V color
.endmacro

;===============================================================================

.macro LIBSCREEN_SETPPUADDRESS_A address
  lda #>address
  sta PPUADDR
  lda #<address
  sta PPUADDR
.endmacro

;===============================================================================

.macro LIBSCREEN_SETPPUDATA_V byte
  lda #byte
  sta PPUDATA
.endmacro

;===============================================================================

.macro LIBSCREEN_SETSCROLL_AA wScrX, wScrY
.scope
  lda wScrX
  sta PPUSCROLL

  lda wScrY
  sta PPUSCROLL

  lda wScrX+1
  and #1
  sta bLibTemp1

  lda PPUCTRL_SHADOW
  and #$FE
  ora bLibTemp1
  sta PPUCTRL_SHADOW
  sta PPUCTRL
.endscope
.endmacro

;===============================================================================

.macro LIBSCREEN_SETSPRITESIZE8x8
  lda PPUCTRL_SHADOW      ; Load the current PPUCTRL settings from the shadow register
  and #%11011111          ; Clear Bit 5 (enable 8x8 sprite mode)
  sta PPUCTRL             ; Store the updated value in PPUCTRL
  sta PPUCTRL_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_SETSPRITESIZE8x16
  lda PPUCTRL_SHADOW      ; Load the current PPUCTRL settings from the shadow register
  ora #%00100000          ; Set Bit 5 (enable 8x16 sprite mode)
  sta PPUCTRL             ; Store the updated value in PPUCTRL
  sta PPUCTRL_SHADOW      ; Update the shadow register
.endmacro

;===============================================================================

.macro LIBSCREEN_WAITSPRITE0
.scope
wait_sprite0_set:
  bit PPUSTATUS
  bvs wait_sprite0_set
wait_sprite0_clear:
  bit PPUSTATUS
  bvc wait_sprite0_clear
.endscope
.endmacro

;===============================================================================

.macro LIBSCREEN_WAITVSYNC
.scope
wait_vsync:
  bit PPUSTATUS
  bpl wait_vsync
.endscope
.endmacro