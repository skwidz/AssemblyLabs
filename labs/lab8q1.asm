#cmpt 229
#lab 8 
#christian Ellinger

#question 1: Quicksort
#	- must have both a quicksort function and a partition function
#	-Follow all parameter passing conventions (regarding ASM frame)
#	-Standard implementation: Pivot element is first element
#	-cite psudo-code sources
#	-Must setup quicksort function call in main,
#		then call quicksort
#		then print the sorted array (with spaces)
#	-can hardcode the array in data
#

#---------- PSUDO-CODE SOURCES ---------
#	https://en.wikipedia.org/wiki/Quicksort
#	https://learn.macewan.ca/bbcswebdav/pid-1359080-dt-content-rid-4211043_1/courses/001175-01-2171-1-41L-13587/Lab%208/Lab%208%20-%20Suggested%20algorithms%20to%20use.pdf?target=blank
#	https://www.youtube.com/watch?v=aQiWF4E8flQ


## Data Section
.data
#	note: the offset is calculated as:  offset =(arrayLength * 4)
	A: .word 5, 1, 3, 6, 2, 4, 2 #an array of values
	offset: .word 24 # the offset to get the end of the array
	len: .word 7 #length of the array
.text

### Main Function ###

#	Variable Usage:
#	a0: (address) holds th address of the array
#	a1: (address) holds the address of the last element of the array
#	t0: (int) temp variable, used for geterating the end address (a1)

	la $a0, A #load the address of the array
	lw $t0, offset #load the ofset value into t0
	add $a1, $a0, $t0 #create the end pointer for the function
	jal quicksort #run the quicksort function
	
	la $a0, A #reload the startinf address of the array
	lw $a1, len #load the array length
	jal printArray #print the sorted array 
	
	li $v0, 10 #load the instruction for exit 
	syscall #exit 
### End of Main
	
			
#### printArray FUNCTION 

#	THIS IS A LEAF FUNCTION

#	this function prints out elements of an array

#	parameters
#	a0: (address) the starting address of the array
#	a1: (int) the length of the array used as index

#	variable usage 
#	t0: (address) temorary variable to save a0 in

printArray:
	li $v0, 1 #load syscall for print int
	move $t0, $a0 # load the start address into a temp variable
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
	

### Quicksort Function ###
### THIS IS A NON-LEAF FUNCTION ##
### Recursive function ###
#	This function takes a list and sorts it using the Quicksort method
#	calls Partition

# Takes a low address and a hi address
#	Parameters: 
#	a0: (address) low address
#	a1: (address) high address


quicksort:
	addi $sp, $sp, -12 #allocate memory space for ra and left and right address
	sw $ra, 8($sp)	#store the return address on the stack
	sw $a0, 4($sp)	#store the left pointer on the stack
	sw $a1, 0($sp)	#store the right pointer on the stack
	#basecase: if (left < right) - array only has one element
	bge $a0, $a1, endQS #break if left < right
	
	jal partition #call the partition function
	lw $a1, 0($sp) #restore the right index
	lw $a0, 4($sp) #restore the left index
	sw $v0, 4($sp) #save the index value on the stack as the left pointer
		#this is so we can have these values when we make the second quicksort call
	move $a1, $v0 #set the right index to the return value from partition
	addi $a1, $a1, -4 #incrememnt the right index so its off the pivot value
	jal quicksort #run the quicksort function on the lower half
	lw $a1, 0($sp) #restore the right index 
	lw $a0, 4($sp) #restore the left index
	addi $a0, $a0, 4 #move the left index up one so its one before the pivot
	jal quicksort # run the quiksort function 
endQS:
	lw $ra, 8($sp) #restore the stack ponter
	addi $sp, $sp, 12 #deallocate the used stackspace. 

########## end of function ##########	
	
### Partition Function ###
### THIS IS A LEAF FUNCTION  ####

#	this function sorts an array that it is passed, 
#	based on values that are greater or less than the pivot element
#	The pivot element is chosen to be the first element in the array

#	Parameters: 
#	a0: (address) left address of the array 
#	a1: (address) right address of the array

#	Variable Usage:
#	
#	$t1: (address) left side address LEFT iterator - "i"'
#	$t2: (address) right side address RIGHT iterator - "j"
#	$t3: (int) temp variabe for value retreval
#	$t4: (int) another temp variable 
#	$t5: (int) Value of the pivot element

#	Return Values:

#	$v0: (address) address of the pivot element
partition: 
	#if left address = right address +1, break
	
	#move $t0, $a0 #init t0 as the pivot address
	lw $t5, ($a0) #load the value of the pivot into t5
	move $t1, $a0 #init t1 as the left address
	addi $t1, $t1, 4 #increment the left side address to skip comparing pivot to itself
	move $t2, $a0 #init t2 as the starting address
	#add $t2, $t2, $a1 #get to the last element of the array(plus one)
	#subi $t2, $t2, 4 #point to the last element address and not one after.
	move $t2, $a1 #set the right side iterator to the right side of the array
loopPart:
	bge $t1, $t2, movePivot # branch if (i < j) 	
	
leftTest:	
	lw $t3, ($t1)#get the value of the elemet at position i
	bgt $t3, $t5, rightTest #end subloop if array[i] > pivot value
	addi $t1, $t1, 4 #increment i (left iterator)
	j leftTest #loop
rightTest:
	lw $t3, ($t2) # get the value of the right side element
	ble $t3, $t5, moveElements #end subloop if array[j] <= pivot
	subi $t2, $t2, 4 #decrement j (right iterator)
	j rightTest #loop

moveElements:
	bge $t1, $t2, movePivot # branch if (i < j)
	lw $t4, ($t1) #get the value of the element at position i
	sw $t3, ($t1) #set the value of array[i] to array[j]
	sw $t4, ($t2) #set the value of array[j] to array[i]
	j loopPart #go back to start of loop 
movePivot: 
	lw $t3, ($t2) #get the value of array[j]
	sw $t5, ($t2) #put the pivor element in array[j]
	sw $t3, ($a0) #put array[j] value in pivot position
	move $v0, $t2 #return address where the pivot got placed
	jr $ra #return to calling function 

########## end of function ##########
