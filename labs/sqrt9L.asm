#cmpt229
#lab9
#question 2
#christian Ellinger

######  Question 2 #####
#Create a square root function named sqrt that receives a float value (x) in $f12
#and returns the square root (y) of x as a float in $f0.
# If the input value x is negative, then the
#function should return NaN.

#This function is to use Newton’s method (when appropriate) to approximate the square root
#y. To determine the value of y, this method uses an initial approximation of y0 = 1. The
#subsequent approximation is yi+1 = 0.5 * (yi + x/yi). 
#This function is to iterate 10 times and return the value y10

#	psudocode for newtons method implementaton:
#	https://en.wikipedia.org/wiki/Newton's_method#Pseudocode

# Data Section
.data
	newline: .asciiz "\n"
	zero: .float 0.0 #a float for zero
	one: .float 1.0 #a float for 1
	half: .float 0.5 #a float for 0.5
	input1: .float 40000 #the first input value
	input2: .float -9 #the second input value 
	input3: .float 12345 #the third input value
	input4: .float 0.000025 #the fourth input value 
.text
### Main Function Section
#	purpose:
#	preps float values from data segment, and calls sqrt function on them

#	variable usage
#	$f12: input float for the sqrt function
#	$f0: output of the aqrt function
#	$v0: function calls

	l.s $f12, input1 #load first input into f12 
	jal sqrt #call the sqrt function
	mov.s $f12, $f0 #move the function result into f12
	la $a0 newline 
	li $v0, 2 #load syscall for print float 
	syscall #do a syscall
	li $v0, 4 #load syscall for print string
	syscall #do a syscall
	
	l.s $f12, input2 #load first input into f12 
	jal sqrt #call the sqrt function
	mov.s $f12, $f0 #move the function result into f12 
	li $v0, 2 #load syscall for print float 
	syscall #do a syscall
	li $v0, 4 #load syscall for print string
	syscall #do a syscall
	
	l.s $f12, input3 #load first input into f12 
	jal sqrt #call the sqrt function
	mov.s $f12, $f0 #move the function result into f12 
	li $v0, 2 #load syscall for print float 
	syscall #do a syscall
	li $v0, 4 #load syscall for print string
	syscall #do a syscall
	
	l.s $f12, input4 #load first input into f12 
	jal sqrt #call the sqrt function
	mov.s $f12, $f0 #move the function result into f12 
	li $v0, 2 #load syscall for print float 
	syscall #do a syscall
	li $v0, 4 #load syscall for print string
	syscall #do a syscall
	
	li $v0, 10 #load syscall for exit 
	syscall #do a syscall
	
######## END OF Main #######

### Squrt Section ###

######	purpose: aproximate the square root of an input float 
#	the function runs for 10 iterations then returns the value
	

## 	Parameters 
#	$f12: (x) a float value to be rooted

##	Return values:
#	$f0: The approxamate root of the function

##	Variable Usage:
#	t0: iteration counter
#	$f4: temp variable for yi calculation, and zero comparison
#	$f5: (yi) y variable
#	$f6: 0.5 float value for calculaton
sqrt:	
	move $t0, $0 #initalize the iteration counter
	l.s $f4, zero #set f4 to zero for compare 
	c.lt.s $f4, $f12 #set coproc1 flag 0 to false if f12 is less than zero 
	bc1f notNum #jump to nan section if the number is neg
	l.s $f5, one #initialize y0 to 1
	l.s $f6, half #initialize f6 to 0.5
	
	#need to test if number is negitive
loop:
	beq $t0, 10, return #go to return if the loop is done 
	div.s $f4, $f12, $f5 #set f4= x/yi
	add.s $f4, $f4, $f5 #set f4 = (yi + x/yi)
	mul.s $f5, $f4, $f6 #set f5 = yi+1 = 0.5 * (yi + x/yi) 
	addi $t0, $t0, 1 #increment the loop counter
	j loop #loop
notNum:
	
	l.s $f4, zero #load zero into f4 to make NaN
	div.s $f0, $f4, $f4 #0/0 is NaN so do that 
	jr $ra #return to calling function
return:
	mov.s $f0, $f5 #move y10 into return slot 
	jr $ra #return to calling function 
	
######## END OF FUNCTION #######	
	