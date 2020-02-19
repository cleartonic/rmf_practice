hirom

incsrc defines.asm
incsrc data.asm
incsrc timer.asm
incsrc timer_text.asm

org $C0FFD8
dw $07 ; set sram to 128kb, the max

; Hooks
org $c00014
JSL TimerFunction
nop


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




; PHA ; store a

REP #$20
LDA $00A1 ; store controller input into a

; check for rng change trigger
CMP #$0050 ; check select, l, r
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
LDX #$64
SRAMLoop:
DEX
STA $206000, x
BNE SRAMLoop


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
JMP GameModeSwitchReturn

GameModeNotStageSelect:

!stagesclearedstart = $7E0B82
!itemslot1 = $7e0b97
!itemslot2 = $7e0b98
!itemslot3 = $7e0b99

; Condition for any other mode stage select met


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

; Load mode and switch for ROCKMAN or FORTE
LDA !mode
BEQ LoadRockmanWeapons ; #$00
BNE LoadForteWeapons ; #$01

LoadRockmanWeapons:   
	; Load Dynamo
	LDA $C49801, X
	STA $7e0b84
	INX
	; Load Cold
	LDA $C49801, X
	STA $7e0b8C
	INX	
	; Load Ground
	LDA $C49801, X
	STA $7e0b82
	INX		
	; Load Tengu
	LDA $C49801, X
	STA $7e0b8E
	INX		
	; Load Astro
	LDA $C49801, X
	STA $7e0b90
	INX		
	; Load Pirate
	LDA $C49801, X
	STA $7e0b86
	INX		
	; Load Burner
	LDA $C49801, X
	STA $7e0b88
	INX		
	; Load Magic
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
    BRA WeaponsReady
    
LoadForteWeapons:   
	; Load Ground
	LDA $C49901, X
	STA $7e0b82
	INX		
	; Load Dynamo
	LDA $C49901, X
	STA $7e0b84
	INX
	; Load Pirate
	LDA $C49901, X
	STA $7e0b86
	INX		
	; Load Burner
	LDA $C49901, X
	STA $7e0b88
	INX		
	; Load Magic
	LDA $C49901, X
	STA $7e0b8A
	INX		
	; Load Cold
	LDA $C49901, X
	STA $7e0b8C
	INX	
	; Load Tengu
	LDA $C49901, X
	STA $7e0b8E
	INX		
	; Load Astro
	LDA $C49901, X
	STA $7e0b90
	INX		


	; Load ITEM_SLOT1
	LDA $C49901, X
	STA $7E0b97
	INX
	; Load ITEM_SLOT2
	LDA $C49901, X
	STA $7E0b98
	INX
	; Load ITEM_SLOT3
	LDA $C49901, X
	STA $7E0b99
	INX
	; Load COUNTERATTACKER_ACTIVE
	LDA $C49901, X
	STA $7E0B9A
	INX
    
WeaponsReady:
      

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




; char select to map
org $c05ba8
JML $C48100

org $C48100
pha
LDA #$0A ; Game mode: stage select 
STA $00E0 ; Game mode
LDA #$00 ; Value of 00 here means to not trigger loading the stage immediately
STA $00E1 ; Game mode

; original code
pla
ldx $0b76
lda $8a43,x
tay
JML $c05baf


org $c05bb2
lda #$00