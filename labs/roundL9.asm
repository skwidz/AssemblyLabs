#cmpt229 
#Lab9
#Christian Ellinger

#Question 1: write a function ROUND that gets a float and returns an integer 
# the function rounds off the float to the nearest integer 

.text

### main function ###
# Takes a float and calls round on it, returns an integer. 

#	Variable usage: 
#	f12: input for the round function
#	f0: output of the round function 
#	v0: variables for syscalls

	li $v0, 6 #load instruction to read float
	syscall
	mov.s $f12, $f0 #move the input into the $f12 register
	jal round #call the round function 
	mov.s $f12, $f0 #move the output of function into f12, to be printed
	li $v0, 2 #load syscall for print float 
	syscall
	li $v0, 10 #load syscall for exit 
	syscall

############  END OF MAIN ############

### Round Function ###
# This function takes a float and returns an integer 
# Rounds off the float to the nearest integer. 

	
# 	Parameters:
#	$f12: the floating point input value 

#	Return values: 
#	$f0: = rounded float


round: 	
	round.w.s $f0, $f12 #round the input, store the result in f0 as a word
	cvt.s.w $f0, $f0 #convert the word back to a float(single perc)
	jr $ra #return to caller
	
# end of function
	
	

	
	
	
	
	
