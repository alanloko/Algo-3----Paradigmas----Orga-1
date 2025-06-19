Ej 1:

es_primo:
    addi sp, sp, -16
    sw ra, (0)sp
    jal cantidad_divisores
    addi t0, x0, 1
    beq a0, t0, esPrimo
    j noEsPrimo

esPrimo:
    j returEs_Primo

noEsPrimo:
    addi a0, a0, 0
    j returnEs_Primo

returnEs_Primo:
    lw ra, (0)sp
    addi sp, sp, 16
    ret
    


cantidad_divisores:
    addi sp, sp, -16
    sw ra, (0)sp
    addi a1, a0, 0
    ble a0, t0, casobase
    addi a1, a1, -1
    jal cantidad_divisores_rec
    j return

return:
    lw ra, (0)sp
    addi sp, sp, 16
    ret

casobase:
    addi a0, x0, 1
    j return


cantidad_divisores_rec:
    addi sp, sp, -16
    sw s0, (4)sp # k
    sw s1, (8)sp # n
    sw ra, (0)sp
    mv s0, a0
    mv s1, a1

    addi t0, x0, 1
    beq s1, t0, casobaseRec

    jal cant_divisores_rec
    rem t0, s0, s1
    beqz t0, suma1Div
    j returnRec

casobaseRec:
    addi a0, x0, 0
    j returnRec

suma1Div:
    addi a0, a0, 1
    j returnRec

returnRec:
    lw ra, (0)sp
    lw s0, (4)sp # k
    lw s1, (8)sp # n
    addi sp, sp, 16
    ret

Ej 2:

.data
    lista:
        .word 1,2,3,4,5,6,7,8
.text
main: 
    la a0, lista   # Carga la dirección de 'lista' en a0
    li a1, 8
    jal arreglo_par
    
    
fin:
    j fin

arreglo_par:
    addi sp, sp, -16
    sw a0, (0)sp
    sw a1, (4)sp
    sw s0, (8)sp
    sw ra, (12)sp

    addi s0, x0, 0
    
loop:
    lw a0, (0)sp
    mv t1, a1
    slli t1, t1, 2
    beq s0, t1, return
    add a0, a0, s0
    lw a0, (0)a0
    jal es_par
    mv t2, a0
    lw a0, (0)sp
    add a0, a0, s0
    sw t2, (0)a0
    addi s0, s0, 4
    j loop

return:
    lw a0, (0)sp
    lw a1, (4)sp
    lw s0, (8)sp
    lw ra, (12)sp
    addi sp, sp, 16
    ret

es_par:
    addi sp, sp, -16
    sw ra, (12)sp

    li t0, 1
    and a0, a0, t0
    bnez a0, noPar
    addi a0, x0, 1
    j retPar
    
noPar:
    addi a0, x0, 0
    j retPar

retPar:
    lw ra, (12)sp
    addi sp, sp, 16
    ret

Ej 3:
a:
cantBytesDeudores:
    addi sp, sp, -16
    sw a0, (0)sp
    sw ra, (12)sp

    addi t0, x0, 0

loop:
    lw t1, (0)a0
    beqz t1, return
    addi a0, a0, 5
    addi t0, t0, 5
    j loop

return:
    mv a0, t0
    lw ra, (12)sp
    addi sp, sp, 16
    ret

b:

contarDeudores:
    addi sp, sp, -16
    sw a0, (0)sp
    sw s0, (4)sp
    sw ra, (12)sp

    addi s0l x0, 0
    addi t0, x0, 1
    addi t1, x0, 2

loop:
    lb a1, (0)a0
    beqz a1, return
    add a0, a0, t0 # avanzo al puntero de Consumos
    lh t2, (0)a0 # cargo el valor de consumos en t2
    add a0, a0, t1
    lh t3, (0)a0 # cargo el valor de pagos en t3
    bgt t2, t3, esDeudor
seguirLoop:
    add a0, a0, t1 # avanzo al siguiente ID
    j loop

esDeudor: 
    addi s0, s0, 1
    j seguirLoop

return: 
    mv a0, s0
    lw s0, (4)sp
    lw ra, (12)sp
    addi sp, sp, 16
    ret

