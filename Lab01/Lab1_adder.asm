.data
	msg: .asciiz "Result is "
	
.text
	# Add integer
	li $t0, 16	# t0 = 16
	add $t0, $t0, 4	# t0 = 20
	addi $t0, $t0, $t1
	
	# Display Result
	li $v0, 4	# v0 = 4
	la $a0, msg	# a0 = "Result is "'s address
	syscall			# print # "Result is "
	li $v0, 1	# v0 = 1
	move $a0, $t0	# a0 = t0 ( 20 )
	syscall			# print # a0
	
	# End Program
	li $v0, 10	# v0 = 10
	syscall			# print

