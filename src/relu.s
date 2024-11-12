.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    beq t1, a1, end  
    slli t2, t1, 2 # Calculate the byte offset (index * 4) for word access
    add t2, a0, t2 # Get the address of the current element in the array
    lw t3, 0(t2) # Load the current element
    blez t3, set_zero        # If the element is less than or equal to 0, jump to set_zero
    j next_relu                   # Otherwise, jump to next
    
set_zero:
    sw x0, 0(t2)             # Store 0 in the current element of the array (set to zero)    
next_relu:
    addi t1, t1, 1           # Increment index s0 by 1
    j loop_start              # Jump back to the start of the relu loop
end:
    ret                      # Return from the relu function
error:
    li a0, 36          
    j exit          
