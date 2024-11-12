.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  
    li t0, 0            
    li t1, 0
loop_start:
    bge t1, a2, loop_end
#    mul t4, t1, a3
    li t6, 0  # multiplication idx
    li t4, 0  # multiplication result
Loop_a0:
    bge t6, t1, Loop_a0_end
    add t4, t4, a3
    addi t6, t6, 1
    j Loop_a0

Loop_a0_end:
    li t6, 0  # multiplication idx
    li t5, 0  # multiplication result
#     mul t5, t1, a4
Loop_a1:
    bge t6, t1, Loop_a1_end
    add t5, t5, a4
    addi t6, t6, 1
    j Loop_a1
Loop_a1_end:
    slli t4, t4, 2
    slli t5, t5, 2
    add t4, a0, t4
    add t5, a1, t5
    lw t4, 0(t4)
    lw t5, 0(t5)

mul_add:
    li t6, 0
    bgez, t4, mul_loop_t4
    bgez, t5, mul_loop_t5
    li t6,0xffffffff
    xor t4, t4, t6
    addi t4,t4,1
    xor t5, t5, t6
    addi t5,t5,1
    li t6, 0
mul_loop_t4:
    bge t6, t4, mul_end
    add t0, t5, t0
    addi t6, t6, 1
    j mul_loop_t4
mul_loop_t5:
    bge t6, t5, mul_end
    add t0, t4, t0
    addi t6, t6, 1
    j mul_loop_t5

mul_end:
    addi t1, t1, 1
    j loop_start
    
    
loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
