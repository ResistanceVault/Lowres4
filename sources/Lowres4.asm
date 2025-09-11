; Requirements
; 68000+
; OCS+
; 1.2+


; V.1.0 beta
; - 1st release



; Execution time 68000: n rasterlines


	MC68000


	INCDIR "include3.5:"

	INCLUDE "exec/exec.i"
	INCLUDE "exec/exec_lib.i"

	INCLUDE "dos/dos.i"
	INCLUDE "dos/dos_lib.i"
	INCLUDE "dos/dosextens.i"

	INCLUDE "graphics/gfxbase.i"
	INCLUDE "graphics/graphics_lib.i"
	INCLUDE "graphics/videocontrol.i"

	INCLUDE "intuition/intuition.i"
	INCLUDE "intuition/intuition_lib.i"
	INCLUDE "intuition/screens.i"

	INCLUDE "libraries/any_lib.i"

	INCLUDE "resources/cia_lib.i"

	INCLUDE "hardware/adkbits.i"
	INCLUDE "hardware/blit.i"
	INCLUDE "hardware/cia.i"
	INCLUDE "hardware/custom.i"
	INCLUDE "hardware/dmabits.i"
	INCLUDE "hardware/intbits.i"


SET_SECOND_COPPERLIST		SET 1
PROTRACKER_VERSION_3		SET 1


	INCDIR "custom-includes-ocs:"


	INCLUDE "macros.i"


	INCLUDE "equals.i"

requires_030_cpu		EQU FALSE
requires_040_cpu		EQU FALSE
requires_060_cpu		EQU FALSE
requires_fast_memory    	EQU FALSE
requires_multiscan_monitor	EQU FALSE

workbench_start_enabled 	EQU FALSE
screen_fader_enabled		EQU FALSE
text_output_enabled     	EQU FALSE

; PT-Replay
pt_ciatiming_enabled		EQU TRUE
pt_usedfx			EQU %1111011000111100
pt_usedefx			EQU %0000001001000000
pt_mute_enabled			EQU FALSE
pt_music_fader_enabled		EQU TRUE
pt_fade_out_delay		EQU 2	; ticks
pt_split_module_enabled		EQU TRUE
pt_track_notes_played_enabled	EQU FALSE
pt_track_volumes_enabled	EQU FALSE
pt_track_periods_enabled	EQU FALSE
pt_track_data_enabled		EQU FALSE
	IFD PROTRACKER_VERSION_3
pt_metronome_enabled		EQU FALSE
pt_metrochanbits		EQU pt_metrochan1
pt_metrospeedbits		EQU pt_metrospeed4th
	ENDC

dma_bits			EQU DMAF_COPPER|DMAF_BLITTER|DMAF_RASTER|DMAF_MASTER|DMAF_SETCLR

	IFEQ pt_ciatiming_enabled
intena_bits			EQU INTF_EXTER|INTF_INTEN|INTF_SETCLR
	ELSE
intena_bits			EQU INTF_VERTB|INTF_EXTER|INTF_INTEN|INTF_SETCLR
	ENDC

ciaa_icr_bits			EQU CIAICRF_SETCLR
	IFEQ pt_ciatiming_enabled
ciab_icr_bits			EQU CIAICRF_TA|CIAICRF_TB|CIAICRF_SETCLR
	ELSE
ciab_icr_bits			EQU CIAICRF_TB|CIAICRF_SETCLR
	ENDC

copcon_bits			EQU 0

pf1_x_size1			EQU 0
pf1_y_size1			EQU 0
pf1_depth1			EQU 0
pf1_x_size2			EQU 0
pf1_y_size2			EQU 0
pf1_depth2			EQU 0
pf1_x_size3			EQU 0
pf1_y_size3			EQU 0
pf1_depth3			EQU 0
pf1_colors_number		EQU 0

pf2_x_size1			EQU 0
pf2_y_size1			EQU 0
pf2_depth1			EQU 0
pf2_x_size2			EQU 0
pf2_y_size2			EQU 0
pf2_depth2			EQU 0
pf2_x_size3			EQU 0
pf2_y_size3			EQU 0
pf2_depth3			EQU 0
pf2_colors_number		EQU 0
pf_colors_number		EQU pf1_colors_number+pf2_colors_number
pf_depth			EQU pf1_depth3+pf2_depth3

pf_extra_number			EQU 2
; Viewport 1 
; Playfield 1 
extra_pf1_x_size		EQU 352
extra_pf1_y_size		EQU 70
extra_pf1_depth			EQU 4
; Viewport 2 
; Playfield 1 
extra_pf2_x_size		EQU 352
extra_pf2_y_size		EQU 176
extra_pf2_depth			EQU 3

spr_number			EQU 0
spr_x_size1			EQU 0
spr_y_size1			EQU 0
spr_x_size2			EQU 0
spr_y_size2			EQU 0
spr_depth			EQU 0
spr_colors_number		EQU 0

	IFD PROTRACKER_VERSION_2 
audio_memory_size		EQU 0
	ENDC
	IFD PROTRACKER_VERSION_3
audio_memory_size		EQU 1*WORD_SIZE
	ENDC

disk_memory_size		EQU 0

extra_memory_size		EQU 0

chip_memory_size		EQU 0

	IFEQ pt_ciatiming_enabled
ciab_cra_bits			EQU CIACRBF_LOAD
	ENDC
ciab_crb_bits			EQU CIACRBF_LOAD|CIACRBF_RUNMODE ; oneshot mode
ciaa_ta_time			EQU 0
ciaa_tb_time			EQU 0
	IFEQ pt_ciatiming_enabled
ciab_ta_time			EQU 14187 ; = 0.709379 MHz * [20000 µs = 50 Hz duration for one frame on a PAL machine]
;ciab_ta_time			EQU 14318 ; = 0.715909 MHz * [20000 µs = 50 Hz duration for one frame on a NTSC machine]
	ELSE
ciab_ta_time			EQU 0
	ENDC
ciab_tb_time			EQU 362 ; = 0.709379 MHz * [511.43 µs = Lowest note period C1 with Tuning=-8 * 2 / PAL clock constant = 907*2/3546895 ticks per second]
					; = 0.715909 MHz * [506.76 µs = Lowest note period C1 with Tuning=-8 * 2 / NTSC clock constant = 907*2/3579545 ticks per second]
ciaa_ta_continuous_enabled	EQU FALSE
ciaa_tb_continuous_enabled	EQU FALSE
	IFEQ pt_ciatiming_enabled
ciab_ta_continuous_enabled	EQU TRUE
	ELSE
ciab_ta_continuous_enabled	EQU FALSE
	ENDC
ciab_tb_continuous_enabled	EQU FALSE

beam_position			EQU $133

MINROW				EQU VSTART_256_LINES

; View
display_window_hstart		EQU HSTART_352_PIXEL
display_window_vstart		EQU MINROW
display_window_hstop		EQU HSTOP_352_PIXEL
display_window_vstop		EQU VSTOP_256_lines

visible_lines_number		EQU 256

; Viewport 1
vp1_pixel_per_line		EQU 336
vp1_visible_pixels_number	EQU 352
vp1_visible_lines_number	EQU 70

vp1_hstart			EQU 0
vp1_vstart			EQU MINROW
vp1_vstop			EQU vp1_vstart+vp1_visible_lines_number

vp1_pf1_depth			EQU 4
vp1_pf_depth			EQU vp1_pf1_depth

vp1_pf1_colors_number		EQU 16
vp1_pf_colors_number		EQU vp1_pf1_colors_number

; Vertical Blank
vb_lines_number			EQU 10

vb_hstart			EQU 0
vb_vstart			EQU vp1_vstop
vb_vstop			EQU vb_vstart+vb_lines_number

; Viewport 2
vp2_pixel_per_line		EQU 336
vp2_visible_pixels_number	EQU 352
vp2_visible_lines_number	EQU 176

vp2_hstart			EQU 0
vp2_vstart			EQU vb_vstop
vp2_vstop			EQU vp2_vstart+vp2_visible_lines_number

vp2_pf1_depth			EQU 3
vp2_pf_depth			EQU vp2_pf1_depth

vp2_pf1_colors_number		EQU 8
vp2_pf_corors_number		EQU vp2_pf1_colors_number


; Viewport 1
; Playfield 1
extra_pf1_plane_width		EQU extra_pf1_x_size/8

; Viewport 2 
; Playfield 1 
extra_pf2_plane_width		EQU extra_pf2_x_size/8


; Viewport 1
; Playfield 1
vp1_data_fetch_width		EQU vp1_pixel_per_line/8
vp1_pf1_plane_moduli		EQU (extra_pf1_plane_width*(extra_pf1_depth-1))+extra_pf1_plane_width-vp1_data_fetch_width

; Viewport 2
; Playfield 1 
vp2_data_fetch_width		EQU vp2_pixel_per_line/8
vp2_pf1_plane_moduli		EQU (extra_pf2_plane_width*(extra_pf2_depth-1))+extra_pf2_plane_width-vp2_data_fetch_width


; View
diwstrt_bits			EQU ((display_window_vstart&$ff)*DIWSTRTF_V0)|(display_window_hstart&$ff)
diwstop_bits			EQU ((display_window_vstop&$ff)*DIWSTOPF_V0)|(display_window_hstop&$ff)
bplcon0_bits			EQU BPLCON0F_COLOR|(pf_depth*BPLCON0F_BPU0)
color00_bits			EQU $000

; Viewport 1
vp1_ddfstrt_bits		EQU DDFSTRT_320_PIXEL
vp1_ddfstop_bits		EQU DDFSTOP_OVERSCAN_16_PIXEL
vp1_bplcon0_bits1		EQU BPLCON0F_COLOR|(extra_pf1_depth*BPLCON0F_BPU0)
vp1_bplcon0_bits2		EQU BPLCON0F_COLOR
vp1_bplcon1_bits		EQU 0
vp1_bplcon2_bits		EQU BPLCON2F_PF1P2 ; sprites in front of playfield 1
vp1_color00_bits		EQU color00_bits

; Viewport 2
vp2_ddfstrt_bits		EQU DDFSTRT_320_PIXEL
vp2_ddfstop_bits		EQU DDFSTOP_OVERSCAN_16_PIXEL
vp2_bplcon0_bits1		EQU BPLCON0F_COLOR|(extra_pf2_depth*BPLCON0F_BPU0)
vp2_bplcon0_bits2		EQU BPLCON0F_COLOR
vp2_bplcon1_bits		EQU 0
vp2_bplcon2_bits		EQU BPLCON2F_PF1P2 ; sprites in front of playfield 1
vp2_color00_bits		EQU color00_bits


; Viewport 1
cl1_hstart1			EQU (vp1_ddfstrt_bits*2)-(extra_pf1_depth*CMOVE_SLOT_PERIOD)
cl1_vstart1			EQU vp1_vstart

; Vertical-Blank
cl1_hstart2			EQU display_window_hstart-(1*CMOVE_SLOT_PERIOD)
cl1_vstart2			EQU vb_vstart

; Viewport 2
cl1_hstart3			EQU (vp2_ddfstrt_bits*2)-(extra_pf2_depth*CMOVE_SLOT_PERIOD)
cl1_vstart3			EQU vp2_vstart

; Copper Interrupt
cl1_hstart4			EQU 0
cl1_vstart4			EQU beam_position&CL_Y_WRAPPING

; Logo
lg_image_x_size			EQU 352
lg_image_plane_width		EQU lg_image_x_size/8
lg_image_y_size			EQU 70
lg_image_depth			EQU 4

; Textwriter
tw_image_x_size			EQU 320
tw_image_plane_width		EQU tw_image_x_size/8
tw_image_depth			EQU 2
tw_origin_char_x_size		EQU 16
tw_origin_char_y_size		EQU 15

tw_text_char_x_size		EQU 16
tw_text_char_width		EQU tw_text_char_x_size/8
tw_text_char_y_size		EQU tw_origin_char_y_size
tw_text_char_depth		EQU tw_image_depth

tw_max_x_position		EQU vp2_visible_pixels_number-tw_text_char_x_size

tw_text_cursor_x_size		EQU tw_text_char_x_size
tw_text_cursor_width		EQU tw_text_cursor_x_size/8
tw_text_cursor_y_size		EQU tw_text_char_y_size
tw_text_cursor_depth		EQU extra_pf2_depth

tw_delay			EQU 5	; frames


vp1_pf1_plane_x_offset		EQU 16
vp1_pf1_bpl1dat_x_offset	EQU 0

vp2_pf1_plane_x_offset		EQU 16
vp2_pf1_bpl1dat_x_offset	EQU 0


	INCLUDE "except-vectors.i"


	INCLUDE "extra-pf-attributes.i"


	INCLUDE "sprite-attributes.i"


; PT-Replay
	INCLUDE "music-tracker/pt-song.i"

	INCLUDE "music-tracker/pt-temp-channel.i"


	RSRESET

cl1_extension1			RS.B 0

cl1_ext1_DDFSTRT		RS.L 1
cl1_ext1_DDFSTOP		RS.L 1
cl1_ext1_BPLCON1		RS.L 1
cl1_ext1_BPLCON2		RS.L 1
cl1_ext1_BPL1MOD		RS.L 1
cl1_ext1_BPL2MOD		RS.L 1
cl1_ext1_COLOR00		RS.L 1
cl1_ext1_COLOR01		RS.L 1
cl1_ext1_COLOR02		RS.L 1
cl1_ext1_COLOR03		RS.L 1
cl1_ext1_COLOR04		RS.L 1
cl1_ext1_COLOR05		RS.L 1
cl1_ext1_COLOR06		RS.L 1
cl1_ext1_COLOR07		RS.L 1
cl1_ext1_COLOR08		RS.L 1
cl1_ext1_COLOR09		RS.L 1
cl1_ext1_COLOR10		RS.L 1
cl1_ext1_COLOR11		RS.L 1
cl1_ext1_COLOR12		RS.L 1
cl1_ext1_COLOR13		RS.L 1
cl1_ext1_COLOR14		RS.L 1
cl1_ext1_COLOR15		RS.L 1
cl1_ext1_BPL1PTH		RS.L 1
cl1_ext1_BPL1PTL		RS.L 1
cl1_ext1_BPL2PTH		RS.L 1
cl1_ext1_BPL2PTL		RS.L 1
cl1_ext1_BPL3PTH		RS.L 1
cl1_ext1_BPL3PTL		RS.L 1
cl1_ext1_BPL4PTH		RS.L 1
cl1_ext1_BPL4PTL		RS.L 1
cl1_ext1_WAIT2			RS.L 1
cl1_ext1_BPLCON0		RS.L 1

cl1_extension1_size		RS.B 0


	RSRESET

cl1_extension2			RS.B 0

cl1_ext2_WAIT			RS.L 1
cl1_ext2_BPL4DAT		RS.L 1
cl1_ext2_BPL3DAT		RS.L 1
cl1_ext2_BPL2DAT		RS.L 1
cl1_ext2_BPL1DAT		RS.L 1

cl1_extension2_size		RS.B 0


	RSRESET

cl1_extension3			RS.B 0

cl1_ext3_WAIT			RS.L 1
cl1_ext3_BPLCON0		RS.L 1

cl1_extension3_size		RS.B 0


	RSRESET

cl1_extension4			RS.B 0

cl1_ext4_WAIT			RS.L 1
cl1_ext4_BPL1DAT		RS.L 1

cl1_extension4_size		RS.B 0


	RSRESET

cl1_extension5			RS.B 0

cl1_ext5_DDFSTRT		RS.L 1
cl1_ext5_DDFSTOP		RS.L 1
cl1_ext5_BPLCON1		RS.L 1
cl1_ext5_BPLCON2		RS.L 1
cl1_ext5_BPL1MOD		RS.L 1
cl1_ext5_BPL2MOD		RS.L 1
cl1_ext5_COLOR00		RS.L 1
cl1_ext5_COLOR01		RS.L 1
cl1_ext5_COLOR02		RS.L 1
cl1_ext5_COLOR03		RS.L 1
cl1_ext5_COLOR04		RS.L 1
cl1_ext5_COLOR05		RS.L 1
cl1_ext5_COLOR06		RS.L 1
cl1_ext5_COLOR07		RS.L 1
cl1_ext5_BPL1PTH		RS.L 1
cl1_ext5_BPL1PTL		RS.L 1
cl1_ext5_BPL2PTH		RS.L 1
cl1_ext5_BPL2PTL		RS.L 1
cl1_ext5_BPL3PTH		RS.L 1
cl1_ext5_BPL3PTL		RS.L 1
cl1_ext5_WAIT2			RS.L 1
cl1_ext5_BPLCON0		RS.L 1

cl1_extension5_size		RS.B 0


	RSRESET

cl1_extension6			RS.B 0

cl1_ext6_WAIT			RS.L 1
cl1_ext6_BPL3DAT		RS.L 1
cl1_ext6_BPL2DAT		RS.L 1
cl1_ext6_BPL1DAT		RS.L 1
cl1_ext6_NOOP			RS.L 1

cl1_extension6_size		RS.B 0


	RSRESET

cl1_begin			RS.B 0

	INCLUDE "copperlist1.i"

; Viewport 1
cl1_extension1_entry		RS.B cl1_extension1_size
cl1_extension2_entry		RS.B cl1_extension2_size*vp1_visible_lines_number
; Vertical Blank
cl1_extension3_entry		RS.B cl1_extension3_size
cl1_extension4_entry		RS.B cl1_extension4_size*vb_lines_number
; Viewport 2
cl1_extension5_entry		RS.B cl1_extension5_size
cl1_extension6_entry		RS.B cl1_extension6_size*vp2_visible_lines_number
; Copper Interrupt
cl1_WAIT			RS.L 1
cl1_INTREQ			RS.L 1

cl1_end				RS.L 1

copperlist1_size		RS.B 0


	RSRESET

cl2_begin			RS.B 0

cl2_end				RS.L 1

copperlist2_size		RS.B 0


cl1_size1			EQU 0
cl1_size2			EQU 0
cl1_size3			EQU copperlist1_size

cl2_size1			EQU 0
cl2_size2			EQU 0
cl2_size3			EQU copperlist2_size


spr0_x_size1			EQU spr_x_size1
spr0_y_size1			EQU 0
spr1_x_size1			EQU spr_x_size1
spr1_y_size1			EQU 0
spr2_x_size1			EQU spr_x_size1
spr2_y_size1			EQU 0
spr3_x_size1			EQU spr_x_size1
spr3_y_size1			EQU 0
spr4_x_size1			EQU spr_x_size1
spr4_y_size1			EQU 0
spr5_x_size1			EQU spr_x_size1
spr5_y_size1			EQU 0
spr6_x_size1			EQU spr_x_size1
spr6_y_size1			EQU 0
spr7_x_size1			EQU spr_x_size1
spr7_y_size1			EQU 0

spr0_x_size2			EQU spr_x_size2
spr0_y_size2			EQU 0
spr1_x_size2			EQU spr_x_size2
spr1_y_size2			EQU 0
spr2_x_size2			EQU spr_x_size2
spr2_y_size2			EQU 0
spr3_x_size2			EQU spr_x_size2
spr3_y_size2			EQU 0
spr4_x_size2			EQU spr_x_size2
spr4_y_size2			EQU 0
spr5_x_size2			EQU spr_x_size2
spr5_y_size2			EQU 0
spr6_x_size2			EQU spr_x_size2
spr6_y_size2			EQU 0
spr7_x_size2			EQU spr_x_size2
spr7_y_size2			EQU 0


	RSRESET

	INCLUDE "main-variables.i"

; PT-Replay
	IFD PROTRACKER_VERSION_2
		INCLUDE "music-tracker/pt2-variables.i"
	ENDC
	IFD PROTRACKER_VERSION_3
		INCLUDE "music-tracker/pt3-variables.i"
	ENDC

; Textwriter
tw_active			RS.W 1
	RS_ALIGN_LONGWORD
tw_image			RS.L 1
tw_text_table_start		RS.W 1
tw_text_char_x_position		RS.W 1
tw_text_char_y_position		RS.W 1

tw_cursor_active		RS.W 1
tw_cursor_x_position		RS.W 1
tw_cursor_y_position		RS.W 1

tw_delay_counter		RS.W 1

variables_size			RS.B 0


	SECTION code,CODE


	INCLUDE "sys-wrapper.i"


	CNOP 0,4
init_main_variables

; PT-Replay
	IFD PROTRACKER_VERSION_2
		PT2_INIT_VARIABLES
	ENDC
	IFD PROTRACKER_VERSION_3
		PT3_INIT_VARIABLES
	ENDC

; Textwriter
	moveq	#TRUE,d0
	move.w	d0,tw_active(a3)
	lea	tw_image_data,a0
	move.l	a0,tw_image(a3)
	move.w	d0,tw_text_table_start(a3)
	move.w	d0,tw_text_char_x_position(a3)
	move.w	d0,tw_text_char_y_position(a3)

	move.w	d0,tw_cursor_active(a3)
	move.w	d0,tw_cursor_x_position(a3)
	move.w	d0,tw_cursor_y_position(a3)

	move.w	#1,tw_delay_counter(a3)	; enable counter
	rts


	CNOP 0,4
init_main
	bsr.s	pt_DetectSysFrequ
	bsr	pt_InitRegisters
	bsr	pt_InitAudTempStrucs
	bsr	pt_ExamineSongStruc
	bsr	pt_InitFtuPeriodTableStarts
	bsr	init_CIA_timers
	bsr	init_colors
	bsr	lg_copy_image_to_playfield
	bsr	tw_init_chars_offsets
	bsr	init_first_copperlist
	bsr	init_second_copperlist
	rts


	PT_DETECT_SYS_FREQUENCY


	PT_INIT_REGISTERS


	PT_INIT_AUDIO_TEMP_STRUCTURES


	PT_EXAMINE_SONG_STRUCTURE


	PT_INIT_FINETUNE_TABLE_STARTS


	CNOP 0,2
init_colors
	CPU_INIT_COLOR COLOR00,1,pf1_rgb4_color_table
	rts


	CNOP 0,4
init_CIA_timers

; PT-Replay
	PT_INIT_TIMERS
	rts


; Logo
	CNOP 0,4
lg_copy_image_to_playfield
	move.l	a4,-(a7)
	move.l	#lg_image_data+(vp1_pf1_plane_x_offset/8),a1 ; bitplane 1
	move.l	extra_pf1(a3),a4	; destination
	bsr.s	lg_copy_image_data
	add.l	#lg_image_plane_width,a1 ; bitplane 2
	bsr.s	lg_copy_image_data
	add.l	#lg_image_plane_width,a1 ; bitplane 3
	bsr.s	lg_copy_image_data
	add.l	#lg_image_plane_width,a1 ; bitplane 4
	bsr.s	lg_copy_image_data
	move.l	(a7)+,a4
	rts


; Input
; a1.l	Source: image
; a4.l	Destination: bitplane
; Result
	CNOP 0,4
lg_copy_image_data
	move.l	a1,a0			; source
	move.l	a4,a2			; destination
	MOVEF.W lg_image_y_size-1,d7
lg_copy_image_data_loop
	REPT vp1_pixel_per_line/WORD_BITS
		move.w	(a0)+,(a2)+	; copy 42 bytes
	ENDR
	ADDF.W	(lg_image_plane_width*(lg_image_depth-1))+WORD_SIZE,a0 ; next line in source
	ADDF.W	(extra_pf1_plane_width*(extra_pf1_depth-1))+WORD_SIZE,a2 ; next line in destination
	dbf	d7,lg_copy_image_data_loop

	ADDF.W	extra_pf1_plane_width,a4 ; next bitplane in destination
	rts


; Textwriter
	INIT_CHARS_OFFSETS.W tw


	CNOP 0,4
init_first_copperlist
	move.l	cl1_display(a3),a0
; View
	bsr.s	cl1_init_playfield_props
; Viewport 1
	bsr	cl1_vp1_init_playfield_props
	bsr	cl1_vp1_init_colors
	bsr	cl1_vp1_init_bitplane_pointers
	bsr	cl1_vp1_start_display
	bsr	cl1_vp1_init_bpldat
; Vertical-Blank
	bsr	cl1_vb_start_blank
	bsr	cl1_vb_init_bpldat
; Viewport 2
	bsr	cl1_vp2_init_playfield_props
	bsr	cl1_vp2_init_colors
	bsr	cl1_vp2_init_bitplane_pointers
	bsr	cl1_vp2_start_display
	bsr	cl1_vp2_init_bpldat
; Copper-Interrupt
	bsr	cl1_init_copper_interrupt
	COP_LISTEND
	bsr	cl1_vp1_set_bitplane_pointers
	bsr	cl1_vp2_set_bitplane_pointers
	rts


; View
	COP_INIT_PLAYFIELD_REGISTERS cl1,NOBITPLANES


; Viewport 1
	COP_INIT_PLAYFIELD_REGISTERS cl1,,vp1

	CNOP 0,4
cl1_vp1_init_colors
	COP_INIT_COLOR COLOR00,16,vp1_pf1_rgb4_color_table
	rts

	CNOP 0,4
cl1_vp1_init_bitplane_pointers
	move.w #BPL1PTH,d0
	moveq	#(extra_pf1_depth*2)-1,d7
cl1_vp1_init_bitplane_pointers_loop
	move.w	d0,(a0)			; BPLxPTH/L
	addq.w	#WORD_SIZE,d0
	addq.w	#LONGWORD_SIZE,a0
	dbf	d7,cl1_vp1_init_bitplane_pointers_loop
	rts

	CNOP 0,4
cl1_vp1_start_display
	COP_WAIT vp1_hstart,vp1_vstart
	COP_MOVEQ vp1_bplcon0_bits1,BPLCON0
	rts

	CNOP 0,4
cl1_vp1_init_bpldat
	move.l	#lg_image_data+(vp1_pf1_BPL1DAT_x_offset/8),a1 ; bitplane 1
	move.l	#(((cl1_vstart1<<24)|(((cl1_hstart1/4)*2)<<16))|$10000)|$fffe,d0 ; CWAIT
	move.w	#BPL1DAT,d1
	move.w	#BPL2DAT,d2
	move.w	#BPL3DAT,d3
	move.w	#BPL4DAT,d4
	move.l	#1<<24,d6
	MOVEF.W vp1_visible_lines_number-1,d7
cl1_vp1_init_bpldat_loop
	move.l	d0,(a0)+		; CWAIT
	move.w	d4,(a0)+		; BPL4DAT
	move.w	lg_image_plane_width*3(a1),(a0)+ ; 1st word bitplane 4
	move.w	d3,(a0)+		; BPL3DAT
	move.w	lg_image_plane_width*2(a1),(a0)+ ; 1st word bitplane 3
	move.w	d2,(a0)+		; BPL2DAT
	move.w	lg_image_plane_width*1(a1),(a0)+ ; 1st word bitplane 2
	move.w	d1,(a0)+		; BPL1DAT
	move.w	(a1),(a0)+		; 1st word bitplane 1
	ADDF.W	lg_image_plane_width*lg_image_depth,a1 ; next line in source
	add.l	d6,d0			; next line in cl
	dbf	d7,cl1_vp1_init_bpldat_loop
	rts


; Vertical Blank
	CNOP 0,4
cl1_vb_start_blank
	COP_WAIT vb_hstart,vb_vstart
	COP_MOVEQ vp1_bplcon0_bits2,BPLCON0
	rts

	CNOP 0,4
cl1_vb_init_bpldat
	move.l	#(((cl1_VSTART2<<24)|(((cl1_HSTART2/4)*2)<<16))|$10000)|$fffe,d0 ; CWAIT
	move.l	#BPL1DAT<<16,d1
	move.l	#1<<24,d2		; next line
	MOVEF.W vb_lines_number-1,d7
cl1_vb_init_bpldat_loop
	move.l	d0,(a0)+		; CWAIT
	add.l	d2,d0			; next line in cl
	move.l	d1,(a0)+		; BPL1DAT
	dbf	d7,cl1_vb_init_bpldat_loop
	rts


; Viewport 2
	COP_INIT_PLAYFIELD_REGISTERS cl1,,vp2

	CNOP 0,4
cl1_vp2_init_colors
	COP_INIT_COLOR COLOR00,8,vp2_pf1_rgb4_color_table
	rts

	CNOP 0,4
cl1_vp2_init_bitplane_pointers
	move.w	#BPL1PTH,d0
	moveq	#(extra_pf2_depth*2)-1,d7
cl1_vp2_init_bitplane_pointers_loop
	move.w	d0,(a0)			; BPLxPTH/L
	addq.w	#WORD_SIZE,d0
	addq.w	#LONGWORD_SIZE,a0
	dbf	d7,cl1_vp2_init_bitplane_pointers_loop
	rts

	CNOP 0,4
cl1_vp2_start_display
	COP_WAIT vp2_hstart,vp2_vstart
	COP_MOVEQ vp2_bplcon0_bits1,BPLCON0
	rts

	CNOP 0,4
cl1_vp2_init_bpldat
	move.l	extra_pf2(a3),a1
	ADDF.W	vp2_pf1_BPL1DAT_x_offset/8,a1 ; bitplane 1
	move.l	#(((cl1_vstart3<<24)|(((cl1_hstart3/4)*2)<<16))|$10000)|$fffe,d0 ; CWAIT
	move.l	#BPL1DAT<<16,d1
	move.l	#BPL2DAT<<16,d2
	move.l	#BPL3DAT<<16,d3
	move.l	#(((CL_Y_WRAPPING<<24)|(((cl1_hstart3/4)*2)<<16))|$10000)|$fffe,d4 ; CWAIT
	move.l	#1<<24,d5
	MOVEF.W vp2_visible_lines_number-1,d7
cl1_vp2_init_bpldat_loop
	move.l	d0,(a0)+		; CWAIT
	move.l	d3,(a0)+		; BPL3DAT
	move.l	d2,(a0)+		; BPL2DAT
	move.l	d1,(a0)+		; BPL1DAT
	ADDF.W	extra_pf2_plane_width*extra_pf2_depth,a1 ; next line in source
	COP_MOVEQ 0,NOOP
	cmp.l	d4,d0			; y wrapping ?
	bne.s	cl1_vp2_init_bpldat_skip
	subq.w	#LONGWORD_SIZE,a0
	COP_WAIT CL_X_WRAPPING,CL_Y_WRAPPING ; patch cl
cl1_vp2_init_bpldat_skip
	add.l	d5,d0			; next line in cl
	dbf	d7,cl1_vp2_init_bpldat_loop
	rts


	COP_INIT_COPINT cl1,cl1_hstart4,cl1_vstart4


	CNOP 0,4
cl1_vp1_set_bitplane_pointers
	move.l	cl1_display(a3),a0
	ADDF.W	cl1_extension1_entry+cl1_ext1_BPL1PTH+WORD_SIZE,a0
	move.l	extra_pf1(a3),d0
	moveq	#extra_pf1_plane_width,d1
	moveq	#extra_pf1_depth-1,d7
cl1_vp1_set_bitplane_pointers_loop
	swap	d0
	move.w	d0,(a0) 	; BPLxPTH
	addq.w	#QUADWORD_SIZE,a0
	swap	d0
	move.w	d0,LONGWORD_SIZE-QUADWORD_SIZE(a0) ; BPLxPTL
	add.l	d1,d0		; next bitplane
	dbf	d7,cl1_vp1_set_bitplane_pointers_loop
	rts


	CNOP 0,4
cl1_vp2_set_bitplane_pointers
	move.l	cl1_display(a3),a0
	ADDF.W	cl1_extension5_entry+cl1_ext5_BPL1PTH+WORD_SIZE,a0
	move.l	extra_pf2(a3),d0
	addq.l	#WORD_SIZE,d0
	moveq	#extra_pf2_plane_width,d1
	moveq	#extra_pf2_depth-1,d7
cl1_vp2_set_bitplane_pointers_loop
	swap	d0
	move.w	d0,(a0) 	; BPLxPTH
	addq.w	#QUADWORD_SIZE,a0
	swap	d0
	move.w	d0,LONGWORD_SIZE-QUADWORD_SIZE(a0) ; BPLxPTL
	add.l	d1,d0		; next bitplane
	dbf	d7,cl1_vp2_set_bitplane_pointers_loop
	rts


	CNOP 0,4
init_second_copperlist
	move.l	cl2_display(a3),a0
	COP_LISTEND
	rts


	CNOP 0,4
main
	bsr.s	no_sync_routines
	bra	beam_routines


	CNOP 0,4
no_sync_routines
	rts


	CNOP 0,4
beam_routines
	bsr	wait_copint
	bsr.s	textwriter
	bsr	tw_display_cursor
	bsr	cl1_update_bpl1dat
	bsr	control_counters
	btst	#CIAB_GAMEPORT0,CIAPRA(a4) ; LMB pressed ?
	bne.s	beam_routines
	rts


; Input
; Result
	CNOP 0,4
textwriter
	move.l	a4,-(a7)
	tst.w	tw_active(a3)
	bne.s	textwriter_quit
	bsr.s	tw_get_new_char_image
	move.l	d0,a0			; store character image address
	moveq	#0,d0
	move.w	tw_text_char_x_position(a3),d0
	move.w	d0,d3			; store x
	lsr.w	#3,d0			; byte offset
	move.w	tw_text_char_y_position(a3),d1
	move.w	d1,d4			; store y
	MULUF.W extra_pf2_plane_width*extra_pf2_depth,d1,d2 ; y offset in playfield
	add.w	d1,d0			; x offset + y offset
	move.l	extra_pf2(a3),a1
	add.l	d0,a1			; add playfield address
	bsr	tw_clear_cursor_data
	move.w	#extra_pf2_plane_width,a2
	move.w	#tw_image_plane_width,a4
	bsr	tw_copy_character_data
	ADDF.W	tw_text_char_x_size,d3	; next text column
	cmp.w	#tw_max_x_position,d3
	ble.s	textwriter_skip
	ADDF.W	tw_text_char_y_size+1,d4 ; next text line
	moveq	#0,d3			; reset x in text line
textwriter_skip
	move.w	d3,tw_text_char_x_position(a3)
	move.w	d4,tw_text_char_y_position(a3)
	move.w	d3,tw_cursor_x_position(a3)
	move.w	d4,tw_cursor_y_position(a3)
	move.w	#FALSE,tw_active(a3)
textwriter_quit
	move.l	(a7)+,a4
	rts


	GET_NEW_CHAR_IMAGE.W tw,tw_check_control_codes,NORESTART

; Input
; d0.b	ASCII-Code
; Result
; d0.l	Return code
	CNOP 0,4
tw_check_control_codes
	cmp.b	#ASCII_CTRL_M,d0
	beq.s	tw_carriage_return
	cmp.b	#ASCII_CTRL_S,d0
	beq.s	tw_stop_textwriter
	rts
	CNOP 0,4
tw_carriage_return
	move.w	#tw_delay,tw_delay_counter(a3)
	bsr.s	tw_clear_cursor
	moveq	#tw_text_char_y_size+1,d0
	add.w	d0,tw_text_char_y_position(a3) ; next text line
	add.w	d0,tw_cursor_y_position(a3)
	moveq	#0,d0
	move.w	d0,tw_text_char_x_position(a3) ; reset x
	move.w	d0,tw_cursor_x_position(a3)
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
tw_stop_textwriter
	bsr.s	tw_clear_cursor
	moveq	#FALSE,d0
	move.w	d0,tw_delay_counter(a3)	; disable counter
	move.w	d0,tw_cursor_active(a3)
	moveq	#RETURN_OK,d0
	rts


; Input
; a0.l		character image
; a1.l	 bitplane 1
; a2.l	Plane width
; a4.l	Plane width character image
; Result
	CNOP 0,4
tw_copy_character_data
	WAITBLIT
	moveq	#tw_text_char_y_size-1,d7
tw_copy_character_data_loop
	move.w	(a0),(a1)	; copy 16 pixel into bitplane 1
	add.l	a4,a0		; next line in character
	add.l	a2,a1		; next line in playfield
	move.w	(a0),(a1)	; copy 16 pixel into bitplane 2
	add.l	a4,a0		; next line in character
	add.l	a2,a1		; next line in playfield
	add.l	a2,a1		; skip bitplane 3 in playfield
	dbf	d7,tw_copy_character_data_loop
	rts


; Input
; Result
	CNOP 0,4
tw_clear_cursor
	moveq	#0,d0
	move.w	tw_cursor_x_position(a3),d0
	lsr.w	#3,d0			; byte offset
	move.w	tw_cursor_y_position(a3),d3
	MULUF.W extra_pf2_plane_width*extra_pf2_depth,d3,d2 ; y offset in playfield
	add.w	d3,d0			; x offset + y offset
	move.l	extra_pf2(a3),a1
	add.l	d0,a1			; add playfield address
	bsr.s	tw_clear_cursor_data
	rts


; Input
; a1.l	 bitplane 1
; Result
	CNOP 0,4
tw_clear_cursor_data
	WAITBLIT
	move.l	#BC0F_DEST<<16,BLTCON0-DMACONR(a6) ; minterm clear
	move.l	a1,BLTDPT-DMACONR(a6)
	move.w	#extra_pf2_plane_width-tw_text_char_width,BLTDMOD-DMACONR(a6)
	move.w	#((tw_text_cursor_y_size*tw_text_cursor_depth)<<6)|(tw_text_cursor_x_size/WORD_BITS),BLTSIZE-DMACONR(a6)
	rts


; Input
; Result
	CNOP 0,4
tw_display_cursor
	tst.w	tw_cursor_active(a3)
	bne.s	tw_display_cursor_quit
	moveq	#0,d0
	move.w	tw_cursor_x_position(a3),d0
	lsr.w	#3,d0			; byte offset
	move.w	tw_cursor_y_position(a3),d1
	MULUF.W extra_pf2_plane_width*extra_pf2_depth,d1,d2 ; y offset in playfield
	add.w	d1,d0			; x offset + y offset
	move.l	extra_pf2(a3),a1
	add.l	d0,a1			; add playfield address
	WAITBLIT
	move.l	#(BC0F_DEST|ANBNC|ANBC|ABNC|ABC)<<16,BLTCON0-DMACONR(a6) ; minterm D=A
	moveq	#-1,d0
	move.l	d0,BLTAFWM-DMACONR(a6)
	move.w	#%1111111111111100,BLTADAT-DMACONR(a6)	; cursor bitplane data
	move.l	a1,BLTDPT-DMACONR(a6)
	move.w	#extra_pf2_plane_width-tw_text_cursor_width,BLTDMOD-DMACONR(a6)
	move.w	#((tw_text_cursor_y_size*tw_text_cursor_depth)<<6)|(tw_text_cursor_x_size/WORD_BITS),BLTSIZE-DMACONR(a6)
tw_display_cursor_quit
	rts


	CNOP 0,4
cl1_update_bpl1dat
	MOVEF.L	extra_pf2_plane_width*extra_pf2_depth,d1
	MOVEF.L cl1_extension6_size,d2
	move.l	extra_pf2(a3),a0
	ADDF.W	vp2_pf1_bpl1dat_x_offset/8,a0
	move.l	cl1_display(a3),a1
	ADDF.W	cl1_extension6_entry+cl1_ext6_BPL1DAT+WORD_SIZE,a1
	MOVEF.W (vp2_visible_lines_number/16)-1,d7
cl1_update_bpl1dat_loop
	REPT 16
		move.w	extra_pf2_plane_width*2(a0),cl1_ext6_BPL3DAT-cl1_ext6_BPL1DAT(a1) ; 1st word bitplane 3
		move.w	extra_pf2_plane_width*1(a0),cl1_ext6_BPL2DAT-cl1_ext6_BPL1DAT(a1) ; 1st word bitplane 2
		move.w	(a0),(a1)	; 1st word bitplane 1
		add.l	d1,a0		; next line in playfield
		add.l	d2,a1		; next line in cl
	ENDR
	dbf	d7,cl1_update_bpl1dat_loop
	rts


; Input
; Result
	CNOP 0,4
control_counters
	move.w	tw_delay_counter(a3),d0
	bmi.s	control_counters_skip2
	subq.w	#1,d0
	bne.s	control_counters_skip1
	MOVEF.W	tw_delay,d0		; reset counter
	clr.w	tw_active(a3)
control_counters_skip1
	move.w	d0,tw_delay_counter(a3)
control_counters_skip2
	rts


	INCLUDE "int-autovectors-handlers.i"

	IFEQ pt_ciatiming_enabled
		CNOP 0,4
ciab_ta_server
	ENDC

	IFNE pt_ciatiming_enabled
		CNOP 0,4
VERTB_server
	ENDC


; PT-Replay
	IFEQ pt_music_fader_enabled
		bsr.s	pt_music_fader
		bra.s	pt_PlayMusic

		PT_FADE_OUT_VOLUME

		CNOP 0,4
	ENDC

	IFD PROTRACKER_VERSION_2
		PT2_REPLAY
	ENDC
	IFD PROTRACKER_VERSION_3
		PT3_REPLAY
	ENDC

	CNOP 0,4
ciab_tb_server
	PT_TIMER_INTERRUPT_SERVER

	CNOP 0,4
EXTER_server
	rts

	CNOP 0,4
NMI_server
	rts


	INCLUDE "help-routines.i"


	INCLUDE "sys-structures.i"


	CNOP 0,2
pf1_rgb4_color_table
	DC.W color00_bits

	CNOP 0,2
vp1_pf1_rgb4_color_table
	INCLUDE "Lowres4:colortables/352x70x16-Lowres4.ct"

	CNOP 0,2
vp2_pf1_rgb4_color_table
	DC.W color00_bits,$fff,$081,color00_bits ; text colors
	DC.W color00_bits,color00_bits,color00_bits
	DC.W $931			; cursor color


; PT-Replay
	INCLUDE "music-tracker/pt-invert-table.i"

	INCLUDE "music-tracker/pt-vibrato-tremolo-table.i"

	IFD PROTRACKER_VERSION_2
		INCLUDE "music-tracker/pt2-period-table.i"
	ENDC
	IFD PROTRACKER_VERSION_3
		INCLUDE "music-tracker/pt3-period-table.i"
	ENDC

	INCLUDE "music-tracker/pt-temp-channel-data-tables.i"

	INCLUDE "music-tracker/pt-sample-starts-table.i"

	INCLUDE "music-tracker/pt-finetune-starts-table.i"


; Textwriter
tw_ascii
	DC.B "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?-'():\/#*@ß$§ "
tw_ascii_end
	EVEN

	CNOP 0,2
tw_chars_offsets
	DS.W tw_ascii_end-tw_ascii


	INCLUDE "sys-variables.i"


	INCLUDE "sys-names.i"


	INCLUDE "error-texts.i"


	DC.B "$VER: "
	DC.B "PT-Replay"
	DC.B "4.3 "
	DC.B "(15.4.25) "
	DC.B "by Christian Gerbig",0
	EVEN


; Textwriter
tw_text
	DC.B ASCII_CTRL_M
	DC.B "WELCOME TO"
	DC.B ASCII_CTRL_M
	DC.B ASCII_CTRL_M
	DC.B "LOWRES PARTY VOLUME 4"
	DC.B ASCII_CTRL_M
	DC.B ASCII_CTRL_M
	DC.B ASCII_CTRL_M
	DC.B ASCII_CTRL_M
	DC.B ASCII_CTRL_M
	DC.B "SEE YOU..."
	DC.B ASCII_CTRL_S
tw_text_end
	EVEN


; Audio data

; PT-Replay
	IFEQ pt_split_module_enabled
pt_auddata			SECTION pt_audio,DATA
		INCBIN "Lowres4:Modules/MOD.beats'n'bits.song"
pt_audsmps			SECTION pt_audio2,DATA_C
		INCBIN "Lowres4:Modules/MOD.beats'n'bits.smps"
	ELSE
pt_auddata			SECTION pt_audio,DATA_C
		INCBIN "Lowres4:Modules/MOD.beats'n'bits"
	ENDC


; Gfx data

; Logo
lg_image_data			SECTION lg_gfx,DATA
	INCBIN "Lowres4:graphics/352x70x16-Lowres4.rawblit"

; Textwriter
tw_image_data			SECTION tw_gfx,DATA
	INCBIN "Lowres4:fonts/16x15x4-Font.rawblit"

	END
