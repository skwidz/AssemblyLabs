#cmpt 229 
#program for lab 4
#written by: christian Ellinger

############QUESTION 1 ################

# a)
#	li $t1,  4294967287  # set t1 to be the decimal representation
		    #of the fourth bit being zero and the other bits being 1, in a bitwise AND
#	and $t0, $s0, $t1   #do the bitwise AND operation to clear only the 4th bit
#	move $t0, $s0	   #move $t0 into $s0, since s0 will not change after the operation unless it is manualy changed
##	the hex value for the and would be FFFFFFF7


# b)
#	li $t1, 64 #set t1 to be the decimal version of 1000000
#	or $t2, $v0, $t1 #do a bitwise or to set the 7th bit
#	move $v0, $t2 # move the result of the bitwise or(now in t2) into $v0		

#	the hex value would be 40

#c)
#	the code would be:
#	and $t0, $v0, 0x0000004c

#d) 	the code would be
#	or $t0, v0, 0x00000380
#	and $t0, $t0, FFFFE3FF
#	the result will be in $t0
#
#purpose: outputs the octal representation of an integer input

# Write an efficient assembly language program
# that outputs the octal format
#representation of an unsigned integer number
# stored in register $s0. You are to input an
#integer value into $s0 (after user input) and
# then output the equivalent in octal. Assume the
#2 most significant bits are zero so that the
# number can be represented with 10 octal digits. If
#for example $s0 contains the value 12210 then 
#its octal value is 1728. For this example, the
#console output should be 0000000172. 
#The leading 0’s should be displayed. Note: Efficient
#means that you are not to use division or
# multiplication in this program; use shift and/or
#rotate operations. 

#thoughts:
#use a bitwise AND on bits, three at a time, print the result, and shift the mask over 3 bits
#start at left side, first two bits zero, print result, then shift mask right three bits. 
#limit to 10 shifts - compare mask to zero. 
#starting value of the mask will be 7*2^27 or 939524096
#shift right every iteration

##NOTE: I wrote this strategically as an attempt to compete with Alan for instruction
# count, as a result, prompts and output are not included to reduce instructions as much as possible


##Variable usage
# $s0: the users input, a decimal intiger
# $t0: the comparison mask used for the Bitwise AND
# $t1: counter for shift offset of result from bitwise AND
# $t2: output of bitwise AND between $v0 and $t0 

##SETUP PHASE %####
#get the user input
	
	li $v0, 5 #load instruction to read user input
	syscall
	move $s0, $v0 #move v0 (the users input) into s0
	#NOTE: Because the value is in s0, it wont change
	
#setup the mask and shift counter
	li $t0, 939524096 ## this is the inital mask value needed for the bitwise AND = (111) 7 * 2^27
	li $t1, 27 ## initalize the shift amount offset for shifting t2 
	
#load the print instruction before the loop 
	li $v0, 1 #load instruction to print the int in a0 

#loop section
	
loop:	and $t2, $s0, $t0 #bitwise and between the mask(t0) and the user's input(s0), put result in t2
	srlv $a0, $t2, $t1  #shift t2 right by an the offset defined by t1, put in a0 to ready it for printing
	syscall #print the value of a0
	addi $t1, $t1, -3 #decrement the shft offset(t1) by three to account for the mask shift 
	srl $t0, $t0, 3 #shift t0 right by three bits to prep for the next bitwise AND
	bgtz $t0, loop #if the mask (t0) > 0 the function isnt done, jump back to loop, else continue
	
#finish phase
	li $v0, 10 #load the syscall for exitiing the program
	syscall	
	
	
