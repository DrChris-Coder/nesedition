; This file is for the FamiStudio Sound Engine and was generated by FamiStudio


.if FAMISTUDIO_CFG_C_BINDINGS
.export _sounds=sounds
.endif

sounds:
	.word @ntsc
	.word @ntsc
@ntsc:
	.word @sfx_ntsc_button
	.word @sfx_ntsc_countdown
	.word @sfx_ntsc_countdown_end
	.word @sfx_ntsc_winner
	.word @sfx_ntsc_loser
	.word @sfx_ntsc_tank

@sfx_ntsc_button:
	.byte $87,$7e,$88,$00,$86,$8f,$89,$f0,$02,$00
@sfx_ntsc_countdown:
	.byte $81,$fd,$82,$00,$80,$3f,$89,$f0,$07,$00
@sfx_ntsc_countdown_end:
	.byte $81,$fd,$82,$00,$80,$3f,$89,$f0,$28,$00
@sfx_ntsc_winner:
	.byte $89,$f0,$02,$87,$7e,$88,$00,$86,$8f,$03,$86,$80,$05,$86,$8f,$30
	.byte $00
@sfx_ntsc_loser:
	.byte $89,$f0,$02,$81,$fb,$82,$01,$80,$3f,$06,$80,$30,$07,$80,$3f,$28
	.byte $00
@sfx_ntsc_tank:
	.byte $84,$e0,$85,$07,$83,$37,$89,$f0,$07,$84,$02,$06,$00

.export sounds
