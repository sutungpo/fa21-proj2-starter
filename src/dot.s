.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    # Prologue
	addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
	li t3, 1
    blt a2, t3, fail
    blt a3, t3, fail2
    blt a4, t3, fail2
    
    li t0, 0
    li t3, 0
    li t4, 0
    li s2, 0
loop_start:
	bge t3, a2, loop_end
    slli t1, t0, 2
    add t2, t1, a0
    lw s0, 0(t2)
	slli t5, t4, 2
	add t6, t5, a1
    lw s1, 0(t6)
	mul a7, s0, s1
    add s2, s2, a7
	addi t3, t3, 1
    add t0, t0, a3
    add t4, t4, a4
	j loop_start
loop_end:
    # Epilogue
    mv a0, s2
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
	addi sp, sp, 12
    ret
fail:
	li a1, 57
	j exit2
fail2:
	li a1, 58
    j exit2