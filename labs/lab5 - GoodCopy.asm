#cmpt229
#chrisitan ellinger
#lab5 


#question 1:
#	initialise a global array of word, length 5 or more)
#	and a global word var containing the array length
#	using a LOOP, sum the array elements and print the 
#	Sum, Max, and Min of the elements of the array.
#	Use pointer arithmetic

#########NOTES 
# for word types, the displacement of each element in an array is 4 bytes

### Variable usage ###
#	$t0: 
#	$t1: position for iterating through the array
#	$t2: Max value from the array
#	$t3: min value from the array
#	$t4: sum of the elements
#	$t5
#
### Global Declarations ##

	.data
A: 	.word 1, 3, 3, -1, 7, 12, 1 #array of numbers
x:	.word 7 #length of the array
sumout:	.asciiz "The sum of the array is: "
maxout: 	.asciiz "\nThe largest number in the array is: "
minout:	.asciiz "\nThe smallest number in the array is: "
	
	.text
### Init section #####
  	
	la $t5, x #load address of the length into $t5
	lw $t5, ($t5) #load the array length into t5
	sll $t5 $t5, 2 #multiply the length by 4
	
#loop section	
	
		
start: 	lw $t0, A($t1) #load the value of A[$t1] into t0 
	add $t4, $t4, $t0 #add t0 to the current sum (t4) and update t4
	#test for max 
	ble $t0,$t2, ltst #if the array value is less or equal then its not max so jump to next compare
	#if gt, set and jump to end
	move $t2, $t0 #set the max(t2) to be the current value(t0)
	b end  #will not be both max and min, jump to end
	#test for lt,
ltst:	bge $t0, $t3, end #go to end if the array value is not the minimum 
	move $t3, $t0 #update the max
	
	
end :	addi $t1, $t1, 4 #increment the index variable in $t1
	bne $t5, $t1, start # if the index is equal to the length of the list
	
############   output phase
	la $a0, sumout #load the sum output string into memory ($a0)
	li $v0, 4 #load instruction to print string into v0
	syscall
	
	move $a0, $t4 #load the sum (t4) into a0 
	li $v0, 1 #syscall for print int
	syscall
	
	
	la $a0, maxout #load the max string into a0, so i could be printed
	li $v0, 4 # load syscall for print string
	syscall
	
	move $a0, $t2 #move the maximum val from the array into memory
	li $v0, 1 # load syscall for printing int
	syscall
	
	la $a0, minout #min output string into memory (a0)
	li $v0, 4 #load syscall for printing string intp v0
	syscall
	
	move $a0, $t3 #load minimum value from array into memory
	li $v0, 1 #load the syscall instruction for printing int
	syscall
	
	##END PHASE
	li $v0,10 #load instruction for exititng
	syscall #program end
	
	