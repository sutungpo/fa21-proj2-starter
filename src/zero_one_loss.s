.globl zero_one_loss

.text
# =======================================================
# FUNCTION: Generates a 0-1 classifer vector inplace in the result vector,
#  where result[i] = (v0[i] == v1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int*) is the pointer to the start of the result vector

# Returns:
#   NONE
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# =======================================================
zero_one_loss:
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
    ebreak
loop_start:
	bge t0, s4, loop_end
    li t6, 0
	slli t1, t0, 2
    add t2, s2, t1
    add t3, s3, t1
    add t4, s5, t1
    lw s6, 0(t2)
    lw s7, 0(t3)
    sub t5, s6, s7
    bne t5, x0, zero
    li t6, 1
zero:
	sw t6, 0(t4)
    addi t0, t0, 1
    j loop_start
loop_end:
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