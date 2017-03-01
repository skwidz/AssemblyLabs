#cmpt229
#chrisitan ellinger
#lab5 

#question 2:
# Write a MIPS assembly program that has an initialized C-style string in the global
# data. Then, write code to determine and output the logical string length 
# (excluding the nullterminator).
# To determine the string length, write a loop that starts
#  at the base address of the string and counts all
#  of the non-null characters before the null terminator.

#### Variable usage ###
#	a0: the element counter
#	t1: the element being examined in each iteration of the loop
######

	.data
	#below is the C-style string
	#str: .word  72, 97, 114, 114, 121, 32, 80, 111, 116, 101, 114, 0 #IS THIS A CSTYLE SRTRING?
	st: .asciiz "hi there!" #string for searching NO THIS IS A C STYLE STRING!!!!
	
	
	.text
	#load address of array, 
	
loop:	lb $t1, st($a0) #load the byte for each letter. 
	#lw $t1, str($a0) #load the element at position $t0 (starts at zero)
	beqz $t1, out	#jump to output if the value is the null terminator 
	addi $a0, $a0, 1 #increment the counter
	b loop #go back to the start of the loop
	
out:	#srl $a0, $a0, 2 #divide counter value by 4 to get number of elements
	li $v0, 1 #load instruction to print the counter value
	syscall
	
	##END PHASE
	li $v0,10 #load instruction for exititng
	syscall #program end
	
