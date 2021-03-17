.data
	msg: .asciiz "Hello World\n"
	
.text
	li $v0, 4
	la $a0, msg
	syscall
	
	# End program
	li $v0, 10
	syscall
	
