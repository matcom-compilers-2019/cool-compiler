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
B_INH:
.word A_INH


#Hierachy
C_INH:
.word B_INH


#Hierachy
D_INH:
.word C_INH


#Hierachy
Main_INH:
.word IO_INH


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
.word A.f
.word A.g


#Virtual_Table
B_VT:
.word B_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word A.f
.word B.g


#Virtual_Table
C_VT:
.word C_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word C.f
.word B.g


#Virtual_Table
D_VT:
.word D_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word D.f
.word D.g


#Virtual_Table
Main_VT:
.word Main_INH
.word Object.abort
.word Object.type_name
.word Object.copy
.word IO.out_string
.word IO.out_int
.word IO.in_string
.word IO.in_int
.word Main.main


#String
str1: .asciiz "\n"



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
li $a0, 20
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
addiu $a0, $a0, 32
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
A.f:
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


#Label
A.g:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 2
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
B.Constructor:
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
B.g:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 3
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
C.Constructor:
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
C.f:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 4
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
D.Constructor:
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
D.f:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 5
sw $a0, ($sp)
addiu $sp, $sp, 4


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


#Label
D.g:
sw $ra, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 6
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
la $a1, A_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, A.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -12($sp)
sw $a0, 4($a1)


#Pop
addiu $sp, $sp, -4


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
la $a1, B_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, B.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -12($sp)
sw $a0, 8($a1)


#Pop
addiu $sp, $sp, -4


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
la $a1, C_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, C.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -12($sp)
sw $a0, 12($a1)


#Pop
addiu $sp, $sp, -4


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
la $a1, D_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, D.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -12($sp)
sw $a0, 16($a1)


#Pop
addiu $sp, $sp, -4


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


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#MemoToVar
lw $a0, -24($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -20($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -28($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -24($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -32($sp)
lw $a1, 8($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -28($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -36($sp)
lw $a1, 8($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -32($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -40($sp)
lw $a1, 12($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -36($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -44($sp)
lw $a1, 12($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -40($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -48($sp)
lw $a1, 16($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -44($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -52($sp)
lw $a1, 16($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -48($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -56($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, A.f
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -52($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -60($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, A.g
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -56($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -64($sp)
lw $a1, 8($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, A.f
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -60($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -68($sp)
lw $a1, 8($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, A.g
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -64($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -72($sp)
lw $a1, 12($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, B.f
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -68($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -76($sp)
lw $a1, 12($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, B.g
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -72($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -80($sp)
lw $a1, 16($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, C.f
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -76($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -84($sp)
lw $a1, 16($a0)
sw $a1, -4($sp)


#DispatchParent
la $v0, C.g
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -80($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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
la $a1, B_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, B.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -80($sp)
sw $a0, 4($a1)


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
la $a1, C_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, C.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -84($sp)
sw $a0, 8($a1)


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
la $a1, D_VT
sw $a1, ($v0)


#VarToVar
lw $a0, -4($sp)
sw $a0, -12($sp)


#DispatchParent
la $v0, D.Constructor
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -8


#VarToMemo
lw $a0, -4($sp)
lw $a1, -88($sp)
sw $a0, 12($a1)


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


#MemoToVar
lw $a0, -100($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -96($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -104($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -100($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -108($sp)
lw $a1, 8($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -104($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -112($sp)
lw $a1, 8($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -108($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -116($sp)
lw $a1, 12($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -112($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


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


#MemoToVar
lw $a0, -120($sp)
lw $a1, 12($a0)
sw $a1, -4($sp)


#Dispatch
lw $a0, -4($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Dispatch
lw $a0, -116($sp)
lw $a0, ($a0)
addiu $a0, $a0, 20
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Push
li $a0, 0
sw $a0, ($sp)
addiu $sp, $sp, 4


#Load_Label
la $a0, str1
sw $a0, -4($sp)


#Dispatch
lw $a0, -120($sp)
lw $a0, ($a0)
addiu $a0, $a0, 16
lw $v0, ($a0)
jalr $ra, $v0
sw $v0, -8($sp)


#Pop
addiu $sp, $sp, -4


#VarToVar
lw $a0, -4($sp)
sw $a0, -108($sp)


#Pop
addiu $sp, $sp, -104


#Return
lw $v0, -4($sp)
addiu $sp, $sp, -4
lw $ra, -4($sp)
addiu $sp, $sp, -4
jr $ra


li $v0, 10
syscall
