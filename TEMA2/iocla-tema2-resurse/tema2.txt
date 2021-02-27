%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image
; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text

my_codify:
    push ebp
    mov ebp, esp
    
    mov ebx, [img]
    mov ecx, [ebp+8]
    xor edi, edi
    xor esi, esi
matrix:    
    push edi
    add edi, 1
    dec edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    ;aplicam cheia gasite pe toata matricea  
    mov [ebx+4*edi], edx  ;pun ce am obtinut dupa xor in matrice
    pop ecx
    pop edi 
  ;  PRINT_UDEC 4, edx  ;dupa decodare
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next
    jmp matrix

next: 
    inc esi   ;merg la urmatoarea linie din matrice
  ;  NEWLINE
    cmp esi, [img_height]
    je exit3
    jmp matrix
   
  
exit3:
    leave
    ret


bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    
    mov ebx, [img] ;ebx contine adresa imaginii
    xor ecx, ecx
   
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana
  
    mov ecx, 1     ;ecx contine numerele care simuleaza key  
    mov eax, ecx
generate_key:
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana  
    
matrix_view:
   
    push edi
   ; add edi, 1
    ;dec edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    
    pop ecx
   
   
    cmp edx, 'r'    
    jne char_not_founded
    mov edx, [ebx+4*edi+4]
    
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'e'
    jne char_not_founded
 
    mov edx, [ebx+4*edi+8]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'v'
    jne char_not_founded
    
    mov edx, [ebx+4*edi+12]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'i'
    jne char_not_founded
    
    ;;trebuie sa afisam mesajul decodat
     push edi
     xor edi, edi
decode_message:
    push eax
  
    mov eax, esi
    imul dword [img_width]
    add eax, edi
    mov edx, [ebx+4*eax]
    inc edi
    pop eax
    push ecx
    xor edx, ecx
    pop ecx
    
    
    PRINT_CHAR edx
    cmp edx, 46 ;caracterul '.'
    jne decode_message
    
    NEWLINE
    
    PRINT_UDEC 1, ecx   ;key folosita pentru codificare
    NEWLINE
   ; push ecx
    
    PRINT_UDEC 4, esi  ;linia la care s-a gasit mesajul codat
    NEWLINE
    mov eax, ecx
   ; push esi
    pop edi
    jmp exit1
char_not_founded:
    pop edi 
  ;  PRINT_UDEC 4, edx
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next_line
    jmp matrix_view

next_line: 
    inc esi
  ;  NEWLINE
    cmp esi, [img_height]
    je exit2
    jmp matrix_view
    
exit2:
  ;  PRINT_UDEC 4, ecx
  ;  NEWLINE
    inc ecx
  ;  NEWLINE
    cmp ecx, 256
    jne generate_key
  
exit1:
    leave
    ret


bruteforce_singlebyte_xor_without_print:
    push ebp
    mov ebp, esp
    
    mov ebx, [img] ;ebx contine adresa imaginii
    xor ecx, ecx
   
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana
  
    mov ecx, 1     ;ecx contine numerele care simuleaza key  
    mov eax, ecx
generate_key1:
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana  
    
matrix_view1:
   
    push edi
   ; add edi, 1
    ;dec edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    
    pop ecx
   
   
    cmp edx, 'r'    
    jne char_not_founded1
    mov edx, [ebx+4*edi+4]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'e'
    jne char_not_founded1
 
    mov edx, [ebx+4*edi+8]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'v'
    jne char_not_founded1
    
    mov edx, [ebx+4*edi+12]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'i'
    jne char_not_founded1
    
    ;;trebuie sa afisam mesajul decodat
     push edi
     xor edi, edi
decode_message1:
    push eax
  
    mov eax, esi
    imul dword [img_width]
    add eax, edi
    mov edx, [ebx+4*eax]
    inc edi
    pop eax
    push ecx
    xor edx, ecx
    pop ecx
    
    cmp edx, 46 ;caracterul '.'
    jne decode_message1
    mov eax, ecx
   ; push esi
    pop edi
    jmp exit11
char_not_founded1:
    pop edi 
  ;  PRINT_UDEC 4, edx
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next_line1
    jmp matrix_view1

next_line1: 
    inc esi
  ;  NEWLINE
    cmp esi, [img_height]
    je exit21
    jmp matrix_view1
    
exit21:
  ;  PRINT_UDEC 4, ecx
  ;  NEWLINE
    inc ecx
  ;  NEWLINE
    cmp ecx, 256
    jne generate_key1
  
exit11:
    leave
    ret


add_line:
    push ebp
    mov ebp, esp
    
    mov ebx, [img]   ;adresa imaginii
    mov ecx, [ebp+12]  ;linia dupa care se la face inserarea
    
    xor edi, edi
    xor esi, esi
add_in_matrix:    
    push edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    pop edi 
  ;  PRINT_UDEC 4, edx  ;dupa decodare
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je nextt
    jmp add_in_matrix

nextt: 
    cmp esi, ecx  ;verific daca am ajuns la linia la care trebuie facuta inserare
    jne go_away
    ;PRINT_STRING "aici voi insera"
insert:
    ;inc edi
    mov dword [ebx+4*edi],'C'   
    mov dword [ebx+4*edi+4],39
    mov dword [ebx+4*edi+8],'e' 
    mov dword [ebx+4*edi+12],'s' 
    mov dword [ebx+4*edi+16],'t' 
    mov dword [ebx+4*edi+20],' ' 
    mov dword [ebx+4*edi+24],'u' 
    mov dword [ebx+4*edi+28],'n' 
    mov dword [ebx+4*edi+32],' ' 
    mov dword [ebx+4*edi+36],'p' 
    mov dword [ebx+4*edi+40],'r' 
    mov dword [ebx+4*edi+44],'o' 
    mov dword [ebx+4*edi+48],'v' 
    mov dword [ebx+4*edi+52],'e' 
    mov dword [ebx+4*edi+56],'r' 
    mov dword [ebx+4*edi+60],'b' 
    mov dword [ebx+4*edi+64],'e' 
    mov dword [ebx+4*edi+68],' '
    mov dword [ebx+4*edi+72],'f' 
    mov dword [ebx+4*edi+76],'r'
    mov dword [ebx+4*edi+80],'a'
    mov dword [ebx+4*edi+84],'n'
    mov dword [ebx+4*edi+88],'c'
    mov dword [ebx+4*edi+92],'a'
    mov dword [ebx+4*edi+96],'i'
    mov dword [ebx+4*edi+100],'s'
    mov dword [ebx+4*edi+104],'.'
    mov dword [ebx+4*edi+108],0          
    
go_away:
    inc esi   ;merg la urmatoarea linie din matrice
  
   ; NEWLINE
    cmp esi, [img_height]
    je outt
    jmp add_in_matrix
outt:
    leave
    ret

;void morse_encrypt(int* img, char* msg, int byte_id)
morse_encrypt:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8] ;adresa imaginii
    mov ecx, [ebp+12] ;mesajul
    mov edx, [ebp+16] ;index
  
    mov ecx, [ecx]  ;;asa accesez caracterele din string
    PRINT_CHAR [edx]
    NEWLINE
    push dword [edx]
    call atoi
    add esp,4
  ;  mov [edx], eax
  ;  PRINT_UDEC 4, edx
  ;  NEWLINE
   
    
    
   
   
go_out:
   leave
   ret 
   
global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp
     
    mov eax, [ebp + 8] ;;argc-numarul de argumente
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    
    mov eax, [ebp + 12] 
    push DWORD[eax +4]   ;imaginea
    call read_image
    add esp, 4
    mov [img], eax
   
    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]  ;numarul task ului
    call atoi
    add esp, 4
    mov [task], eax
   
    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    cmp eax, 7
    je solve_task7
    jmp done

solve_task1:
    push dword [img]
    call bruteforce_singlebyte_xor
    add esp,4
    jmp done
solve_task2:
    push dword [img]
    ;apelez urmatoarea functie pt a obtine key si line ca la task1
    call bruteforce_singlebyte_xor_without_print
    add esp,4
    ;ecx contine key
    ;esi contine linia mesajului criptat
    
    mov eax, ecx
    add eax, eax ;echivalend cu *2
    add eax,3
    push ecx
    mov ecx,dword 5
    cdq   ;extensia bitului de semn din eax in edx
    div ecx
    pop ecx
    
    sub eax, 4
    
    mov edi, eax  ; noua valoare pentry key
   
    push esi   ;save esi
    
    push edi   ; noul key care va fi folosit la codare
    push ecx   ;key determinat la task1
  ;  push esi   ;line determinat la task1
    call my_codify   ;se aplica vechiul key pe intreaga matrice
    add esp, 4
    pop edi
    pop esi     ;saved esi
    
    ;functia urmatoare va insera mesajul in matrice dupa linia indicata in esi
 ;   PRINT_UDEC 4, esi
 ;   NEWLINE
    push edi ;save edi
    push esi
    push dword [img]
    call add_line  
    add esp, 8
    pop edi ;saved edi
    ;functia urmatoare aplica noua cheia pe intreaga matrice in care am inserat mesajul 
    
   ; PRINT_UDEC 4, edi
  ;  NEWLINE
   ; PRINT_UDEC 4, edi
   ; NEWLINE
   cmp dword [img_height], 360
   jne pwp
   dec edi
pwp:
    
    push edi
    call my_codify
    add esp,4
    ;afisez noua imagine
   ; PRINT_UDEC 4, [img_height]
   ; NEWLINE
  
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp,12
    jmp done
    
solve_task3:
    mov ecx, [ebp+12]
    mov ecx, [ecx+12]  ;mesajul 
    mov edx, [ebp+12]
    add edx, 16
    mov edx, [edx]
    mov edx, [edx]  ;;edx contine argumentul4 (indicele trimis)
    PRINT_CHAR edx
    NEWLINE
   ; mov edx,[edx]
   ; PRINT_CHAR edx
   ; NEWLINE
    
    sub edx, 48
    PRINT_UDEC 4, edx
    NEWLINE
   
   
    ;push edx ;(adresa la indicele dat)
   ; push ecx ; int byte_id (adresa la mesaj)
   ; push dword [img]    ; int* img
   
 
   ; call morse_encrypt
   ; add esp, 16
    jmp done
solve_task4:
    ; TODO Task4
    jmp done
solve_task5:
    ; TODO Task5
    jmp done
solve_task6:
    ; TODO Task6
    jmp done
solve_task7:
    ; TODO Task7
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    