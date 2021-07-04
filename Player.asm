; ==================
; Player RAM defines
; ==================

section	"Player RAM",wram0
PlayerRAM:

Player_ScreenID:		db	; which subscreen the player is currently on
Player_XPos:			db	; current X position
Player_YPos:			db	; current Y position
Player_SubpixelXY:		db	; upper nybble = X subpixel, lower nybble = Y subpixel
Player_CurrentAnim:		db	; current animation
Player_AnimTimer:		db	; time until next animation frame is displayed
Player_CurrentFrame:	db	; current animation frame being displayed
Player_Flags:			db

PlayerRAM_End:

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
	; load player palette
	ldfar	hl,Pal_Player
	ld		a,8
	call	LoadPal	
	; TODO
	ret
	
ProcessPlayer:
	; TODO
	ret
	
DrawPlayer:
	; TODO
	ret