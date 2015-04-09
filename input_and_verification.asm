# ********** DO NOT MODIFY THIS ASM FILE **********

get_array:
	push $ra
	li $s0, 0xF0000000	# UART
	li $s2, 0b10	# Status register bit mask
	li $t5, 10		# Used to convert decimal to binary
	li $t6, 48		# Used to convert ASCII to decimal
	li $t7, 59		# ';'
	li $t8, 32		# space character
	li $t0, 0		# value of current number
	li $t1, array1
	li $t2, array2
	li $t3, array3
	li $t4, array4
	li $v1, 0		# Array size return value
	li $s3, 0		# Acculmultor
	UART_read_loop:
		jal get_char
		nop
		# Check for end of input
		bne $v0, $t7, UART_not_a_semicolon
			nop
			jal store_num_in_arrays
			addiu $v1, $v1, 1	#increment array length during branch delay slot
			move $v0, $s3	#move accumulator to return value
			pop $ra
			return
			nop
		UART_not_a_semicolon:
		# Check for space indicating end of number
		bne $v0, $t8, UART_not_a_space
			nop
			jal store_num_in_arrays
			addiu $v1, $v1, 1	#increment array length during branch delay slot
			move $t0, $0	#clear input
			j UART_read_loop
			nop
		# Assume value is a number, convert to binary
		UART_not_a_space:
			mullo $t0, $t0, $t5	#multiply current number by 10
			subu $v0, $v0, $t6	#convert UART character from ascii to decimal
			addu $t0, $t0, $v0
			j UART_read_loop
			nop

store_num_in_arrays:
	sw $t0, 0($t1)
	sw $t0, 0($t2)
	sw $t0, 0($t3)
	sw $t0, 0($t4)
	addiu $t1, $t1, 4
	addiu $t2, $t2, 4
	addiu $t3, $t3, 4
	addiu $t4, $t4, 4
	addu $s3, $s3, $t0	# Update accumulator
	jr $ra
	nop


sort_validator:
	push $ra
	li $a3, 49		# error message input
	li $a0, array1
	jal single_array_sort_validator
	nop
	jal print_validator_output
	nop

	li $a3, 50		# error message input
	li $a0, array2
	jal single_array_sort_validator
	nop
	jal print_validator_output
	nop

	li $a3, 51		# error message input
	li $a0, array3
	jal single_array_sort_validator
	nop
	jal print_validator_output
	nop

	li $a3, 52		# error message input
	li $a0, array4
	jal single_array_sort_validator
	nop
	jal print_validator_output
	nop

	li $a3, 10 # New Line
	jal put_char
	nop

	pop $ra
	return
	nop

# Inputs:
# 	a0 - array starting address
# 	a1 - array length
#	a2 - accumulator
# Outputs:
# 	v0 - 1 = pass, 0 = fail
single_array_sort_validator:
	li $t0, 0	# loop counter
	li $t1, 0	# accumulator
#	li $t2, 1
#	subu $t2, $a1, $t2	#subtract 1 from array size
	li $s0, 0	# previous number
	li $v0, 0 # return value initialized as fail
	validator_loop:
		lw $s1, 0($a0)
		addu $t1, $t1, $s1	# update accumulator
		slt $t3, $s1, $s0	# compare current and previous number
		bne $t3, $0, exit_validator_loop	# previous < current, exit with fail condition
		addiu $t0, $t0, 1	# increment loop counter during branch delay slot
		move $s0, $s1	# update previous number
		bne $t0, $a1, validator_loop	# check if end of the array reached
		#bne $t0, $t2, validator_loop	# check if end of the array reached
		addiu $a0, $a0, 4	# increment array address during branch delay slot
	bne $a2, $t1, exit_validator_loop	# exit with failure if accumulators don't match
	nop
	ori $v0, $v0, 1	# return set to pass
	exit_validator_loop:
	jr $ra
	nop

print_validator_fail_message:
	.asciiw "FAILED Array "
print_validator_pass_message:
	.asciiw "Passed Array "

# a3 - array number character
print_validator_output:
	push $ra
	push $a3
	li $t1, 12	# Character total
	li $t2, 0	# Counter
	beq $v0, $0, load_fail_address
		nop
		li $s3, print_validator_pass_message
		j print_error_loop
		nop
	load_fail_address:
		li $s3, print_validator_fail_message
	print_error_loop:
		lw $a3, 0($s3)
		jal put_char
		addiu $s3, $s3, 4 # increment array address during branch delay slot
		bne $t2, $t1 print_error_loop
		addiu $t2, $t2, 1 # increment counter during branch delay slot
	pop $a3
	jal put_char
	nop
	li $a3, 10 # New Line
	jal put_char
	nop
	pop $ra
	jr $ra
	nop
			




#Description: Reads UART and returns it in $v0
# Uses s2, s4, v0 
get_char:
	get_char_busy_wait:
		lw $s4, 4($s0)	#load status register
		and $s4, $s4, $s2	#mask for ready bit
		bne $s4, $s2, get_char_busy_wait
		nop
	lw $v0, 8($s0)	#load from recieve buffer
	sw $s2, 0($s0)	#command register: clear status
	jr $ra
	nop

#Description: Writes value in $a3 to UART
# Uses: s0, s1, t0, 
put_char:
	li $s0 0xF0000000	# UART
	li $s1 0b01	# Status register bit mask
	put_char_busy_wait:
		lw $t0, 4($s0)	#load status register
		and $t0, $t0, $s1	#mask for clear to send
		bne $t0, $s1, put_char_busy_wait
		nop
	sw $a3, 12($s0)	#store in send buffer
	sw $s1, 0($s0)	#command register: send
	jr $ra
	nop
