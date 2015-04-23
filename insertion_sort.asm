# Implement insertion sort here
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about selection sort can be found here:
# http://en.wikipedia.org/wiki/Selection_sort

insertion_sort:
	#TODO
	li $s2, 1 # load i
	move $t4, $a1 #Serves as a counter for K

	Counted_Loop:
		slt $t3, $s2, $a1 #Compare 1 to length
		beq $t3, $0, sorted #When i is equal to length
		nop
	
		move $t4, $s2
		FML:
			
			
			li $t5, 4 # load 4 to multiply n by 4
			mullo $t5, $t4, $t5 #Multiply n by 4
			addu $t0, $a0, $t5 # Add n*4 to get nth element of array

			lw $s0, 0($t0) # Store nth element of array into register
			addiu $t1, $t0, -4 # Subtract 4 to get previous element
			lw $s1, 0($t1) # Store n-1 element of array into register

			slt $t3, $s0, $s1 # a[k] < a[k-1]
			beq $t3, $0, while_skip # If a[k] = a[k-1] move to fail
			nop
			slt $t3, $0, $t4 # if 1 is less than k
			beq $t3, $0, while_skip # If k > 1 
			nop
	

			sw $s0, 0($t1) 
			sw $s1, 0($t0) # Swap two array elements
		
			addiu $t4, $t4, -1 #j--
			j FML
			nop

		while_skip:

		addiu $s2, $s2, 1
		
		j Counted_Loop
		nop

	sorted:
	return
	nop
