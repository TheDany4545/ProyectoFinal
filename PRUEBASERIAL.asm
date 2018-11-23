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
