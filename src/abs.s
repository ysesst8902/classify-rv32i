.globl abs

.text
# =================================================================
# FUNCTION: Absolute Value Converter
#
# Transforms any integer into its absolute (non-negative) value by
# modifying the original value through pointer dereferencing.
# For example: -5 becomes 5, while 3 remains 3.
#
# Args:
#   a0 (int *): Memory address of the integer to be converted
#
# Returns:
#   None - The operation modifies the value at the pointer address
# =================================================================
abs:
    # Prologue
    ebreak
    # Load number from memory
    lw t0 0(a0)
    bgez t0, done

    # TODO: Add your own implementation
    # If t0 is negative, negate it to make it positive
    li t1,0xffffffff
    xor t0, t1, t0
    addi t0,t0,1
    sw t0, 0(a0)  # Store the absolute value back to memory
done:
    # Epilogue
    jr ra
