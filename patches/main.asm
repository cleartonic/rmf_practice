hirom

incsrc defines.asm
incsrc data.asm
incsrc timer.asm
incsrc timer_text.asm

org $C0FFD8
dw $07 ; set sram to 128kb, the max

; Hooks
org $C1107E
JSL InStageHook
nop

org $C04A5D
JSL GameModeSwitchHook
nop
nop
nop
nop



org $C48000 ; free space
InStageHook:

JSL TimerFunction



; PHA ; store a

REP #$20
LDA $00A1 ; store controller input into a

; check for rng change trigger
CMP #$2030 ; check select, l, r
BEQ ChangeRNG

; check for max hp/wp trigger
CMP #$A040 ; check select, x, b
BEQ RestoreHPWP

; check for stage load trigger
CMP #$E000 ; check select, y, b
SEP #$20
BNE ExitMainHook
JML Load_Stage

ChangeRNG:
LDA #$0001
ADC $FB
STA $FB
SEP #$20
JMP ExitMainHook


; Restore HP/WP will happen here, then continue on 
RestoreHPWP:
; set HP to 28
SEP #$20
LDA #$1C
STA $0C2F

; set all weapons to 28. A still has #$1C, which is 28, max weapon

TSB $0b82
TSB $0b84
TSB $0b86
TSB $0b88
TSB $0b8A
TSB $0b8C
TSB $0b8E
TSB $0b90



ExitMainHook:
; PLA
ldy #$0004 ;previous instructions at C1107E
LDA $2a,x ;previous instructions at C1107E
RTL

Load_Stage:
; SEP #$30
LDA #$0A ; Game mode: stage select 
STA $00E0 ; Game mode
LDA #$00 ; Value of 00 here means to not trigger loading the stage immediately
STA $00E1 ; Game mode
; REP #$30

; PLA
ldy #$0004 ;previous instructions at C1107E
LDA $2a,x ;previous instructions at C1107E
RTL












org $C49000 ; free space

GameModeSwitchHook:



; load and branch on game mode value
PHA


; write data for tileset numbers to VRAM
; Start FBDFC0
; End   FBE080
; Delta C0, 60 for index (half of C0)

PHX
PHY

LDX #$00

; use onscreem_timer1 for temp variable
lda #$00
sta !onscreen_timer1 

TilesetLoop:

; digit4
; vram address
rep #$20
clc
txa
lsr
sta !onscreen_timer1 
asl
tax
LDA #$0180 ; VRAM address 0300. Just multiply LDA address by 2 for VRAM address
ADC !onscreen_timer1 
STA $2116 
; data to load
; sep #$20
LDA $FBDFC0, X

; rep #$20
STA $2118


INX
INX
CPX #$C0
BNE TilesetLoop

TilesetLoopFinish:
sep #$20

PLY
PLX


; clear out timer vals
lda #$00
sta !onscreen_timer1 
sta !onscreen_timer2 
sta !onscreen_timer3 
sta !onscreen_timer4
sta !onscreen_flash_timer1 
sta !onscreen_flash_timer2 
sta !onscreen_flash_timer3 
sta !onscreen_flash_timer4
sta !room_flash_timer
sta !room_flash_control




; Reset CDs upon loading a stage
LDA #$00

; this could be made much more efficient with [STA, x] loop
STA $206000
STA $206001
STA $206002
STA $206003
STA $206004
STA $206005
STA $206006
STA $206007
STA $206008
STA $206009
STA $20600a
STA $20600b
STA $20600c
STA $20600d
STA $20600e
STA $20600f
STA $206010
STA $206011
STA $206012
STA $206013
STA $206014
STA $206015
STA $206016
STA $206017
STA $206018
STA $206019
STA $20601a
STA $20601b
STA $20601c
STA $20601d
STA $20601e
STA $20601f
STA $206020
STA $206021
STA $206022
STA $206023
STA $206024
STA $206025
STA $206026
STA $206027
STA $206028
STA $206029
STA $20602a
STA $20602b
STA $20602c
STA $20602d
STA $20602e
STA $20602f
STA $206030
STA $206031
STA $206032
STA $206033
STA $206034
STA $206035
STA $206036
STA $206037
STA $206038
STA $206039
STA $20603a
STA $20603b
STA $20603c
STA $20603d
STA $20603e
STA $20603f
STA $206040
STA $206041
STA $206042
STA $206043
STA $206044
STA $206045
STA $206046
STA $206047
STA $206048
STA $206049
STA $20604A
STA $20604B
STA $20604C
STA $20604D
STA $20604E
STA $20604F
STA $206050
STA $206051
STA $206052
STA $206053
STA $206054
STA $206055
STA $206056
STA $206057
STA $206058
STA $206059
STA $20605a
STA $20605b
STA $20605C
STA $20605D
STA $20605E
STA $20605F
STA $206060
STA $206061
STA $206062
STA $206063

LDA $00E0
CMP #$0A ; compare to stage select
BNE GameModeNotStageSelect ; if anything else, branch & return
nop
nop

; Condition for stage select met
; Set flags for complete stages for stage select

; Check input for King Stage switcher. Kinda lazy? Isn't really checking if King stage is selected
LDA $00A1 ; store controller input into az
CMP #$20 ; check L press
BEQ SetKing2
CMP #$10 ; check R press
BEQ SetKing3
BRA GameModeContinue ; if none are met, go here immediately

SetKing2:
LDA #$0B
STA $7E0B73
BRA GameModeContinue

SetKing3:
LDA #$0C
STA $7E0B73
BRA GameModeContinue

GameModeContinue:
LDA #$9C ; set all stages complete
STA $0B82
STA $0B84
STA $0B86
STA $0B88
STA $0B8A
STA $0B8C
STA $0B8E
STA $0B90
LDA #$FF ; set complete 8 weapons stage
STA $0B79
BRA GameModeSwitchReturn

GameModeNotStageSelect:

!stagesclearedstart = $7E0B82
!itemslot1 = $7e0b97
!itemslot2 = $7e0b98
!itemslot3 = $7e0b99

; Condition for any other mode stage select met


; ; Store X & Y
; PHX 
; PHY


; Load stage ID, which will offset the data table at C49800 for weapon/stage loadout
LDA $0B73
ASL
ASL
ASL
ASL ; bit shift left, which will be the offset for each stage. E.g., Dynamo man, stage id 01, bitshift to 10, then load in $C49810
STA $7E2400 ; push this offset to address $7E2400. OFFSET1
; ADC #$07 ; add how many stages to be loaded for first loop

TAX ; transfer to X

; A = offset id for loading data
; X = current position on loading table (where data is being loaded from)
; Y = current position on current stage/inventory loadout (where data is being overwritten)
; #C49801 is the starting location for stage ids. Offset by ____X_ bit by stage ID

; load in stage cleared ids

; UPDATE
; Because CAPCOM decided to use a completely different indexing system for stage IDs compared to stage COMPLETE IDs, we can't use any relative addressing past what we put into ROM. So... hardcode each entry. Thanks.

;LDY #$0E
   
	; Load Dynamo stage
	LDA $C49801, X
	STA $7e0b84
	INX
	; Load Cold stage
	LDA $C49801, X
	STA $7e0b8C
	INX	
	; Load Ground stage
	LDA $C49801, X
	STA $7e0b82
	INX		
	; Load Tengu stage
	LDA $C49801, X
	STA $7e0b8E
	INX		
	; Load Astro stage
	LDA $C49801, X
	STA $7e0b90
	INX		
	; Load Pirate stage
	LDA $C49801, X
	STA $7e0b86
	INX		
	; Load Burner stage
	LDA $C49801, X
	STA $7e0b88
	INX		
	; Load Magic stage
	LDA $C49801, X
	STA $7e0b8A
	INX		

	; Load ITEM_SLOT1
	LDA $C49801, X
	STA $7E0b97
	INX
	; Load ITEM_SLOT2
	LDA $C49801, X
	STA $7E0b98
	INX
	; Load ITEM_SLOT3
	LDA $C49801, X
	STA $7E0b99
	INX
	; Load COUNTERATTACKER_ACTIVE
	LDA $C49801, X
	STA $7E0B9A
	INX
      
   
   ; BEQ .ret
; .loop 
	; LDA $C49801, X
	; PHX
	; TYX
	; STA !stagesclearedstart, X
	; DEX
	; DEX
	; TXY
	; PLX
	; DEX
	
	; ; Check if X has hit the original offset, saved at OFFSET1
	; TXA
	; CMP $7E2400
	; BNE .loop
; .ret



; ; Restore X & Y
; PLX
; PLY

BRA GameModeSwitchReturn





; original instructions at C04A5D & return
GameModeSwitchReturn:
PLA
TAY			
lda $865D,y
TAY
LDA $866D,y
RTL




org $C05749
JML ScreenTransitionHook

org $C48400



; here we clear out the timer, but also flash the room time for 120f
ScreenTransitionHook:


; set up flash timer if control is not set, then set control
LDA !room_flash_control
BNE SkipFlashControl
lda !onscreen_timer4
sta !onscreen_flash_timer4
lda !onscreen_timer3
sta !onscreen_flash_timer3
lda !onscreen_timer2
sta !onscreen_flash_timer2
lda !onscreen_timer1
sta !onscreen_flash_timer1
LDA #$01
STA !room_flash_control
LDA #$78 ; 120 frames
STA !room_flash_timer

SkipFlashControl: 
sep #$20

lda #$00
sta !onscreen_timer4
sta !onscreen_timer3
sta !onscreen_timer2
sta !onscreen_timer1

; original code
REP #$30
LDA $98
AND #$00FF
JML $C05750
