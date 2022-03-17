# mips_assembly_practice
## In this practice, I have created a priority queue with its operations in MIPS Assembly. 
## I have implemented a max binary heap to represent the priority queue (where the value of parent node will always be greater than the value of child node, and the root value must be maximum among all.

### Each node has 16-byte address which holds information given below:
## | Structure |

### Byte Address        Contents
###     X           Value of the node
###   X + 4       Address of the left child
###   X + 8       Address of the right child
###   X + 12       Address of the parent

## | Conventions |

### The arguments to the procedures are stored in $a registers, the first one in $a0, second one in $a1 and so on.
### Argument check is out-of-scope. I did not check the arguments for their validity.

## | Implemented Procedures |

### build (list)
### This procedure will construct a priority queue data structure from an unordered list of integers. The address of the first integer is in the  list  argument (I assumed the list is terminated by -1). This procedure will call insert procedure for each node insertion operation other than the first node. First insertion is handled in this procedure and the address of the root node provided to the insert procedure as an argument for the subsequent insertions. The address of the root is stored in $v0 register.

### insert (value, queue)
### This procedure will create and put a new node (the value is given in $a0 register) to the queue (the address of the root node of the queue is in queue argument). The procedure will require new space in memory for the new node, which is obtained with the MIPS system call.

### print (queue)
### This procedure will print the priority queue (the address of the root node is in queue argument) to the screen by breadth first traversal.
