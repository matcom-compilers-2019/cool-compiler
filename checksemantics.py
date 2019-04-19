#import itertools as itl

import cool_ast as ast
import visitor
from scope import Scope

ERROR = 0
#INTEGER = 1

class CheckSemanticsVisitor:
    @visitor.on('node')
    def visit(self, node, scope, errors):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node, scope, errors):
        return self.visit(node.class_list, scope, errors)

    @visitor.when(ast.ClassListNode)
    def visit(self, node, scope, errors):
        result = True
        for c in node.classes:
            child_scope = scope.create_child_scope()
            result = result and self.visit(c, child_scope, errors)
            scope.add_type(c.name.value, c.parent.value, c.features)
        return result
    
    @visitor.when(ast.ClassNode)
    def visit(self, node, scope, errors):
        result = True
        for f in node.features:
            result = result and self.visit(f, scope, errors)
        return result
    
    @visitor.when(ast.AttributeNode)
    def visit(self, node, scope, errors):
        val_t = self.visit(node.value, scope, errors)
        if val_t:
            if val_t != node.type.value:
                errors.append('Attribute declaration failed because the types do not match at line %d column %d' % (node.type.line, node.type.column))
                return ERROR
            scope.define_variable(node.name, node.type.value)
            return node.type.value
        return ERROR
    
    @visitor.when(ast.MethodNode)
    def visit(self, node, scope, errors):
        child_scope = scope.create_child_scope()
        fine = True
        if not child_scope.check_type(node.return_type.value):
            errors.append('Method declaration failed because the return type is not defined at line %d column %d' %(node.return_type.line, node.return_type.column))
            fine = False
        for p in node.params:
            fine = fine and self.visit(p, child_scope, errors)
        fine = fine and self.visit(node.body, child_scope, errors)
        
        return fine if not fine else node.return_type.value
    
    @visitor.when(ast.ParamNode)
    def visit(self, node, scope, errors):
        if not scope.check_type(node.type.value):
            errors.append('Parameter declaration failed because the type is not defined at line %d column %d' % (node.type.line, node.type.colummn))
            return False
        scope.define_variable(node.name.value, node.type.value)
        return node.type.value

    @visitor.when(ast.ComparerNode)
    def visit(self, node, scope, errors):
        rleft = self.visit(node.left, scope, errors)
        rright = self.visit(node.right, scope, errors)
        if rleft != rright or rleft != "Bool" or rright != "Bool":
            errors.append('Operator error: the operand types do not match. Both operands must be "BOOLEAN"')
            return ERROR
        return rleft

    @visitor.when(ast.ArithmeticNode)
    def visit(self, node, scope, errors):
        rleft = self.visit(node.left, scope, errors)
        rright = self.visit(node.right, scope, errors)
        if rleft != rright or rleft != "Int" or rright != "Int":
            errors.append('Operator error: the operand types do not match. Both operands must be "Int"')
            return ERROR
        return rleft

    @visitor.when(ast.OpositeNode)
    def visit(self, node, scope, errors):
        expr_type = self.visit(node.expr, scope, errors)
        if expr_type != "Int" :
            errors.append('The "~" operator takes an INTEGER expression as parameter, "%s" was given' % (expr_type))
            return ERROR
        return expr_type

    @visitor.when(ast.NotNode)
    def visit(self, node, scope, errors):
        expr_type = self.visit(node.expr, scope, errors)
        if expr_type != "Bool" :
            errors.append('The "not" operator takes a BOOLEAN expression as parameter, "%s" was given' % (expr_type))
            return ERROR
        return expr_type

    @visitor.when(ast.LetNode)
    def visit(self, node, scope, errors):
        child_scope = scope.create_child_scope()
        for dcl in node.let_part:
            self.visit(dcl, child_scope, errors)
        return self.visit(node.in_part, child_scope, errors)

    @visitor.when(ast.BlockNode)
    def visit(self, node, scope, errors):
        for expr in node.expr_list:
            rtype = self.visit(expr, scope, errors)
        return rtype

    @visitor.when(ast.AssignationNode)
    def visit(self, node, scope, errors):
        rtype = self.visit(node.expr, scope, errors)
        if not scope.is_defined(node.name.value):
            errors.append('Variable "%s" not defined at line %d column %d]: .' % (node.name.value, node.name.row, node.name.colummn))
            return ERROR
        return rtype

    @visitor.when(ast.NumberNode)
    def visit(self, node, scope, errors):
        return "Int"

    @visitor.when(ast.BoolNode)
    def visit(self, node, scope, errors):
        return "Bool"
    
    @visitor.when(ast.StrtingNode)
    def visit(self, node, scope, errors):
        return "String"

    @visitor.when(ast.VarNode)
    def visit(self, node, scope, errors):
        if not scope.is_defined(node.name.value):
            errors.append('Variable "%s" not defined at  line %s column %s.' % (node.name.value, node.name.row, node.name.column))
            return ERROR
        return scope.get_type(node.name.value)

    @visitor.when(ast.PrintNode)
    def visit(self, node, scope, errors):
        return self.visit(node.expr, scope, errors)

    # @visitor.when(ast.PrintStringNode)
    # def visit(self, node, scope, errors):
    #     return INTEGER

    @visitor.when(ast.ScanNode)
    def visit(self, node, scope, errors):
        return "Int"

    @visitor.when(ast.DeclarationNode)
    def visit(self, node, scope, errors):
        rtype = self.visit(node.expr, scope, errors)
        if scope.is_local(node.idx_token.text_token):
            errors.append('Variable "%s" already defined at line:%d column:%d.' % (node.name.value, node.name.row, node.name.column))
            return ERROR
        scope.define_variable(node.name.value, node.type.value)
        return rtype
    
    @visitor.when(ast.NewNode)
    def visit(self, node, scope, errors):
        return node.type.value
    
    @visitor.when(ast.LoopNode)
    def visit(self, node, scope, errors):
        cvisit = self.visit(node.condition, scope, errors)
        child_scope = scope.create_child_scope()
        result = self.visit(node.body, child_scope, errors)
        return cvisit if not cvisit else result
    
    @visitor.when(ast.ConditionalNode)
    def visit(self, node, scope, errors):
        _if = self.visit(node.if_part, scope, errors)
        child_scope = scope.create_child_scope()
        _then = self.visit(node.then_part, child_scope, errors)
        child_scope = scope.create_child_scope()
        _else = self.visit(node.else_part, child_scope, errors)
        if not _if or not _then or not _else:
            return ERROR
        return _if
    
    @visitor.when(ast.ShortDispatchNode)
    def visit(self, node, scope, errors):
        method = scope.get_local_method(node.method_name.value)
        if not method:
            return ERROR
        return method.return_type

    @visitor.when(ast.PointDispatchNode)
    def visit(self, node, scope, errors):
        t = self.visit(node.expr, scope, errors)
        if not t:
            return ERROR
        m = scope.look_for_method(t,node.method_name.value)
        if not m:
            return ERROR
        return m.return_type.value
    
    @visitor.when(ast.ParentDispatchNode)
    def visit(self, node, scope, errors):
        t = self.visit(node.expr, scope, errors)
        if not scope.inherits(t, node.parent.value):
            return ERROR
        m = scope.get_mehthod(node.parent.value, node.method_name.value)
        if not m:
            return ERROR
        return m.return_type.value

    @visitor.when(ast.IsVoidNode)
    def visit(self, node, scope, errors):
        return 'Bool'
    
    @visitor.when(ast.CaseNode)
    def visit(self, node, scope, errors):
        maint = self.visit(node.main_expr, scope, errors)
        if not maint:
            return ERROR
        #TODO: Verify the lowest ancestor among the branches.