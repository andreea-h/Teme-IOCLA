    
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

    ; Implementati rezolvarea aici:
    

      ;;;radacina arborelui
    xor ebx, ebx
    mov ebx, [root]
    mov ecx, [ebx]
    mov edx, [ecx]
    mov [array], edx
 ;   PRINT_CHAR [array] ; obtinem -
 ;   NEWLINE
    
    ;;; subarborele stang
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    mov eax, [root]
    add eax ,4
    mov ebx, [eax]
   
    mov ecx, [ebx]
    mov esi, [ecx]
    mov [array+4], esi
  
;    PRINT_CHAR  [array+4]
;    NEWLINE
    
    ;;subarborele drept
    
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    mov eax, [root]
    add eax, 8
    mov ebx, [eax]
    mov ecx, [ebx]
    mov esi, [ecx]
    mov [array+8], esi
 
;    PRINT_CHAR [array+8]
;    NEWLINE
 ;   NEWLINE

    
    
    mov ecx, 3  
    
    jmp afisare_vector
 
extrage_de_pe_stiva:
  ;  PRINT_STRING "andreea"
  ;  NEWLINE
    pop dword edx ;;iau de pe stiva 2 operanzi
  
   ; PRINT_CHAR edx
    ;NEWLINE
    sub edx, 0x30
    pop dword esi  
    
 ;   PRINT_CHAR esi
 ;   NEWLINE
    sub esi, 0x30
   
    add edx, esi
   ; PRINT_STRING print_format1
 ;   PRINT_UDEC 1, edx
 ;   NEWLINE
    dec ecx
    test ecx, ecx
    jz exit
    jnz afisare_vector
    
incarca_pe_stiva:
 ;   PRINT_STRING "papanasi"
 ;   NEWLINE
    push dword [array+4*(ecx-1)]
 ;   PRINT_STRING print_format
 ;   NEWLINE

    cmp eax, 0x2b ;+
    cmp eax, 0x2d ;-
    cmp eax, 0x2a ;*
    cmp eax, 0x2f ;/
 ;   PRINT_HEX 4, eax
 ;   NEWLINE
    jz extrage_de_pe_stiva
    dec ecx
    test ecx, ecx
    jz atoi_label
afisare_vector:
    mov eax, [array+4*(ecx-1)]
;    PRINT_CHAR [array+4*(ecx-1)]
;    NEWLINE
;    PRINT_HEX 4, eax
;    NEWLINE
    cmp eax, 0x2b ;+
      jz extrage_de_pe_stiva
    cmp eax, 0x2d ;-
    cmp eax, 0x2a ;*
    cmp eax, 0x2f ;/
    jnz incarca_pe_stiva
  
    dec ecx
    jnz afisare_vector
    
    
atoi_label:
    ;;apel 'atoi'
    push eax ;;parametrul pentru care apelez atoi
    call atoi
    add esp, 4  
    
    
    
    
    
    
exit:  
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret