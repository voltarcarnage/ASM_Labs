/*  var 147
    size of numbers - 32 signed
    Insertion sort with binary search*/
.arch armv8-a
    .data
    .align 3
matrix:
    .word 1, 2, 5, 6
    .word 3, 4, 20, 18
    .word 5, 7, 9, 11
    .word 25, 23, 21, 19
n:
    .byte 4

    .text
    .align 2
    .globl _start
    .type _start, %function
_start:
    adr x0, n
    ldrb w1, [x0] //n size of matrix x0
    adr x2, matrix //matrix adr x1
    mov x3, #2 //x3 = 2 x28
    sub x4, x1, #1 //n-1 x27
    mov x5, #0 //x5 = i x2
    mul x6, x1, x1 //max size x26

//first loop
_L0:
    add x5, x5, #1 //i = i + 1
    cmp x5, x1
    BGE _L4 //if i >= n exit
    mov x7, #0 //j
    add x9, x5, #1 //one diag amount

//second loop
_L1:
    mov x10, x7 // m and j, m = j
    add x7, x7, #1 //j += 1
    cmp x7, x9 // j <= amount in diag
    BGE _L0 //b to new diagonal
    mul x11, x7, x4 //bin search x11 = (n-1)j
    add x11, x11, x5 // x11 *= i (n-1)j + i
    lsl x19, x11, #2
    ldrsw x12, [x2, x19]
    //ldr x12, [x2, x11, lsl #2] //matr[x11]
    mov x13, #0
    mov x14, x7
    B   _search

//Insertion sort
_L2:
    add x15, x10, #1 // p = m + 1
    cmp x15, x16 // ?
    BEQ _L3
    mul x11, x4, x10 // x11 = i * k? x11 = (n-1)*k (x5,10)
    add x11, x11, x5 // x11 + i
    lsl x19, x11, #2
    ldrsw x20, [x2, x19] //x20 = matr[x11]
    //ldr x20, [x2, x11, lsl #3]
    mul x11, x15, x4
    add x11, x11, x5 // x11 + i
    lsl x19, x11, #2
    str w20, [x2, x19] //matr[x11] = x6
    //str x20, [x2, x11, lsl #3]
    sub x10, x10, #1 // k -= 1
    B   _L2

_L3:
    mov x11, x16
    mul x11, x11, x4
    add x11, x11, x5
    lsl x19, x11, #2
    str w12, [x2, x19] //matr[x11] = x12
    //str x12, [x2, x11 ,lsl #3]
    B _L1

_L4:
    add x5, x5, x4 // x5 = 1 + n - 1 = n
    cmp x5, x6
    BGE _exit
    mov x7, #0
    udiv x9, x5, x1
    sub x9, x1, x9
    B _L1

_search:
    cmp x13, x14 //x13 = left, x14 = right
    BGE _searchEnd
    add x8, x13, x14 // x8 = left + right
    udiv x16, x8, x3 // x16 = mid = (left + right) / 2
    mul x11, x4, x16 // x11 = mid * (n-1)
    add x11, x11, x5 // x11 += i
    lsl x19, x11, #2
    ldrsw x17, [x2, x19] //x17 = matr[x11]
    //ldr x17, [x2, x11, lsl #3]
    cmp x17, x12 // x12 - element of search
    BEQ _searchRet // x17 == x15
    .ifdef opposite
    BLT _searchLes //x17 < x12
    B   _searchGre //x17 > x12
    .else
    BLT _searchGre //x17 > x12
    B   _searchLes //x17 < x12
    .endif

_searchLes:
    add x13, x16, #1
    B   _search

_searchGre:
    mov x14, x16
    B   _search

_searchEnd:
    mov x16, x14

_searchRet:
    B   _L2

_exit:
    mov x0, #0
    mov x8, #93
    svc #0

.size _start, .-_start
