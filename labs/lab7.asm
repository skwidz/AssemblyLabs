# lab 7 
#cmpt 229 
# christian ellinger 

### Global Declarations #######
.data 



#### Code Segments #######
.text 

##QUESTION ONE


##### ------- MAIN SEGEMNT -------
li $a0, -4 #load int into a0 for function parameters
li $a1, 3 #load int into a1 for function parameters
jal positive #call the positive function

move $a0, $v0 #set a0 to the value of v0
li $v0, 1 #load syscalls for print int
syscall

li $v0, 10 #load instruction for exiting
syscall #exit the program


# Positive function 
#	parameters
#	a0: int x
#	a1: int y
positive:	 	
	sw $ra, 0($sp)#save ra on the stack
	jal addint #jump to addint function
	#addint runs
	blez $v0, less #branch if the return value isnt greater than zero
	li $v0, 1  #set return to 1, as its positive
	b return #jump to return bit
less:	
	move $v0, $0 #set return value to zero, since its non-positive
return: 
	lw $ra 0($sp) #restore the stack pointer
	jr $ra #jump back to calling function 
	
	
	
	
	
#add int function (leaf function)
#	parameters
#	a0: int x 
#	a1: int y
#	return
#	v0: the sum of x and y
addint: 
	add $v0, $a0, $a1 #add the two parameters (a0, a1), and store in v0  
	jr $ra #jump back to calling function 
	
	

