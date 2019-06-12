import sys
sys.path.append('/..')
from code_gen.il_nodes import *
from parsing import cool_ast as ast
from code_gen.virtual_table import virtual_table, Variables
import visitor



class codeVisitor:

    def __init__(self):
        self.code = []
        self.data = []
        self.cur_class = 'Main'
        self.intGen = 0
        self.vt = virtual_table()

    def getInt(self):
        self.intGen += 1
        return str(self.intGen)

    def collectTypes(self, class_list):

        types = {'Obejct' : None, 'IO' : 'Object', 'Int' : 'Object', 'Bool' : 'Object', 'String' : 'Object'}
        methods = {'Object' : ['abort', 'type_name', 'copy'], \
                   'IO' : ['out_string', 'out_int', 'in_string', 'out_int'], \
                   'String' : ['length', 'concat', 'substr'],\
                   'Int' : [], 'Bool' : [] }
        attr = dict([ (x, []) for x in types ])


        for node in class_list:
            if node.parent == None:
                types[node.name] = 'Obeject'
            else:
                types[node.name] = node.parent.name

            for f in node.features:
                if type(f) == ast.AttributeNode:
                    if not node.name in attr:
                        attr[node.name] = []
                    attr[node.name].append(f.name)
                else: 
                    if not node.name in methods:
                        methods[node.name] = []
                    methods[node.name].append(f.name)

        for t in types:
            nodes = [t]
            x = t
            while(types[x] != None):
                x = types[t]
                nodes.append(x)
            nodes.reverse()
            for node in nodes:
                self.vt.add_method(t, methods[node])
                self.vt.add_attr(t, attr[node])

    
            

    
    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node):
        self.visit(node.class_list)

    @visitor.when(ast.ClassListNode)
    def visit(self):
        self.collectTypes(node.class_list)
        

    @visitor.when(ast.ClassNode)
    def visit(self, node):
        pass

    @visitor.when(ast.AttributeNode)
    def visit(self):
        pass

    @visitor.when(ast.MethodNode)
    def visit(self, node):
        
        self.code.append(LabelIL(self.cur_class, node.name)) 
        variables = Variables()

        #pasar self
        for p in node.params:
            variables.add_var(p.name)

        self.visit(node.body, variables)    
    
    
    @visitor.when(ast.BlockNode)
    def visit(self, node, variables):
        for e in node.exprs:
            self.visit(e, variables)

    
   
    def bin_op(self, node, variables : Variables, sym : str):
        p = variables.add_temp()
        code.append(PushIL(0))
        
        self.visit(node.left,  variables)
        l = variables.peek_last()
        self.visit(node.right, variables)
        r = variables.peek_last()  
        
        p, l, r = map(lambda x : variables.id(x), [p, l, r])
        self.code.append(BinOpIL(p, l, r, sym))
        
        variables.pop_temp()
        variables.pop_temp()
        self.code.append(PopIL(2))

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

    @visitor.when(ast.GENode)
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
        self.visit(node.expr, variables)
        variables.pop_temp()
        self.code.append(UnaryOpIL(p, l, symb))


    @visitor.when(ast.OpositeNode)
    def visit(self, node, variables):
        unary_op(node, variables, '~')

    @visitor.when(ast.NotNode)
    def visit(self, node):
        unary_op(node, Variables, '!')

    @visitor.when(ast.LetNode)
    def visit(self, node, variables):
        p = variables.peek_last()    
    
        for expr in node.let_part:
            self.visit(expr, variables)

        r = variables.add_temp()
        self.visit(node.in_part, variables)
        variables.pop_temp()

        for expr in node.let_part:
            variables.pop_var(expr.name)

        code.append(VarToVarIL(p, r))


    
    @visitor.when(ast.AssignationNode)
    def visit(self, node, variables):
        l = variables.add_var(node.name)
        r = variables.add_temp()
        self.visit(node.value, variables)
        variables.pop_temp()

        self.code.append(VarToVarIL(l, r))

    @visitor.when(ast.NumberNode)
    def visit(self, node, variables):
        p = variables.peek_last()
        self.code.append(CteToMemoIL(p, node.value))

    @visitor.when(ast.BoolNode)
    def visit(self, node, variables):
        p = variables.peek_last()
        self.code.append(CteToMemoIL(p, 1 if node.value else 0))

    @visitor.when(ast.StrtingNode)
    def visit(self, node):
        pass

    @visitor.when(ast.VarNode)
    def visit(self, node):
        pass

    @visitor.when(ast.DeclarationNode)
    def visit(self, node, variables : Variables):
        p = variables.add_var(node.name)
        t = variables.add_temp()
        if node.expr != None:
            self.visit(node.expr, variables)
            code.append(VarToVarIL(p, t))
        variables.pop_temp()


    @visitor.when(ast.NewNode)
    def visit(self, node, variables):
        p = variables.peek_last()
        size = self.vt.get_size(node.type)
        code.append(AllocateIL(p, size))

    @visitor.when(ast.LoopNode)
    def visit(self, node, variables):
        labelLOOP = LabelIL('_loop', self.getInt())
        labelPOOL = LabelIL('_pool', labelLOOP.snd)
        labelBODY = LabelIL('_body', labelLOOP.snd) 

        #LOOP
        self.code.append(labelLOOP)

        #Condition
        c = variables.add_temp()
        self.visit(node.condition, variables)
        variables.pop_temp()

        #if Condition GOTO BODY
        self.code.append(IfJumpIL(c, labelBODY.label))

        #GOTO POOL
        self.code.append(GotoIL(labelPOOL.label))
        
        #BODY
        self.code.append(labelBODY)
        self.visit(node.body, variables)
        self.code.append(GotoIL(labelLOOP.label))

        #POOL
        self.code.append(labelPOOL)


    @visitor.when(ast.ConditionalNode)
    def visit(self, node, variables):
        c = variables.add_temp()        
        self.visit(node.if_part, variables)
        variables.pop_temp()

        labelIF = LabelIL('_if', self.getInt()) 
        labelFI = LabelIL('_fi', labelFI)
        # If condition GOTO IF
        self.code.append(IfJumpIL(c, labelIF.label))
        
        #Else
        if node.else_part != None:
            self.visit(node.else_part, variables)
        self.code.append(GotoIL(labelFI.label))
        #If
        self.code.append(labelIF)
        self.visit(node.then_part, variables)
        # Fi
        self.code.append(LabelIL('_fi', LabelIF.snd))
        

        


    @visitor.when(ast.ShortDispatchNode)
    def visit(self, node, variables):
        idx = self.vt.get_method_id(node.method_name)
        code.append(PushPCIL())
        
        new_var = Variables()
        for p in node.params:
            x = variables.add_temp()
            self.visit(p)

            code.append(PushIL())
            new_var.add_var(para)

        code.append(DispathcIL)


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



# ShortDispatchNode
# PointDispatchNode
# ParentDispatchNode

# CaseNode **

# StrtingNode
# VoidNode