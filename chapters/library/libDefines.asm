;===============================================================================
;                     RetroGameDev NES Edition libDefines
;===============================================================================
.feature c_comments  ; Enable the use of C-style comments in the assembler
; Constants

; Colors (PPU color codes)
BLACK    = 14      ; Color code for black (background or sprite)
WHITE    = 48      ; Color code for white
RED      = 22      ; Color code for red
CYAN     = 28      ; Color code for cyan
PURPLE   = 36      ; Color code for purple
GREEN    = 43      ; Color code for green
BLUE     = 17      ; Color code for blue
YELLOW   = 41      ; Color code for yellow
GRAY     = 16      ; Color code for gray

; OAM (Object Attribute Memory) Bit Masks for sprite properties
OAM_PALETTE  = %00000011  ; Bits 0-1: Sprite palette selection (values 0-3)
OAM_BEHIND   = %00100000  ; Bit 5: Sprite behind the background flag (0 = in front, 1 = behind)
OAM_FLIP_H   = %01000000  ; Bit 6: Horizontal flip (0 = normal, 1 = flipped)
OAM_FLIP_V   = %10000000  ; Bit 7: Vertical flip (0 = normal, 1 = flipped)

; CPU Memory Locations
                  ; $0000-$00FF: 256 bytes Zero Page (Used in libVariables.asm & gameVariables.asm)
SPRITERAM = $0200 ; $0200-$02FF: 256 bytes of Sprite RAM (buffer for OAM data, copied during VBlank)
                  ; $0300-$07FF: 1280 bytes free CPU RAM for general use
                  ; ====================================
                  ; CPU RAM is 2KB in total

; PPU Registers (Memory-mapped I/O addresses)
PPUCTRL   = $2000  ; PPU Control register: Controls NMI enable, sprite size, background/sprite tile select, etc.
PPUMASK   = $2001  ; PPU Mask register: Enables/disables rendering, grayscale, and visibility of sprites/backgrounds.
PPUSTATUS = $2002  ; PPU Status register: VBlank flag, sprite 0 hit, sprite overflow status.
OAMADDR   = $2003  ; OAM Address register: Set OAM address for sprite data reads/writes.
OAMDATA   = $2004  ; OAM Data register: Read/write sprite data to/from OAM.
PPUSCROLL = $2005  ; PPU Scroll register: Fine X/Y scrolling (two consecutive writes - X first, then Y).
PPUADDR   = $2006  ; PPU Address register: Set VRAM address for read/write operations (two consecutive writes - MSB first, then LSB).
PPUDATA   = $2007  ; PPU Data register: Read/write data to/from VRAM at the address set by PPUADDR.
OAMDMA    = $4014  ; OAM DMA: DMA transfer of 256 bytes from CPU RAM to OAM (usually for sprite data).


; APU (Audio Processing Unit) Registers
DMCFREQ   = $4010  ; DMC (Delta Modulation Channel) Frequency Control.
APUFRAME  = $4017  ; APU Frame Counter: Controls frame interrupts and sequence for audio timing.

; JoyPad Registers (Controller input)
JOYPAD1   = $4016  ; Player 1 input register: Write to latch inputs, read to get Player 1's controller state.
JOYPAD2   = $4017  ; Player 2 input register: Read-only for Player 2's controller input.

; PPU Memory Locations (Nametable and Attribute Table addresses)

; Nametables (960 bytes each, arranged in a 2x2 grid for scrolling)
NAMETABLE0       = $2000  ; Nametable 0 (top-left)
NAMETABLE1       = $2400  ; Nametable 1 (top-right)
NAMETABLE2       = $2800  ; Nametable 2 (bottom-left)
NAMETABLE3       = $2C00  ; Nametable 3 (bottom-right)

; Attribute tables (64 bytes each, managing 16x16 pixel attribute blocks)
ATTRTABLE0       = $23C0  ; Attribute table for Nametable 0
ATTRTABLE1       = $27C0  ; Attribute table for Nametable 1
ATTRTABLE2       = $2BC0  ; Attribute table for Nametable 2
ATTRTABLE3       = $2FC0  ; Attribute table for Nametable 3

; Palette Memory Locations (Background and Sprite palettes)
BGPALETTE        = $3F00  ; Background palette memory start address.
SPPALETTE        = $3F10  ; Sprite palette memory start address.

; FamiStudio Sound Engine Configuration
.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE    ; FamiStudio uses the Zero Page segment.
.define FAMISTUDIO_CA65_RAM_SEGMENT  RAM         ; Define RAM segment for FamiStudio data.
.define FAMISTUDIO_CA65_CODE_SEGMENT CODE        ; Define Code segment for FamiStudio.

FAMISTUDIO_CFG_EXTERNAL         = 1  ; Enable external sound engine support.
FAMISTUDIO_CFG_DPCM_SUPPORT     = 1  ; Enable support for DPCM (Delta Pulse Code Modulation) samples.
FAMISTUDIO_CFG_SFX_SUPPORT      = 1  ; Enable support for sound effects.
FAMISTUDIO_CFG_SFX_STREAMS      = 2  ; Number of sound effect channels.
FAMISTUDIO_CFG_EQUALIZER        = 1  ; Enable equalizer effect.
FAMISTUDIO_USE_VOLUME_TRACK     = 1  ; Enable volume effects.
FAMISTUDIO_USE_PITCH_TRACK      = 1  ; Enable pitch effects.
FAMISTUDIO_USE_VOLUME_SLIDES    = 1  ; Enable volume slides.
FAMISTUDIO_USE_SLIDE_NOTES      = 1  ; Enable sliding notes (pitch bends).
FAMISTUDIO_USE_VIBRATO          = 1  ; Enable vibrato effect.
FAMISTUDIO_USE_ARPEGGIO         = 1  ; Enable arpeggio effect.
FAMISTUDIO_CFG_SMOOTH_VIBRATO   = 1  ; Enable smooth vibrato transitions.
FAMISTUDIO_USE_RELEASE_NOTES    = 1  ; Enable support for release notes (sustain/release).
FAMISTUDIO_DPCM_OFF             = $e000  ; DPCM sample memory starting address.
FAMISTUDIO_EXP_VRC6             = 1  ; Enable support for VRC6 expansion audio (Konami expansion chip).
FAMISTUDIO_USE_DUTYCYCLE_EFFECT = 1  ; Enable duty cycle effect for sound manipulation.