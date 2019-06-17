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

        code_gen += ".data\n"
        code_gen += "buffer:\n.space 65536\n"
        code_gen += "strsubstrexception: .asciiz \"{}\"\n".format("Substring index exception\n")
        code_gen += "\n"
    
        for node in self.nodes_data:
            self.visit(node)

        for code in self.code_data:
            code_gen += (code + "\n")
        
        code_gen += "\n.globl main\n"
        code_gen += ".text\n"

        fl = open('code_gen\staticMipsCode.s')

        code_gen += fl.read()

        for node in self.nodes_text:
            self.visit(node)

        for code in self.code_text:
            code_gen += (code + "\n")
        
        code_gen += "li $v0, 10\n"
        code_gen += "syscall\n"
        
        return code_gen
    
    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(il.StringIL)
    def visit(self, node):
        self.code_data.append("#String")
        self.code_data.append("{}: .asciiz {}".format(node.label, node.string) )
        self.code_data.append("\n")

    @visitor.when(il.HierarchyIL)
    def visit(self, node):
        self.code_data.append("#Hierachy")
        self.code_data.append("{}_INH:".format(node.node))
        self.code_data.append(".word {}_INH".format(node.parent))
        self.code_data.append("\n")

    @visitor.when(il.VirtualTableIL)
    def visit(self, node):
        self.code_data.append("#Virtual_Table")
        self.code_data.append("{}_VT:".format(node.name))
        self.code_data.append(".word {}_INH".format(node.name))
        for m in node.methods:
            self.code_data.append(".word {}".format(m))
        self.code_data.append("\n")

    @visitor.when(il.LoadLabelIL)
    def visit(self, node):
        self.code_text.append("#Load_Label")
        self.code_text.append("la $a0, {}".format(node.label))
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.var))
        self.code_text.append("\n")

    @visitor.when(il.BinOpIL)
    def visit(self, node):
        self.code_text.append("#BinOP")
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
        elif node.symb == '/':
            self.code_text.append("div $a0, $a1")
            self.code_text.append("mflo $a0")
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.var))
        self.code_text.append("\n")

    @visitor.when(il.UnaryOpIL)
    def visit(self, node):
        self.code_text.append("#UnOP")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.op))
        if node.symb == '~':
            self.code_text.append("not $a0, $a0")
        elif node.symb == '!':
            self.code_text.append("li $a1, 1")
            self.code_text.append("sub $a0, $a1, $a0")
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.var))
        self.code_text.append("\n")
    
    #--------ASIGNACIONES----------------------------

    @visitor.when(il.VarToVarIL)
    def visit(self, node):
        self.code_text.append("#VarToVar")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.right))
        self.code_text.append("sw $a0, {}($sp)".format(-4 * node.left))
        self.code_text.append("\n")

    @visitor.when(il.MemoToVarIL)
    def visit(self, node):
        self.code_text.append("#MemoToVar")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.right))
        self.code_text.append("lw $a1, {}($a0)".format(4 * node.offset))
        self.code_text.append("sw $a1, {}($sp)".format(-4 * node.left))
        self.code_text.append("\n")
    
    @visitor.when(il.VarToMemoIL)
    def visit(self, node):
        self.code_text.append("#VarToMemo")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.right))
        self.code_text.append("lw $a1, {}($sp)".format(-4 * node.left))
        self.code_text.append("sw $a0, {}($a1)".format(4 * node.offset))
        self.code_text.append("\n")
    
    @visitor.when(il.CteToMemoIL)
    def visit(self, node):
        self.code_text.append("#CteToMemo")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.left))
        self.code_text.append("li $a1, {}".format(node.right))
        self.code_text.append("sw $a1, {}($a0)".format(node.offset * 4))
        self.code_text.append("\n")

    @visitor.when(il.AllocateIL)
    def visit(self, node):
        self.code_text.append("#Allocate")
        self.code_text.append("li $v0, 9")
        self.code_text.append("li $a0, {}".format(4 * node.size))
        self.code_text.append("syscall")
        self.code_text.append("sw $v0, {}($sp)".format(-4 * node.var))
        self.code_text.append("la $a1, {}_VT".format(node.typ))
        self.code_text.append("sw $a1, ($v0)")
        self.code_text.append("\n")
    
    @visitor.when(il.LabelIL)
    def visit(self, node):
        self.code_text.append("#Label")
        self.code_text.append("{}:".format(node.label))
        if node.func:
            self.code_text.append("sw $ra, ($sp)")
            self.code_text.append("addiu $sp, $sp, 4")
        self.code_text.append("\n")
    
    @visitor.when(il.GotoIL)
    def visit(self, node):
        self.code_text.append("#Goto")
        self.code_text.append("j {}".format(node.label))
        self.code_text.append("\n")

    @visitor.when(il.IfJumpIL)
    def visit(self, node):
        self.code_text.append("#IfJumpIL")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.var))
        self.code_text.append("bnez $a0, {}".format(node.label))
        self.code_text.append("\n")
    
    @visitor.when(il.PopIL)
    def visit(self, node):
        self.code_text.append("#Pop")
        self.code_text.append("addiu $sp, $sp, {}".format(-4 * node.cant))
        self.code_text.append("\n")

    @visitor.when(il.PushIL)
    def visit(self, node):
        self.code_text.append("#Push")
        self.code_text.append("li $a0, {}".format(node.val))
        self.code_text.append("sw $a0, ($sp)")
        self.code_text.append("addiu $sp, $sp, 4")
        self.code_text.append("\n")
    
    @visitor.when(il.ReturnIL)
    def visit(self, node):
        self.code_text.append("#Return")
        self.code_text.append("lw $v0, {}($sp)".format(-4))
        self.code_text.append("addiu $sp, $sp, -4")
        self.code_text.append("lw $ra, {}($sp)".format(-4))
        self.code_text.append("addiu $sp, $sp, -4")
        self.code_text.append("jr $ra")
        self.code_text.append("\n")

    @visitor.when(il.DispatchIL)
    def visit(self, node):
        #node.offset node.object node.res
        self.code_text.append("#Dispatch")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.obj))
        self.code_text.append("lw $a0, ($a0)")
        self.code_text.append("addiu $a0, $a0, {}".format(4 * node.offset))
        self.code_text.append("lw $v0, ($a0)")
        self.code_text.append("jalr $ra, $v0")
        self.code_text.append("sw $v0, {}($sp)".format(-4 * node.res))
        self.code_text.append("\n")
    
    
    @visitor.when(il.CommentIL)
    def visit(self, node):
        pass


    @visitor.when(il.DispatchParentIL)
    def visit(self, node):
        #node.label node.obj node.res
        self.code_text.append("#DispatchParent")
        self.code_text.append("la $v0, {}".format(node.method))
        self.code_text.append("jalr $ra, $v0")
        self.code_text.append("sw $v0, {}($sp)".format(-4 * node.res))
        self.code_text.append("\n")

    @visitor.when(il.InheritIL)
    def visit(self, node):
        self.code_text.append("#Inherit")
        self.code_text.append("lw $a0, {}($sp)".format(-4 * node.child))
        self.code_text.append("la $a1, {}".format(node.labelParent))
        self.code_text.append("la $t0, inherit")
        self.code_text.append("jalr $ra, $t0")
        self.code_text.append("sw $v0, {}($sp)".format(-4 * node.res))
        self.code_text.append("\n")

    @visitor.when(il.PrintIL)
    def visit(self, node):
        self.code_text.append("#Print")
        if node.string:
            self.code_text.append("la $t0, _out_string")
        else:
            self.code_text.append("la $t0, _out_in")
        self.code_text.append("jalr $ra, $t0")
        self.code_text.append("\n")
