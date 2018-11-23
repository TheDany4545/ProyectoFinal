#include "p16f887.inc"

; CONFIG1
; __config 0xFFF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF   
 
;******************************************************************************* 
;DECLARACION DE VARIABLES 
;*******************************************************************************
VARIABLES      UDATA
CONT1	       RES	  1
CONT2	       RES	  1
W_TEMP	       RES	  1
STATUS_TEMP    RES	  1

;*******************************************************************************
; RESETEO DE VECTOR
;*******************************************************************************
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
    
ISR_VECT  CODE    0x0004    
  PUSH:
    MOVWF W_TEMP
    SWAPF STATUS,W
    MOVWF STATUS_TEMP
  ISR:
   
  POP:
    SWAPF STATUS_TEMP,W
    MOVWF STATUS
    SWAPF W_TEMP,F
    SWAPF W_TEMP,W
    RETFIE			  
    
    MAIN_PROG CODE                      ; let linker place main program

START
;*******************************************************************************
    CALL    CONFIG_IO  
    CALL    CONFIG_RELOJ		; RELOJ INTERNO DE 500KHz
    CALL    CONFIG_ADC			; canal 0, fosc/8, adc on, justificado a la izquierda, Vref interno (0-5V)
    CALL    CONFIG_PWM
    BANKSEL PORTA

;--------------------------------------------
CONFIG_IO
BANKSEL	ANSEL		    ;BANCO 3
    CLRF	ANSEL		    ;I/O DIGITALES
    BSF	        ANSEL, 6	    ;ANSEL6 COMO ENTRADA ANALÓGICA	RE1
    BSF	        ANSEL, 7	    ;ANSEL7 COMO ENTRADA ANALÓGICA	RE2
    CLRF	ANSELH
    BSF	        ANSELH, 3	    ;ANSELH3 COMO ENTRADA ANALÓGICA  RB4
    BSF	        ANSELH, 5	    ;ANSELH5 COMO ENTRADA ANALÓGICA  RB5  
    
    BANKSEL	TRISA		    ;BANCO 1
    CLRF	TRISA
    MOVLW	B'00110000'
    MOVWF	TRISB
    CLRF	TRISC
    CLRF	TRISD
    MOVLW	B'1111'
    MOVWF	TRISE
    
    BANKSEL	PORTA		    ;BANCO 0
    CLRF	PORTA		    ;LIMPIAMOS PUERTOS
    CLRF        PORTB
    CLRF	PORTC
    CLRF	PORTD
    CLRF	PORTE
   
    BANKSEL	TRISA		    ;BANCO 1  
   
    BCF		OPTION_REG, T0CS    ;INTERNAL INSTRUCTION CYCLE CLOCK (FOSC/4)
    BCF		OPTION_REG, PSA	    ;PRESCALER DEL TIMER0
    BSF		OPTION_REG, PS2	    ;PRESCALER 1:256
    BSF		OPTION_REG, PS1
    BSF		OPTION_REG, PS0 
    
     BANKSEL	ADCON0
    BCF		ADCON0, ADCS1
    BCF		ADCON0, ADCS0	    ;FOSC/8 RELOJ TAD------------------------------AHORITA FOSC/2
    BSF		ADCON0, CHS3
    BCF		ADCON0, CHS2
    BSF		ADCON0, CHS1
    BSF		ADCON0, CHS0
    
    BANKSEL	TRISA
    BCF		ADCON1, ADFM	    ;LO JUSTIFICAMOS A LA IZQUIERDA
    BCF		ADCON1, VCFG1	    ;REFERENCIA VREF- : 5V
    BCF		ADCON1, VCFG0	    ;REFERENCIA VREF+ : 0V
    
    BANKSEL	TRISC
    BSF		TRISC, RC1	    ;ESTABLEZCO RC1 / CCP2 COMO ENTRADA
    BSF		TRISC, RC2	    ;ESTABLEZCO RC2 / CCP1 COMO ENTRADA
    MOVLW	.255		    ;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA .255
    MOVWF	PR2		    ;COLOCO EL VALOR DEL PERIODO DE MI SEÃ?AL 16.384mS
    
    BANKSEL	PORTA
    BSF		CCP2CON, CCP2M3
    BSF		CCP2CON, CCP2M2
    BSF		CCP2CON, CCP2M1
    BSF		CCP2CON, CCP2M0	    ;MODO PWM
    
    MOVLW	B'00011011'
    MOVWF	CCPR2L		    ;MSB DEL DUTY CICLE
    BSF		CCP2CON, DC2B0
    BSF		CCP2CON, DC2B1	    ;LSB del duty cicle
    
    BCF		PIR1, TMR2IF
    
    BSF		T2CON, T2CKPS1
    BSF		T2CON, T2CKPS0	    ; PRESCALER 1:16
    
    BSF		T2CON, TMR2ON	    ; HABILITAMOS EL TMR2
    BTFSS	PIR1, TMR2IF
    GOTO	$-1
    BCF		PIR1, TMR2IF
    
    BSF		CCP1CON, CCP1M3
    BSF		CCP1CON, CCP1M2
    BCF		CCP1CON, CCP1M1
    BCF		CCP1CON, CCP1M0	    ;MODO PWM
    
    
    MOVLW	B'00011011'
    MOVWF	CCPR1L		    ;MSB DEL DUTY CICLE
    BSF		CCP1CON, DC1B0
    BSF		CCP1CON, DC1B1	    ;LSB del duty cicle
    
    BCF		PIR1, TMR2IF
    
    BSF		T2CON, T2CKPS1
    BSF		T2CON, T2CKPS0	    ;PRESCALER 1:16
    
    BSF		T2CON, TMR2ON	    ;HABILITAMOS EL TMR2
    BTFSS	PIR1, TMR2IF
    GOTO	$-1
    BCF		PIR1, TMR2IF
    
    BANKSEL	TRISC
    BCF		TRISC, RC1	    ;RC1 / CCP2 SALIDA PWM
    BCF		TRISC, RC2	    ;RC2 / CCP1 SALIDA PWM
    
    BANKSEL TXSTA
    BCF	    TXSTA, SYNC		    ;ASINCRÓNO
    BSF	    TXSTA, BRGH		    ;LOW SPEED
    BANKSEL BAUDCTL
    BSF	    BAUDCTL, BRG16	    ;8 BITS BAURD RATE GENERATOR
    BANKSEL SPBRG
    MOVLW   .25	    
    MOVWF   SPBRG		    ;CARGAMOS EL VALOR DE BAUDRATE CALCULADO
    CLRF    SPBRGH
    BANKSEL RCSTA
    BSF	    RCSTA, SPEN		    ;HABILITAR SERIAL PORT
    BCF	    RCSTA, RX9		    ;SOLO MANEJAREMOS 8BITS DE DATOS
    BSF	    RCSTA, CREN		    ;HABILITAMOS LA RECEPCIÓN 
    BANKSEL TXSTA
    BSF	    TXSTA, TXEN		    ;HABILITO LA TRANSMISION
    
    BANKSEL PORTD
    CLRF    PORTD
    
    BANKSEL	PORTA
    BSF		ADCON0, ADON	    ;ACTIVAMOS EL MÓDULO ADC
