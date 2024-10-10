.data
    matrix: .space 1600
    vector: .space 1600
    parola: .space 1600
    columnIndex: .space 4
    lineIndex: .space 4
    n: .space 4
    m: .space 4
    p: .space 4
    k: .space 4
    auxn: .space 4
    auxm: .space 4
    index: .space 4
    left: .space 4
    right: .space 4
    vecini: .space 4
    o: .space 4
    mesaj: .space 20
    len_mesaj: .space 4
    litera: .space 4
    len_parola: .space 4    
    len_cheie: .space 4
    numar: .space 4
    inceput: .asciz "0x"
    hexa: .asciz "0123456789ABCDEF"
    formatScanf: .asciz "%d"
    mesajScanf: .asciz "%s"
    formatPrintf: .asciz "%d "
    mesajPrintf: .asciz "%c"
    enter: .asciz "\n"
.text
.global main
main:

    pushl $m
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    movl m, %ebx
    movl %ebx, auxm
    incl auxm
    
    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    movl n, %ebx
    movl %ebx, auxn
    incl auxn       #incrementare doar cu 1 pentru ca nu trebuie sa verific 
                    #ultima coloana
    
    pushl $p
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    movl $0, index
    lea matrix, %edi
    addl $2, n
    
for_p:
    movl index, %ecx
    cmp %ecx, p
    je continuare_for_p
    
    pushl $left
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    push $right
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    incl left
    incl right
    
    xorl %edx, %edx
    movl left, %eax
    mull n
    addl right, %eax
    
    movl $1, (%edi, %eax, 4)
    
    incl index
    jmp for_p

continuare_for_p:
    pushl $k
    pushl $formatScanf
    call scanf
    addl $8, %esp

for_k:
    
    movl k, %ecx
    cmp $0, %ecx
    je afisare_matrice
           
    count_vecini:
        movl $1, lineIndex
        lea matrix, %edi
        lea vector, %esi
        movl $0, index
        
        for_l:
            movl lineIndex, %ecx
            cmp %ecx, auxm
            je evolutie
        
            movl $1, columnIndex
  
            for_c:
                movl $0, vecini
                movl columnIndex, %ecx
                cmp %ecx, auxn
                je continuare_for_l
            
                movl lineIndex, %eax
                xorl %edx, %edx
                mull n
                addl columnIndex, %eax
            
                incl %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                addl n, %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                decl %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                decl %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                subl n, %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                subl n, %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                incl %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                incl %eax
                movl (%edi, %eax, 4), %ebx
                addl %ebx, vecini
            
                movl index, %eax
                movl vecini, %ebx
                movl %ebx, (%esi, %eax, 4)
                incl index
            
                incl columnIndex
                jmp for_c
            
            continuare_for_l:
                incl lineIndex
                jmp for_l
            
    evolutie:
        lea vector, %esi
        lea matrix, %edi
        movl $1, lineIndex
        movl $0, index
        
        for_lin:
            movl lineIndex, %ecx
            cmp %ecx, auxm
            je continuare_evolutie
        
            movl $1, columnIndex
            
            for_col:
                movl columnIndex, %ecx
                cmp %ecx, auxn
                je continuare_for_lin
            
                movl lineIndex, %eax
                xorl %edx, %edx
                mull n
                addl columnIndex, %eax
            
                movl index, %ecx
                movl (%esi, %ecx, 4), %ebx
                movl (%edi, %eax, 4), %edx
            
                cmp $1, %edx
                jne zero
            
                cmp $2, %ebx        #subpopulare
                jge next1
                movl $0, (%edi, %eax, 4)
                jmp gata
            
            next1:
                cmp $3, %ebx        #ultrapopulare
                jle gata
                movl $0, (%edi, %eax, 4)
                jmp gata
            
            zero:
                cmp $3, %ebx
                jne gata
                movl $1, (%edi, %eax, 4)
            
            gata:
                incl index
                incl columnIndex
                jmp for_col
            
            continuare_for_lin:
                incl lineIndex
                jmp for_lin
    
    continuare_evolutie:
        decl k
        jmp for_k

afisare_matrice:
    movl $1, lineIndex
    lea matrix, %edi
    for_lines:
        movl lineIndex, %ecx
        cmp %ecx, auxm
        je cerinta_0x01
        
        movl $1, columnIndex
        
        for_columns:
            movl columnIndex, %ecx
            cmp %ecx, auxn
            je cont
            
            movl lineIndex, %eax
            xorl %edx, %edx
            mull n
            addl columnIndex, %eax
            
            movl (%edi, %eax, 4), %ebx
            
            pushl %ebx
            pushl $formatPrintf
            call printf
            addl $8, %esp
            
            pushl $0
            call fflush
            popl %ebx
            
            incl columnIndex
            jmp for_columns
        
        cont:
            movl $4, %eax
            movl $1, %ebx
            movl $enter, %ecx
            movl $2, %edx
            int $0x80
            
            incl lineIndex
            jmp for_lines

cerinta_0x01:
    pushl $o
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    pushl $mesaj
    push $mesajScanf
    call scanf
    addl $8, %esp
    
    pushl $mesaj
    call strlen
    addl $4, %esp
    movl %eax, len_mesaj

movl o, %ebx
cmp $1, %ebx
je decriptare

lungime_cheie:
    lea matrix, %edi
    
    movl len_mesaj, %eax
    movl $8, %ebx
    xor %edx, %edx
    mull %ebx
    movl %eax, len_parola

    movl m, %eax
    addl $2, %eax
    movl n, %ebx
    mull %ebx
    movl %eax, len_cheie
    movl %eax, index
    
    for_cheie:
        movl index, %ecx
        cmp len_parola, %ecx
        jge for_xor
        
        subl len_cheie, %ecx
        movl (%edi, %ecx, 4), %ebx
        
        addl len_cheie, %ecx
        movl %ebx, (%edi, %ecx, 4)
        
        incl index
        jmp for_cheie

for_xor:
    movl len_parola, %ebx
    movl %ebx, len_cheie
    
    lea mesaj, %esi
    lea matrix, %edi
    
    movl $0, index
    
    for_litere:
        xor %edx, %edx
        movl index, %eax
        addl $1, %eax
        movl $8, %ebx
        mull %ebx
        movl %eax, len_parola
        
        movl index, %ecx
        cmp %ecx, len_mesaj
        je binar_to_hexa
        
        movb (%esi, %ecx, 1), %al
        mov %eax, litera 
        
        for_binar:
            cmp $0, %eax
            je continuare_for_litere
            
            movl $2, %ebx
            xor %edx, %edx
            divl %ebx
            
            decl len_parola
            movl len_parola, %ecx
            movl (%edi, %ecx, 4), %ebx
            
            xorl %edx, %ebx
            movl %ebx, (%edi, %ecx, 4)
            
            jmp for_binar
            
        continuare_for_litere:
            incl index
            jmp for_litere
        
binar_to_hexa:
    movl $4, %eax
    movl $1, %ebx
    movl $inceput, %ecx
    movl $3, %edx
    int $0x80
    
    movl $0, index
    lea matrix, %edi
    lea hexa, %esi
    
    for_transformare:
        movl $0, numar
        movl index, %ecx
        cmp %ecx, len_cheie
        je exit
        
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $8, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $4, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $2, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        movl (%edi, %ecx, 4), %ebx
        addl %ebx, numar
        
        movl %ecx, index
        movl numar, %ecx
        movb (%esi, %ecx, 1), %al
        
        push %eax
        push $mesajPrintf
        call printf
        addl $8, %esp
        
        push $0
        call fflush
        pop %ebx
        
        incl index
        jmp for_transformare

decriptare:

    movl len_mesaj, %eax
    subl $2, %eax
    movl $4, %ebx
    xor %edx, %edx
    mull %ebx
    movl %eax, len_parola

    movl m, %eax
    addl $2, %eax
    movl n, %ebx
    mull %ebx
    movl %eax, len_cheie
    movl %eax, index

    for_cheie2:
        movl index, %ecx
        cmp len_parola, %ecx
        jge continuare_decriptare
        
        subl len_cheie, %ecx
        movl (%edi, %ecx, 4), %ebx
        
        addl len_cheie, %ecx
        movl %ebx, (%edi, %ecx, 4)
        
        incl index
        jmp for_cheie2

continuare_decriptare:

movl len_parola, %ebx
movl %ebx, len_cheie
movl $2, index
lea mesaj, %esi
    
for_hexa:
    movl index, %ecx
    cmp len_mesaj, %ecx
    je afisare
        
    movl $4, %ebx
    movl index, %eax
    decl %eax
    mull %ebx
    movl %eax, len_parola
    
    movb (%esi, %ecx, 1), %al
        
    cmp $65, %eax
    jge literaa
    
    subl $48, %eax
    jmp for_hexa_to_binar
        
    literaa:
    subl $55, %eax
            
    for_hexa_to_binar:
        cmp $0, %eax
        je continuare_for_hexa
        
        xor %edx, %edx
        movl $2, %ebx
        divl %ebx
        
        decl len_parola
        movl len_parola, %ecx
        movl (%edi, %ecx, 4), %ebx
        
        xorl %edx, %ebx
        movl %ebx, (%edi, %ecx, 4)
        
        jmp for_hexa_to_binar 
                
    continuare_for_hexa:
        
        incl index
        jmp for_hexa
      
      
afisare:
    movl $0, index
    fro:
        movl index, %ecx
        cmp %ecx, len_cheie
        je for_cuvant
        
        movl (%edi, %ecx, 4), %ebx
        push %ebx
        push $formatPrintf
        call printf
        addl $8, %esp
        
        push $0
        call fflush
        pop %ebx
        
        incl index
        jmp fro
      
        
for_cuvant:
    movl $0, index
    
    for_parcurgere:
        movl $0, numar
        movl index, %ecx
        cmp len_cheie, %ecx
        je exit
        
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $128, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $64, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $32, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $16, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $8, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $4, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        xor %edx, %edx
        movl (%edi, %ecx, 4), %ebx
        movl $2, %eax
        mull %ebx
        addl %eax, numar
        
        incl %ecx
        movl (%edi, %ecx, 4), %ebx
        addl %ebx, numar
        
        movl %ecx, index
        movl numar, %eax
        
        push %eax
        push $mesajPrintf
        call printf
        addl $8, %esp
        
        push $0
        call fflush
        pop %ebx
        
        incl index
        jmp for_parcurgere

exit: 
    movl $4, %eax
    movl $1, %ebx
    movl $enter, %ecx
    movl $2, %edx
    int $0x80    
    
    push $0
    call fflush
    pop %ebx
        
    mov $1, %eax
    xorl %ebx, %ebx
    int $0x80
