%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ; pregatim registrele
    xor eax, eax
    xor ebx, ebx

encrypt:
    ; verificam daca valoarea registrului eax
    ; a atins valoarea lui ecx
    cmp eax, ecx
    je exit

    ; preluam fiecare valoare din vector
    mov ebx, [esi + eax]

    ; adaugam valoarea lui step
    add ebx, edx

    ; verificam daca valoarea registrului depaseste 
    ; caracterul 'Z'
    cmp bl, 90
    jg exception

    ; adaugam in vectorul destinatie
    jmp add_string
loop encrypt

exception:
    ; scadem numarul de caractere din alfabet pentru a
    ; ne repozitiona in alfabet
    sub bl, 26

    ; adaugam in vectorul destinatie
    jmp add_string

add_string:
    ; adaugarea valorii pentru pozitia corespunzatoare
    mov byte [edi + eax], bl

    ; incrementarea registrului pentru pozitie
    inc eax

    ; repetarea pasilor pentru fiecare element
    jmp encrypt

; iesirea din program
exit:
    popa
    leave
    ret
    