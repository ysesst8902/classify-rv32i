.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)
    li t1, 0

loop_start:
    bge t6, a1, end
    slli t3, t6, 2
    add t3, a0, t3
    lw t3, 0(t3)
    bge t3, t0, update
    j next_step
      
update:
    mv t1, t6
    mv t0, t3 

next_step:
    addi  t6, t6, 1                    
    j loop_start        


handle_error:
    li a0, 36
    j exit
    
end:
    mv      a0, t1                
    ret