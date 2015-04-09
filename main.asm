# ********** DO NOT MODIFY THIS ASM FILE **********
# Each function is passed the starting address (smallest address) of an array via $a0 and the number of elements in the array via $a1
# Sort the array so that it starts with the smallest value and ends with the largest value
# Inputs will all be positive integers

.org 0x10000000
j main
nop

array1:
	.space 1024
array2:
	.space 1024
array3:
	.space 1024
array4:
	.space 1024


main:
	li $sp, 0x10FFFFFC
	call get_array
	nop
	move $a2, $v0	#accumulator
	move $a1, $v1	#array size
	
# ========== Place break point after this line ==========
	li $a0, array1
	call bubble_sort
	nop
	
# ========== Place break point after this line ==========
	li $a0, array2
	call insertion_sort
	nop

# ========== Place break point after this line ==========
	li $a0, array3
	call quick_sort
	nop

# ========== Place break point after this line ==========
	li $a0, array4
	call wildcard_sort
	nop

	call sort_validator
	nop

	j main
	nop
