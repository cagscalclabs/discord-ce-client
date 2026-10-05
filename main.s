	.section	.text,"ax",@progbits
	assume	adl = 1
	public	_main                           ; -- Begin function main
_main:                                  ; @main
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -4
	add	hl, sp
	ld	sp, hl
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), hl
	call	_lwip_example_stack_start
	bit	0, a
	jr	nz, BB0_2
	jr	BB0_1
	private	BB0_1
BB0_1:
	call	_lwip_example_gfx_stop
	ld	hl, 1
	ld	(ix - 3), hl
	jp	BB0_28
	private	BB0_2
BB0_2:
	ld	hl, 15088
	push	hl
	call	_mem_request
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(_g), hl
	ld	hl, (_g)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB0_4
	jr	BB0_3
	private	BB0_3
BB0_3:
	ld	hl, _.str.1
	push	hl
	ld	hl, _.str
	push	hl
	call	_lwip_example_show_and_wait
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	hl, 1
	push	hl
	call	_lwip_example_finish
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 3), hl
	jp	BB0_28
	private	BB0_4
BB0_4:
	ld	hl, (_g)
	ld	de, 15088
	push	de
	ld	de, 0
	push	de
	push	hl
	call	_memset
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	call	_palette
	call	_load
	ld	hl, _stack_event
	push	hl
	call	_lwip_set_event_cb
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB0_5
	private	BB0_5
BB0_5:                                  ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_11 Depth 2
	call	_setup
	bit	0, a
	jp	z, BB0_27
	jr	BB0_6
	private	BB0_6
BB0_6:                                  ;   in Loop: Header=BB0_5 Depth=1
	call	_run
	ld	hl, (_g)
	ld	de, 214
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB0_8
	jr	BB0_7
	private	BB0_7
BB0_7:                                  ;   in Loop: Header=BB0_5 Depth=1
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	push	hl
	call	_lwip_socket_destroy
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 214
	add	hl, de
	ld	(hl), 0
	jr	BB0_8
	private	BB0_8
BB0_8:                                  ;   in Loop: Header=BB0_5 Depth=1
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB0_10
	jr	BB0_9
	private	BB0_9
BB0_9:                                  ;   in Loop: Header=BB0_5 Depth=1
	call	_save_token
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	(hl), 0
	jr	BB0_10
	private	BB0_10
BB0_10:                                 ;   in Loop: Header=BB0_5 Depth=1
	call	_clear_selection
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	(hl), 1
	call	_render
	ld	(ix - 4), 0
	jr	BB0_11
	private	BB0_11
BB0_11:                                 ;   Parent Loop BB0_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	a, (ix - 4)
	cp	a, 6
	ld	a, 0
	jr	z, BB0_16
	jr	BB0_12
	private	BB0_12
BB0_12:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	a, (ix - 4)
	cp	a, 1
	ld	a, 0
	jr	z, BB0_16
	jr	BB0_13
	private	BB0_13
BB0_13:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	a, (ix - 4)
	cp	a, 3
	ld	a, -1
	ld	l, 0
	jr	nz, BB0_15
; %bb.14:                               ;   in Loop: Header=BB0_11 Depth=2
	ld	a, l
	private	BB0_15
BB0_15:                                 ;   in Loop: Header=BB0_11 Depth=2
	jr	BB0_16
	private	BB0_16
BB0_16:                                 ;   in Loop: Header=BB0_11 Depth=2
	bit	0, a
	jp	z, BB0_24
	jr	BB0_17
	private	BB0_17
BB0_17:                                 ;   in Loop: Header=BB0_11 Depth=2
	call	_lwip_service_events
	call	_os_GetCSC
	ld	(ix - 4), a
	ld	a, (ix - 4)
	cp	a, 4
	jr	nz, BB0_20
	jr	BB0_18
	private	BB0_18
BB0_18:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	hl, (_g)
	ld	de, 2561
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	z, BB0_20
	jr	BB0_19
	private	BB0_19
BB0_19:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	hl, (_g)
	ld	de, 2561
	add	hl, de
	dec	(hl)
	call	_render
	jr	BB0_20
	private	BB0_20
BB0_20:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	a, (ix - 4)
	cp	a, 5
	jr	nz, BB0_23
	jr	BB0_21
	private	BB0_21
BB0_21:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	hl, (_g)
	ld	de, 2561
	add	hl, de
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, 17
	add	hl, de
	ld	iy, (_g)
	ld	de, 2560
	add	iy, de
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jr	nc, BB0_23
	jr	BB0_22
	private	BB0_22
BB0_22:                                 ;   in Loop: Header=BB0_11 Depth=2
	ld	hl, (_g)
	ld	de, 2561
	add	hl, de
	inc	(hl)
	call	_render
	jr	BB0_23
	private	BB0_23
BB0_23:                                 ;   in Loop: Header=BB0_11 Depth=2
	jp	BB0_11
	private	BB0_24
BB0_24:                                 ;   in Loop: Header=BB0_5 Depth=1
	ld	a, (ix - 4)
	cp	a, 6
	jr	z, BB0_26
	jr	BB0_25
	private	BB0_25
BB0_25:
	jr	BB0_27
	private	BB0_26
BB0_26:                                 ;   in Loop: Header=BB0_5 Depth=1
	ld	hl, (_g)
	ld	de, 1989
	add	hl, de
	ld	(hl), 0
	jp	BB0_5
	private	BB0_27
BB0_27:
	or	a, a
	sbc	hl, hl
	push	hl
	call	_lwip_set_event_cb
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 15088
	push	de
	ld	de, 0
	push	de
	push	hl
	call	_memset
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	push	hl
	call	_mem_release
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	or	a, a
	sbc	hl, hl
	ld	(_g), hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_lwip_example_finish
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 3), hl
	jr	BB0_28
	private	BB0_28
BB0_28:
	ld	hl, (ix - 3)
	ld	iy, 4
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_lwip_example_stack_start:              ; -- Begin function lwip_example_stack_start
                                        ; @lwip_example_stack_start
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	a, 1
	pop	ix
	ret
                                        ; -- End function
_lwip_example_gfx_stop:                 ; -- Begin function lwip_example_gfx_stop
                                        ; @lwip_example_gfx_stop
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	pop	ix
	ret
                                        ; -- End function
_mem_request:                           ; -- Begin function mem_request
                                        ; @mem_request
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (ix - 3)
	push	hl
	call	_malloc
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_lwip_example_show_and_wait:            ; -- Begin function lwip_example_show_and_wait
                                        ; @lwip_example_show_and_wait
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_example_finish:                   ; -- Begin function lwip_example_finish
                                        ; @lwip_example_finish
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (ix - 3)
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_palette:                               ; -- Begin function palette
                                        ; @palette
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, _palette.colors
	ld	de, 12
	ld	bc, 16
	push	bc
	push	de
	push	hl
	call	_gfx_SetPalette
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, 8
	push	hl
	call	_gfx_SetMonospaceFont
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, 1
	push	hl
	push	hl
	call	_gfx_SetTextScale
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_load:                                  ; -- Begin function load
                                        ; @load
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -12
	add	hl, sp
	ld	sp, hl
	ld	de, 209
	ld	bc, 0
	lea	hl, ix - 5
	ld	(ix - 12), hl
	lea	hl, ix - 6
	ld	(ix - 9), hl
	ld	hl, (_g)
	push	de
	push	bc
	push	hl
	call	_memset
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.6
	push	hl
	ld	hl, _.str.5
	push	hl
	call	_ti_Open
	ld	de, 4
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(ix - 1), a
	ld	a, (ix - 1)
	or	a, a
	jp	z, BB7_10
	jr	BB7_1
	private	BB7_1
BB7_1:
	ld	(ix - 6), 0
	ld	a, (ix - 1)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	push	de
	ld	hl, (ix - 12)
	push	hl
	call	_ti_Read
	ld	iy, 12
	add	iy, sp
	ld	sp, iy
	ld	de, 1
	or	a, a
	sbc	hl, de
	jp	nz, BB7_8
	jr	BB7_2
	private	BB7_2
BB7_2:
	ld	hl, 4
	push	hl
	ld	hl, _.str.7
	push	hl
	ld	hl, (ix - 12)
	push	hl
	call	_memcmp
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB7_8
	jr	BB7_3
	private	BB7_3
BB7_3:
	ld	a, (ix - 1)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	push	hl
	ld	hl, (ix - 9)
	push	hl
	call	_ti_Read
	ld	iy, 12
	add	iy, sp
	ld	sp, iy
	ld	de, 1
	or	a, a
	sbc	hl, de
	jp	nz, BB7_8
	jr	BB7_4
	private	BB7_4
BB7_4:
	ld	a, (ix - 6)
	cp	a, 4
	jp	nz, BB7_8
	jr	BB7_5
	private	BB7_5
BB7_5:
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	a, (ix - 1)
	ld	e, a
	push	de
	ld	de, 1
	push	de
	ld	de, 32
	push	de
	push	hl
	call	_ti_Read
	ld	iy, 12
	add	iy, sp
	ld	sp, iy
	ld	de, 1
	or	a, a
	sbc	hl, de
	jr	nz, BB7_8
	jr	BB7_6
	private	BB7_6
BB7_6:
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	de, 32
	push	de
	ld	de, 0
	push	de
	push	hl
	call	_memchr
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB7_8
	jr	BB7_7
	private	BB7_7
BB7_7:
	ld	hl, (_g)
	ld	de, 4
	push	de
	ld	de, _.str.7
	push	de
	push	hl
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	(iy + 4), 4
	jr	BB7_9
	private	BB7_8
BB7_8:
	ld	hl, (_g)
	ld	de, 209
	push	de
	ld	de, 0
	push	de
	push	hl
	call	_memset
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB7_9
	private	BB7_9
BB7_9:
	ld	a, (ix - 1)
	ld	l, a
	push	hl
	call	_ti_Close
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, 4
	ex	de, hl
	jr	BB7_10
	private	BB7_10
BB7_10:
	ld	hl, (_g)
	push	de
	ld	de, _.str.7
	push	de
	push	hl
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	(iy + 4), 4
	ld	iy, (_g)
	ld	a, (iy + 5)
	or	a, a
	jr	nz, BB7_12
	jr	BB7_11
	private	BB7_11
BB7_11:
	ld	iy, (_g)
	lea	hl, iy + 5
	ld	de, _.str.8
	push	de
	ld	de, 128
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB7_12
	private	BB7_12
BB7_12:
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB7_14
	jr	BB7_13
	private	BB7_13
BB7_13:
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	de, _.str.9
	push	de
	ld	de, 32
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB7_14
	private	BB7_14
BB7_14:
	call	_load_token
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	push	hl
	call	_token_valid
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB7_16
	jr	BB7_15
	private	BB7_15
BB7_15:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	ld	(hl), 0
	jr	BB7_16
	private	BB7_16
BB7_16:
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_set_event_cb:                     ; -- Begin function lwip_set_event_cb
                                        ; @lwip_set_event_cb
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_stack_event:                           ; -- Begin function stack_event
                                        ; @stack_event
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -89
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	lea	de, ix - 83
	ld	(ix - 3), hl
	ld	hl, (_g)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB9_4
	jr	BB9_1
	private	BB9_1
BB9_1:
	ld	hl, (_g)
	ld	bc, 213
	add	hl, bc
	ld	a, (hl)
	bit	0, a
	jr	nz, BB9_4
	jr	BB9_2
	private	BB9_2
BB9_2:
	ld	hl, (_g)
	ld	bc, 214
	add	hl, bc
	ld	a, (hl)
	bit	0, a
	jr	z, BB9_4
	jr	BB9_3
	private	BB9_3
BB9_3:
	ld	hl, (ix - 3)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB9_5
	jr	BB9_4
	private	BB9_4
BB9_4:
	jp	BB9_16
	private	BB9_5
BB9_5:
	ld	(ix - 86), de
	ld	iy, (ix - 3)
	ld	a, (iy + 1)
	or	a, a
	jr	nz, BB9_11
	jr	BB9_6
	private	BB9_6
BB9_6:
	ld	hl, (ix - 3)
	ld	a, (hl)
	cp	a, 2
	jr	nz, BB9_11
	jr	BB9_7
	private	BB9_7
BB9_7:
	ld	hl, (_g)
	ld	bc, 2152
	add	hl, bc
	push	hl
	pop	bc
	ld	iy, (ix - 3)
	ld	hl, (iy + 2)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB9_9
	jr	BB9_8
	private	BB9_8
BB9_8:
	ld	iy, (ix - 3)
	ld	de, (iy + 2)
	ld	hl, 80
	jr	BB9_10
	private	BB9_9
BB9_9:
	ld	hl, 80
	ld	de, _.str.8
	jr	BB9_10
	private	BB9_10
BB9_10:
	push	de
	push	hl
	push	bc
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB9_11
	private	BB9_11
BB9_11:
	ld	iy, (ix - 3)
	ld	a, (iy + 1)
	cp	a, 1
	jp	nz, BB9_16
	jr	BB9_12
	private	BB9_12
BB9_12:
	ld	iy, (ix - 3)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	call	_lwip_debug_file_name
	ld	(ix - 89), hl
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	iy, (ix - 3)
	ld	hl, (iy + 2)
	ld	e, (iy + 5)
	ld	bc, -1
	xor	a, a
	call	__land
                                        ; kill: def $e killed $e def $ude
	ld	iy, (ix - 3)
	ld	iy, (iy + 6)
	ld	bc, 0
	ld	c, iyl
	ld	b, iyh
	push	bc
	push	de
	push	hl
	ld	hl, (ix - 89)
	push	hl
	ld	hl, _.str.12
	push	hl
	ld	hl, 80
	push	hl
	ld	hl, (ix - 86)
	push	hl
	call	_snprintf
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 3)
	ld	a, (hl)
	cp	a, 2
	jr	z, BB9_14
	jr	BB9_13
	private	BB9_13
BB9_13:
	ld	hl, (_g)
	ld	de, 2072
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB9_15
	jr	BB9_14
	private	BB9_14
BB9_14:
	ld	hl, (_g)
	ld	de, 2072
	add	hl, de
	ld	de, (ix - 86)
	push	de
	ld	de, 80
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB9_15
	private	BB9_15
BB9_15:
	jr	BB9_16
	private	BB9_16
BB9_16:
	ld	hl, 89
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_setup:                                 ; -- Begin function setup
                                        ; @setup
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -203
	add	hl, sp
	ld	sp, hl
	ld	de, -185
	lea	iy, ix + 0
	add	iy, de
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	or	a, a
	sbc	hl, hl
	lea	bc, iy + 46
	lea	de, iy + 14
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 66
	ld	(iy + 0), de
	ld	(ix - 10), hl
	ld	(ix - 11), 1
	ld	iy, (_g)
	lea	hl, iy + 5
	push	hl
	ld	hl, 128
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	push	bc
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	push	hl
	ld	hl, 32
	push	hl
	ld	de, -194
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB10_1
	private	BB10_1
BB10_1:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB10_43 Depth 2
	call	_lwip_service_events
	call	_os_GetCSC
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	(iy + 13), a
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB10_3
	jr	BB10_2
	private	BB10_2
BB10_2:                                 ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	jr	BB10_4
	private	BB10_3
BB10_3:                                 ;   in Loop: Header=BB10_1 Depth=1
	ld	iy, (_g)
	lea	hl, iy + 5
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 60)
	pop	ix
	jr	BB10_4
	private	BB10_4
BB10_4:                                 ;   in Loop: Header=BB10_1 Depth=1
	ld	(iy + 10), hl
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	hl, 32
	jr	nz, BB10_6
; %bb.5:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, 128
	private	BB10_6
BB10_6:                                 ;   in Loop: Header=BB10_1 Depth=1
	ld	(iy + 7), hl
	ld	hl, (iy + 10)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 60)
	pop	ix
	ld	(iy + 4), hl
	ld	a, (iy + 13)
	cp	a, 3
	jr	z, BB10_8
	jr	BB10_7
	private	BB10_7
BB10_7:                                 ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	cp	a, 1
	jr	nz, BB10_9
	jr	BB10_8
	private	BB10_8
BB10_8:
	ld	(ix - 7), 0
	jp	BB10_60
	private	BB10_9
BB10_9:                                 ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	cp	a, 4
	jr	z, BB10_11
	jr	BB10_10
	private	BB10_10
BB10_10:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	cp	a, 5
	jr	nz, BB10_14
	jr	BB10_11
	private	BB10_11
BB10_11:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	hl, 1
	ld	de, 0
	jr	z, BB10_13
; %bb.12:                               ;   in Loop: Header=BB10_1 Depth=1
	ex	de, hl
	private	BB10_13
BB10_13:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	(ix - 10), hl
	jp	BB10_37
	private	BB10_14
BB10_14:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	cp	a, 12
	jr	nz, BB10_17
	jr	BB10_15
	private	BB10_15
BB10_15:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (iy + 4)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB10_17
	jr	BB10_16
	private	BB10_16
BB10_16:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 10)
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 60)
	pop	ix
	ld	de, (iy + 4)
	push	hl
	pop	iy
	add	iy, de
	ld	(iy - 1), 0
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jp	BB10_36
	private	BB10_17
BB10_17:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	cp	a, 6
	jp	nz, BB10_30
	jr	BB10_18
	private	BB10_18
BB10_18:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB10_20
	jr	BB10_19
	private	BB10_19
BB10_19:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, 1
	ld	(ix - 10), hl
	jp	BB10_29
	private	BB10_20
BB10_20:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	iy, (_g)
	lea	de, iy + 5
	ld	iy, (_g)
	ld	bc, 233
	add	iy, bc
	ld	hl, (_g)
	ld	bc, 362
	add	hl, bc
	push	hl
	ld	hl, 9443
	push	hl
	ld	hl, 128
	push	hl
	push	iy
	push	de
	call	_wire_target
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB10_22
	jr	BB10_21
	private	BB10_21
BB10_21:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.14
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jr	BB10_28
	private	BB10_22
BB10_22:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB10_24
	jr	BB10_23
	private	BB10_23
BB10_23:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.15
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB10_27
	private	BB10_24
BB10_24:
	call	_save
	ld	iy, (_g)
	lea	hl, iy + 5
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB10_26
	jr	BB10_25
	private	BB10_25
BB10_25:
	call	_load_token
	jr	BB10_26
	private	BB10_26
BB10_26:
	ld	(ix - 7), 1
	jp	BB10_60
	private	BB10_27
BB10_27:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jr	BB10_28
	private	BB10_28
BB10_28:                                ;   in Loop: Header=BB10_1 Depth=1
	jr	BB10_29
	private	BB10_29
BB10_29:                                ;   in Loop: Header=BB10_1 Depth=1
	jp	BB10_35
	private	BB10_30
BB10_30:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	ld	l, a
	push	hl
	call	_input_char
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	(iy + 3), a
	ld	a, (iy + 3)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB10_34
	jr	BB10_31
	private	BB10_31
BB10_31:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 3)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, 32
	or	a, a
	sbc	hl, de
	jr	z, BB10_34
	jr	BB10_32
	private	BB10_32
BB10_32:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (iy + 4)
	inc	hl
	ld	de, (iy + 7)
	or	a, a
	sbc	hl, de
	jr	nc, BB10_34
	jr	BB10_33
	private	BB10_33
BB10_33:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 3)
	ld	hl, (iy + 10)
	ld	de, (iy + 4)
	add	hl, de
	ld	(hl), a
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 10)
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 60)
	pop	ix
	ld	de, (iy + 4)
	push	hl
	pop	iy
	add	iy, de
	ld	(iy + 1), 0
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jr	BB10_34
	private	BB10_34
BB10_34:                                ;   in Loop: Header=BB10_1 Depth=1
	jr	BB10_35
	private	BB10_35
BB10_35:                                ;   in Loop: Header=BB10_1 Depth=1
	jr	BB10_36
	private	BB10_36
BB10_36:                                ;   in Loop: Header=BB10_1 Depth=1
	jr	BB10_37
	private	BB10_37
BB10_37:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (iy + 13)
	or	a, a
	jr	z, BB10_39
	jr	BB10_38
	private	BB10_38
BB10_38:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	(ix - 11), 1
	jr	BB10_39
	private	BB10_39
BB10_39:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	a, (ix - 11)
	bit	0, a
	jp	z, BB10_59
	jr	BB10_40
	private	BB10_40
BB10_40:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, 16
	push	hl
	call	_gfx_FillScreen
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, 19
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 320
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	call	_fill
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, _.str.16
	push	hl
	ld	hl, 19
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 4
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	hl, _.str.17
	jr	nz, BB10_42
; %bb.41:                               ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.18
	private	BB10_42
BB10_42:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 28
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	or	a, a
	sbc	hl, hl
	ld	(iy + 0), hl
	jr	BB10_43
	private	BB10_43
BB10_43:                                ;   Parent Loop BB10_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	hl, (iy + 0)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	a, 0
	jp	nc, BB10_45
	jr	BB10_44
	private	BB10_44
BB10_44:                                ;   in Loop: Header=BB10_43 Depth=2
	ld	hl, (iy + 0)
	ld	bc, 39
	call	__imulu
	ld	de, -200
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	iy, (_g)
	lea	hl, iy + 5
	push	hl
	call	_strlen
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 60)
	pop	ix
	push	hl
	pop	de
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	push	ix
	lea	ix, ix - 128
	ld	hl, (ix - 72)
	pop	ix
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB10_45
	private	BB10_45
BB10_45:                                ;   in Loop: Header=BB10_43 Depth=2
	bit	0, a
	jp	z, BB10_48
	jr	BB10_46
	private	BB10_46
BB10_46:                                ;   in Loop: Header=BB10_43 Depth=2
	ld	hl, (iy + 0)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	pop	de
	ld	hl, 40
	add	hl, de
	push	ix
	lea	ix, ix - 128
	ld	(ix - 69), hl
	pop	ix
	ld	hl, (_g)
	push	ix
	lea	ix, ix - 128
	ld	(ix - 75), hl
	pop	ix
	ld	hl, (iy + 0)
	ld	bc, 39
	call	__imulu
	push	hl
	pop	de
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 75)
	pop	ix
	add	iy, de
	lea	hl, iy + 5
	push	bc
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	de, -197
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	jr	BB10_47
	private	BB10_47
BB10_47:                                ;   in Loop: Header=BB10_43 Depth=2
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 0)
	inc	hl
	ld	(iy + 0), hl
	jp	BB10_43
	private	BB10_48
BB10_48:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	hl, _.str.19
	jr	nz, BB10_50
; %bb.49:                               ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.20
	private	BB10_50
BB10_50:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 86
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 100
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, _.str.21
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 124
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, _.str.22
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 140
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, _.str.23
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 164
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 10987
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB10_52
	jr	BB10_51
	private	BB10_51
BB10_51:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.24
	jr	BB10_58
	private	BB10_52
BB10_52:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (_g)
	ld	de, 10986
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB10_54
	jr	BB10_53
	private	BB10_53
BB10_53:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.25
	jr	BB10_57
	private	BB10_54
BB10_54:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, (_g)
	ld	de, 10986
	add	hl, de
	ld	a, (hl)
	cp	a, 1
	ld	hl, _.str.26
	jr	z, BB10_56
; %bb.55:                               ;   in Loop: Header=BB10_1 Depth=1
	ld	hl, _.str.27
	private	BB10_56
BB10_56:                                ;   in Loop: Header=BB10_1 Depth=1
	jr	BB10_57
	private	BB10_57
BB10_57:                                ;   in Loop: Header=BB10_1 Depth=1
	jr	BB10_58
	private	BB10_58
BB10_58:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 180
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 1989
	add	hl, de
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 21
	push	hl
	ld	hl, 204
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, _.str.28
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 224
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	call	_gfx_BlitBuffer
	ld	(ix - 11), 0
	jr	BB10_59
	private	BB10_59
BB10_59:                                ;   in Loop: Header=BB10_1 Depth=1
	jp	BB10_1
	private	BB10_60
BB10_60:
	ld	a, (ix - 7)
	ld	hl, 203
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_run:                                   ; -- Begin function run
                                        ; @run
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -170
	add	hl, sp
	ld	sp, hl
	ld	de, -153
	lea	iy, ix + 0
	add	iy, de
	ld	bc, 0
	ld	de, -156
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	lea	hl, iy + 12
	ld	de, -159
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	hl, (_g)
	ld	de, 220
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 224
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 214
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 589
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 15084
	add	hl, de
	ld	(hl), bc
	ld	iy, (_g)
	ld	de, 2566
	add	iy, de
	ld	(iy), bc
	lea	hl, iy + 3
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	(hl), bc
	ld	hl, (_g)
	ld	de, 2232
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2152
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2072
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2561
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2560
	add	hl, de
	ld	(hl), 0
	call	_clear_selection
	ld	hl, (_g)
	ld	de, 487
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 406
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	ld	de, 0
	push	de
	ld	de, 45000
	push	de
	ld	de, 0
	push	de
	ld	de, 2
	push	de
	ld	de, 1
	push	de
	push	hl
	call	_lwip_socket_create
	ld	iy, 18
	add	iy, sp
	ld	sp, iy
	ld	(ix - 9), hl
	ld	hl, (ix - 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB11_2
	jr	BB11_1
	private	BB11_1
BB11_1:
	ld	hl, _.str.35
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB11_76
	private	BB11_2
BB11_2:
	ld	hl, (_g)
	ld	de, 214
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	ld	de, 0
	push	de
	ld	de, _event
	push	de
	ld	de, 8
	push	de
	push	hl
	call	_lwip_socket_on_event
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	ld	hl, (hl)
	ld	de, 0
	push	de
	push	de
	ld	de, 0
	push	de
	ld	de, 45000
	push	de
	ld	de, 7
	push	de
	push	hl
	call	_lwip_netif_request_services
	ld	iy, 18
	add	iy, sp
	ld	sp, iy
	ld	(ix - 9), hl
	ld	hl, (ix - 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB11_4
	jr	BB11_3
	private	BB11_3
BB11_3:
	ld	hl, _.str.36
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB11_76
	private	BB11_4
BB11_4:
	ld	hl, (_g)
	ld	de, 220
	add	hl, de
	ld	(hl), 1
	call	_lwip_now_ms
	ld	iy, (_g)
	ld	bc, 2598
	add	iy, bc
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), e
	ld	hl, _.str.37
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	call	_render
	jr	BB11_5
	private	BB11_5
BB11_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB11_17 Depth 2
                                        ;       Child Loop BB11_27 Depth 3
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	nz, BB11_76
	jr	BB11_6
	private	BB11_6
BB11_6:                                 ;   in Loop: Header=BB11_5 Depth=1
	call	_lwip_service_events
	call	_lwip_now_ms
	ld	(ix - 13), hl
	ld	(ix - 10), e
	ld	hl, (_g)
	ld	de, 220
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB11_16
	jr	BB11_7
	private	BB11_7
BB11_7:                                 ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2598
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, 45000
	xor	a, a
	call	__lcmpu
	jr	c, BB11_9
	jr	BB11_8
	private	BB11_8
BB11_8:                                 ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, _.str.38
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB11_15
	private	BB11_9
BB11_9:                                 ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	ld	hl, (hl)
	ld	de, 3
	push	de
	push	hl
	call	_lwip_are_services_ready
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB11_14
	jr	BB11_10
	private	BB11_10
BB11_10:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 220
	add	hl, de
	ld	(hl), 0
	ld	iy, (_g)
	ld	de, 233
	add	iy, de
	ld	hl, (_g)
	ld	de, 362
	add	hl, de
	ld	hl, (hl)
	ld	de, 0
	ld	e, l
	ld	d, h
	push	de
	push	iy
	ld	hl, _.str.39
	push	hl
	call	_status
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	push	hl
	pop	bc
	ld	hl, (_g)
	ld	de, 233
	add	hl, de
	ld	iy, (_g)
	ld	de, 362
	add	iy, de
	ld	de, (iy)
	push	de
	push	hl
	push	bc
	call	_lwip_socket_connect
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	ld	(ix - 9), hl
	ld	hl, (ix - 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB11_12
	jr	BB11_11
	private	BB11_11
BB11_11:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, _.str.40
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB11_13
	private	BB11_12
BB11_12:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	de, (ix - 13)
	ld	a, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2590
	add	iy, bc
	ld	(iy), de
	lea	hl, iy + 3
	ld	(hl), a
	ld	iy, (_g)
	ld	bc, 2586
	add	iy, bc
	ld	(iy), de
	lea	hl, iy + 3
	ld	(hl), a
	ld	iy, (_g)
	ld	bc, 2582
	add	iy, bc
	ld	(iy), de
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB11_13
	private	BB11_13
BB11_13:                                ;   in Loop: Header=BB11_5 Depth=1
	jr	BB11_14
	private	BB11_14
BB11_14:                                ;   in Loop: Header=BB11_5 Depth=1
	jr	BB11_15
	private	BB11_15
BB11_15:                                ;   in Loop: Header=BB11_5 Depth=1
	jr	BB11_16
	private	BB11_16
BB11_16:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	de, -156
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 8192
	ld	(iy + 9), hl
	jr	BB11_17
	private	BB11_17
BB11_17:                                ;   Parent Loop BB11_5 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB11_27 Depth 3
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	a, 0
	jr	nz, BB11_23
	jr	BB11_18
	private	BB11_18
BB11_18:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	a, 0
	jr	z, BB11_23
	jr	BB11_19
	private	BB11_19
BB11_19:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	push	hl
	call	_lwip_socket_available
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 28)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, 0
	jr	z, BB11_23
	jr	BB11_20
	private	BB11_20
BB11_20:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	hl, (iy + 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, -1
	ld	l, 0
	jr	nz, BB11_22
; %bb.21:                               ;   in Loop: Header=BB11_17 Depth=2
	ld	a, l
	private	BB11_22
BB11_22:                                ;   in Loop: Header=BB11_17 Depth=2
	jr	BB11_23
	private	BB11_23
BB11_23:                                ;   in Loop: Header=BB11_17 Depth=2
	bit	0, a
	jp	z, BB11_36
	jr	BB11_24
	private	BB11_24
BB11_24:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	ld	de, 128
	push	de
	ld	bc, -159
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	call	_lwip_socket_read
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 28)
	pop	ix
	ld	(iy + 6), hl
	ld	hl, (iy + 6)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB11_26
	jr	BB11_25
	private	BB11_25
BB11_25:                                ;   in Loop: Header=BB11_5 Depth=1
	jp	BB11_36
	private	BB11_26
BB11_26:                                ;   in Loop: Header=BB11_17 Depth=2
	or	a, a
	sbc	hl, hl
	ld	(iy + 3), hl
	jr	BB11_27
	private	BB11_27
BB11_27:                                ;   Parent Loop BB11_5 Depth=1
                                        ;     Parent Loop BB11_17 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ld	hl, (iy + 3)
	ld	de, (iy + 6)
	or	a, a
	sbc	hl, de
	ld	l, 0
	jr	nc, BB11_29
	jr	BB11_28
	private	BB11_28
BB11_28:                                ;   in Loop: Header=BB11_27 Depth=3
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	ld	l, 1
	xor	a, l
	ld	l, a
	jr	BB11_29
	private	BB11_29
BB11_29:                                ;   in Loop: Header=BB11_27 Depth=3
	bit	0, l
	jr	z, BB11_32
	jr	BB11_30
	private	BB11_30
BB11_30:                                ;   in Loop: Header=BB11_27 Depth=3
	ld	de, (iy + 3)
	ld	bc, -159
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	ld	a, (hl)
	ld	l, a
	push	hl
	call	_feed
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB11_31
	private	BB11_31
BB11_31:                                ;   in Loop: Header=BB11_27 Depth=3
	ld	de, -156
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 3)
	inc	hl
	ld	(iy + 3), hl
	jr	BB11_27
	private	BB11_32
BB11_32:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	de, (iy + 9)
	ld	hl, (iy + 6)
	or	a, a
	sbc	hl, de
	jr	nc, BB11_34
	jr	BB11_33
	private	BB11_33
BB11_33:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	hl, (iy + 9)
	ld	de, (iy + 6)
	or	a, a
	sbc	hl, de
	jr	BB11_35
	private	BB11_34
BB11_34:                                ;   in Loop: Header=BB11_17 Depth=2
	or	a, a
	sbc	hl, hl
	jr	BB11_35
	private	BB11_35
BB11_35:                                ;   in Loop: Header=BB11_17 Depth=2
	ld	(iy + 9), hl
	jp	BB11_17
	private	BB11_36
BB11_36:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 226
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_40
	jr	BB11_37
	private	BB11_37
BB11_37:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_40
	jr	BB11_38
	private	BB11_38
BB11_38:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB11_40
	jr	BB11_39
	private	BB11_39
BB11_39:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 226
	add	hl, de
	ld	(hl), 0
	or	a, a
	sbc	hl, hl
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB11_40
	private	BB11_40
BB11_40:                                ;   in Loop: Header=BB11_5 Depth=1
	call	_os_GetCSC
	ld	l, a
	push	hl
	call	_handle_key
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	call	_lwip_now_ms
	ld	(ix - 13), hl
	ld	(ix - 10), e
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_44
	jr	BB11_41
	private	BB11_41
BB11_41:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB11_44
	jr	BB11_42
	private	BB11_42
BB11_42:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2582
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, 30000
	xor	a, a
	call	__lcmpu
	jr	c, BB11_44
	jr	BB11_43
	private	BB11_43
BB11_43:                                ;   in Loop: Header=BB11_5 Depth=1
	or	a, a
	sbc	hl, hl
	push	hl
	ld	de, _.str.41
	push	de
	push	hl
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 13)
	ld	a, (ix - 10)
	ld	iy, (_g)
	ld	de, 2582
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB11_44
	private	BB11_44
BB11_44:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_47
	jr	BB11_45
	private	BB11_45
BB11_45:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2586
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, 90000
	xor	a, a
	call	__lcmpu
	jr	c, BB11_47
	jr	BB11_46
	private	BB11_46
BB11_46:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, _.str.42
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB11_47
	private	BB11_47
BB11_47:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB11_55
	jr	BB11_48
	private	BB11_48
BB11_48:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB11_51
	jr	BB11_49
	private	BB11_49
BB11_49:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB11_51
	jr	BB11_50
	private	BB11_50
BB11_50:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_55
	jr	BB11_51
	private	BB11_51
BB11_51:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2590
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, 60000
	xor	a, a
	call	__lcmpu
	jr	c, BB11_55
	jr	BB11_52
	private	BB11_52
BB11_52:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	hl, _.str.43
	jr	nz, BB11_54
; %bb.53:                               ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, _.str.44
	private	BB11_54
BB11_54:                                ;   in Loop: Header=BB11_5 Depth=1
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB11_55
	private	BB11_55
BB11_55:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 224
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_58
	jr	BB11_56
	private	BB11_56
BB11_56:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2586
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, 5000
	xor	a, a
	call	__lcmpu
	jr	c, BB11_58
	jr	BB11_57
	private	BB11_57
BB11_57:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, _.str.45
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB11_58
	private	BB11_58
BB11_58:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	iy, (_g)
	ld	de, 2566
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	call	__lcmpzero
	jp	z, BB11_61
	jr	BB11_59
	private	BB11_59
BB11_59:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2562
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, -162
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, e
	ld	l, 0
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 28)
	pop	ix
	ld	(iy + 0), l
	ld	de, (iy - 2)
	ld	d, l
	ld	c, l
	ld	e, a
	push	ix
	lea	ix, ix - 128
	ld	(ix - 39), de
	pop	ix
	or	a, a
	sbc	hl, hl
	push	ix
	lea	ix, ix - 128
	ld	(ix - 36), l
	ld	(ix - 35), h
	pop	ix
	ld	a, -45
	ld	l, 77
	ld	h, 98
	ld	(iy + 1), h
	ld	de, (iy - 1)
	ld	d, l
	ld	e, a
	ld	a, c
	ld	(iy + 2), a
	ld	hl, (iy + 0)
	ld	h, a
	ld	a, 16
	ld	l, a
	ld	bc, 0
	ld	iyl, c
	ld	iyh, b
	push	iy
	push	hl
	push	de
	ld	de, -162
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	ld	bc, -167
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 36
	ld	c, (iy + 0)
	ld	b, (iy + 1)
	call	__llmulu
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	ld	iy, 32
	push	iy
	call	__llshru
	push	hl
	pop	bc
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	a, e
	ld	l, 6
	call	__lshru
	ld	de, -170
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	ld	iy, (_g)
	ld	de, 2566
	add	iy, de
	ld	bc, (iy)
	lea	hl, iy + 3
	ld	d, (hl)
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 42
	ld	hl, (iy + 0)
	ld	e, a
	ld	a, d
	call	__lcmpu
	jr	c, BB11_61
	jr	BB11_60
	private	BB11_60
BB11_60:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, _.str.46
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB11_61
	private	BB11_61
BB11_61:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB11_73
	jr	BB11_62
	private	BB11_62
BB11_62:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	nz, BB11_73
	jr	BB11_63
	private	BB11_63
BB11_63:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	nz, BB11_73
	jr	BB11_64
	private	BB11_64
BB11_64:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (ix - 13)
	ld	e, (ix - 10)
	ld	iy, (_g)
	ld	bc, 2594
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, 1500
	xor	a, a
	call	__lcmpu
	jp	c, BB11_73
	jr	BB11_65
	private	BB11_65
BB11_65:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 221
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_68
	jr	BB11_66
	private	BB11_66
BB11_66:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 5
	or	a, a
	sbc	hl, de
	jr	nz, BB11_68
	jr	BB11_67
	private	BB11_67
BB11_67:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 221
	add	hl, de
	ld	(hl), 0
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	de, (iy)
	lea	hl, iy + 3
	ld	a, (hl)
	ld	l, a
	push	hl
	push	de
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 13)
	ld	a, (ix - 10)
	ld	iy, (_g)
	ld	de, 2594
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB11_72
	private	BB11_68
BB11_68:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 222
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_71
	jr	BB11_69
	private	BB11_69
BB11_69:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB11_71
	jr	BB11_70
	private	BB11_70
BB11_70:                                ;   in Loop: Header=BB11_5 Depth=1
	call	_history
	ld	hl, (ix - 13)
	ld	a, (ix - 10)
	ld	iy, (_g)
	ld	de, 2594
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB11_71
	private	BB11_71
BB11_71:                                ;   in Loop: Header=BB11_5 Depth=1
	jr	BB11_72
	private	BB11_72
BB11_72:                                ;   in Loop: Header=BB11_5 Depth=1
	jr	BB11_73
	private	BB11_73
BB11_73:                                ;   in Loop: Header=BB11_5 Depth=1
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB11_75
	jr	BB11_74
	private	BB11_74
BB11_74:                                ;   in Loop: Header=BB11_5 Depth=1
	call	_render
	jr	BB11_75
	private	BB11_75
BB11_75:                                ;   in Loop: Header=BB11_5 Depth=1
	jp	BB11_5
	private	BB11_76
BB11_76:
	ld	hl, 170
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_destroy:                   ; -- Begin function lwip_socket_destroy
                                        ; @lwip_socket_destroy
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_save_token:                            ; -- Begin function save_token
                                        ; @save_token
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -197
	add	hl, sp
	ld	sp, hl
	ld	de, -185
	lea	iy, ix + 0
	add	iy, de
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	ld	bc, _.str.10
	ld	hl, _.str.29
	lea	de, iy + 6
	push	ix
	lea	ix, ix - 128
	ld	(ix - 63), de
	pop	ix
	lea	de, iy + 4
	push	ix
	lea	ix, ix - 128
	ld	(ix - 69), de
	pop	ix
	lea	de, iy + 3
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 66
	ld	(iy + 0), de
	push	hl
	push	bc
	call	_ti_Open
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(iy + 5), a
	ld	a, (iy + 5)
	or	a, a
	jr	nz, BB13_4
	jr	BB13_1
	private	BB13_1
BB13_1:
	ld	hl, _.str.166
	push	hl
	ld	hl, _.str.10
	push	hl
	call	_ti_Open
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(iy + 5), a
	ld	a, (iy + 5)
	or	a, a
	jr	nz, BB13_3
	jr	BB13_2
	private	BB13_2
BB13_2:
	ld	hl, _.str.167
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB13_20
	private	BB13_3
BB13_3:
	ld	(iy + 4), 0
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	push	hl
	ld	de, -197
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Write
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	jr	BB13_4
	private	BB13_4
BB13_4:
	ld	(iy + 3), 0
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	call	_ti_Rewind
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	push	hl
	ld	de, -194
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Read
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	a, (iy + 3)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388575
	or	a, a
	sbc	hl, de
	jr	c, BB13_6
	jr	BB13_5
	private	BB13_5
BB13_5:
	ld	(iy + 3), 32
	jr	BB13_6
	private	BB13_6
BB13_6:
	ld	(iy + 2), 0
	jr	BB13_7
	private	BB13_7
BB13_7:                                 ; =>This Inner Loop Header: Depth=1
	ld	a, (iy + 2)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	a, (iy + 3)
	lea	bc, iy + 0
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	push	bc
	pop	iy
	or	a, a
	sbc	hl, de
	jp	nc, BB13_17
	jr	BB13_8
	private	BB13_8
BB13_8:                                 ;   in Loop: Header=BB13_7 Depth=1
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	call	_ti_Tell
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	push	ix
	lea	ix, ix - 128
	ld	iy, (ix - 60)
	pop	ix
	ld	(iy + 0), l
	ld	(iy + 1), h
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 172
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Read
	ld	iy, 12
	add	iy, sp
	ld	sp, iy
	ld	de, 1
	or	a, a
	sbc	hl, de
	jr	z, BB13_10
	jr	BB13_9
	private	BB13_9
BB13_9:
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jp	BB13_17
	private	BB13_10
BB13_10:                                ;   in Loop: Header=BB13_7 Depth=1
	ld	hl, 128
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_memchr
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB13_12
	jr	BB13_11
	private	BB13_11
BB13_11:                                ;   in Loop: Header=BB13_7 Depth=1
	ld	de, 128
	ld	bc, -191
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	ld	de, 44
	push	de
	ld	de, 0
	push	de
	push	hl
	call	_memchr
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB13_13
	jr	BB13_12
	private	BB13_12
BB13_12:                                ;   in Loop: Header=BB13_7 Depth=1
	jp	BB13_16
	private	BB13_13
BB13_13:                                ;   in Loop: Header=BB13_7 Depth=1
	ld	iy, (_g)
	lea	hl, iy + 5
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB13_15
	jr	BB13_14
	private	BB13_14
BB13_14:
	ld	de, 128
	ld	bc, -191
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	add	iy, de
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	push	hl
	ld	hl, 44
	push	hl
	push	iy
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 0)
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	de
	call	_ti_Seek
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 172
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Write
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	call	_ti_SetArchiveStatus
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	call	_ti_Close
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB13_20
	private	BB13_15
BB13_15:                                ;   in Loop: Header=BB13_7 Depth=1
	jr	BB13_16
	private	BB13_16
BB13_16:                                ;   in Loop: Header=BB13_7 Depth=1
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	inc	(iy + 2)
	jp	BB13_7
	private	BB13_17
BB13_17:
	ld	a, (iy + 3)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388576
	or	a, a
	sbc	hl, de
	jp	nc, BB13_19
	jr	BB13_18
	private	BB13_18
BB13_18:
	ld	iy, (_g)
	lea	hl, iy + 5
	push	hl
	ld	hl, 128
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, 128
	ld	bc, -191
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	add	iy, de
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	push	hl
	ld	hl, 44
	push	hl
	push	iy
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 172
	push	hl
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Write
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	inc	(iy + 3)
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	call	_ti_Rewind
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	push	hl
	ld	de, -194
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Write
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	jr	BB13_19
	private	BB13_19
BB13_19:
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	call	_ti_SetArchiveStatus
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	de, -188
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 5)
	ld	l, a
	push	hl
	call	_ti_Close
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB13_20
	private	BB13_20
BB13_20:
	ld	hl, 197
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_clear_selection:                       ; -- Begin function clear_selection
                                        ; @clear_selection
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	call	_clear_chat
	ld	hl, (_g)
	ld	de, 568
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 5284
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 5282
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2634
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2618
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 228
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 227
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 221
	add	hl, de
	ld	(hl), 0
	pop	ix
	ret
                                        ; -- End function
_render:                                ; -- Begin function render
                                        ; @render
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -116
	add	hl, sp
	ld	sp, hl
	lea	hl, ix - 80
	ld	(ix - 107), hl
	ld	hl, 16
	push	hl
	call	_gfx_FillScreen
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, 19
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 320
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	call	_fill
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	de, 133
	add	iy, de
	ld	hl, (_g)
	ld	de, 406
	add	hl, de
	push	hl
	push	iy
	ld	hl, _.str.168
	push	hl
	ld	hl, 80
	push	hl
	ld	hl, (ix - 107)
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, (ix - 107)
	push	hl
	ld	hl, 19
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 4
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB15_10
	jr	BB15_1
	private	BB15_1
BB15_1:
	ld	hl, (_g)
	ld	de, 1989
	add	hl, de
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 21
	push	hl
	ld	hl, 40
	push	hl
	ld	hl, 4
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2232
	add	hl, de
	ld	de, 39
	push	de
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 56
	push	hl
	ld	hl, 4
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2152
	add	hl, de
	push	hl
	ld	hl, _.str.169
	push	hl
	ld	hl, 80
	push	hl
	ld	hl, (ix - 107)
	push	hl
	call	_snprintf
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, 39
	push	hl
	ld	hl, (ix - 107)
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 72
	push	hl
	ld	hl, 4
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2560
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB15_3
	jr	BB15_2
	private	BB15_2
BB15_2:
	ld	hl, 39
	push	hl
	ld	hl, _.str.170
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 88
	push	hl
	ld	hl, 4
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	jr	BB15_3
	private	BB15_3
BB15_3:
	ld	(ix - 81), 0
	jr	BB15_4
	private	BB15_4
BB15_4:                                 ; =>This Inner Loop Header: Depth=1
	ld	a, (ix - 81)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388591
	or	a, a
	sbc	hl, de
	ld	a, 0
	jp	nc, BB15_6
	jr	BB15_5
	private	BB15_5
BB15_5:                                 ;   in Loop: Header=BB15_4 Depth=1
	ld	a, (ix - 81)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	iy, (_g)
	ld	de, 2561
	add	iy, de
	ld	a, (iy)
	ld	de, 0
	ld	e, a
	add	hl, de
	ld	iy, (_g)
	ld	de, 2560
	add	iy, de
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB15_6
	private	BB15_6
BB15_6:                                 ;   in Loop: Header=BB15_4 Depth=1
	bit	0, a
	jr	z, BB15_9
	jr	BB15_7
	private	BB15_7
BB15_7:                                 ;   in Loop: Header=BB15_4 Depth=1
	ld	a, (ix - 81)
	or	a, a
	sbc	hl, hl
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	pop	de
	ld	hl, 88
	add	hl, de
	ld	(ix - 113), hl
	ld	hl, (_g)
	ld	(ix - 116), hl
	ld	a, (ix - 81)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	iy, (_g)
	ld	de, 2561
	add	iy, de
	ld	a, (iy)
	ld	de, 0
	ld	e, a
	add	hl, de
	ld	bc, 72
	call	__imulu
	push	hl
	pop	de
	ld	hl, (ix - 116)
	add	hl, de
	ld	de, 2272
	add	hl, de
	ex	de, hl
	ld	hl, 39
	push	hl
	push	de
	ld	hl, 16
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, (ix - 113)
	push	hl
	ld	hl, 4
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	jr	BB15_8
	private	BB15_8
BB15_8:                                 ;   in Loop: Header=BB15_4 Depth=1
	inc	(ix - 81)
	jp	BB15_4
	private	BB15_9
BB15_9:
	jp	BB15_55
	private	BB15_10
BB15_10:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jr	nc, BB15_12
	jr	BB15_11
	private	BB15_11
BB15_11:
	call	_panel
	jp	BB15_54
	private	BB15_12
BB15_12:
	ld	hl, 18
	push	hl
	ld	hl, 208
	push	hl
	ld	hl, 88
	push	hl
	ld	hl, 16
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_fill
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	de, _.str.171
	jr	z, BB15_14
; %bb.13:
	ld	de, _.str.172
	private	BB15_14
BB15_14:
	ld	hl, 10
	push	hl
	push	de
	ld	hl, 18
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 18
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 5284
	add	hl, de
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	(ix - 84), hl
	or	a, a
	sbc	hl, hl
	ld	(ix - 87), hl
	jr	BB15_15
	private	BB15_15
BB15_15:                                ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 84)
	ld	iy, (_g)
	ld	de, 5282
	add	iy, de
	ld	a, (iy)
	ld	de, 0
	ld	e, a
	or	a, a
	sbc	hl, de
	ld	a, 0
	jp	nc, BB15_17
	jr	BB15_16
	private	BB15_16
BB15_16:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	hl, (ix - 87)
	ld	de, 22
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB15_17
	private	BB15_17
BB15_17:                                ;   in Loop: Header=BB15_15 Depth=1
	bit	0, a
	jp	z, BB15_28
	jr	BB15_18
	private	BB15_18
BB15_18:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	hl, (ix - 84)
	ld	iy, (_g)
	ld	de, 5283
	add	iy, de
	ld	a, (iy)
	ld	de, 0
	ld	e, a
	or	a, a
	sbc	hl, de
	ld	a, 0
	jr	nz, BB15_24
	jr	BB15_19
	private	BB15_19
BB15_19:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	a, 1
	jr	nz, BB15_23
	jr	BB15_20
	private	BB15_20
BB15_20:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	a, -1
	ld	l, 0
	jr	z, BB15_22
; %bb.21:                               ;   in Loop: Header=BB15_15 Depth=1
	ld	a, l
	private	BB15_22
BB15_22:                                ;   in Loop: Header=BB15_15 Depth=1
	jr	BB15_23
	private	BB15_23
BB15_23:                                ;   in Loop: Header=BB15_15 Depth=1
	jr	BB15_24
	private	BB15_24
BB15_24:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	l, 1
	and	a, l
	ld	e, a
	ld	(ix - 88), e
	ld	a, (ix - 88)
	and	a, l
	ld	l, a
	ld	e, 18
	ld	a, l
	add	a, e
	ld	l, a
	ld	(ix - 89), l
	ld	hl, (ix - 87)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	pop	de
	ld	hl, 28
	add	hl, de
	ld	a, (ix - 89)
	ld	e, a
	push	de
	ld	de, 8
	push	de
	ld	de, 88
	push	de
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_fill
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	hl, (ix - 84)
	ld	bc, 104
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 2786
	add	iy, de
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	hl
	push	iy
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	ld	de, 42
	jr	nz, BB15_26
; %bb.25:                               ;   in Loop: Header=BB15_15 Depth=1
	ld	de, 32
	private	BB15_26
BB15_26:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	iy, (_g)
	ld	hl, (ix - 84)
	ld	bc, 104
	call	__imulu
	push	hl
	pop	bc
	add	iy, bc
	ld	bc, 2807
	add	iy, bc
	push	iy
	push	de
	ld	hl, _.str.173
	push	hl
	ld	hl, 80
	push	hl
	ld	hl, (ix - 107)
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 87)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	pop	de
	ld	hl, 28
	add	hl, de
	ld	a, (ix - 89)
	ld	de, 10
	push	de
	ld	de, (ix - 107)
	push	de
	ld	e, a
	push	de
	ld	de, 17
	push	de
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	jr	BB15_27
	private	BB15_27
BB15_27:                                ;   in Loop: Header=BB15_15 Depth=1
	ld	hl, (ix - 84)
	inc	hl
	ld	(ix - 84), hl
	ld	hl, (ix - 87)
	inc	hl
	ld	(ix - 87), hl
	jp	BB15_15
	private	BB15_28
BB15_28:
	ld	hl, 10
	push	hl
	ld	hl, _.str.174
	push	hl
	ld	hl, 18
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 208
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jr	nz, BB15_30
	jr	BB15_29
	private	BB15_29
BB15_29:
	ld	iy, _.str.175
	jr	BB15_31
	private	BB15_30
BB15_30:
	ld	iy, (_g)
	ld	de, 487
	add	iy, de
	jr	BB15_31
	private	BB15_31
BB15_31:
	ld	hl, 28
	push	hl
	push	iy
	ld	hl, 16
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 18
	push	hl
	ld	hl, 90
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	de, (hl)
	ld	hl, (_g)
	ld	bc, 10184
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	jr	nc, BB15_33
	jr	BB15_32
	private	BB15_32
BB15_32:
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	hl, (hl)
	ld	iy, (_g)
	ld	de, 10184
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
	jr	BB15_34
	private	BB15_33
BB15_33:
	or	a, a
	sbc	hl, hl
	jr	BB15_34
	private	BB15_34
BB15_34:
	ld	(ix - 92), hl
	ld	hl, (ix - 92)
	ld	de, 24
	or	a, a
	sbc	hl, de
	jr	c, BB15_36
	jr	BB15_35
	private	BB15_35
BB15_35:
	ld	hl, (ix - 92)
	ld	de, -23
	add	hl, de
	jr	BB15_37
	private	BB15_36
BB15_36:
	or	a, a
	sbc	hl, hl
	jr	BB15_37
	private	BB15_37
BB15_37:
	ld	(ix - 95), hl
	ld	hl, (ix - 95)
	ld	(ix - 98), hl
	jr	BB15_38
	private	BB15_38
BB15_38:                                ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 98)
	ld	de, (ix - 92)
	or	a, a
	sbc	hl, de
	jr	nc, BB15_41
	jr	BB15_39
	private	BB15_39
BB15_39:                                ;   in Loop: Header=BB15_38 Depth=1
	ld	hl, (ix - 98)
	ld	de, (ix - 95)
	or	a, a
	sbc	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	pop	de
	ld	hl, 30
	add	hl, de
	ld	(ix - 110), hl
	ld	iy, (_g)
	ld	hl, (ix - 98)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5335
	add	iy, de
	ld	a, (iy)
	ld	iy, (_g)
	ld	hl, (ix - 98)
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5285
	add	iy, de
	ld	hl, 28
	push	hl
	push	iy
	ld	hl, 16
	push	hl
	ld	l, a
	push	hl
	ld	hl, (ix - 110)
	push	hl
	ld	hl, 90
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	jr	BB15_40
	private	BB15_40
BB15_40:                                ;   in Loop: Header=BB15_38 Depth=1
	ld	hl, (ix - 98)
	inc	hl
	ld	(ix - 98), hl
	jp	BB15_38
	private	BB15_41
BB15_41:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 5
	or	a, a
	sbc	hl, de
	jp	nz, BB15_53
	jr	BB15_42
	private	BB15_42
BB15_42:
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	nz, BB15_53
	jr	BB15_43
	private	BB15_43
BB15_43:
	ld	hl, (_g)
	ld	de, 10865
	add	hl, de
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 101), hl
	ld	iy, (_g)
	ld	hl, (ix - 101)
	ld	de, 27
	or	a, a
	sbc	hl, de
	jr	c, BB15_45
	jr	BB15_44
	private	BB15_44
BB15_44:
	ld	hl, (ix - 101)
	ld	de, -26
	add	hl, de
	ex	de, hl
	jr	BB15_46
	private	BB15_45
BB15_45:
	ld	de, 0
	jr	BB15_46
	private	BB15_46
BB15_46:
	add	iy, de
	ld	de, 10865
	add	iy, de
	ld	(ix - 104), iy
	ld	hl, (_g)
	ld	de, 10987
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB15_48
	jr	BB15_47
	private	BB15_47
BB15_47:
	ld	hl, (_g)
	ld	de, 10986
	add	hl, de
	ld	a, (hl)
	cp	a, 1
	jr	nz, BB15_49
	jr	BB15_48
	private	BB15_48
BB15_48:
	ld	de, 80
	ld	bc, 65
	jr	BB15_52
	private	BB15_49
BB15_49:
	ld	hl, (_g)
	ld	de, 10986
	add	hl, de
	ld	a, (hl)
	cp	a, 2
	ld	hl, 48
	jr	z, BB15_51
; %bb.50:
	ld	hl, 97
	private	BB15_51
BB15_51:
	push	hl
	pop	bc
	ld	de, 80
	jr	BB15_52
	private	BB15_52
BB15_52:
	ld	hl, (ix - 104)
	push	hl
	push	bc
	ld	hl, _.str.176
	push	hl
	push	de
	ld	hl, (ix - 107)
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, 18
	push	hl
	ld	hl, 8
	push	hl
	ld	hl, 230
	push	hl
	ld	hl, 216
	push	hl
	ld	hl, 90
	push	hl
	call	_fill
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, 28
	push	hl
	ld	hl, (ix - 107)
	push	hl
	ld	hl, 18
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 216
	push	hl
	ld	hl, 90
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	jr	BB15_53
	private	BB15_53
BB15_53:
	jr	BB15_54
	private	BB15_54
BB15_54:
	jr	BB15_55
	private	BB15_55
BB15_55:
	ld	hl, 18
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, 320
	push	hl
	ld	hl, 224
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_fill
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 1989
	add	hl, de
	ld	de, 39
	push	de
	push	hl
	ld	hl, 18
	push	hl
	ld	hl, 17
	push	hl
	ld	hl, 225
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	de, _.str.177
	jr	nz, BB15_57
; %bb.56:
	ld	de, _.str.178
	private	BB15_57
BB15_57:
	ld	hl, 39
	push	hl
	push	de
	ld	hl, 18
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 233
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	call	_gfx_BlitBuffer
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 0
	ld	hl, 116
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_service_events:                   ; -- Begin function lwip_service_events
                                        ; @lwip_service_events
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	pop	ix
	ret
                                        ; -- End function
_os_GetCSC:                             ; -- Begin function os_GetCSC
                                        ; @os_GetCSC
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	de, _os_GetCSC.__loc
	ld	iy, _test_keys
	jr	BB17_1
	private	BB17_1
BB17_1:
	ld	hl, (_test_key_pos)
	ld	bc, 64
	or	a, a
	sbc	hl, bc
	jr	nc, BB17_3
	jr	BB17_2
	private	BB17_2
BB17_2:
	jr	BB17_4
	private	BB17_3
BB17_3:
	push	de
	call	___assert_fail_loc
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	private	BB17_4
BB17_4:
	jr	BB17_5
	private	BB17_5
BB17_5:
	ld	de, (_test_key_pos)
	push	de
	pop	bc
	inc	bc
	ld	(_test_key_pos), bc
	add	iy, de
	ld	a, (iy)
	pop	ix
	ret
                                        ; -- End function
_mem_release:                           ; -- Begin function mem_release
                                        ; @mem_release
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (ix - 3)
	push	hl
	call	_free
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_SetPalette:                        ; -- Begin function gfx_SetPalette
                                        ; @gfx_SetPalette
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -9
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	bc, (ix + 9)
	ld	de, (ix + 12)
	ld	iy, _gfx_SetPalette.__loc
	ld	(ix - 3), hl
	ld	(ix - 6), bc
	ld	(ix - 9), de
	jr	BB19_1
	private	BB19_1
BB19_1:
	ld	hl, (ix - 6)
	ld	bc, 12
	or	a, a
	sbc	hl, bc
	jr	nz, BB19_4
	jr	BB19_2
	private	BB19_2
BB19_2:
	ld	hl, (ix - 9)
	ld	bc, 16
	or	a, a
	sbc	hl, bc
	jr	nz, BB19_4
	jr	BB19_3
	private	BB19_3
BB19_3:
	jr	BB19_5
	private	BB19_4
BB19_4:
	push	iy
	call	___assert_fail_loc
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	private	BB19_5
BB19_5:
	jr	BB19_6
	private	BB19_6
BB19_6:
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_SetMonospaceFont:                  ; -- Begin function gfx_SetMonospaceFont
                                        ; @gfx_SetMonospaceFont
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_SetTextScale:                      ; -- Begin function gfx_SetTextScale
                                        ; @gfx_SetTextScale
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_ti_Open:                               ; -- Begin function ti_Open
                                        ; @ti_Open
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -8
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	iy, _test_appvars
	ld	(ix - 4), hl
	ld	(ix - 7), de
	ld	(ix - 8), 0
	jr	BB22_1
	private	BB22_1
BB22_1:                                 ; =>This Inner Loop Header: Depth=1
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388606
	or	a, a
	sbc	hl, de
	jp	nc, BB22_11
	jr	BB22_2
	private	BB22_2
BB22_2:                                 ;   in Loop: Header=BB22_1 Depth=1
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	lea	hl, iy + 0
	add	hl, de
	ld	hl, (hl)
	ld	de, (ix - 4)
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB22_4
	jr	BB22_3
	private	BB22_3
BB22_3:                                 ;   in Loop: Header=BB22_1 Depth=1
	jp	BB22_10
	private	BB22_4
BB22_4:
	ld	hl, (ix - 7)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, 119
	or	a, a
	sbc	hl, de
	jr	nz, BB22_6
	jr	BB22_5
	private	BB22_5
BB22_5:
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	ld	iy, _test_appvars
	lea	hl, iy + 0
	add	hl, de
	ld	de, 2051
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	call	__imulu
	push	hl
	pop	de
	lea	hl, iy + 0
	add	hl, de
	ld	de, 2054
	add	hl, de
	ld	(hl), 1
	jr	BB22_9
	private	BB22_6
BB22_6:
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	ld	iy, _test_appvars
	lea	hl, iy + 0
	add	hl, de
	ld	de, 2054
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB22_8
	jr	BB22_7
	private	BB22_7
BB22_7:
	ld	(ix - 1), 0
	jr	BB22_12
	private	BB22_8
BB22_8:
	jr	BB22_9
	private	BB22_9
BB22_9:
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 2055
	add	iy, de
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	ld	a, (ix - 8)
	inc	a
	ld	(ix - 1), a
	jr	BB22_12
	private	BB22_10
BB22_10:                                ;   in Loop: Header=BB22_1 Depth=1
	inc	(ix - 8)
	ld	iy, _test_appvars
	jp	BB22_1
	private	BB22_11
BB22_11:
	ld	(ix - 1), 0
	jr	BB22_12
	private	BB22_12
BB22_12:
	ld	a, (ix - 1)
	ld	hl, 8
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_ti_Read:                               ; -- Begin function ti_Read
                                        ; @ti_Read
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -19
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	a, (ix + 15)
	ld	iy, _test_appvars
	ld	(ix - 6), hl
	ld	(ix - 9), de
	ld	(ix - 12), bc
	ld	(ix - 13), a
	ld	a, (ix - 13)
	or	a, a
	jr	z, BB23_2
	jr	BB23_1
	private	BB23_1
BB23_1:
	ld	a, (ix - 13)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388605
	or	a, a
	sbc	hl, de
	jr	c, BB23_3
	jr	BB23_2
	private	BB23_2
BB23_2:
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), hl
	jp	BB23_6
	private	BB23_3
BB23_3:
	ld	a, (ix - 13)
	or	a, a
	sbc	hl, hl
	ld	l, a
	dec	hl
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	(ix - 16), iy
	ld	hl, (ix - 9)
	ld	bc, (ix - 12)
	call	__imulu
	ld	(ix - 19), hl
	ld	hl, (ix - 16)
	ld	de, 2055
	add	hl, de
	ld	hl, (hl)
	ld	de, (ix - 19)
	add	hl, de
	ex	de, hl
	ld	hl, (ix - 16)
	ld	bc, 2051
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	jr	nc, BB23_5
	jr	BB23_4
	private	BB23_4
BB23_4:
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), hl
	jr	BB23_6
	private	BB23_5
BB23_5:
	ld	de, (ix - 6)
	ld	iy, (ix - 16)
	ld	hl, (ix - 16)
	ld	bc, 2055
	add	hl, bc
	ld	bc, (hl)
	add	iy, bc
	lea	hl, iy + 3
	ld	bc, (ix - 19)
	push	bc
	push	hl
	push	de
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix - 19)
	ld	iy, (ix - 16)
	ld	bc, 2055
	add	iy, bc
	ld	hl, (iy)
	add	hl, de
	ld	(iy), hl
	ld	hl, (ix - 12)
	ld	(ix - 3), hl
	jr	BB23_6
	private	BB23_6
BB23_6:
	ld	hl, (ix - 3)
	ld	iy, 19
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_ti_Close:                              ; -- Begin function ti_Close
                                        ; @ti_Close
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	(ix - 1), a
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_copy:                                  ; -- Begin function copy
                                        ; @copy
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 6)
	ld	bc, (ix + 9)
	ld	hl, (ix + 12)
	ld	iy, _.str.11
	ld	(ix - 3), de
	ld	(ix - 6), bc
	ld	(ix - 9), hl
	ld	hl, (ix - 3)
	ld	de, (ix - 6)
	ld	bc, (ix - 9)
	push	bc
	push	iy
	push	de
	push	hl
	call	_snprintf
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_load_token:                            ; -- Begin function load_token
                                        ; @load_token
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -187
	add	hl, sp
	ld	sp, hl
	ld	iy, _.str.10
	ld	bc, _.str.6
	lea	hl, ix - 8
	push	ix
	lea	ix, ix - 128
	ld	(ix - 59), hl
	pop	ix
	ld	de, -181
	lea	hl, ix + 0
	add	hl, de
	push	ix
	lea	ix, ix - 128
	ld	(ix - 56), hl
	pop	ix
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	ld	(hl), 0
	push	bc
	push	iy
	call	_ti_Open
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(ix - 7), a
	ld	a, (ix - 7)
	or	a, a
	jr	nz, BB26_2
	jr	BB26_1
	private	BB26_1
BB26_1:
	jp	BB26_16
	private	BB26_2
BB26_2:
	ld	(ix - 8), 0
	ld	a, (ix - 7)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	push	hl
	ld	de, -187
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Read
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	a, (ix - 8)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388575
	or	a, a
	sbc	hl, de
	jr	c, BB26_4
	jr	BB26_3
	private	BB26_3
BB26_3:
	ld	(ix - 8), 32
	jr	BB26_4
	private	BB26_4
BB26_4:
	ld	(ix - 9), 0
	ld	bc, 1
	jr	BB26_5
	private	BB26_5
BB26_5:                                 ; =>This Inner Loop Header: Depth=1
	ld	a, (ix - 9)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	a, (ix - 8)
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jp	nc, BB26_15
	jr	BB26_6
	private	BB26_6
BB26_6:                                 ;   in Loop: Header=BB26_5 Depth=1
	ld	a, (ix - 7)
	ld	l, a
	push	hl
	push	bc
	ld	hl, 172
	push	hl
	ld	de, -184
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_ti_Read
	ld	iy, 12
	add	iy, sp
	ld	sp, iy
	ld	de, 1
	or	a, a
	sbc	hl, de
	jr	z, BB26_8
	jr	BB26_7
	private	BB26_7
BB26_7:
	jp	BB26_15
	private	BB26_8
BB26_8:                                 ;   in Loop: Header=BB26_5 Depth=1
	ld	hl, 128
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	de, -184
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_memchr
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB26_10
	jr	BB26_9
	private	BB26_9
BB26_9:                                 ;   in Loop: Header=BB26_5 Depth=1
	ld	de, 128
	ld	bc, -184
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	ld	de, 44
	push	de
	ld	de, 0
	push	de
	push	hl
	call	_memchr
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB26_11
	jr	BB26_10
	private	BB26_10
BB26_10:                                ;   in Loop: Header=BB26_5 Depth=1
	jr	BB26_14
	private	BB26_11
BB26_11:                                ;   in Loop: Header=BB26_5 Depth=1
	ld	iy, (_g)
	lea	hl, iy + 5
	push	hl
	ld	de, -184
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB26_13
	jr	BB26_12
	private	BB26_12
BB26_12:
	ld	iy, (_g)
	ld	de, 165
	add	iy, de
	ld	de, 128
	push	ix
	lea	ix, ix - 128
	ld	hl, (ix - 56)
	pop	ix
	add	hl, de
	push	hl
	ld	de, 44
	push	de
	push	iy
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB26_15
	private	BB26_13
BB26_13:                                ;   in Loop: Header=BB26_5 Depth=1
	jr	BB26_14
	private	BB26_14
BB26_14:                                ;   in Loop: Header=BB26_5 Depth=1
	inc	(ix - 9)
	ld	bc, 1
	jp	BB26_5
	private	BB26_15
BB26_15:
	ld	a, (ix - 7)
	ld	l, a
	push	hl
	call	_ti_Close
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB26_16
	private	BB26_16
BB26_16:
	ld	hl, 187
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_token_valid:                           ; -- Begin function token_valid
                                        ; @token_valid
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -4
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 4), hl
	ld	hl, (ix - 4)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	de, 43
	or	a, a
	sbc	hl, de
	jr	z, BB27_2
	jr	BB27_1
	private	BB27_1
BB27_1:
	ld	(ix - 1), 0
	jp	BB27_16
	private	BB27_2
BB27_2:
	jr	BB27_3
	private	BB27_3
BB27_3:                                 ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	or	a, a
	jp	z, BB27_15
	jr	BB27_4
	private	BB27_4
BB27_4:                                 ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388511
	or	a, a
	sbc	hl, de
	jr	c, BB27_6
	jr	BB27_5
	private	BB27_5
BB27_5:                                 ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388485
	or	a, a
	sbc	hl, de
	jp	c, BB27_13
	jr	BB27_6
	private	BB27_6
BB27_6:                                 ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388543
	or	a, a
	sbc	hl, de
	jr	c, BB27_8
	jr	BB27_7
	private	BB27_7
BB27_7:                                 ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388517
	or	a, a
	sbc	hl, de
	jr	c, BB27_13
	jr	BB27_8
	private	BB27_8
BB27_8:                                 ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388560
	or	a, a
	sbc	hl, de
	jr	c, BB27_10
	jr	BB27_9
	private	BB27_9
BB27_9:                                 ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388550
	or	a, a
	sbc	hl, de
	jr	c, BB27_13
	jr	BB27_10
	private	BB27_10
BB27_10:                                ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, 95
	or	a, a
	sbc	hl, de
	jr	z, BB27_13
	jr	BB27_11
	private	BB27_11
BB27_11:                                ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, 45
	or	a, a
	sbc	hl, de
	jr	z, BB27_13
	jr	BB27_12
	private	BB27_12
BB27_12:
	ld	(ix - 1), 0
	jr	BB27_16
	private	BB27_13
BB27_13:                                ;   in Loop: Header=BB27_3 Depth=1
	jr	BB27_14
	private	BB27_14
BB27_14:                                ;   in Loop: Header=BB27_3 Depth=1
	ld	hl, (ix - 4)
	inc	hl
	ld	(ix - 4), hl
	jp	BB27_3
	private	BB27_15
BB27_15:
	ld	(ix - 1), 1
	jr	BB27_16
	private	BB27_16
BB27_16:
	ld	a, (ix - 1)
	ld	hl, 4
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_debug_file_name:                  ; -- Begin function lwip_debug_file_name
                                        ; @lwip_debug_file_name
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	hl, _.str.13
	ld	(ix - 1), a
	ld	iy, 1
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_status:                                ; -- Begin function status
                                        ; @status
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	iy, 80
	ld	(ix - 3), hl
	lea	hl, ix + 9
	ld	(ix - 6), hl
	ld	hl, (_g)
	ld	bc, 1989
	add	hl, bc
	ld	bc, (ix - 3)
	ld	de, (ix - 6)
	push	de
	push	bc
	push	iy
	push	hl
	call	_vsnprintf
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_save:                                  ; -- Begin function save
                                        ; @save
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	de, _.str.5
	ld	hl, _.str.29
	push	hl
	push	de
	call	_ti_Open
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(ix - 1), a
	ld	a, (ix - 1)
	or	a, a
	jr	nz, BB30_2
	jr	BB30_1
	private	BB30_1
BB30_1:
	ld	hl, _.str.30
	push	hl
	ld	hl, _.str.5
	push	hl
	call	_ti_Open
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(ix - 1), a
	jr	BB30_2
	private	BB30_2
BB30_2:
	ld	a, (ix - 1)
	or	a, a
	jr	nz, BB30_4
	jr	BB30_3
	private	BB30_3
BB30_3:
	ld	hl, _.str.31
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB30_5
	private	BB30_4
BB30_4:
	ld	a, (ix - 1)
	ld	l, a
	push	hl
	call	_ti_Rewind
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	a, (ix - 1)
	ld	e, a
	push	de
	ld	de, 1
	push	de
	ld	de, 4
	push	de
	push	hl
	call	_ti_Write
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	lea	hl, iy + 4
	ld	a, (ix - 1)
	ld	e, a
	push	de
	ld	de, 1
	push	de
	push	de
	push	hl
	call	_ti_Write
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 133
	add	hl, de
	ld	a, (ix - 1)
	ld	e, a
	push	de
	ld	de, 1
	push	de
	ld	de, 32
	push	de
	push	hl
	call	_ti_Write
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	a, (ix - 1)
	ld	l, a
	push	hl
	ld	hl, 1
	push	hl
	call	_ti_SetArchiveStatus
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	a, (ix - 1)
	ld	l, a
	push	hl
	call	_ti_Close
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB30_5
	private	BB30_5
BB30_5:
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_input_char:                            ; -- Begin function input_char
                                        ; @input_char
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	de, 1
	ld	bc, 3
	ld	(ix - 2), a
	ld	a, (ix - 2)
	cp	a, 13
	jr	nz, BB31_2
	jr	BB31_1
	private	BB31_1
BB31_1:
	ld	hl, (_g)
	ld	de, 10986
	add	hl, de
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	inc	hl
	call	__irems
	ld	a, l
	ld	hl, (_g)
	add	hl, de
	ld	(hl), a
	ld	hl, (_g)
	ld	de, 10987
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	ld	(ix - 1), 0
	jr	BB31_10
	private	BB31_2
BB31_2:
	ld	a, (ix - 2)
	cp	a, 14
	jr	nz, BB31_4
	jr	BB31_3
	private	BB31_3
BB31_3:
	ld	hl, (_g)
	ld	de, 10987
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	ld	(ix - 1), 0
	jr	BB31_10
	private	BB31_4
BB31_4:
	ld	a, (ix - 2)
	ld	hl, (_g)
	ld	bc, 10987
	add	hl, bc
	ld	l, (hl)
	bit	0, l
	jr	z, BB31_6
	jr	BB31_5
	private	BB31_5
BB31_5:
	jr	BB31_7
	private	BB31_6
BB31_6:
	ld	hl, (_g)
	ld	de, 10986
	add	hl, de
	ld	l, (hl)
	ld	de, 0
	ld	e, l
	jr	BB31_7
	private	BB31_7
BB31_7:
	push	de
	ld	l, a
	push	hl
	call	_key_to_char
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	(ix - 3), a
	ld	a, (ix - 3)
	or	a, a
	jr	z, BB31_9
	jr	BB31_8
	private	BB31_8
BB31_8:
	ld	hl, (_g)
	ld	de, 10987
	add	hl, de
	ld	(hl), 0
	jr	BB31_9
	private	BB31_9
BB31_9:
	ld	a, (ix - 3)
	ld	(ix - 1), a
	jr	BB31_10
	private	BB31_10
BB31_10:
	ld	a, (ix - 1)
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_FillScreen:                        ; -- Begin function gfx_FillScreen
                                        ; @gfx_FillScreen
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	(ix - 1), a
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_fill:                                  ; -- Begin function fill
                                        ; @fill
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -13
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	a, (ix + 18)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 9), bc
	ld	hl, (ix + 15)
	ld	(ix - 12), hl
	ld	(ix - 13), a
	ld	a, (ix - 13)
	ld	l, a
	push	hl
	call	_gfx_SetColor
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	iy, (ix - 3)
	ld	de, (ix - 6)
	ld	bc, (ix - 9)
	ld	hl, (ix - 12)
	push	hl
	push	bc
	push	de
	push	iy
	call	_gfx_FillRectangle
	ld	hl, 25
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_text:                                  ; -- Begin function text
                                        ; @text
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -58
	add	hl, sp
	ld	sp, hl
	ld	l, (ix + 12)
	ld	a, (ix + 15)
	ld	bc, (ix + 18)
	lea	iy, ix - 55
	ld	de, (ix + 6)
	ld	(ix - 3), de
	ld	de, (ix + 9)
	ld	(ix - 6), de
	ld	(ix - 7), l
	ld	(ix - 8), a
	ld	(ix - 11), bc
	ld	hl, (ix + 21)
	ld	(ix - 14), hl
	ld	hl, (ix - 14)
	ld	de, 41
	or	a, a
	sbc	hl, de
	jr	c, BB34_2
	jr	BB34_1
	private	BB34_1
BB34_1:
	ld	hl, 40
	ld	(ix - 14), hl
	jr	BB34_2
	private	BB34_2
BB34_2:
	ld	hl, (ix - 14)
	ld	de, (ix - 11)
	push	de
	push	hl
	ld	hl, _.str.34
	push	hl
	ld	hl, 41
	push	hl
	ld	(ix - 58), iy
	push	iy
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	a, (ix - 7)
	ld	l, a
	push	hl
	call	_gfx_SetTextFGColor
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	a, (ix - 8)
	ld	l, a
	push	hl
	call	_gfx_SetTextBGColor
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 3)
	ld	de, (ix - 6)
	push	de
	push	hl
	ld	hl, (ix - 58)
	push	hl
	call	_gfx_PrintStringXY
	ld	hl, 67
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_BlitBuffer:                        ; -- Begin function gfx_BlitBuffer
                                        ; @gfx_BlitBuffer
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	pop	ix
	ret
                                        ; -- End function
_ti_Rewind:                             ; -- Begin function ti_Rewind
                                        ; @ti_Rewind
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	de, 0
	ld	iy, _test_appvars
	ld	(ix - 1), a
	ld	a, (ix - 1)
	or	a, a
	jr	z, BB36_3
	jr	BB36_1
	private	BB36_1
BB36_1:
	ld	a, (ix - 1)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, -8388608
	add	hl, bc
	ld	bc, -8388605
	or	a, a
	sbc	hl, bc
	jr	nc, BB36_3
	jr	BB36_2
	private	BB36_2
BB36_2:
	ld	a, (ix - 1)
	or	a, a
	sbc	hl, hl
	ld	l, a
	dec	hl
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	bc
	add	iy, bc
	ld	bc, 2055
	add	iy, bc
	ld	(iy), de
	jr	BB36_3
	private	BB36_3
BB36_3:
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_ti_Write:                              ; -- Begin function ti_Write
                                        ; @ti_Write
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -19
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	a, (ix + 15)
	ld	iy, _test_appvars
	ld	(ix - 6), hl
	ld	(ix - 9), de
	ld	(ix - 12), bc
	ld	(ix - 13), a
	ld	a, (ix - 13)
	or	a, a
	jr	z, BB37_2
	jr	BB37_1
	private	BB37_1
BB37_1:
	ld	a, (ix - 13)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388605
	or	a, a
	sbc	hl, de
	jr	c, BB37_3
	jr	BB37_2
	private	BB37_2
BB37_2:
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), hl
	jp	BB37_11
	private	BB37_3
BB37_3:
	ld	a, (ix - 13)
	or	a, a
	sbc	hl, hl
	ld	l, a
	dec	hl
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	(ix - 16), iy
	ld	hl, (ix - 9)
	ld	bc, (ix - 12)
	call	__imulu
	ld	(ix - 19), hl
	jr	BB37_4
	private	BB37_4
BB37_4:
	ld	hl, (ix - 16)
	ld	de, 2055
	add	hl, de
	ld	hl, (hl)
	ld	de, (ix - 19)
	add	hl, de
	ld	de, 2049
	or	a, a
	sbc	hl, de
	jr	nc, BB37_6
	jr	BB37_5
	private	BB37_5
BB37_5:
	jr	BB37_7
	private	BB37_6
BB37_6:
	ld	hl, _ti_Write.__loc
	push	hl
	call	___assert_fail_loc
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	private	BB37_7
BB37_7:
	jr	BB37_8
	private	BB37_8
BB37_8:
	ld	iy, (ix - 16)
	ld	hl, (ix - 16)
	ld	de, 2055
	add	hl, de
	ld	de, (hl)
	add	iy, de
	lea	hl, iy + 3
	ld	de, (ix - 6)
	ld	bc, (ix - 19)
	push	bc
	push	de
	push	hl
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix - 19)
	ld	iy, (ix - 16)
	ld	bc, 2055
	add	iy, bc
	ld	hl, (iy)
	add	hl, de
	ld	(iy), hl
	ld	hl, (ix - 16)
	add	hl, bc
	ld	de, (hl)
	ld	hl, (ix - 16)
	ld	bc, 2051
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	jr	nc, BB37_10
	jr	BB37_9
	private	BB37_9
BB37_9:
	ld	hl, (ix - 16)
	ld	de, 2055
	add	hl, de
	ld	bc, (hl)
	ld	hl, (ix - 16)
	ld	de, 2051
	add	hl, de
	ld	(hl), bc
	jr	BB37_10
	private	BB37_10
BB37_10:
	ld	hl, (ix - 12)
	ld	(ix - 3), hl
	jr	BB37_11
	private	BB37_11
BB37_11:
	ld	hl, (ix - 3)
	ld	iy, 19
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_ti_SetArchiveStatus:                   ; -- Begin function ti_SetArchiveStatus
                                        ; @ti_SetArchiveStatus
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -2
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	l, (ix + 9)
	ld	e, 1
	and	a, e
	ld	e, a
	ld	(ix - 1), e
	ld	(ix - 2), l
	ld	hl, 2
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_key_to_char:                           ; -- Begin function key_to_char
                                        ; @key_to_char
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -2
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	c, (ix + 9)
	ld	hl, 57
	ld	de, 0
	ld	(ix - 1), a
	ld	(ix - 2), c
	ld	a, (ix - 1)
	cp	a, 100
	jr	z, BB39_2
; %bb.1:
	ex	de, hl
	private	BB39_2
BB39_2:
	ld	a, l
	ld	hl, 2
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_SetColor:                          ; -- Begin function gfx_SetColor
                                        ; @gfx_SetColor
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	(ix - 1), a
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_FillRectangle:                     ; -- Begin function gfx_FillRectangle
                                        ; @gfx_FillRectangle
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -12
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 9), bc
	ld	hl, (ix + 15)
	ld	(ix - 12), hl
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_SetTextFGColor:                    ; -- Begin function gfx_SetTextFGColor
                                        ; @gfx_SetTextFGColor
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	(ix - 1), a
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_SetTextBGColor:                    ; -- Begin function gfx_SetTextBGColor
                                        ; @gfx_SetTextBGColor
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	(ix - 1), a
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_gfx_PrintStringXY:                     ; -- Begin function gfx_PrintStringXY
                                        ; @gfx_PrintStringXY
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -9
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 9), bc
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_create:                    ; -- Begin function lwip_socket_create
                                        ; @lwip_socket_create
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -16
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 6)
	ld	bc, (ix + 9)
	ld	a, (ix + 21)
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), de
	ld	(ix - 6), bc
	ld	de, (ix + 12)
	ld	(ix - 9), de
	ld	de, (ix + 15)
	ld	(ix - 12), de
	ld	de, (ix + 18)
	ld	(ix - 16), de
	ld	(ix - 13), a
	ld	iy, 16
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_fail:                                  ; -- Begin function fail
                                        ; @fail
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	(hl), 0
	call	_clear_selection
	ld	hl, (ix - 3)
	push	hl
	ld	hl, _.str.11
	push	hl
	call	_status
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_on_event:                  ; -- Begin function lwip_socket_on_event
                                        ; @lwip_socket_on_event
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -12
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 9), bc
	ld	hl, (ix + 15)
	ld	(ix - 12), hl
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_event:                                 ; -- Begin function event
                                        ; @event
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -18
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	bc, (ix + 9)
	ld	de, (ix + 12)
	ld	iy, _.str.48
	ld	(ix - 3), hl
	ld	(ix - 6), bc
	ld	(ix - 9), de
	ld	hl, (ix + 15)
	ld	(ix - 12), hl
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB48_2
	jr	BB48_1
	private	BB48_1
BB48_1:
	jp	BB48_20
	private	BB48_2
BB48_2:
	ld	hl, (ix - 6)
	ld	de, 3
	or	a, a
	sbc	hl, de
	jp	nz, BB48_12
	jr	BB48_3
	private	BB48_3
BB48_3:
	ld	hl, (ix - 9)
	ld	(ix - 15), hl
	ld	hl, (_g)
	ld	de, 2232
	add	hl, de
	push	hl
	pop	bc
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB48_5
	jr	BB48_4
	private	BB48_4
BB48_4:
	ld	iy, _.str.47
	jr	BB48_8
	private	BB48_5
BB48_5:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB48_7
; %bb.6:
	ld	iy, _.str.49
	private	BB48_7
BB48_7:
	jr	BB48_8
	private	BB48_8
BB48_8:
	push	iy
	ld	hl, 40
	push	hl
	push	bc
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 15)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB48_10
	jr	BB48_9
	private	BB48_9
BB48_9:
	ld	hl, (ix - 15)
	ld	de, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, e
	ld	h, d
	ld	iy, (ix - 15)
	ld	bc, (iy + 2)
	ld	de, 0
	ld	e, c
	ld	d, b
	ld	iy, (ix - 15)
	ld	bc, (iy + 4)
	ld	iy, (ix - 15)
	ld	iy, (iy + 7)
	push	iy
	push	bc
	push	de
	push	hl
	ld	hl, _.str.50
	push	hl
	call	_status
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	jr	BB48_11
	private	BB48_10
BB48_10:
	ld	hl, _.str.51
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB48_11
	private	BB48_11
BB48_11:
	call	_capture_traceback
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	(hl), 0
	call	_clear_selection
	jp	BB48_20
	private	BB48_12
BB48_12:
	ld	hl, (ix - 6)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jp	nz, BB48_20
	jr	BB48_13
	private	BB48_13
BB48_13:
	ld	hl, (ix - 9)
	ld	(ix - 18), hl
	ld	hl, (ix - 18)
	ld	hl, (hl)
	ld	de, 5
	or	a, a
	sbc	hl, de
	jr	nz, BB48_15
	jr	BB48_14
	private	BB48_14
BB48_14:
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	(hl), 1
	ld	hl, _.str.52
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB48_19
	private	BB48_15
BB48_15:
	ld	hl, (ix - 18)
	ld	hl, (hl)
	ld	de, 6
	or	a, a
	sbc	hl, de
	jr	z, BB48_17
	jr	BB48_16
	private	BB48_16
BB48_16:
	ld	hl, (ix - 18)
	ld	hl, (hl)
	ld	de, 7
	or	a, a
	sbc	hl, de
	jr	nz, BB48_18
	jr	BB48_17
	private	BB48_17
BB48_17:
	ld	hl, (_g)
	ld	de, 2232
	add	hl, de
	ld	de, _.str.53
	push	de
	ld	de, 40
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	call	_capture_traceback
	ld	hl, _.str.54
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB48_18
	private	BB48_18
BB48_18:
	jr	BB48_19
	private	BB48_19
BB48_19:
	jr	BB48_20
	private	BB48_20
BB48_20:
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_netif_request_services:           ; -- Begin function lwip_netif_request_services
                                        ; @lwip_netif_request_services
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -16
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	a, (ix + 15)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 10), bc
	ld	(ix - 7), a
	ld	hl, (ix + 18)
	ld	(ix - 13), hl
	ld	hl, (ix + 21)
	ld	(ix - 16), hl
	ld	hl, (ix - 6)
	ld	(_test_service_flags), hl
	ld	hl, (_test_service_error)
	ld	iy, 16
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_lwip_now_ms:                           ; -- Begin function lwip_now_ms
                                        ; @lwip_now_ms
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, (_test_time)
	ld	a, (_test_time+3)
	ld	e, a
	pop	ix
	ret
                                        ; -- End function
_lwip_are_services_ready:               ; -- Begin function lwip_are_services_ready
                                        ; @lwip_are_services_ready
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	a, (_test_services_ready)
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_connect:                   ; -- Begin function lwip_socket_connect
                                        ; @lwip_socket_connect
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 6)
	ld	bc, (ix + 9)
	ld	iy, (ix + 12)
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), de
	ld	(ix - 6), bc
	push	hl
	lea	hl, iy + 0
	ld	(ix - 9), l
	ld	(ix - 8), h
	pop	hl
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_available:                 ; -- Begin function lwip_socket_available
                                        ; @lwip_socket_available
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 6)
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), de
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_read:                      ; -- Begin function lwip_socket_read
                                        ; @lwip_socket_read
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 6)
	ld	bc, (ix + 9)
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), de
	ld	(ix - 6), bc
	ld	de, (ix + 12)
	ld	(ix - 9), de
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_feed:                                  ; -- Begin function feed
                                        ; @feed
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	hl, _.str.56
	ld	iy, _.str.57
	ld	(ix - 1), a
	ld	a, (ix - 1)
	or	a, a
	jr	nz, BB55_2
	jr	BB55_1
	private	BB55_1
BB55_1:
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB55_8
	private	BB55_2
BB55_2:
	ld	a, (ix - 1)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	bc, 10
	or	a, a
	sbc	hl, bc
	jr	nz, BB55_4
	jr	BB55_3
	private	BB55_3
BB55_3:
	ld	hl, (_g)
	ld	iy, (_g)
	ld	de, 15084
	add	iy, de
	ld	bc, (iy)
	add	hl, bc
	ld	bc, 10988
	add	hl, bc
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 10988
	add	hl, de
	push	hl
	call	_received
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 15084
	add	hl, de
	ld	de, 0
	ld	(hl), de
	jr	BB55_8
	private	BB55_4
BB55_4:
	ld	hl, (_g)
	ld	bc, 15084
	add	hl, bc
	ld	hl, (hl)
	ld	bc, 4095
	or	a, a
	sbc	hl, bc
	jr	nc, BB55_6
	jr	BB55_5
	private	BB55_5
BB55_5:
	ld	a, (ix - 1)
	ld	iy, (_g)
	ld	hl, (_g)
	ld	de, 15084
	add	hl, de
	ld	de, (hl)
	push	de
	pop	bc
	inc	bc
	ld	(hl), bc
	add	iy, de
	ld	de, 10988
	add	iy, de
	ld	(iy), a
	jr	BB55_7
	private	BB55_6
BB55_6:
	push	iy
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB55_7
	private	BB55_7
BB55_7:
	jr	BB55_8
	private	BB55_8
BB55_8:
	ld	hl, 1
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_list_page:                             ; -- Begin function list_page
                                        ; @list_page
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -47
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	a, (ix + 9)
	ld	bc, _.str.137
	lea	iy, ix - 44
	ld	(ix - 4), hl
	ld	(ix - 1), a
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB56_2
	jr	BB56_1
	private	BB56_1
BB56_1:
	jp	BB56_6
	private	BB56_2
BB56_2:
	ld	hl, (ix - 4)
	ld	a, (ix - 1)
	ld	e, a
	push	de
	push	hl
	push	bc
	ld	hl, 40
	push	hl
	ld	(ix - 47), iy
	push	iy
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	de, 2618
	add	iy, de
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	hl, _.str.138
	jr	z, BB56_4
; %bb.3:
	ld	hl, _.str.139
	private	BB56_4
BB56_4:
	ld	de, (ix - 47)
	push	de
	push	hl
	push	iy
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB56_6
	jr	BB56_5
	private	BB56_5
BB56_5:
	ld	hl, (ix - 4)
	ld	a, (ix - 1)
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	ld	iy, (_g)
	ld	de, 2578
	add	iy, de
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 5284
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 5282
	add	hl, de
	ld	(hl), 0
	ld	hl, _.str.140
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB56_6
	private	BB56_6
BB56_6:
	ld	hl, 47
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_handle_key:                            ; -- Begin function handle_key
                                        ; @handle_key
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -590
	add	hl, sp
	ld	sp, hl
	ld	de, -578
	lea	iy, ix + 0
	add	iy, de
	ld	a, (ix + 6)
	ld	bc, 0
	lea	hl, ix - 67
	push	ix
	ld	de, -590
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -315
	lea	hl, ix + 0
	add	hl, de
	push	ix
	ld	de, -587
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -584
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	lea	hl, iy + 1
	ld	de, -581
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	(ix - 7), a
	ld	a, (ix - 7)
	or	a, a
	jr	z, BB57_2
	jr	BB57_1
	private	BB57_1
BB57_1:
	ld	hl, (_g)
	ld	de, 224
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB57_3
	jr	BB57_2
	private	BB57_2
BB57_2:
	jp	BB57_102
	private	BB57_3
BB57_3:
	ld	a, (ix - 7)
	cp	a, 1
	jr	nz, BB57_5
	jr	BB57_4
	private	BB57_4
BB57_4:
	ld	hl, (_g)
	ld	de, 213
	add	hl, de
	ld	(hl), 1
	call	_clear_selection
	ld	hl, _.str.141
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB57_102
	private	BB57_5
BB57_5:
	ld	a, (ix - 7)
	cp	a, 2
	jr	nz, BB57_8
	jr	BB57_6
	private	BB57_6
BB57_6:
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB57_8
	jr	BB57_7
	private	BB57_7
BB57_7:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 224
	add	hl, de
	ld	(hl), 1
	push	bc
	ld	hl, _.str.142
	push	hl
	push	bc
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.143
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB57_102
	private	BB57_8
BB57_8:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jp	nc, BB57_22
	jr	BB57_9
	private	BB57_9
BB57_9:
	ld	a, (ix - 7)
	cp	a, 3
	jr	nz, BB57_11
	jr	BB57_10
	private	BB57_10
BB57_10:
	ld	hl, _.str.144
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB57_102
	private	BB57_11
BB57_11:
	ld	a, (ix - 7)
	cp	a, 4
	jr	nz, BB57_14
	jr	BB57_12
	private	BB57_12
BB57_12:
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB57_14
	jr	BB57_13
	private	BB57_13
BB57_13:
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	de, (hl)
	dec	de
	ld	(hl), de
	jr	BB57_14
	private	BB57_14
BB57_14:
	ld	a, (ix - 7)
	cp	a, 5
	jr	nz, BB57_17
	jr	BB57_15
	private	BB57_15
BB57_15:
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	hl, (hl)
	ld	de, 40
	or	a, a
	sbc	hl, de
	jr	nc, BB57_17
	jr	BB57_16
	private	BB57_16
BB57_16:
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	de, (hl)
	inc	de
	ld	(hl), de
	jr	BB57_17
	private	BB57_17
BB57_17:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 3
	or	a, a
	sbc	hl, de
	jp	nz, BB57_21
	jr	BB57_18
	private	BB57_18
BB57_18:
	ld	a, (ix - 7)
	cp	a, 6
	jp	nz, BB57_21
	jr	BB57_19
	private	BB57_19
BB57_19:
	ld	hl, (_g)
	ld	de, 568
	add	hl, de
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB57_21
	jr	BB57_20
	private	BB57_20
BB57_20:
	ld	hl, (_g)
	ld	de, 568
	add	hl, de
	push	hl
	ld	hl, _.str.145
	push	hl
	ld	hl, 60
	push	hl
	ld	de, -590
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_snprintf
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2602
	add	hl, de
	ld	bc, -590
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	ld	de, _.str.146
	push	de
	push	hl
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 568
	add	hl, de
	ld	(hl), 0
	ld	hl, _.str.147
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB57_21
	private	BB57_21
BB57_21:
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	jp	BB57_102
	private	BB57_22
BB57_22:
	ld	a, (ix - 7)
	cp	a, 7
	jr	nz, BB57_26
	jr	BB57_23
	private	BB57_23
BB57_23:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB57_26
	jr	BB57_24
	private	BB57_24
BB57_24:
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB57_26
	jr	BB57_25
	private	BB57_25
BB57_25:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 4
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	(hl), 1
	or	a, a
	sbc	hl, hl
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jp	BB57_102
	private	BB57_26
BB57_26:
	ld	a, (ix - 7)
	cp	a, 8
	jp	nz, BB57_37
	jr	BB57_27
	private	BB57_27
BB57_27:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	nz, BB57_37
	jr	BB57_28
	private	BB57_28
BB57_28:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jr	nz, BB57_31
	jr	BB57_29
	private	BB57_29
BB57_29:
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB57_31
	jr	BB57_30
	private	BB57_30
BB57_30:
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	de, (iy)
	lea	hl, iy + 3
	ld	a, (hl)
	ld	l, a
	push	hl
	push	de
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB57_36
	private	BB57_31
BB57_31:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 5
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	c, 1
	jr	z, BB57_35
	jr	BB57_32
	private	BB57_32
BB57_32:
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	ld	a, (hl)
	or	a, a
	ld	c, -1
	ld	a, 0
	jr	z, BB57_34
; %bb.33:
	ld	c, a
	private	BB57_34
BB57_34:
	jr	BB57_35
	private	BB57_35
BB57_35:
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	e, 1
	ld	a, c
	and	a, e
	ld	e, a
	ld	(hl), e
	or	a, a
	sbc	hl, hl
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB57_36
	private	BB57_36
BB57_36:
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	jp	BB57_102
	private	BB57_37
BB57_37:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jr	z, BB57_39
	jr	BB57_38
	private	BB57_38
BB57_38:
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB57_66
	jr	BB57_39
	private	BB57_39
BB57_39:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB57_41
	jr	BB57_40
	private	BB57_40
BB57_40:
	jp	BB57_102
	private	BB57_41
BB57_41:
	ld	a, (ix - 7)
	cp	a, 4
	jr	nz, BB57_44
	jr	BB57_42
	private	BB57_42
BB57_42:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	z, BB57_44
	jr	BB57_43
	private	BB57_43
BB57_43:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	dec	(hl)
	jr	BB57_44
	private	BB57_44
BB57_44:
	ld	a, (ix - 7)
	cp	a, 5
	jr	nz, BB57_47
	jr	BB57_45
	private	BB57_45
BB57_45:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	inc	hl
	ld	iy, (_g)
	ld	de, 5282
	add	iy, de
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jr	nc, BB57_47
	jr	BB57_46
	private	BB57_46
BB57_46:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	inc	(hl)
	jr	BB57_47
	private	BB57_47
BB57_47:
	ld	a, (ix - 7)
	cp	a, 9
	jr	nz, BB57_53
	jr	BB57_48
	private	BB57_48
BB57_48:
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	call	__lcmpzero
	jr	z, BB57_53
	jr	BB57_49
	private	BB57_49
BB57_49:
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 24
	ld	iyl, 0
	ld	a, iyl
	call	__lcmpu
	jr	c, BB57_51
	jr	BB57_50
	private	BB57_50
BB57_50:
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, -24
	ld	a, -1
	call	__ladd
	ld	iyl, e
	jr	BB57_52
	private	BB57_51
BB57_51:
	or	a, a
	sbc	hl, hl
	jr	BB57_52
	private	BB57_52
BB57_52:
	push	iy
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB57_53
	private	BB57_53
BB57_53:
	ld	a, (ix - 7)
	cp	a, 10
	jr	nz, BB57_56
	jr	BB57_54
	private	BB57_54
BB57_54:
	ld	iy, (_g)
	ld	de, 2578
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	call	__lcmpzero
	jr	z, BB57_56
	jr	BB57_55
	private	BB57_55
BB57_55:
	ld	iy, (_g)
	ld	de, 2578
	add	iy, de
	ld	de, (iy)
	lea	hl, iy + 3
	ld	a, (hl)
	ld	l, a
	push	hl
	push	de
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB57_56
	private	BB57_56
BB57_56:
	ld	a, (ix - 7)
	cp	a, 6
	jr	nz, BB57_58
	jr	BB57_57
	private	BB57_57
BB57_57:
	call	_choose
	jr	BB57_58
	private	BB57_58
BB57_58:
	ld	a, (ix - 7)
	cp	a, 3
	jr	nz, BB57_61
	jr	BB57_59
	private	BB57_59
BB57_59:
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB57_61
	jr	BB57_60
	private	BB57_60
BB57_60:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 5
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	(hl), 0
	or	a, a
	sbc	hl, hl
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB57_61
	private	BB57_61
BB57_61:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	iy, (_g)
	ld	de, 5284
	add	iy, de
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jr	nc, BB57_63
	jr	BB57_62
	private	BB57_62
BB57_62:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	a, (hl)
	ld	hl, (_g)
	ld	de, 5284
	add	hl, de
	ld	(hl), a
	jr	BB57_63
	private	BB57_63
BB57_63:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	iy, (_g)
	ld	de, 5284
	add	iy, de
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	de, 22
	add	iy, de
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jr	c, BB57_65
	jr	BB57_64
	private	BB57_64
BB57_64:
	ld	hl, (_g)
	ld	de, 5283
	add	hl, de
	ld	a, (hl)
	ld	l, -21
	add	a, l
	ld	c, a
	ld	hl, (_g)
	ld	de, 5284
	add	hl, de
	ld	(hl), c
	jr	BB57_65
	private	BB57_65
BB57_65:
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	jp	BB57_102
	private	BB57_66
BB57_66:
	ld	a, (ix - 7)
	cp	a, 4
	jr	nz, BB57_69
	jr	BB57_67
	private	BB57_67
BB57_67:
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	hl, (hl)
	ld	de, 23
	add	hl, de
	ld	iy, (_g)
	ld	de, 10181
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
	jr	nc, BB57_69
	jr	BB57_68
	private	BB57_68
BB57_68:
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	de, (hl)
	inc	de
	ld	(hl), de
	jp	BB57_101
	private	BB57_69
BB57_69:
	ld	a, (ix - 7)
	cp	a, 5
	jr	nz, BB57_72
	jr	BB57_70
	private	BB57_70
BB57_70:
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB57_72
	jr	BB57_71
	private	BB57_71
BB57_71:
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	de, (hl)
	dec	de
	ld	(hl), de
	jp	BB57_100
	private	BB57_72
BB57_72:
	ld	a, (ix - 7)
	cp	a, 11
	jr	nz, BB57_74
	jr	BB57_73
	private	BB57_73
BB57_73:
	ld	hl, (_g)
	ld	de, 228
	add	hl, de
	ld	a, (hl)
	ld	hl, (_g)
	ld	de, 222
	add	hl, de
	ld	e, 1
	and	a, e
	ld	e, a
	ld	(hl), e
	jp	BB57_99
	private	BB57_74
BB57_74:
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	nz, BB57_98
	jr	BB57_75
	private	BB57_75
BB57_75:
	ld	hl, (_g)
	ld	de, 10865
	add	hl, de
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 70), hl
	ld	a, (ix - 7)
	cp	a, 3
	jr	nz, BB57_77
	jr	BB57_76
	private	BB57_76
BB57_76:
	ld	hl, (_g)
	ld	de, 10865
	add	hl, de
	ld	(hl), 0
	jp	BB57_97
	private	BB57_77
BB57_77:
	ld	a, (ix - 7)
	cp	a, 12
	jr	nz, BB57_80
	jr	BB57_78
	private	BB57_78
BB57_78:
	ld	hl, (ix - 70)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB57_80
	jr	BB57_79
	private	BB57_79
BB57_79:
	ld	hl, (_g)
	ld	de, (ix - 70)
	add	hl, de
	ld	de, 10864
	add	hl, de
	ld	(hl), 0
	jp	BB57_96
	private	BB57_80
BB57_80:
	ld	a, (ix - 7)
	cp	a, 6
	jp	nz, BB57_91
	jr	BB57_81
	private	BB57_81
BB57_81:
	ld	hl, (ix - 70)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, BB57_91
	jr	BB57_82
	private	BB57_82
BB57_82:
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	z, BB57_85
	jr	BB57_83
	private	BB57_83
BB57_83:
	ld	hl, (_g)
	ld	de, 227
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB57_85
	jr	BB57_84
	private	BB57_84
BB57_84:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB57_86
	jr	BB57_85
	private	BB57_85
BB57_85:
	ld	hl, _.str.148
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB57_102
	private	BB57_86
BB57_86:
	ld	hl, (_g)
	ld	de, 10865
	add	hl, de
	push	hl
	ld	hl, 245
	push	hl
	ld	de, -587
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_quote
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB57_90
	jr	BB57_87
	private	BB57_87
BB57_87:
	ld	de, -587
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.149
	push	hl
	ld	hl, 262
	push	hl
	ld	de, -581
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_snprintf
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2666
	add	hl, de
	ld	bc, -581
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	ld	de, _.str.150
	push	de
	push	hl
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB57_89
	jr	BB57_88
	private	BB57_88
BB57_88:
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	(hl), 1
	ld	hl, _.str.151
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB57_89
	private	BB57_89
BB57_89:
	jr	BB57_90
	private	BB57_90
BB57_90:
	jr	BB57_95
	private	BB57_91
BB57_91:
	ld	a, (ix - 7)
	ld	l, a
	push	hl
	call	_input_char
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -584
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	(iy + 0), a
	ld	a, (iy + 0)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB57_94
	jr	BB57_92
	private	BB57_92
BB57_92:
	ld	hl, (ix - 70)
	inc	hl
	ld	de, 121
	or	a, a
	sbc	hl, de
	jr	nc, BB57_94
	jr	BB57_93
	private	BB57_93
BB57_93:
	ld	a, (iy + 0)
	ld	hl, (_g)
	ld	de, (ix - 70)
	add	hl, de
	ld	de, 10865
	add	hl, de
	ld	(hl), a
	ld	hl, (_g)
	ld	de, (ix - 70)
	add	hl, de
	ld	de, 10866
	add	hl, de
	ld	(hl), 0
	jr	BB57_94
	private	BB57_94
BB57_94:
	jr	BB57_95
	private	BB57_95
BB57_95:
	jr	BB57_96
	private	BB57_96
BB57_96:
	jr	BB57_97
	private	BB57_97
BB57_97:
	jr	BB57_98
	private	BB57_98
BB57_98:
	jr	BB57_99
	private	BB57_99
BB57_99:
	jr	BB57_100
	private	BB57_100
BB57_100:
	jr	BB57_101
	private	BB57_101
BB57_101:
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	jr	BB57_102
	private	BB57_102
BB57_102:
	ld	hl, 590
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_request:                               ; -- Begin function request
                                        ; @request
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -38
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	iy, 400
	lea	hl, ix - 29
	ld	(ix - 35), hl
	ld	hl, (ix + 6)
	ld	(ix - 4), hl
	ld	(ix - 7), de
	ld	(ix - 10), bc
	push	iy
	call	_mem_malloc
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 13), hl
	ld	hl, (ix - 13)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB58_2
	jr	BB58_1
	private	BB58_1
BB58_1:
	ld	hl, _.str.156
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	(ix - 1), 0
	jp	BB58_14
	private	BB58_2
BB58_2:
	ld	hl, (_g)
	ld	de, 2570
	add	hl, de
	ld	(ix - 38), hl
	ld	hl, (hl)
	ld	iy, (ix - 38)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	iy, (ix - 38)
	ld	(iy), hl
	lea	iy, iy + 3
	ld	(iy), e
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ld	hl, _.str.157
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, (ix - 35)
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	de, (ix - 13)
	ld	bc, (ix - 7)
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB58_4
	jr	BB58_3
	private	BB58_3
BB58_3:
	ld	hl, (ix - 10)
	jr	BB58_5
	private	BB58_4
BB58_4:
	ld	hl, _.str.8
	jr	BB58_5
	private	BB58_5
BB58_5:
	push	hl
	ld	hl, (ix - 35)
	push	hl
	push	bc
	ld	hl, _.str.158
	push	hl
	ld	hl, 400
	push	hl
	push	de
	call	_snprintf
	ld	iy, 18
	add	iy, sp
	ld	sp, iy
	ld	(ix - 32), hl
	ld	hl, (ix - 32)
	ld	de, -8388608
	add	hl, de
	ld	de, -8388608
	or	a, a
	sbc	hl, de
	jr	c, BB58_7
	jr	BB58_6
	private	BB58_6
BB58_6:
	ld	hl, (ix - 32)
	ld	de, -8388608
	add	hl, de
	ld	de, -8388208
	or	a, a
	sbc	hl, de
	jr	c, BB58_8
	jr	BB58_7
	private	BB58_7
BB58_7:
	ld	hl, (ix - 13)
	push	hl
	call	_mem_free
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.159
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	(ix - 1), 0
	jp	BB58_14
	private	BB58_8
BB58_8:
	ld	hl, (_g)
	ld	de, 212
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB58_10
	jr	BB58_9
	private	BB58_9
BB58_9:
	ld	hl, (_g)
	ld	de, 209
	add	hl, de
	ld	de, (ix - 13)
	ld	bc, (ix - 32)
	push	bc
	push	de
	push	hl
	call	_lwip_socket_write
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB58_11
	jr	BB58_10
	private	BB58_10
BB58_10:
	ld	hl, (ix - 13)
	push	hl
	call	_mem_free
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.160
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	(ix - 1), 0
	jr	BB58_14
	private	BB58_11
BB58_11:
	ld	hl, (ix - 13)
	push	hl
	call	_mem_free
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 4)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB58_13
	jr	BB58_12
	private	BB58_12
BB58_12:
	ld	hl, (ix - 4)
	ld	de, (ix - 35)
	push	de
	ld	de, 16
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	call	_lwip_now_ms
	ld	iy, (_g)
	ld	bc, 2590
	add	iy, bc
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), e
	jr	BB58_13
	private	BB58_13
BB58_13:
	ld	(ix - 1), 1
	jr	BB58_14
	private	BB58_14
BB58_14:
	ld	a, (ix - 1)
	ld	hl, 38
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_history:                               ; -- Begin function history
                                        ; @history
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	iy, _.str.163
	ld	bc, _.str.164
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	nz, BB59_4
	jr	BB59_1
	private	BB59_1
BB59_1:
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	z, BB59_4
	jr	BB59_2
	private	BB59_2
BB59_2:
	ld	hl, (_g)
	ld	de, 228
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB59_4
	jr	BB59_3
	private	BB59_3
BB59_3:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB59_5
	jr	BB59_4
	private	BB59_4
BB59_4:
	jr	BB59_7
	private	BB59_5
BB59_5:
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	push	bc
	push	iy
	push	hl
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB59_7
	jr	BB59_6
	private	BB59_6
BB59_6:
	ld	hl, (_g)
	ld	de, 10862
	add	hl, de
	ld	bc, 0
	ld	(hl), bc
	ld	hl, (_g)
	ld	de, 10859
	add	hl, de
	ld	(hl), bc
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	(hl), bc
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	(hl), bc
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 222
	add	hl, de
	ld	(hl), 0
	ld	hl, _.str.165
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB59_7
	private	BB59_7
BB59_7:
	pop	ix
	ret
                                        ; -- End function
_capture_traceback:                     ; -- Begin function capture_traceback
                                        ; @capture_traceback
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -23
	add	hl, sp
	ld	sp, hl
	lea	hl, ix - 1
	ld	(ix - 1), 0
	push	hl
	call	_lwip_get_traceback
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 4), hl
	ld	a, (ix - 1)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388603
	or	a, a
	sbc	hl, de
	jr	c, BB60_2
	jr	BB60_1
	private	BB60_1
BB60_1:
	ld	hl, 4
	jr	BB60_3
	private	BB60_2
BB60_2:
	ld	a, (ix - 1)
	or	a, a
	sbc	hl, hl
	ld	l, a
	jr	BB60_3
	private	BB60_3
BB60_3:
	ld	a, l
	ld	hl, (_g)
	ld	de, 2560
	add	hl, de
	ld	(hl), a
	ld	hl, (_g)
	ld	de, 2561
	add	hl, de
	ld	(hl), 0
	ld	(ix - 5), 0
	jr	BB60_4
	private	BB60_4
BB60_4:                                 ; =>This Inner Loop Header: Depth=1
	ld	a, (ix - 5)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	iy, (_g)
	ld	de, 2560
	add	iy, de
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	de, -8388608
	add	iy, de
	add	hl, de
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jp	nc, BB60_10
	jr	BB60_5
	private	BB60_5
BB60_5:                                 ;   in Loop: Header=BB60_4 Depth=1
	ld	iy, (ix - 4)
	ld	a, (ix - 5)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 22
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	(ix - 8), iy
	ld	iy, (ix - 8)
	ld	a, (iy + 2)
	or	a, a
	jr	z, BB60_7
	jr	BB60_6
	private	BB60_6
BB60_6:                                 ;   in Loop: Header=BB60_4 Depth=1
	ld	iy, (_g)
	ld	a, (ix - 5)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 72
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 2272
	add	iy, de
	ld	(ix - 14), iy
	ld	iy, (ix - 8)
	ld	a, (iy + 2)
	ld	l, a
	push	hl
	call	_lwip_debug_file_name
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	iy, (ix - 8)
	ld	de, (iy + 3)
	ld	a, (iy + 6)
	ld	iy, (ix - 8)
	ld	iy, (iy + 8)
	ld	bc, 0
	ld	c, iyl
	ld	b, iyh
	push	bc
	ld	c, a
	push	bc
	push	de
	push	hl
	ld	hl, _.str.12
	push	hl
	ld	hl, 72
	push	hl
	ld	hl, (ix - 14)
	push	hl
	call	_snprintf
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	jp	BB60_8
	private	BB60_7
BB60_7:                                 ;   in Loop: Header=BB60_4 Depth=1
	ld	iy, (_g)
	ld	a, (ix - 5)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 72
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 2272
	add	iy, de
	ld	(ix - 11), iy
	ld	iy, (ix - 8)
	ld	hl, (iy + 10)
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	(ix - 23), de
	ld	iy, (ix - 8)
	ld	hl, (iy + 12)
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	iy, (ix - 8)
	ld	hl, (iy + 14)
	ld	(ix - 17), hl
	ld	iy, (ix - 8)
	ld	iy, (iy + 18)
	or	a, a
	sbc	hl, hl
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld	iy, (ix - 8)
	ld	bc, (iy + 20)
	ld	(ix - 20), bc
	ld	bc, 0
	ld	iy, (ix - 20)
	ld	c, iyl
	ld	b, iyh
	push	bc
	push	hl
	ld	hl, (ix - 17)
	push	hl
	push	de
	ld	hl, (ix - 23)
	push	hl
	ld	hl, _.str.55
	push	hl
	ld	hl, 72
	push	hl
	ld	hl, (ix - 11)
	push	hl
	call	_snprintf
	ld	hl, 24
	add	hl, sp
	ld	sp, hl
	jr	BB60_8
	private	BB60_8
BB60_8:                                 ;   in Loop: Header=BB60_4 Depth=1
	jr	BB60_9
	private	BB60_9
BB60_9:                                 ;   in Loop: Header=BB60_4 Depth=1
	inc	(ix - 5)
	jp	BB60_4
	private	BB60_10
BB60_10:
	ld	hl, 23
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_get_traceback:                    ; -- Begin function lwip_get_traceback
                                        ; @lwip_get_traceback
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	de, (ix + 6)
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), de
	ld	iy, (ix - 3)
	ld	(iy), 0
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_received:                              ; -- Begin function received
                                        ; @received
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1557
	add	hl, sp
	ld	sp, hl
	ld	de, -210
	lea	iy, ix + 0
	add	iy, de
	ld	de, -385
	lea	hl, ix + 0
	add	hl, de
	push	ix
	ld	bc, -1524
	add	ix, bc
	lea	de, ix + 0
	pop	ix
	push	ix
	ld	bc, -1536
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	ld	de, _.str.113
	push	ix
	ld	bc, -1542
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	lea	bc, iy + 30
	push	ix
	ld	de, -1527
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	lea	de, iy + 26
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 3
	ld	(iy + 0), de
	push	hl
	pop	iy
	lea	de, iy + 94
	push	ix
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 128
	lea	ix, ix - 18
	ld	(ix + 0), de
	pop	ix
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	lea	de, iy + 0
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 12
	ld	(iy + 0), de
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 2
	lea	de, iy + 0
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 15
	ld	(iy + 0), de
	ld	de, -1536
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	lea	de, iy + 6
	lea	iy, ix + 0
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 128
	lea	iy, iy - 9
	ld	(iy + 0), de
	ld	hl, (ix + 6)
	ld	(ix - 9), hl
	ld	hl, (ix - 9)
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	push	bc
	call	_wire_parse
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_2
	jr	BB62_1
	private	BB62_1
BB62_1:
	ld	hl, _.str.58
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_2
BB62_2:
	call	_lwip_now_ms
	ld	iy, (_g)
	ld	bc, 2586
	add	iy, bc
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), e
	ld	hl, _.str.59
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 23), hl
	ld	hl, _.str.60
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 20), hl
	ld	hl, _.str.61
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 17), hl
	ld	hl, _.str.62
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 14), hl
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2602
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	l, 1
	and	a, l
	ld	l, a
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 13), l
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2618
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	l, 1
	and	a, l
	ld	l, a
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 12), l
	ld	hl, (iy + 23)
	ld	de, _.str.63
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_8
	jr	BB62_3
	private	BB62_3
BB62_3:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_6
	jr	BB62_4
	private	BB62_4
BB62_4:
	ld	de, -1539
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.64
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_uint
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_6
	jr	BB62_5
	private	BB62_5
BB62_5:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 26)
	ld	e, (iy + 29)
	ld	bc, 2
	xor	a, a
	call	__lcmpu
	jr	z, BB62_7
	jr	BB62_6
	private	BB62_6
BB62_6:
	ld	hl, _.str.65
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_7
BB62_7:
	call	_login
	jp	BB62_165
	private	BB62_8
BB62_8:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.66
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	de, -1527
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	iy, (hl)
	jp	nz, BB62_18
	jr	BB62_9
	private	BB62_9
BB62_9:
	ld	a, (iy + 13)
	bit	0, a
	jp	z, BB62_18
	jr	BB62_10
	private	BB62_10
BB62_10:
	ld	hl, _.str.67
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 9), hl
	ld	hl, _.str.68
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 6), hl
	ld	hl, (iy + 9)
	ld	de, 8
	push	de
	ld	de, _.str.69
	push	de
	push	hl
	call	_strncmp
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_14
	jr	BB62_11
	private	BB62_11
BB62_11:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 9)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	de, 1025
	or	a, a
	sbc	hl, de
	jr	nc, BB62_14
	jr	BB62_12
	private	BB62_12
BB62_12:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 6)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	de, 129
	or	a, a
	sbc	hl, de
	jr	nc, BB62_14
	jr	BB62_13
	private	BB62_13
BB62_13:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 6)
	ld	a, (hl)
	or	a, a
	jr	nz, BB62_15
	jr	BB62_14
	private	BB62_14
BB62_14:
	ld	hl, _.str.70
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_15
BB62_15:
	ld	hl, (_g)
	ld	de, 589
	add	hl, de
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 9)
	ld	bc, (iy + 6)
	push	bc
	push	de
	ld	de, _.str.71
	push	de
	ld	de, 1400
	push	de
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 1
	ld	(hl), de
	ld	hl, _.str.72
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -1539
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.73
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_uint
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_17
	jr	BB62_16
	private	BB62_16
BB62_16:
	call	_lwip_now_ms
	ld	iy, (_g)
	ld	bc, 2562
	add	iy, bc
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), e
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 26)
	ld	a, (iy + 29)
	ld	iy, (_g)
	ld	de, 2566
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB62_17
	private	BB62_17
BB62_17:
	jp	BB62_165
	private	BB62_18
BB62_18:
	ld	hl, (iy + 23)
	ld	de, _.str.74
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_25
	jr	BB62_19
	private	BB62_19
BB62_19:
	ld	a, (iy + 13)
	bit	0, a
	jp	z, BB62_25
	jr	BB62_20
	private	BB62_20
BB62_20:
	ld	hl, _.str.75
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 3), hl
	ld	hl, (iy + 3)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	de, 16
	or	a, a
	sbc	hl, de
	jr	z, BB62_22
	jr	BB62_21
	private	BB62_21
BB62_21:
	ld	hl, _.str.76
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_22
BB62_22:
	ld	hl, (_g)
	ld	de, 589
	add	hl, de
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 3)
	push	de
	ld	de, _.str.77
	push	de
	ld	de, 1400
	push	de
	push	hl
	call	_snprintf
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 2
	ld	(hl), de
	ld	hl, _.str.78
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -1539
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.73
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_uint
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_24
	jr	BB62_23
	private	BB62_23
BB62_23:
	call	_lwip_now_ms
	ld	iy, (_g)
	ld	bc, 2562
	add	iy, bc
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), e
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 26)
	ld	a, (iy + 29)
	ld	iy, (_g)
	ld	de, 2566
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB62_24
	private	BB62_24
BB62_24:
	jp	BB62_164
	private	BB62_25
BB62_25:
	ld	hl, (iy + 23)
	ld	de, _.str.79
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_30
	jr	BB62_26
	private	BB62_26
BB62_26:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 2
	or	a, a
	sbc	hl, de
	jp	nz, BB62_30
	jr	BB62_27
	private	BB62_27
BB62_27:
	ld	hl, _.str.80
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 0), hl
	ld	hl, (iy + 0)
	push	hl
	call	_wire_id
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_29
	jr	BB62_28
	private	BB62_28
BB62_28:
	ld	hl, _.str.81
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_29
BB62_29:
	ld	hl, (_g)
	ld	de, 568
	add	hl, de
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 0)
	push	de
	ld	de, 21
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.82
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	hl
	ld	hl, 81
	push	hl
	ld	de, -1554
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_display_ascii
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 589
	add	hl, de
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 0)
	push	de
	ld	bc, -1554
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	ld	de, _.str.83
	push	de
	ld	de, 1400
	push	de
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 3
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 2069
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	hl, _.str.84
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_163
	private	BB62_30
BB62_30:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.85
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_36
	jr	BB62_31
	private	BB62_31
BB62_31:
	ld	a, (iy + 13)
	bit	0, a
	jp	z, BB62_36
	jr	BB62_32
	private	BB62_32
BB62_32:
	ld	hl, _.str.86
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1533
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 91), hl
	ld	hl, (iy + 91)
	push	hl
	call	_token_valid
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_34
	jr	BB62_33
	private	BB62_33
BB62_33:
	ld	hl, _.str.80
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	hl
	call	_wire_id
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_35
	jr	BB62_34
	private	BB62_34
BB62_34:
	ld	hl, _.str.87
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_35
BB62_35:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	push	ix
	ld	de, -1533
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 91)
	push	de
	ld	de, 44
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	(hl), 1
	ld	iy, (_g)
	ld	de, 2566
	add	iy, de
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 589
	add	hl, de
	ld	(hl), 0
	call	_clear_selection
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 4
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 226
	add	hl, de
	ld	(hl), 1
	ld	hl, _.str.88
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_162
	private	BB62_36
BB62_36:
	ld	hl, (iy + 23)
	ld	de, _.str.89
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB62_38
	jr	BB62_37
	private	BB62_37
BB62_37:
	ld	hl, (iy + 23)
	ld	de, _.str.90
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_55
	jr	BB62_38
	private	BB62_38
BB62_38:
	ld	a, (iy + 12)
	bit	0, a
	jp	z, BB62_55
	jr	BB62_39
	private	BB62_39
BB62_39:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	a, 1
	ld	l, 0
	jr	z, BB62_41
; %bb.40:
	ld	a, l
	private	BB62_41
BB62_41:
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	(iy + 90), a
	ld	a, (iy + 90)
	bit	0, a
	jr	z, BB62_43
	jr	BB62_42
	private	BB62_42
BB62_42:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 17)
	jr	BB62_44
	private	BB62_43
BB62_43:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 14)
	jr	BB62_44
	private	BB62_44
BB62_44:
	push	ix
	ld	de, -1533
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 87), hl
	ld	a, (iy + 90)
	bit	0, a
	jr	nz, BB62_47
	jr	BB62_45
	private	BB62_45
BB62_45:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 17)
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_51
	jr	BB62_46
	private	BB62_46
BB62_46:
	ld	hl, (iy + 23)
	ld	de, _.str.90
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_51
	jr	BB62_47
	private	BB62_47
BB62_47:
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 90)
	bit	0, a
	jr	z, BB62_49
	jr	BB62_48
	private	BB62_48
BB62_48:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.89
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_51
	jr	BB62_49
	private	BB62_49
BB62_49:
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 87)
	push	hl
	call	_wire_id
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_51
	jr	BB62_50
	private	BB62_50
BB62_50:
	ld	hl, (_g)
	ld	de, 5282
	add	hl, de
	ld	a, (hl)
	cp	a, 24
	jr	nz, BB62_52
	jr	BB62_51
	private	BB62_51
BB62_51:
	ld	hl, _.str.91
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_52
BB62_52:
	ld	iy, (_g)
	ld	hl, (_g)
	ld	de, 5282
	add	hl, de
	ld	a, (hl)
	inc	(hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 104
	call	__imulu
	push	hl
	pop	de
	lea	hl, iy + 0
	add	hl, de
	ld	de, 2786
	add	hl, de
	ex	de, hl
	ld	bc, -1533
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	(iy + 84), de
	ld	hl, (iy + 84)
	ld	de, (iy + 87)
	push	de
	ld	de, 21
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	iy, (iy + 84)
	lea	hl, iy + 21
	ld	de, -1557
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	hl, _.str.82
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	hl
	ld	hl, 81
	push	hl
	ld	de, -1557
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_display_ascii
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.92
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_bool
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	iy, (iy + 84)
	ld	l, 1
	and	a, l
	ld	l, a
	ld	(iy + 102), l
	ld	hl, _.str.93
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_bool
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	de, (iy + 84)
	lea	bc, iy + 0
	ld	l, 1
	and	a, l
	ld	l, a
	push	de
	pop	iy
	ld	(iy + 103), l
	push	bc
	pop	iy
	ld	bc, (iy + 87)
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_54
	jr	BB62_53
	private	BB62_53
BB62_53:
	ld	de, -1533
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	bc
	pop	iy
	ld	iy, (iy + 84)
	ld	a, (iy + 102)
	ld	hl, (_g)
	ld	de, 227
	add	hl, de
	ld	e, 1
	and	a, e
	ld	e, a
	ld	(hl), e
	push	bc
	pop	iy
	ld	iy, (iy + 84)
	ld	a, (iy + 103)
	ld	hl, (_g)
	ld	de, 228
	add	hl, de
	ld	e, 1
	and	a, e
	ld	e, a
	ld	(hl), e
	jr	BB62_54
	private	BB62_54
BB62_54:
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	jp	BB62_161
	private	BB62_55
BB62_55:
	ld	hl, (iy + 23)
	ld	de, _.str.94
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB62_57
	jr	BB62_56
	private	BB62_56
BB62_56:
	ld	hl, (iy + 23)
	ld	de, _.str.95
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_72
	jr	BB62_57
	private	BB62_57
BB62_57:
	ld	a, (iy + 12)
	bit	0, a
	jp	z, BB62_72
	jr	BB62_58
	private	BB62_58
BB62_58:
	ld	iy, (_g)
	ld	de, 2578
	add	iy, de
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), 0
	ld	de, -1539
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.96
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_uint
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_62
	jr	BB62_59
	private	BB62_59
BB62_59:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 26)
	ld	a, (iy + 29)
	ld	iy, (_g)
	ld	de, 2574
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	call	__lcmpu
	jr	nc, BB62_62
	jr	BB62_60
	private	BB62_60
BB62_60:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 26)
	ld	a, (iy + 29)
	ld	hl, 100000
	ld	e, 0
	call	__lcmpu
	jr	c, BB62_62
	jr	BB62_61
	private	BB62_61
BB62_61:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 26)
	ld	a, (iy + 29)
	ld	iy, (_g)
	ld	de, 2578
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	jr	BB62_62
	private	BB62_62
BB62_62:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2618
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 5282
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	nz, BB62_64
	jr	BB62_63
	private	BB62_63
BB62_63:
	ld	hl, _.str.97
	jr	BB62_71
	private	BB62_64
BB62_64:
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	l, 1
	jr	nz, BB62_68
	jr	BB62_65
	private	BB62_65
BB62_65:
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	l, -1
	ld	a, 0
	jr	z, BB62_67
; %bb.66:
	ld	l, a
	private	BB62_67
BB62_67:
	jr	BB62_68
	private	BB62_68
BB62_68:
	bit	0, l
	ld	hl, _.str.98
	jr	nz, BB62_70
; %bb.69:
	ld	hl, _.str.99
	private	BB62_70
BB62_70:
	jr	BB62_71
	private	BB62_71
BB62_71:
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_160
	private	BB62_72
BB62_72:
	ld	hl, (iy + 23)
	ld	de, _.str.100
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_77
	jr	BB62_73
	private	BB62_73
BB62_73:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2634
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_77
	jr	BB62_74
	private	BB62_74
BB62_74:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 17)
	ld	hl, (_g)
	ld	de, 2682
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_76
	jr	BB62_75
	private	BB62_75
BB62_75:
	ld	hl, _.str.101
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_76
BB62_76:
	call	_clear_chat
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 17)
	push	de
	ld	de, 21
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	de, 406
	add	iy, de
	ld	hl, (_g)
	ld	de, 2703
	add	hl, de
	push	hl
	ld	hl, 81
	push	hl
	push	iy
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2634
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 5
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 217
	add	hl, de
	ld	(hl), 1
	or	a, a
	sbc	hl, hl
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jp	BB62_159
	private	BB62_77
BB62_77:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.102
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_85
	jr	BB62_78
	private	BB62_78
BB62_78:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2634
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_85
	jr	BB62_79
	private	BB62_79
BB62_79:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 14)
	ld	hl, (_g)
	ld	de, 2682
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_81
	jr	BB62_80
	private	BB62_80
BB62_80:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 17)
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_82
	jr	BB62_81
	private	BB62_81
BB62_81:
	ld	hl, _.str.103
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_82
BB62_82:
	call	_clear_chat
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	ix
	ld	de, -1527
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (iy + 14)
	push	de
	ld	de, 21
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	de, 487
	add	iy, de
	ld	hl, (_g)
	ld	de, 2703
	add	hl, de
	push	hl
	ld	hl, 81
	push	hl
	push	iy
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2784
	add	hl, de
	ld	a, (hl)
	ld	hl, (_g)
	ld	de, 227
	add	hl, de
	push	de
	pop	iy
	ld	e, 1
	and	a, e
	ld	c, a
	ld	(hl), c
	ld	hl, (_g)
	ld	bc, 2785
	add	hl, bc
	ld	a, (hl)
	ld	hl, (_g)
	ld	bc, 228
	add	hl, bc
	and	a, e
	ld	e, a
	ld	(hl), e
	ld	hl, (_g)
	ld	bc, 218
	add	hl, bc
	ld	(hl), 0
	ld	hl, (_g)
	ld	bc, 2634
	add	hl, bc
	ld	(hl), 0
	ld	hl, (_g)
	ld	bc, 217
	add	hl, bc
	ld	(hl), 0
	ld	hl, (_g)
	lea	de, iy + 0
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	hl, _.str.99
	jr	nz, BB62_84
; %bb.83:
	ld	hl, _.str.104
	private	BB62_84
BB62_84:
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	call	_history
	jp	BB62_158
	private	BB62_85
BB62_85:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.105
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_89
	jr	BB62_86
	private	BB62_86
BB62_86:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_89
	jr	BB62_87
	private	BB62_87
BB62_87:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 14)
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_89
	jr	BB62_88
	private	BB62_88
BB62_88:
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	jp	BB62_157
	private	BB62_89
BB62_89:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.106
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_93
	jr	BB62_90
	private	BB62_90
BB62_90:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_93
	jr	BB62_91
	private	BB62_91
BB62_91:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 14)
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_93
	jr	BB62_92
	private	BB62_92
BB62_92:
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	ld	(hl), 0
	ld	hl, _.str.99
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_156
	private	BB62_93
BB62_93:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.107
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_109
	jr	BB62_94
	private	BB62_94
BB62_94:
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB62_109
	jr	BB62_95
	private	BB62_95
BB62_95:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 17)
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_109
	jr	BB62_96
	private	BB62_96
BB62_96:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 14)
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_109
	jr	BB62_97
	private	BB62_97
BB62_97:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 20)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB62_100
	jr	BB62_98
	private	BB62_98
BB62_98:
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_100
	jr	BB62_99
	private	BB62_99
BB62_99:
	jp	BB62_165
	private	BB62_100
BB62_100:
	ld	hl, _.str.108
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1533
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 81), hl
	ld	hl, (iy + 81)
	push	hl
	call	_wire_id
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_102
	jr	BB62_101
	private	BB62_101
BB62_101:
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 81)
	push	hl
	call	_seen
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_103
	jr	BB62_102
	private	BB62_102
BB62_102:
	jp	BB62_165
	private	BB62_103
BB62_103:
	ld	hl, _.str.109
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	hl
	ld	hl, 81
	push	hl
	ld	de, -1548
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_display_ascii
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.110
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	hl
	ld	hl, 513
	push	hl
	ld	de, -1551
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_display_ascii
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.112
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_bool
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_105
; %bb.104:
	ld	hl, _.str.8
	ld	de, -1542
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	private	BB62_105
BB62_105:
	ld	de, -1542
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	de, -1551
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	de, -1548
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.111
	push	hl
	ld	hl, 620
	push	hl
	ld	de, -1545
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_snprintf
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 81)
	ld	de, 17
	push	de
	push	hl
	ld	de, -1545
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_append
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, -1539
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.114
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_uint
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_108
	jr	BB62_106
	private	BB62_106
BB62_106:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 26)
	ld	e, (iy + 29)
	call	__lcmpzero
	jr	z, BB62_108
	jr	BB62_107
	private	BB62_107
BB62_107:
	ld	de, -1533
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 81)
	ld	de, 20
	push	de
	push	hl
	ld	hl, _.str.115
	push	hl
	call	_append
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB62_108
	private	BB62_108
BB62_108:
	jp	BB62_155
	private	BB62_109
BB62_109:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.116
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB62_111
	jr	BB62_110
	private	BB62_110
BB62_110:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.117
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_121
	jr	BB62_111
	private	BB62_111
BB62_111:
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jp	z, BB62_121
	jr	BB62_112
	private	BB62_112
BB62_112:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 17)
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_121
	jr	BB62_113
	private	BB62_113
BB62_113:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 14)
	ld	hl, (_g)
	ld	de, 385
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jp	z, BB62_121
	jr	BB62_114
	private	BB62_114
BB62_114:
	ld	hl, _.str.108
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1536
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 3), hl
	ld	hl, (iy + 3)
	push	hl
	call	_wire_id
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	nz, BB62_116
	jr	BB62_115
	private	BB62_115
BB62_115:
	jp	BB62_165
	private	BB62_116
BB62_116:
	ld	de, -1536
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 3)
	push	hl
	call	_delete_message
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -1536
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 3)
	push	hl
	call	_seen
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.117
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_120
	jr	BB62_117
	private	BB62_117
BB62_117:
	ld	hl, (_g)
	ld	de, 228
	add	hl, de
	ld	a, (hl)
	ld	hl, (_g)
	ld	bc, 222
	add	hl, bc
	ld	c, 1
	and	a, c
	ld	c, a
	ld	(hl), c
	ld	hl, (_g)
	add	hl, de
	ld	a, (hl)
	bit	0, a
	ld	hl, _.str.118
	jr	nz, BB62_119
; %bb.118:
	ld	hl, _.str.119
	private	BB62_119
BB62_119:
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB62_120
	private	BB62_120
BB62_120:
	jp	BB62_154
	private	BB62_121
BB62_121:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.120
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_124
	jr	BB62_122
	private	BB62_122
BB62_122:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2666
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_124
	jr	BB62_123
	private	BB62_123
BB62_123:
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 10865
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2666
	add	hl, de
	ld	(hl), 0
	ld	hl, _.str.121
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_153
	private	BB62_124
BB62_124:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.122
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_127
	jr	BB62_125
	private	BB62_125
BB62_125:
	ld	hl, (_g)
	ld	de, 215
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB62_127
	jr	BB62_126
	private	BB62_126
BB62_126:
	call	_clear_selection
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	de, 4
	ld	(hl), de
	or	a, a
	sbc	hl, hl
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_list_page
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.123
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_152
	private	BB62_127
BB62_127:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.124
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_130
	jr	BB62_128
	private	BB62_128
BB62_128:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 17)
	ld	hl, (_g)
	ld	de, 364
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_130
	jr	BB62_129
	private	BB62_129
BB62_129:
	ld	hl, (_g)
	ld	de, 221
	add	hl, de
	ld	(hl), 1
	jp	BB62_151
	private	BB62_130
BB62_130:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.125
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_132
	jr	BB62_131
	private	BB62_131
BB62_131:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	(hl), 1
	ld	hl, _.str.126
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_150
	private	BB62_132
BB62_132:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 23)
	ld	de, _.str.127
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, BB62_149
	jr	BB62_133
	private	BB62_133
BB62_133:
	ld	hl, _.str.75
	push	hl
	ld	de, -1530
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	push	hl
	call	_wire_string
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1536
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	lea	bc, iy + 0
	ld	(iy + 0), hl
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 13)
	bit	0, a
	jr	z, BB62_138
	jr	BB62_134
	private	BB62_134
BB62_134:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	(hl), 1
	ld	hl, (_g)
	ld	de, 229
	add	hl, de
	ld	a, (hl)
	bit	0, a
	push	bc
	pop	iy
	jr	z, BB62_137
	jr	BB62_135
	private	BB62_135
BB62_135:
	ld	hl, (iy + 0)
	ld	de, _.str.128
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	push	ix
	ld	de, -1536
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_137
	jr	BB62_136
	private	BB62_136
BB62_136:
	ld	hl, (_g)
	ld	de, 229
	add	hl, de
	ld	(hl), 0
	call	_login
	jp	BB62_165
	private	BB62_137
BB62_137:
	ld	hl, (iy + 0)
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_138
BB62_138:
	push	bc
	pop	iy
	ld	hl, (iy + 0)
	ld	de, _.str.129
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB62_140
	jr	BB62_139
	private	BB62_139
BB62_139:
	ld	de, -1536
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 0)
	ld	de, _.str.130
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB62_141
	jr	BB62_140
	private	BB62_140
BB62_140:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 225
	add	hl, de
	ld	(hl), 1
	ld	hl, _.str.131
	push	hl
	call	_fail
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jp	BB62_165
	private	BB62_141
BB62_141:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	a, (iy + 12)
	bit	0, a
	jr	nz, BB62_143
	jr	BB62_142
	private	BB62_142
BB62_142:
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2634
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_144
	jr	BB62_143
	private	BB62_143
BB62_143:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2634
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2618
	add	hl, de
	ld	(hl), 0
	jr	BB62_144
	private	BB62_144
BB62_144:
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_146
	jr	BB62_145
	private	BB62_145
BB62_145:
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	ld	(hl), 0
	jr	BB62_146
	private	BB62_146
BB62_146:
	ld	de, -1527
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, (iy + 20)
	ld	hl, (_g)
	ld	de, 2666
	add	hl, de
	push	hl
	push	bc
	call	_matches
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB62_148
	jr	BB62_147
	private	BB62_147
BB62_147:
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2666
	add	hl, de
	ld	(hl), 0
	jr	BB62_148
	private	BB62_148
BB62_148:
	ld	de, -1536
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy + 0)
	push	hl
	ld	hl, _.str.11
	push	hl
	call	_status
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	jr	BB62_149
	private	BB62_149
BB62_149:
	jr	BB62_150
	private	BB62_150
BB62_150:
	jr	BB62_151
	private	BB62_151
BB62_151:
	jr	BB62_152
	private	BB62_152
BB62_152:
	jr	BB62_153
	private	BB62_153
BB62_153:
	jr	BB62_154
	private	BB62_154
BB62_154:
	jr	BB62_155
	private	BB62_155
BB62_155:
	jr	BB62_156
	private	BB62_156
BB62_156:
	jr	BB62_157
	private	BB62_157
BB62_157:
	jr	BB62_158
	private	BB62_158
BB62_158:
	jr	BB62_159
	private	BB62_159
BB62_159:
	jr	BB62_160
	private	BB62_160
BB62_160:
	jr	BB62_161
	private	BB62_161
BB62_161:
	jr	BB62_162
	private	BB62_162
BB62_162:
	jr	BB62_163
	private	BB62_163
BB62_163:
	jr	BB62_164
	private	BB62_164
BB62_164:
	jr	BB62_165
	private	BB62_165
BB62_165:
	ld	hl, 1557
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_matches:                               ; -- Begin function matches
                                        ; @matches
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	xor	a, a
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	hl, (ix - 3)
	ld	e, (hl)
	ld	l, e
	rlc	l
	sbc	hl, hl
	ld	l, e
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB63_2
; %bb.1:
	jr	BB63_6
	private	BB63_2
BB63_2:
	ld	hl, (ix - 6)
	ld	e, (hl)
	ld	l, e
	rlc	l
	sbc	hl, hl
	ld	l, e
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB63_6
	jr	BB63_3
	private	BB63_3
BB63_3:
	ld	hl, (ix - 3)
	ld	de, (ix - 6)
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, -1
	ld	l, 0
	jr	z, BB63_5
; %bb.4:
	ld	a, l
	private	BB63_5
BB63_5:
	jr	BB63_6
	private	BB63_6
BB63_6:
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_login:                                 ; -- Begin function login
                                        ; @login
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -73
	add	hl, sp
	ld	sp, hl
	ld	de, 1
	lea	hl, ix - 70
	ld	(ix - 73), hl
	ld	hl, (_g)
	ld	bc, 230
	add	hl, bc
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	push	hl
	call	_token_valid
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 229
	add	hl, de
	ld	c, 1
	and	a, c
	ld	c, a
	ld	(hl), c
	ld	hl, (_g)
	add	hl, de
	ld	a, (hl)
	bit	0, a
	jr	z, BB64_2
	jr	BB64_1
	private	BB64_1
BB64_1:
	ld	hl, (_g)
	ld	de, 165
	add	hl, de
	push	hl
	ld	hl, _.str.132
	push	hl
	ld	hl, 70
	push	hl
	ld	hl, (ix - 73)
	push	hl
	call	_snprintf
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2602
	add	hl, de
	ld	de, (ix - 73)
	push	de
	ld	de, _.str.133
	push	de
	push	hl
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.134
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB64_3
	private	BB64_2
BB64_2:
	ld	hl, (_g)
	ld	de, 2602
	add	hl, de
	ld	de, 0
	push	de
	ld	de, _.str.135
	push	de
	push	hl
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, _.str.136
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB64_3
	private	BB64_3
BB64_3:
	ld	hl, 73
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_display_ascii:                         ; -- Begin function display_ascii
                                        ; @display_ascii
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -13
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	iyl, 0
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	hl, (ix + 12)
	ld	(ix - 9), hl
	or	a, a
	sbc	hl, hl
	ld	(ix - 12), hl
	jr	BB65_1
	private	BB65_1
BB65_1:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB65_11 Depth 2
	ld	hl, (ix - 9)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, iyl
	jp	z, BB65_3
	jr	BB65_2
	private	BB65_2
BB65_2:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	hl, (ix - 12)
	inc	hl
	ld	de, (ix - 6)
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB65_3
	private	BB65_3
BB65_3:                                 ;   in Loop: Header=BB65_1 Depth=1
	bit	0, a
	jp	z, BB65_15
	jr	BB65_4
	private	BB65_4
BB65_4:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	iy, (ix - 9)
	lea	hl, iy + 0
	inc	hl
	ld	(ix - 9), hl
	ld	a, (iy)
	ld	(ix - 13), a
	ld	a, (ix - 13)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388480
	or	a, a
	sbc	hl, de
	jr	nc, BB65_10
	jr	BB65_5
	private	BB65_5
BB65_5:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	a, (ix - 13)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388576
	or	a, a
	sbc	hl, de
	jr	c, BB65_8
	jr	BB65_6
	private	BB65_6
BB65_6:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	a, (ix - 13)
	cp	a, 127
	jr	z, BB65_8
	jr	BB65_7
	private	BB65_7
BB65_7:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	a, (ix - 13)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	c, 0
	ld	iyl, c
	jr	BB65_9
	private	BB65_8
BB65_8:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	hl, 32
	ld	c, 0
	ld	iyl, c
	jr	BB65_9
	private	BB65_9
BB65_9:                                 ;   in Loop: Header=BB65_1 Depth=1
	ld	a, l
	ld	hl, (ix - 3)
	ld	bc, (ix - 12)
	push	bc
	pop	de
	inc	de
	ld	(ix - 12), de
	add	hl, bc
	ld	(hl), a
	jr	BB65_14
	private	BB65_10
BB65_10:                                ;   in Loop: Header=BB65_1 Depth=1
	ld	hl, (ix - 3)
	ld	de, (ix - 12)
	push	de
	pop	bc
	inc	bc
	ld	(ix - 12), bc
	add	hl, de
	ld	(hl), 63
	ld	c, 0
	ld	iyl, c
	jr	BB65_11
	private	BB65_11
BB65_11:                                ;   Parent Loop BB65_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	hl, (ix - 9)
	ld	a, (hl)
	ld	l, -64
	and	a, l
	ld	l, a
	ld	a, l
	cp	a, -128
	jr	nz, BB65_13
	jr	BB65_12
	private	BB65_12
BB65_12:                                ;   in Loop: Header=BB65_11 Depth=2
	ld	hl, (ix - 9)
	inc	hl
	ld	(ix - 9), hl
	jr	BB65_11
	private	BB65_13
BB65_13:                                ;   in Loop: Header=BB65_1 Depth=1
	jr	BB65_14
	private	BB65_14
BB65_14:                                ;   in Loop: Header=BB65_1 Depth=1
	jp	BB65_1
	private	BB65_15
BB65_15:
	ld	hl, (ix - 3)
	ld	de, (ix - 12)
	add	hl, de
	ld	(hl), 0
	ld	hl, 13
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_clear_chat:                            ; -- Begin function clear_chat
                                        ; @clear_chat
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	de, 0
	ld	hl, (_g)
	ld	bc, 10862
	add	hl, bc
	ld	(hl), de
	ld	hl, (_g)
	ld	bc, 10859
	add	hl, bc
	ld	(hl), de
	ld	hl, (_g)
	ld	bc, 10184
	add	hl, bc
	ld	(hl), de
	ld	hl, (_g)
	ld	bc, 10181
	add	hl, bc
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 222
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 219
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2650
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 10865
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 223
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 2666
	add	hl, de
	ld	(hl), 0
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	pop	ix
	ret
                                        ; -- End function
_seen:                                  ; -- Begin function seen
                                        ; @seen
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -10
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	bc, 0
	ld	(ix - 4), hl
	ld	(ix - 7), bc
	jr	BB67_1
	private	BB67_1
BB67_1:                                 ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 7)
	ld	iy, (_g)
	ld	de, 10181
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
	jr	nc, BB67_6
	jr	BB67_2
	private	BB67_2
BB67_2:                                 ;   in Loop: Header=BB67_1 Depth=1
	ld	iy, (_g)
	ld	hl, (ix - 7)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5314
	add	iy, de
	ld	hl, (ix - 4)
	push	hl
	push	iy
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB67_4
	jr	BB67_3
	private	BB67_3
BB67_3:
	ld	(ix - 1), 1
	jp	BB67_15
	private	BB67_4
BB67_4:                                 ;   in Loop: Header=BB67_1 Depth=1
	jr	BB67_5
	private	BB67_5
BB67_5:                                 ;   in Loop: Header=BB67_1 Depth=1
	ld	hl, (ix - 7)
	inc	hl
	ld	(ix - 7), hl
	ld	bc, 0
	jr	BB67_1
	private	BB67_6
BB67_6:
	ld	(ix - 10), bc
	jr	BB67_7
	private	BB67_7
BB67_7:                                 ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 10)
	ld	iy, (_g)
	ld	de, 10859
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
	jr	nc, BB67_12
	jr	BB67_8
	private	BB67_8
BB67_8:                                 ;   in Loop: Header=BB67_7 Depth=1
	ld	iy, (_g)
	ld	hl, (ix - 10)
	ld	bc, 21
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 10187
	add	iy, de
	ld	hl, (ix - 4)
	push	hl
	push	iy
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB67_10
	jr	BB67_9
	private	BB67_9
BB67_9:
	ld	(ix - 1), 1
	jp	BB67_15
	private	BB67_10
BB67_10:                                ;   in Loop: Header=BB67_7 Depth=1
	jr	BB67_11
	private	BB67_11
BB67_11:                                ;   in Loop: Header=BB67_7 Depth=1
	ld	hl, (ix - 10)
	inc	hl
	ld	(ix - 10), hl
	jr	BB67_7
	private	BB67_12
BB67_12:
	ld	iy, (_g)
	ld	hl, (_g)
	ld	de, 10862
	add	hl, de
	ld	hl, (hl)
	ld	bc, 21
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 10187
	add	iy, de
	ld	hl, (ix - 4)
	push	hl
	ld	hl, 21
	push	hl
	push	iy
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 10862
	add	hl, de
	ld	hl, (hl)
	inc	hl
	ld	bc, 31
	call	__iand
	ld	iy, (_g)
	ld	de, 10862
	add	iy, de
	ld	(iy), hl
	ld	hl, (_g)
	ld	de, 10859
	add	hl, de
	ld	hl, (hl)
	ld	de, 32
	or	a, a
	sbc	hl, de
	jr	nc, BB67_14
	jr	BB67_13
	private	BB67_13
BB67_13:
	ld	hl, (_g)
	ld	de, 10859
	add	hl, de
	ld	de, (hl)
	inc	de
	ld	(hl), de
	jr	BB67_14
	private	BB67_14
BB67_14:
	ld	(ix - 1), 0
	jr	BB67_15
	private	BB67_15
BB67_15:
	ld	a, (ix - 1)
	ld	hl, 10
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_append:                                ; -- Begin function append
                                        ; @append
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -45
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	a, (ix + 12)
	lea	bc, ix - 36
	ld	(ix - 45), bc
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 7), a
	ld	hl, (ix - 3)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	(ix - 39), hl
	jr	BB68_1
	private	BB68_1
BB68_1:                                 ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 39)
	ld	de, 28
	or	a, a
	sbc	hl, de
	jr	nc, BB68_3
	jr	BB68_2
	private	BB68_2
BB68_2:                                 ;   in Loop: Header=BB68_1 Depth=1
	ld	hl, (ix - 39)
	jr	BB68_4
	private	BB68_3
BB68_3:                                 ;   in Loop: Header=BB68_1 Depth=1
	ld	hl, 28
	jr	BB68_4
	private	BB68_4
BB68_4:                                 ;   in Loop: Header=BB68_1 Depth=1
	ld	(ix - 42), hl
	ld	hl, (ix - 3)
	ld	de, (ix - 42)
	push	de
	push	hl
	ld	hl, (ix - 45)
	push	hl
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix - 42)
	ld	bc, (ix - 45)
	push	bc
	pop	hl
	add	hl, de
	ld	(hl), 0
	ld	hl, (ix - 6)
	ld	a, (ix - 7)
	ld	e, a
	push	de
	push	hl
	push	bc
	call	_add_row
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix - 42)
	ld	hl, (ix - 3)
	add	hl, de
	ld	(ix - 3), hl
	ld	de, (ix - 42)
	ld	hl, (ix - 39)
	or	a, a
	sbc	hl, de
	ld	(ix - 39), hl
	jr	BB68_5
	private	BB68_5
BB68_5:                                 ;   in Loop: Header=BB68_1 Depth=1
	ld	hl, (ix - 39)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB68_1
	jr	BB68_6
	private	BB68_6
BB68_6:
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	ld	hl, 45
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_delete_message:                        ; -- Begin function delete_message
                                        ; @delete_message
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -12
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, 0
	ld	(ix - 3), hl
	ld	(ix - 6), de
	ld	(ix - 9), de
	jr	BB69_1
	private	BB69_1
BB69_1:                                 ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 9)
	ld	iy, (_g)
	ld	de, 10181
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
	jp	nc, BB69_6
	jr	BB69_2
	private	BB69_2
BB69_2:                                 ;   in Loop: Header=BB69_1 Depth=1
	ld	iy, (_g)
	ld	hl, (ix - 9)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5314
	add	iy, de
	ld	hl, (ix - 3)
	push	hl
	push	iy
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, BB69_4
	jr	BB69_3
	private	BB69_3
BB69_3:                                 ;   in Loop: Header=BB69_1 Depth=1
	ld	iy, (_g)
	ld	hl, (ix - 6)
	push	hl
	pop	de
	inc	de
	ld	(ix - 6), de
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5285
	add	iy, de
	ld	(ix - 12), iy
	ld	iy, (_g)
	ld	hl, (ix - 9)
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5285
	add	iy, de
	ld	hl, 51
	push	hl
	push	iy
	ld	hl, (ix - 12)
	push	hl
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	jr	BB69_4
	private	BB69_4
BB69_4:                                 ;   in Loop: Header=BB69_1 Depth=1
	jr	BB69_5
	private	BB69_5
BB69_5:                                 ;   in Loop: Header=BB69_1 Depth=1
	ld	hl, (ix - 9)
	inc	hl
	ld	(ix - 9), hl
	jp	BB69_1
	private	BB69_6
BB69_6:
	ld	bc, (ix - 6)
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	(hl), bc
	ld	hl, (_g)
	ld	de, 10184
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	hl, (_g)
	ld	de, 216
	add	hl, de
	ld	(hl), 1
	ld	hl, 12
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_add_row:                               ; -- Begin function add_row
                                        ; @add_row
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -28
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	bc, (ix + 9)
	ld	a, (ix + 12)
	ld	e, 0
	ld	(ix - 3), hl
	ld	(ix - 6), bc
	ld	(ix - 7), a
	ld	hl, (_g)
	ld	bc, 10181
	add	hl, bc
	ld	hl, (hl)
	ld	(ix - 10), hl
	or	a, a
	sbc	hl, hl
	ld	(ix - 13), hl
	jr	BB70_1
	private	BB70_1
BB70_1:                                 ; =>This Inner Loop Header: Depth=1
	ld	hl, (ix - 6)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, e
	jp	z, BB70_3
	jr	BB70_2
	private	BB70_2
BB70_2:                                 ;   in Loop: Header=BB70_1 Depth=1
	ld	hl, (ix - 13)
	ld	iy, (_g)
	ld	de, 10181
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB70_3
	private	BB70_3
BB70_3:                                 ;   in Loop: Header=BB70_1 Depth=1
	bit	0, a
	jp	z, BB70_11
	jr	BB70_4
	private	BB70_4
BB70_4:                                 ;   in Loop: Header=BB70_1 Depth=1
	ld	iy, (_g)
	ld	hl, (ix - 13)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5314
	add	iy, de
	ld	(ix - 16), iy
	ld	hl, (ix - 16)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, BB70_9
	jr	BB70_5
	private	BB70_5
BB70_5:                                 ;   in Loop: Header=BB70_1 Depth=1
	ld	hl, (ix - 16)
	push	hl
	call	_strlen
	ld	(ix - 25), hl
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 6)
	push	hl
	call	_strlen
	ld	iy, 3
	add	iy, sp
	ld	sp, iy
	ld	de, (ix - 25)
	or	a, a
	sbc	hl, de
	jr	c, BB70_8
	jr	BB70_6
	private	BB70_6
BB70_6:                                 ;   in Loop: Header=BB70_1 Depth=1
	ld	hl, (ix - 16)
	push	hl
	call	_strlen
	ld	(ix - 28), hl
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 6)
	push	hl
	call	_strlen
	push	hl
	pop	de
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 28)
	or	a, a
	sbc	hl, de
	jr	nz, BB70_9
	jr	BB70_7
	private	BB70_7
BB70_7:                                 ;   in Loop: Header=BB70_1 Depth=1
	ld	hl, (ix - 16)
	ld	de, (ix - 6)
	push	de
	push	hl
	call	_strcmp
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	ld	de, -8388608
	add	hl, de
	ld	de, -8388607
	or	a, a
	sbc	hl, de
	jr	c, BB70_9
	jr	BB70_8
	private	BB70_8
BB70_8:
	ld	hl, (ix - 13)
	ld	(ix - 10), hl
	jr	BB70_11
	private	BB70_9
BB70_9:                                 ;   in Loop: Header=BB70_1 Depth=1
	ld	e, 0
	jr	BB70_10
	private	BB70_10
BB70_10:                                ;   in Loop: Header=BB70_1 Depth=1
	ld	hl, (ix - 13)
	inc	hl
	ld	(ix - 13), hl
	jp	BB70_1
	private	BB70_11
BB70_11:
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	hl, (hl)
	ld	de, 96
	or	a, a
	sbc	hl, de
	jr	nz, BB70_15
	jr	BB70_12
	private	BB70_12
BB70_12:
	ld	hl, (ix - 10)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB70_14
	jr	BB70_13
	private	BB70_13
BB70_13:
	jp	BB70_16
	private	BB70_14
BB70_14:
	ld	iy, (_g)
	ld	de, 5285
	add	iy, de
	ld	hl, (_g)
	ld	de, 5336
	add	hl, de
	ld	de, 4845
	push	de
	push	hl
	push	iy
	call	_memmove
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	de, (hl)
	dec	de
	ld	(hl), de
	ld	hl, (ix - 10)
	dec	hl
	ld	(ix - 10), hl
	jr	BB70_15
	private	BB70_15
BB70_15:
	ld	iy, (_g)
	ld	hl, (ix - 10)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5336
	add	iy, de
	ld	(ix - 22), iy
	ld	iy, (_g)
	ld	hl, (ix - 10)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5285
	add	iy, de
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	hl, (hl)
	ld	de, (ix - 10)
	or	a, a
	sbc	hl, de
	push	hl
	pop	bc
	ld	hl, 51
	call	__imulu
	push	hl
	push	iy
	ld	hl, (ix - 22)
	push	hl
	call	_memmove
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 10181
	add	hl, de
	ld	de, (hl)
	inc	de
	ld	(hl), de
	ld	iy, (_g)
	ld	hl, (ix - 10)
	ld	bc, 51
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 5285
	add	iy, de
	ld	(ix - 19), iy
	ld	hl, (ix - 19)
	ld	de, (ix - 3)
	push	de
	ld	de, 29
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	iy, (ix - 19)
	lea	hl, iy + 29
	ld	de, (ix - 6)
	push	de
	ld	de, 21
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	a, (ix - 7)
	ld	iy, (ix - 19)
	ld	(iy + 50), a
	jr	BB70_16
	private	BB70_16
BB70_16:
	ld	hl, 28
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_choose:                                ; -- Begin function choose
                                        ; @choose
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -69
	add	hl, sp
	ld	sp, hl
	ld	iy, _.str.153
	lea	de, ix - 60
	ld	hl, (_g)
	ld	bc, 218
	add	hl, bc
	ld	a, (hl)
	bit	0, a
	jr	nz, BB71_3
	jr	BB71_1
	private	BB71_1
BB71_1:
	ld	hl, (_g)
	ld	bc, 5282
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	z, BB71_3
	jr	BB71_2
	private	BB71_2
BB71_2:
	ld	hl, (_g)
	ld	bc, 5283
	add	hl, bc
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	(ix - 66), iy
	ld	(ix - 69), de
	ld	iy, (_g)
	ld	bc, 5282
	add	iy, bc
	ld	a, (iy)
	ld	iy, 0
	ld	iyl, a
	ld	bc, -8388608
	add	iy, bc
	add	hl, bc
	lea	bc, iy + 0
	or	a, a
	sbc	hl, bc
	jr	c, BB71_4
	jr	BB71_3
	private	BB71_3
BB71_3:
	jp	BB71_10
	private	BB71_4
BB71_4:
	ld	iy, (_g)
	ld	hl, (_g)
	ld	bc, 5283
	add	hl, bc
	ld	a, (hl)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, 104
	call	__imulu
	push	hl
	pop	bc
	add	iy, bc
	ld	bc, 2786
	add	iy, bc
	ld	(ix - 63), iy
	ld	hl, (_g)
	ld	bc, 2682
	add	hl, bc
	ld	bc, (ix - 63)
	push	bc
	ld	de, 21
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	hl, (_g)
	ld	de, 2703
	add	hl, de
	ld	iy, (ix - 63)
	lea	de, iy + 21
	push	de
	ld	de, 81
	push	de
	push	hl
	call	_copy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	iy, (ix - 63)
	ld	a, (iy + 102)
	ld	hl, (_g)
	ld	de, 2784
	add	hl, de
	ld	c, 1
	and	a, c
	ld	e, a
	ld	(hl), e
	ld	iy, (ix - 63)
	ld	a, (iy + 103)
	ld	hl, (_g)
	ld	de, 2785
	add	hl, de
	and	a, c
	ld	e, a
	ld	(hl), e
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	ld	de, _.str.89
	jr	z, BB71_6
; %bb.5:
	ld	de, _.str.90
	private	BB71_6
BB71_6:
	ld	hl, (ix - 63)
	push	hl
	push	de
	ld	hl, _.str.152
	push	hl
	ld	hl, 60
	push	hl
	ld	hl, (ix - 69)
	push	hl
	call	_snprintf
	ld	hl, 15
	add	hl, sp
	ld	sp, hl
	ld	iy, (_g)
	ld	de, 2634
	add	iy, de
	ld	hl, (_g)
	ld	de, 230
	add	hl, de
	ld	hl, (hl)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jr	z, BB71_8
; %bb.7:
	ld	hl, _.str.154
	ld	(ix - 66), hl
	private	BB71_8
BB71_8:
	ld	hl, (ix - 69)
	push	hl
	ld	hl, (ix - 66)
	push	hl
	push	iy
	call	_request
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	bit	0, a
	jr	z, BB71_10
	jr	BB71_9
	private	BB71_9
BB71_9:
	ld	hl, (_g)
	ld	de, 218
	add	hl, de
	ld	(hl), 1
	ld	hl, _.str.155
	push	hl
	call	_status
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	jr	BB71_10
	private	BB71_10
BB71_10:
	ld	hl, 69
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_mem_malloc:                            ; -- Begin function mem_malloc
                                        ; @mem_malloc
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (ix - 3)
	push	hl
	call	_malloc
	ld	iy, 6
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_mem_free:                              ; -- Begin function mem_free
                                        ; @mem_free
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -3
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (ix - 3)
	push	hl
	call	_free
	ld	hl, 6
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
_lwip_socket_write:                     ; -- Begin function lwip_socket_write
                                        ; @lwip_socket_write
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -9
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	bc, (ix + 9)
	ld	de, (ix + 12)
	ld	iy, _lwip_socket_write.__loc
	ld	(ix - 3), hl
	ld	(ix - 6), bc
	ld	(ix - 9), de
	jr	BB74_1
	private	BB74_1
BB74_1:
	ld	hl, (ix - 9)
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, BB74_3
	jr	BB74_2
	private	BB74_2
BB74_2:
	jr	BB74_4
	private	BB74_3
BB74_3:
	push	iy
	call	___assert_fail_loc
	ld	hl, 3
	add	hl, sp
	ld	sp, hl
	private	BB74_4
BB74_4:
	jr	BB74_5
	private	BB74_5
BB74_5:
	ld	hl, (ix - 6)
	ld	de, (ix - 9)
	push	de
	push	hl
	ld	hl, _test_tx
	push	hl
	call	_memcpy
	ld	hl, 9
	add	hl, sp
	ld	sp, hl
	ld	de, (ix - 9)
	ld	hl, _test_tx
	add	hl, de
	ld	(hl), 0
	or	a, a
	sbc	hl, hl
	ld	iy, 9
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_ti_Tell:                               ; -- Begin function ti_Tell
                                        ; @ti_Tell
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -1
	add	hl, sp
	ld	sp, hl
	ld	a, (ix + 6)
	ld	de, 0
	ld	iy, _test_appvars
	ld	(ix - 1), a
	ld	a, (ix - 1)
	or	a, a
	jr	z, BB75_3
	jr	BB75_1
	private	BB75_1
BB75_1:
	ld	a, (ix - 1)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	bc, -8388608
	add	hl, bc
	ld	bc, -8388605
	or	a, a
	sbc	hl, bc
	jr	nc, BB75_3
	jr	BB75_2
	private	BB75_2
BB75_2:
	ld	a, (ix - 1)
	or	a, a
	sbc	hl, hl
	ld	l, a
	dec	hl
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	de, 2055
	add	iy, de
	ld	hl, (iy)
	ld	de, 0
	ld	e, l
	ld	d, h
	jr	BB75_4
	private	BB75_3
BB75_3:
	jr	BB75_4
	private	BB75_4
BB75_4:
	ld	l, e
	ld	h, d
	ld	iy, 1
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_ti_Seek:                               ; -- Begin function ti_Seek
                                        ; @ti_Seek
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -16
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	a, (ix + 12)
	ld	iy, _test_appvars
	ld	bc, -1
	ld	(ix - 6), hl
	ld	(ix - 9), de
	ld	(ix - 10), a
	ld	a, (ix - 10)
	or	a, a
	jr	z, BB76_2
	jr	BB76_1
	private	BB76_1
BB76_1:
	ld	a, (ix - 10)
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	de, -8388608
	add	hl, de
	ld	de, -8388605
	or	a, a
	sbc	hl, de
	jr	c, BB76_3
	jr	BB76_2
	private	BB76_2
BB76_2:
	ld	(ix - 3), bc
	jr	BB76_10
	private	BB76_3
BB76_3:
	ld	a, (ix - 10)
	or	a, a
	sbc	hl, hl
	ld	l, a
	dec	hl
	ld	bc, 2058
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	(ix - 13), iy
	ld	hl, (ix - 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, BB76_5
	jr	BB76_4
	private	BB76_4
BB76_4:
	ld	bc, 0
	push	bc
	pop	hl
	jr	BB76_9
	private	BB76_5
BB76_5:
	ld	hl, (ix - 9)
	ld	de, 2
	or	a, a
	sbc	hl, de
	ld	bc, 0
	jr	nz, BB76_7
	jr	BB76_6
	private	BB76_6
BB76_6:
	ld	hl, (ix - 13)
	ld	de, 2051
	add	hl, de
	ld	hl, (hl)
	jr	BB76_8
	private	BB76_7
BB76_7:
	ld	hl, (ix - 13)
	ld	de, 2055
	add	hl, de
	ld	hl, (hl)
	jr	BB76_8
	private	BB76_8
BB76_8:
	jr	BB76_9
	private	BB76_9
BB76_9:
	ld	(ix - 16), hl
	ld	iy, (ix - 16)
	ld	de, (ix - 6)
	add	iy, de
	ld	hl, (ix - 13)
	ld	de, 2055
	add	hl, de
	ld	(hl), iy
	ld	(ix - 3), bc
	jr	BB76_10
	private	BB76_10
BB76_10:
	ld	hl, (ix - 3)
	ld	iy, 16
	add	iy, sp
	ld	sp, iy
	pop	ix
	ret
                                        ; -- End function
_panel:                                 ; -- Begin function panel
                                        ; @panel
; %bb.0:
	push	ix
	ld	ix, 0
	add	ix, sp
	ld	hl, -55
	add	hl, sp
	ld	sp, hl
	ld	bc, 0
	ld	iyl, 0
	lea	hl, ix - 49
	ld	(ix - 55), hl
	ld	hl, (_g)
	ld	de, 589
	add	hl, de
	ld	(ix - 3), hl
	ld	(ix - 6), bc
	ld	(ix - 9), bc
	jr	BB77_1
	private	BB77_1
BB77_1:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB77_5 Depth 2
	ld	hl, (ix - 3)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, iyl
	jp	z, BB77_3
	jr	BB77_2
	private	BB77_2
BB77_2:                                 ;   in Loop: Header=BB77_1 Depth=1
	ld	hl, (ix - 9)
	ld	de, 23
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB77_3
	private	BB77_3
BB77_3:                                 ;   in Loop: Header=BB77_1 Depth=1
	bit	0, a
	jp	z, BB77_15
	jr	BB77_4
	private	BB77_4
BB77_4:                                 ;   in Loop: Header=BB77_1 Depth=1
	or	a, a
	sbc	hl, hl
	ld	(ix - 52), hl
	jr	BB77_5
	private	BB77_5
BB77_5:                                 ;   Parent Loop BB77_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	hl, (ix - 3)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	a, iyl
	jp	z, BB77_8
	jr	BB77_6
	private	BB77_6
BB77_6:                                 ;   in Loop: Header=BB77_5 Depth=2
	ld	hl, (ix - 3)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, 10
	or	a, a
	sbc	hl, de
	ld	a, iyl
	jp	z, BB77_8
	jr	BB77_7
	private	BB77_7
BB77_7:                                 ;   in Loop: Header=BB77_5 Depth=2
	ld	hl, (ix - 52)
	ld	de, 39
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	BB77_8
	private	BB77_8
BB77_8:                                 ;   in Loop: Header=BB77_5 Depth=2
	bit	0, a
	jr	z, BB77_10
	jr	BB77_9
	private	BB77_9
BB77_9:                                 ;   in Loop: Header=BB77_5 Depth=2
	ld	iy, (ix - 3)
	lea	hl, iy + 0
	inc	hl
	ld	(ix - 3), hl
	ld	a, (iy)
	ld	iyl, 0
	ld	de, (ix - 52)
	push	de
	pop	bc
	inc	bc
	ld	(ix - 52), bc
	ld	hl, (ix - 55)
	add	hl, de
	ld	(hl), a
	jp	BB77_5
	private	BB77_10
BB77_10:                                ;   in Loop: Header=BB77_1 Depth=1
	ld	hl, (ix - 3)
	ld	a, (hl)
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	l, a
	ld	de, 10
	or	a, a
	sbc	hl, de
	jr	nz, BB77_12
	jr	BB77_11
	private	BB77_11
BB77_11:                                ;   in Loop: Header=BB77_1 Depth=1
	ld	hl, (ix - 3)
	inc	hl
	ld	(ix - 3), hl
	jr	BB77_12
	private	BB77_12
BB77_12:                                ;   in Loop: Header=BB77_1 Depth=1
	ld	de, (ix - 52)
	ld	hl, (ix - 55)
	add	hl, de
	ld	(hl), 0
	ld	hl, (ix - 6)
	push	hl
	pop	de
	inc	de
	ld	(ix - 6), de
	ld	iy, (_g)
	ld	de, 2069
	add	iy, de
	ld	de, (iy)
	or	a, a
	sbc	hl, de
	jr	c, BB77_14
	jr	BB77_13
	private	BB77_13
BB77_13:                                ;   in Loop: Header=BB77_1 Depth=1
	ld	hl, (ix - 9)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	pop	de
	ld	hl, 24
	add	hl, de
	ld	de, 39
	push	de
	ld	de, (ix - 55)
	push	de
	ld	de, 16
	push	de
	ld	de, 17
	push	de
	push	hl
	ld	hl, 2
	push	hl
	call	_text
	ld	hl, 18
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 9)
	inc	hl
	ld	(ix - 9), hl
	jr	BB77_14
	private	BB77_14
BB77_14:                                ;   in Loop: Header=BB77_1 Depth=1
	ld	iyl, 0
	jp	BB77_1
	private	BB77_15
BB77_15:
	ld	hl, 55
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
                                        ; -- End function
	.section	.bss,"aw",@nobits
	private	_g
_g:
	rb	3

	.section	.rodata,"a",@progbits
	private	_.str
_.str:
	db	"Discord "

	private	_.str.1
_.str.1:
	db	"Not enough memory "

	rb	($$ - $) and 1
	private	_palette.colors
_palette.colors:

	private	_gfx_SetPalette.__loc
_gfx_SetPalette.__loc:
	dl	_.str.2
	dd	122                             ; 0x7a
	dl	_.str.3
	dl	_.str.4

	private	_.str.2
_.str.2:
	db	"src/../tests/platform.h "

	private	_.str.3
_.str.3:
	db	"void gfx_SetPalette(const uint16_t *, size_t, unsigned int) "

	private	_.str.4
_.str.4:
	db	"n == 12 && off == 16 "

	private	_.str.5
_.str.5:
	db	"DISCRD "

	private	_.str.6
_.str.6:
	db	"r "

	private	_.str.7
_.str.7:
	db	"DSC4 "

	private	_.str.8
_.str.8:

	private	_.str.9
_.str.9:
	db	"DiscordCE "

	.section	.data,"aw",@progbits
	private	_test_appvars
_test_appvars:
	dl	_.str.5
	dl	0                               ; 0x0
	db	0                               ; 0x0
	dl	0                               ; 0x0
	dl	_.str.10
	dl	0                               ; 0x0
	db	0                               ; 0x0
	dl	0                               ; 0x0

	.section	.rodata,"a",@progbits
	private	_.str.10
_.str.10:
	db	"DISCTK "

	private	_.str.11
_.str.11:
	db	"%s "

	private	_.str.12
_.str.12:
	db	"%s:%lu x%u "

	private	_.str.13
_.str.13:
	db	"handshake.c "

	private	_.str.14
_.str.14:
	db	"Use host:port or tls://host:port "

	private	_.str.15
_.str.15:
	db	"Enter a local username/profile "

	private	_.str.16
_.str.16:
	db	"Discord relay setup "

	private	_.str.17
_.str.17:
	db	"  Server / IP / URL: "

	private	_.str.18
_.str.18:
	db	"> Server / IP / URL: "

	private	_.str.19
_.str.19:
	db	"> Username (local profile): "

	private	_.str.20
_.str.20:
	db	"  Username (local profile): "

	private	_.str.21
_.str.21:
	db	"Discord identity is verified at login. "

	private	_.str.22
_.str.22:
	db	"Port 8443 unless set in target line. "

	private	_.str.23
_.str.23:
	db	"Alpha: abc/ABC/123   X,T: shift "

	private	_.str.24
_.str.24:
	db	"Input: ABC (once) "

	private	_.str.25
_.str.25:
	db	"Input: abc "

	private	_.str.26
_.str.26:
	db	"Input: ABC "

	private	_.str.27
_.str.27:
	db	"Input: 123 "

	private	_.str.28
_.str.28:
	db	"Enter: next/connect   Clear: exit "

	private	_.str.29
_.str.29:
	db	"r+ "

	private	_.str.30
_.str.30:
	db	"w "

	private	_.str.31
_.str.31:
	db	"Could not save profile "

	private	_ti_Write.__loc
_ti_Write.__loc:
	dl	_.str.2
	dd	60                              ; 0x3c
	dl	_.str.32
	dl	_.str.33

	private	_.str.32
_.str.32:
	db	"size_t ti_Write(const void *, size_t, size_t, uint8_t) "

	private	_.str.33
_.str.33:
	db	"av->pos + n <= sizeof(av->data) "

	private	_.str.34
_.str.34:
	db	"%.*s "

	private	_.str.35
_.str.35:
	db	"Socket create failed "

	private	_.str.36
_.str.36:
	db	"Network service request failed "

	private	_.str.37
_.str.37:
	db	"Waiting for DHCP/DNS (Mode cancels) "

	private	_.str.38
_.str.38:
	db	"Network timeout "

	private	_.str.39
_.str.39:
	db	"Connecting to %.45s:%u "

	private	_.str.40
_.str.40:
	db	"Connection failed "

	private	_.str.41
_.str.41:
	db	"ping "

	private	_.str.42
_.str.42:
	db	"Relay not responding; reconnect "

	private	_.str.43
_.str.43:
	db	"No send reply; outcome unknown "

	private	_.str.44
_.str.44:
	db	"Request timed out; reconnect "

	private	_.str.45
_.str.45:
	db	"Logged out locally; connection closed "

	private	_.str.46
_.str.46:
	db	"Login expired; reconnect "

	private	_.str.47
_.str.47:
	db	"Before TLS connected "

	private	_.str.48
_.str.48:
	db	"Waiting for relay hello "

	private	_.str.49
_.str.49:
	db	"Relay session "

	private	_.str.50
_.str.50:
	db	"Net err c%u o%u r%d e%u "

	private	_.str.51
_.str.51:
	db	"Network error; no details "

	private	_.str.52
_.str.52:
	db	"TLS connected; waiting for relay "

	private	_.str.53
_.str.53:
	db	"Relay session closed "

	private	_.str.54
_.str.54:
	db	"Disconnected; reconnect from setup "

	private	_.str.55
_.str.55:
	db	"socket c%u o%u r%d e%u s%u "

	.section	.bss,"aw",@nobits
	private	_test_service_flags
_test_service_flags:
	rb	3

	private	_test_service_error
_test_service_error:
	rb	3

	private	_test_time
_test_time:
	rb	4

	.section	.data,"aw",@progbits
	private	_test_services_ready
_test_services_ready:
	db	1                               ; 0x1

	.section	.rodata,"a",@progbits
	private	_.str.56
_.str.56:
	db	"Invalid NUL in frame "

	private	_.str.57
_.str.57:
	db	"Relay frame exceeds 4096 bytes "

	private	_.str.58
_.str.58:
	db	"Invalid relay frame "

	private	_.str.59
_.str.59:
	db	"type "

	private	_.str.60
_.str.60:
	db	"id "

	private	_.str.61
_.str.61:
	db	"guild_id "

	private	_.str.62
_.str.62:
	db	"channel_id "

	private	_.str.63
_.str.63:
	db	"hello "

	private	_.str.64
_.str.64:
	db	"version "

	private	_.str.65
_.str.65:
	db	"Relay protocol mismatch "

	private	_.str.66
_.str.66:
	db	"device "

	private	_.str.67
_.str.67:
	db	"verification_uri "

	private	_.str.68
_.str.68:
	db	"user_code "

	private	_.str.69
_.str.69:
	db	"https:// "

	private	_.str.70
_.str.70:
	db	"Invalid login response "

	private	_.str.71
_.str.71:
	db	"Open on phone/computer:
%s

Enter this code:
%s

Approve login in browser.
Up/Down scroll this screen. "

	private	_.str.72
_.str.72:
	db	"Waiting for browser approval "

	private	_.str.73
_.str.73:
	db	"expires_in "

	private	_.str.74
_.str.74:
	db	"link_required "

	private	_.str.75
_.str.75:
	db	"code "

	private	_.str.76
_.str.76:
	db	"Invalid linking code "

	private	_.str.77
_.str.77:
	db	"Link your Discord account:

In a server with this bot, run
/relay_link code:%s

Then confirm the account here.
Only use a code from YOUR calc. "

	private	_.str.78
_.str.78:
	db	"Waiting for Discord link "

	private	_.str.79
_.str.79:
	db	"link_candidate "

	private	_.str.80
_.str.80:
	db	"discord_id "

	private	_.str.81
_.str.81:
	db	"Invalid linked account "

	private	_.str.82
_.str.82:
	db	"name "

	private	_.str.83
_.str.83:
	db	"Confirm YOUR Discord account:

%s
ID: %s

ENTER: link this account
CLEAR: cancel and disconnect "

	private	_.str.84
_.str.84:
	db	"Check name and account ID "

	private	_.str.85
_.str.85:
	db	"authenticated "

	private	_.str.86
_.str.86:
	db	"token "

	private	_.str.87
_.str.87:
	db	"Invalid session response "

	private	_.str.88
_.str.88:
	db	"Login confirmed; loading servers... "

	private	_.str.89
_.str.89:
	db	"guild "

	private	_.str.90
_.str.90:
	db	"channel "

	private	_.str.91
_.str.91:
	db	"Invalid channel list "

	private	_.str.92
_.str.92:
	db	"can_send "

	private	_.str.93
_.str.93:
	db	"can_history "

	private	_.str.94
_.str.94:
	db	"guilds_end "

	private	_.str.95
_.str.95:
	db	"channels_end "

	private	_.str.96
_.str.96:
	db	"next_offset "

	private	_.str.97
_.str.97:
	db	"No accessible entries; Y= reload "

	private	_.str.98
_.str.98:
	db	"Up/Down, Enter to select "

	private	_.str.99
_.str.99:
	db	"Enter sends; Y= channels "

	private	_.str.100
_.str.100:
	db	"selected_guild "

	private	_.str.101
_.str.101:
	db	"Server selection mismatch "

	private	_.str.102
_.str.102:
	db	"selected_channel "

	private	_.str.103
_.str.103:
	db	"Channel selection mismatch "

	private	_.str.104
_.str.104:
	db	"Read-only channel; Y= channels "

	private	_.str.105
_.str.105:
	db	"history_begin "

	private	_.str.106
_.str.106:
	db	"history_end "

	private	_.str.107
_.str.107:
	db	"message "

	private	_.str.108
_.str.108:
	db	"message_id "

	private	_.str.109
_.str.109:
	db	"author "

	private	_.str.110
_.str.110:
	db	"text "

	private	_.str.111
_.str.111:
	db	"<%s> %s%s "

	private	_.str.112
_.str.112:
	db	"truncated "

	private	_.str.113
_.str.113:
	db	"... "

	private	_.str.114
_.str.114:
	db	"attachments "

	private	_.str.115
_.str.115:
	db	"[attachment] "

	private	_.str.116
_.str.116:
	db	"message_deleted "

	private	_.str.117
_.str.117:
	db	"message_changed "

	private	_.str.118
_.str.118:
	db	"Message edited; refreshing... "

	private	_.str.119
_.str.119:
	db	"Edited message removed "

	private	_.str.120
_.str.120:
	db	"sent "

	private	_.str.121
_.str.121:
	db	"Sent "

	private	_.str.122
_.str.122:
	db	"reset "

	private	_.str.123
_.str.123:
	db	"Access changed; select server "

	private	_.str.124
_.str.124:
	db	"channels_changed "

	private	_.str.125
_.str.125:
	db	"logged_out "

	private	_.str.126
_.str.126:
	db	"Logged out "

	private	_.str.127
_.str.127:
	db	"error "

	private	_.str.128
_.str.128:
	db	"invalid_session "

	private	_.str.129
_.str.129:
	db	"session_expired "

	private	_.str.130
_.str.130:
	db	"authentication_required "

	private	_.str.131
_.str.131:
	db	"Session expired; reconnect "

	private	_.str.132
_.str.132:
	db	",""token"":""%s"" "

	private	_.str.133
_.str.133:
	db	"resume "

	private	_.str.134
_.str.134:
	db	"Resuming saved session... "

	private	_.str.135
_.str.135:
	db	"login "

	private	_.str.136
_.str.136:
	db	"Requesting browser login... "

	private	_.str.137
_.str.137:
	db	",""offset"":%lu "

	private	_.str.138
_.str.138:
	db	"guilds "

	private	_.str.139
_.str.139:
	db	"channels "

	private	_.str.140
_.str.140:
	db	"Loading list... "

	private	_.str.141
_.str.141:
	db	"Disconnected "

	private	_.str.142
_.str.142:
	db	"logout "

	private	_.str.143
_.str.143:
	db	"Logging out... "

	private	_.str.144
_.str.144:
	db	"Login cancelled "

	private	_.str.145
_.str.145:
	db	",""discord_id"":""%s"" "

	private	_.str.146
_.str.146:
	db	"link_confirm "

	private	_.str.147
_.str.147:
	db	"Confirming account... "

	private	_.str.148
_.str.148:
	db	"Select a writable channel "

	private	_.str.149
_.str.149:
	db	",""text"":%s "

	private	_.str.150
_.str.150:
	db	"send "

	private	_.str.151
_.str.151:
	db	"Sending... "

	private	_.str.152
_.str.152:
	db	",""%s_id"":""%s"" "

	private	_.str.153
_.str.153:
	db	"select_guild "

	private	_.str.154
_.str.154:
	db	"select_channel "

	private	_.str.155
_.str.155:
	db	"Waiting for selection... "

	private	_.str.156
_.str.156:
	db	"Out of memory "

	private	_.str.157
_.str.157:
	db	"r%lu "

	private	_.str.158
_.str.158:
	db	"{""op"":""%s"",""id"":""%s""%s}
 "

	private	_.str.159
_.str.159:
	db	"Request too long "

	private	_.str.160
_.str.160:
	db	"Connection lost; send outcome unknown "

	private	_lwip_socket_write.__loc
_lwip_socket_write.__loc:
	dl	_.str.2
	dd	88                              ; 0x58
	dl	_.str.161
	dl	_.str.162

	private	_.str.161
_.str.161:
	db	"lwip_error_t lwip_socket_write(struct lwip_socket *, const uint8_t *, size_t) "

	private	_.str.162
_.str.162:
	db	"n < sizeof(test_tx) "

	.section	.bss,"aw",@nobits
	private	_test_tx
_test_tx:
	rb	4096

	.section	.rodata,"a",@progbits
	private	_.str.163
_.str.163:
	db	"history "

	private	_.str.164
_.str.164:
	db	",""limit"":20 "

	private	_.str.165
_.str.165:
	db	"Loading history... "

	private	_.str.166
_.str.166:
	db	"w+ "

	private	_.str.167
_.str.167:
	db	"Could not save token "

	private	_.str.168
_.str.168:
	db	"Discord %.14s | %.16s "

	private	_.str.169
_.str.169:
	db	"TLS: %.31s  Traceback (newest) "

	private	_.str.170
_.str.170:
	db	"No traceback entries captured "

	private	_.str.171
_.str.171:
	db	"Servers "

	private	_.str.172
_.str.172:
	db	"Channels "

	private	_.str.173
_.str.173:
	db	"%c%.9s "

	private	_.str.174
_.str.174:
	db	"<> pages "

	private	_.str.175
_.str.175:
	db	"Choose a Discord server "

	private	_.str.176
_.str.176:
	db	"%c %s "

	private	_.str.177
_.str.177:
	db	"Up/Down: trace Enter: setup Mode: exit "

	private	_.str.178
_.str.178:
	db	"Y=:channels Window:servers Mode:back "

	.section	.bss,"aw",@nobits
	private	_test_key_pos
_test_key_pos:
	rb	3

	.section	.rodata,"a",@progbits
	private	_os_GetCSC.__loc
_os_GetCSC.__loc:
	dl	_.str.2
	dd	104                             ; 0x68
	dl	_.str.179
	dl	_.str.180

	private	_.str.179
_.str.179:
	db	"uint8_t os_GetCSC(void) "

	private	_.str.180
_.str.180:
	db	"test_key_pos < sizeof(test_keys) "

	.section	.bss,"aw",@nobits
	private	_test_keys
_test_keys:
	rb	64

	.ident	"clang version 19.1.0 (https://github.com/CE-Programming/llvm-project ef28e9c54cd1333a6091ab2ffbd315b465fc5090)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _lwip_example_stack_start
	.addrsig_sym _lwip_example_gfx_stop
	.addrsig_sym _mem_request
	.addrsig_sym _lwip_example_show_and_wait
	.addrsig_sym _lwip_example_finish
	.addrsig_sym _palette
	.addrsig_sym _load
	.addrsig_sym _lwip_set_event_cb
	.addrsig_sym _stack_event
	.addrsig_sym _setup
	.addrsig_sym _run
	.addrsig_sym _lwip_socket_destroy
	.addrsig_sym _save_token
	.addrsig_sym _clear_selection
	.addrsig_sym _render
	.addrsig_sym _lwip_service_events
	.addrsig_sym _os_GetCSC
	.addrsig_sym _mem_release
	.addrsig_sym _malloc
	.addrsig_sym _gfx_SetPalette
	.addrsig_sym _gfx_SetMonospaceFont
	.addrsig_sym _gfx_SetTextScale
	.addrsig_sym ___assert_fail_loc
	.addrsig_sym _ti_Open
	.addrsig_sym _ti_Read
	.addrsig_sym _memcmp
	.addrsig_sym _memchr
	.addrsig_sym _ti_Close
	.addrsig_sym _copy
	.addrsig_sym _load_token
	.addrsig_sym _token_valid
	.addrsig_sym _strcmp
	.addrsig_sym _snprintf
	.addrsig_sym _strlen
	.addrsig_sym _lwip_debug_file_name
	.addrsig_sym _wire_target
	.addrsig_sym _status
	.addrsig_sym _save
	.addrsig_sym _input_char
	.addrsig_sym _gfx_FillScreen
	.addrsig_sym _fill
	.addrsig_sym _text
	.addrsig_sym _gfx_BlitBuffer
	.addrsig_sym _vsnprintf
	.addrsig_sym _ti_Rewind
	.addrsig_sym _ti_Write
	.addrsig_sym _ti_SetArchiveStatus
	.addrsig_sym _key_to_char
	.addrsig_sym _gfx_SetColor
	.addrsig_sym _gfx_FillRectangle
	.addrsig_sym _gfx_SetTextFGColor
	.addrsig_sym _gfx_SetTextBGColor
	.addrsig_sym _gfx_PrintStringXY
	.addrsig_sym _lwip_socket_create
	.addrsig_sym _fail
	.addrsig_sym _lwip_socket_on_event
	.addrsig_sym _event
	.addrsig_sym _lwip_netif_request_services
	.addrsig_sym _lwip_now_ms
	.addrsig_sym _lwip_are_services_ready
	.addrsig_sym _lwip_socket_connect
	.addrsig_sym _lwip_socket_available
	.addrsig_sym _lwip_socket_read
	.addrsig_sym _feed
	.addrsig_sym _list_page
	.addrsig_sym _handle_key
	.addrsig_sym _request
	.addrsig_sym _history
	.addrsig_sym _capture_traceback
	.addrsig_sym _lwip_get_traceback
	.addrsig_sym _received
	.addrsig_sym _wire_parse
	.addrsig_sym _wire_string
	.addrsig_sym _matches
	.addrsig_sym _wire_uint
	.addrsig_sym _login
	.addrsig_sym _strncmp
	.addrsig_sym _wire_id
	.addrsig_sym _display_ascii
	.addrsig_sym _wire_bool
	.addrsig_sym _clear_chat
	.addrsig_sym _seen
	.addrsig_sym _append
	.addrsig_sym _delete_message
	.addrsig_sym _add_row
	.addrsig_sym _choose
	.addrsig_sym _wire_quote
	.addrsig_sym _mem_malloc
	.addrsig_sym _mem_free
	.addrsig_sym _lwip_socket_write
	.addrsig_sym _free
	.addrsig_sym _ti_Tell
	.addrsig_sym _ti_Seek
	.addrsig_sym _panel
	.addrsig_sym _g
	.addrsig_sym _palette.colors
	.addrsig_sym _gfx_SetPalette.__loc
	.addrsig_sym _test_appvars
	.addrsig_sym _ti_Write.__loc
	.addrsig_sym _test_service_flags
	.addrsig_sym _test_service_error
	.addrsig_sym _test_time
	.addrsig_sym _test_services_ready
	.addrsig_sym _lwip_socket_write.__loc
	.addrsig_sym _test_tx
	.addrsig_sym _test_key_pos
	.addrsig_sym _os_GetCSC.__loc
	.addrsig_sym _test_keys
	extern	_llvm.memmove.p0.p0.i24
	extern	__Unwind_SjLj_Unregister
	extern	_memset
	extern	__land
	extern	__lsub
	extern	__llshru
	extern	_vsnprintf
	extern	__lcmpzero
	extern	_malloc
	extern	_memchr
	extern	_llvm.va_start.p0
	extern	_snprintf
	extern	_wire_string
	extern	__ladd
	extern	__irems
	extern	_llvm.eh.sjlj.lsda
	extern	_free
	extern	_memmove
	extern	__iand
	extern	_llvm.stacksave.p0
	extern	_memcmp
	extern	__lshru
	extern	_wire_bool
	extern	___assert_fail_loc
	extern	_wire_target
	extern	_memcpy
	extern	__llmulu
	extern	_wire_uint
	extern	_llvm.eh.sjlj.functioncontext
	extern	_llvm.memset.p0.i24
	extern	_llvm.memcpy.p0.p0.i24
	extern	_llvm.eh.sjlj.setup.dispatch
	extern	_llvm.frameaddress.p0
	extern	_llvm.stackrestore.p0
	extern	__lcmpu
	extern	_llvm.va_end.p0
	extern	_strcmp
	extern	_wire_parse
	extern	_strlen
	extern	__imulu
	extern	_llvm.eh.sjlj.callsite
	extern	_wire_quote
	extern	_strncmp
	extern	__Unwind_SjLj_Register
	extern	_wire_id
