.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    addi sp, sp, -12
    # Read matrix into memory
    la a0, file_path
    addi a1, sp, 4
    addi a2, sp, 0
    jal ra, read_matrix

    lw a1, 0(sp)
    lw a2, 4(sp)
    jal ra, print_int_array

    # Terminate the program
    addi sp, sp, 12
    jal ra, exit