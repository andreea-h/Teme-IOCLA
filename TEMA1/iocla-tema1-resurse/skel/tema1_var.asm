%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
   
section .data
    array times 1000 dd 0;;vectorul pentru memorarea expresiei
    contor: db 1
    save_root: dd 1, 0
    print_format: dd 'Rezultatul este',0
    print_format1: dd ' Suma este ',0
section .text

my_atoi: 
    push ebp
    mov ebp, esp
    
    xor ebx, ebx
    xor edx, edx ;;memoreaza stringul ca intreg

    mov esi, 10
    lea ecx, [ebp+8] ;; in bl memorez pe rand fiecare cifra a numarului
convert:
    ;;parcurg sirul byte cu byte
   
   movzx ebx, byte [ecx]
  ; mov bl, byte [ecx]
  ; test bl, bl ;!!!
   cmp ebx, 0x00
   je out
   cmp ebx, 48
   jl out
   cmp ebx, 57
   jg out
   
;   PRINT_STRING "inainte de convert: "
;  PRINT_UDEC 4, ebx
;   NEWLINE
  
   inc ecx
   sub ebx, 48
;   PRINT_STRING "caracter convertit "
   
 ;  PRINT_UDEC 4, ebx
 ;  NEWLINE
;   PRINT_STRING "dupa convert: "
;   PRINT_UDEC 1 ,ebx
;   NEWLINE
   
   mov eax, edx
   mul esi 
   add eax, ebx
   mov edx, eax
;   PRINT_UDEC 4, edx
;   NEWLINE
  
   jmp convert
    
out:       
    leave
    ret

deferentiere_stanga:
    push ebp
    mov ebp, esp
    ;;am adresa in eax
    mov ebx, [ebp+8] ;;radacina subarborelui stanga 
    mov ecx, [ebx]
    add ecx, 4
    mov esi, [ecx] 
    mov edx, [esi]

    PRINT_STRING "deferentiez: "
    PRINT_CHAR [array+4*edi]
    NEWLINE
    
out1:
    leave 
    ret    

check_if_operator:
    push ebp
    mov ebp, esp
;primesc ca argument un string
    mov ebx, [ebp+8] 
    cmp ebx, "+"
    je out3
    cmp ebx, "-"
    je out3
    cmp ebx, "/"
    je out3
    cmp ebx, "*"
    je out3
out4:
    mov ecx, 0x01 ;;am dat ca parametru un operand
    leave 
    ret    
   
out3:
    mov ecx, dword 0x00 ;;am dat ca parametru un operator
    leave 
    ret
    
    
preordine:
    push ebp
    mov ebp, esp
   
    mov eax, [ebp+8] ;;argumentul functiei- radacina arborelui
    mov eax, [eax]
    mov eax, [eax] ;;deferentiez 
    test eax, eax
    jne afisare
    jmp exit_preordine
    
afisare:
    mov eax, [ebp+8]
    mov eax, [eax]
    mov eax, [eax]
    PRINT_CHAR eax
    NEWLINE
    mov eax, [ebp+8]
    mov eax, [eax]
    mov eax, [eax+4]
    push eax
    call preordine
    add esp, 4
    mov eax, [ebp+8]
    mov eax, [eax]
    mov eax, [eax+8]
    push eax
    call preordine
    add esp,4
    
    
        
exit_preordine:
    leave 
    ret    
    
;--------------------------------------------------------    
global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    ;;root contine un pointer = o adresa la adresa
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST ;;eax - valoarea de retur a functiei
    mov [root], eax
    xor eax, eax
;--------------------------------------------------------
    ; Implementati rezolvarea aici:
    

    push [root]
    call preordine
    add esp, 4
    
    
exit:  
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret