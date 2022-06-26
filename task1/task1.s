/* variant 27
   signed res: (a*c/b + d*b/e - c^2/a*d)
   size of a - 32
   size of b - 16
   size of c - 32
   size of d - 16
   size of e - 32 */

   .data
   .align 3
res:
  .skip 8
a:
  .4byte 1
c:
  .4byte 1
e:
  .4byte 1
b:
  .2byte -32
d:
  .2byte 4

  .text
  .align 2
  .globl _start
  .type _start,%function
_start:
  adr x0, a
  ldrsw x1, [x0]//a
  adr x0, b
  ldrsh w2, [x0]//b
  CBZ w2, _exception
  adr x0, c
  ldrsw x3, [x0]//c
  adr x0, d
  ldrsh w4, [x0]//d
  adr x0, e
  ldrsw x5, [x0]//e
  CBZ x5, _exception
  mul	x6, x3, x1//a*c
  sdiv  x6, x6, x2//a*c/b
  mul   w7, w4, w2//d*b
  sdiv  x7, x7, x5//d*b/e
  mul   x8, x3, x3//c^2
  mul   x9, x1, x4//a*d
  CBZ   x9, _exception
  sdiv  x9, x8, x9//c^2/a*d
  adds  x6, x6, x7//a*c/b + d*b/e
  BVS   _exception
  subs  x6, x6, x9//res = a*c/b + d*b/e - c^2/a*d
  BVS   _exception
  adr   x0, res
  str   x6, [x0]
  mov 	x0, #0
  B 	_exit

_exception:
  mov	x0, #1

_exit:
  mov   x8, #93
  svc   #0
.size _start, .-_start
