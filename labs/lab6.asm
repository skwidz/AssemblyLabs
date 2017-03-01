#cmput 229
# Christian Ellinger
# Lab 6
#

#any data declarations go here

.text

#### main variable usage
#	$a0: buffer memory location 
#	$a1: length of th buffer


# -------------- MAIN ---------------
	li $a0, 64 #load the memory size into 
	li $a1, 64 #load 64 bits of space for the string (for later)
	li $v0, 9 #load syscall for memory alocation
	syscall
	move $a0, $v0 #move the allocated memory address into a0 

	jal input #jump to input function
	   #INPUT FUNCTION RUNS
	jal toUpper
	   #TO UPPER FUNCTION RUNS 
	move $a1, $v0
	jal strRev
	   #STRING REVERSE FUNCTION RUNS
	li $v0,4 #load instriction to print string 
	syscall  #print the string
	
	li $v0, 10 #load instruction to exit program
	syscall #exit
	
# -------------------- 
	
########## INPUT FUNCTION declaration
#	parameters
#	a0: the address of the storage buffer
#	a1: the size of the buffer	

input: 
	#as a default, read_string takes a0 as a buffer address
	#and a1 as a length, so that will work fine
	li $v0, 8 #syscall code to read a string inton memory 
	syscall
	#leaf function so use jr
	jr $ra #return to calling functino
###############	

###### toUpper function declaration #####
#	parameters	
#	$a0: address of string buffer
#	$a1: length of string buffer (returned)

#	variables
#	$t0: buffer element index
#	$t1: buffer element
#	$s0: end address of the buffer

toUpper:
	la $t0, ($a0)  #put the start address of the string in t0
loop:
	lb $t1, ($t0) #load the fisrt byte of the input into t1
	beqz $t1, done #if the byte is null, break
	blt $t1, 0x61, increment #check lower bounds for uppercase hex vals
	bgt $t1, 0x7A, increment #check upper bounds for uppercase hex vals
	#The letter is a lower case, change it to upper case
	subi $t1, $t1, 0x20 #increment the ascii value
	sb $t1, ($t0)#update the changed byte
	
	
increment:
	addi $t0, $t0, 1 #increment the index to point at thenext byte
	b loop #go back to loop
done:
	#leaf function so use jr
	move $v0, $t0 #move end address of the string into s1 for grease later
	jr $ra #return to calling function 
	
################

######## stringRev Function declaration
#
#	parameters
#	a0: address of the string
#	a1: end address of the string

#	variables
#	$t0, address of the start of the string
#	$t1, temp variable fot the swapped values
#	$t2, another temp variale for swap

strRev: 
	la $t0, ($a0) #load the starting address into t0 
	subi $a1, $a1, 1 #decrement the end address of the string so its not at the null terminator
looop:	bge $t0, $a1 , end #if the end address is lt or eq the start address, youre done
	lb $t1 ($t0) #load the front byte into the temp
	lb $t2 ($a1) #load the back byte into the second temp
	sb $t1 ($a1) #save the front byte in the back address
	sb $t2 ($t0) #save the back byte in the front address
	addi $t0, $t0, 1 #increment the front address
	subi $a1, $a1, 1	#decrement the back address
	b looop  #go back to start of the loop
end: 
	jr $ra #return to calling function
#############			
	