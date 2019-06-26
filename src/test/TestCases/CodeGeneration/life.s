.data
buffer: .space 65536
strsubstrexception: .asciiz "Substring index exception
"
str0: .asciiz "Object"
str1: .asciiz "IO"
str2: .asciiz "Int"
str3: .asciiz "Bool"
str4: .asciiz "String"
str5: .asciiz "Board"
str6: .asciiz "CellularAutomaton"
str7: .asciiz "\n"
str8: .asciiz " "
str9: .asciiz "X"
str10: .asciiz "-"
str11: .asciiz ""
str12: .asciiz "\nPlease chose a number:\n"
str13: .asciiz "\t1: A cross\n"
str14: .asciiz "\t2: A slash from the upper left to lower right\n"
str15: .asciiz "\t3: A slash from the upper right to lower left\n"
str16: .asciiz "\t4: An X\n"
str17: .asciiz "\t5: A greater than sign \n"
str18: .asciiz "\t6: A less than sign\n"
str19: .asciiz "\t7: Two greater than signs\n"
str20: .asciiz "\t8: Two less than signs\n"
str21: .asciiz "\t9: A 'V'\n"
str22: .asciiz "\t10: An inverse 'V'\n"
str23: .asciiz "\t11: Numbers 9 and 10 combined\n"
str24: .asciiz "\t12: A full grid\n"
str25: .asciiz "\t13: A 'T'\n"
str26: .asciiz "\t14: A plus '+'\n"
str27: .asciiz "\t15: A 'W'\n"
str28: .asciiz "\t16: An 'M'\n"
str29: .asciiz "\t17: An 'E'\n"
str30: .asciiz "\t18: A '3'\n"
str31: .asciiz "\t19: An 'O'\n"
str32: .asciiz "\t20: An '8'\n"
str33: .asciiz "\t21: An 'S'\n"
str34: .asciiz "Your choice => "
str35: .asciiz " XX  XXXX XXXX  XX  "
str36: .asciiz "    X   X   X   X   X    "
str37: .asciiz "X     X     X     X     X"
str38: .asciiz "X   X X X   X   X X X   X"
str39: .asciiz "X     X     X   X   X    "
str40: .asciiz "    X   X   X     X     X"
str41: .asciiz "X  X  X  XX  X      "
str42: .asciiz " X  XX  X  X  X     "
str43: .asciiz "X   X X X   X  "
str44: .asciiz "  X   X X X   X"
str45: .asciiz "X X X X X X X X"
str46: .asciiz "XXXXXXXXXXXXXXXXXXXXXXXXX"
str47: .asciiz "XXXXX  X    X    X    X  "
str48: .asciiz "  X    X  XXXXX  X    X  "
str49: .asciiz "X     X X X X   X X  "
str50: .asciiz "  X X   X X X X     X"
str51: .asciiz "XXXXX   X   XXXXX   X   XXXX"
str52: .asciiz "XXX    X   X  X    X   XXXX "
str53: .asciiz " XX X  XX  X XX "
str54: .asciiz " XX X  XX  X XX X  XX  X XX "
str55: .asciiz " XXXX   X    XX    X   XXXX "
str56: .asciiz "                         "
str57: .asciiz "Would you like to continue with the next generation? \n"
str58: .asciiz "Please use lowercase y or n for your answer [y]: "
str59: .asciiz "n"
str60: .asciiz "\n\n"
str61: .asciiz "Would you like to choose a background pattern? \n"
str62: .asciiz "Please use lowercase y or n for your answer [n]: "
str63: .asciiz "y"
str64: .asciiz "Main"
str65: .asciiz "Welcome to the Game of Life.\n"
str66: .asciiz "There are many initial states to choose from. \n"
_class.IO: .word str1, str0, 0
_class.Int: .word str2, str0, 0
_class.Bool: .word str3, str0, 0
_class.String: .word str4, str0, 0
_class.Board: .word str5, str1, str0, 0
_class.CellularAutomaton: .word str6, str5, str1, str0, 0
_class.Main: .word str64, str6, str5, str1, str0, 0

.globl main
.text
_inherit:
lw $a0, 8($a0)
_inherit.loop:
lw $a2, 0($a0)
beq $a1, $a2, _inherit_true
beq $a2, $zero, _inherit_false
addiu $a0, $a0, 4
j _inherit.loop
_inherit_false:
li $v0, 0
jr $ra
_inherit_true:
li $v0, 1
jr $ra

_copy:
lw $a1, 0($sp)
lw $a0, -4($sp)
li $v0, 9
syscall
lw $a1, 0($sp)
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

_abort:
li $v0, 10
syscall

_out_string:
li $v0, 4
lw $a0, 0($sp)
syscall
jr $ra

_out_int:
li $v0, 1
lw $a0, 0($sp)
syscall
jr $ra

_in_string:
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

_in_int:
li $v0, 5
syscall
jr $ra

_stringlength:
lw $a0, 0($sp)
_stringlength.loop:
lb $a1, 0($a0)
beqz $a1, _stringlength.end
addiu $a0, $a0, 1
j _stringlength.loop
_stringlength.end:
lw $a1, 0($sp)
subu $v0, $a0, $a1
jr $ra

_stringconcat:
move $a2, $ra
jal _stringlength
move $v1, $v0
addiu $sp, $sp, -4
jal _stringlength
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

_stringsubstr:
lw $a0, -8($sp)
addiu $a0, $a0, 1
li $v0, 9
syscall
move $v1, $v0
lw $a0, 0($sp)
lw $a1, -4($sp)
add $a0, $a0, $a1
lw $a2, -8($sp)
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


main:
# Call start;
sw $ra, 0($sp)
addiu $sp, $sp, -4
jal start
addiu $sp, $sp, 4
lw $ra, 0($sp)
# Object.constructor:


Object.constructor:
# PARAM t0;
# // set method: Object.abort
# *(t0 + 3) = Label "Object.abort"
la $a0, Object.abort
lw $a1, 0($sp)
sw $a0, 12($a1)
# // set method: Object.type_name
# *(t0 + 4) = Label "Object.type_name"
la $a0, Object.type_name
lw $a1, 0($sp)
sw $a0, 16($a1)
# // set method: Object.copy
# *(t0 + 5) = Label "Object.copy"
la $a0, Object.copy
lw $a1, 0($sp)
sw $a0, 20($a1)
# // set class name: Object
# *(t0 + 0) = "Object"
la $a0, str0
lw $a1, 0($sp)
sw $a0, 0($a1)
# // set class size: 6 words
# *(t0 + 1) = 6
lw $a0, 0($sp)
li $a1, 6
sw $a1, 4($a0)
# Return ;

lw $v0, 4($sp)
jr $ra
# IO.constructor:


IO.constructor:
# PARAM t0;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -12($sp)
# Call Object.constructor;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Object.constructor
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
# // set method: IO.out_string
# *(t0 + 6) = Label "IO.out_string"
la $a0, IO.out_string
lw $a1, 0($sp)
sw $a0, 24($a1)
# // set method: IO.out_int
# *(t0 + 7) = Label "IO.out_int"
la $a0, IO.out_int
lw $a1, 0($sp)
sw $a0, 28($a1)
# // set method: IO.in_string
# *(t0 + 8) = Label "IO.in_string"
la $a0, IO.in_string
lw $a1, 0($sp)
sw $a0, 32($a1)
# // set method: IO.in_int
# *(t0 + 9) = Label "IO.in_int"
la $a0, IO.in_int
lw $a1, 0($sp)
sw $a0, 36($a1)
# // set class name: Object
# *(t0 + 0) = "IO"
la $a0, str1
lw $a1, 0($sp)
sw $a0, 0($a1)
# // set class size: 10 words
# *(t0 + 1) = 10
lw $a0, 0($sp)
li $a1, 10
sw $a1, 4($a0)
# // set class generation label
# *(t0 + 2) = Label "_class.IO"
la $a0, _class.IO
lw $a1, 0($sp)
sw $a0, 8($a1)
# Return ;

lw $v0, 4($sp)
jr $ra
# _class.IO: _class.Object
# _class.Int: _class.Object
# _class.Bool: _class.Object
# _class.String: _class.Object
# _wrapper.Int:


_wrapper.Int:
# PARAM t0;
# t1 = Alloc 7;
# Begin Allocate
li $v0, 9
li $a0, 28
syscall
sw $v0, -4($sp)
# End Allocate
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# Call Object.constructor;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Object.constructor
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
# *(t1 + 0) = "Int"
la $a0, str2
lw $a1, -4($sp)
sw $a0, 0($a1)
# *(t1 + 6) = t0
lw $a0, 0($sp)
lw $a1, -4($sp)
sw $a0, 24($a1)
# *(t1 + 2) = Label "_class.Int"
la $a0, _class.Int
lw $a1, -4($sp)
sw $a0, 8($a1)
# Return t1;

lw $v0, -4($sp)
jr $ra
# _wrapper.Bool:


_wrapper.Bool:
# PARAM t0;
# t1 = Alloc 7;
# Begin Allocate
li $v0, 9
li $a0, 28
syscall
sw $v0, -4($sp)
# End Allocate
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# Call Object.constructor;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Object.constructor
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
# *(t1 + 0) = "Bool"
la $a0, str3
lw $a1, -4($sp)
sw $a0, 0($a1)
# *(t1 + 6) = t0
lw $a0, 0($sp)
lw $a1, -4($sp)
sw $a0, 24($a1)
# *(t1 + 2) = Label "_class.Bool"
la $a0, _class.Bool
lw $a1, -4($sp)
sw $a0, 8($a1)
# Return t1;

lw $v0, -4($sp)
jr $ra
# _wrapper.String:


_wrapper.String:
# PARAM t0;
# t1 = Alloc 10;
# Begin Allocate
li $v0, 9
li $a0, 40
syscall
sw $v0, -4($sp)
# End Allocate
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# Call Object.constructor;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Object.constructor
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
# *(t1 + 0) = "String"
la $a0, str4
lw $a1, -4($sp)
sw $a0, 0($a1)
# *(t1 + 9) = t0
lw $a0, 0($sp)
lw $a1, -4($sp)
sw $a0, 36($a1)
# *(t1 + 2) = Label "_class.String"
la $a0, _class.String
lw $a1, -4($sp)
sw $a0, 8($a1)
# Return t1;

lw $v0, -4($sp)
jr $ra
# Object.abort:


Object.abort:
# Goto _abort
j _abort
# Object.type_name:


Object.type_name:
# PARAM t0;
# t0 = *(t0 + 0)
lw $a0, 0($sp)
lw $a1, 0($a0)
sw $a1, 0($sp)
# Return t0;

lw $v0, 0($sp)
jr $ra
# Object.copy:


Object.copy:
# PARAM t0;
# t1 = *(t0 + 1)
lw $a0, 0($sp)
lw $a1, 4($a0)
sw $a1, -4($sp)
# t2 = 4
li $a0, 4
sw $a0, -8($sp)
# t1 = t1 * t2
lw $a0, -4($sp)
lw $a1, -8($sp)
mult $a0, $a1
mflo $a0
sw $a0, -4($sp)
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -20($sp)
# t0 = Call _copy;
sw $ra, -12($sp)
addiu $sp, $sp, -16
jal _copy
addiu $sp, $sp, 16
lw $ra, -12($sp)
sw $v0, 0($sp)
# PopParam 2;
# Return t0;

lw $v0, 0($sp)
jr $ra
# IO.out_string:


IO.out_string:
# PARAM t0;
# PARAM t1;
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# t0 = Call _out_string;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal _out_string
addiu $sp, $sp, 12
lw $ra, -8($sp)
sw $v0, 0($sp)
# PopParam 1;
# Return t0;

lw $v0, 0($sp)
jr $ra
# IO.out_int:


IO.out_int:
# PARAM t0;
# PARAM t1;
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# t0 = Call _out_int;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal _out_int
addiu $sp, $sp, 12
lw $ra, -8($sp)
sw $v0, 0($sp)
# PopParam 1;
# Return t0;

lw $v0, 0($sp)
jr $ra
# IO.in_string:


IO.in_string:
# PARAM t0;
# t0 = Call _in_string;
sw $ra, -4($sp)
addiu $sp, $sp, -8
jal _in_string
addiu $sp, $sp, 8
lw $ra, -4($sp)
sw $v0, 0($sp)
# Return t0;

lw $v0, 0($sp)
jr $ra
# IO.in_int:


IO.in_int:
# PARAM t0;
# t0 = Call _in_int;
sw $ra, -4($sp)
addiu $sp, $sp, -8
jal _in_int
addiu $sp, $sp, 8
lw $ra, -4($sp)
sw $v0, 0($sp)
# Return t0;

lw $v0, 0($sp)
jr $ra
# String.length:


String.length:
# PARAM t0;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -8($sp)
# t0 = Call _stringlength;
sw $ra, -4($sp)
addiu $sp, $sp, -8
jal _stringlength
addiu $sp, $sp, 8
lw $ra, -4($sp)
sw $v0, 0($sp)
# PopParam 1;
# Return t0;

lw $v0, 0($sp)
jr $ra
# String.concat:


String.concat:
# PARAM t0;
# PARAM t1;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -12($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -16($sp)
# t0 = Call _stringconcat;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal _stringconcat
addiu $sp, $sp, 12
lw $ra, -8($sp)
sw $v0, 0($sp)
# PopParam 2;
# Return t0;

lw $v0, 0($sp)
jr $ra
# String.substr:


String.substr:
# PARAM t0;
# PARAM t1;
# PARAM t2;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -20($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -24($sp)
# t0 = Call _stringsubstr;
sw $ra, -12($sp)
addiu $sp, $sp, -16
jal _stringsubstr
addiu $sp, $sp, 16
lw $ra, -12($sp)
sw $v0, 0($sp)
# PopParam 3;
# Return t0;

lw $v0, 0($sp)
jr $ra
# _class.Board: _class.IO
# Board.size_of_board:


Board.size_of_board:
# PARAM t0;
# PARAM t1;
# // get veriable: initial
# t2 = t1
lw $a0, -4($sp)
sw $a0, -8($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -16($sp)
# t2 = Call String.length;
sw $ra, -12($sp)
addiu $sp, $sp, -16
jal String.length
addiu $sp, $sp, 16
lw $ra, -12($sp)
sw $v0, -8($sp)
# PopParam 1;
# Return t2;

lw $v0, -8($sp)
jr $ra
# Board.board_init:


Board.board_init:
# PARAM t0;
# PARAM t1;
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get veriable: start
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get method: Board.size_of_board
# t4 = *(t3 + 10)
lw $a0, -12($sp)
lw $a1, 40($a0)
sw $a1, -16($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -32($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -36($sp)
# t3 = Call t4;
sw $ra, -28($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -32
jalr $ra, $a0
addiu $sp, $sp, 32
lw $ra, -28($sp)
sw $v0, -12($sp)
# PopParam 2;
# // get veriable: size
# t5 = t3
lw $a0, -12($sp)
sw $a0, -20($sp)
# t6 = 15
li $a0, 15
sw $a0, -24($sp)
# t2 = t5 = t6
lw $a0, -20($sp)
lw $a1, -24($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.152
lw $a0, -8($sp)
beqz $a0, _else.152
# t2 = 3
li $a0, 3
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 5
li $a0, 5
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# Goto _endif.152
j _endif.152
# _else.152:


_else.152:
# // get veriable: size
# t5 = t3
lw $a0, -12($sp)
sw $a0, -20($sp)
# t6 = 16
li $a0, 16
sw $a0, -24($sp)
# t2 = t5 = t6
lw $a0, -20($sp)
lw $a1, -24($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.166
lw $a0, -8($sp)
beqz $a0, _else.166
# t2 = 4
li $a0, 4
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 4
li $a0, 4
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# Goto _endif.166
j _endif.166
# _else.166:


_else.166:
# // get veriable: size
# t5 = t3
lw $a0, -12($sp)
sw $a0, -20($sp)
# t6 = 20
li $a0, 20
sw $a0, -24($sp)
# t2 = t5 = t6
lw $a0, -20($sp)
lw $a1, -24($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.180
lw $a0, -8($sp)
beqz $a0, _else.180
# t2 = 4
li $a0, 4
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 5
li $a0, 5
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# Goto _endif.180
j _endif.180
# _else.180:


_else.180:
# // get veriable: size
# t5 = t3
lw $a0, -12($sp)
sw $a0, -20($sp)
# t6 = 21
li $a0, 21
sw $a0, -24($sp)
# t2 = t5 = t6
lw $a0, -20($sp)
lw $a1, -24($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.194
lw $a0, -8($sp)
beqz $a0, _else.194
# t2 = 3
li $a0, 3
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 7
li $a0, 7
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# Goto _endif.194
j _endif.194
# _else.194:


_else.194:
# // get veriable: size
# t5 = t3
lw $a0, -12($sp)
sw $a0, -20($sp)
# t6 = 25
li $a0, 25
sw $a0, -24($sp)
# t2 = t5 = t6
lw $a0, -20($sp)
lw $a1, -24($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.208
lw $a0, -8($sp)
beqz $a0, _else.208
# t2 = 5
li $a0, 5
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 5
li $a0, 5
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# Goto _endif.208
j _endif.208
# _else.208:


_else.208:
# // get veriable: size
# t5 = t3
lw $a0, -12($sp)
sw $a0, -20($sp)
# t6 = 28
li $a0, 28
sw $a0, -24($sp)
# t2 = t5 = t6
lw $a0, -20($sp)
lw $a1, -24($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.222
lw $a0, -8($sp)
beqz $a0, _else.222
# t2 = 7
li $a0, 7
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 4
li $a0, 4
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# Goto _endif.222
j _endif.222
# _else.222:


_else.222:
# t2 = 5
li $a0, 5
sw $a0, -8($sp)
# *(t0 + 12) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 5
li $a0, 5
sw $a0, -8($sp)
# *(t0 + 13) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# // get veriable: size
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# *(t0 + 14) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# _endif.222:


_endif.222:
# _endif.208:


_endif.208:
# _endif.194:


_endif.194:
# _endif.180:


_endif.180:
# _endif.166:


_endif.166:
# _endif.152:


_endif.152:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# Return t2;

lw $v0, -8($sp)
jr $ra
# Board.constructor:


Board.constructor:
# PARAM t0;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -16($sp)
# Call IO.constructor;
sw $ra, -12($sp)
addiu $sp, $sp, -16
jal IO.constructor
addiu $sp, $sp, 16
lw $ra, -12($sp)
# PopParam 1;
# // set method: Board.size_of_board
# *(t0 + 10) = Label "Board.size_of_board"
la $a0, Board.size_of_board
lw $a1, 0($sp)
sw $a0, 40($a1)
# // set method: Board.board_init
# *(t0 + 11) = Label "Board.board_init"
la $a0, Board.board_init
lw $a1, 0($sp)
sw $a0, 44($a1)
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# // set attribute: rows
# *(t0 + 12) = t1
lw $a0, -4($sp)
lw $a1, 0($sp)
sw $a0, 48($a1)
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# // set attribute: columns
# *(t0 + 13) = t1
lw $a0, -4($sp)
lw $a1, 0($sp)
sw $a0, 52($a1)
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# // set attribute: board_size
# *(t0 + 14) = t1
lw $a0, -4($sp)
lw $a1, 0($sp)
sw $a0, 56($a1)
# // set class name: Board
# *(t0 + 0) = "Board"
la $a0, str5
lw $a1, 0($sp)
sw $a0, 0($a1)
# // set class size: 15 words
# *(t0 + 1) = 15
lw $a0, 0($sp)
li $a1, 15
sw $a1, 4($a0)
# // set class generation label
# *(t0 + 2) = Label "_class.Board"
la $a0, _class.Board
lw $a1, 0($sp)
sw $a0, 8($a1)
# Return ;

lw $v0, 4($sp)
jr $ra
# _class.CellularAutomaton: _class.Board
# CellularAutomaton.init:


CellularAutomaton.init:
# PARAM t0;
# PARAM t1;
# // get veriable: map
# t2 = t1
lw $a0, -4($sp)
sw $a0, -8($sp)
# *(t0 + 33) = t2
lw $a0, -8($sp)
lw $a1, 0($sp)
sw $a0, 132($a1)
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: map
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# // get method: CellularAutomaton.board_init
# t3 = *(t2 + 11)
lw $a0, -8($sp)
lw $a1, 44($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -24($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -28($sp)
# t2 = Call t3;
sw $ra, -20($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -24
jalr $ra, $a0
addiu $sp, $sp, 24
lw $ra, -20($sp)
sw $v0, -8($sp)
# PopParam 2;
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.print:


CellularAutomaton.print:
# PARAM t0;
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# // get attribute: CellularAutomaton.board_size
# t4 = *(t0 + 14)
lw $a0, 0($sp)
lw $a1, 56($a0)
sw $a1, -16($sp)
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# t7 = "\n"
la $a0, str7
sw $a0, -28($sp)
# // get method: CellularAutomaton.out_string
# t6 = *(t3 + 6)
lw $a0, -12($sp)
lw $a1, 24($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -48($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -52($sp)
# t3 = Call t6;
sw $ra, -44($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -48
jalr $ra, $a0
addiu $sp, $sp, 48
lw $ra, -44($sp)
sw $v0, -12($sp)
# PopParam 2;
# _whilecondition.307:


_whilecondition.307:
# // get veriable: i
# t6 = t2
lw $a0, -8($sp)
sw $a0, -24($sp)
# // get veriable: num
# t7 = t4
lw $a0, -16($sp)
sw $a0, -28($sp)
# t3 = t6 < t7
lw $a0, -24($sp)
lw $a1, -28($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -12($sp)
# IfZ t3 Goto _endwhile.307
lw $a0, -12($sp)
beqz $a0, _endwhile.307
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get attribute: CellularAutomaton.population_map
# t7 = *(t0 + 33)
lw $a0, 0($sp)
lw $a1, 132($a0)
sw $a1, -28($sp)
# // get veriable: i
# t9 = t2
lw $a0, -8($sp)
sw $a0, -36($sp)
# // get attribute: CellularAutomaton.columns
# t10 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -40($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -48($sp)
# PushParam t9;
lw $a0, -36($sp)
sw $a0, -52($sp)
# PushParam t10;
lw $a0, -40($sp)
sw $a0, -56($sp)
# t7 = Call String.substr;
sw $ra, -44($sp)
addiu $sp, $sp, -48
jal String.substr
addiu $sp, $sp, 48
lw $ra, -44($sp)
sw $v0, -28($sp)
# PopParam 3;
# // get method: CellularAutomaton.out_string
# t6 = *(t3 + 6)
lw $a0, -12($sp)
lw $a1, 24($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -48($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -52($sp)
# t3 = Call t6;
sw $ra, -44($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -48
jalr $ra, $a0
addiu $sp, $sp, 48
lw $ra, -44($sp)
sw $v0, -12($sp)
# PopParam 2;
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# t7 = "\n"
la $a0, str7
sw $a0, -28($sp)
# // get method: CellularAutomaton.out_string
# t6 = *(t3 + 6)
lw $a0, -12($sp)
lw $a1, 24($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -48($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -52($sp)
# t3 = Call t6;
sw $ra, -44($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -48
jalr $ra, $a0
addiu $sp, $sp, 48
lw $ra, -44($sp)
sw $v0, -12($sp)
# PopParam 2;
# // get veriable: i
# t6 = t2
lw $a0, -8($sp)
sw $a0, -24($sp)
# // get attribute: CellularAutomaton.columns
# t7 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -28($sp)
# t3 = t6 + t7
lw $a0, -24($sp)
lw $a1, -28($sp)
add $a0, $a0, $a1
sw $a0, -12($sp)
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# Goto _whilecondition.307
j _whilecondition.307
# _endwhile.307:


_endwhile.307:
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# t7 = "\n"
la $a0, str7
sw $a0, -28($sp)
# // get method: CellularAutomaton.out_string
# t6 = *(t3 + 6)
lw $a0, -12($sp)
lw $a1, 24($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -48($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -52($sp)
# t3 = Call t6;
sw $ra, -44($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -48
jalr $ra, $a0
addiu $sp, $sp, 48
lw $ra, -44($sp)
sw $v0, -12($sp)
# PopParam 2;
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# Return t1;

lw $v0, -4($sp)
jr $ra
# CellularAutomaton.num_cells:


CellularAutomaton.num_cells:
# PARAM t0;
# // get attribute: CellularAutomaton.population_map
# t1 = *(t0 + 33)
lw $a0, 0($sp)
lw $a1, 132($a0)
sw $a1, -4($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# t1 = Call String.length;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal String.length
addiu $sp, $sp, 12
lw $ra, -8($sp)
sw $v0, -4($sp)
# PopParam 1;
# Return t1;

lw $v0, -4($sp)
jr $ra
# CellularAutomaton.cell:


CellularAutomaton.cell:
# PARAM t0;
# PARAM t1;
# // get attribute: CellularAutomaton.board_size
# t4 = *(t0 + 14)
lw $a0, 0($sp)
lw $a1, 56($a0)
sw $a1, -16($sp)
# t5 = 1
li $a0, 1
sw $a0, -20($sp)
# t3 = t4 - t5
lw $a0, -16($sp)
lw $a1, -20($sp)
sub $a0, $a0, $a1
sw $a0, -12($sp)
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.369
lw $a0, -8($sp)
beqz $a0, _else.369
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.369
j _endif.369
# _else.369:


_else.369:
# // get attribute: CellularAutomaton.population_map
# t2 = *(t0 + 33)
lw $a0, 0($sp)
lw $a1, 132($a0)
sw $a1, -8($sp)
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# t5 = 1
li $a0, 1
sw $a0, -20($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -28($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -32($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -36($sp)
# t2 = Call String.substr;
sw $ra, -24($sp)
addiu $sp, $sp, -28
jal String.substr
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -8($sp)
# PopParam 3;
# _endif.369:


_endif.369:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.north:


CellularAutomaton.north:
# PARAM t0;
# PARAM t1;
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 - t5
lw $a0, -16($sp)
lw $a1, -20($sp)
sub $a0, $a0, $a1
sw $a0, -12($sp)
# t4 = 0
li $a0, 0
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.395
lw $a0, -8($sp)
beqz $a0, _else.395
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.395
j _endif.395
# _else.395:


_else.395:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 - t6
lw $a0, -20($sp)
lw $a1, -24($sp)
sub $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.cell
# t3 = *(t2 + 18)
lw $a0, -8($sp)
lw $a1, 72($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -32($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -36($sp)
# t2 = Call t3;
sw $ra, -28($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -32
jalr $ra, $a0
addiu $sp, $sp, 32
lw $ra, -28($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.395:


_endif.395:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.south:


CellularAutomaton.south:
# PARAM t0;
# PARAM t1;
# // get attribute: CellularAutomaton.board_size
# t3 = *(t0 + 14)
lw $a0, 0($sp)
lw $a1, 56($a0)
sw $a1, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.423
lw $a0, -8($sp)
beqz $a0, _else.423
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.423
j _endif.423
# _else.423:


_else.423:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.cell
# t3 = *(t2 + 18)
lw $a0, -8($sp)
lw $a1, 72($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -32($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -36($sp)
# t2 = Call t3;
sw $ra, -28($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -32
jalr $ra, $a0
addiu $sp, $sp, 32
lw $ra, -28($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.423:


_endif.423:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.east:


CellularAutomaton.east:
# PARAM t0;
# PARAM t1;
# // get veriable: position
# t6 = t1
lw $a0, -4($sp)
sw $a0, -24($sp)
# t7 = 1
li $a0, 1
sw $a0, -28($sp)
# t5 = t6 + t7
lw $a0, -24($sp)
lw $a1, -28($sp)
add $a0, $a0, $a1
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 / t6
lw $a0, -20($sp)
lw $a1, -24($sp)
div $a0, $a1
mflo $a0
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 * t5
lw $a0, -16($sp)
lw $a1, -20($sp)
mult $a0, $a1
mflo $a0
sw $a0, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.452
lw $a0, -8($sp)
beqz $a0, _else.452
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.452
j _endif.452
# _else.452:


_else.452:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.cell
# t3 = *(t2 + 18)
lw $a0, -8($sp)
lw $a1, 72($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -36($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -40($sp)
# t2 = Call t3;
sw $ra, -32($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.452:


_endif.452:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.west:


CellularAutomaton.west:
# PARAM t0;
# PARAM t1;
# // get veriable: position
# t3 = t1
lw $a0, -4($sp)
sw $a0, -12($sp)
# t4 = 0
li $a0, 0
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.487
lw $a0, -8($sp)
beqz $a0, _else.487
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.487
j _endif.487
# _else.487:


_else.487:
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 / t6
lw $a0, -20($sp)
lw $a1, -24($sp)
div $a0, $a1
mflo $a0
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 * t5
lw $a0, -16($sp)
lw $a1, -20($sp)
mult $a0, $a1
mflo $a0
sw $a0, -12($sp)
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.495
lw $a0, -8($sp)
beqz $a0, _else.495
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.495
j _endif.495
# _else.495:


_else.495:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 - t6
lw $a0, -20($sp)
lw $a1, -24($sp)
sub $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.cell
# t3 = *(t2 + 18)
lw $a0, -8($sp)
lw $a1, 72($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -32($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -36($sp)
# t2 = Call t3;
sw $ra, -28($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -32
jalr $ra, $a0
addiu $sp, $sp, 32
lw $ra, -28($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.495:


_endif.495:
# _endif.487:


_endif.487:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.northwest:


CellularAutomaton.northwest:
# PARAM t0;
# PARAM t1;
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 - t5
lw $a0, -16($sp)
lw $a1, -20($sp)
sub $a0, $a0, $a1
sw $a0, -12($sp)
# t4 = 0
li $a0, 0
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.527
lw $a0, -8($sp)
beqz $a0, _else.527
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.527
j _endif.527
# _else.527:


_else.527:
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 / t6
lw $a0, -20($sp)
lw $a1, -24($sp)
div $a0, $a1
mflo $a0
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 * t5
lw $a0, -16($sp)
lw $a1, -20($sp)
mult $a0, $a1
mflo $a0
sw $a0, -12($sp)
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.538
lw $a0, -8($sp)
beqz $a0, _else.538
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.538
j _endif.538
# _else.538:


_else.538:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 - t6
lw $a0, -20($sp)
lw $a1, -24($sp)
sub $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.north
# t3 = *(t2 + 19)
lw $a0, -8($sp)
lw $a1, 76($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -32($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -36($sp)
# t2 = Call t3;
sw $ra, -28($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -32
jalr $ra, $a0
addiu $sp, $sp, 32
lw $ra, -28($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.538:


_endif.538:
# _endif.527:


_endif.527:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.northeast:


CellularAutomaton.northeast:
# PARAM t0;
# PARAM t1;
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 - t5
lw $a0, -16($sp)
lw $a1, -20($sp)
sub $a0, $a0, $a1
sw $a0, -12($sp)
# t4 = 0
li $a0, 0
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.570
lw $a0, -8($sp)
beqz $a0, _else.570
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.570
j _endif.570
# _else.570:


_else.570:
# // get veriable: position
# t6 = t1
lw $a0, -4($sp)
sw $a0, -24($sp)
# t7 = 1
li $a0, 1
sw $a0, -28($sp)
# t5 = t6 + t7
lw $a0, -24($sp)
lw $a1, -28($sp)
add $a0, $a0, $a1
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 / t6
lw $a0, -20($sp)
lw $a1, -24($sp)
div $a0, $a1
mflo $a0
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 * t5
lw $a0, -16($sp)
lw $a1, -20($sp)
mult $a0, $a1
mflo $a0
sw $a0, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.581
lw $a0, -8($sp)
beqz $a0, _else.581
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.581
j _endif.581
# _else.581:


_else.581:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.north
# t3 = *(t2 + 19)
lw $a0, -8($sp)
lw $a1, 76($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -36($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -40($sp)
# t2 = Call t3;
sw $ra, -32($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.581:


_endif.581:
# _endif.570:


_endif.570:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.southeast:


CellularAutomaton.southeast:
# PARAM t0;
# PARAM t1;
# // get attribute: CellularAutomaton.board_size
# t3 = *(t0 + 14)
lw $a0, 0($sp)
lw $a1, 56($a0)
sw $a1, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.617
lw $a0, -8($sp)
beqz $a0, _else.617
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.617
j _endif.617
# _else.617:


_else.617:
# // get veriable: position
# t6 = t1
lw $a0, -4($sp)
sw $a0, -24($sp)
# t7 = 1
li $a0, 1
sw $a0, -28($sp)
# t5 = t6 + t7
lw $a0, -24($sp)
lw $a1, -28($sp)
add $a0, $a0, $a1
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 / t6
lw $a0, -20($sp)
lw $a1, -24($sp)
div $a0, $a1
mflo $a0
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 * t5
lw $a0, -16($sp)
lw $a1, -20($sp)
mult $a0, $a1
mflo $a0
sw $a0, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.629
lw $a0, -8($sp)
beqz $a0, _else.629
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.629
j _endif.629
# _else.629:


_else.629:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.south
# t3 = *(t2 + 20)
lw $a0, -8($sp)
lw $a1, 80($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -36($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -40($sp)
# t2 = Call t3;
sw $ra, -32($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.629:


_endif.629:
# _endif.617:


_endif.617:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.southwest:


CellularAutomaton.southwest:
# PARAM t0;
# PARAM t1;
# // get attribute: CellularAutomaton.board_size
# t3 = *(t0 + 14)
lw $a0, 0($sp)
lw $a1, 56($a0)
sw $a1, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t2 = t3 < t4
lw $a0, -12($sp)
lw $a1, -16($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -8($sp)
# IfZ t2 Goto _else.665
lw $a0, -8($sp)
beqz $a0, _else.665
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.665
j _endif.665
# _else.665:


_else.665:
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get attribute: CellularAutomaton.columns
# t6 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -24($sp)
# t4 = t5 / t6
lw $a0, -20($sp)
lw $a1, -24($sp)
div $a0, $a1
mflo $a0
sw $a0, -16($sp)
# // get attribute: CellularAutomaton.columns
# t5 = *(t0 + 13)
lw $a0, 0($sp)
lw $a1, 52($a0)
sw $a1, -20($sp)
# t3 = t4 * t5
lw $a0, -16($sp)
lw $a1, -20($sp)
mult $a0, $a1
mflo $a0
sw $a0, -12($sp)
# // get veriable: position
# t4 = t1
lw $a0, -4($sp)
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.677
lw $a0, -8($sp)
beqz $a0, _else.677
# t2 = " "
la $a0, str8
sw $a0, -8($sp)
# Goto _endif.677
j _endif.677
# _else.677:


_else.677:
# t2 = t0
lw $a0, 0($sp)
sw $a0, -8($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# t4 = t5 - t6
lw $a0, -20($sp)
lw $a1, -24($sp)
sub $a0, $a0, $a1
sw $a0, -16($sp)
# // get method: CellularAutomaton.south
# t3 = *(t2 + 20)
lw $a0, -8($sp)
lw $a1, 80($a0)
sw $a1, -12($sp)
# PushParam t2;
lw $a0, -8($sp)
sw $a0, -32($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -36($sp)
# t2 = Call t3;
sw $ra, -28($sp)
lw $a0, -12($sp)
addiu $sp, $sp, -32
jalr $ra, $a0
addiu $sp, $sp, 32
lw $ra, -28($sp)
sw $v0, -8($sp)
# PopParam 2;
# _endif.677:


_endif.677:
# _endif.665:


_endif.665:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.neighbors:


CellularAutomaton.neighbors:
# PARAM t0;
# PARAM t1;
# t10 = t0
lw $a0, 0($sp)
sw $a0, -40($sp)
# // get veriable: position
# t12 = t1
lw $a0, -4($sp)
sw $a0, -48($sp)
# // get method: CellularAutomaton.north
# t11 = *(t10 + 19)
lw $a0, -40($sp)
lw $a1, 76($a0)
sw $a1, -44($sp)
# PushParam t10;
lw $a0, -40($sp)
sw $a0, -60($sp)
# PushParam t12;
lw $a0, -48($sp)
sw $a0, -64($sp)
# t10 = Call t11;
sw $ra, -56($sp)
lw $a0, -44($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -40($sp)
# PopParam 2;
# t11 = "X"
la $a0, str9
sw $a0, -44($sp)
# t9 = t10 =:= t11
lw $a0, -40($sp)
lw $a1, -44($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -36($sp)
# IfZ t9 Goto _else.709
lw $a0, -36($sp)
beqz $a0, _else.709
# t9 = 1
li $a0, 1
sw $a0, -36($sp)
# Goto _endif.709
j _endif.709
# _else.709:


_else.709:
# t9 = 0
li $a0, 0
sw $a0, -36($sp)
# _endif.709:


_endif.709:
# t11 = t0
lw $a0, 0($sp)
sw $a0, -44($sp)
# // get veriable: position
# t13 = t1
lw $a0, -4($sp)
sw $a0, -52($sp)
# // get method: CellularAutomaton.south
# t12 = *(t11 + 20)
lw $a0, -44($sp)
lw $a1, 80($a0)
sw $a1, -48($sp)
# PushParam t11;
lw $a0, -44($sp)
sw $a0, -60($sp)
# PushParam t13;
lw $a0, -52($sp)
sw $a0, -64($sp)
# t11 = Call t12;
sw $ra, -56($sp)
lw $a0, -48($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -44($sp)
# PopParam 2;
# t12 = "X"
la $a0, str9
sw $a0, -48($sp)
# t10 = t11 =:= t12
lw $a0, -44($sp)
lw $a1, -48($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -40($sp)
# IfZ t10 Goto _else.726
lw $a0, -40($sp)
beqz $a0, _else.726
# t10 = 1
li $a0, 1
sw $a0, -40($sp)
# Goto _endif.726
j _endif.726
# _else.726:


_else.726:
# t10 = 0
li $a0, 0
sw $a0, -40($sp)
# _endif.726:


_endif.726:
# t8 = t9 + t10
lw $a0, -36($sp)
lw $a1, -40($sp)
add $a0, $a0, $a1
sw $a0, -32($sp)
# t10 = t0
lw $a0, 0($sp)
sw $a0, -40($sp)
# // get veriable: position
# t12 = t1
lw $a0, -4($sp)
sw $a0, -48($sp)
# // get method: CellularAutomaton.east
# t11 = *(t10 + 21)
lw $a0, -40($sp)
lw $a1, 84($a0)
sw $a1, -44($sp)
# PushParam t10;
lw $a0, -40($sp)
sw $a0, -60($sp)
# PushParam t12;
lw $a0, -48($sp)
sw $a0, -64($sp)
# t10 = Call t11;
sw $ra, -56($sp)
lw $a0, -44($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -40($sp)
# PopParam 2;
# t11 = "X"
la $a0, str9
sw $a0, -44($sp)
# t9 = t10 =:= t11
lw $a0, -40($sp)
lw $a1, -44($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -36($sp)
# IfZ t9 Goto _else.744
lw $a0, -36($sp)
beqz $a0, _else.744
# t9 = 1
li $a0, 1
sw $a0, -36($sp)
# Goto _endif.744
j _endif.744
# _else.744:


_else.744:
# t9 = 0
li $a0, 0
sw $a0, -36($sp)
# _endif.744:


_endif.744:
# t7 = t8 + t9
lw $a0, -32($sp)
lw $a1, -36($sp)
add $a0, $a0, $a1
sw $a0, -28($sp)
# t9 = t0
lw $a0, 0($sp)
sw $a0, -36($sp)
# // get veriable: position
# t11 = t1
lw $a0, -4($sp)
sw $a0, -44($sp)
# // get method: CellularAutomaton.west
# t10 = *(t9 + 22)
lw $a0, -36($sp)
lw $a1, 88($a0)
sw $a1, -40($sp)
# PushParam t9;
lw $a0, -36($sp)
sw $a0, -60($sp)
# PushParam t11;
lw $a0, -44($sp)
sw $a0, -64($sp)
# t9 = Call t10;
sw $ra, -56($sp)
lw $a0, -40($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -36($sp)
# PopParam 2;
# t10 = "X"
la $a0, str9
sw $a0, -40($sp)
# t8 = t9 =:= t10
lw $a0, -36($sp)
lw $a1, -40($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -32($sp)
# IfZ t8 Goto _else.762
lw $a0, -32($sp)
beqz $a0, _else.762
# t8 = 1
li $a0, 1
sw $a0, -32($sp)
# Goto _endif.762
j _endif.762
# _else.762:


_else.762:
# t8 = 0
li $a0, 0
sw $a0, -32($sp)
# _endif.762:


_endif.762:
# t6 = t7 + t8
lw $a0, -28($sp)
lw $a1, -32($sp)
add $a0, $a0, $a1
sw $a0, -24($sp)
# t8 = t0
lw $a0, 0($sp)
sw $a0, -32($sp)
# // get veriable: position
# t10 = t1
lw $a0, -4($sp)
sw $a0, -40($sp)
# // get method: CellularAutomaton.northeast
# t9 = *(t8 + 24)
lw $a0, -32($sp)
lw $a1, 96($a0)
sw $a1, -36($sp)
# PushParam t8;
lw $a0, -32($sp)
sw $a0, -60($sp)
# PushParam t10;
lw $a0, -40($sp)
sw $a0, -64($sp)
# t8 = Call t9;
sw $ra, -56($sp)
lw $a0, -36($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -32($sp)
# PopParam 2;
# t9 = "X"
la $a0, str9
sw $a0, -36($sp)
# t7 = t8 =:= t9
lw $a0, -32($sp)
lw $a1, -36($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -28($sp)
# IfZ t7 Goto _else.780
lw $a0, -28($sp)
beqz $a0, _else.780
# t7 = 1
li $a0, 1
sw $a0, -28($sp)
# Goto _endif.780
j _endif.780
# _else.780:


_else.780:
# t7 = 0
li $a0, 0
sw $a0, -28($sp)
# _endif.780:


_endif.780:
# t5 = t6 + t7
lw $a0, -24($sp)
lw $a1, -28($sp)
add $a0, $a0, $a1
sw $a0, -20($sp)
# t7 = t0
lw $a0, 0($sp)
sw $a0, -28($sp)
# // get veriable: position
# t9 = t1
lw $a0, -4($sp)
sw $a0, -36($sp)
# // get method: CellularAutomaton.northwest
# t8 = *(t7 + 23)
lw $a0, -28($sp)
lw $a1, 92($a0)
sw $a1, -32($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -60($sp)
# PushParam t9;
lw $a0, -36($sp)
sw $a0, -64($sp)
# t7 = Call t8;
sw $ra, -56($sp)
lw $a0, -32($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -28($sp)
# PopParam 2;
# t8 = "X"
la $a0, str9
sw $a0, -32($sp)
# t6 = t7 =:= t8
lw $a0, -28($sp)
lw $a1, -32($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -24($sp)
# IfZ t6 Goto _else.798
lw $a0, -24($sp)
beqz $a0, _else.798
# t6 = 1
li $a0, 1
sw $a0, -24($sp)
# Goto _endif.798
j _endif.798
# _else.798:


_else.798:
# t6 = 0
li $a0, 0
sw $a0, -24($sp)
# _endif.798:


_endif.798:
# t4 = t5 + t6
lw $a0, -20($sp)
lw $a1, -24($sp)
add $a0, $a0, $a1
sw $a0, -16($sp)
# t6 = t0
lw $a0, 0($sp)
sw $a0, -24($sp)
# // get veriable: position
# t8 = t1
lw $a0, -4($sp)
sw $a0, -32($sp)
# // get method: CellularAutomaton.southeast
# t7 = *(t6 + 25)
lw $a0, -24($sp)
lw $a1, 100($a0)
sw $a1, -28($sp)
# PushParam t6;
lw $a0, -24($sp)
sw $a0, -60($sp)
# PushParam t8;
lw $a0, -32($sp)
sw $a0, -64($sp)
# t6 = Call t7;
sw $ra, -56($sp)
lw $a0, -28($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -24($sp)
# PopParam 2;
# t7 = "X"
la $a0, str9
sw $a0, -28($sp)
# t5 = t6 =:= t7
lw $a0, -24($sp)
lw $a1, -28($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -20($sp)
# IfZ t5 Goto _else.816
lw $a0, -20($sp)
beqz $a0, _else.816
# t5 = 1
li $a0, 1
sw $a0, -20($sp)
# Goto _endif.816
j _endif.816
# _else.816:


_else.816:
# t5 = 0
li $a0, 0
sw $a0, -20($sp)
# _endif.816:


_endif.816:
# t3 = t4 + t5
lw $a0, -16($sp)
lw $a1, -20($sp)
add $a0, $a0, $a1
sw $a0, -12($sp)
# t5 = t0
lw $a0, 0($sp)
sw $a0, -20($sp)
# // get veriable: position
# t7 = t1
lw $a0, -4($sp)
sw $a0, -28($sp)
# // get method: CellularAutomaton.southwest
# t6 = *(t5 + 26)
lw $a0, -20($sp)
lw $a1, 104($a0)
sw $a1, -24($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -60($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -64($sp)
# t5 = Call t6;
sw $ra, -56($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -60
jalr $ra, $a0
addiu $sp, $sp, 60
lw $ra, -56($sp)
sw $v0, -20($sp)
# PopParam 2;
# t6 = "X"
la $a0, str9
sw $a0, -24($sp)
# t4 = t5 =:= t6
lw $a0, -20($sp)
lw $a1, -24($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -16($sp)
# IfZ t4 Goto _else.834
lw $a0, -16($sp)
beqz $a0, _else.834
# t4 = 1
li $a0, 1
sw $a0, -16($sp)
# Goto _endif.834
j _endif.834
# _else.834:


_else.834:
# t4 = 0
li $a0, 0
sw $a0, -16($sp)
# _endif.834:


_endif.834:
# t2 = t3 + t4
lw $a0, -12($sp)
lw $a1, -16($sp)
add $a0, $a0, $a1
sw $a0, -8($sp)
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.cell_at_next_evolution:


CellularAutomaton.cell_at_next_evolution:
# PARAM t0;
# PARAM t1;
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get method: CellularAutomaton.neighbors
# t4 = *(t3 + 27)
lw $a0, -12($sp)
lw $a1, 108($a0)
sw $a1, -16($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t3 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -12($sp)
# PopParam 2;
# t4 = 3
li $a0, 3
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.856
lw $a0, -8($sp)
beqz $a0, _else.856
# t2 = "X"
la $a0, str9
sw $a0, -8($sp)
# Goto _endif.856
j _endif.856
# _else.856:


_else.856:
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get method: CellularAutomaton.neighbors
# t4 = *(t3 + 27)
lw $a0, -12($sp)
lw $a1, 108($a0)
sw $a1, -16($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t3 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -12($sp)
# PopParam 2;
# t4 = 2
li $a0, 2
sw $a0, -16($sp)
# t2 = t3 = t4
lw $a0, -12($sp)
lw $a1, -16($sp)
seq $a0, $a0, $a1
sw $a0, -8($sp)
# IfZ t2 Goto _else.871
lw $a0, -8($sp)
beqz $a0, _else.871
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get veriable: position
# t5 = t1
lw $a0, -4($sp)
sw $a0, -20($sp)
# // get method: CellularAutomaton.cell
# t4 = *(t3 + 18)
lw $a0, -12($sp)
lw $a1, 72($a0)
sw $a1, -16($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t3 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -12($sp)
# PopParam 2;
# t4 = "X"
la $a0, str9
sw $a0, -16($sp)
# t2 = t3 =:= t4
lw $a0, -12($sp)
lw $a1, -16($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -8($sp)
# IfZ t2 Goto _else.883
lw $a0, -8($sp)
beqz $a0, _else.883
# t2 = "X"
la $a0, str9
sw $a0, -8($sp)
# Goto _endif.883
j _endif.883
# _else.883:


_else.883:
# t2 = "-"
la $a0, str10
sw $a0, -8($sp)
# _endif.883:


_endif.883:
# Goto _endif.871
j _endif.871
# _else.871:


_else.871:
# t2 = "-"
la $a0, str10
sw $a0, -8($sp)
# _endif.871:


_endif.871:
# _endif.856:


_endif.856:
# Return t2;

lw $v0, -8($sp)
jr $ra
# CellularAutomaton.evolve:


CellularAutomaton.evolve:
# PARAM t0;
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# t4 = t0
lw $a0, 0($sp)
sw $a0, -16($sp)
# // get method: CellularAutomaton.num_cells
# t5 = *(t4 + 17)
lw $a0, -16($sp)
lw $a1, 68($a0)
sw $a1, -20($sp)
# PushParam t4;
lw $a0, -16($sp)
sw $a0, -52($sp)
# t4 = Call t5;
sw $ra, -48($sp)
lw $a0, -20($sp)
addiu $sp, $sp, -52
jalr $ra, $a0
addiu $sp, $sp, 52
lw $ra, -48($sp)
sw $v0, -16($sp)
# PopParam 1;
# t6 = ""
la $a0, str11
sw $a0, -24($sp)
# _whilecondition.916:


_whilecondition.916:
# // get veriable: position
# t8 = t2
lw $a0, -8($sp)
sw $a0, -32($sp)
# // get veriable: num
# t9 = t4
lw $a0, -16($sp)
sw $a0, -36($sp)
# t5 = t8 < t9
lw $a0, -32($sp)
lw $a1, -36($sp)
sge $a0, $a0, $a1
li $a1, 1
sub $a0, $a1, $a0
sw $a0, -20($sp)
# IfZ t5 Goto _endwhile.916
lw $a0, -20($sp)
beqz $a0, _endwhile.916
# // get veriable: temp
# t5 = t6
lw $a0, -24($sp)
sw $a0, -20($sp)
# t9 = t0
lw $a0, 0($sp)
sw $a0, -36($sp)
# // get veriable: position
# t11 = t2
lw $a0, -8($sp)
sw $a0, -44($sp)
# // get method: CellularAutomaton.cell_at_next_evolution
# t10 = *(t9 + 28)
lw $a0, -36($sp)
lw $a1, 112($a0)
sw $a1, -40($sp)
# PushParam t9;
lw $a0, -36($sp)
sw $a0, -52($sp)
# PushParam t11;
lw $a0, -44($sp)
sw $a0, -56($sp)
# t9 = Call t10;
sw $ra, -48($sp)
lw $a0, -40($sp)
addiu $sp, $sp, -52
jalr $ra, $a0
addiu $sp, $sp, 52
lw $ra, -48($sp)
sw $v0, -36($sp)
# PopParam 2;
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -52($sp)
# PushParam t9;
lw $a0, -36($sp)
sw $a0, -56($sp)
# t5 = Call String.concat;
sw $ra, -48($sp)
addiu $sp, $sp, -52
jal String.concat
addiu $sp, $sp, 52
lw $ra, -48($sp)
sw $v0, -20($sp)
# PopParam 2;
# t6 = t5
lw $a0, -20($sp)
sw $a0, -24($sp)
# // get veriable: position
# t8 = t2
lw $a0, -8($sp)
sw $a0, -32($sp)
# t9 = 1
li $a0, 1
sw $a0, -36($sp)
# t5 = t8 + t9
lw $a0, -32($sp)
lw $a1, -36($sp)
add $a0, $a0, $a1
sw $a0, -20($sp)
# t2 = t5
lw $a0, -20($sp)
sw $a0, -8($sp)
# Goto _whilecondition.916
j _whilecondition.916
# _endwhile.916:


_endwhile.916:
# // get veriable: temp
# t5 = t6
lw $a0, -24($sp)
sw $a0, -20($sp)
# *(t0 + 33) = t5
lw $a0, -20($sp)
lw $a1, 0($sp)
sw $a0, 132($a1)
# t5 = t0
lw $a0, 0($sp)
sw $a0, -20($sp)
# Return t1;

lw $v0, -4($sp)
jr $ra
# CellularAutomaton.option:


CellularAutomaton.option:
# PARAM t0;
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\nPlease chose a number:\n"
la $a0, str12
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t1: A cross\n"
la $a0, str13
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t2: A slash from the upper left to lower right\n"
la $a0, str14
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t3: A slash from the upper right to lower left\n"
la $a0, str15
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t4: An X\n"
la $a0, str16
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t5: A greater than sign \n"
la $a0, str17
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t6: A less than sign\n"
la $a0, str18
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t7: Two greater than signs\n"
la $a0, str19
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t8: Two less than signs\n"
la $a0, str20
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t9: A 'V'\n"
la $a0, str21
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t10: An inverse 'V'\n"
la $a0, str22
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t11: Numbers 9 and 10 combined\n"
la $a0, str23
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t12: A full grid\n"
la $a0, str24
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t13: A 'T'\n"
la $a0, str25
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t14: A plus '+'\n"
la $a0, str26
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t15: A 'W'\n"
la $a0, str27
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t16: An 'M'\n"
la $a0, str28
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t17: An 'E'\n"
la $a0, str29
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t18: A '3'\n"
la $a0, str30
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t19: An 'O'\n"
la $a0, str31
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t20: An '8'\n"
la $a0, str32
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\t21: An 'S'\n"
la $a0, str33
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "Your choice => "
la $a0, str34
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# // get method: CellularAutomaton.in_int
# t4 = *(t1 + 9)
lw $a0, -4($sp)
lw $a1, 36($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 1;
# t2 = t1
lw $a0, -4($sp)
sw $a0, -8($sp)
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\n"
la $a0, str7
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 1
li $a0, 1
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1153
lw $a0, -4($sp)
beqz $a0, _else.1153
# t1 = " XX  XXXX XXXX  XX  "
la $a0, str35
sw $a0, -4($sp)
# Goto _endif.1153
j _endif.1153
# _else.1153:


_else.1153:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 2
li $a0, 2
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1161
lw $a0, -4($sp)
beqz $a0, _else.1161
# t1 = "    X   X   X   X   X    "
la $a0, str36
sw $a0, -4($sp)
# Goto _endif.1161
j _endif.1161
# _else.1161:


_else.1161:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 3
li $a0, 3
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1169
lw $a0, -4($sp)
beqz $a0, _else.1169
# t1 = "X     X     X     X     X"
la $a0, str37
sw $a0, -4($sp)
# Goto _endif.1169
j _endif.1169
# _else.1169:


_else.1169:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 4
li $a0, 4
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1177
lw $a0, -4($sp)
beqz $a0, _else.1177
# t1 = "X   X X X   X   X X X   X"
la $a0, str38
sw $a0, -4($sp)
# Goto _endif.1177
j _endif.1177
# _else.1177:


_else.1177:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 5
li $a0, 5
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1185
lw $a0, -4($sp)
beqz $a0, _else.1185
# t1 = "X     X     X   X   X    "
la $a0, str39
sw $a0, -4($sp)
# Goto _endif.1185
j _endif.1185
# _else.1185:


_else.1185:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 6
li $a0, 6
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1193
lw $a0, -4($sp)
beqz $a0, _else.1193
# t1 = "    X   X   X     X     X"
la $a0, str40
sw $a0, -4($sp)
# Goto _endif.1193
j _endif.1193
# _else.1193:


_else.1193:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 7
li $a0, 7
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1201
lw $a0, -4($sp)
beqz $a0, _else.1201
# t1 = "X  X  X  XX  X      "
la $a0, str41
sw $a0, -4($sp)
# Goto _endif.1201
j _endif.1201
# _else.1201:


_else.1201:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 8
li $a0, 8
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1209
lw $a0, -4($sp)
beqz $a0, _else.1209
# t1 = " X  XX  X  X  X     "
la $a0, str42
sw $a0, -4($sp)
# Goto _endif.1209
j _endif.1209
# _else.1209:


_else.1209:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 9
li $a0, 9
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1217
lw $a0, -4($sp)
beqz $a0, _else.1217
# t1 = "X   X X X   X  "
la $a0, str43
sw $a0, -4($sp)
# Goto _endif.1217
j _endif.1217
# _else.1217:


_else.1217:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 10
li $a0, 10
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1225
lw $a0, -4($sp)
beqz $a0, _else.1225
# t1 = "  X   X X X   X"
la $a0, str44
sw $a0, -4($sp)
# Goto _endif.1225
j _endif.1225
# _else.1225:


_else.1225:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 11
li $a0, 11
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1233
lw $a0, -4($sp)
beqz $a0, _else.1233
# t1 = "X X X X X X X X"
la $a0, str45
sw $a0, -4($sp)
# Goto _endif.1233
j _endif.1233
# _else.1233:


_else.1233:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 12
li $a0, 12
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1241
lw $a0, -4($sp)
beqz $a0, _else.1241
# t1 = "XXXXXXXXXXXXXXXXXXXXXXXXX"
la $a0, str46
sw $a0, -4($sp)
# Goto _endif.1241
j _endif.1241
# _else.1241:


_else.1241:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 13
li $a0, 13
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1249
lw $a0, -4($sp)
beqz $a0, _else.1249
# t1 = "XXXXX  X    X    X    X  "
la $a0, str47
sw $a0, -4($sp)
# Goto _endif.1249
j _endif.1249
# _else.1249:


_else.1249:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 14
li $a0, 14
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1257
lw $a0, -4($sp)
beqz $a0, _else.1257
# t1 = "  X    X  XXXXX  X    X  "
la $a0, str48
sw $a0, -4($sp)
# Goto _endif.1257
j _endif.1257
# _else.1257:


_else.1257:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 15
li $a0, 15
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1265
lw $a0, -4($sp)
beqz $a0, _else.1265
# t1 = "X     X X X X   X X  "
la $a0, str49
sw $a0, -4($sp)
# Goto _endif.1265
j _endif.1265
# _else.1265:


_else.1265:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 16
li $a0, 16
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1273
lw $a0, -4($sp)
beqz $a0, _else.1273
# t1 = "  X X   X X X X     X"
la $a0, str50
sw $a0, -4($sp)
# Goto _endif.1273
j _endif.1273
# _else.1273:


_else.1273:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 17
li $a0, 17
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1281
lw $a0, -4($sp)
beqz $a0, _else.1281
# t1 = "XXXXX   X   XXXXX   X   XXXX"
la $a0, str51
sw $a0, -4($sp)
# Goto _endif.1281
j _endif.1281
# _else.1281:


_else.1281:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 18
li $a0, 18
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1289
lw $a0, -4($sp)
beqz $a0, _else.1289
# t1 = "XXX    X   X  X    X   XXXX "
la $a0, str52
sw $a0, -4($sp)
# Goto _endif.1289
j _endif.1289
# _else.1289:


_else.1289:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 19
li $a0, 19
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1297
lw $a0, -4($sp)
beqz $a0, _else.1297
# t1 = " XX X  XX  X XX "
la $a0, str53
sw $a0, -4($sp)
# Goto _endif.1297
j _endif.1297
# _else.1297:


_else.1297:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 20
li $a0, 20
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1305
lw $a0, -4($sp)
beqz $a0, _else.1305
# t1 = " XX X  XX  X XX X  XX  X XX "
la $a0, str54
sw $a0, -4($sp)
# Goto _endif.1305
j _endif.1305
# _else.1305:


_else.1305:
# // get veriable: num
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = 21
li $a0, 21
sw $a0, -20($sp)
# t1 = t4 = t5
lw $a0, -16($sp)
lw $a1, -20($sp)
seq $a0, $a0, $a1
sw $a0, -4($sp)
# IfZ t1 Goto _else.1313
lw $a0, -4($sp)
beqz $a0, _else.1313
# t1 = " XXXX   X    XX    X   XXXX "
la $a0, str55
sw $a0, -4($sp)
# Goto _endif.1313
j _endif.1313
# _else.1313:


_else.1313:
# t1 = "                         "
la $a0, str56
sw $a0, -4($sp)
# _endif.1313:


_endif.1313:
# _endif.1305:


_endif.1305:
# _endif.1297:


_endif.1297:
# _endif.1289:


_endif.1289:
# _endif.1281:


_endif.1281:
# _endif.1273:


_endif.1273:
# _endif.1265:


_endif.1265:
# _endif.1257:


_endif.1257:
# _endif.1249:


_endif.1249:
# _endif.1241:


_endif.1241:
# _endif.1233:


_endif.1233:
# _endif.1225:


_endif.1225:
# _endif.1217:


_endif.1217:
# _endif.1209:


_endif.1209:
# _endif.1201:


_endif.1201:
# _endif.1193:


_endif.1193:
# _endif.1185:


_endif.1185:
# _endif.1177:


_endif.1177:
# _endif.1169:


_endif.1169:
# _endif.1161:


_endif.1161:
# _endif.1153:


_endif.1153:
# Return t1;

lw $v0, -4($sp)
jr $ra
# CellularAutomaton.prompt:


CellularAutomaton.prompt:
# PARAM t0;
# t2 = ""
la $a0, str11
sw $a0, -8($sp)
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "Would you like to continue with the next generation? \n"
la $a0, str57
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "Please use lowercase y or n for your answer [y]: "
la $a0, str58
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# // get method: CellularAutomaton.in_string
# t4 = *(t1 + 8)
lw $a0, -4($sp)
lw $a1, 32($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 1;
# t2 = t1
lw $a0, -4($sp)
sw $a0, -8($sp)
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\n"
la $a0, str7
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# // get veriable: ans
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = "n"
la $a0, str59
sw $a0, -20($sp)
# t1 = t4 =:= t5
lw $a0, -16($sp)
lw $a1, -20($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -4($sp)
# IfZ t1 Goto _else.1378
lw $a0, -4($sp)
beqz $a0, _else.1378
# t1 = 0
li $a0, 0
sw $a0, -4($sp)
# Goto _endif.1378
j _endif.1378
# _else.1378:


_else.1378:
# t1 = 1
li $a0, 1
sw $a0, -4($sp)
# _endif.1378:


_endif.1378:
# Return t1;

lw $v0, -4($sp)
jr $ra
# CellularAutomaton.prompt2:


CellularAutomaton.prompt2:
# PARAM t0;
# t2 = ""
la $a0, str11
sw $a0, -8($sp)
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "\n\n"
la $a0, str60
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "Would you like to choose a background pattern? \n"
la $a0, str61
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# t5 = "Please use lowercase y or n for your answer [n]: "
la $a0, str62
sw $a0, -20($sp)
# // get method: CellularAutomaton.out_string
# t4 = *(t1 + 6)
lw $a0, -4($sp)
lw $a1, 24($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# PushParam t5;
lw $a0, -20($sp)
sw $a0, -32($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 2;
# t1 = t0
lw $a0, 0($sp)
sw $a0, -4($sp)
# // get method: CellularAutomaton.in_string
# t4 = *(t1 + 8)
lw $a0, -4($sp)
lw $a1, 32($a0)
sw $a1, -16($sp)
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -28($sp)
# t1 = Call t4;
sw $ra, -24($sp)
lw $a0, -16($sp)
addiu $sp, $sp, -28
jalr $ra, $a0
addiu $sp, $sp, 28
lw $ra, -24($sp)
sw $v0, -4($sp)
# PopParam 1;
# t2 = t1
lw $a0, -4($sp)
sw $a0, -8($sp)
# // get veriable: ans
# t4 = t2
lw $a0, -8($sp)
sw $a0, -16($sp)
# t5 = "y"
la $a0, str63
sw $a0, -20($sp)
# t1 = t4 =:= t5
lw $a0, -16($sp)
lw $a1, -20($sp)
move $v1, $ra
jal _stringcmp
move $ra, $v1
move $a0, $v0
sw $a0, -4($sp)
# IfZ t1 Goto _else.1423
lw $a0, -4($sp)
beqz $a0, _else.1423
# t1 = 1
li $a0, 1
sw $a0, -4($sp)
# Goto _endif.1423
j _endif.1423
# _else.1423:


_else.1423:
# t1 = 0
li $a0, 0
sw $a0, -4($sp)
# _endif.1423:


_endif.1423:
# Return t1;

lw $v0, -4($sp)
jr $ra
# CellularAutomaton.constructor:


CellularAutomaton.constructor:
# PARAM t0;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -12($sp)
# Call Board.constructor;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Board.constructor
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
# // set method: CellularAutomaton.init
# *(t0 + 15) = Label "CellularAutomaton.init"
la $a0, CellularAutomaton.init
lw $a1, 0($sp)
sw $a0, 60($a1)
# // set method: CellularAutomaton.print
# *(t0 + 16) = Label "CellularAutomaton.print"
la $a0, CellularAutomaton.print
lw $a1, 0($sp)
sw $a0, 64($a1)
# // set method: CellularAutomaton.num_cells
# *(t0 + 17) = Label "CellularAutomaton.num_cells"
la $a0, CellularAutomaton.num_cells
lw $a1, 0($sp)
sw $a0, 68($a1)
# // set method: CellularAutomaton.cell
# *(t0 + 18) = Label "CellularAutomaton.cell"
la $a0, CellularAutomaton.cell
lw $a1, 0($sp)
sw $a0, 72($a1)
# // set method: CellularAutomaton.north
# *(t0 + 19) = Label "CellularAutomaton.north"
la $a0, CellularAutomaton.north
lw $a1, 0($sp)
sw $a0, 76($a1)
# // set method: CellularAutomaton.south
# *(t0 + 20) = Label "CellularAutomaton.south"
la $a0, CellularAutomaton.south
lw $a1, 0($sp)
sw $a0, 80($a1)
# // set method: CellularAutomaton.east
# *(t0 + 21) = Label "CellularAutomaton.east"
la $a0, CellularAutomaton.east
lw $a1, 0($sp)
sw $a0, 84($a1)
# // set method: CellularAutomaton.west
# *(t0 + 22) = Label "CellularAutomaton.west"
la $a0, CellularAutomaton.west
lw $a1, 0($sp)
sw $a0, 88($a1)
# // set method: CellularAutomaton.northwest
# *(t0 + 23) = Label "CellularAutomaton.northwest"
la $a0, CellularAutomaton.northwest
lw $a1, 0($sp)
sw $a0, 92($a1)
# // set method: CellularAutomaton.northeast
# *(t0 + 24) = Label "CellularAutomaton.northeast"
la $a0, CellularAutomaton.northeast
lw $a1, 0($sp)
sw $a0, 96($a1)
# // set method: CellularAutomaton.southeast
# *(t0 + 25) = Label "CellularAutomaton.southeast"
la $a0, CellularAutomaton.southeast
lw $a1, 0($sp)
sw $a0, 100($a1)
# // set method: CellularAutomaton.southwest
# *(t0 + 26) = Label "CellularAutomaton.southwest"
la $a0, CellularAutomaton.southwest
lw $a1, 0($sp)
sw $a0, 104($a1)
# // set method: CellularAutomaton.neighbors
# *(t0 + 27) = Label "CellularAutomaton.neighbors"
la $a0, CellularAutomaton.neighbors
lw $a1, 0($sp)
sw $a0, 108($a1)
# // set method: CellularAutomaton.cell_at_next_evolution
# *(t0 + 28) = Label "CellularAutomaton.cell_at_next_evolution"
la $a0, CellularAutomaton.cell_at_next_evolution
lw $a1, 0($sp)
sw $a0, 112($a1)
# // set method: CellularAutomaton.evolve
# *(t0 + 29) = Label "CellularAutomaton.evolve"
la $a0, CellularAutomaton.evolve
lw $a1, 0($sp)
sw $a0, 116($a1)
# // set method: CellularAutomaton.option
# *(t0 + 30) = Label "CellularAutomaton.option"
la $a0, CellularAutomaton.option
lw $a1, 0($sp)
sw $a0, 120($a1)
# // set method: CellularAutomaton.prompt
# *(t0 + 31) = Label "CellularAutomaton.prompt"
la $a0, CellularAutomaton.prompt
lw $a1, 0($sp)
sw $a0, 124($a1)
# // set method: CellularAutomaton.prompt2
# *(t0 + 32) = Label "CellularAutomaton.prompt2"
la $a0, CellularAutomaton.prompt2
lw $a1, 0($sp)
sw $a0, 128($a1)
# t1 = ""
la $a0, str11
sw $a0, -4($sp)
# // set attribute: population_map
# *(t0 + 33) = t1
lw $a0, -4($sp)
lw $a1, 0($sp)
sw $a0, 132($a1)
# // set class name: CellularAutomaton
# *(t0 + 0) = "CellularAutomaton"
la $a0, str6
lw $a1, 0($sp)
sw $a0, 0($a1)
# // set class size: 34 words
# *(t0 + 1) = 34
lw $a0, 0($sp)
li $a1, 34
sw $a1, 4($a0)
# // set class generation label
# *(t0 + 2) = Label "_class.CellularAutomaton"
la $a0, _class.CellularAutomaton
lw $a1, 0($sp)
sw $a0, 8($a1)
# Return ;

lw $v0, 4($sp)
jr $ra
# _class.Main: _class.CellularAutomaton
# Main.main:


Main.main:
# PARAM t0;
# t2 = 0
li $a0, 0
sw $a0, -8($sp)
# t4 = ""
la $a0, str11
sw $a0, -16($sp)
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# t7 = "Welcome to the Game of Life.\n"
la $a0, str65
sw $a0, -28($sp)
# // get method: Main.out_string
# t6 = *(t3 + 6)
lw $a0, -12($sp)
lw $a1, 24($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -40($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 2;
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# t7 = "There are many initial states to choose from. \n"
la $a0, str66
sw $a0, -28($sp)
# // get method: Main.out_string
# t6 = *(t3 + 6)
lw $a0, -12($sp)
lw $a1, 24($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -40($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 2;
# _whilecondition.1506:


_whilecondition.1506:
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get method: Main.prompt2
# t6 = *(t3 + 32)
lw $a0, -12($sp)
lw $a1, 128($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 1;
# IfZ t3 Goto _endwhile.1506
lw $a0, -12($sp)
beqz $a0, _endwhile.1506
# t3 = 1
li $a0, 1
sw $a0, -12($sp)
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get method: Main.option
# t6 = *(t3 + 30)
lw $a0, -12($sp)
lw $a1, 120($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 1;
# t4 = t3
lw $a0, -12($sp)
sw $a0, -16($sp)
# t3 = Alloc 34;
# Begin Allocate
li $v0, 9
li $a0, 136
syscall
sw $v0, -12($sp)
# End Allocate
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# Call CellularAutomaton.constructor;
sw $ra, -32($sp)
addiu $sp, $sp, -36
jal CellularAutomaton.constructor
addiu $sp, $sp, 36
lw $ra, -32($sp)
# PopParam 1;
# // get veriable: choice
# t7 = t4
lw $a0, -16($sp)
sw $a0, -28($sp)
# // get method: CellularAutomaton.init
# t6 = *(t3 + 15)
lw $a0, -12($sp)
lw $a1, 60($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# PushParam t7;
lw $a0, -28($sp)
sw $a0, -40($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 2;
# *(t0 + 35) = t3
lw $a0, -12($sp)
lw $a1, 0($sp)
sw $a0, 140($a1)
# // get attribute: Main.cells
# t3 = *(t0 + 35)
lw $a0, 0($sp)
lw $a1, 140($a0)
sw $a1, -12($sp)
# // get method: CellularAutomaton.print
# t6 = *(t3 + 16)
lw $a0, -12($sp)
lw $a1, 64($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 1;
# _whilecondition.1543:


_whilecondition.1543:
# // get veriable: continue
# t3 = t2
lw $a0, -8($sp)
sw $a0, -12($sp)
# IfZ t3 Goto _endwhile.1543
lw $a0, -12($sp)
beqz $a0, _endwhile.1543
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# // get method: Main.prompt
# t6 = *(t3 + 31)
lw $a0, -12($sp)
lw $a1, 124($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 1;
# IfZ t3 Goto _else.1547
lw $a0, -12($sp)
beqz $a0, _else.1547
# // get attribute: Main.cells
# t3 = *(t0 + 35)
lw $a0, 0($sp)
lw $a1, 140($a0)
sw $a1, -12($sp)
# // get method: CellularAutomaton.evolve
# t6 = *(t3 + 29)
lw $a0, -12($sp)
lw $a1, 116($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 1;
# // get attribute: Main.cells
# t3 = *(t0 + 35)
lw $a0, 0($sp)
lw $a1, 140($a0)
sw $a1, -12($sp)
# // get method: CellularAutomaton.print
# t6 = *(t3 + 16)
lw $a0, -12($sp)
lw $a1, 64($a0)
sw $a1, -24($sp)
# PushParam t3;
lw $a0, -12($sp)
sw $a0, -36($sp)
# t3 = Call t6;
sw $ra, -32($sp)
lw $a0, -24($sp)
addiu $sp, $sp, -36
jalr $ra, $a0
addiu $sp, $sp, 36
lw $ra, -32($sp)
sw $v0, -12($sp)
# PopParam 1;
# Goto _endif.1547
j _endif.1547
# _else.1547:


_else.1547:
# t3 = 0
li $a0, 0
sw $a0, -12($sp)
# t2 = t3
lw $a0, -12($sp)
sw $a0, -8($sp)
# _endif.1547:


_endif.1547:
# Goto _whilecondition.1543
j _whilecondition.1543
# _endwhile.1543:


_endwhile.1543:
# Goto _whilecondition.1506
j _whilecondition.1506
# _endwhile.1506:


_endwhile.1506:
# t3 = t0
lw $a0, 0($sp)
sw $a0, -12($sp)
# Return t1;

lw $v0, -4($sp)
jr $ra
# Main.constructor:


Main.constructor:
# PARAM t0;
# PushParam t0;
lw $a0, 0($sp)
sw $a0, -8($sp)
# Call CellularAutomaton.constructor;
sw $ra, -4($sp)
addiu $sp, $sp, -8
jal CellularAutomaton.constructor
addiu $sp, $sp, 8
lw $ra, -4($sp)
# PopParam 1;
# // set method: Main.main
# *(t0 + 34) = Label "Main.main"
la $a0, Main.main
lw $a1, 0($sp)
sw $a0, 136($a1)
# t1 = NULL;
sw $zero, -4($sp)
# // set attribute: cells
# *(t0 + 35) = t1
lw $a0, -4($sp)
lw $a1, 0($sp)
sw $a0, 140($a1)
# // set class name: Main
# *(t0 + 0) = "Main"
la $a0, str64
lw $a1, 0($sp)
sw $a0, 0($a1)
# // set class size: 36 words
# *(t0 + 1) = 36
lw $a0, 0($sp)
li $a1, 36
sw $a1, 4($a0)
# // set class generation label
# *(t0 + 2) = Label "_class.Main"
la $a0, _class.Main
lw $a1, 0($sp)
sw $a0, 8($a1)
# Return ;

lw $v0, 4($sp)
jr $ra
# start:


start:
# t1 = Alloc 36;
# Begin Allocate
li $v0, 9
li $a0, 144
syscall
sw $v0, -4($sp)
# End Allocate
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# Call Main.constructor;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Main.constructor
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
# PushParam t1;
lw $a0, -4($sp)
sw $a0, -12($sp)
# Call Main.main;
sw $ra, -8($sp)
addiu $sp, $sp, -12
jal Main.main
addiu $sp, $sp, 12
lw $ra, -8($sp)
# PopParam 1;
li $v0, 10
syscall
