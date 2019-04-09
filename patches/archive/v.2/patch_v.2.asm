hirom
;incbin "rf.sfc"
;!bank = $000000



; To do
; Reset CDs upon loading a stage
LDA #$00
REP #$20
STA $206044
STA $206046
STA $206048
STA $20604A
STA $20604C
STA $20604E
STA $20605C
STA $20605E
STA $206060
STA $206062
SEP #$20


!base = $C00000
org $C0ffd8
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

org $C



org $C48000 ; free space
InStageHook:

; PHA ; store a


REP #$20
LDA $00A1 ; store controller input into az



; restore hp to max upon 
CMP #$A040 ; check select, x, b
BEQ RestoreHPWP

CMP #$E000 ; check select, y, b
SEP #$20
BNE Continue1
JML Load_Stage

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



Continue1:
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

; always set sram to zero for CD values



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



org $C49800 ; free space

; Intro
dd $00000000
dd $00000000	
dd $00001000	
dd $00000000

; Dynamo
dd $009C0000	
dd $9C9C9C00	
dd $4010A000	
dd $00000040
; Cold
dd $00000000	
dd $00000000	
dd $00100000	
dd $00000000
; Ground
dd $009C9C00	
dd $9C9C9C00	
dd $4010A000	
dd $00000040
; Tengu
dd $9C9C9C00	
dd $9C9C9C00	
dd $4010A000	
dd $00000040
; Astro
dd $009C0000	
dd $9C9C0000	
dd $4010A000	
dd $00000000
; Pirate
dd $009C0000	
dd $9C000000	
dd $00100000	
dd $00000000
; Burner
dd $009C0000	
dd $00000000	
dd $00100000	
dd $00000000
; Magic
dd $9C9C9C00	
dd $9C9C9C9C	
dd $4010A000	
dd $00000040
; Weapon
dd $00000000	
dd $00000000	
dd $00100000	
dd $00000000
; King 1
dd $9C9C9C00	
dd $9C9C9C9C	
dd $4810A29C	
dd $00000040
; King 2
dd $9C9C9C00	
dd $9C9C9C9C	
dd $4810A29C	
dd $00000040
; King 3
dd $9C9C9C00	
dd $9C9C9C9C	
dd $4810A29C	
dd $00000040