# lab 7 q2
#cmpt 229 
# christian ellinger 

### Global Declarations #######
.data 
A: .word 1, 1, 1, 1, 1, 1, 1 #an array of numbers
len: .word 7 #the length of the array
lentwo: .word 7 #secong buffer for a workaround for the CRAZY ERROR I WAS GETTING
## LEN AND LENTWO MUST BE THE SAME THING 
starter: .word 5 #the starter value fot



#### Code Segments #######
.text 

##QUESTION TWO

#------ MAIN FUNCTION ------
	la $a0, A #load first address of A into a0; 
	lw $a1, len #load the array length into 
	lw $a2, starter #load the starter int into a2;
	
	jal fillArray
	#after this function call, the array elements should have different values
	
	
	la $a0, A #load the first address of A into a0
	
	#this line is setting the a1 buffer to a buffer that isnt len, when i set it to len
	#i didnt want to have to use lentwo, but i had no idea why it was breaking
	lw $a1, lentwo #load the length into a1 
	jal printArray #print the contents of the array
	
	li $v0, 10 #load syscall to exit 
	syscall #exit the program
	

########## end of function ##########

#### printArray FUNCTION 

#	THIS IS A LEAF FUNCTION

#	this function prints out elements of an array

#	parameters
#	a0: (address) the starting address of the array
#	a1: (int) the length of the array used as index

#	variable usage 
#	t0: temorary variable to save a0 in
printArray:
	li $v0, 1 #load syscall for print int
	move $t0, $a0
forPArray:
	beqz $a1, returnPArray #return if the index (a1) is zero
	lw $a0, ($t0) #load the int at address t0 into a0, so it can be printed
	syscall# print a0
	addi $t0, $t0, 4 #increment the address
	subi $a1, $a1, 1 #decrement the array length
	j forPArray #loop
	
returnPArray:
	jr $ra #return to calling function
	
	
########## end of function ##########

#### fillArray FUNCTION 

#	THIS IS NOT A LEAF FUNCTION

#	this function iterates thhrough an array of integers and each element 
#	to be the sum of the remaining elements of the array

#	This function has no return value
#
#	parameters
#	$a0: (address) starting address of an array
#	a1: (int) length of the array 
#	a2: (int) an integer to set the first element value to

#	variable usage
#	$t0: (address) holds the index address for the forloop 


fillArray:	
	addi $sp, $sp, -16
	sw $ra 12($sp) #save the return address on the stack 
	sw $a0, 8($sp) #put the starting address on the stack
	sw $a1, 4($sp) #put the array length on the stack
	sw $a0, 0($sp) #load address for the loop index onto the stack
	move $t0, $a0 #set the temp variable to the first address
	sb $a2, ($a0) #set the starter int to the first address
forFA: 
	beqz $a1, returnFA #go to return if we have reached the end of the array
	jal termInt #call the term int function
	#after this call v0 will be set to the ouput of the function
	lw $t0, 0($sp) #restore the index address
	addi $t0, $t0, 4 #increment the index address
	sw $v0, ($t0) #save the sum amount into the array index address
	lw $a1, 4($sp) #restore the array length
	subi $a1, $a1, 1 #decrement the array length
	lw $a0, 8($sp) #reload the starting address of the stack
	sw $a1, 4($sp) #save the new array length on the stack
	sw $t0, 0($sp) #save the new index address on the stack
	j forFA #loop
returnFA:
	lw $ra 12($sp) #get the return address off the stack
	addi $sp, $sp, 16 #pop things off the stack 
	jr $ra #return to calling function 
	
########## end of function ##########

##### termInt FUNCTION 

#	THIS IS A LEAF FUNCTION 

#	this function summs the specified number of array
# 	elements and returns that sum
	
#	parameters
#	a0: (address) starting address of the array
#	a1: (int) number of elements to be summed (element counter)

#	return values 
#	v0: (int) the sum of the specified number of array elements

#	variable usage
#	t0: (int) temporary variable for getting array element

termInt:	

	move $v0, $0 #init the sum to zero
	move $t1, $0 #init the counter to 0
forTInt:	
	beqz $a1, returnTInt #go to return if the counter is at the end
	lw $t0 ($a0) #load the fisrt byte into the temp variable
	add $v0, $v0, $t0 #add the array element to the sum
	addi $a0, $a0, 4 #increment the array address
	subi $a1,$a1, 1 #decrement the element counter
	b forTInt #go to start of loop
returnTInt:
	#at tis point the sum will be in v0, so we can just return
	jr $ra
	
########## end of function ##########
	