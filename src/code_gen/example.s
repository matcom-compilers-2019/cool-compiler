.data
item:
.word A
.word B

.text
.globl main

main: 
li $t0, 5
li $t1, 6
j item

A:
li $t5, 10

B:
li $t6 20