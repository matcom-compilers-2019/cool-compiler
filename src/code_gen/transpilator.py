import sys
sys.path.append('/..')
from code_gen.il_nodes import *
from parsing import cool_ast as ast
from code_gen.virtual_table import virtual_table, Variables
import visitor



class codeVisitor:

    def __init__(self):
        #IL code
        self.code = []
        self.data = []

        #Utilities
        self.cur_class = 'Main'
        self.intGen = 0
        
        #Features
        self.vt = virtual_table()

        #Usefull
        self.depth = {}

    def getInt(self):
        self.intGen += 1
        return str(self.intGen)

    # Collects class, functions, inheritence and attributes definitions
    def collectTypes(self, class_list):

        types = {'Object' : None, 'IO' : 'Object', 'Int' : 'Object', 'Bool' : 'Object', 'String' : 'Object'}
        methods = {'Object' : ['abort', 'type_name', 'copy'], \
                   'IO' : ['out_string', 'out_int', 'in_string', 'in_int'], \
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

        #Filling depths for case expr
        depth = dict([(x, len(types) + 2) for x in types])
        depth['Object'] = 0

        for _ in types:
            for c in types:
                if c == 'Object':
                    continue
                p = types[c]
                depth[c] = min(depth[c], depth[p] + 1)
        self.depth = depth

    def InitialCode(self):
        self.code.append(CommentIL('Initial code'))
        self.code.append(LabelIL("main", ""))
        
        self.code.append(PushIL())
        self.code.append(PushIL())
        self.code.append(PushIL())

        self.code.append(AllocateIL(1, self.vt.get_size('Main'), 'Main'))
              
        self.code.append(DispatchParentIL(2, 1, 'Main.Constructor'))
        
        
        self.code.append(DispatchIL(3, 1, self.vt.get_method_id('Main', 'main')))
        
        self.code.append(GotoIL("Object.abort"))



    #Visitor
    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node):
        self.visit(node.class_list)

    @visitor.when(ast.ClassListNode)
    def visit(self, node):
        self.collectTypes(node.classes)
        self.InitialCode()
        self.builtin_constructor()

        for cl in node.classes:
            self.visit(cl)
        
        
    @visitor.when(ast.ClassNode)
    def visit(self, node):
        self.cur_class = node.name.value

        attrs = []
        for f in node.features:
            if type(f) == ast.AttributeNode:
                attrs.append(f)
        
        self.create_constructor(attrs)

        for f in node.features:
            self.visit(f)


    def builtin_constructor(self):
        built = ['Object', 'IO', 'Int', 'Bool', 'String']
        for c in built:
            self.code.append(LabelIL(c, 'Constructor', True))
            self.code.append(PushIL()) #No result, but needed in logic
            self.code.append(ReturnIL())

    def create_constructor(self, attrs):
        self.code.append(LabelIL(self.cur_class, 'Constructor', True))
        
        variables = Variables()
        variables.add_var('self')
        variables.add_temp() # return address

        for node in attrs:
            if node.value == None:
                continue
            self.visit(node.value, variables)
            p = variables.peek_last()
            idx = self.vt.get_attr_id(self.cur_class, node.name.value) 
            self.code.append(VarToMemoIL(variables.id('self'), variables.id(p), idx))
            variables.pop_var()
            self.code.append(PopIL(1))
        
        self.code.append(PushIL()) #No result, but needed in logic
        self.code.append(ReturnIL())



    @visitor.when(ast.AttributeNode)
    def visit(self, node):
        pass

    @visitor.when(ast.MethodNode)
    def visit(self, node):
        
        self.code.append(LabelIL(self.cur_class, node.name, True)) 

        #This has being push already before calling dispatch
        # El self se adiciona en el class node
        variables = Variables()
        variables.add_var('self') #Self its alway the first parameter

        for p in node.params:
            variables.add_var(p.name)
        
        variables.add_temp() # return address

        self.visit(node.body, variables)    

        self.code.append(ReturnIL())
    
    @visitor.when(ast.BlockNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('Block'))
        res = variables.add_temp()
        self.code.append(PushIL(0))

        for e in node.exprs:
            self.visit(e, variables)
        
        p = variables.peek_last()
        self.code.append(VarToVarIL(variables.id(res), variables.id(p)))

        self.code.append(PopIL(len(node.exprs)))
        for i in range(len(node.exprs)):
            variables.pop_var()
   
    def bin_op(self, node, variables : Variables, sym : str):
        self.code.append(CommentIL('Binary_op'))
        self.code.append(PushIL(0))
        res = variables.add_temp()


        self.visit(node.left,  variables)
        l = variables.peek_last()
        self.visit(node.right, variables)
        r = variables.peek_last()  
        
        self.code.append(BinOpIL(variables.id(res), variables.id(l), variables.id(r), sym))
        
        variables.pop_var()
        variables.pop_var()
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
        self.code.append(CommentIL('Unary_op'))
        res = variables.add_temp()
        self.code.append(PushIL())
    
        self.visit(node.expr, variables)
        l = variables.peek_last()
        
        self.code.append(UnaryOpIL(variables.id(res), variables.id(l), symb))
        variables.pop_var()
        self.code.append(PopIL(1))

    @visitor.when(ast.OpositeNode)
    def visit(self, node, variables):
        self.unary_op(node, variables, '~')

    @visitor.when(ast.NotNode)
    def visit(self, node, variables):
        self.unary_op(node, variables, '!')

    @visitor.when(ast.LetNode)
    def visit(self, node, variables : Variables):
        self.code.append(PushIL())
        res = variables.add_temp()   
    
        child_vars = variables.get_copy()
        for expr in node.let_part:
            self.visit(expr, child_vars)
            child_vars = child_vars.get_copy()


        self.visit(node.in_part, child_vars)
        p = child_vars.peek_last()

        self.code.append(VarToVarIL(res, p))
        
        self.code.append(PopIL(len(node.let_part) + 1))

    
    @visitor.when(ast.AssignationNode)
    def visit(self, node, variables):
        self.code.append(CommentIL ('Assignment'))   
        self.visit(node.value, variables)
        p = variables.peek_last()
    
        if node.name.value in variables.variables:
            self.code.append(VarToVarIL( variables.id(node.name.value), variables.id(p) ) )
        else:
            self.code.append(VarToMemoIL( variables.id('self'), variables.id(p), self.vt.get_attr_id(self.cur_class, node.name.value) ) )


    @visitor.when(ast.NumberNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('Number'))
        variables.add_temp()
        self.code.append(PushIL(int(node.value)))


    @visitor.when(ast.BoolNode)
    def visit(self, node, variables):
        variables.add_temp()
        self.code.append(PushIL(1 if node.value else 0))

    @visitor.when(ast.StrtingNode)
    def visit(self, node, variables):
        label = 'str' + str(self.getInt())
        self.data.append(StringIL(label, node.value))
        
        self.code.append(CommentIL('Loading label'))
        self.code.append(PushIL())
        p = variables.add_temp()

        self.code.append(LoadLabelIL(variables.id(p), label)) 


    @visitor.when(ast.VarNode)
    def visit(self, node, variables):
        self.code.append(PushIL())
        res = variables.add_temp()

        if node.id.value in variables.variables:
            self.code.append(VarToVarIL(variables.id(res), variables.id(node.id.value)))
        else:
            self.code.append(MemoToVarIL(variables.id(res), variables.id('self'), self.vt.get_attr_id(self.cur_class, node.id.value)))


    @visitor.when(ast.DeclarationNode)
    def visit(self, node, variables : Variables):
        self.code.append(PushIL())
        p = variables.add_var(node.name.value)
        
        if node.expr != None:
            self.visit(node.expr, variables)
            r = variables.peek_last()
            self.code.append(VarToVarIL(variables.id(p), variables.id(r) ))
            variables.pop_var()
            self.code.append(PopIL(1))


    @visitor.when(ast.NewNode)
    def visit(self, node, variables):
        #return element, copy of the allocate
        res = variables.add_temp()
        self.code.append(PushIL())

        #Dispatch needs to return something
        disp = variables.add_temp()
        self.code.append(PushIL())
        
        #'object' needs to be on the top of the stack before calling dispatch
        self.code.append(PushIL())
        p = variables.add_temp()

        size = self.vt.get_size(node.type.value)
        self.code.append(AllocateIL(variables.id(p), size, node.type.value))

        #copying allocate to res for returning
        self.code.append(VarToVarIL(variables.id(res), variables.id(p) ))

        #dispatching
        self.code.append(DispatchParentIL(variables.id(disp), variables.id(p), node.type.value + '.Constructor'))
        
        #dont need dispatch return, or first 'object' because already copy in res
        self.code.append(PopIL(2))
        variables.pop_var()
        variables.pop_var()

    @visitor.when(ast.LoopNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('LOOP'))
        self.code.append(PushIL())
        res = variables.add_temp()

        labelLOOP = LabelIL('_loop', self.getInt())
        labelPOOL = LabelIL('_pool', labelLOOP.snd)
        labelBODY = LabelIL('_body', labelLOOP.snd) 

        #LOOP
        self.code.append(labelLOOP)

        #Condition
        self.visit(node.condition, variables)
        c = variables.peek_last()

        #if Condition GOTO BODY
        self.code.append(IfJumpIL(variables.id(c), labelBODY.label))

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

    @visitor.when(ast.ConditionalNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('Conditional'))
        res = variables.add_temp()
        self.code.append(PushIL())

        self.visit(node.if_part, variables)
        c = variables.peek_last()

        labelIF = LabelIL('_if', self.getInt()) 
        labelFI = LabelIL('_fi', labelIF.snd)
        # If condition GOTO IF
        self.code.append(IfJumpIL(variables.id(c), labelIF.label))
     
        #Else
        self.visit(node.else_part, variables)
        _else = variables.peek_last()
        self.code.append(VarToVarIL(variables.id(res) , variables.id(_else) ))
        variables.pop_var()

        self.code.append(GotoIL(labelFI.label))     
        
        #If
        self.code.append(labelIF)
        self.visit(node.then_part, variables)
        _if = variables.peek_last()
        self.code.append(VarToVarIL(variables.id(res) , variables.id(_if) ))
        variables.pop_var()
        
        # Fi
        self.code.append(LabelIL('_fi', labelIF.snd))
        
        
        variables.pop_var()
        self.code.append(PopIL(2))


    @visitor.when(ast.ShortDispatchNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('SelfDispatch'))

        # Dir of return
        res = variables.add_temp()
        self.code.append(PushIL())
        #Offset of method
        idx = self.vt.get_method_id(self.cur_class, node.method_name.value)
        
        if self.cur_class != 'Main':
            self.code.append(CommentIL('Pushing Self'))
            s = variables.add_temp()
            self.code.append(PushIL())
            self.code.append(VarToVarIL( variables.id(s),  variables.id('self')))

        #Pushing Params
        i = 0
        for p in node.params:
            self.code.append(CommentIL('PARAM ' + str(i)))
            i += 1 
            self.visit(p, variables)
        #Calling Dispath
        self.code.append(DispatchIL(variables.id(res), variables.id('self'), idx))
        

        n = 0 if self.cur_class == 'Main' else 1
        for i  in range(len(node.params) + n):
            variables.pop_var()
        self.code.append(PopIL(len(node.params) + n))
       

    @visitor.when(ast.PointDispatchNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('PointDispatch'))

        # Dir of return
        res = variables.add_temp()
        self.code.append(PushIL())

        #Offset of method
        idx = self.vt.get_method_id(node.expr.static_type, node.method_name.value)

        #Pushing the object
        self.code.append(CommentIL('Pushing Object'))
        self.visit(node.expr, variables)

        name = variables.peek_last()

        #Pushing Params
        i = 0
        for p in node.params:
            self.code.append(CommentIL('PARAM ' + str(i)))
            i += 1 
            self.visit(p, variables)
        
        #Calling Dispath
        self.code.append(DispatchIL(variables.id(res), variables.id(name), idx))

        for i  in range(len(node.params) + 1):
            variables.pop_var()
        self.code.append(PopIL(len(node.params) + 1))


    @visitor.when(ast.ParentDispatchNode)
    def visit(self, node, variables):
        self.code.append(CommentIL('ParenttDispatch'))
        # Dir of return
        res = variables.add_temp()
        self.code.append(PushIL())

        #Pushing the object
        self.code.append(CommentIL('Pushing Object'))
        self.visit(node.expr, variables)
        name = variables.peek_last()
        #Pushing Params
        i = 0
        for p in node.params:
            self.code.append(CommentIL('PARAM ' + str(i)))
            i += 1 
            self.visit(p, variables)

        method = node.parent.value + '.' + node.method_name.value
        #Calling Dispath
        self.code.append(DispatchParentIL(variables.id(res), variables.id(name), method))

        self.code.append(PopIL(len(node.params) + 1))
        for i  in range(len(node.params) + 1):
            variables.pop_var()

    @visitor.when(ast.CaseNode)
    def visit(self, node, variables):
        node.branches.sort(key = lambda x : self.depth[x.type], reverse = True)

        res = variables.add_temp()
        self.code.append(PushIL())

        self.visit(node.main_expr, variables)
        m = variables.peek_last()

        b_labels = [LabelIL('branch', self.getInt()) for _ in node.branches]
        
        i = 0
        for b in node.branches:
            
            temp = variables.add_temp()
            self.code.append(PushIL())

            self.code.append(InheritIL(variables.id(m), b.type, variables.id(temp)))

            self.code.append(IfJumpIL(variables.id(temp),b_labels[i].label))
            self.code.append(PopIL(1))
            variables.pop_var()
            i += 1
            
        end = LabelIL('end_case', self.get_Int())
        i = 0
        for b in node.branches:

            self.code.append(b_labels[i])
            i += 1
            Variables.pop_var()
            self.code.append(PopIL(1))

            self.code.append(PushIL())
            r = variables.add_var(b.id)
            self.code.append(VarToVarIL(variables.id(r), variables.id(m)))

            self.visit(b.expr, variables)
            p = variables.peek_last()

            self.code.append(VarToVarIL(variables.id(res), variables.id(p)))
            for _ in range(3):
                variables.pop_var()
            self.code.append(PopIL(3))




    @visitor.when(ast.VoidNode)
    def visit(self, node):
        pass

    
        

def start():
    pass

if __name__ == '__main__':
    start()
