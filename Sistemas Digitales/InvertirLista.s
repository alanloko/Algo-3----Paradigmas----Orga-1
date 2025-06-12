{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 .data\
    lista:\
        .word 20,39,47,55,10,0,-1\
.text\
main: \
    la a0, lista   # Carga la direcci\'f3n de 'lista' en a0\
    li a1, 7\
    slli a1, a1, 2\
    jal ra, InvertirArreglo\
    li a2, 1\
    bne a0, a2, noFunciona\
funciona: \
    li a1, 1\
    j fin\
noFunciona: \
    li a1, 0\
fin: \
    j fin\
\
InvertirArreglo: \
    addi sp, sp, -12\
    sw a0, (0)sp\
    sw a1, (4)sp\
    sw ra, (8)sp\
    addi t0, x0, 0\
loop:\
    lw a0, (0)sp # cargo el puntero a la lista\
    add a0, a0, t0\
    lw a0, (0)a0 # cargo en a0, el valor que se ubica en el puntero de a0\
    jal ra, invx # a0 = -a0\
    mv a2, a0 # a2 = -a0\
    lw a0, (0)sp # cargo el puntero de la lista\
    add a0, a0, t0 # desplazo al i-esimo elemento\
    sw a2, (0)a0 # guardo -a0 en el puntero del i-esimo elemento\
    addi t0, t0, 4 # avanzo a i + 1\
    bne t0, a1, loop # si i < n loop sino termina\
    #\
    lw a0, (0)sp\
    lw a1, (4)sp\
    lw ra, (8)sp\
    addi sp, sp, 12\
    ret \
\
invx: \
    addi sp, sp, -8\
    sw s0, (0)sp\
    sw ra, (4)sp\
    not s0, a0\
    addi s0, s0, 1\
    mv a0, s0\
    lw s0, (0)sp\
    lw ra, (4)sp\
    addi sp, sp, 8\
    ret\
}