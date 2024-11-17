# Assignment 2: Classify

## Function: `abs`
### RISC_V code
```assembly
.globl abs

.text
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
```
### Implementation Steps
1. **Load the integer**:
   - The value at the memory address provided in `a0` is loaded into the temporary register `t0` using the `lw` instruction.
2. **Check sign**:
   - The `bgez` instruction checks if `t0` is non-negative. If true, the program skips further calculations and directly jumps to the `done` label.
3. **Negate negative numbers**:
   - For negative values, the two's complement operation is used:
     - First, the number is XORed with `0xFFFFFFFF` to invert its bits.
     - Then, `1` is added using the `addi` instruction to complete the negation.
   - The computed absolute value is stored back in memory using the `sw` instruction.
4. **Return**:
   - The program ends with `jr ra`, returning control to the caller.

## Function: `argmax`
### RISC_V code
```assembly
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
```
### Implementation Steps
1. **Initialization**:
   - Load the first element of the array into `t0` (current maximum value).
   - Initialize `t1` to `0` (index of the maximum value).

2. **Loop Through the Array**:
   - Use a loop counter `t6` to iterate over the array.
   - For each element:
     - Load the value into `t3`.
     - Compare it with the current maximum (`t0`).
     - If the current value is greater than or equal to `t0`, update `t0` and set `t1` to the current index (`t6`).

3. **Return the Result**:
   - After completing the iteration, `t1` (index of the first maximum value) is moved to `a0`, and the function returns.
## Function: `relu`
### RISC_V code
```assembly
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
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
```
### Implementation Steps
1. **Initialization**:
   - Use `t1` as the loop counter, initialized to `0`, to represent the index of the array.
   - Calculate the address of each array element using an index-based offset.

2. **Array Traversal**:
   - For each iteration:
     - Compute the address of the current element and load its value into `t3`.
     - If the current element is less than or equal to `0` (`blez` instruction), jump to the `set_zero` section and set the element to `0`.
     - Otherwise, skip the update and proceed to the next element.

3. **Update Index and Continue**:
   - Increment the counter `t1` by `1` using the `addi` instruction.
   - Loop back to the beginning until all elements of the array are processed.

## Function: `matmul`
### RISC_V code
```assembly
matmul:
    # Error checks
    li t0 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    li s0, 0 # outer loop counter
    li s1, 0 # inner loop counter
    mv s2, a6 # incrementing result matrix pointer
    mv s3, a0 # incrementing matrix A pointer, increments durring outer loop
    mv s4, a3 # incrementing matrix B pointer, increments during inner loop 
    
outer_loop_start:
    #s0 is going to be the loop counter for the rows in A
    li s1, 0
    mv s4, a3
    blt s0, a1, inner_loop_start

    j outer_loop_end
    
inner_loop_start:
# HELPER FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use = number of columns of A, or number of rows of B
#   a3 (int)  is the stride of arr0 = for A, stride = 1
#   a4 (int)  is the stride of arr1 = for B, stride = len(rows) - 1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
    bge s1, a5, inner_loop_end

    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    
    mv a0, s3 # setting pointer for matrix A into the correct argument value
    mv a1, s4 # setting pointer for Matrix B into the correct argument value
    mv a2, a2 # setting the number of elements to use to the columns of A
    li a3, 1 # stride for matrix A
    mv a4, a5 # stride for matrix B
    
    jal dot
    
    mv t0, a0 # storing result of the dot product into t0
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    addi sp, sp, 24
    
    sw t0, 0(s2)
    addi s2, s2, 4 # Incrememtning pointer for result matrix
    
    li t1, 4
    add s4, s4, t1 # incrememtning the column on Matrix B
    
    addi s1, s1, 1
    j inner_loop_start
    
inner_loop_end:
    # TODO: Add your own implementation
    # Move to the next row in Matrix A
    slli t2, a2, 2
    add s3, s3, t2      
    addi s0, s0, 1      

    j outer_loop_start  # Jump back to the start of the outer loop
outer_loop_end:
    # Epilogue to restore registers and return
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    jr ra
error:
    li a0, 38
    j exit
```
### Implementation Steps
1. **Outer Loop (Row Traversal)**:
   - Iterate over the rows of Matrix A (`a1` times).
   - For each row, reset the inner loop counter and initialize the column pointer for Matrix B.

2. **Inner Loop (Column Traversal)**:
   - For each column of Matrix B (`a5` times):
     - Save the current context onto the stack.
     - Set up arguments for the `dot` helper function:
       - Pointer to the current row in Matrix A.
       - Pointer to the current column in Matrix B.
       - Number of elements for the dot product (`a2`).
       - Stride for Matrix A (`1`).
       - Stride for Matrix B (`a5`).
     - Call the `dot` function to compute the dot product.
     - Restore the context from the stack.
     - Store the dot product result into the result matrix and increment the result matrix pointer.
     - Move the column pointer in Matrix B to the next column.

3. **Update Outer Loop**:
   - After processing all columns for the current row in Matrix A, move to the next row by updating the pointer and incrementing the outer loop counter.
