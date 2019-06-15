import sys
sys.path.append('/..')
from code_gen.il_nodes import *
from parsing import cool_ast as ast
from code_gen.virtual_table import virtual_table, Variables
import visitor
import copy


class codeVisitor:

    def __init__(self):
        #IL code
        self.code = []
        self.data = []

        #Utilities
        self.cur_class = 'Main'
        self.intGen = 0
        
        
        self.vt = virtual_table()
        self.variables = Variables()

    def getInt(self):
        self.intGen += 1
        return str(self.intGen)

    # Collects class, functions, inheritence and attributes definitions
    def collectTypes(self, class_list):

        types = {'Object' : None, 'IO' : 'Object', 'Int' : 'Object', 'Bool' : 'Object', 'String' : 'Object'}
        methods = {'Object' : ['abort', 'type_name', 'copy'], \
                   'IO' : ['out_string', 'out_int', 'in_string', 'out_int'], \
                   'String' : ['length', 'concat', 'substr'],\
                   'Int' : [], 'Bool' : [] }
        attr = dict([ (x, []) for x in types ])


        for node in class_list:
            types[node.name.value] = node.parent.value

            for f in node.features:
                if type(f) == ast.AttributeNode:
                    if not node.name.value in attr:
                        attr[node.name.value] = []
                    attr[node.name.value].append(f.name.value)
                else: 
                    if not node.name.value in methods:
                        methods[node.name.value] = []
                    methods[node.name.value].append(f.name.value)

        for t in types.keys():
            nodes = [t]
            x = t
           

            while(types[x] != None):
               x = types[x]
               nodes.append(x)

            nodes.reverse()
            for node in nodes:
                try:
                    self.vt.add_method(t, node, methods[node])
                except:
                    pass
                try:
                    self.vt.add_attr(t, attr[node])
                except:
                    pass

        
        #Adding inheritance lines
        for k in types:
            self.data.append(HierarchyIL(k, types[k]))
        

        #Adding virtual tables lines
        for c in self.vt.methods:
            self.data.append(VirtualTableIL(c, self.vt.methods[c]))  

        #Visitor
    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node):
        self.visit(node.class_list)

    @visitor.when(ast.ClassListNode)
    def visit(self, node):
        self.collectTypes(node.class_list)
        

    @visitor.when(ast.ClassNode)
    def visit(self, node):
        self.cur_class = node.name
        for f in node.features:
            self.visit(f)


    @visitor.when(ast.MethodNode)
    def visit(self, node):
        
        self.code.append(LabelIL(self.cur_class, node.name, True)) 

        variables = Variables()
        
        #This has being push already before calling dispatch
        variables.add_var('self')
        for p in node.params:
            variables.add_var(p.name)

        self.visit(node.body, variables)    

        self.code.append(ReturnIL())
    
    @visitor.when(ast.BlockNode)
    def visit(self, node, variables):
        for e in node.exprs:
            self.visit(e, variables)

    
   
    def bin_op(self, node, variables : Variables, sym : str):
        self.code.append(PushIL(0))
        res = variables.add_temp()


        self.visit(node.left,  variables)
        l = variables.peek_last()
        self.visit(node.right, variables)
        r = variables.peek_last()  
        
        self.code.append(BinOpIL(res, l, r, sym))
        
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
        self.code.append(PushIL(0))
        res = variables.add_temp()

        l = variables.add_temp()
        self.visit(node.expr, variables)
        self.code.append(UnaryOpIL(res, l, symb))
        variables.pop_temp()
        self.code.append(PopIL(1))

    @visitor.when(ast.OpositeNode)
    def visit(self, node, variables):
        unary_op(node, variables, '~')

    @visitor.when(ast.NotNode)
    def visit(self, node):
        unary_op(node, Variables, '!')

    @visitor.when(ast.LetNode)
    def visit(self, node, variables):
        self.code.append(PushIL(0))
        res = variables.add_temp()   
    
        for expr in node.let_part:
            self.visit(expr, variables)

        # self.code.append(PushIL(0))
        
        self.visit(node.in_part, variables)
        p = variables.peek_last()

        code.append(VarToVarIL(res, p))
        
        variables.pop_var()
        for expr in node.let_part:
            variables.pop_var()
        self.code.append(PopIL(len(node.let_part) + 1))

    
    @visitor.when(ast.AssignationNode)
    def visit(self, node, variables):
        self.code.append(PushIL(0))
        l = variables.add_var(node.name.value)
        
        self.visit(node.value, variables)
        p = variables.peek_last()
        
        self.code.append(VarToVarIL(l, p))
        variables.pop_var()
        self.code.append(PopIL(1))

    @visitor.when(ast.NumberNode)
    def visit(self, node, variables):
        variables.add_temp()
        self.code.append(PushIL(int(node.value.value)))


    @visitor.when(ast.BoolNode)
    def visit(self, node, variables):
        variables.add_temp()
        self.code.append(PushIL(1 if node.value.value == 'true' else 0))

    @visitor.when(ast.StrtingNode)
    def visit(self, node):
        pass

    @visitor.when(ast.VarNode)
    def visit(self, node, variables):
        self.code.append(PushIL(0))
        res = variables.add_temp()

        if variables.__contains__(node.id.value):
            self.code.append(VarToVarIL(res, variables[node.id.value]))
        else:
            self.code.append(MemoToVarIL(res, variables[self], self.vt.get_attr(self.cur_class, node.id.value)))


    @visitor.when(ast.DeclarationNode)
    def visit(self, node, variables : Variables):
        self.code.append(PushIL(0))
        p = variables.add_var(node.name)
        
        if node.expr != None:
            self.visit(node.expr, variables)
            r = variables.peek_last()
            code.append(VarToVarIL(p, t))
            variables.pop_var()


    @visitor.when(ast.NewNode)
    def visit(self, node, variables):
        self.code.append(PushIL(0))
        variables.add_temp()
        size = self.vt.get_size(node.type.value)
        code.append(AllocateIL(p, size, node.type.value))

    @visitor.when(ast.LoopNode)
    def visit(self, node, variables):

        self.code.append(PushIL(0))
        self.variables.add_temp()

        labelLOOP = LabelIL('_loop', self.getInt())
        labelPOOL = LabelIL('_pool', labelLOOP.snd)
        labelBODY = LabelIL('_body', labelLOOP.snd) 

        #LOOP
        self.code.append(labelLOOP)

        #Condition
        self.visit(node.condition, variables)
        c = variables.peek_last()

        #if Condition GOTO BODY
        self.code.append(IfJumpIL(c, labelBODY.label))

        #GOTO POOL
        self.code.append(GotoIL(labelPOOL.label))
        
        #BODY
        self.code.append(labelBODY)
        self.visit(node.body, variables)
        variables.pop_var() #Pop the value of eprx in body
        variables.pop_var() #Pop condition
        self.code.append(PopIL(2))
        self.code.append(GotoIL(labelLOOP.label))

        #POOL
        self.code.append(labelPOOL)
        variables.pop_var() #Just pop condition
        self.code.append(PopIL(1))

    @visitor.when(ast.ConditionalNode)
    def visit(self, node, variables):
        res = variables.add_temp()
        self.code.append(PushIL(0)) 
        self.visit(node.if_part, variables)
        c = variables.peek_last()

        labelIF = LabelIL('_if', self.getInt()) 
        labelFI = LabelIL('_fi', labelFI)
        # If condition GOTO IF
        self.code.append(IfJumpIL(c, labelIF.label))
        
        temp = 0
        #Else
        if node.else_part != None:
            self.visit(node.else_part, variables)
            temp = variables.peek_last()
        self.code.append(GotoIL(labelFI.label))
        #If
        self.code.append(labelIF)
        self.visit(node.then_part, variables)
        temp = variables.peek_last()
        # Fi
        self.code.append(LabelIL('_fi', LabelIF.snd))
        self.code.append(VarToVarIL(res, temp))
        variables.pop_var()
        variables.pop_var()
        self.code.append(PopIL(2))
        

        


    @visitor.when(ast.ShortDispatchNode)
    def visit(self, node, variables):
        # res = variables.add_temp()
        # self.code.append(PushIL(0))

        # idx = self.vt.get_method_id(node.method_name)
        
        # for p in node.params:
        #     code.append(PushIL())
        #     new_var.add_var(para)

        # code.append(DispathcIL)
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



# ShortDispatchNode
# PointDispatchNode
# ParentDispatchNode

# CaseNode **

# StrtingNode
# VoidNode