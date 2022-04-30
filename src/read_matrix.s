.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
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
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
	sw ra, 36(sp)
    
	mv s0, a0
  	mv s1, a1
    mv s2, a2

    mv a1, s0
    li a2, 0
    call fopen
    li t0, -1
    li a1, 89
    beq a0, t0, fail
    li s4, 4
    mv s3, a0
    mv a1, s3
    mv a2, s1
	mv a3, s4
    call fread
    li a1, 91
    bne a0, s4, fail
    mv a1, s3
    mv a2, s2
    mv a3, s4
    call fread
    li a1, 91
    bne a0, s4, fail
    
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s6, t1, t0
    mul t2, s6, s4
    mv a0, t2
    call malloc
    ebreak
    li a1 88
    beq a0, x0, fail
    mv s5, a0
	li s7, 0
    ebreak
loop_start:
	bge s7, s6, loop_end
	slli t1, s7, 2
    add s8, s5, t1
    mv a1, s3
    mv a2, s8
    mv a3, s4
    call fread
    li a1, 91
    bne a0, s4, fail
    addi s7, s7, 1
    j loop_start
loop_end:

	mv a1, s3
    call fclose
	li t0, -1
    li a1, 90
    beq a0, t0, fail

    # Epilogue
    mv a0, s5
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
	lw ra, 36(sp)
	addi sp, sp, 40
    ret

fail:
	j exit2