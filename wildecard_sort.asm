# You can implement any sorting algorithm you choose.  You can really go two ways with this: implement the simplest algorithm you can think of in as few lines as possible or take on a faster, but more complex algorithm like heapsort.
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Quicksort

wildcard_sort:
	#TODO
	# selection sort algorithm
#	addiu $t8 , $a1 , -1	# set $t8 to index of last element
	sll $t8 , $a1 , 2	# multiply by 4
	addu $t8 , $t8 , $a0	# set $t8 to memory address PAST the last element

	move $t0 , $a0	# using $t0 as i, but using memory addresses to be clever
ss_for1_top:
# for i = 0; i < length; i++
	slt $t9 , $t0 , $t8	# is i past the last element 
	beq $t9 , $zero , ss_for1_bot
	nop

	move $t2 , $t0	# set $t2 to point at i element(start min)

	move $t1 , $t0	# using $t1 as j
ss_for2_top:
# for j = i; j < length; j++
	slt $t9 , $t1 , $t8	# is j past the last element
	beq $t9 , $zero , ss_for2_bot
	nop

	lw $s0 , 0($t1)	# get data at j
	lw $s1 , 0($t2)	# get data at i

	slt $t9 , $s0 , $s1	# if arr[j] is NOT less than arr[i]
	beq $t9 , $zero , min_skip	# skip setting new min
	nop

	move $t2 , $t1

min_skip:
	

	addiu $t1 , $t1 , 4	# incrementing by 4 because memory address
	j ss_for2_top
	nop
ss_for2_bot:

	lw $s0 , 0($t0)	# get data at i
	lw $s1 , 0($t2)	# get data at min index
	sw $s1 , 0($t0)	# swap min and i, $t0 is i
	sw $s0 , 0($t2)	# swap min and i, $t2 is min
	

	addiu $t0 , $t0 , 4	# incrementing by 4 because memory address
	j ss_for1_top
	nop

ss_for1_bot:
		



	return
	nop
