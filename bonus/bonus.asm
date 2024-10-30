section .data

section .text
    global bonus

bonus:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

; verificarea principala in care am
; considerat eax adresa liniei cu nr 4,
; astfel eax + 4 va fi linia 0 (inferioara) 
verify:
    ; pregatim registrii pentru shiftare
    xor edx, edx
    mov edx, 1
    push ecx
    mov ecx, ebx

    ; facem shiftarea astfel incat, in binar
    ; edx sa contina 1 pe pozitia din stanga
    ; piesei
    sub ecx, 1
    shl edx, cl
    pop ecx

    ; verificarea cazurilor speciale
    cmp eax, 0
    je no_down

    cmp eax, 7
    je no_up

    cmp ebx, 0
    je no_left

    cmp ebx, 7
    je no_right

    ; verificam daca dama se afla pe pozitiile din
    ; mijlocul tablei, fapt pentru care trebuie sa
    ; modificam valorile ambelor elemente din vector
    cmp eax, 4
    je upper_simple
    
    cmp eax, 3
    je lower_simple

    
   jmp exit


upper_simple:
    ; ne pozitionam pe linia superioara
    ; liniei pe care se afla piesa
    sub eax, 4
    add eax, 1

    ; adaugam valoarea lui edx pentru
    ; a transforma in 1 elementul de pe
    ; pozitia dorita
    add [ecx + eax], edx

    ; shiftam pentru a transforma
    ; in 1 elementul cu 2 pozitii spre
    ; dreapta de pe linie
    shl edx, 2
    add [ecx + eax], edx

    ; ne pozitionam pe linia inferioara
    ; liniei pe care se afla piesa
    add eax, 3
    add eax, 3

    add [ecx + eax], edx
    shr edx, 2
    add [ecx + eax], edx

    jmp exit

lower_simple:
    ; ne pozitionam pe linia inferioara
    ; liniei pe care se afla piesa
    add eax, 3
    add [ecx + eax], edx
    shl edx, 2
    add [ecx + eax], edx

    ; ne pozitionam pe linia superioara
    ; liniei pe care se afla piesa
    add [ecx], edx
    shr edx, 2
    add [ecx], edx
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
    add [ecx + 2], edx
    
    shl edx, 2
    add [ecx + 2], edx

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
    add [ecx + 5], edx
    
    shl edx, 2
    add [ecx + 5], edx

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

    ; verificam daca dama se afla in partea
    ; superioara, respectiv inferioara a tablei
    cmp eax, 4
    jg no_left_upper_simple
    
    cmp eax, 3
    jl no_left_lower_simple

    jmp exit

; adaugarea pentru coloana din stanga
; in cazul in care dama in partea superioara
no_left_upper_simple:
    shl edx, 2
    sub eax, 4
    mov [ecx], edx
    sub eax, 1
    mov byte [ecx + eax], 2
    add eax, 2
    mov byte [ecx + eax], 2
    jmp exit

; adaugarea pentru coloana din stanga
; in cazul in care dama in partea inferioara
no_left_lower_simple:
    sub eax, 1
    add eax, 4

    ; setam cu 1 elementele din matrice de pe coloana
    ; cu index 1 (pentru linia superioara si cea inferioara
    ; liniei pe care se afla piesa)
    add byte [ecx + eax], 2
    add eax, 2
    add byte [ecx + eax], 2
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

    ; verificam daca dama se afla in partea
    ; superioara, respectiv inferioara a tablei
    cmp eax, 4
    jg no_right_upper_simple
    
    cmp eax, 3
    jl no_right_lower_simple
    
    jmp exit


; adaugarea pentru coloana din dreapta
; in cazul in care dama in partea superioara
no_right_upper_simple:
    ; setam cu 1 elementele din matrice de pe coloana
    ; cu index 7 (pentru linia superioara si cea inferioara
    ; liniei pe care se afla piesa)
    sub eax, 4
    sub eax, 1
    mov byte [ecx + eax], 64
    add eax, 2
    mov byte [ecx + eax], 64
    jmp exit

; adaugarea pentru coloana din dreapta
; in cazul in care dama in partea inferioara
no_right_lower_simple:
    add eax, 3
    add byte [ecx + eax], 64
    add eax, 2
    add byte [ecx + eax], 64
    jmp exit

; adaugarea pentru coltul din stanga, sus
no_up_no_left:
    mov byte [ecx + 2], 2
    jmp exit

; adaugarea pentru coltul din dreapta, sus
no_up_no_right:
    mov byte [ecx + 2], 64
    jmp exit

; adaugarea pentru coltul din dreapta, jos
no_down_no_right: 
    mov byte [ecx + 5], 64
    jmp exit

; adaugarea pentru coltul din stanga, jos
no_left_no_down:
    mov byte [ecx + 5], 2
    jmp exit

; iesirea din program
exit:
    popa
    leave
    ret
