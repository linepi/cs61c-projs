.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================

write_matrix:
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
    mv s3, a3
    
    # open file 
    mv a1, s0
    li a2, 1 # r permission
    jal ra, fopen
    li t0, -1
    beq a0, t0, error53
    addi sp, sp, -4
    sw a0, 0(sp) # fd
    
    # file write(row and column)
    lw a1, 0(sp)
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    mv a2, sp
    li a3, 2
    li a4, 4
    jal ra, fwrite
    li t0, 2
    bne a0, t0, error54

    # file write(matrix content)
    lw a1, 8(sp)
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal ra, fwrite
    mul t0, s2, s3
    bne a0, t0, error54

    # file close
    lw a1, 8(sp) 
    jal ra, fclose
    li t0, -1
    beq a0, t0, error55

    # end
    addi sp, sp, 12
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
error53:
    li a1, 53
    li a0, 17
    ecall
error54:
    li a1, 54
    li a0, 17
    ecall
error55:
    li a1, 55
    li a0, 17
    ecall