.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    addi sp, sp, -12
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    # Prologue
    li t0, 1
    blt a1, t0, error7
    # t1 for max, t2 for index
    lw t1, 0(a0)
    li t2, 0
loop_start:
    li s0, 1
loop_continue:
    slli t0, s0, 2
    add s1, a0, t0
    lw s2, 0(s1)
    bge t1, s2, go_on
    mv t1, s2
    mv t2, s0
go_on:
    addi s0, s0, 1
    bne s0, a1, loop_continue
loop_end:
    # Epilogue
    mv a0, t2
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp) 
    addi sp, sp, 12
    ret
error7:
    # exit with code 7
    li a0, 17
    li a1, 7
    ecall