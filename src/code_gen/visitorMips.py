from code_gen import il_nodes as il
import visitor


class MIPS:
    def __init__(self, nodes_text, nodes_data):
        self.code_text = []
        self.code_data = []
        self.nodes_text = nodes_text
        self.nodes_data = nodes_data
    
    def generate(self):
        code_gen = ""
    
        for node in nodes_data:
            self.visit(node)
        for code in code_data:
            code_gen += (code + "\n")

        code_gen += open('staticMipsCode.s')

        for node in nodes_text:
            self.visit(node)
        for code in code_text:
            code_gen += (code + "\n")
        
        return code_gen

    @visitor.when(il.StringIL)
    def visit(self, node):
        self.code_data.append("{}: .asciiz \"{}\"".format(node.label, node.string))

    @visitor.when(il.HierarchyIL)
    def visit(self, node):
        self.code_data.append("{}:".format(node.parent))
        self.code_data.append(".word {}".format(node.child))

    @visit.when(il.VirtualTableIL)
    def visit(self, node):
        self.code_data.append("{}VT:".format(node.name))
        self.code_data.append(".word {}".format(node.name))
        for m in node.methods:
            self.code_data.append(".word {}".format(m))


    @visitor.when(il.BinOpIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.leftop))
        self.code_text.append("lw $a1, {}($sp)".format(-4 * node.rightop))
        if node.symb == '<':
            self.code_text.append("li $a2, 1")
            self.code_text.append("add $a0, $a0, $a2")
            self.code_text.append("sge $a0, $a1, $a0")
        elif node.symb == '=':
            self.code_text.append("seq $a0, $a0, $a1")
        elif node.symb == '<=':
            self.code_text.append("sge $a0, $a1, $a0")
        elif node.symb == '>':
            self.code_text.append("li $a2, 1")
            self.code_text.append("add $a1, $a1, $a2")
            self.code_text.append("sge $a0, $a0, $a1")
        elif node.symb == '>=':
            self.code_text.append("sge $a0, $a0, $a1")
        elif node.symb =='+':
            self.code_text.append("add $a0, $a0, $a1")
        elif node.symb == '-':
            self.code_text.append("sub $a0, $a0, $a1")
        elif node.symb == '*':
            self.code_text.append("mult $a0, $a1")
            self.code_text.append("mflo $a0")
        elif node.symb == '/'
            self.code_text.append("div $a0, $a1")
            self.code_text.append("mflo $a0")
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.var))

    @visitor.when(il.UnaryOpIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.op))
        if node.symb == '~':
            self.code_text.append("not $a0, $a0")
        elif node.symb == '!':
            self.code_text.append("li $a1, 1")
            self.code_text.append("sub $a0, $a1, $a0")
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.var))
    
    #--------ASIGNACIONES----------------------------

    @visitor.when(il.VarToVarIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.right))
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.left))

    @visitor.when(il.MemoToVarIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.right))
        self.code_text.append("lw $a1, {}($a0)".format(4 * node.offset))
        self.code_text.append("sw $a1, {}($sp)".format(-4 * node.left))
    
    @visitor.when(il.VarToMemoIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.right))
        self.code_text.append("lw $a1, {}($sp)".format(-4 * node.left))
        self.code_text.append("sw $a0, {}($a1)".format(4 * node.offset))
    
    @visitor.when(il.CteToMemoIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.left))
        self.code_text.append("li $a1, {}".format(node.right))
        self.code_text.append("sw $a1, {}($a0)".format(node.offset * 4))

    @visitor.when(il.AllocateIL)
    def visit(self, node):
        self.code_text.append("li $v0, 9")
        self.code_text.append("li $a0, {}".format(4 * node.size))
        self.code_text.append("syscall")
        self.code_text.append("sw $v0, {}($sp)".format(-4 * node.var))
        self.code_text.append("sw ")
    
    @visitor.when(il.LabelIL)
    def visit(self, node):
        self.code_text.append("{}:".format(node.label))
        if node.func:
            self.code_text.append("sw $ra, ($sp)")
    
    @visitor.when(il.GotoIL)
    def visit(self, node):
        self.code_text.append("j {}".format(node.label))

    @visitor.when(il.IfJumpIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(-4*node.var))
        self.code_text.append("beqz $a0, {}".format(node.label))
    
    @visitor.when(il.PopIL)
    def visit(self, node):
        self.code_text.append("addiu $sp, $sp, {}".format(-4 * node.cant))

    @visitor.when(il.PushIL)
    def visit(self, node):
        self.code_text.append("li $a0, {}".format(node.val))
        self.code_text.append("sw $a0, ($sp)")
        self.code_text.append("addiu $sp, $sp, 4")
    
    @visitor.when(il.ReturnIL)
    def visit(self, node):
        self.code_text.append("lw $ra, ($sp)")
        self.code_text.append("addiu $sp, $sp, -4")
        self.code_text.append("jr $ra")

    #de aqui en adelante hay que revisarlos
    @visitor.when(il.DispatchIL)
    def visit(self, node):
        #node.offset node.object
        self.code_text.append("lw $a0, {}($sp)".format(4 * node.obj))
        self.code_text.append("addiu $a0, $a0, {}".format(4 * node.offset))
        self.code_text.append("lw $v0, ($a0)")
        self.code_text.append("jalr $ra, $a0")
        

    @visitor.when(il.DispatchParentIL)
    def visit(self, node):
        #node.offset node.object
        self.code_text.append("lw $a0, {}($sp)".format(4 * node.obj))
        self.code_text.append("lw $a0, ($a0)")
        self.code_text.append("li $a1, {}".format(4 * node.offset))
        self.code_text.append("add $a0, $a0, $a1")
        self.code_text.append("lw $a0, ($a0)")
        self.code_text.append("jalr $ra, $a0")

    @visitor.when(il.InheritIL)
    def visit(self, node):
        self.code_text.append("lw $a0, {}($sp)".format(4 * node.child))

        self.code_text.append("la $a1, {}".format(node.labelParent))
        self.code_text.append("la $t0, inherit")
        self.code_text.append("jalr $ra, $t0")
