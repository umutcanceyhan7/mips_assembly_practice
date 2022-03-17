.data
unorderedList: .word 13, 26, 44, 8, 16, 37, 23, 67, 90, 87, 29, 41, 14, 74, 39, -1

insertValues: .word 46, 85, 24, 25, 3, 33, 45, 52, 62, 17

space: .asciiz " "
newLine: .asciiz "\n"

#v1

####################################
#   4 Bytes - Value
#   4 Bytes - Address of Left Node
#   4 Bytes - Address of Right Node
#   4 Bytes - Address of Root Node
####################################

.text 
main:




la $a0, unorderedList

jal build

#li $a0, 8
#li $v0, 1
#syscall

#test return
li $v0, 10
syscall

# code moves from here
move $s3, $v0

move $a0, $s3
jal print

li $s0, 8
li $s2, 0
la $s1, insertValues
insertLoopMain: 
beq $s2, $s0, insertLoopMainDone

lw $a0, ($s1)
move $a1, $s3
jal insert

addi $s1, $s1, 4
addi $s2, $s2, 1 
b insertLoopMain
insertLoopMainDone:

move $a0, $s3
jal print


move $a0, $s3
jal remove


move $a0, $s3
jal print


li $v0, 10
syscall 


########################################################################
# Write your code after this line
########################################################################





####################################
#   4 Bytes - Value
#   4 Bytes - Address of Left Node
#   4 Bytes - Address of Right Node
#   4 Bytes - Address of Root Node
####################################
####################################
# Build Procedure
####################################
build:
    # $a0 has come with unordered list address. 
    # store a0 to stack to prevent changes on it.
    subu $sp, $sp, 4
    sw $a0, 0($sp) 

    ## new function will be called
    ## so $ra stored to stack
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    ## find biggest function called
    jal findBiggest

    testFindBiggestFunction: 
        ##################################
        # TEST PART FOR Find Biggest Function
        # Must print biggest value and first value in unordered list accordingly
        subu $sp, $sp, 8
        sw $v0, 0($sp)
        sw $a0, 4($sp)

        move $t7, $v0
        move $t6, $a0
        # Check for root node value (90)
        move $a0, $v0
        li $v0, 1
        syscall

        # Print new line
        li $v0, 4
        la $a0, newLine
        syscall

        # Print unordered list's first element (13)
        lw $a0, 0($t6)
        li $v0, 1
        syscall
        
        # Print new line
        li $v0, 4
        la $a0, newLine
        syscall

        lw $v0, 0($sp)
        lw $a0, 4($sp)
        addu $sp, $sp, 8
        #################################

    ## load $ra its former value to return main function
    lw $ra, 0($sp)
    addu $sp, $sp, 4

    # store $a0 (unordered list adress) to stack
    subu $sp, $sp, 4
    sw $a0, 0($sp)

    # store $v0 (biggest value in the list) to stack
    subu $sp, $sp, 4
    sw $v0, 0($sp)

    # allocate the 16 bytes memory address for root node
    li $v0, 9
    li $a0, 16
    syscall

    # store root node address to temporary register.
    move $t0, $v0

    # restore $v0 from stack
    lw $v0, 0($sp)
    addu $sp, $sp, 4

    
    # restore $a0 from stack
    lw $a0, 0($sp)
    addu $sp, $sp, 4

    # create root node of heap list
    sw $v0, 0($t0) # value -> 90
    sw $zero, 4($t0) # left child -> 0
    sw $zero, 8($t0) # right child -> 0 
    sw $zero, 12($t0) # parent address -> 0

    # assign the address of the root node to v0

    move $v0, $t0

    # $a0 parameter restored as it is given to the function 
    lw $a0, 0($sp)
    addu $sp, $sp, 4

    testRootNodeValues:
        ############################
        # It must print root nodes values 
        # Biggest value in unordered list, and zero for other 3 values 
        # because there is not any parent, left child or right child accordingly
        # It must print first value in unordered list
        subu $sp, $sp, 8
        sw $v0, 0($sp)
        sw $a0, 4($sp)

        move $t7, $v0
        move $t6, $a0
        # Check for root node value
        lw $a0, 0($t7)
        li $v0, 1
        syscall
        
        # Print space
        li $v0, 4
        la $a0, space
        syscall
        
        # Check for left child address value
        lw $a0, 4($t7)
        li $v0, 1
        syscall

        # Print space
        li $v0, 4
        la $a0, space
        syscall

        # Check for right child address value
        lw $a0, 8($t7)
        li $v0, 1
        syscall

        # Print space
        li $v0, 4
        la $a0, space
        syscall

        # Check for parent address value
        lw $a0, 12($t7)
        li $v0, 1
        syscall

        # Print new line
        li $v0, 4
        la $a0, newLine
        syscall

        lw $a0, 0($t6)
        li $v0, 1
        syscall

        lw $v0, 0($sp)
        lw $a0, 4($sp)
        addu $sp, $sp, 8
        #################################
        
    #################################
    # Root Node Created and its address stored in $v0
    # Unordered list is stored in $a0
    #################################

    # call insert function for each node



    

    jr $ra

####################################
# Insert Procedure
####################################
insert:



jr $ra

####################################
# Remove Procedure
####################################
remove:



jr $ra

####################################
# Print Procedure
####################################
print:



jr $ra

####################################
# Extra Procedures
####################################

findBiggest:

    # save $ra to stack
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    # assign unordered list address to $s5 register
    move $s5, $a0
    loop:
        # load current list element to $t0

        lw $t0, 0($s5)

        # list finished

        beq $t0, -1, returnBiggest

        # compare current biggest and current array value

        blt $s4, $t0, updateBiggest

        # pass next element in the array

        addu $s5, $s5, 4
        
        # j to loop
        j loop

    returnBiggest:
        # store biggestValue to $v0
        move $v0, $s4
        # returns to where findBiggest function is called 
        # by using ra value that stored in stack
        lw $ra 0($sp)
        addu $sp, $sp, 4

        jr $ra

    updateBiggest:
        lw $s4, ($s5)
    
        j loop


removeBiggestValueFromList:
    # unordered list $a0
    # biggest value $a1
    # returns updatedList (biggest value removed) $v0
    
    # unordered list in $t2
    move $t2, $a0
    # biggest value in $t3
    move $t3, $a1


    biggestValueFound:

    # biggest value found and changed with next value

    #remove process continues. 
        # if next value is -1, j removeCompleted
        beq $t1, -1, removeCompleted
        # else 
            #change value with next value in the list
            sw $t1, 0($t2)
            # pass the next value
            addu $t2, $t2, 4

            j biggestValueFound

    biggestValueNotFound: 
    # biggest value NOT FOUND search process continues. 
        addu $t2, $t2, 4

            j updateValues
    updateValues:
        # current value $t0
        lw $t0, 0($t2)
        # next value $t1
        lw $t1, 4($t2)

        # if current value is equal to biggest
        beq $t3, $t0, biggestValueFound
        
    
    removeCompleted:
        # change current value in the list with next value (-1)
        sw $t1, 0($t2)
        # next value is -1, change it with zero and jump returnBiggest
        sw $zero, 4($t2)

        jr $ra
