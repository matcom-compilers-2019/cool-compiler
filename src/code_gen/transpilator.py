import sys
sys.path.append('/..')
from il_nodes import *
from parsing import cool_ast as ast
from virtual_table import virtual_table, Variables

generate = generator()


#visitors
class typeCollector:
    def __init__(self):
        self.types = {}

    

class codeVisitor:

    def __init__(self):
        self.code = []

    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node):
        pass

    @visitor.when(ast.ClassListNode)
    def visit(self):
        pass

    @visitor.when(ast.ClassNode)
    def visit(self, node):
        pass

    @visitor.when(ast.AttributeNode)
    def visit(self):
        pass

    @visitor.when(ast.MethodNode)
    def visit(self, node):
        
        code.append(LabelIL()) # Necesita tener la clase a traves de la cual se llama al metodo
        variables = Variables()

        for p in node.params.reverse:
            variables.add_var(p.name)

        self.visit(node.body, variables)    
    
    
    @visitor.when(ast.BlockNode)
    def visit(self, node, variables):
        for e in node.exprs:
            self.visit(e, variables)

    
   
    def bin_op(self, node, variables : Variables, sym : str):
        p = variables.peek_last()
        l = variables.add_temp()
        self.visit(node.left)
        r = variables.add_temp()
        self.visit(node.right)  
        variables.pop_temp() # if stack is (sp - dir)
        variables.pop_temp()
        code.append(BinOpIL(p, l, r, sym))
        # cleaning goes here if stack is (sp + dir)
        
    @visitor.when(ast.LessNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '<')

    @visitor.when(ast.EqualNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '=')

    @visitor.when(ast.LeqNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '<=')

    @visitor.when(ast.GNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '>')

    @visitor.when(ast.GeNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '>=')
    
    @visitor.when(ast.SumNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '+')
    
    @visitor.when(ast.SubNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '-')

    @visitor.when(ast.TimesNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '*')

    @visitor.when(ast.DivNode)
    def visit(self, node, variables):
        self.bin_op(node, variables, '/')

    def unary_op(self, node, variables : Variables , symb : str):
        p = variables.peek_last()
        l = variables.add_temp()
        self.visit(node.expr)
        variables.pop_temp()
        code.append(UnaryOpIL(p, l, symb))


    @visitor.when(ast.OpositeNode)
    def visit(self, node, variables):
        unary_op(node, variables, '~')

    @visitor.when(ast.NotNode)
    def visit(self, node):
        unary_op(node, Variables, '!')

    @visitor.when(ast.LetNode)
    def visit(self, node):
        pass

    
    @visitor.when(ast.AssignationNode)
    def visit(self, node):
        pass

    @visitor.when(ast.BoolNode)
    def visit(self, node, variables):
        p = variables.peek_last()
        code.append(VarToMemoIL())

    @visitor.when(ast.StrtingNode)
    def visit(self, node):
        pass

    @visitor.when(ast.VarNode)
    def visit(self, node):
        pass

    @visitor.when(ast.DeclarationNode)
    def visit(self, node):
        pass

    @visitor.when(ast.NewNode)
    def visit(self, node):
        pass

    @visitor.when(ast.LoopNode)
    def visit(self, node):
        pass

    @visitor.when(ast.ConditionalNode)
    def visit(self, node):
        pass

    @visitor.when(ast.ShortDispatchNode)
    def visit(self, node):
        pass


    @visitor.when(ast.PointDispatchNode)
    def visit(self, node):
        pass

    @visitor.when(ast.ParentDispatchNode)
    def visit(self, node):
        pass

    @visitor.when(ast.CaseNode)
    def visit(self, node):
        pass

    @visitor.when(ast.VoidNode)
    def visit(self, node):
        pass


def start():
    pass

if __name__ == '__main__':
    start()