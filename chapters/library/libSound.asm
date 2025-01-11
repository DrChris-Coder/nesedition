;===============================================================================
;                     RetroGameDev NES Edition libSound
;===============================================================================
; Includes
.include "famistudio_ca65.s"

;===============================================================================
; Macros

.macro LIBSOUND_INIT music, sfx
  ; Init music
  ldx #<music
  ldy #>music
  lda #1        ; NTSC mode
  jsr famistudio_init

  ; Init SFX
  ldx #<sfx
  ldy #>sfx
  jsr famistudio_sfx_init
.endmacro

;===============================================================================

.macro LIBSOUND_MUSICPAUSE pause
  lda #pause
  jsr famistudio_music_pause
.endmacro

;===============================================================================

.macro LIBSOUND_MUSICPLAY track
  lda #track
  jsr famistudio_music_play
.endmacro

;===============================================================================

.macro LIBSOUND_MUSICSTOP
  jsr famistudio_music_stop
.endmacro

;===============================================================================

.macro LIBSOUND_SFXPLAY track, channel
  lda #track
  ldx #channel
  jsr famistudio_sfx_play
.endmacro