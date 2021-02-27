%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
   
section .data
    array times 1000 dq 0;;vector pentru memorarea expresiei
    contor: dd 0 ;;variabila iterator folosita la parcuregerea vect. 'array'
section .text

;;-------------------------------------------------------
;; verifica daca argumentul primit este operand sau operator
;; rezultatul este pasat prin registrul edx (contine 1->operand, 0->operator)
check_if_operator: 
    push ebp
    mov ebp, esp
    
    xor edx, edx
    mov ebx, [ebp+8] 
    cmp ebx, "+"
    je operatorul
    cmp ebx, "-"
    je operatorul
    cmp ebx, "/"
    je operatorul
    cmp ebx, "*"
    je operatorul
operandul:
    mov edx, 0x01 ;;am primit ca parametru un operand
    leave 
    ret    
operatorul:
    mov edx, dword 0x00 ;;am primit ca parametru un operator
    leave 
    ret
    
;;;;;------------------------------------------------------
;;;;;-------------------------------------------------------    
preordine:
    push ebp
    mov ebp, esp
    xor edx, edx
    mov esi, 10
    lea eax, [ebp+8] ;;argumentul primit la apel - radacina arborelui
    mov eax, [eax]
    test eax, eax
    jne afisare
    jmp exit_preordine
    xor edi, edi
afisare:
    xor edi, edi
    mov eax, [ebp+8]
    mov eax, [eax] 
atoi:
     movzx ebx, byte [eax] ;;pune in ebx pe rand caracterele din string
     ;;parcurg sirul byte cu byte, verific daca am ajuns la finalul stringului
     cmp ebx, 0x00 ;; cand s-a ajuns la finalul string-ului
     je out_conversie
     cmp ebx, '-'   ;;numar negativ sau operatorul minus
     je atribuie_negativ
     ;;edx va fi folosit si in check_if_operator -> il salvez pe stiva
     push edx ;;salvez pe stiva edx = rezultatul conversiei
     push dword ebx
     call check_if_operator
     add esp,4
     ;;rezultatul este memorat in edx
     cmp edx, 0x01 ;;;operand
     pop edx
     je continua_parcurgerea
     jne char_operator
atribuie_negativ:     ;;;pune in edi 255->marchez ca numarul este negativ
     push eax
     mov eax, [eax]  ;;verific daca - marcheaza numar negativ sau este operator
     cmp eax, '-'
     je char_operator
     pop eax
     mov edi, 255
     inc eax
     jmp atoi
continua_parcurgerea:
    inc eax
    sub ebx, 48 ;;caracterul retinut in ebx este 'convertit' la intreg
    push eax
    mov eax, edx
    mul esi ;;inmulteste cu 10 rezultatul curent
    add eax, ebx ;;adauga la rezultat cifra curenta (din ebx)
    mov edx, eax  ;retine rezultatul in edx
    pop eax
    jmp atoi ;;reia operatiile pana cand se va intalni un caracter invalid (sau terminatorul de sir)
out_conversie: 
    cmp edi, 255
    je numar_negativ  ;;primul caracter era '-' -> numar negativ
    jne finally_outt
numar_negativ:
    neg edx ;;negam rezultatul obtinut
    mov eax, edx
    jmp finally_outt
char_operator:  
    mov edx, ebx
finally_outt:  ;; adauga in 'array' operatorul/operandul    
    mov ecx, dword [contor]
    mov [array+ecx*4], edx ;;edx retine rezultatul conversiei
    add dword [contor],1
    ;;;apel recursiv pentru subarborele stang
    lea eax, [ebp+8]
    mov eax, [eax]
    mov eax, [eax+4]
    push eax
    call preordine
    sub esp,4
    ;;;apel recursiv pentru subarborele drept
    lea eax, [ebp+8]
    mov eax, [eax]
    mov eax, [eax+8]
    mov [esp], eax
    call preordine
    sub esp,4
exit_preordine:
    leave 
    ret    
    
;; parcurge expresia si memoreaza rezultatul final in eax
evaluare_expresie:
    push ebp
    mov ebp, esp
    xor edx, edx
    xor eax, eax 
    mov ecx, [contor]
calcul_expresie:
    ;;se parcurge vectorul in ordinea inversa, de la dreapta la stanga
    mov eax, [array+4*(ecx-1)]
    ;eax contine elemetul curent din vector
    mov ebx, eax
    push eax 
    call check_if_operator
    add esp, 4
    mov eax, ebx
    cmp edx, 0x01 ;; edx contine 1 --> in eax este un operand
    je operand
    jne operator
operand: ;;daca el.curent este operand, atunci se pune pe stiva
    push eax
    jmp efect_calcul
operator: 
    ;; se scot 2 operanzi de pe stiva
    pop esi
    pop edi
    ;;se efectueaza operatie in functie de operatorul curent
    ;;apoi se pune rezultatul pe stiva
    cmp eax, "+"
    je suma
    cmp eax, "-"
    je diferenta
    cmp eax, "/"
    je impartire
    cmp eax, "*"
    je produs  
suma:
    add esi, edi
    push esi
    jmp efect_calcul
diferenta:
    sub esi,edi
    push esi
    jmp efect_calcul
impartire:
    mov ebx, eax  ;;salvez in 'ebx' valoarea din'eax'
    xor edx, edx
    mov eax, esi
cu_idiv:
    cdq ;;se face extensia de semn in edx:eax
    idiv edi 
    jmp stiva
stiva:
    push eax ;;pune se stiva catul impartirii
    mov eax, ebx ;;restaureaza valoarea lui 'eax' salvata anterior in ebx
    jmp efect_calcul
produs: 
    mov ebx, eax
    mov eax, edi
    imul esi
    push eax ;;pune rezultatul inmultirii pe stiva    
    mov eax, ebx   
efect_calcul:
    cmp ecx, 1  ;;verificam daca s-a ajuns la primul element din vector
    je exit_calcul
    dec ecx
    jmp calcul_expresie                                                                
exit_calcul:
    pop eax ;;rezultatul este ultimul numar pus pe stiva
    PRINT_DEC 4, eax
    leave
    ret                    
;--------------------------------------------------------    
global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST ;;eax - valoarea de retur a functiei
    mov [root], eax
 
;--------------------------------------------------------
    ; Implementati rezolvarea aici:
 
    push dword [root]
    call preordine ;;; functie recursiva in cadrul careia se memoreaza intr-un vector arborele
    add esp, 4
  
;--------------------------------------------------------  

    ;;parcurge expresia memorata in array 
    ;;folosesc stiva pentru a evalua valoarea expresiei
    call evaluare_expresie
   
exit:  
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret