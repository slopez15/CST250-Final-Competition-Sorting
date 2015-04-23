# You can implement any sorting algorithm you choose.  You can really go two ways with this: implement the simplest algorithm you can think of in as few lines as possible or take on a faster, but more complex algorithm like heapsort.
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Quicksort

wildcard_sort:
	#TODO

arrayC:
	.space 1024
#arrayB:
#	.space 1024

	li $t0, arrayC	# store address
			# 1) length = range of elements in Array4, index holds number occurances 
			# 2) numbers <= Array4[i]

#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array

	li $t1, 0		# indexed value in Array4 
	li $t2, 0		# temp used for 2nd number in first loop
	li $t3, 0		# less/greater comparison result
	li $t4, 0		# loop counter
	li $t5, 1 		# determine first loop or not/ can override after first loop of array4

	#v0 smallest #
	#v1 largest  #
# ========== Determine smallest and largets number ==========

	get_small_LARGE_elements:

	beq $a1, $t4 set_arrayC_length	# jump when reaching last element of in Array4
	nop	
	addiu $t4, $t4, 1		# increment count by 1

	lw $t1, 0($a0)		# get first number
	addiu $a0, $a0, 4
	
	push $ra
	call compare
	nop
	
	j get_small_LARGE_elements
	nop

# ========== Sets arrayC equal to the range of elements in array4 ==========
	set_arrayC_length:


# ========== Increment all of the occurances of numbers from array4 into arrayC ==========
	increment_element_occurances:


	j increment_element_occurances
	nop

# ========== Determine less than and greater than registers ==========
						
			compare:
			beq $t4, $t5 first
			nop
			
			pop $v1
			slt $t3, $t1 $v1			#compare
			push $v1
			beq $t3, $0, change_maximum 	#jump if $t1 < $v1
			nop

			pop $v0
			slt $t3, $t1, $v0			#compare
			push $v0 	
			bne $t3, $0, change_minimum 	#jump if $t1 > $v0
			nop
		
			compareReturn:
		
			pop $ra
			return
			nop
		#================	occurs once=========	#
			first:	
			lw $t2, 0($a0)		# get second number
			addiu $a0, $a0, 4
			addiu $t4, $t4, 1
			
			slt $t3, $t1, $t2 # compare first numbers 1 and 2
			bne $t3, $0 firstLsecond	#jump if $t1 < $t2
			nop
			
			#if $t1 > $t2
			move $v1, $t1
			move $v0, $t2

			j endFirst
			nop

			firstLsecond:
			#if $t1 < $t2
			move $v0, $t1
			move $v1, $t2

			endFirst:	
			
			push $v1		#push largest then smallest
			push $v0
			j get_small_LARGE_elements
			nop
		#================	occurs once     =========	



		#========  case where $t1 > $t2	========
			
			
			change_minimum:
			pop $v0

			move $v0, $t1

			push $v0
			j compareReturn #	where $t2 > $v0
			nop
			
		#========case where $t1 < $t2	========
			change_maximum:
			# compare each number (new) number to both numbers on stack
			pop $v0			
			pop $v1	# getting largest in stack
			
			move $v1, $t1
			
			pop $v1
			pop $v0
			j compareReturn
			nop
				
	return
	nop