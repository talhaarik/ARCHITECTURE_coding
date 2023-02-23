##############################################################
#Dynamic array
##############################################################
#   4 Bytes - Capacity
#	4 Bytes - Size
#   4 Bytes - Address of the Elements
#############################################################

##############################################################
#Song
##############################################################
#   4 Bytes - Address of the Name (name itself is 64 bytes)
#   4 Bytes - Duration
##############################################################


.data
space: .asciiz " "
newLine: .asciiz "\n"
tab: .asciiz "\t"
menu: .asciiz "\n● To add a song to the list-> \t\t enter 1\n● To delete a song from the list-> \t enter 2\n● To list all the songs-> \t\t enter 3\n● To exit-> \t\t\t enter 4\n"
menuWarn: .asciiz "Please enter a valid input!\n"
name: .asciiz "Enter the name of the song: "
duration: .asciiz "Enter the duration: "
name2: .asciiz "Song name: "
duration2: .asciiz "Song duration: "
emptyList: .asciiz "List is empty!\n"
noSong: .asciiz "\nSong not found!\n"
songAdded: .asciiz "\nSong added.\n"
songDeleted: .asciiz "\nSong deleted.\n"

copmStr: .space 64

sReg: .word 3, 7, 1, 2, 9, 4, 6, 5
songListAddress: .word 0 #the address of the song list stored here!

.text 
main:

	jal initDynamicArray
	sw $v0, songListAddress
	
	la $t0, sReg
	lw $s0, 0($t0)
	lw $s1, 4($t0)
	lw $s2, 8($t0)
	lw $s3, 12($t0)
	lw $s4, 16($t0)
	lw $s5, 20($t0)
	lw $s6, 24($t0)
	lw $s7, 28($t0)

menuStart:
	la $a0, menu    
    li $v0, 4
    syscall

	li $v0,  5
    syscall
	li $t0, 1
	beq $v0, $t0, addSong
	li $t0, 2
	beq $v0, $t0, deleteSong
	li $t0, 3
	beq $v0, $t0, listSongs
	li $t0, 4
	beq $v0, $t0, terminate
	
	la $a0, menuWarn    
    li $v0, 4
    syscall
	b menuStart
	
addSong:
	jal createSong 
	lw $a0, songListAddress
	move $a1, $v0
	jal putElement
	b menuStart
	
deleteSong:
	lw $a0, songListAddress
	jal findSong
	lw $a0, songListAddress
	move $a1, $v0
	jal removeElement
	b menuStart
	
listSongs:
	lw $a0, songListAddress
	jal listElements
	b menuStart
	
terminate:
	la $a0, newLine		
	li $v0, 4
	syscall
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	move $a0, $s1
	syscall
	move $a0, $s2
	syscall
	move $a0, $s3
	syscall
	move $a0, $s4
	syscall
	move $a0, $s5
	syscall
	move $a0, $s6
	syscall
	move $a0, $s7
	syscall
	
	li $v0, 10
	syscall


initDynamicArray:
	li $a0, 12  #12 bytes for the dynamic array
	li $v0, 9  #sbrk
	syscall  #allocate memory for the dynamic array

	move $t1, $v0  #t1 is the address of the dynamic array

	li $a0, 2  #2 bytes for the capacity
	li $v0, 9  #sbrk
	syscall  #allocate memory for the size

	move $t2, $v0  #t2 is the address of the elements
	li $t3, 2  #capacity of dynamic_array
	li $t4, 0  #size of dynamic_array

	sw $t3, 0($t1)  #store capacity
	sw $t4, 4($t1)  #store size
	sw $t2, 8($t1)  #store address of the elements

	move $v0,$t1 
	jr$ra 


createSong:
	li $a0, 64  #64 bytes for the name of the song
	li $v0, 9  #sbrk
	syscall  #allocate memory for the name of the song

	move $t1, $v0  #t1 is the address of the name of the song

	li $a0, 8 #8 bytes for the song
	li $v0, 9  #sbrk
	syscall  #allocate memory for the duration of the song

	move $t2, $v0  #t2 is the address of the song
	
	la $a0, name  #get the name of the song
	li $v0, 4  #print the name of the song
	syscall  

	li $v0, 8  #read the name of the song
	syscall
	sw $v0, 0($t1)  #store the name of the song

	la $a0, duration  #get the duration of the song
	li $v0, 4  #print the duration of the song
	syscall

	li $v0, 5  #read the duration of the song
	syscall
	sw $v0, 0($t2)  #store the duration of the song

	sw $t1, 4($t2)  #store the address of the name of the song

	move $v0, $t2  #return the address of the song
	jr$ra


putElement:
	move $t1, $a0  #t1 is the address of the dynamic array
	move $t2, $a1  #t2 is the address of the song

	lw $t3, 4($t1)  #t3 is the size of the dynamic array
	lw $t4, 0($t1)  #t4 is the capacity of the dynamic array

	bge $t3, $t4, expandArray #if size >= capacity, expand the array

	expandArray:
	sll $t4, $t4, 1  #t4 is the capacity of the dynamic array * 2
	sw $t4, 0($t1)  #store the new capacity
	li $a0, $t4  #a0 is the capacity of the dynamic array * 2
	li $v0, 9  #sbrk
	syscall  #allocate memory for the new elements

	lw $t5, 8($t1)  #t5 is the address of the elements
	add $t6, $t5, $t3  #t6 is the address of the next element
	sw $t2, 0($t6)  #store the song in the next element

	addi $t3, $t3, 1  #increase the size by 1
	sw $t3, 4($t1)  #store the new size

	jr$ra



removeElement:
	move $t1, $a0  #t1 is the address of the dynamic array
	move $t2, $a1  #t2 is the index of the song to be removed

	lw $t3, 4($t1)  #t3 is the size of the dynamic array
	lw $t4, 0($t1)  #t4 is the capacity of the dynamic array

	lw $t5, 8($t1)  #t5 is the address of the elements
	add $t6, $t5, $t2  #t6 is the address of the element to be removed
	lw $t7, 0($t6)  #t7 is the address of the song to be removed

	subi $t9, $t3, 1  #t9 is the size - 1
	sw $t9, 4($t1)  #store the new size


	li $t8, 8  #t8 is 8
	mul $t8, $t8, $t2  #t8 is 8 * index
	add $t8, $t5, $t8  #t8 is the address of the element to be removed
	add $t9, $t8, $t8  #t9 is the address of the next element
	sw $t9, 0($t8)  #store the address of the next element in the previous element

	jr$ra


findSong:
	move $t1, $a0  #t1 is the address of the dynamic array
	move $t2, $a1  #t2 is the address of the song to be found

	lw $t3, 4($t1)  #t3 is the size of the dynamic array
	lw $t4, 0($t1)  #t4 is the capacity of the dynamic array

	lw $t5, 8($t1)  #t5 is the address of the elements

	li $t6, 0  #t6 is 0
	li $t7, 1  #t7 is 1
	li $t8, 0  #t8 is 0

    loop:
	beq $t6, $t3, endLoop  #if t6 == t3, end the loop
	lw $t9, 0($t5)  #t9 is the address of the song
	beq $t9, $t2, found  #if t9 == t2, the song was found
	add $t5, $t5, $t7  #t5 is the address of the next element
	add $t6, $t6, $t7  #t6 is the index of the next element
	j loop

	found:
	move $t8, $t6  #t8 is the index of the song

	endLoop:
	move $v0, $t8  #return the index of the song
	jr$ra


compareString:
	move $t1, $a0  #t1 is the address of the first string
	move $t2, $a1  #t2 is the address of the second string

	li $t3, 0  #t3 is the index of the first string
	li $t4, 0  #t4 is the index of the second string

	li $t5, 0  #t5 is the result of the comparison

	compareStringLoop:
	lb $t6, 0($t1)  #t6 is the character of the first string
	lb $t7, 0($t2)  #t7 is the character of the second string

	beq $t6, $t7, compareStringLoopEnd  #if the characters are equal, then continue the loop

	bne $t6, $t7, compareStringLoopEnd  #if the characters are not equal, then end the loop

	addi $t3, $t3, 1  #increase the index of the first string by 1
	addi $t4, $t4, 1  #increase the index of the second string by 1
	addi $t1, $t1, 1  #increase the address of the first string by 1
	addi $t2, $t2, 1  #increase the address of the second string by 1
	j compareStringLoop

	compareStringLoopEnd:
	beq $t6, $t7, compareStringLoopEndEqual  #if the characters are equal, then the strings are equal

	bne $t6, $t7, compareStringLoopEndNotEqual  #if the characters are not equal, then the strings are not equal

	compareStringLoopEndEqual:
	li $t5, 1  #the strings are equal
	j compareStringLoopEndFinal

	compareStringLoopEndNotEqual:
	li $t5, 0  #the strings are not equal
	j compareStringLoopEndFinal

	compareStringLoopEndFinal:
	move $v0, $t5  #return the result of the comparison
	jr$ra


listElements:
	move $t1, $a0  #t1 is the address of the dynamic array

	lw $t2, 4($t1)  #t2 is the size of the dynamic array
	lw $t3, 0($t1)  #t3 is the capacity of the dynamic array

	lw $t4, 8($t1)  #t4 is the address of the elements

	li $t5, 0  #t5 is 0

	loop:
	beq $t5, $t2, endLoop  #if t5 == t2, end the loop
	lw $t7, 0($t4)  #t7 is the address of the song
	jal printSong  #print the song
	addi $t4, $t4, 4  #t4 is the address of the next element
	addi $t5, $t5, 1  #t5 is the index of the next element
	j loop

	endLoop:
	jr$ra


printSong:
	move $t1, $a0  #t1 is the address of the song
	jr $ra	


printElement:
	move $t1, $a0  #t1 is the address of the dynamic array
	move $t2, $a1  #t2 is the index of the song to be printed

	lw $t3, 4($t1)  #t3 is the size of the dynamic array
	lw $t4, 0($t1)  #t4 is the capacity of the dynamic array

	lw $t5, 8($t1)  #t5 is the address of the elements
	add $t6, $t5, $t2  #t6 is the address of the element to be printed
	lw $t7, 0($t6)  #t7 is the address of the song to be printed
	
	jr $ra