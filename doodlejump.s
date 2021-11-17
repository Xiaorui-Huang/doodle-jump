#####################################################################
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Game Controls
# J: doodler move left
# K: doodler move rigt
# S: retry after Game Over
#
#####################################################################

.data
	bufferAddress: .word 0x10009000
	displayAddress: .word 0x10008000
	doodlerLocation: .word 0x10007000 
	platform1: .word 0x10007100
	platform2: .word 0x10007200
	platform3: .word 0x10007300
	#Colours
	sky_blue: .word 0x87ceeb
	orange: .word 0xec8100
	dark_blue: .word 0x006bec
	black: .word 0x000000
	light_grey: .word 0xcd3d3d3
	skin: .word 0xffccbc
	hair: .word 0x795548
	grass: .word 0x78b451
	dirt: .word 0x846249
	bright_yellow: .word 0xffff55
	#Object parameters
	platformLength: .word 8
	jumpHeight: .word 21
	sleepTime: .word 25
	#Scores 
	scores: .word 0,0,0,0,0

.text 

#Functions
j main
random:
	#0 parameters
	#returns a random number between 0 and 20
	li $v0, 42	#generate random number	- range 0 <= [int] < [upper bound]
	li $a0, 0 	#RNG ID???
	lw $s0, platformLength
	addi $t7, $zero, 32	#calculating upper bound using platform Length
	sub $t7, $t7, $s0
	addi $t7, $t7, 1
	add $a1, $zero, $t7 	#upper bound 
	syscall		#random number in $a0
	#platform length test code
	#addi $a0,$zero,20 
	sll $v0, $a0,2 	#multiple 4 to get BYTES using shift
	jr $ra
	
paint_plat:
	#1 parameter - (Address platform, data colour)
	# no return values
	add $t3, $a0, $zero		#load addr of plat1
	add $t1, $a1, $zero		# get platform colour
	
	addi $t2,$zero,0	# for t2 = 0 to platLength
	plat_loop:
		sw $t1, 0($t3)		#paint the plat
		addi $t3, $t3, 4	# next address
		addi $t2,$t2,1		#counter t2 ++
		lw $t4, platformLength
		beq $t2, $t4,end_paint_plat	
		j plat_loop		#loop back
		
	end_paint_plat:
	jr $ra

	
#==========================NB==========================
#===================can be genralized==================	
collision_detection:
	# void function
	# 4 parameter (Address doodlerLocation, Address collider, int colliderLength, int jumpHeight)
	add $s2, $t2, $zero	#saving parameter 
	add $s0, $t0, $zero	
	add $s5, $t5, $zero
	add $s6, $t6, $zero
	
	add $t2, $a0, $zero	#"popping off the parameters"
	add $t3, $a1, $zero	#"popping off the parameters"
	
	addi $t4, $t3,-148	#collision area: one row above and 2 block left = -128-8
	addi $t6, $a2,-1	#calculating shift to one row above by colliderLength-1 blocks
	sll $t6, $t6, 2
	addi $t6, $t6, -128	# t6 contains the number of bytes to move
	add $t5, $t3,$t6	#collision area: one row above and doodlerWidth-1 to the right 
	
	#test colour
	#li $t7,0x00ff00
	#sw $t7,0($t4)
	#sw $t7,0($t5)
	
	#if(jump steps(t8)==0 && lower (t4)<= doodler (t2)<=upper(t5))
	bnez $t8, end_collide		#branch if doodler is not falling. i.e. t8 not equal 0	
	bgt $t4,$t2, end_collide	#branch to else if lower bound t4 > t2 DoodlerLocation
	bgt $t2,$t5, end_collide	#branch to else if lower 2 DoodlerLocation > t5 upper bound
	if_collide:
		add $t8, $zero, $a3	#doodler will jump 16 blocks
					#also doodler is not falling anymore
	end_collide:
		add $t2, $s2, $zero 		#restoring 
		add $t0, $s0, $zero 
		add $t5, $s5, $zero 
		add $t6, $s6, $zero 
		jr $ra
		
print_scores:
	#2 parameters (int numberToPRint, Addr LocationToPrint(Top Left))
	addi $sp, $sp, -4
	sw $ra, 0($sp)		#pushing the return addr on the stack
	add $s0, $t0, $zero	#saving
	add $s1, $t1, $zero
	add $s2, $t2, $zero   
	
	add $t0, $a0, $zero 	#The number to print
	add $t1, $a1, $zero 	#The Location to print
	lw $t2, bright_yellow		#loading the color
	
	beqz $t0, print0
	beq $t0,1, print1
	beq $t0,2, print2
	beq $t0,3, print3
	beq $t0,4, print4
	beq $t0,5, print5
	beq $t0,6, print6
	beq $t0,7, print7
	beq $t0,8, print8
	beq $t0,9, print9
	j printError
	print0:
	add $t2, $zero, $zero 	#black 0's
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	j return_print_scores
	print1:
	addi $t2, $zero, 0xff0000 	#OnePlus red theme 
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
	j return_print_scores
	print2:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	j return_print_scores
	print3:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	j return_print_scores
	print4:
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
	j return_print_scores
	print5:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	j return_print_scores
	print6:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	j return_print_scores
	print7:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
	j return_print_scores
	print8:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	j return_print_scores
	print9:
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 8($t1)
	j return_print_scores
	printError:
	addi $t2, $zero, 0xff0000 	#change to RED for ERROR
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
        addi $t1, $t1, 128
		sw $t2, 0($t1)
		sw $t2, 4($t1)
		sw $t2, 8($t1)
	
	
	return_print_scores:
	lw $ra, 0($sp)
	addi, $sp, $sp,4 	#popping the return addr off the stack
	
	add $t0, $s0, $zero	#restoring
	add $t1, $s1, $zero
	add $t2, $s2, $zero   
	jr $ra 
addScore:#(No parameters)
#==============TEST code for score===================
	addi $sp, $sp, -4
	sw $ra, 0($sp)		#pushing the return addr on the stack
	
	add $s0, $t0, $zero	#saving
	add $s1, $t1, $zero
	add $s2, $t2, $zero   

	lw $t0, scores		#score++
	addi, $t0, $t0, 1
	sw $t0, scores
	
	addi $a0, $zero, 0	#updates the Unit score
	jal addScoreHelper
	
	
	#======MYSTERY CODE======SOLVED
	#somehow the helper method was general to all numbers in the array???
	#What??? I'd take it but how?
	#the pointer to the array points to the next one if overflow id detected and this works under the assumption that no increments will be more than 10
	
	
	return_addScore:
	lw $ra, 0($sp)
	addi, $sp, $sp,4 	#popping the return addr off the stack
	
	add $t0, $s0, $zero	#restoring
	add $t1, $s1, $zero
	add $t2, $s2, $zero   
	jr $ra 
addScoreHelper:# 1 parameter(int offset_from_score)

	#while(score[i]>9){
	#	score[i]=score[i]-10
	#	score[i+1]++
	#}
	add $s0, $t0, $zero	#saving
	add $s1, $t1, $zero
	add $s2, $t2, $zero   
	
	la $t0,scores		#load address of scores
	
	sll $t1, $a0, 2		#getting the offset in bytes
	add $t0, $t0 ,$t1	#pointing to the number according to offset
	#if (score[i]>9)
	lw $t2,0($t0)		#t2 holds the value from addr t0
	
	while_need_increment:
	bgt $t2, 9, increment
	j return_addScoreHelper
		increment:
		addi $t2, $t2, -10
		sw $t2, 0($t0)
		addi $t0, $t0, 4 	#points to the next in the array
		lw $t2, 0($t0)		#loads the next value in the array
		addi $t2, $t2, 1	#increments ++
		sw $t2, 0($t0)
		j while_need_increment
		
	return_addScoreHelper:
	add $t0, $s0, $zero	#restoring
	add $t1, $s1, $zero
	add $t2, $s2, $zero      
	jr $ra
#===================================================
main:
	addi $t8, $zero, 0 	# t8 is the number of more jumps left. 0 means falling
	#lw $t0, bufferAddress 	# $t0 stores the base address for display
	#lw $t1, sky_blue	# $t1 stores the sky blue background colour code
	#lw $t2, orange		# $t2 stores the orange platform color code
	#lw $t3, dark_blue 	# $t3 stores the dark blue dooler color
	
	#sw $t1, 0($t0)		# paint the first (top-left) unit red.
	#sw $t2, 4($t0)		# paint the second unit on the first row green.
	#sw $t3, 128($t0)	# paint the first unit on the second row blue.
	
	#initializing
	lw $t0, bufferAddress 
	
	lw $t3, platform1 	
	addi $t3, $t0, 3968	#plat1 on row 31 relative to bufferAddress 31 x 32 x 4
	
	lw $t2, doodlerLocation
	addi $t2,$t0, 3840	#row of doodler relative to bufferAddress 30x 32 x 4
	
	jal random #calls function random
	
	
	# generate random number
	#li $v0, 42	#generate random number
	#li $a0, 0 	#RNG ID???
	#li $a1, 20 	#Maxium 
	#syscall		#random number in $a0
	#platform length test code
	#addi $a0,$zero,20 
	#sll $t4, $a0,2 	#multiple 4 to get BYTES using shift
	
	add $t3, $t3, $v0 	#add RNG number to plat location
	addi $t2, $t2, 4	#add blocks to centre the Doodler
	add $t2, $t2, $v0 	#add RNG number to Doodler
	sw $t2, doodlerLocation
	sw $t3, platform1
	
	lw $t3, platform2
	addi $t3, $t0, 2560	#plat 2 on row 20 relative to bufferAddress 20 x 32 x 4
	jal random
	add $t3, $t3, $v0 	#add RNG number to plat location
	sw $t3, platform2
	
	lw $t3, platform3
	addi $t3, $t0, 1152	#plat3 on row 9 relative to bufferAddress 9 x 32 x 4
	jal random
	add $t3, $t3, $v0 	#add RNG number to plat location
	sw $t3, platform3
	
	

paint:
	#SLEEP is very important
	li $v0, 32 		#sleep
	lw $a0, sleepTime		#for 50ms ~20fps?
	syscall
	

paint_background:
	lw $t0, bufferAddress 	# $t0 stores the base address for display
	lw $t1, sky_blue	#load sky_blur code
	addi $t3, $t0, 4096 	# 4*32*32 last puxel
	background_loop:
		sw $t1, 0($t0)		#paint the block sky blue
		addi $t0, $t0, 4	# counter ++
		beq $t0, $t3, paint_platforms	#jump out of the loop when all pixels are painted
	j background_loop
	
paint_platforms:
	lw $t1, grass
	lw $t7, dirt
	
	lw $t3, platform1
	add $a0, $t3, $zero	#Push the parameter onto function paint_plat
	add $a1, $t1, $zero	#Push the color on
	jal paint_plat
	lw $t3, platform1
	addi $a0, $t3, 128	#Push the parameter onto function paint_plat
	add $a1, $t7, $zero	#Push the color on
	jal paint_plat
	lw $t3, platform1
	addi $a0, $t3, 256	#Push the parameter onto function paint_plat
	add $a1, $t7, $zero	#Push the color on
	jal paint_plat
	

	lw $t1, grass
	lw $t7, dirt
	
	lw $t3, platform2	
	add $a0, $t3, $zero	#Push the parameter onto function paint_plat
	add $a1, $t1, $zero	#Push the color on
	jal paint_plat
	lw $t3, platform2
	addi $a0, $t3, 128	#Push the parameter onto function paint_plat
	add $a1, $t7, $zero	#Push the color on
	jal paint_plat
	lw $t3, platform2
	addi $a0, $t3, 256	#Push the parameter onto function paint_plat
	add $a1, $t7, $zero	#Push the color on
	jal paint_plat
	
	lw $t1, grass
	lw $t7, dirt
	
	lw $t3, platform3	
	add $a0, $t3, $zero	#Push the parameter onto function paint_plat
	add $a1, $t1, $zero	#Push the color on
	jal paint_plat
	lw $t3, platform3
	addi $a0, $t3, 128	#Push the parameter onto function paint_plat
	add $a1, $t7, $zero	#Push the color on
	jal paint_plat
	lw $t3, platform3
	addi $a0, $t3, 256	#Push the parameter onto function paint_plat
	add $a1, $t7, $zero	#Push the color on
	jal paint_plat
	
	#lw $t3, platform1	#load addr of plat1
	#lw $t1, orange		# get platform orange colour
	#addi $t2,$zero,0	# for t2 = 0 to 11 (12 blocks)
	#plat_loop:
	#	sw $t1, 0($t3)		#paint the plat
	#	addi $t3, $t3, 4	# next address
	#	addi $t2,$t2,1		#counter t2 ++
	#	beq $t2, 12, paint_doodler 	#exit loop when t2==8 blocks are drawn
	#	j plat_loop		#loop back	
paint_doodler:
	lw $t2, doodlerLocation	#load dooler location into t4
	lw $t1, skin
	sw $t1, 0($t2)
	sw $t1, 20($t2)
	addi $t2, $t2, -128
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 12($t2)
	sw $t1, 20($t2)
	addi $t2, $t2, -128
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 12($t2)
	sw $t1, 16($t2)
	sw $t1, 20($t2)
	addi $t2, $t2, -128
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 12($t2)
	sw $t1, 20($t2)
	addi $t2, $t2, -128
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 12($t2)
	sw $t1, 16($t2)
	addi $t2, $t2, -128
	lw $t1, hair
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 12($t2)
	sw $t1, 16($t2)
	sw $t1, 20($t2)
	addi $t2, $t2, 128
	sw $t1, 0($t2)
	sw $t1, 20($t2)
	addi $t2, $t2, 128
	lw $t1, black
	sw $t1, 4($t2)
	sw $t1, 16($t2)
	addi $t2, $t2, 256
	sw $t1, 4($t2)
	sw $t1, 16($t2)
	addi $t2, $t2, 128
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 12($t2)
	sw $t1, 16($t2)
	
	
	#lw $t1, dark_blue 	#load doodler color
	#sw $t1, 0($t2)		# paint dooler left leg	
	#sw $t1, 8($t2)		# paint dooder right leg
	#addi $t2, $t2, -124	# point to dooler body
	#sw $t1, -4($t2)		# paint doodler body
	#sw $t1, 0($t2)		
	#sw $t1, 4($t2)
	#addi $t2, $t2, -128   	# point to doodler head
	#sw $t1, 0($t2)
	
	
	#test code for plat cap
	#lw $t0, bufferAddress
	#addi $t3, $t0, 1276
	#li $t6,0x00ff00
	#sw $t6,0($t3)
	#test code end
paint_scores:
	#================test code for score=====================
	add $s0, $t0, $zero	#saving
	add $s1, $t1, $zero
	add $s2, $t2, $zero
	add $s3, $t3, $zero
	add $s4, $t4, $zero
	add $s5, $t5, $zero
	add $s6, $t6, $zero
	
	addi $t6,$zero, 3440
	
	la $t0, scores	#get the address
	lw $t1, 0($t0)	#int numberToPRint
	addi $t0, $t0, 4	#next int in array
	lw $t2, 0($t0)	#int numberToPRint
	addi $t0, $t0, 4	#next int in array
	lw $t3, 0($t0)	#int numberToPRint
	addi $t0, $t0, 4	#next int in array
	lw $t4, 0($t0)	#int numberToPRint
	addi $t0, $t0, 4	#next int in array
	lw $t5, 0($t0)	#int numberToPRint
	
	add $a0, $t1, $zero	#int numberToPRint
	lw $a1, bufferAddress
	add $a1, $a1, $t6	#Addr LocationToPrint(Top Left) - row 27 4th block from the right
	jal print_scores
	
	bnez $t2, paint_tens	#skip if it's a leading 0
	bnez $t3, paint_tens	#skip if it's a leading 0
	bnez $t4, paint_tens	#skip if it's a leading 0
	bnez $t5, paint_tens	#skip if it's a leading 0
	j paint_display
	paint_tens:
	add $a0, $t2, $zero	#int numberToPRint
	lw $a1, bufferAddress
	addi $t6, $t6, -16
	add $a1, $a1, $t6	#Addr LocationToPrint(Top Left) 4 blocks to the left from the previous number
	jal print_scores
	
	bnez $t3, paint_hundreds	#skip if it's a leading 0
	bnez $t4, paint_hundreds	#skip if it's a leading 0
	bnez $t5, paint_hundreds	#skip if it's a leading 0
	j paint_display
	paint_hundreds:
	add $a0, $t3, $zero	#int numberToPRint
	lw $a1, bufferAddress
	addi $t6, $t6, -16
	add $a1, $a1, $t6	#Addr LocationToPrint(Top Left) 4 blocks to the left from the previous number
	jal print_scores
	

	bnez $t4, paint_thousands	#skip if it's a leading 0
	bnez $t5, paint_thousands	#skip if it's a leading 0
	j paint_display
	paint_thousands:
	add $a0, $t4, $zero	#int numberToPRint
	lw $a1, bufferAddress
	addi $t6, $t6, -16
	add $a1, $a1, $t6	#Addr LocationToPrint(Top Left) 4 blocks to the left from the previous number
	jal print_scores
	
	
	beqz $t5, paint_display	#skip if it's a leading 0
	add $a0, $t5, $zero	#int numberToPRint
	lw $a1, bufferAddress
	addi $t6, $t6, -16
	add $a1, $a1, $t6	#Addr LocationToPrint(Top Left) 4 blocks to the left from the previous number
	jal print_scores
	
	add $t0, $s0, $zero	#restoring
	add $t1, $s1, $zero
	add $t2, $s2, $zero
	add $t3, $s3, $zero
	add $t4, $s4, $zero
	add $t5, $s5, $zero
	add $t6, $s6, $zero
	#=====================================================

paint_display: #paint display from buffer
	lw $t0, displayAddress 	# $t0 stores the base address for display
	lw $t1, bufferAddress	# $t1 is the buffer
	addi $t3, $t0, 4096
	display_loop:
		lw $t4, 0($t1)		#getting the color value from buffer
		sw $t4, 0($t0)		#paint the block with buffer color
		addi $t0, $t0, 4	# next location in display
		addi $t1, $t1, 4	# next location in buffer
		beq $t0, $t3, check_key	#jump out of the loop when all pixels are painted
	j display_loop
	
check_key:
	lw $t9, 0xffff0000		# load keypress or not
	beq $t9, 1 , keyboard_input	#jumo to keyboard_input if there is a key stroke
	j calculate			
keyboard_input:
	lw $t9, 0xffff0004		#load they key value
	
	beq $t9, 0x4a, respond_to_j 	#respond to upper case J
	beq $t9, 0x6a, respond_to_j	#respond to lower case j
	beq $t9, 0x4b, respond_to_k 	#respond to upper case K
	beq $t9, 0x6b, respond_to_k	#respond to lower case k
	j calculate
respond_to_j:
	lw $t2, doodlerLocation
	addi $t2, $t2, -4		#doodler go left
	sw $t2, doodlerLocation
	j calculate
respond_to_k:
	lw $t2, doodlerLocation
	addi $t2, $t2, 4		#doodler go right
	sw $t2, doodlerLocation
	j calculate
respond_to_s:
	j main  	#yep resurrection is that easy
death: 			# awaiting of trail SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

	# painting GAME OVER
	lw $t0, displayAddress
	lw $t1, light_grey		#get colour
	addi $t0, $t0, 916	#row 8 column 7 - 7*128+5*4
	
	#print grey shade
	#row one
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 2
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	
	sw $t1, 20($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	#row 3
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 48($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 4
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	
	#row 5
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#Print OVER
	#row 1
	addi $t0, $t0, 256
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 36($t0)
	
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 2
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 36($t0)
	
	sw $t1, 44($t0)
	
	sw $t1, 64($t0)
	sw $t1, 76($t0)
	
	#row 3
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 24($t0)
	sw $t1, 32($t0)
	
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 4
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 24($t0)
	sw $t1, 32($t0)
	
	sw $t1, 44($t0)
	
	sw $t1, 64($t0)
	sw $t1, 72($t0)
	
	#row 5
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 28($t0)
	
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 76($t0)
	
	#print Balck Titile GAME
	lw $t0, displayAddress
	addi $t0, $t0, 1048	#row 8 column 7 - 8*128+6*4
	lw, $t1, black
	
	#row one
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 2
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	
	sw $t1, 20($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	#row 3
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 48($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 4
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	
	#row 5
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 32($t0)
	
	sw $t1, 40($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#Print OVER
	#row 1
	addi $t0, $t0, 256
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 36($t0)
	
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 2
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 20($t0)
	sw $t1, 36($t0)
	
	sw $t1, 44($t0)
	
	sw $t1, 64($t0)
	sw $t1, 76($t0)
	
	#row 3
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 24($t0)
	sw $t1, 32($t0)
	
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	
	#row 4
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 12($t0)
	
	sw $t1, 24($t0)
	sw $t1, 32($t0)
	
	sw $t1, 44($t0)
	
	sw $t1, 64($t0)
	sw $t1, 72($t0)
	
	#row 5
	addi $t0, $t0, 128
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	sw $t1, 28($t0)
	
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	
	sw $t1, 64($t0)
	sw $t1, 76($t0)
	
	
	#Clearing the score data
	la $t0, scores
	sw $zero, 0($t0)	#unit cleared
	addi $t0, $t0, 4
	sw $zero, 0($t0)	#tens cleared
	addi $t0, $t0, 4
	sw $zero, 0($t0)	#hundred cleared
	addi $t0, $t0, 4
	sw $zero, 0($t0)	#thousands cleared
	addi $t0, $t0, 4
	sw $zero, 0($t0)	#ten thousands cleared
	
	check_s:
	lw $t9, 0xffff0000		# load keypress or not
	beq $t9, 1 , resurrect		#jump to keyboard_input if there is a key stroke
	j still_dead
	resurrect:
		lw $t9, 0xffff0004		#load they key value
		beq $t9, 0x53, respond_to_s 	#respond to upper case S
		beq $t9, 0x73, respond_to_s	#respond to lower case s
		j calculate
	still_dead:
	#SLEEP is very important
	#li $v0, 32 		#sleep
	#li $a0, 50	
	#syscall
	
	j check_s		

calculate:
	#test for collision after j,k move on all 3 platform
	# 4 parameter (Address doodlerLocation, Address collider, int colliderWidth, int jumpHeight)
	lw $t2, doodlerLocation 	# do not need to load again for collision detection, since function do not alter t2
	lw $t0, bufferAddress		
	addi, $t4, $t0, 0xfff		# move pointer t3 to the last pixel
	
	#===============Game Over=================
	bgt $t2, $t4, death		# if plat is below last pixel - restart/terminate game
	
	
	lw $t3, platform1
	
	lw $t5, platformLength  #carefull using global variables
	lw $t6, jumpHeight
	
	add $a0, $t2, $zero	#preping parameter 1
	add $a1, $t3, $zero	#preping parameter 2
	add $a2, $zero,$t5 	#preping parameter 3
	add $a3, $zero, $t6	#preping parameter 4
	jal collision_detection
	
	lw $t3, platform2
	add $a0, $t2, $zero	#preping parameter 1
	add $a1, $t3, $zero	#preping parameter 2
	add $a2, $zero,$t5 	#preping parameter 3
	add $a3, $zero, $t6	#preping parameter 4
	jal collision_detection
	
	lw $t4, platformLength
	lw $t3, platform3
	add $a0, $t2, $zero	#preping parameter 1
	add $a1, $t3, $zero	#preping parameter 2
	add $a2, $zero,$t5 	#preping parameter 3
	add $a3, $zero, $t6	#preping parameter 4
	jal collision_detection
	
	
	beqz $t8, fall 		# Movig platform only if doodler is jumping i.e. t8>0
	lw $t0, bufferAddress
	addi $t6, $t0, 1276	# last block on th e 9th row - (10 x 128 - 4)
	bgt $t2,$t6, jump	# branch to jump (else) if DoodlerLocation t2 > t6 jumpCapStart i.e. Doodler is above the cap
	if_movePlat:
		#doodler location don't change
		#jump step t8 --
		#move all platform down by one
		#respawn new plats if hit bottom boundary
	
		lw $t3, platform1	# Moving plat1
		addi $t3, $t3, 128
		sw $t3, platform1
		lw $t3, platform2	# Moving plat2
		addi $t3, $t3, 128
		sw $t3, platform2
		lw $t3, platform3	# Moving plat3
		addi $t3, $t3, 128
		sw $t3, platform3
		
		addi $t8 $t8, -1	# Number of more jumps t8--
		
		
		#add to score
		jal addScore
		
		spawnPlat:
		lw $t0, bufferAddress		
		addi, $t4, $t0, 0xfff		#move pointer t3 to the last pixel
		lw $t3, platform1		#load plat1
		
		#if plat is below last pixel - need new plat NO ELSE
		bgt $t3, $t4, newPlat1		
		j continuePlat2		
		newPlat1:			
			addi $t3, $t0, -128	#plat 2 on row 20 relative to bufferAddress 20 x 32 x 4
			jal random
			add $t3, $t3, $v0 	#add RNG number to plat location
			sw $t3, platform1
		continuePlat2:			#check platform 2
		lw $t3, platform2		#load plat2
		bgt $t3, $t4, newPlat2		#if plat is below last pixel - need new plat
		j continuePlat3	
		newPlat2:			
			addi $t3, $t0, -128	#plat 2 on row 20 relative to bufferAddress 20 x 32 x 4
			jal random
			add $t3, $t3, $v0 	#add RNG number to plat location
			sw $t3, platform2
		continuePlat3:
		lw $t3, platform3		#load plat3
		bgt $t3, $t4, newPlat3		#if plat is below last pixel - need new plat
		j endCal
		newPlat3: 
			addi $t3, $t0, -128	#plat 2 on row 20 relative to bufferAddress 20 x 32 x 4
			jal random
			add $t3, $t3, $v0 	#add RNG number to plat location
			sw $t3, platform3
		j endCal
	jump:
		#if(jump step t8 > 0)
		beqz $t8,fall		
		addi $t2, $t2, -128	#doodler jump by 1 row
		addi $t8 $t8, -1	# Number of more jumps t8--
		j endCal
	fall:				#when jump step t8==0
		addi $t2, $t2, 128	#doodler fall by 1 row
	endCal:
		sw $t2, doodlerLocation	#update doodler location
		j paint
	#respawning platforms 
	# Capping doodler
	# moving plat when doodler hit cap
	#
Exit:
	li $v0, 10 		# terminate the program gracefully 
	syscall
