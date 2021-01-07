;-------------------------------------------------
    TITLE DISPLAY - programme prototype
    .286
;------------------------------------STACK SEGMENT
SSEG        SEGMENT    STACK
        DB 32 DUP("STACK---")

SSEG        ENDS
;-------------------------------------DATA SEGMENT
DSEG        SEGMENT

Jouer     DB      "Jouer"
L_Jouer   EQU     $-Jouer

Quitter     DB      "Quitter"
L_Quitter   EQU     $-Quitter

Fleche     DB      "=>"
L_Fleche    EQU     $-Fleche 

Vide    DB      "  "
L_Vide     EQU     $-Vide

Texte    DB      "Texte"
L_Texte     EQU     $-Texte

Compt    DB      "Pas :"
L_Compt     EQU     $-Compt

Gap1   DB      "Bravo !",10,10,"Tu as battu Freezer !",10,"Maintenant tu dois battre cell...",10,10,"Appuie sur entrer pour continuer !"
L_Gap1     EQU     $-Gap1

Gap2    DB      "Incroyable...",10,10,"Tu as battu Cell !",10,"Il reste une menace dans l'univers...",10,"Buu arrive !",10,10,"Appuie sur entrer pour continuer !"
L_Gap2     EQU     $-Gap2

txtfin    DB      "C'est fou !!",10,10,"Tu as battu Buu !",10,"Bravo beau gosse t'es trop fort !!",10,10,"Appuie sur entrer pour finir !"
L_txtfin    EQU     $-txtfin

creajeu    DB      "Gisonni Sylvio",32,32,32,32,32,32,"Robert Colin",10,10,"DUT Informatique 2019/2020 1A",10,10
L_creajeu     EQU     $-creajeu

score    DB      "Ton score :"
L_score     EQU     $-score

titre   DB      "Dragon Ball Quest"
L_titre     EQU     $-titre

trait  DB      "_________________"
L_trait    EQU     $-trait

hauteurquitter db 0
hauteurjouer db 0
posX dw 0
posY dw 0
posXMAX dw 325
posYMAX dw 200
nbpas dw 0
varscore dw ?
xA db 0
yA db 0
xB db 40
yB db 25
color db 0

%include Macro.asm

DSEG        ENDS
;-------------------------------------CODE SEGMENT
CSEG SEGMENT 'CODE'
ASSUME CS:CSEG, SS:SSEG, DS:DSEG
;-------------------------------------------------MACRO 

FlecheSurJouer MACRO
            MOV    AH,02h
            MOV    DH,10h
            MOV    DL,08h
            INT    10H

            MOV BX, 0001H 
            LEA DX, Vide
            MOV CX, L_Vide
            MOV AH, 40H 
            INT 21H

            MOV    AH,02h
            MOV    DH,09h
            MOV    DL,08h
            INT    10H

            MOV BX, 0001H 
            LEA DX, Fleche 
            MOV CX, L_Fleche 
            MOV AH, 40H 
            INT 21H
ENDM

FlechesurQuitter MACRO
            MOV    AH,02h
            MOV    DH,09h
            MOV    DL,08h
            INT    10H

            MOV BX, 0001H 
            LEA DX, Vide
            MOV CX, L_Vide
            MOV AH, 40H 
            INT 21H

            MOV    AH,02h
            MOV    DH,10h
            MOV    DL,08h
            INT    10H

            MOV BX, 0001H 
            LEA DX, Fleche 
            MOV CX, L_Fleche 
            MOV AH, 40H 
            INT 21H
ENDM

AfficherCadre MACRO
boucle:
            mov  AH, 0Ch
            mov  AL,3
            mov  DX, 180
            int  10h
            INC CX
            CMP CX, 300
            JNE boucle

            mov  CX, 20

boucle2:
            mov  AH, 0Ch
            mov  AL,3
            mov  DX, 20
            int  10h
            INC CX
            CMP CX, 300
            JNE boucle2

            mov DX,20
boucle3:
            mov  AH, 0Ch
            mov  AL,3
            mov  CX, 20
            int  10h
            INC DX
            CMP DX, 180
            JNE boucle3

            mov DX,20
boucle4:
            mov  AH, 0Ch
            mov  AL,3
            mov  CX, 300
            int  10h
            INC DX
            CMP DX, 180
            JNE boucle4

            mov  CX, 16

boucle5:
            mov  AH, 0Ch
            mov  AL,11
            mov  DX, 184
            int  10h
            INC CX
            CMP CX, 304
            JNE boucle5

            mov  CX, 16

boucle6:
            mov  AH, 0Ch
            mov  AL,11
            mov  DX, 16
            int  10h
            INC CX
            CMP CX, 304
            JNE boucle6

            mov DX,16
boucle7:
            mov  AH, 0Ch
            mov  AL,11
            mov  CX, 16
            int  10h
            INC DX
            CMP DX, 184
            JNE boucle7

            mov DX,16
boucle8:
            mov  AH, 0Ch
            mov  AL,11
            mov  CX, 304
            int  10h
            INC DX
            CMP DX, 184
            JNE boucle8
ENDM

Nettoyerecran:
    ; on stocke les registres
    push AX
    push DS
    push BX
    push CX
    push DI

    mov  AH, 06h
    mov  AL, 0      ; on remonte toutes les lignes
    mov  BH, color  ; on attribue de nouvelles lignes
    mov  CL, xA     ; la colonne la plus basse (entre 0 et 40 pour les colonnes et 0 et 25 pour les lignes car 1 caractères = 8*8 pixel)
    mov  CH, yA     ; la colonne la plus haute
    mov  DL, xB
    mov  DH, yB     ; le coin en bas à droite
    int  10h        ; on affiche

    Setcursor 0, 0

    ; on restore les registres
    pop  DI
    pop  CX
    pop  BX
    pop  DS
    pop  AX
RET

AfficherSsj1:
	push AX
	push BX

	mov  AX, posX
	mov  BX, posY

	add  BX, 3
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 02Bh	

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 037h
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 3
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	add  BX, 3
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	add  BX, 3
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 037h
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 3
	DessinPixel AX, BX, 037h
	inc  BX
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 3
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 3
	DessinPixel AX, BX, 037h
	inc  BX
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 4
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 02Bh

	pop  BX
	pop  AX
RET

AfficherSsj2:
	push AX
	push BX

	mov  AX, posX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 034h
	inc  BX
	DessinPixel AX, BX, 034h
	add  BX, 3
	DessinPixel AX, BX, 034h
	inc  BX
	DessinPixel AX, BX, 034h

	inc  AX
	mov  BX, posY

	add  BX, 3
	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	
	add  BX, 3
	DessinPixel AX, BX, 034h	
	add  BX, 2
	DessinPixel AX, BX, 034h	
	add  BX, 4
	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 034h
	inc  BX
	DessinPixel AX, BX, 034h	
	add  BX, 4
	DessinPixel AX, BX, 034h
	inc  BX
	DessinPixel AX, BX, 034h

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 034h
	add  BX, 4
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 037h	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 3
	DessinPixel AX, BX, 037h	

	inc  AX
	mov  BX, posY

	add  BX, 3
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	inc  BX
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 05Bh
	add  BX, 2
	DessinPixel AX, BX, 05Bh
	add  BX, 3
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Ah	

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 037h	
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 3
	DessinPixel AX, BX, 037h	
	inc  BX
	DessinPixel AX, BX, 02Ah	
	inc  BX
	DessinPixel AX, BX, 037h	

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 2
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 3
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	add  BX, 3
	DessinPixel AX, BX, 037h	
	inc  BX
	DessinPixel AX, BX, 05Bh	
	inc  BX
	DessinPixel AX, BX, 05Bh

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 4
	DessinPixel AX, BX, 02Bh	

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 02Bh	
	add  BX, 7
	DessinPixel AX, BX, 034h

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 9
	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	add  BX, 7
	DessinPixel AX, BX, 034h	
	add  BX, 3
	DessinPixel AX, BX, 034h	

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 034h	
	add  BX, 3
	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	
	add  BX, 5
	DessinPixel AX, BX, 034h	
	inc  BX
	DessinPixel AX, BX, 034h	
	add  BX, 3
	DessinPixel AX, BX, 034h

	pop  BX
	pop  AX
RET

AfficherFreezer:
	push AX
	push BX

	mov  AX, 200
	mov  BX, 40

	add  BX, 3
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	

	inc  AX
	mov  BX, 40

	add  BX, 2
	DessinPixel AX, BX, 023h	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh

	inc  AX
	mov  BX, 40

	add  BX, 2
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	add  BX, 3
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 06Bh	

	inc  AX
	mov  BX, 40

	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 4
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 023h	

	inc  AX
	mov  BX, 40

	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	add  BX, 2
	DessinPixel AX, BX, 028h	
	inc  BX
	DessinPixel AX, BX, 028h	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh

	inc  AX
	mov  BX, 40

	DessinPixel AX, BX, 023h
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	add  BX, 4
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh

	inc  AX
	mov  BX, 40

	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	

	inc  AX
	mov  BX, 40

	DessinPixel AX, BX, 06Bh
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	add  BX, 4
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh

	inc  AX
	mov  BX, 40

	inc  BX
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	add  BX, 2
	DessinPixel AX, BX, 028h	
	inc  BX
	DessinPixel AX, BX, 028h	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	

	inc  AX
	mov  BX, 40

	inc  BX
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 4
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 023h

	inc  AX
	mov  BX, 40

	add  BX, 2
	DessinPixel AX, BX, 06Bh	
	inc  BX
	DessinPixel AX, BX, 06Bh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	add  BX, 3
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 06Bh	

	inc  AX
	mov  BX, 40

	add  BX, 2
	DessinPixel AX, BX, 06Bh	
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	

	inc  AX
	mov  BX, 40

	add  BX, 3
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	

	pop  BX
	pop  AX
RET

AfficherCell:
	push AX
	push BX

	mov  AX, 200
	mov  BX, 120

	add  BX, 17
	DessinPixel AX,BX, 018h	
	inc  BX

	inc  AX
	mov  BX, 120

	add  BX, 5
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 8
	inc  BX
	inc  BX
	inc  BX
	inc  AX
	mov  BX, 120

	add  BX, 3
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 7
	add  BX, 3
	inc  BX
	inc  AX
	mov  BX, 120

	add  BX, 2
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 4
	add  BX, 2
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 00Fh
	add  BX, 2
	inc  AX
	mov  BX, 120

	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 4
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 00Fh
	add  BX, 2
	inc  AX
	mov  BX, 120

	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 023h
	add  BX, 3
	DessinPixel AX, BX, 023h
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 120

	add  BX, 3
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	add  BX, 2
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 120

	add  BX, 4
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h
	add  BX, 2
	DessinPixel AX, BX, 028h	
	inc  BX
	DessinPixel AX, BX, 028h
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 120

	add  BX, 5
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 3
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	add  BX, 4
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	

	inc  AX
	mov  BX, 120

	add  BX, 6
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	add  BX, 5
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	

	inc  AX
	mov  BX, 120

	add  BX, 5
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 3
	DessinPixel AX, BX, 00Fh	
	add  BX, 2
	DessinPixel AX, BX, 02Bh	
	add  BX, 4
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h

	inc  AX
	mov  BX, 120

	add  BX, 4
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h
	add  BX, 2
	DessinPixel AX, BX, 028h
	inc  BX
	DessinPixel AX, BX, 028h	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 00Fh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 3
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 02Bh	

	inc  AX
	mov  BX, 120

	add  BX, 3
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h
	add  BX, 2
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 023h
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 3
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 120

	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 023h
	add  BX, 3
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 120

	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 023h
	inc  BX
	DessinPixel AX, BX, 023h	
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	add  BX, 4
	DessinPixel AX, BX, 077h	
	inc  BX
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 00Fh
	add  BX, 2

	inc  AX
	mov  BX, 120

	add  BX, 2
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 4
	add  BX, 2
	DessinPixel AX, BX, 077h
	inc  BX
	DessinPixel AX, BX, 00Fh	
	add  BX, 2

	inc  AX
	mov  BX, 120

	add  BX, 3
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h	
	inc  BX
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 7
	add  BX, 3
	inc  BX

	inc  AX
	mov  BX, 120

	add  BX, 5
	DessinPixel AX, BX, 078h
	inc  BX
	DessinPixel AX, BX, 02Bh
	inc  BX
	DessinPixel AX, BX, 02Bh
	add  BX, 8
	inc  BX
	inc  BX
	inc  BX

	inc  AX
	mov  BX, 120

	add  BX, 17
	inc  BX

	pop  BX
	pop  AX
RET

AfficherSsj3:
	push AX
	push BX

	mov  AX, posX
	mov  BX, posY

	add  BX, 9
	DessinPixel AX, BX, 02Ch
	add  BX, 4
	DessinPixel AX, BX, 02Ch

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 072h
	add  BX, 3
	DessinPixel AX, BX, 02Ch
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	add  BX, 2
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Ch
	add  BX, 2
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 072h	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch
	inc  BX
	DessinPixel AX, BX, 02Ch
	add  BX, 5
	DessinPixel AX, BX, 02Ch

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 072h
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	add  BX, 2
	DessinPixel AX, BX, 02Ch	
	add  BX, 2
	DessinPixel AX, BX, 037h	
	add  BX, 5
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 072h
	add  BX, 4
	DessinPixel AX, BX, 02Ch
	add  BX, 2
	DessinPixel AX, BX, 05Ah
	add  BX, 2
	DessinPixel AX, BX, 02Ah
	add  BX, 5
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 02Ch
	add  BX, 2
	DessinPixel AX, BX, 02Ch
	inc  BX
	DessinPixel AX, BX, 02Ch	
	add  BX, 3
	DessinPixel AX, BX, 05Ah	
	add  BX, 2
	DessinPixel AX, BX, 02Ah	
	add  BX, 3
	DessinPixel AX, BX, 02Ah	
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 072h	
	add  BX, 2
	DessinPixel AX, BX, 02Ch	
	add  BX, 3
	DessinPixel AX, BX, 05Ah	
	inc  BX
	DessinPixel AX, BX, 05Ah	
	inc  BX
	DessinPixel AX, BX, 05Ah
	add  BX, 2
	DessinPixel AX, BX, 02Ah
	inc  BX
	DessinPixel AX, BX, 037h
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	add  BX, 2
	DessinPixel AX, BX, 02Ch	
	add  BX, 2
	DessinPixel AX, BX, 05Ah
	inc  BX
	DessinPixel AX, BX, 05Ah
	inc  BX
	DessinPixel AX, BX, 02Fh	
	inc  BX
	DessinPixel AX, BX, 02Fh	
	inc  BX
	DessinPixel AX, BX, 05Ah	
	inc  BX
	DessinPixel AX, BX, 05Ah	
	add  BX, 2
	DessinPixel AX, BX, 02Ah	
	inc  BX
	DessinPixel AX, BX, 037h
	inc  BX
	DessinPixel AX, BX, 02Ah

	inc  AX
	mov  BX, posY

	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch
	add  BX, 2
	DessinPixel AX, BX, 05Ah
	inc  BX
	DessinPixel AX, BX, 05Ah
	inc  BX
	DessinPixel AX, BX, 02Fh
	inc  BX
	DessinPixel AX, BX, 05Ah
	inc  BX
	DessinPixel AX, BX, 05Ah
	inc  BX
	DessinPixel AX, BX, 05Ah	
	add  BX, 2
	DessinPixel AX, BX, 02Ah	
	inc  BX
	DessinPixel AX, BX, 037h	
	inc  BX
	DessinPixel AX, BX, 02Ah	
	inc  BX
	DessinPixel AX, BX, 037h	

	inc  AX
	mov  BX, posY

	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch
	add  BX, 2
	DessinPixel AX, BX, 05Ah	
	inc  BX
	DessinPixel AX, BX, 05Ah	
	add  BX, 2
	DessinPixel AX, BX, 05Ah
	add  BX, 2
	DessinPixel AX, BX, 02Ah	
	add  BX, 4
	DessinPixel AX, BX, 037h

	inc  AX
	mov  BX, posY

	add  BX, 3
	DessinPixel AX, BX, 02Ch	
	add  BX, 2
	DessinPixel AX, BX, 05Ah	
	inc  BX
	DessinPixel AX, BX, 05Ah	

	inc  AX
	mov  BX, posY

	add  BX, 3
	DessinPixel AX, BX, 02Ch	
	inc  BX
	DessinPixel AX, BX, 02Ch	

	inc  AX
	mov  BX, posY

	add  BX, 4
	DessinPixel AX, BX, 02Ch

	pop  BX
	pop  AX
RET

AfficherBuu:
	push AX
	push BX

	mov  AX, 200
	mov  BX, 90

	add  BX, 8
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 6
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 5
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 4
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 3
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 2
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	add  BX, 2
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 2
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	inc  BX
	DessinPixel AX, BX, 028h	
	add  BX, 2
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX

	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 018h	
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 90

	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	add  BX, 3
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 018h	
	inc  BX
	DessinPixel AX, BX, 018h

	inc  AX
	mov  BX, 90

	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	add  BX, 2
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 2
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 018h	
	inc  BX
	DessinPixel AX, BX, 02Bh	

	inc  AX
	mov  BX, 90

	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 018h
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 90

	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 2
	add  BX, 2
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 90

	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 2
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 00Fh
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 018h
	inc  AX
	mov  BX, 90
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 3
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 90

	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 3
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	inc  BX
	add  BX, 2
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX

	inc  AX
	mov  BX, 90

	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 5
	add  BX, 3
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	add  BX, 3
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch

	inc  AX
	mov  BX, 90

	add  BX, 2
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 7
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 90

	add  BX, 3
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 7
	inc  BX
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 03Ch	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh	
	inc  BX
	DessinPixel AX, BX, 02Bh

	inc  AX
	mov  BX, 90

	add  BX, 4
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	DessinPixel AX, BX, 03Ch
	inc  BX
	add  BX, 8
	inc  BX
	inc  BX
	inc  BX

	inc  AX
	mov  BX, 90

	add  BX, 5
	inc  BX
	inc  BX
	inc  BX

	pop  BX
	pop  AX
RET

Pasfreezer:  
      
    mov cx,0 
    mov dx,0 
    label1: 
        cmp ax,0 
        je print1       
          
        mov bx,10      

        div bx       

        push dx               
        inc cx               
        xor dx,dx 
        jmp label1 
    print1: 
        cmp cx,0 
        je sortiecombat1
          
        pop dx 
        add dx,48 
        mov ah,02h 
        int 21h 
        dec cx 
        jmp print1 
RET

Pascell:  
      
    mov cx,0 
    mov dx,0 
    label2: 
        cmp ax,0 
        je print2    
          
        mov bx,10      

        div bx       

        push dx               
        inc cx               
        xor dx,dx 
        jmp label2
    print2: 
        cmp cx,0 
        je sortiecombat2
          
        pop dx 
        add dx,48 
        mov ah,02h 
        int 21h 
        dec cx 
        jmp print2
RET

Pasbuu:  
      
    mov cx,0 
    mov dx,0 
    label3: 
        cmp ax,0 
        je print3      
          
        mov bx,10      

        div bx       

        push dx               
        inc cx               
        xor dx,dx 
        jmp label3
    print3: 
        cmp cx,0 
        je sortiecombat3
          
        pop dx 
        add dx,48 
        mov ah,02h 
        int 21h 
        dec cx 
        jmp print3
RET

ValScore:  
      
    mov cx,0 
    mov dx,0 
    label4: 
        cmp ax,0 
        je print4   
          
        mov bx,10      

        div bx       

        push dx               
        inc cx               
        xor dx,dx 
        jmp label4
    print4: 
        cmp cx,0 
        je sortiescore
          
        pop dx 
        add dx,48 
        mov ah,02h 
        int 21h 
        dec cx 
        jmp print4
RET
;-------------------------------------------------

;MAIN
MAIN     PROC    FAR

;sauver l'adresse de retour
PUSH    DS
PUSH    0

;registre
            MOV   AX, DSEG
            MOV   DS, AX
            
            mov     AX, 0A000h			;mode graphique 13
            mov     ES, AX
            MOV    ax,13H
            INT    10H

            MOV    AH,02h				;placement du curseur
            MOV    DH,09h
            MOV    hauteurjouer,DH		;sauvegarde de la valeur de la hauteur du curseur
            MOV    DL,10h
            INT    10H

            MOV BX, 0001H 
            LEA DX, Jouer 				;affichage de "Jouer" dans le menu
            MOV CX, L_Jouer
            MOV AH, 40H 
            INT 21H
            FlecheSurJouer				;affichage de la fleche de selection

            MOV    AH,02h
            MOV    DH,10h
            MOV    hauteurquitter,DH
            MOV    DL,10h
            INT    10H

            MOV BX, 0001H 
            LEA DX, Quitter 			;affichage de "Quitter" dans le menu
            MOV CX, L_Quitter
            MOV AH,40H
            INT 21H
            
            MOV CX,20
            AfficherCadre				;affichage du cadre de jeu

			Setcursor 12,4
            MOV BX, 0001H 
            LEA DX, titre			;affichage du titre du jeu
            MOV CX, L_titre
            MOV AH,40H
            INT 21H

			Setcursor 12,5
            MOV BX, 0001H 
            LEA DX, trait
            MOV CX, L_trait
            MOV AH,40H
            INT 21H

choix:      
            MOV AH,00h					;fonction qui enregistre une touche appuyer sur le clavier
            INT 16H

            CMP AH, 1CH					
            JE enter_pressed

            CMP AH, 2CH
            JE z_pressed

            CMP AH, 1FH
            JE s_pressed
            JMP choix

z_pressed:
            FlecheSurJouer
            MOV DH,hauteurjouer
            JMP choix
s_pressed:
            FlechesurQuitter
            MOV DH,hauteurquitter
            JMP choix
enter_pressed: 
                CMP DH,10h
                JE exit
                JMP GokuVsFreezer

GokuVsFreezer:
            MOV posX,8						;début 1er combat
            MOV posY,90
            CALL Nettoyerecran				;"reset" de l'écran
            CALL AfficherSsj1				;affichage des personnages
            CALL AfficherFreezer

deplacementGF:

            Setcursor 0,0					;affichage du compteur de pas
            MOV BX, 0001H 
            LEA DX, Compt
            MOV CX, L_Compt
            MOV AH, 40H 
            INT 21H

            Setcursor 6,0
			MOV AX,nbpas  
			CALL Pasfreezer
			sortiecombat1:

            MOV AH,00h						;fonction qui enregistre une touche appuyer sur le clavier
            INT 16H

            CMP AH, 2CH
            JE z_moveGF

            CMP AH, 1FH
            JE s_moveGF

            CMP AH, 10H
            JE q_moveGF

            CMP AH, 20H
            JE d_moveGF
            JMP deplacementGF
        
d_moveGF:
            CALL Nettoyerecran
            INC nbpas
            ADD posX, 8
            CMP posX,304
            JE XM10GF
            CALL AfficherSsj1
            CALL AfficherFreezer
            CMP posX,200
            JE verifYGF
            JMP deplacementGF
z_moveGF:
            CALL Nettoyerecran
            INC nbpas
            SUB posY, 10
            CMP posY, 0
            JE YP10GF
            CALL AfficherSsj1
            CALL AfficherFreezer
            CMP posX,200
            JE verifYGF
            JMP deplacementGF
s_moveGF:
            CALL Nettoyerecran
            INC nbpas
            ADD posY, 10
            CMP posY,180
            JE YM10GF
            CALL AfficherSsj1
            CALL AfficherFreezer
            CMP posX,200
            JE verifYGF
            JMP deplacementGF
q_moveGF:
            CALL Nettoyerecran
            INC nbpas
            SUB posX, 8
            CMP posX, 0
            JE XP10GF
            CALL AfficherSsj1
            CALL AfficherFreezer
            CMP posX,200
            JE verifYGF
            JMP deplacementGF

XM10GF:
            SUB posX,8
            CALL AfficherSsj1
            CALL AfficherFreezer
            JMP deplacementGF
XP10GF:
            ADD posX,8
            CALL AfficherSsj1
            CALL AfficherFreezer
            JMP deplacementGF
YP10GF:
            ADD posY,10
            CALL AfficherSsj1
            CALL AfficherFreezer
            JMP deplacementGF
YM10GF:
            SUB posY,10
            CALL AfficherSsj1
            CALL AfficherFreezer
            JMP deplacementGF

verifYGF:
            CMP posY,40
            JE Transition1
            JMP deplacementGF

Transition1:

            CALL Nettoyerecran					;transition entre combat freezer et combat cell
            Setcursor 0,10

            MOV BX, 0001H 
            LEA DX, Gap1
            MOV CX, L_Gap1
            MOV AH, 40H 
            INT 21H

continuer:
            MOV AH,00h
            INT 16H

            CMP AH, 1CH
            JE GokuVsCell
            JMP continuer

GokuVsCell:								;début combat contre cell

            MOV posX,8
            MOV posY,90
            CALL Nettoyerecran
            CALL AfficherSsj2
            CALL AfficherCell

deplacementGC:

            Setcursor 0,0
            MOV BX, 0001H 
            LEA DX, Compt
            MOV CX, L_Compt
            MOV AH, 40H 
            INT 21H

            Setcursor 6,0
			MOV AX,nbpas  
			CALL Pascell
			sortiecombat2:

            MOV AH,00h
            INT 16H

            CMP AH, 2CH
            JE z_moveGC

            CMP AH, 1FH
            JE s_moveGC

            CMP AH, 10H
            JE q_moveGC

            CMP AH, 20H
            JE d_moveGC
            JMP deplacementGC
        
d_moveGC:
            CALL Nettoyerecran
            INC nbpas
            ADD posX, 8
            CMP posX,304
            JE XM10GC
            CALL AfficherSsj2
            CALL AfficherCell

            CMP posX,200
            JE verifYGC
            JMP deplacementGC
z_moveGC:
            CALL Nettoyerecran
            INC nbpas
            SUB posY, 10
            CMP posY, 0
            JE YP10GC
            CALL AfficherSsj2
            CALL AfficherCell

            CMP posX,200
            JE verifYGC
            JMP deplacementGC
s_moveGC:
            CALL Nettoyerecran
            INC nbpas
            ADD posY, 10
            CMP posY,170
            JE YM10GC
            CALL AfficherSsj2
            CALL AfficherCell

            CMP posX,200
            JE verifYGC
            JMP deplacementGC
q_moveGC:
            CALL Nettoyerecran
            INC nbpas
            SUB posX, 8
            CMP posX, 0
            JE XP10GC
            CALL AfficherSsj2
            CALL AfficherCell

            CMP posX,200
            JE verifYGC
            JMP deplacementGC

XM10GC:
            SUB posX,8
            CALL AfficherSsj2
            CALL AfficherCell
            JMP deplacementGC
XP10GC:
            ADD posX,8
            CALL AfficherSsj2
            CALL AfficherCell
            JMP deplacementGC
YP10GC:
            ADD posY,10
            CALL AfficherSsj2
            CALL AfficherCell
            JMP deplacementGC
YM10GC:
            SUB posY,10
            CALL AfficherSsj2
            CALL AfficherCell
            JMP deplacementGC

verifYGC:
        CMP posY,120
        JE Transition2
        JMP deplacementGC

Transition2:								;transition entre combat cell et combat buu

            CALL Nettoyerecran
            Setcursor 0,10

            MOV BX, 0001H 
            LEA DX, Gap2
            MOV CX, L_Gap2
            MOV AH, 40H 
            INT 21H

continuer2:
            MOV AH,00h
            INT 16H

            CMP AH, 1CH
            JE GokuVsBuu
            JMP continuer2

GokuVsBuu:									;début combat contre buu

            MOV posX,8
            MOV posY,90
            CALL Nettoyerecran
            CALL AfficherSsj3
            CALL AfficherBuu

deplacementGB:

            Setcursor 0,0
            MOV BX, 0001H 
            LEA DX, Compt
            MOV CX, L_Compt
            MOV AH, 40H 
            INT 21H

            Setcursor 6,0
			MOV AX,nbpas  
			CALL Pasbuu
			sortiecombat3:
			
            MOV AH,00h
            INT 16H

            CMP AH, 2CH
            JE z_moveGB

            CMP AH, 1FH
            JE s_moveGB

            CMP AH, 10H
            JE q_moveGB

            CMP AH, 20H
            JE d_moveGB
            JMP deplacementGB
        
d_moveGB:
            CALL Nettoyerecran
            INC nbpas
            ADD posX, 8
            CMP posX,304
            JE XM10GB
            CALL AfficherSsj3
            CALL AfficherBuu

            CMP posX,200
            JE verifYGB
            JMP deplacementGB
z_moveGB:
            CALL Nettoyerecran
            INC nbpas
            SUB posY, 10
            CMP posY, 0
            JE YP10GB
            CALL AfficherSsj3
            CALL AfficherBuu
             
            CMP posX,200
            JE verifYGB
            JMP deplacementGB
s_moveGB:
            CALL Nettoyerecran
            INC nbpas
            ADD posY, 10
            CMP posY,170
            JE YM10GB
            CALL AfficherSsj3
            CALL AfficherBuu

            CMP posX,200
            JE verifYGB
            JMP deplacementGB
q_moveGB:
            CALL Nettoyerecran
            INC nbpas
            SUB posX, 8
            CMP posX, 0
            JE XP10GB
            CALL AfficherSsj3
            CALL AfficherBuu
             
            CMP posX,200
            JE verifYGB
            JMP deplacementGB

XM10GB:
            SUB posX,8
            CALL AfficherSsj3
             
            JMP deplacementGB
XP10GB:
            ADD posX,8
            CALL AfficherSsj3
             
            JMP deplacementGB
YP10GB:
            ADD posY,10
            CALL AfficherSsj3
             
            JMP deplacementGB
YM10GB:
            SUB posY,10
            CALL AfficherSsj3
             
            JMP deplacementGB

verifYGB:
        CMP posY,90
        JE Msgfin
        JMP deplacementGB

Msgfin:										;message de fin du jeu(fin du dernier combat)

            CALL Nettoyerecran
            Setcursor 0,2
            MOV BX, 0001H 
            LEA DX, txtfin
            MOV CX, L_txtfin
            MOV AH, 40H 
            INT 21H

			Setcursor 0,18
            MOV BX, 0001H 
            LEA DX, score
            MOV CX, L_score
            MOV AH, 40H 
            INT 21H

			Setcursor 12,18
			MOV AX,nbpas  
			CALL ValScore
			sortiescore:
terminer:
            MOV AH,00h
            INT 16H

            CMP AH, 1CH
            JE createur
            JMP terminer

createur:								;Affichage info sur le jeu
            CALL Nettoyerecran
            Setcursor 0,10

            MOV BX, 0001H 
            LEA DX, creajeu
            MOV CX, L_creajeu
            MOV AH, 40H 
            INT 21H

fin:
            MOV AH,00h
            INT 16H

            CMP AH, 1CH
            JE exit
            JMP fin

exit: 								;Fonction pour fermer le programme
			MOV AH,4CH 
			INT 21H 
;fin de la procedure MAIN
    MAIN    ENDP
;fin du code du segment
    CSEG    ENDS
;fin du programme
    END        MAIN
;---------------------------------fin de programme