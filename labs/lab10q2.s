#lab 10 
#cmpt 229
#christian Ellinger

#Question 2: write a simple exception handler, it can only recieve traps in the first version
#when a trap occurs the exception handler prints out the trap number and also prints
#the hex address at which the trap occured 
.kdata 
	outStr1: .asciiz "Trap_ occured at"
	newline: .asciiz "\n"
	k0: .word 0 
	a0: .word 0
	v0: .word 0
#Note: use the mips syscall to output a number
.ktext 0x80000180
	#save values needee
	move $k0, $at #move k0 to at
	sw $k0, k0	#save k0
	sw $v0, v0	#save v0
	sw $a0, a0 	#save a0
	#save values needed
	
	
	#what tap caused me to get here
	mfc0 $k0, $13	#move the cause register contents into k0
	srl $k0, $k0, 2 #move exception code over t position 4 - 0 
	andi $k0, $k0 31 #isolate exception code
	
		
	li $t0, 0 	#get null term
	
	#I would have gotten the trap number
	
	la $a0, outStr1	#load the output string into memory
	li $v0, 4	#print word 
	syscall	
	
	###Need to split the string and get the trap number into the output
	
	
	mfc0 $a0, $14	#move the address form the address loaction
	li $v0, 34 	#load syscall for printing
	syscall
	
	la $a0, newline	#load the output string into memory
	li $v0, 4	#print word 
	syscall
	
	#setup return address
return:	mfc0 $k0, $14 #k0 is th address of the victim
	addi $k0, $k0, 4 #move past victim to next instruction
	mtc0 $k0, $14  #save new address
	
	#restore registers
	lw $a0, a0 #restore a0
	lw $v0, v0 #restore v0
	lw $k0, k0 #restore k0 
	move $at, $k0
	
	eret


