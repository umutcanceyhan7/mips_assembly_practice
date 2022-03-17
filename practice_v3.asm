.data
unorderedList: .word 13, 26, 44, 8, 16, 37, 23, 67, 90, 87, 29, 41, 14, 74, 39, -1

insertValues: .word 46, 85, 24, 25, 3, 33, 45, 52, 62, 17

space: .asciiz " "
newLine: .asciiz "\n"


# Umutcan CEYHAN 260201003 
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

# $v0 is the RootNodeAddress 

# code moves from here
# $s3 is the RootNodeAddress
move $s3, $v0

move $a0, $s3
# $a0 -> RootNodeAddress
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
    # store a0 (unordered list address) to stack to prevent changes on it.
    subu $sp, $sp, 4
    sw $a0, 0($sp) 

    ## new function will be called
    ## so $ra stored to stack
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    ## find biggest function called
    # Parameters $a0 -> list
    jal findBiggest

    ## returned value stored in $s0 because insert function need this template
    move $s0, $v0
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

    # $a0 (unordered list) parameter restored as it is given to the function 
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

        # Print new line
        li $v0, 4
        la $a0, newLine
        syscall

        lw $v0, 0($sp)
        lw $a0, 4($sp)
        addu $sp, $sp, 8
        #################################

    #################################
    # Root Node Created and its address stored in $v0
    # Unordered list is stored in $a0
    #################################
    # Before the loop move $a0 to $s1 because it is empty at first
    move $s1, $a0

    ### STORE THE INITIAL parameter a0 (unordered list) and $v0 rootNodeAddres in stack.
    subu $sp $sp, 8
    sw $a0, 0($sp)
    sw $v0, 4($sp)

    # Loop to insert nodes binary heap tree
    insertEachNodeLoop:  
        ### Updated Biggest value address that needs removed from list stored in $s0
        ### Updated Unordered List address stored in $s1  
        
        ## Check list is finished or not
        # $t0 -> First item in the list 
        lw $t0, 0($s1)
        # if it is -1 then finish loop
        beq $t0, -1, insertEachNodeLoopEnd
        #######################################################
        ########## RBVFromList FUNCTION STARTED ###############
        
      
        # removeBiggestValueFromList function call will be made so store $ra in stack
        subu $sp, $sp, 4
        sw $ra, 0($sp)

        # removeBiggestValueFromList function parameters are prepared
        # updatedList moved to $a0 as parameter
        move $a0, $s1
        # biggestValue moved to $a1 as parameter
        move $a1, $s0

        # $a0, $a1 and $v0 stored in stack before function call
        subu $sp, $sp, 12
        sw $v0, 0($sp)
        sw $a0, 4($sp)
        sw $a1, 8($sp)

        # $a0 -> list, $a1 -> biggestValue
        # removeBiggestValueFromList function will be called
        
        jal removeBiggestValueFromList

        # updated list stored in $s1 
        move $s1, $v0

        testRemoveBiggestValueFromListFunction:
            # LOCAL TEST IT MUST PRINT FIRST 4 elements of the list 
            subu $sp, $sp, 12
            sw $v0, 0($sp)
            sw $a0, 4($sp)
            sw $s1, 8($sp)

            move $t7, $s1
            loop2:
                # Check for root node value
                lw $t1 0($t7)
                beq $t1, -1, end
                
                lw $a0, 0($t7)
        
                li $v0, 1
                syscall
                        
                # Print space
                li $v0, 4
                la $a0, space
                syscall
                
                addu $t7, $t7, 4
                j loop2
            end:

                # Print space
                li $v0, 4
                la $a0, newLine
                syscall

                #restore values
                lw $v0, 0($sp)
                lw $a0, 4($sp)
                lw $s1, 8($sp)
                addu $sp, $sp, 12
                #################################
            ########### TEST DONE #############
        # load back to v0 root node address from stack
        lw $v0, 0($sp)
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addu $sp, $sp, 12

        # removeBiggestValueFromList function completed $ra value is restored
        lw $ra, 0($sp)
        addu $sp, $sp, 4

        ################# RBVFromList FUNCTION DONE ###########
        #######################################################
        ########## FINDBIGGEST FUNCTION STARTED ###############

        # findBiggest function will be called so store $ra in stack
        subu $sp, $sp, 4
        sw $ra, 0($sp)

        # store $a0 stack
        subu $sp, $sp, 4
        sw $a0, 0($sp)

        # store $v0 (root node address) in stack
        subu $sp, $sp, 4
        sw $v0, 0($sp)
        
        # assign updated list to $a0 as parameter
        move $a0, $s1

        jal findBiggest
        
        # store biggest value in $s0 
        move $s0, $v0

        testFindBiggestFunction2:

            move $a0, $s0
            li $v0, 1
            syscall

            la $a0, newLine
            li $v0, 4
            syscall
            ##### TEST DONE

        # restore $v0 with initial value (root Node Address)
        lw $v0, 0($sp)
        addu $sp, $sp, 4

        # restore $a0 as unordered list address
        lw $a0, 0($sp)
        addu $sp, $sp, 4

        # findBiggest function completed $ra value is restored
        lw $ra, 0($sp)
        addu $sp, $sp, 4

        ################# FINDBIGGEST FUNCTION DONE ###########
        #######################################################
        ########## INSERT FUNCTION STARTED ####################
        # insert function parameters are prepared
        # store $v0 and $a0 in stack 
        subu $sp, $sp, 8
        sw $v0, 0($sp)
        sw $a0, 4($sp)

        # $a0 -> biggest value, $a1 -> root node address
        move $a0, $s0

        move $a1, $v0

        # insert function will be called so store $ra in stack
        subu $sp, $sp, 4
        sw $ra, 0($sp) 

        jal insert

        # insert function completed $ra value is restored
        lw $ra, 0($sp)
        addu $sp, $sp, 4

        # restore $v0 and $a0 values from stack
        lw $v0, 0($sp)
        lw $a0, 4($sp)
        addu $sp, $sp, 8

        ################# INSERT FUNCTION DONE ################
        j insertEachNodeLoop
    
    insertEachNodeLoopEnd:

    ### RESTORE THE INITIAL parameter $a0 and $v0 from stack
    lw $a0, 0($sp)
    lw $v0, 4($sp)
    addu $sp, $sp, 8

        jr $ra

####################################
# Insert Procedure
####################################
insert: # (value, rootNodeAddress)
    # initial parameters $a0 -> value , $a1 -> rootNodeAddress
    
    # if value is $zero than there is not a valid value then return immediately
    beq $a0, $zero, returnImmediately

    # store initial parameters to stack
    subu $sp, $sp, 8
    sw $a0, 0($sp)
    sw $a1, 4($sp)

    ## find tail parent address
    findTailParentLoop:
        # Left child is empty $t0 -> leftChild
        lw $t0, 4($a1)
        beq $t0, $zero, leftChildEmpty
        # Right child is empty $t0 -> rightChild
        lw $t0, 8($a1)
        beq $t0, $zero, rightChildEmpty
        # If upper part is not true, then child slots are full, pass next parent and
        addu $a1, $a1, 16 
        # return to the beginning of the loop
        j findTailParentLoop 
    
    leftChildEmpty:
        
        # create child node
        li $v0, 9
        li $a0, 16
        syscall

        # v0 -> is child node address, a1 -> parent node address
        # restore $a0 (child node value) from stack
        lw $a0, 0($sp)

        # change child node value 
        sw $a0, 0($v0)
        # change child node's left child address to zero
        sw $zero, 4($v0)
        # change child node's right child address to zero
        sw $zero, 8($v0)
        # change child node parent address to its parent node's address
        sw $a1, 12($v0)
        # update parent node's left child address
        sw $v0,  4($a1)

        j heapListCheck
        
    rightChildEmpty:
        
        # create child node
        li $v0, 9
        li $a0, 16
        syscall

        # v0 -> is child node address, a1 -> parent node address
        # restore $a0 from stack
        lw $a0, 0($sp)

        # change child node value 
        sw $a0, 0($v0)
        # change child node's left child address to zero
        sw $zero, 4($v0)
        # change child node's right child address to zero
        sw $zero, 8($v0)
        # change child node parent address to its parent node's address
        sw $a1, 12($v0)
        # update parent node's left child address
        sw $v0, 8($a1)

    heapListCheck:
        #### check for heap list condition 
        move $t0, $v0 # $t0 -> child node address
        move $t1, $a1 # $t1 -> Parent node address
        lw $t2, 0($t0) # $t2 -> Child node value
        lw $t3, 0($t1) # $t3 -> Parent node value

        # compare value with parentnode value
        ble $t2, $t3, testInsertion

    swapNodes:
        # child node's value updated
        sw $t3, 0($t0)
        # parent node's value updated
        sw $t2, 0($t1)

        # check if the parent node is root node
        # Parent node's parent node address
        lw $t5, 12($t1) # t5 -> Parent node's parent node address
        beq $t5, $zero, testInsertion # If parent node's parent is empty then it is root node then return.

        move $v0, $t1 # $t1 former parent node new child node
        move $a1, $t5 # $t5 former parent's parent node new parent node

        j heapListCheck

    testInsertion:
        ############################
        # It must print parent and child node values
        subu $sp, $sp, 8
        sw $v0, 0($sp)
        sw $a0, 4($sp)

        move $t7, $v0
        move $t6, $a1
        # Check for child node value
        lw $a0, 0($t7)
        li $v0, 1
        syscall
        
        # Print space
        li $v0, 4
        la $a0, space
        syscall
        
        # Check for child node left child address value
        lw $a0, 4($t7)
        li $v0, 1
        syscall

        # Print space
        li $v0, 4
        la $a0, space
        syscall

        # Check for child node right child address value
        lw $a0, 8($t7)
        li $v0, 1
        syscall

        # Print space
        li $v0, 4
        la $a0, space
        syscall

        # Check for child node parent address value
        lw $a0, 12($t7)
        li $v0, 1
        syscall

        # Print new line
        li $v0, 4
        la $a0, newLine
        syscall
        
        # Check for parent node value
        lw $a0, 0($t6)
        li $v0, 1
        syscall
        
        # Print space
        li $v0, 4
        la $a0, space
        syscall
        
        # Check for parent node left child address value
        lw $a0, 4($t6)
        li $v0, 1
        syscall

        # Print space
        li $v0, 4
        la $a0, space
        syscall

        # Check for parent node right child address value
        lw $a0, 8($t6)
        li $v0, 1
        syscall

        # Print space
        li $v0, 4
        la $a0, space
        syscall

        # Check for parent node parent address value
        lw $a0, 12($t6)
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



    # restore initial parameters
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addu $sp, $sp, 8

    returnImmediately:
        # empty the $v0
        move $v0, $zero
        
        jr $ra

####################################
# Remove Procedure
####################################
remove: # (list) -> (removedBiggestValue)
    ## Parameters $a0 -> list
    # Finds biggest value in given list
    # Then removes it from list.

    # Store parameters to stack
    subu $sp, $sp, 4
    sw $a0, 0($sp)


    # FindBiggest function will be called store $ra in stack 
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    # Parameters $a0 -> list, $v0 biggest value in the list
    jal findBiggest
    # FindBiggest Function completed restore $ra from stack
    lw $ra, 0($sp)
    addu $sp, $sp, 4

    # Restore $a0 from stack
    lw $a0, 0($sp)

    # Store $v0 (biggest value) to $t0 register
    move $t0, $v0

    # Load $a0 (list) to $t1 register from stack
    move $t1, $a0

    # RemoveBiggestValueFromList function will be called store $ra in stack 
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    # Parameters $a0 -> biggestValue, $a1 -> list, $v0 -> updatedList
    move $a0, $t0
    move $a1, $t1

    jal removeBiggestValueFromList

    
    # Function completed $ra restored
    lw $ra, 0($sp)
    addu $sp, $sp, 4

    # Assign removedValue to v0
    move $v0, $a0 

    # $a0 restored 
    lw $a0, 0($sp)
    addu $sp, $sp, 4

    jr $ra

####################################
# Print Procedure
####################################
print: # (rootNodeAddress)
    # Store $a0 to stack
    subu $sp, $sp, 4
    sw $a0, 0($sp)

    # move the RootNodeAddress to temp reg.
    move $t0, $a0

    printLoop:
    # Loop through list
        # current node's value is in $t1
        lw $t1, 0($t0)
        ## End condition
        # if one of the left child or right child is empty or both empty then 
        # If value is less than or equal to $zero j willNotPrint and return  
        ble $t1, $zero, willNotPrint
        # Else print value
        move $a0, $t1
        li $v0, 1
        syscall
        # Print space
        la $a0, space
        li $v0, 4
        syscall 

        # Pass next node and j loop again
        addu $t0, $t0, 16
        j printLoop

    # Unless value is bigger than $zero then return
    willNotPrint:
        # Print new line
        la $a0, newLine
        li $v0, 4
        syscall

        # Restore $a0 from stack
        lw $a0, 0($sp)
        addu $sp, $sp, 4

        jr $ra

####################################
# Extra Procedures
####################################
####################################
# FindBiggest Procedure
####################################
findBiggest: # (list) -> (biggestValue)

    # assign unordered list address to $s5 register
    move $s5, $a0
    # format $s4 (former biggest value) with $zero
    move $s4, $zero

    printGivenList:
            # put parameters to stack
            subu $sp, $sp, 8
            sw $v0, 0($sp)
            sw $a0, 4($sp)

            # protect s5 from changes
            move $t7, $s5
            findBiggestTestLoop:
                # Check for root node value
                lw $t1 0($t7)
                beq $t1, -1, findBiggestTestEnd
                
                lw $a0, 0($t7)
        
                li $v0, 1
                syscall
                        
                # Print space
                li $v0, 4
                la $a0, space
                syscall
                
                addu $t7, $t7, 4
                j findBiggestTestLoop
            findBiggestTestEnd:

                # Print space
                li $v0, 4
                la $a0, newLine
                syscall

                #restore values
                lw $v0, 0($sp)
                lw $a0, 4($sp)
                addu $sp, $sp, 8
                #################################
        ########### TEST DONE #############
    findBiggestLoop:
        # load current list element to $t0

        lw $t0, 0($s5)

        # list finished

        beq $t0, -1, returnBiggest

        # compare current biggest and current array value

        blt $s4, $t0, updateBiggest

        # pass next element in the array

        addu $s5, $s5, 4
        
        # j to loop
        j findBiggestLoop

    returnBiggest:
        # store biggestValue to $v0
        move $v0, $s4

        jr $ra

    updateBiggest:
        # $t0 -> current item, $s4 -> former biggest value
        move $s4, $t0 
    
        j findBiggestLoop

####################################
# removeBiggestValueFromList Procedure
####################################
removeBiggestValueFromList: # (list, removalValue) -> (updatedList)
    # unordered list $a0
    # biggest value $a1
    # returns updatedList (biggest value removed) $v0
    
    # unordered list in $t2
    move $t2, $a0
    # biggest value in $t3
    move $t3, $a1

    updateValues:
        # current value $t0
        lw $t0, 0($t2)
        # next value $t1
        lw $t1, 4($t2)

        # if current value is equal to biggest
        beq $t3, $t0, biggestValueFound

    biggestValueNotFound: 
        # biggest value NOT FOUND search process continues. 
        addu $t2, $t2, 4
        
        j updateValues
    
        
    biggestValueFound:
        # Values are updated
            # current value $t0
            lw $t0, 0($t2)
            # next value $t1
            lw $t1, 4($t2)
        #remove process continues. 
        # if next value is -1, j removeCompleted
        beq $t1, -1, removeCompleted
        # else 
            #change value with next value in the list
            sw $t1, 0($t2)
            # pass the next value
            addu $t2, $t2, 4

            j biggestValueFound
    removeCompleted:
        # change current value in the list with next value (-1)
        sw $t1, 0($t2)
        # next value is -1, change it with zero and jump returnBiggest
        sw $zero, 4($t2)
        
        # list updated completely and unordered list address assigned to v0 
        move $v0, $a0

        jr $ra