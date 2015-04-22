# Implement quick sort here
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Quicksort

quick_sort:
	addiu $a2 , $a1 , -1	# set $a2 to number of elements - 1
	move $a1 , $zero	# set $a1 to 0(start index)

	push $ra	# save $ra by pushing onto the stack

	jal qs_recurse	# jump and link to the recursive quick sort method
	nop	# nop after jump

	pop $ra	# restore $ra from stack
	
	return
	nop

# recursive method for quick sort
# Inputs:
# 	$a0 is the array
# 	$a1 is the minimum index
# 	$a2 is the maximum index
# OVERWRITES THESE REGISTERS
#	$t9
qs_recurse:
	
	slt $t9 , $a1 , $a2	# compare min and max
	beq $t9 , $zero , qs_recurse_ret	# if min > max, jump to qs_recurse_ret
	nop


	push $ra	# save return address onto the stack

	push $a2	# save maximum index to the stack
	push $a1	# save minimum index to the stack

	jal qs_partition	# partition using given min and max
	nop	# nop after jump

	pop $a1 # restore minimum index from stack
	addiu $a2 , $v0 , -1	# use partiton element - 1 for parameter 2 of qs_recurse	
	push $v0 # save partition index to stack

	jal qs_recurse	# do the sorting for min to partition - 1
	nop

	pop $a1	# restore partition index from stack
	addiu $a1 , $a1 , 1	# add one to partition index
	pop $a2	# restore maximum index from stack

	jal qs_recurse	# do the sorting for partition + 1 to max
	nop

	pop $ra	# restore return address from stack

	
qs_recurse_ret:

	jr $ra	# jump to the return address
	nop	# nop after jump
### end of qs_recurse

# method used to partion elements within a set range
# function arguments
#	$a0 is the array
#	$a1 is the minimum index
#	$a2 is the maximum index
# returns
#	$v0 is the index of the partition element
# OVERWRITES THESE REGISTERS
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t9
#	$s0
#	$s1
#	$s2
#	$a1
#	$a2
#	$v0

qs_partition:
	
	push $a1	# store min on the stack
	push $a2	# store max on the stack

	addu $t0 , $a1 , $a2		# sum min and max
	srl $a2 , $t0 , 1		# divide by 2, store in $a2

	push $ra	# store return address

	# move partition value out of the way
	jal qs_swap	# $a0 is array, $a1 is min, $a2 is middle
	nop		# swap min and middle

	pop $ra # restore return address

	pop $a2	# restore max from stack
	pop $a1	# restore min from stacks

	move $t0 , $a1	# set left to min
#	addiu $t0 , $t0 , 1	# set left to min + 1(becuase min is partition)
	move $t1 , $a2	# set right to max
	move $t2 , $a1	# set partition to min(because we just swapped it)

	# $t0 is min index
	# $t1 is max index
	# $t2 is middle index



	
	# set memory address for partition value(shouldn't change)
	sll $s2 , $t2 , 2	# multiply mid by 4 to get byte offset
	addu $s2 , $s2 , $a0	# add offset to array memory location, store in $t6
	lw $t5 , 0($s2)	# load the actual data from partition element

qs_part_lltr_top:
# start of while loop

	
	# while loop conditional
	slt $t9 , $t0 , $t1	# is left less than right
	beq $t9 , $zero , qs_part_lltr_end	# if not, jump to end
	nop


qs_part_llep_top:
# start of inner while loop 1

	slt $t9 , $t0 , $t1	# compare left counter to right counter
	beq $t9 , $zero , qs_part_llep_end	# jump if not less than
	nop

	# set memory address for left value
	sll $s0 , $t0 , 2	# multiply left by 4 to get byte offset
	addu $s0 , $s0 , $a0	# add offset to array memory location, store in $t4
	lw $t3 , 0($s0)	# load the data from left index
	slt $t9 , $t5 , $t3	# is left data less than or equal to partition data
	bne $t9 , $zero , qs_part_llep_end	# jump if left data is GREATER THAN partition data
	nop

	addiu $t0 , $t0 , 1	# increment the left counter

	j qs_part_llep_top	# uncondtional jumpto the
	nop		# top of the while loop
# end of inner while loop 1
qs_part_llep_end:

qs_part_rgtp_top:
# start of inner while loop 2

	# set memory address for right value
	sll $s1 , $t1 , 2	# multiply by 4 to get btye offset
	addu $s1 , $s1 , $a0	# add offset to array memory location, store in $t5

	lw $t4 , 0($s1)	# load the value for right element
	slt $t9 , $t4 , $t5	# if right is less than partition, jump
	bne $t9 , $zero , qs_part_rgtp_end	# to the end of the loop
	nop
	subu $t9 , $t4 , $t5	# if they are the same then jump because
	beq $t9 , $zero , qs_part_rgtp_end	# equal is not greater than
	nop

	addiu $t1 , $t1 , -1	# decrement right counter

	j qs_part_rgtp_top	# unconditional jump to the
	nop		# top of the while loop

# end of inner while loop 2
qs_part_rgtp_end:

qs_part_fltc_top:
# final if statement

	slt $t9 , $t0 , $t1	# if left is NOT less than right
	beq $t9 , $zero , qs_part_fltc_end	# jump over swa instruction
	nop

	# swap left and right
	push $t0	# save left count to stack
	push $t1	# save right count to stack
	push $t2	# save partition index to stack

	push $ra	# save return address to stack

	move $a1 , $t0	# moves index of left into $a1
	move $a2 , $t1	# moves index of right into $a2

	jal qs_swap	# swaps left element and right element
	nop
	
	pop $ra	# restore the return address from the stack

	pop $t2	# retsore partition index from stack
	pop $t1	# restore right count from stack
	pop $t0	# restore left count from stack

# end of if statement(else)
qs_part_fltc_end:

	
	j qs_part_lltr_top	# unconditional jump to the
	nop		# top of the while loop
qs_part_lltr_end:
# end of while loop
	
	push $ra	# save return address to stack

	move $a2 , $t1	# set $a2 to the current right
	move $a1 , $t2	# set $a1 to the current min(partition)
	
	# $a0 is array(still)
	# $a1 is min
	# $a2 is right

	jal qs_swap
	nop
	
	pop $ra	# restore return address from stack

	move $v0 , $a2

	jr $ra
	nop
### end of qs_partition


# function used to swap two elements within an array
# a0 is memory of array
# a1 is index 1
# a2 is index 2
# OVERWRITES THESE REGISTERS
#	$t0
#	$t1
#	$t2
#	$t3
qs_swap:
	
	sll $t1 , $a1 , 2	# shift left by 2 bits(multply by 4)
	sll $t2 , $a2 , 2	# shift left by 2 bits(multply by 4)

	addu $t0 , $a0 , $t1		# add calculated offset to memory locate
	addu $t1 , $a0 , $t2		# add calculated offset to memory locate
	
	lw $t2 , 0($t0)	# load element at $t0 into $t2
	lw $t3 , 0($t1)	# load element at $t1 into $t3
	sw $t2 , 0($t1)	# store element in $t2 at $t1
	sw $t3 , 0($t0)	# store element in $t3 at $t0

	jr $ra
	nop
### end of qs_swap


