.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================

# modify a0

dot:
    li t0, 1
    blt a2, t0, error5
    blt a3, t0, error6
    blt a4, t0, error6
    # Error checks
    addi sp, sp, -12
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    # Prologue
    li s0, 0
    li t1, 0 # sum
loop_start:
    slli t0, s0, 2
    mul t0, t0, a3
    add t0, t0, a0
    lw s1, 0(t0)
    slli t0, s0, 2
    mul t0, t0, a4
    add t0, t0, a1
    lw s2, 0(t0)
    mul t0, s1, s2
    add t1, t1, t0
    addi s0, s0, 1
    bne s0, a2, loop_start
loop_end:
    mv a0, t1
    # Epilogue
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp) 
    addi sp, sp, 12
    ret
error5:
    li a1, 5
    li a0, 17
    ecall
error6:
    li a1, 6
    li a0, 17
    ecall