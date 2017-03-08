#lab 8
#cmpt 229
#chrisitan ellinger

#Q2 Implement euclidian algorithm for GCD


.text
### Main Function ###
	li $a0, 100 #move a value into a0 
	li $a1, 0 #move a value into a1
	jal gcd #run the gcd function 
	move $a0, $v0 #move the result into a0
	
	li $v0, 1 #load the syscall for print int 
	syscall
	li $v0, 10 #load the syscall for exit
	syscall
### Gcd function ### 
# this is a recusive function that calculates the GCD of th two input numbers
#
# 	Parameters:
#	a0: (int) first integer
#	a1: (int) second integer


#  int GCD(int i, int j) {
#	int k = i mod j;
#	if k == 0
#	  return j
#	else
#	  return GCD(j, k)
#   }


gcd: 	
	addi $sp, $sp, -4 #allocate stack space
	sw $ra, 0($sp) #save the return address to the stack
	
	#TODO: if the two are equal, return
	bgt $a0, $a1, div2 #make sure a0 is smaller that a1
	move $t0, $a1 #move the smaller number into temp
	move $a1, $a0 #move a0 into a1
	move $a0, $t0 #move the larger value into a1
div2:	div $a0, $a1 #divide the larger number by the smaller number
afterDiv:	mfhi $t1 #move the remainder into t0
	beqz $t1, return #return if the remainder = 0
	#else recurse
	move $a0,$t1 #set the larger of the numbers as the remainder
	jal gcd
return:
	move $v0, $a1 #move the gcd into v0
	lw $ra, 0($sp) #restore the return address
	addi $sp, $sp, 4 #deallocate stack space
	jr $ra
	