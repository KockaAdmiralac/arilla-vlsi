.extern __stack_pointer
.global _start

.section .startup
.type _start, %function
_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop
    li x2, 0
    la x2, __stack_pointer
    call main
loop:
    j loop
.end
