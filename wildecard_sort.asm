# You can implement any sorting algorithm you choose.  You can really go two ways with this: implement the simplest algorithm you can think of in as few lines as possible or take on a faster, but more complex algorithm like heapsort.
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Quicksort
# learn more about counting sort through https://www.youtube.com/watch?v=5rLrRpcBCzo
wildcard_sort:
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

	lw $t1, 0($a0)		# get comparing number
	addiu $a0, $a0, 4

	j compare
	nop
	
	j get_small_LARGE_elements
	nop

# ========== Sets arrayC equal to the range of elements in array4 ==========
	set_arrayC_length:


	#get lowest and largest nums in A[], 
	#$t6 =lowest; $t7 =highest
	pop $v0
	pop $v1
	move $t6, $v0
	move $t7, $v1
	push $v1
	push $v0
	
	subu $t6, $t7, $t6 #amount between range
	addiu $t6, $t6, 1 #add 1+ space 
	
	li $t7, 4
	mullo $t6, $t6, $t7 #4 for each number in range
	addu $t0, $t0, $t6 #make space for the range
	#IMPORTANT dont do 0 +=1; its lowestNumIndex +=1 saves range memory waste	
	
	#Set zeros in every index location
#	li $t4, 0
#	li $t6, 0
	
#	set_Zeros_in_arrayC:

	#C[n]; get location C[n] & place zero '0' into it
	#start at $t4 = 0 & $t6 will hold addresses
#	move $t6, $t4
#	sll $t6, $t6, 2 	#multiply by 4; make space for element
#	addu $t6, $t6, $t0 	#address for element in arrayC
		#lw $t7, 0($t7) #actual data; element
#	sw $0, 0($t6) 	#stored zero in address
#	addiu $t4, $t4, 1		# increment count by 1

#	bne $a1, $t4 set_Zeros_in_arrayC # continue when reaching last element of in arrayC
#	nop
	#reset t5-t7
#	li $t4, 0
#	li $t5, 0
#	li $t6, 0
#	li $t7, 0
	
	#push $ra	
		#use for Sizing same as $a0 =arrayA
		#lui $t6, 4
		#mullo $t4, $t4, $t6
		#addu $t0, $t0, $t6 
	#or $t4, $t4, $0 #zero out for later use
	
	#pop $ra
	#return
	#nop


# ========== Increment all of the occurances of numbers from array4 into arrayC ==========

	move $t6, $a1 #array4 numElements aka size
#	li $t7, 1
	increment_element_occurances:
	
	#element
	#A[size]=n
	#C[n]= C[n]+1
	#$a0 - array4
	#$a1 - size
	
	#A[i]=n; i=last=A[]size-1
	#subu $t6, $t6, $t7 #array4 size-1
	#n of A[i]=n
	sll $t6, $t6, 2 #multiply by 4; make space for element
	addu $t6, $t6, $a0 #address for element in array4
	lw $t6, 0($t6) #actual data; element
	
	#$t0 - arrayC
	#$t6 - element
	#C[n]= C[n]+1; n=elementIndex for
	move $t7, $t6
		#li $t7, $t6, -1 #element index-1
	#C[n]= C[n]+1; get location C[n] & +1 into it
	sll $t7, $t7, 2 #multiply by 4; make space for element
	addu $t7, $t7, $t0 #address for element in arrayC
	lw $t5, 0($t7) #actual data; element
	addiu $t5, $t5, 1 #+1 to element
	sw $t5, 0($t7) 	# +1 into address of index
	
	addiu $t4, $t4, 1	# increment count by 1
	li $t7, 1
	beq $a1, $t4 increment_element_occurances	# jump wen reaching last element of in Array4; gone through 
	nop	
	
	
	
	j increment_element_occurances
	nop
# ========== Determine less than and greater than registers ==========
						
			compare:
			beq $t4, $t5 first
			nop
			
			pop $v0
			pop $v1

			slt $t3, $t1 $v1			#compare
			push $v1
			beq $t3, $0, change_maximum 	#jump if $t1 < $v1
			nop

			slt $t3, $t1, $v0			#compare
			push $v0 	
			bne $t3, $0, change_minimum 	#jump if $t1 > $v0
			nop
		
			compareReturn:
		
			j get_small_LARGE_elements
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