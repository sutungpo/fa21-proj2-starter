.globl squared_loss

.text
# =======================================================
# FUNCTION: Get the squared difference of 2 int vectors,
#   store in the result vector and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int*) is the pointer to the start of the result vector

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# =======================================================
squared_loss:
	li t0, 1
    blt a2, t0, fail
    
    addi sp, sp, -32
    sw s2, 0(sp)
    sw s3, 4(sp)
    sw s4, 8(sp)
    sw s5, 12(sp)
    sw s6, 16(sp)
    sw s7, 20(sp)
    sw s8, 24(sp)
    sw ra, 28(sp)
    
    mv s2, a0
    mv s3, a1
    mv s4, a2
    mv s5, a3
	li t0, 0
    li t6, 0
loop_start:
	bge t0, s4, loop_end
	slli t1, t0, 2
    add t2, s2, t1
    add t3, s3, t1
    add t4, s5, t1
    lw s6, 0(t2)
    lw s7, 0(t3)
    sub t5, s6, s7
    bge t5, x0, zero
    sub t5, x0, t5
zero:
	mul t5, t5, t5
	sw t5, 0(t4)
    add t6, t6, t5
    addi t0, t0, 1
    j loop_start
loop_end:
    mv a0, t6
    lw s2, 0(sp)
    lw s3, 4(sp)
    lw s4, 8(sp)
    lw s5, 12(sp)
    lw s6, 16(sp)
    lw s7, 20(sp)
    lw s8, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret
fail:
	li a1, 123
    j exit2