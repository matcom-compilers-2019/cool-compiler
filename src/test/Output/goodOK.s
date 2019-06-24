.data
buffer:
.space 65536
strsubstrexception: .asciiz "Substring index exception
"

#Hierachy
Object_INH:
.word None_INH


#Hierachy
IO_INH:
.word Object_INH


#Hierachy
Int_INH:
.word Object_INH


#Hierachy
Bool_INH:
.word Object_INH


#Hierachy
String_INH:
.word Object_INH


#Hierachy
A_INH:
.word Object_INH


#Hierachy
BB___INH:
.word A_INH


#Hierachy
Main_INH:
.word Object_INH


#Virtual_Table
Object_VT:
.word Object_INH
.word Object.abort
.word Object.type_name
.word Object.copy


#Virtual_Table
IO_VT:
.word IO_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word IO.out_string
.word IO.out_int
.word IO.in_string
.word IO.in_int


#Virtual_Table
Int_VT:
.word Int_INH
.word Object.abort
.word Object.type_name
.word Object.copy


#Virtual_Table
Bool_VT:
.word Bool_INH
.word Object.abort
.word Object.type_name
.word Object.copy


#Virtual_Table
String_VT:
.word String_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word String.length
.word String.concat
.word String.substr


#Virtual_Table
A_VT:
.word A_INH
.word Object.abort
.word Object.type_name
.word Object.copy


#Virtual_Table
BB___VT:
.word BB___INH
.word Object.abort
.word Object.type_name
.word Object.copy


#Virtual_Table
Main_VT:
.word Main_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word Main.main



.globl main
.text
inherit:
beq $a0, $a1, inherit_true
beq $a0, $zero, inherit_false
lw $a0, ($a0)
j inherit
inherit_true:
li $v0, 1
jr $ra
inherit_false:
li $v0, 0
jr $ra
        

#Cambiado
Object.copy:
lw $a1, -4($sp)
lw $a0, -8($sp)
li $v0, 9
syscall
lw $a1, -4($sp)
lw $a0, 4($a1)
move $a3, $v0
_copy.loop:
lw $a2, 0($a1)
sw $a2, 0($a3)
addiu $a0, $a0, -1
addiu $a1, $a1, 4
addiu $a3, $a3, 4
beq $a0, $zero, _copy.end
j _copy.loop
_copy.end:
jr $ra

#Cambiado(Funciona)
Object.abort:
li $v0, 10
syscall

#Cambiado(funciona)
IO.out_string:
li $v0, 4
lw $a0, -4($sp)
syscall
jr $ra

#Cambiado(Funciona)
IO.out_int:
li $v0, 1
lw $a0, -4($sp)
syscall
jr $ra


IO.in_string:
move $a3, $ra
la $a0, buffer
li $a1, 65536
li $v0, 8
syscall
addiu $sp, $sp, -4
sw $a0, 0($sp)
jal String.length
addiu $sp, $sp, 4
move $a2, $v0
addiu $a2, $a2, -1
move $a0, $v0
li $v0, 9
syscall
move $v1, $v0
la $a0, buffer
_in_string.loop:
beqz $a2, _in_string.end
lb $a1, 0($a0)
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
addiu $a2, $a2, -1
j _in_string.loop
_in_string.end:
sb $zero, 0($v1)
move $ra, $a3
jr $ra


IO.in_int:
li $v0, 5
syscall
jr $ra

#(Cambiado)
String.length:
lw $a0, -4($sp)
_stringlength.loop:
lb $a1, 0($a0)
beqz $a1, _stringlength.end
addiu $a0, $a0, 1
j _stringlength.loop
_stringlength.end:
lw $a1, -4($sp)
subu $v0, $a0, $a1
jr $ra


String.concat:
move $a2, $ra
jal String.length
move $v1, $v0
addiu $sp, $sp, -4
jal String.length
addiu $sp, $sp, 4
add $v1, $v1, $v0
addi $v1, $v1, 1
li $v0, 9
move $a0, $v1
syscall
move $v1, $v0
lw $a0, 0($sp)
_stringconcat.loop1:
lb $a1, 0($a0)
beqz $a1, _stringconcat.end1
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
j _stringconcat.loop1
_stringconcat.end1:
lw $a0, -4($sp)
_stringconcat.loop2:
lb $a1, 0($a0)
beqz $a1, _stringconcat.end2
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
j _stringconcat.loop2
_stringconcat.end2:
sb $zero, 0($v1)
move $ra, $a2
jr $ra

#(Cambiado)
String.substr:
lw $a0, -12($sp)
addiu $a0, $a0, 1
li $v0, 9
syscall
move $v1, $v0
lw $a0, -4($sp)
lw $a1, -8($sp)
add $a0, $a0, $a1
lw $a2, -12($sp)
_stringsubstr.loop:
beqz $a2, _stringsubstr.end
lb $a1, 0($a0)
beqz $a1, _substrexception
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
addiu $a2, $a2, -1
j _stringsubstr.loop
_stringsubstr.end:
sb $zero, 0($v1)
jr $ra


_substrexception:
la $a0, strsubstrexception
li $v0, 4
syscall
li $v0, 10
syscall


_stringcmp:
li $v0, 1
_stringcmp.loop:
lb $a2, 0($a0)
lb $a3, 0($a1)
beqz $a2, _stringcmp.end
beq $a2, $zero, _stringcmp.end
beq $a3, $zero, _stringcmp.end
bne $a2, $a3, _stringcmp.differents
addiu $a0, $a0, 1
addiu $a1, $a1, 1
j _stringcmp.loop
_stringcmp.end:
beq $a2, $a3, _stringcmp.equals
_stringcmp.differents:
li $v0, 0
jr $ra
_stringcmp.equals:
li $v0, 1
jr $ra

#Label
main:


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Allocate
li $v0, 9
li $a0, 4
syscall
sw $v0, -4($sp)
la $a1, Main_VT
sw $a1, ($v0)


#DispatchParent
la $v0, Main.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -12($sp)


#Goto
j Object.abort


#Label
Object.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
IO.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
Int.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
Bool.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
String.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
A.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
BB__.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
Main.Constructor:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
Main.main:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 1
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


li $v0, 10
syscall
