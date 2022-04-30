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
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
	sw ra, 48(sp)
    addi sp, sp, -24
	ebreak
	# =====================================
    # LOAD MATRICES
    # =====================================
	
    lw s0, 0(a1)
    lw s1, 4(a1)
    lw s2, 8(a1)
    lw s3, 12(a1)
    # Load pretrained m0
	addi s10, sp, 0
    addi s11, sp, 4
    mv a0, s0
    mv a1, s10
    mv a2, s11
    call read_matrix
    mv s5, a0

    # Load pretrained m1
	addi s10, sp, 8
    addi s11, sp, 12
    mv a0, s1
    mv a1, s10
    mv a2, s11
    call read_matrix
    mv s6, a0

    # Load input matrix
	addi s10, sp, 16
    addi s11, sp, 20
    mv a0, s2
    mv a1, s10
    mv a2, s11
    call read_matrix
    mv s7, a0

  # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
	lw t0, 0(sp)
    lw t1, 20(sp)
    mul t0, t0, t1
    slli a0, t0, 2
	call malloc
    li a1, 88
    beq a0, x0, fail
	mv s8, a0
    
    # matmul m0 x h
    mv a0, s5
    lw a1, 0(sp)
    lw a2, 4(sp)
    mv a3, s7
    lw a4, 16(sp)
    lw a5, 20(sp)
    mv a6, s8
    call matmul
    
	#relu h
    lw t0, 0(sp)
    lw t1, 20(sp)
    mul a1, t0, t1
    mv a0, s8
    call relu

	#matmul m1 x h
    lw t0, 8(sp)
    lw t1, 20(sp)
    mul t0, t0, t1
    slli a0, t0, 2
	call malloc
    li a1, 88
    beq a0, x0, fail
	mv s9, a0
    
    mv a0, s6
    lw a1, 8(sp)
    lw a2, 12(sp)
    mv a3, s8
    lw a4, 0(sp)
    lw a5, 20(sp)
    mv a6, s9
    call matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
	mv a0, s3
    mv a1, s9
    lw a2, 8(sp)
    lw a3, 20(sp)
    call write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0, s9
    lw t0, 8(sp)
    lw t1, 20(sp)
    mul a1, t0, t1
	call argmax
    mv s10, a0

    # Print classification
	bne s4, x0, no_print
	mv a1, s10
	call print_int

    # Print newline afterwards for clarity
	li a1, 10
    call print_char
no_print:
	mv a0, s10
    addi sp, sp, 24
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
	lw ra, 48(sp)
    addi sp, sp, 52

    ret
fail:
	j exit2