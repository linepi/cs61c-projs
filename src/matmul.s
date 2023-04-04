.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================

# modify a0, a1, a2, a3, a4

matmul:
    # Error checks
    bge x0, a1, error2
    bge x0, a2, error2
    bge x0, a4, error3
    bge x0, a5, error3
    bne a2, a4, error4
    addi sp, sp, -28
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s4, 4(sp)
    sw s5, 0(sp)
    sw ra, 24(sp)
    # Prologue
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    # dot param a2, a3, a4
    li a3, 1
    mv a4, s5

    li t3, 0 # t3: i
outer_loop_start:
    # dot param a0
    mul t0, t3, s2
    slli t0, t0, 2
    add a0, s0, t0
    # dot param a0
    li t4, 0 # t4: j
inner_loop_start:
    # dot param a1
    mv t0, t4
    slli t0, t0, 2
    add a1, s3, t0 
    # save a0 because dot modify a0
    addi sp, sp, -4
    sw a0, 0(sp)
    jal ra, dot # get the a0 from dot
    # find where to store in d
    mul t0, t3, s5
    add t0, t0, t4
    slli t0, t0, 2
    add t0, t0, a6 
    sw a0, 0(t0)
    # restore a0
    lw a0, 0(sp)
    addi sp, sp, 4

    addi t4, t4, 1
    bne t4, s5, inner_loop_start
inner_loop_end:
    addi t3, t3, 1
    bne t3, s1, outer_loop_start
outer_loop_end:
    # Epilogue
    lw ra, 24(sp)
    lw s5, 0(sp)
    lw s4, 4(sp) 
    lw s3, 8(sp)
    lw s2, 12(sp)
    lw s1, 16(sp)
    lw s0, 20(sp)
    addi sp, sp, 28
    ret
error2:
    li a1, 2
    li a0, 17
    ecall
error3:
    li a1, 3
    li a0, 17
    ecall
error4:
    li a1, 4
    li a0, 17
    ecall