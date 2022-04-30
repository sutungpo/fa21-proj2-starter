.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
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
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
	li t0, 1
    blt a1, t0, fail
    blt a2, t0, fail
    blt a4, t0, fail
    blt a5, t0, fail
    bne a2, a4, fail

    # Prologue
	addi sp, sp, -40
    sw s2, 0(sp)
    sw s3, 4(sp)
    sw s4, 8(sp)
    sw s5, 12(sp)
    sw s6, 16(sp)
    sw s7, 20(sp)
    sw s8, 24(sp)
    sw s9, 28(sp)
    sw s10, 32(sp)
    sw ra, 36(sp)
	li s2, 0
    li s3, 0
    mv s4, a0
    mv s5, a1
    mv s6, a2
    mv s7, a3
    mv s8, a4
    mv s9, a5
    mv s10, a6
    ebreak
outer_loop_start:
	bge s2, s5, outer_loop_end
	li s3, 0
inner_loop_start:
	bge s3, s9, inner_loop_end
    mul t4, s2, s6
    slli t5, t4, 2
    add a0, t5, s4
    slli t6, s3, 2
    add a1, s7, t6
    mv a2, s6
    li a3, 1
    mv a4, s9
    call dot
    ebreak
	mul t0, s2, s5
	add t1, t0, s3
	slli t2, t1, 2
    add t3, t2, s10
    sw a0, 0(t3)
    addi s3, s3, 1
    j inner_loop_start
    
inner_loop_end:
	addi s2, s2, 1
	j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s2, 0(sp)
    lw s3, 4(sp)
    lw s4, 8(sp)
    lw s5, 12(sp)
    lw s6, 16(sp)
    lw s7, 20(sp)
    lw s8, 24(sp)
    lw s9, 28(sp)
    lw s10, 32(sp)
    lw ra, 36(sp)
	addi sp, sp, 40
    ret
fail:
	li a1, 59
    j exit2