.data
	array: .space 256
	array_odd: .space 256
	array_even: .space 256
	msg1: .asciiz "....Bubble Sort...."
	msg2: .asciiz "\nEnter Input Length: "
	msg3: .asciiz "\nEnter Input Values: "
	msg4: .asciiz "\nSorted Odd : "
	msg5: .asciiz "\nSorted Even: "
	newl: .asciiz "\n"
	spce: .asciiz " "

.text
	main:
		# Display program title
		li $v0, 4		# System call to print a string
		la $a0, msg1		# Load (msg1) address to the argument register
		syscall
		
		# promt user to enter input length
		la $a0, msg2		# Load (msg2) address to the argument register
		syscall
		
		# Get the user's input
		li $v0, 5		# System call to get integer from the keyboard
		syscall
		move $t0, $v0		# Move the user input to $t0
		
		li $v0, 4		# System call to print a string
		la $a0, msg3		# Load (msg3) address to the argument register
		syscall
		jal newline		# Call newline
		
		addi $t1, $zero, 0	# Initialize scanloop counter
		addi $t2, $zero, 0	# Initialize data segment address counter
	
# Scanning, filtering
###	# ---------------- ---------------- ---------------- ----------------
	scanloop:
		beq $t0, $t1, initsort_odd	# If counter is equal to input length in $v0 then branch initsort
		li $v0, 5		# System call to get integer from the keyboard
		syscall
		sw $v0, array($t2)
		
		# temp1 = v0 & 1
		and $t3, $v0, 1
		beq $t3, 1, storeodd
		beq $t3, 0, storeeven

	storeodd:	# if temp == 1, temp1 is odd
		sw $v0, array_odd($t5)
		addi $t5, $t5, 4
		addi $s1, $s1, 1
		b stored
		
	storeeven:	# if temp == 0, temp1 is even
		sw $v0, array_even($t6)
		addi $t6, $t6, 4
		addi $s2, $s2, 1
		b stored
		
	stored:
		addi $t2, $t2, 4	# Update data segment address counter
		addi $t1, $t1, 1	# Update loop counter
		
		j scanloop		# Goto scanloop

# Sorting
###	# ---------------- ---------------- ---------------- ----------------
	initsort_odd:
		subi $s1, $s1, 1
		addi $t3, $zero, 0	# Initialize i counter
	
	# ---------------- ---------------- ---------------- ----------------
	outerloop_odd:
		beq $s1, $t3, initsort_even
		
		addi $t2, $zero, 0	# Initialize data segment address counter
		addi $t4, $zero, 0	# Initialize j counter
		
		j innerloop_odd
		
	nexti_odd:
		addi $t3, $t3, 1	# Update i counter by 1
		j outerloop_odd		# Goto outerloop
		
	innerloop_odd:
		beq $s1, $t4, nexti_odd
		
		lw $t5, array_odd($t2)	# Load from data segment address plus $t2 offset to $t5
		addi $t2, $t2, 4	# Add offset by 4 bytes
		lw $t6, array_odd($t2)	# Load from data segment address plus $t2 offset to $t6
		
		bgt $t5, $t6, swap_odd	# If $t5 is Greater than $t6 then swap
		
	nextj_odd:
		addi $t4, $t4, 1
		j innerloop_odd
		
	swap_odd:
		subi $t2, $t2, 4	# Subtract offset by 4 bytes
		sw $t6, array_odd($t2)	# Store from $t6 to data segment address plus $t2 offset
		addi $t2, $t2, 4	# Add offset by 4 bytes
		sw $t5, array_odd($t2)	# Store from $t5 to data segment address plus $t2 offset
		j nextj_odd		# return to nextj
	
###	# ---------------- ---------------- ---------------- ----------------
	initsort_even:
		subi $s2, $s2, 1
		addi $t3, $zero, 0	# Initialize i counter
	
	# ---------------- ---------------- ---------------- ----------------
	outerloop_even:
		beq $s2, $t3, initdisp_odd
		
		addi $t2, $zero, 0	# Initialize data segment address counter
		addi $t4, $zero, 0	# Initialize j counter
		
		j innerloop_even
		
	nexti_even:
		addi $t3, $t3, 1	# Update i counter by 1
		j outerloop_even	# Goto outerloop
		
	innerloop_even:
		beq $s2, $t4, nexti_even
		
		lw $t5, array_even($t2)	# Load from data segment address plus $t2 offset to $t5
		addi $t2, $t2, 4	# Add offset by 4 bytes
		lw $t6, array_even($t2)	# Load from data segment address plus $t2 offset to $t6
		
		bgt $t5, $t6, swap_even	# If $t5 is Greater than $t6 then swap
		
	nextj_even:
		addi $t4, $t4, 1
		j innerloop_even
		
	swap_even:
		subi $t2, $t2, 4	# Subtract offset by 4 bytes
		sw $t6, array_even($t2)	# Store from $t6 to data segment address plus $t2 offset
		addi $t2, $t2, 4	# Add offset by 4 bytes
		sw $t5, array_even($t2)	# Store from $t5 to data segment address plus $t2 offset
		j nextj_even		# return to nextj
		
# Printing
###	# ---------------- ---------------- ---------------- ----------------
	initdisp_odd:
		addi $s1, $s1, 1
		addi $t1, $zero, 0
		addi $t2, $zero, 0
		
		li $v0, 4
		la $a0, msg4
		syscall
		
	display_odd:
		beq $s1, $t1, initdisp_even
		
		li $v0, 1
		lw $a0, array_odd($t2)
		syscall
		jal onespace
		
		addi $t1, $t1, 1
		addi $t2, $t2, 4
		
		j display_odd
	
###	# ---------------- ---------------- ---------------- ----------------
	initdisp_even:
		addi $s2, $s2, 1
		addi $t1, $zero, 0
		addi $t2, $zero, 0
		
		li $v0, 4
		la $a0, msg5
		syscall
	
	display_even:
		beq $s2, $t1, end
		
		li $v0, 1
		lw $a0, array_even($t2)
		syscall
		jal onespace
		
		addi $t1, $t1, 1
		addi $t2, $t2, 4
		
		j display_even

# Utils
###	# ---------------- ---------------- ---------------- ----------------
	onespace:
		li $v0, 4
		la $a0, spce		# Load (newl) address to the argument register
		syscall
		jr $ra			# Jump to return address
	
	newline:
		li $v0, 4		# System call to print a string
		la $a0, newl		# Load (newl) address to the argument register
		syscall
		jr $ra			# Jump to return address
	
	end:
		li $v0, 10		# System call to end the program
		syscall
