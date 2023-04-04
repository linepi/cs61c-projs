.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    #
    # Pesudo code:
    #   hidden_layer = matmul(m0, input)
    #   relu(hidden_layer) # Recall that relu is performed in-place
    #   scores = matmul(m1, hidden_layer)
    addi sp sp -4
    sw ra 0(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # If argc != 5, exit with 49
    li t0, 5
    bne s0, t0, error49

	# =====================================
    # LOAD MATRICES
    # =====================================
    # struct matrix{
    #     int row;
    #     int column;
    #     int *data;        
    # }

    # Load pretrained m0
    addi sp, sp, -12
    mv s3, sp # s3: m0
    lw a0, 4(s1)
    addi a1, sp, 8
    addi a2, sp, 4
    jal ra, read_matrix
    sw a0, 0(sp)

    # Load pretrained m1
    addi sp, sp, -12
    mv s4, sp # s4: m1
    lw a0, 8(s1)
    addi a1, sp, 8
    addi a2, sp, 4
    jal ra, read_matrix
    sw a0, 0(sp)

    # Load input matrix
    addi sp, sp, -12
    mv s5, sp # s5: input
    lw a0, 12(s1)
    addi a1, sp, 8
    addi a2, sp, 4
    jal ra, read_matrix
    sw a0, 0(sp)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # malloc space for hidden_layer
    lw t0, 8(s3)
    lw t1, 4(s5)
    mul a0, t0, t1
    slli a0, a0, 2
    jal ra malloc
    addi sp, sp, -12
    mv s6 sp # s6: hidden
    lw t0, 8(s3)
    lw t1, 4(s5)
    sw t0, 8(s6)
    sw t1, 4(s6)
    sw a0, 0(s6)
    # matmul
    lw a0, 0(s3)
    lw a1, 8(s3)
    lw a2, 4(s3)
    lw a3, 0(s5)
    lw a4, 8(s5)
    lw a5, 4(s5)
    lw a6, 0(s6)

    jal ra, matmul

    # relu
    lw t0, 8(s6)
    lw t1, 4(s6)
    mul a1, t0, t1
    lw a0, 0(s6)
    jal ra, relu
    # malloc space for res
    lw t0, 8(s4)
    lw t1, 4(s6)
    mul a0, t0, t1
    slli a0, a0, 2
    jal ra malloc
    addi sp, sp, -12
    mv s7 sp # s7: res
    lw t0, 8(s4)
    lw t1, 4(s6)
    sw t0, 8(s7)
    sw t1, 4(s7)
    sw a0, 0(s7)
    # matmul
    lw a0, 0(s4)
    lw a1, 8(s4)
    lw a2, 4(s4)
    lw a3, 0(s6)
    lw a4, 8(s6)
    lw a5, 4(s6)
    lw a6, 0(s7)
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    lw a1, 0(s7)
    lw a2, 8(s7)
    lw a3, 4(s7)
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw a0, 0(s7)
    lw t0, 8(s7)
    lw t1, 4(s7)
    mul a1, t0, t1
    jal ra, argmax

    # If a2 == 0 print, otherwise go to end
    bne s2, x0, end
    # Print classification
    mv a1, a0
    jal ra print_int
    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char
end:
    lw a0 0(s3)
    jal free
    lw a0 0(s4)
    jal free
    lw a0 0(s5)
    jal free
    lw a0 0(s6)
    jal free
    lw a0 0(s7)
    jal free
    addi sp, sp, 60
    lw ra 0(sp)
    addi sp, sp 4
    ret
error49:
    li a1 49
    li a0 17
    ecall