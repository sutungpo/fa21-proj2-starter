.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:

    # Prologue
    ebreak
	li t5, 1
    blt a1, t5, fail
	li t0, 0
    li t5, 0
    lw t4, 0(a0)
    addi t0, t0, 1
loop_start:
	bge t0, a1, loop_end
	slli t1, t0, 2
    add t2, t1, a0
    lw t3, 0(t2)
    bge t4, t3, loop_continue
    mv t4, t3
    mv t5, t0
loop_continue:
	addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
	mv a0, t5
    ret
fail:
	li a1, 57
    j exit2