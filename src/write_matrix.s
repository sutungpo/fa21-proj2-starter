.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
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
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

	addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
	sw ra, 28(sp)
    addi sp, sp, -8
    
	mv s0, a0
  	mv s1, a1
    mv s2, a2
    mv s3, a3
    sw a2, 0(sp)
    sw a3, 4(sp)
    mv s5, sp
    addi s6, sp, 4
    ebreak
    mv a1, s0
    li a2, 1
    call fopen
    li t0, -1
    li a1, 89
    beq a0, t0, fail
    mv s4, a0
    # write row
    mv a1, s4
    mv a2, s5
    li a3, 1
    li a4, 4
    call fwrite
    li t0, 1
    li a1, 92
    bne a0, t0, fail
    # write column
    mv a1, s4
    mv a2, s6
    li a3, 1
    li a4, 4
    call fwrite
    li t0, 1
    li a1, 92
    bne a0, t0, fail

	mul a3, s2, s3
    mv a1, s4
    mv a2, s1
    li a4, 4
    call fwrite
    mul t0, s2, s3
    li a1, 92
    bne a0, t0, fail
    
	mv a1, s4
    call fclose
	li t0, -1
    li a1, 90
    beq a0, t0, fail

    # Epilogue
    addi sp, sp, 8
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
	lw ra, 28(sp)
	addi sp, sp, 32
    ret

fail:
	j exit2
