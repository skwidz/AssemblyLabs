#lab 10 
#cmpt 229
#christian Ellinger

#Question 1:
#using memory mapped I/O, write a function READS thqt inputs a string from 
#the keyboard or the keyboard simulator. The calling function must pass a 
#buffer address to READS, the buffer address is passed into $a0 and its 
#physical length in $a1. The reads function places characters in the buffer
#untill the return key (ASCII 0xA) is pressed, it then appends the null 
#terminator onto the string instead of the return key value

#NOTE: the fiction READS, must also not overflow the buffer. So the len
# of the string = bufferLen-1 (to have space for null terminator)
#Once the buffer is full, any extra chars will simply be ignored untill the
#user pressed the enter key. Reads will only return on ENTER

.data
	buffer: .space 4			#the buffer to store the word in
	length: .word 4 			#the length of the buffer
	ofString:    .asciiz "too many characters\n Buffer Contents: "	#a string to print when there is buffer overflow
	enterString: .asciiz "pressed enter\n Buffer Contents: "	#string to print when there is no overflow
.text

##### MAIN Function ####

#	Function Purpose 
#	sets up the parameters for the READS function
#	when READS returns, it prints the contents of the buffer
#	it gave READS to stdout, and prints a message indicating if the buffer had overflow

#	variable usage:
#	$a0, address of the buffer, parameter for READS
#	$a1, length of the buffer, parameter for READS
#	$v0, return value of READS, also used for syscalls

	

main:
	la $a0, buffer 		#load the address of the buffer into a0 
	lw $a1, length 		#load the buffer length into a1
	jal reads		#call the reads function
	beqz $v0, enterPressed	#check if the buffer was overflown, break if not
	la $a0, ofString		#load the "overflow" string into a0 for printing 
	j printing		#jump to printing segment
enterPressed:
	la $a0, enterString	#load the overflow string into a0 for printing
printing:	
	lw $a1 length		
	li $v0, 4		#load syscall for print string into v0 
	syscall		#print the string
	la $a0, buffer		#load the buffer address into a0 

	syscall 		#print the contnents of the buffer
	
	li $v0, 10 		#load syscall for exit
	syscall 		#exit 
#### READS Function ####

######	Function purpose:
#	this function reads keyboard input into a buffer specified 
#	by the caller (in the parameters) the function adds pressed 
#	characters to the buffer untill the length reaches the buffer 
#	length (specified in parametrs) and appends the null terminator
#	The function will poll keyboard input untill the ENTER key 
#	is pressed, at which point the function will return

####	Variable Usage	#####

#	Parameters:
#	$a0, buffer address
#	$a1, length of the buffer

#	Variable Usage:
#	$t0, holder for keyboard control address
#	$t1, value of the keypress, also used as a temp variable at the end of READS
#	$v0, used for syscalls

####	Return values
#	$v0, 0 if the buffer was not overflown, 1 if it was


reads:
	li $v0, 0 		#init retrun value to zer0 
	li $t0, 0xffff0000 	#load keyboard controll base address into $a2
kbLoop:
	lw $t1, 0($t0)		#read kb control register into t1
	andi $t1, $t1, 1 	#mask the register value to get the ready bit
	beqz $t1, kbLoop		#return to polling if the key is not pressed
	##key is pressed
	 
	lw $t1, 4($t0)		#read the Value of the data register
	sb $t1, ($a0)		#store the keypress value in the buffer
	beq $t1, 10, enter	#break if the keypress is an enter
	ble $a1, 1 overflow	#break if the buffer is full, dont add to it
	addi $a0, $a0, 1 	#decrement the address of the buffer to store the next word
	subi $a1, $a1, 1		#decrement the buffer length
	j kbLoop
overflow:	
	li $v0, 1		#set the return value to 1, buffer overflowed
	j kbLoop		#go back to start of the loop
enter:
	#return here
	li $t1, 0  		#load in a null terminator
	sb $t1, ($a0)		#put the null terminator at the end of the array
	jr $ra		#return to calling function 

### --------- END OF FUNCTION -------- 