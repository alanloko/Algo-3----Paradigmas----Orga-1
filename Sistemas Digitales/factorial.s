.data
    n:
        .word 5
.text
main: 
    lw a0, n   # Carga n en a0
    jal ra, factorial
funciona: 
    j fin
noFunciona: 
    li a1, 0
fin: 
    j fin

factorial: 
    addi sp, sp, -16
    sw a0, (0)sp # n
    sw ra, (12)sp
    
    #
    
    beqz a0, casobase1

recursion:
    addi a0, a0, -1 # n - 1
    jal factorial # factorial(n -1)
    lw a1, (0)sp # n
    jal multiplicar # n*factorial(n-1)
    j return
    
casobase1:
    addi a0, x0, 1
    j return


return:
    lw s0, (4)sp
    lw ra, (12)sp
    addi sp, sp, 16
    ret 


multiplicar:
    addi sp, sp, -16
    sw a0, (0)sp # n
    sw a1, (4)sp # m
    sw ra, (12)sp
    
    addi t0, a0, 0
    addi a0, x0, 0 # inicializas n en 0
loop:
    beqz a1, returnMultiplicar # si m es = 0, return
    add a0, a0, t0 # a0 + n, m veces 
    addi a1, a1, -1 # m - 1
    j loop # se repite hasta m = 0
    

returnMultiplicar:
    lw a1, (4)sp
    lw ra, (12)sp
    addi sp, sp, 16
    ret 
