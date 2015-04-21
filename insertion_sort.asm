# Implement insertion sort here
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about selection sort can be found here:
# http://en.wikipedia.org/wiki/Selection_sort

insertion_sort:
	#TODO
	li $t2, 1 #load one to compare K to one later
	move $t4, $a1 #Serves as a counter for K
	li $t5, 4 # load 4 to multiply n by 4
	mullo $t5, $t4, $t5 #Multiply n by 4
	addu $t0, $a0, $t5 # Add n*4 to get nth element of array

	loop:

	lw $s0, 0($t0) # Store nth element of array into register
	addiu $t1, $t0, -4 # Subtract 4 to get previous element
	lw $s1, 0($t1) # Store n-1 element of array into register

	slt $t3, $s0, $s1 # a[k] < a[k-1]
	beq $t3, $0, failed # If a[k] = a[k-1] move to fail
	nop
	slt $t3, $t2, $t4 # if 1 is less than k
	beq $t3, $0, failed # If k > 1 
	nop

	
	

	sw $s0, 0($t1) 
	sw $s1, 0($t0) # Swap two array elements
	
	j loop
	nop

	failed:
	
	return
	nop
