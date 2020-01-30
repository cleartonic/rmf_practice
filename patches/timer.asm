hirom
; timer function
; 8 bit start for math
org $C48200
TimerFunction:

sep #$20
; check first digit and increase next. repeat pattern for all 4 digits
lda !onscreen_timer1
cmp #$09
bne IncreaseDigit1

; if it's 9, set it to zero, then move on to next digit
lda #$00
sta !onscreen_timer1
JMP TimerFunctionDigit2

IncreaseDigit1:
clc
lda #$01
adc !onscreen_timer1
sta !onscreen_timer1
JMP FinishMainTimer





TimerFunctionDigit2:
lda !onscreen_timer2
cmp #$09
bne IncreaseDigit2

; if it's 9, set it to zero, then move on to next digit
lda #$00
sta !onscreen_timer2
JMP TimerFunctionDigit3

IncreaseDigit2:
clc
lda #$01
adc !onscreen_timer2
sta !onscreen_timer2
JMP FinishMainTimer




TimerFunctionDigit3:
lda !onscreen_timer3
cmp #$09
bne IncreaseDigit3

; if it's 9, set it to zero, then move on to next digit
lda #$00
sta !onscreen_timer3
JMP TimerFunctionDigit4

IncreaseDigit3:
clc
lda #$01
adc !onscreen_timer3
sta !onscreen_timer3
JMP FinishMainTimer




TimerFunctionDigit4:
lda !onscreen_timer4
cmp #$09
bne IncreaseDigit4

; if it's 9, set it to zero, then move on to next digit
lda #$00
sta !onscreen_timer4
JMP FinishMainTimer ; out of digits, so stop increasing

IncreaseDigit4:
clc
lda #$01
adc !onscreen_timer4
sta !onscreen_timer4
JMP FinishMainTimer




FinishMainTimer:
; every loaded onscreen_timer needs #$30 added to it 


;;;;;;;;;;;;;;;; commenting out main timer for now

    ; ; digit4
    ; ; vram address
    ; rep #$20
    ; LDA #$0B5F ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
    ; STA $2116 
    ; ; data to load
    ; sep #$20
    ; LDA #$24
    ; XBA
    ; LDA #$30
    ; ADC !onscreen_timer1

    ; rep #$20
    ; STA $2118



    ; ; digit3
    ; ; vram address
    ; rep #$20
    ; LDA #$0B5E ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
    ; STA $2116 
    ; ; data to load
    ; sep #$20
    ; LDA #$24
    ; XBA
    ; LDA #$30
    ; ADC !onscreen_timer2

    ; rep #$20
    ; STA $2118



    ; ; digit4
    ; ; vram address
    ; rep #$20
    ; LDA #$0B5D ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
    ; STA $2116 
    ; ; data to load
    ; sep #$20
    ; LDA #$24
    ; XBA
    ; LDA #$30
    ; ADC !onscreen_timer3

    ; rep #$20
    ; STA $2118



    ; ; digit4
    ; ; vram address
    ; rep #$20
    ; LDA #$0B5C ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
    ; STA $2116 
    ; ; data to load
    ; sep #$20
    ; LDA #$24
    ; XBA
    ; LDA #$30
    ; ADC !onscreen_timer4

    ; rep #$20
    ; STA $2118


; now that the main timer is done, deal with the flash timer 

; first check if the control is set to #$01

sep #$20
LDA !room_flash_control
BNE FlashControlProcess
JMP FinishTimerFull
; if its not equal to 0, i.e. #$01, then check timer 

FlashControlProcess:

LDA !room_flash_timer
CMP #$01
BNE FlashTimerProcess ;if not at the final second, then keep posting it to the screen

; if equal, then undo control 
LDA #$00
STA !room_flash_control ; this should stop the loop from writing at all
STA !room_flash_timer
                        
; now clear out the vram  
              
; digit4
; vram address
rep #$20
LDA #$0B7F ; VRAM address 16c8. Just multiply LDA address by 2 for VRAM address
STA $2116 
LDA #$0000
STA $2118
LDA #$0B7E ; VRAM address 16c8. Just multiply LDA address by 2 for VRAM address
STA $2116 
LDA #$0000
STA $2118
LDA #$0B7D ; VRAM address 16c8. Just multiply LDA address by 2 for VRAM address
STA $2116 
LDA #$0000
STA $2118
LDA #$0B7C ; VRAM address 16c8. Just multiply LDA address by 2 for VRAM address
STA $2116 
LDA #$0000
STA $2118
              
JMP FinishTimerFull



FlashTimerProcess:
; now write the data
; digit4
; vram address
rep #$20
LDA #$0B7F ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
STA $2116 
; data to load
sep #$20
LDA #$24
XBA
LDA #$30
ADC !onscreen_flash_timer1
DEC A

rep #$20
STA $2118



; digit3
; vram address
rep #$20
LDA #$0B7E ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
STA $2116 
; data to load
sep #$20
LDA #$24
XBA
LDA #$30
ADC !onscreen_flash_timer2

rep #$20
STA $2118



; digit4
; vram address
rep #$20
LDA #$0B7D ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
STA $2116 
; data to load
sep #$20
LDA #$24
XBA
LDA #$30
ADC !onscreen_flash_timer3

rep #$20
STA $2118



; digit4
; vram address
rep #$20
LDA #$0B7C ; VRAM address 16b8. Just multiply LDA address by 2 for VRAM address
STA $2116 
; data to load
sep #$20
LDA #$24
XBA
LDA #$30
ADC !onscreen_flash_timer4

rep #$20
STA $2118

; and finally decrement timer by 1
sep #$20
clc
lda !room_flash_timer
dec a
sta !room_flash_timer

FinishTimerFull:
sep #$20

inc $00d2
ldx #$00
RTL
