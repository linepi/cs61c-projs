.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================

# modify a0, a1, a2

read_matrix:
    addi sp, sp, -28
    sw ra, 24(sp)
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s4, 4(sp)
    sw s5, 0(sp)
    # Prologue
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # open file 
    mv a1, s0
    li a2, 0 # r permission
    jal ra, fopen
    li t0, -1
    beq a0, t0, error50
    mv s3, a0 # s3: fd

    addi sp, sp, -8
    mv s4, sp # s4: two int buffer

    # read first two 4-bytes int
    mv a1, s3
    mv a2, s4 
    li a3, 8
    jal ra, fread
    li t0, 8
    bne a0, t0, error51 

    # malloc matrix space
    lw t0, 0(s4)
    lw t1, 4(s4)
    mul a0, t0, t1
    slli a0, a0, 2
    mv s4, a0 # overwrite s4 to matrix size(byte)
    jal ra, malloc
    li t0, -1
    beq a0, t0, error48
    mv s5, a0 # s5: matrix buffer

    # read matrix content
    mv a1, s3
    mv a2, s5
    mv a3, s4
    jal ra, fread
    bne a0, s4, error51 

    # close file
    mv a1, s3
    jal ra, fclose
    li t0, -1
    beq a0, t0, error52

    # end
    lw t0, 0(sp)
    sw t0, 0(s1)
    lw t0, 4(sp)
    sw t0, 0(s2)
    mv a0, s5

    addi sp, sp, 8

    # Epilogue
    lw s5, 0(sp)
    lw s4, 4(sp) 
    lw s3, 8(sp)
    lw s2, 12(sp)
    lw s1, 16(sp)
    lw s0, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    ret
error48:
    li a1, 48
    li a0, 17
    ecall
error50:
    li a1, 50
    li a0, 17
    ecall
error51:
    li a1, 51
    li a0, 17
    ecall
error52:
    li a1, 52
    li a0, 17
    ecall