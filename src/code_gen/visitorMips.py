from code_gen import il_nodes as il
import visitor

# Register constants
SP = '$sp' #stack pointer
FP = '$fp' #frame pointer
RA = '$ra' #return address
V0 = '$v0' #used for output and to return values from functions
A0 = '$a0'
T0 = '$t0' #temporaries  
T1 = '$t1'



class MIPS:
    def __init__(self, nodes):
        self.code = []
    

    @visitor.when(il.BinOpIL)
    def visit(self, node):
        self.code.append("lw $a0, {}($sp)".format(4 * node.leftop))
        self.code.append("lw $a1, {}($sp)".format(4 * node.rightop))
        if node.symb == '<':
            self.code.append("li $a2, 1")
            self.code.append("add $a0, $a0, $a2")
            self.code.append("sge $a0, $a1, $a0")
        elif node.symb == '=':
            self.code.append("seq $a0, $a0, $a1")
        elif node.symb == '<=':
            self.code.append("sge $a0, $a1, $a0")
        elif node.symb == '>':
            self.code.append("li $a2, 1")
            self.code.append("add $a1, $a1, $a2")
            self.code.append("sge $a0, $a0, $a1")
        elif node.symb == '>=':
            self.code.append("sge $a0, $a0, $a1")
        elif node.symb =='+':
            self.code.append("add $a0, $a0, $a1")
        elif node.symb == '-':
            self.code.append("sub $a0, $a0, $a1")
        elif node.symb == '*':
            self.code.append("mult $a0, $a1")
            self.code.append("mflo $a0")
        elif node.symb == '/'
            self.code.append("div $a0, $a1")
            self.code.append("mflo $a0")
        self.code.append("sw $a0, {}($sp)".format(4 * node.var))

    @visitor.when(il.UnaryOpIL)
    def visit(self, node):
        self.code.append("lw $a0, {}($sp)".format(4 * node.op))
        if node.symb == '~':
            self.code.append("not $a0, $a0")
        elif node.symb == '!':
            self.code.append("li $a1, 1")
            self.code.append("sub $a0, a1, $a0")
        self.code.append("sw $a0, {}($sp)".format(4 * node.var))

    @visitor.when(il.VarToVarIL)
    def visit(self, node):
        self.code.append("lw $a0, {}($sp)".format(4 * node.right))
        self.code.append("sw $a0, {}($sp)".format(4 * node.left))

    #----------VER OTRAS ASIGNACIONES----------------
    # @visitor.when(il.MemoToVarIL)
    # def visit(self, node):
    #     self.code.append("lw $a0, {}($sp)")

    @visitor.when(il.AllocateIL)
    def visit(self, node):
        self.code.append("li $v0, 9")
        self.code.append("li $a0, {}".format(4 * node.size))
        self.code.append("syscall")
        self.code.append("sw $v0, {}($sp)".format(4 * node.var))
    
    #-----------VER DIFERENCIACION LABEL_FUNCION, LABEL----
    @visitor.when(il.LabelIL)
    def visit(self, node):
        self.code.append("{}:".fromat(node.label))

    #-----------FALTA VER BIEN FUNCIONALIDAD DE ESTE NODO--
    # @visitor.when(il.PushVarIL)
    # def visit(self, node):
    #     self.code.append("lw $a0, {}($sp)".format(node.value))
    #     self.code.append("sw $a0, {}($sp)".format(node.arg))
    
    @visitor.when(il.GotoIL)
    def visit(self, node):
        self.code.append("j {}".format(node.label))

    @visitor.when(il.IfJumpIL)
    def visit(self, node):
        self.code.append("lw $a0, {}($sp)".format(node.var))
        self.code.append("beqz $a0, {}($sp)".format(node.label))


