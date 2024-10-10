.data
    matrix: .space 1600
    vector: .space 1600
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
    pointer_input: .long 0
    pointer_output: .long 0
    input: .asciz "in.txt"
    output: .asciz "output.txt"
    r: .ascii "r"
    w: .ascii "w"
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d "
    enter: .asciz "\n"
.text
.global main
main:

    push $w
    push $output
    call fopen
    pop %ebx
    pop %ebx
    
    mov %eax, pointer_output

    push $r
    push $input
    call fopen
    pop %ebx
    pop %ebx
    
    movl %eax, pointer_input
    
    pushl $m
    push $formatScanf
    push pointer_input
    call fscanf
    addl $12, %esp
    
    movl m, %ebx
    movl %ebx, auxm
    incl auxm
    
    push $n
    push $formatScanf
    push pointer_input
    call fscanf
    add $12, %esp
    
    movl n, %ebx
    movl %ebx, auxn
    incl auxn       #incrementare doar cu 1 pentru ca nu trebuie sa verific 
                    #ultima coloana
    
    push $p
    push $formatScanf
    push pointer_input
    call fscanf
    add $12, %esp
    
    movl $0, index
    lea matrix, %edi
    addl $2, n
    
for_p:
    movl index, %ecx
    cmp %ecx, p
    je for_k
    
    push $left
    push $formatScanf
    push pointer_input
    call fscanf
    add $12, %esp
    
    push $right
    push $formatScanf
    push pointer_input
    call fscanf
    add $12, %esp
    
    incl left
    incl right
    
    xorl %edx, %edx
    movl left, %eax
    mull n
    addl right, %eax
    
    movl $1, (%edi, %eax, 4)
    
    incl index
    jmp for_p

for_k:
    push $k
    push $formatScanf
    push pointer_input
    call fscanf
    add $12, %esp
    
    movl k, %ecx
    cmp $0, %ecx
    je afisare   
           
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

afisare:
    movl $1, lineIndex
    lea matrix, %edi
    for_lines:
        movl lineIndex, %ecx
        cmp %ecx, auxm
        je exit
        
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
            
            push %ebx
            push $formatPrintf
            push pointer_output
            call fprintf
            add $12, %esp
            
            pushl $0
            call fflush
            popl %ebx
            
            incl columnIndex
            jmp for_columns
        
        cont:
            push $enter
            push pointer_output
            call fprintf
            add $8, %esp
            
            incl lineIndex
            jmp for_lines

exit:
    mov $1, %eax
    xorl %ebx, %ebx
    int $0x80