# Implement bubble sort here
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Bubble_sort

bubble_sort:

MAIN:
	
BUBBLESORT:
	li $t9, 0 # Swap counter
	move $t8, $a0 #t8 is now points to array
	
COMPARE:
	lw $t0, 0($t8) # Load ptr contents
	lw $t1, 4($t8) # Load ptr + 1 contents
	slt $t2, $t0, $t1
	
	beq $t2, $0, SWAP # compare ptr < ptr + 1, if ptr + 1 is smaller move it
	nop
	j NEXT
	nop
	
SWAP:
	sw $t0, 4($t8) #stores in t0 in opposite memory condition.
	sw $t1, 0($t8)
	
	addiu $t9, $t9, 1 # Add one to the swap counter
	j NEXT
	nop
NEXT:
	addiu $t8, $t8, 4 # Increment next pointer
	addiu $t3, $a1, -1 #tranlate num of elements into index value
	sll $t3, $t3, 2 #multiply index by 4 to get byte offset
	addu $s0, $a0, $t3 #add offset to find the last element
	bne $t8, $s0, COMPARE # if t8 is not last element then run loop again.
	nop
	beq $t9, $0, DONE # if we run through array without swaps, then done.
	nop
	j BUBBLESORT
	nop
DONE:

	return
	nop
