.arch armv8-a
    .data
errmsg1:
    .asciz "Usage: ./task3 _filename_\n"
    .equ    errlen1, .-errmsg1
dictionary:
    .string "bBcCdDfFgGjJkKlLmMnNpPqQsStTvVxXzZhHrRwWyY"
    .equ    dictlen, .-dictionary
    .text
    .align 2
    .globl _start
    .type  _start, %function
_start:
    ldr x0, [sp]//argc
    cmp x0, #2
    beq 2f
1:
    mov x0, #2
    adr x1, errmsg1
    mov x2, errlen1
    mov x8, #64
    svc     #0
    mov x0, #1
    b _exit
2:
    ldr x0, [sp, #16]
    bl _main
    mov x0, #0
    b  _exit
_exit:
    mov x8, #93
    svc     #0
    .size   _start, .-_start
    .type   _main, %function
    .text
    .align  2
    .equ    filename, 16
    .equ    fd, 24
    .equ    counter1, 32
    .equ    counter2, 40
    .equ    buf, 48
    .equ    len, 3
    .equ    bufres, 51
    .equ    stksz, 54
_main:
    mov x16, stksz
    sub sp,  sp, x16
    stp x29, x30, [sp]
    mov x29, sp
    str x0,  [x29, filename]
    mov x1,  x0
    mov x0,  #-100
    mov x2,  0x0
    mov x3,  0600
    mov x8,  #56
    svc      #0
    cmp x0,  #0
    bgt      0f
    bl       _writeerr
    b        4f
0:
    str x0, [x29, fd]
    //mov x16, #0
    //ldr x16, [x29, counter1]
1:
    mov x12, x29
    add x12, x12, bufres
    ldr x0, [x29, fd]
    mov x1, x29
    add x1, x1, buf
    mov x2, len
    mov x8, #63
    svc     #0
    mov x21, x0
    cmp x0, #0
    beq     2f
    bgt     3f
/*17:
    ldr x18, [x29, counter2]
    ldr x19, [x29, counter]
    add x18, x19, x18
    cmp x18, #0
    beq 3f
    b 9f
    //cmp x18, #1
    //bne 9f
    //ldr x18, [x29, counter]
    //cmp x18, #0
    //beq 3f
    //b   9f
*/2:
    ldr x0, [x29,fd]
    mov x8, #57
    svc     #0
4:
    ldp x29, x30, [sp]
    mov x16, stksz
    add sp, sp, x16
    ret
9:
    mov x16, x29
    add x16, x16, buf
    sub x16, x1, x16
    //sub x16, x16, #1
    cmp x21, x16
    beq 8f
    //ldr x16, [x29, counter]
    //cmp x16, #-1
    //beq 3f
    ldrb w9, [x1], #1
    cmp w9, ' '
    beq 9b
    cmp w9, '\t'
    beq 9b
    //mov x16, #0
    //str x16, [x29, counter1]
    b 11f
14:
    add x1, x1, #1
    //mov x16, #0
    //ldr x16, [x29, counter]
    b 9b
11:
    sub x1, x1, #1
    b 3f
3:
    //mov x16, #0
    //str x16, [x29, counter]
    //mov x18, #0
    //str x18, [x29, counter2]
    adr x0, dictionary
    b   5f
5:
    //mov x16, #0
    //str x16, [x29, counter]
    mov x16, x29
    add x16, x16, buf
    sub x16, x1, x16
    cmp x21, x16
    beq 8f
    ldrb w9, [x1]
    ldrb w11, [x0], #1
    cmp w9, w11
    beq 6f
    cmp w11, #0
    beq 7f
    cmp w9, ' '
    beq 10f
    cmp w9, '\n'
    beq 12f
    cmp w9, '\t'
    beq 10f
    cmp w9, #0
    beq 8f
    b   5b
6:
    add x1, x1, #1
    adr x0, dictionary
    b 5b
10:
    ldr x18, [x29, counter2]
    cmp x18, #1
    bne 6b
    add x1, x1, #1
    adr x0, dictionary
    mov x18, #1 //if end of word put counter1
    mov x24, #0
    str x24, [x29, counter2] //for glasnie
    str x18, [x29, counter1] //for spaces
    b 5b
7:
    ldr x19, [x29, counter1]
    //ldr x18, [x29, counter2]
    //add x18, x18, x19
    cmp x19, #1
    beq 13f
    mov x19, #1
    str x19, [x29, counter2]
    strb w9, [x12]
    add x12, x12, #1
    add x1, x1, #1
    adr x0, dictionary
    b 5b
13:
    mov x18, #0
    str x18, [x29, counter1]
    mov x18, #1
    str x18, [x29, counter2]
    mov w17, ' '
    strb w17, [x12]
    add x12, x12, #1
    strb w9, [x12]
    add x12, x12, #1
    add x1, x1, #1
    adr x0, dictionary
    b 5b
12:
    str w9, [x12]
    add x12, x12, #1
    add x1, x1, #1
    adr x0, dictionary
    mov x18, #0
    str x18, [x29, counter1]
    str x18, [x29, counter2]
    b 9b
/*12:
    mov  x16, x12
    sub  x16, x16, #1
    ldrb w18, [x16]
    cmp w18, ' '
    beq 13f
    strb w9,  [x12]
    add  x1, x1, #1
    add  x12, x12, #1
    //mov x16, #0
    //str x16, [x29, counter]
    b   9b
13:
    //add x12, x12, #1
    strb w9,  [x16]
    add  x1, x1, #1
    b   5b
//15:
    //sub x1, x1, #1
    //b 9b
10:
    ldr x16, [x29, counter]
    //cmp x16, #-1
    //beq 15b
    //ldr x16, [x29, counter]
    cmp x16, #-1
    bne 9b
    mov w17, ' '
    str w17, [x12]
    add x12, x12, #1
    add x1,  x1,   #1
    //mov x16, #-1
    //str x16, [x29, counter]
    b 9b
6:
    //mov x17, x29
    //add x17, x17, buf
    //sub x17, x1, x17
    //cmp x17, #0
    //beq 14b
    //mov x16, #-1
    //str x16, [x29, counter]
    //ldr x16, [x29, counter]
    //cmp x16, #-1
    //beq 15b
    add x1, x1, #1
    adr x0, dictionary
    //ldrb w13, [x1] uncoment if something goes wrong)
    //cmp w13, ' '
    //beq 10b
    //cmp w13, '\t'
    //beq 10b
    b   5b
7:
    mov x16, #-1
    str x16, [x29, counter]
    str w9,  [x12]
    add x12, x12, #1
    add x1, x1,   #1
    adr x0, dictionary
    b   5b
18:
    cmp w9, ' '
    bne 19f
    mov x18, #0
    str x18, [x29, counter2]
    b 8f
19:
    mov x18, #1
    str x18, [x29, counter2]
    b 8f
*/8:
    sub x13, x12, x29
    sub x13, x13, bufres
    mov x2, x13 // amount of symb
    mov x0, #1 //stdout
    mov x13, x29
    add x13, x13, bufres
    mov x1, x13 //addr of bufres
    mov x8, #64
    svc #0
    b 1b
    .size   _main, .-_main
    .type   _writeerr, %function
    .data
nofile:
    .string "No such file or directory\n"
    .equ    nofilelen, .-nofile
permission:
    .string "Permission denied\n"
    .equ    permissionlen, .-permission
unknown:
    .string "Unknown error\n"
    .equ    unknownlen, .-unknown
    .text
    .align 2
_writeerr:
    cmp x0, #-2
    bne 0f
    adr x1, nofile
    mov x2, nofilelen
    b   2f
0:
    cmp x0, #-13
    bne 1f
    adr x1, permission
    mov x2, permissionlen
    b   2f
1:
    adr x1, unknown
    mov x2, unknownlen
2:
    mov x0, #2
    mov x8, #64
    svc     #0
    ret
    .size _writeerr, .-_writeerr
