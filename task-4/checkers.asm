
section .data

section .text
	global checkers

checkers:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

verify:
    ; pregatirea registrilor 
    xor edx, edx
    mov edx, eax

    ; pastrarea in registru pozitia initiala
    ; a damei
    imul edx, 8
    add edx, ebx

    ; verificarea cazurilor speciale (piesa se afla
    ; pe marginile tablei)
    cmp eax, 0
    je no_down

    cmp eax, 7
    je no_up

    cmp ebx, 0
    je no_left

    cmp ebx, 7
    je no_right
    
    ; punem valoarea registrului pe stiva
    ; pentru a o accesa ulterior
    push edx

    ; adaugam pe cele 4 pozitii in matrice
    ; valoarea 1 (am folosit faptul ca 
    ; tabla are dimensiunea 8x8)

    add edx, 7
    mov byte [ecx + edx], 1

    add edx, 2
    mov byte [ecx + edx], 1

    pop edx

    sub edx, 7
    mov byte [ecx + edx], 1


    sub edx, 2
    mov byte [ecx + edx], 1
    
   jmp exit

; tratarea cazului in care piesa se afla
; pe linia superioara
no_up:
    ; piesa se afla in coltul din stanga
    cmp ebx, 0
    je no_up_no_left

    ; piesa se afla in coltul din dreapta
    cmp ebx, 7
    je no_up_no_right

    ; adaugarea efectiva pentru linia superioara
    sub edx, 7
    mov byte [ecx + edx], 1

    sub edx, 2
    mov byte [ecx + edx], 1

    jmp exit

; tratarea cazului in care piesa se afla
; pe linia superioara
no_down:
    ; piesa se afla in coltul din stanga
    cmp ebx, 0
    je no_left_no_down

    ; piesa se afla in coltul din dreapta
    cmp ebx, 7
    je no_down_no_right

    ; adaugarea efectiva pentru linia inferioara
    add edx, 7
    mov byte [ecx + edx], 1

    add edx, 2
    mov byte [ecx + edx], 1

    jmp exit

; tratarea cazului in care piesa se afla
; pe coloana din stanga
no_left:
    ; piesa se afla pe linia superioara
    cmp eax, 0
    je no_up_no_left

    ; piesa se afla pe linia inferioara
    cmp eax, 7
    je no_left_no_down

    ; adaugarea efectiva pentru coloana din stanga
    add edx, 9
    mov byte [ecx + edx], 1

    sub edx, 9
    sub edx, 7
    mov byte [ecx + edx], 1
    jmp exit

; tratarea cazului in care piesa se afla
; pe coloana din dreapta
no_right:
    ; piesa se afla pe linia superioara
    cmp eax, 0
    je no_up_no_right

    ; piesa se afla pe linia inferioara
    cmp eax, 7
    je no_down_no_right

    ; adaugarea efectiva pentru coloana din dreapta
    sub edx, 9
    mov byte [ecx + edx], 1

    add edx, 9
    add edx, 7
    mov byte [ecx + edx], 1
    jmp exit

; adaugarea pentru coltul din stanga, sus
no_up_no_left:
    sub edx, 7
    mov byte [ecx + edx], 1
    jmp exit

; adaugarea pentru coltul din dreapta, sus
no_up_no_right:
    sub edx, 9
    mov byte [ecx + edx], 1
    jmp exit

; adaugarea pentru coltul din dreapta, jos
no_down_no_right:
    add edx, 7
    mov byte [ecx + edx], 1
    jmp exit

; adaugarea pentru coltul din stanga, jos
no_left_no_down:
    add edx, 9
    mov byte [ecx + edx], 1
    jmp exit

; iesirea din program
exit:
    popa
    leave
    ret
