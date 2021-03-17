# data section
.data
base: .space 1

# code/instruction section
.text
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi  $1,  $0,  3 # Place 3 in $1
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
add $3, $1, $0 # Place 1 in $2
addiu $3, $0, 5
addiu $4, $0, -100
sll $0, $0, 0
sll $0, $0, 0
addu $5, $3, $1
addu $5, $3, $4
and $1, $3, $1
andi $1, $3, 44
nor $1, $3, $4
xor $1, $3, $4
xori $1, $3, 4
or $1, $3, $4
ori $1, $0, 4660
slt $1, $3, $5
slt $1, $5, $3
slti $1, $5, 10
addi $6, $0, 1
sll $0, $0, 0
sll $0, $0, 0
sub $7 , $1, $6
subu $8 , $4, $5
slt $9, $6, $4
addi $10, $0, 10
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $11, $10, 3
srl $11, $10, 1
sra $11, $10, 2
sltiu $11, $10, 1
sltiu $11, $10, -1
sltu $11, $1, $10
sltu $11, $10, $

addi $9 , $0 , 2
addi $14, $0, 10
addi $15, $0, 2
sll $0, $0, 0
sll $0, $0, 0
addi $11, $zero, 5
srav $13, $14, $15
srlv $13, $14, $15
sllv $13, $14, $15
lui $9, 0x1001
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sw $11, 0($9)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $11, $zero, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
lw $11, 0($9)
lui $12, 0

# MARsWork/Examples/test.asm
addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt

