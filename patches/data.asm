if !zipsroute = 1
    org $C49800 ; free space, ROCKMAN, zips route
    ; Intro
    ; Dynamo
    ; Cold
    ; Ground
    ; Tengu
    ; Astro
    ; Pirate
    ; Burner
    ; Magic
    ; Weapon
    ; King 1
    ; King 2
    ; Wily 3
    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c000000
    dd $009c009c
    dd $4000209c
    dd $00000040

    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c9c0000
    dd $009c009c
    dd $4000209c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $009c009c
    dd $4000209c
    dd $00000040

    ; 
    dd $9c000000
    dd $009c009c
    dd $40002000
    dd $00000040

    ; 
    dd $00000000
    dd $009c009c
    dd $00000000
    dd $00000000

    ; 
    dd $00000000
    dd $009c0000
    dd $00000000
    dd $00000000

    ; 
    dd $9c9c9c00
    dd $9c9c009c
    dd $4000209c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $0000009c
    dd $00000000

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4800229c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4800229c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4800229c
    dd $00000040

    org $C49900 ; free space, FORTE
    ; 
    
    
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    dd $9c000000
    dd $009c009c
    dd $4000239c
    dd $00000040

    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    dd $9c9c0000
    dd $009c009c
    dd $4000239c
    dd $00000040

    dd $9c9c9c00
    dd $009c009c
    dd $4000239c
    dd $00000040

    dd $9c000000
    dd $009c009c
    dd $40002300
    dd $00000040

    dd $00000000
    dd $009c009c
    dd $00000000
    dd $00000000

    dd $00000000
    dd $009c0000
    dd $00000000
    dd $00000000

    dd $9c9c9c00
    dd $9c9c009c
    dd $4000239c
    dd $00000040

    dd $9c9c9c00
    dd $9c9c9c9c
    dd $0000239c
    dd $00000000

    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040

    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040

    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040



elseif !zipsroute = 0
    org $C49800 ; free space, ROCKMAN, no-zip route
    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c009c00
    dd $9c9c9c9c
    dd $4000209c
    dd $00000040

    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c000000
    dd $009c009c
    dd $40002000
    dd $00000040

    ; 
    dd $9c009c00
    dd $009c009c
    dd $40002000
    dd $00000040

    ; 
    dd $9c009c00
    dd $9c9c9c9c
    dd $40002000
    dd $00000040

    ; 
    dd $00000000
    dd $009c009c
    dd $00000000
    dd $00000000

    ; 
    dd $00000000
    dd $009c0000
    dd $00000000
    dd $00000000

    ; 
    dd $9c009c00
    dd $9c9c009c
    dd $40002000
    dd $00000040

    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4800229c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4800229c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4800229c
    dd $00000040




    org $C49900 ; free space, FORTE
    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c009c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040

    ; 
    dd $00000000
    dd $00000000
    dd $00000000
    dd $00000000

    ; 
    dd $9c000000
    dd $009c009c
    dd $40002300
    dd $00000040

    ; 
    dd $9c009c00
    dd $009c009c
    dd $40002300
    dd $00000040

    ; 
    dd $9c009c00
    dd $9c9c9c9c
    dd $40002300
    dd $00000040

    ; 
    dd $00000000
    dd $009c009c
    dd $00000000
    dd $00000000

    ; 
    dd $00000000
    dd $009c0000
    dd $00000000
    dd $00000000

    ; 
    dd $9c009c00
    dd $9c9c009c
    dd $40002300
    dd $00000040

    ; 
    dd $00000000
    dd $00000000
    dd $00002300
    dd $00000000

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040

    ; 
    dd $9c9c9c00
    dd $9c9c9c9c
    dd $4000239c
    dd $00000040

endif