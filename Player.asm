; ==================
; Player RAM defines
; ==================

section	"Player RAM",wram0
PlayerRAM:

Player_ScreenID:		db	; which subscreen the player is currently on
Player_XPos:			db	; current X position
Player_YPos:			db	; current Y position
Player_SubpixelXY:		db	; upper nybble = X subpixel, lower nybble = Y subpixel
Player_AnimPointer:		dw	; pointer to current animation sequence
Player_AnimTimer:		db	; time until next animation frame is displayed (if -1, frame will be displayed indefinitely)
Player_CurrentFrame:	db	; current animation frame being displayed

PlayerRAM_End:

Player_MoveSpeed		equ	2

; ========================
; Player animation defines
; ========================

F_Player_Idle			equ	0
F_Player_Idle_Blink1	equ	1
F_Player_Idle_Blink2	equ	2
F_Player_Idle_Blink3	equ	3
F_Player_Idle_Blink4	equ	4

F_Player_Left1			equ	8
F_Player_Left1_Blink1	equ	9
F_Player_Left1_Blink2	equ	10
F_Player_Left1_Blink3	equ	11
F_Player_Left1_Blink4	equ	12

F_Player_Left2			equ	16
F_Player_Left2_Blink1	equ	17
F_Player_Left2_Blink2	equ	18
F_Player_Left2_Blink3	equ	19
F_Player_Left2_Blink4	equ	20

F_Player_Right1			equ	24
F_Player_Right1_Blink1	equ	25
F_Player_Right1_Blink2	equ	26
F_Player_Right1_Blink3	equ	27
F_Player_Right1_Blink4	equ	28

F_Player_Right2			equ	32
F_Player_Right2_Blink1	equ	33
F_Player_Right2_Blink2	equ	34
F_Player_Right2_Blink3	equ	35
F_Player_Right2_Blink4	equ	36

F_Player_Win			equ	5
F_Player_Hurt1			equ	6
F_Player_Hurt2			equ	7
F_Player_Angry			equ	13
F_Player_Sad			equ	14
F_Player_Surprise		equ	15
F_Player_LookUp			equ	21
F_Player_LookDown		equ	22

; ===============
; Player routines
; ===============

section "Player routines",rom0

InitPlayer:
	; init RAM
	ld		hl,PlayerRAM
	ld		b,PlayerRAM_End-PlayerRAM
	xor		a
	call	_FillRAMSmall
	; initialize animation pointer
	ld		a,low(Anim_Player_Idle)
	ld		[Player_AnimPointer],a
	ld		a,high(Anim_Player_Idle)
	ld		[Player_AnimPointer+1],a
	; load player palette
	ldfar	hl,Pal_Player
	ld		a,8
	call	LoadPal	
	; TODO
	ret
	
ProcessPlayer:
	; TODO
	
	call	AnimatePlayer
	ret
	
DrawPlayer:
	; load correct frame in player VRAM area
	ld		a,[Player_CurrentFrame]
	add		a
	add		a
	ld		l,a
	ld		h,0
	add		hl,hl	; x2
	add		hl,hl	; x4
	add		hl,hl	; x8
	add		hl,hl	; x16
	ldfar	de,PlayerTiles
	add		hl,de
	ld		b,$40
	ld		de,$8000
	ld		a,1
	ldh		[rVBK],a
.loadtiles
	ldh		a,[rSTAT]
	and		2
	jr		nz,.loadtiles
	ld		a,[hl+]
	ld		[de],a
	inc		e
	dec		b
	jr		nz,.loadtiles
	xor		a
	ldh		[rVBK],a

	ld		hl,OAMBuffer
	ld		a,[Engine_CameraY]
	ld		e,a
	ld		a,[Player_YPos]
	sub		e
	add		8
	ld		b,a
	ld		[hl+],a
	ld		a,[Engine_CameraX]
	ld		e,a
	ld		a,[Player_XPos]
	sub		e
	ld		c,a
	ld		[hl+],a
	xor		a
	ld		[hl+],a
	ld		a,%00001000
	ld		[hl+],a
	ld		a,b
	ld		[hl+],a
	ld		a,c
	add		8
	ld		[hl+],a
	ld		a,2
	ld		[hl+],a
	ld		a,%00001000
	ld		[hl],a
	
	ret

; ===================
; Animation constants
; ===================

C_SetAnim	equ	$80

; ================
; Animation macros
; ================

NUM_ANIMS	set	0	; no touchy!

defanim:		macro
AnimID_\1		equ	NUM_ANIMS
NUM_ANIMS		set	NUM_ANIMS+1
Anim_\1:
	endm

; ==================
; Animation routines
; ==================

Player_SetAnimation:
	ld		a,l
	ld		[Player_AnimPointer],a
	ld		a,h
	ld		[Player_AnimPointer+1],a
	ld		a,1
	ld		[Player_AnimTimer],a
	ret

AnimatePlayer:
	ld		a,[Player_AnimTimer]
	cp		-1
	ret		z	; return if current frame time = -1
	dec		a
	ld		[Player_AnimTimer],a
	ret		nz	; return if anim timer > 0

	; get anim pointer
	ld		a,[Player_AnimPointer]
	ld		l,a
	ld		a,[Player_AnimPointer+1]
	ld		h,a
	
	; get frame / command number
.getEntry
	ld		a,[hl+]
	bit		7,a
	jr		nz,.cmdProc
	ld		[Player_CurrentFrame],a
	ld		a,[hl+]
	ld		[Player_AnimTimer],a
.doneEntry
	ld		a,l
	ld		[Player_AnimPointer],a
	ld		a,h
	ld		[Player_AnimPointer+1],a
	ret
	
.cmdProc
	push	hl
	ld		hl,.cmdProcTable
	add		a
	add		l
	ld		l,a
	jr		nc,.nocarry
	inc		h
.nocarry
	ld		a,[hl+]
	ld		h,[hl]
	ld		l,a
	jp		hl
	
.cmdProcTable:
	dw		.setAnim
	
.setAnim
	pop		hl
	ld		a,[hl+]
	ld		h,[hl]
	ld		l,a
	jr		.getEntry

; ==============
; Animation data
; ==============

; Animation format:
; XX YY
; XX = Frame ID / command (if bit 7 set)
; YY = Wait time / command parameter

	defanim	Player_Left2
	db		F_Player_Left2,-1
	
	defanim	Player_Left1
	db		F_Player_Left1,-1

	defanim	Player_Idle
	db		F_Player_Idle,-1

	defanim	Player_Right1
	db		F_Player_Right1,-1
	
	defanim	Player_Right2
	db		F_Player_Right2,-1
	
	defanim	Player_Left2Blink
	db		F_Player_Left2_Blink1,1
	db		F_Player_Left2_Blink2,1
	db		F_Player_Left2_Blink3,1
	db		F_Player_Left2_Blink4,4
	db		F_Player_Left2_Blink3,1
	db		F_Player_Left2_Blink2,1
	db		F_Player_Left2_Blink1,1
	dbw		C_SetAnim,Anim_Player_Left2
	
	defanim	Player_Left1Blink
	db		F_Player_Left1_Blink1,1
	db		F_Player_Left1_Blink2,1
	db		F_Player_Left1_Blink3,1
	db		F_Player_Left1_Blink4,4
	db		F_Player_Left1_Blink3,1
	db		F_Player_Left1_Blink2,1
	db		F_Player_Left1_Blink1,1
	dbw		C_SetAnim,Anim_Player_Left1
	
	defanim	Player_IdleBlink
	db		F_Player_Idle_Blink1,1
	db		F_Player_Idle_Blink2,1
	db		F_Player_Idle_Blink3,1
	db		F_Player_Idle_Blink4,4
	db		F_Player_Idle_Blink3,1
	db		F_Player_Idle_Blink2,1
	db		F_Player_Idle_Blink1,1
	dbw		C_SetAnim,Anim_Player_Idle
	
	defanim	Player_Right1Blink
	db		F_Player_Right1_Blink1,1
	db		F_Player_Right1_Blink2,1
	db		F_Player_Right1_Blink3,1
	db		F_Player_Right1_Blink4,4
	db		F_Player_Right1_Blink3,1
	db		F_Player_Right1_Blink2,1
	db		F_Player_Right1_Blink1,1
	dbw		C_SetAnim,Anim_Player_Right1
	
	defanim	Player_Right2Blink
	db		F_Player_Right2_Blink1,1
	db		F_Player_Right2_Blink2,1
	db		F_Player_Right2_Blink3,1
	db		F_Player_Right2_Blink4,4
	db		F_Player_Right2_Blink3,1
	db		F_Player_Right2_Blink2,1
	db		F_Player_Right2_Blink1,1
	dbw		C_SetAnim,Anim_Player_Right2
	
	defanim	Player_Hurt
	db		F_Player_Hurt1,6
	db		F_Player_Hurt2,6
	dbw		C_SetAnim,Anim_Player_Hurt
	
	defanim	Player_SMH
	db		F_Player_Left1,2
	db		F_Player_Left2,2
	db		F_Player_Left1,2
	db		F_Player_Idle,2
	db		F_Player_Right1,2
	db		F_Player_Right2,2
	db		F_Player_Right1,2
	db		F_Player_Idle,2
	db		F_Player_Left1,2
	db		F_Player_Left2,2
	db		F_Player_Left1,2
	db		F_Player_Idle,2
	db		F_Player_Right1,2
	db		F_Player_Right2,2
	db		F_Player_Right1,2
	db		F_Player_Idle,2
	db		F_Player_Left1,2
	db		F_Player_Left2,2
	db		F_Player_Left1,2
	db		F_Player_Idle,2
	db		F_Player_Right1,2
	db		F_Player_Right2,2
	db		F_Player_Right1,2
	dbw		C_SetAnim,Anim_Player_Idle