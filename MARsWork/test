.data
list: .word 3, 2, 1, 4, 7, 1, -1
size: .word 7
#MARsWork/Examples/Proj-B_test2.s
.text
main:
lui $1, 0x1001
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
ori $16, $1, 0x001C
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
lw $s0, 0($s0)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $s1, $s0, -1 #limit
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $s2, $0, 1  #counter
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
lui $v1, 0x1001     #base address
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
ori $8, $1, 0x0000
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
add $t0, $0, $v1 #initilizes address counter to base address
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
jal print
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
loop:
lw $t1, 0($t0)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
lw $t2, 4($t0)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
slt $t3, $t2, $t1
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
beq $t3, $0, skipswap
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sw $t1, 4($t0)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sw $t2, 0($t0)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
skipswap:
addi $s2, $s2, 1  #increment coutner by 1
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $t0, $t0, 4  #incrase memory refrence
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
bne $s2, $s0, loop
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $s2, $0, 1   #reset counter to 1
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
add $t0, $0, $v1 #reset address to base
addi $s1, $s1, -1
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
bne $s1, $0 loop
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
jal print
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
li   $v0, 10          # system call for exit
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
      syscall               # Exit!
	  sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
      j end
	  sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
     
     
print:
addi $t4, $0, 0 #print counter
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
add $t5, $0, $v1 #base addrees copy
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
printloop:
lw $a0, 0($t5)
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
ori  $v0, $zero , 1    # specify Print Integer service
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
syscall
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $t4, $t4, 1
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $t5, $t5, 4
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
bne $t4, $s0, printloop #if print counter is same as size, quit
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
addi $a0, $0, 0x2D
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
        addi $v0, $0, 0xB
		sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
        syscall
		sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
jr $ra
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
end: