  .arch armv8-a
  .text
  .align 2
  .global resize_Asm
  .type resize_Asm, %function
  .equ  inputData, 16
  .equ  temp, 24
  .equ  width1,   32
  .equ  height1, 40
  .equ  width2, 48
  .equ  height2, 56
  .equ  channels, 64
  /*
  x0 - adr inputData
  x1 - adr temp
  x2 - w1
  x3 - h1
  x4 - w2
  x5 - h2
  x6 - channels
  */
resize_Asm:
    sub sp, sp, #68
    stp x29, x30, [sp]
    mov x29, sp
    lsl x7, x2, #16 // x7 = w1 << 16
    udiv x8, x7, x4 // x8 = (w1 << 16) / w2
    add x8, x8, #1 // x8 += 1 / x8 = (w1 << 16)/w2 + 1 // x_ratio
    lsl x9, x3, #16 // x9 = h1 << 16
    udiv x10, x9, x5 // x10 = (h1 << 16) / h2
    add x10, x10, #1 // x10 = (h1 << 16) / h2 + 1 // y_ratio
    mov x20, #0 // i
    mov x21, #0 // j
    mov x22, #0 // k
0:

    mul x11, x21, x8 // x11 = (j * x_ratio)
    lsr x11, x11, #16 // x11 = x11 >> 16 // px
    mul x12, x20, x10 // x12 = (i * y_ratio)
    lsr x12, x12, #16 // x12 = x12 >> 16 // py
    mul x13, x20, x6 // x13 = i * channels
    mul x13, x13, x4 // x13 = i * channels * w2
    mul x14, x21, x6 // x14 = j * channels
    add x13, x13, x14 // x13 = i * channels * w2 + j * channels
    add x13, x13, x22 // x13 = i * channels * w2 + j * channels + k
    mul x15, x12, x6 // x15 = py * channels
    mul x15, x15, x2 // x15 = py * channels * w1
    mul x16, x11, x6 // x16 = px * channels
    add x15, x15, x16 // x15 = py * channels * w1 + px * channels
    add x15, x15, x22 // x15 = py * channels * w1 + px * channels + k
    sub x27, x15, x22
    ldr w28, [x0, x27]
    ror w28, w28, #6
    str w28, [x0, x27]
    ldrb w17, [x0, x15]
    strb w17, [x1, x13]
1:
    add x22, x22, #1
    cmp x22, x6
    beq 2f
    b 0b
2:
    add x21, x21, #1
    mov x22, #0
    cmp x21, x4
    beq 3f
    b 0b
3:
    add x20, x20, #1
    mov x21, #0
    mov x22, #0
    cmp x20, x5
    beq 4f
    b 0b
4:
    ldp x29, x30, [sp]
    add sp, sp, #68
    ret
    .size resize_Asm, .-resize_Asm
