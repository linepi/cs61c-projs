.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    li t0, 1
    blt a1, t0, error7
    # Error checks
    addi sp, sp, -12
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    # Prologue
loop_start:
    li s0, 0 # s0: i
loop_continue:
    slli t0, s0, 2
    add s1, a0, t0 # s1: pointer for data
    lw s2, 0(s1)   # s2: data
    # max(s2, 0)
    srai t0, s2, 31
    and t0, t0, s2
    sub s2, s2, t0
    # s2 - (s2 >> 31) & s2
    sw s2, 0(s1)
    addi s0, s0, 1
    blt s0, a1, loop_continue
loop_end:
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