.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 2, 1, 4, 5, 6, 1, 7, 8 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "outputs/test_write_matrix/student_write_outputs.bin"

.text
main:
    # Write the matrix to a file
    la a0, file_path
    la a1, m0
    li a2, 2
    li a3, 4
    jal ra write_matrix

    # Exit the program
    jal ra, exit