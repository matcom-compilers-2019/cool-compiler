from parsing import cool_ast as ast
import visitor
from checksemantic.scope import Scope

ERROR = 0

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
            if c.parent:
                scope.add_type(c.name.value, [m for m in c.features if isinstance(m, ast.MethodNode)], c.parent.value)
            else:
                scope.add_type(c.name.value, [m for m in c.features if isinstance(m, ast.MethodNode)])
        for c in node.classes:
            child_scope = scope.create_child_scope(inside=c.name.value)
            if not self.visit(c, child_scope, errors):
                result = False
        return result
    
    @visitor.when(ast.ClassNode)
    def visit(self, node, scope, errors):
        result = True
        for f in node.features:
            if not self.visit(f, scope, errors):
                result = False
        #scope.define_variable('self', node.name.value)
        return result
    
    @visitor.when(ast.AttributeNode)
    def visit(self, node, scope, errors):
        val_t = 'Void'
        if node.value:
            val_t = self.visit(node.value, scope, errors)
        if val_t:
            t = node.type.value if node.type.value != 'SELF_TYPE' else scope.inside
            if val_t != t and val_t != 'Void':
                errors.append('Attribute declaration failed because the types do not match at line %d column %d' % (node.type.line, node.type.column))
                return ERROR
            t = val_t if val_t == 'Void' else node.type.value
            scope.define_variable(node.name.value, t)
            return t
        return ERROR
    
    @visitor.when(ast.MethodNode)
    def visit(self, node, scope, errors):
        child_scope = scope.create_child_scope()
        child_scope.methods = [m for m in scope.methods]
        fine = True
        if node.return_type.value != 'SELF_TYPE' and not child_scope.check_type(node.return_type.value):
            errors.append('Method declaration failed because the return type is not defined at line %d column %d' %(node.return_type.line, node.return_type.column))
            fine = False
        for p in node.params:
            if not self.visit(p, child_scope, errors):
                fine = False
        
        if not fine:
            return ERROR
        
        fine = self.visit(node.body, child_scope, errors)
                
        t = node.return_type.value if node.return_type.value != 'SELF_TYPE' else child_scope.inside
        fine = fine if fine != 'SELF_TYPE' else child_scope.inside
        if t != fine:
            errors.append('The return type does not match with the expression in the body of method %s at line %d, column %d' % (node.name.value, node.return_type.line, node.return_type.column))
            return ERROR
        scope.add_method(node)
        return fine
    
    @visitor.when(ast.ParamNode)
    def visit(self, node, scope, errors):
        if not scope.check_type(node.type.value):
            errors.append('Parameter declaration failed because the type is not defined at line %d column %d' % (node.type.line, node.type.column))
            return False
        if node.type.value == 'SELF_TYPE':
            errors.append('Parameter cannot be "SELF_TYPE" at line %d, column %d' % (node.type.line, node.type.column))
            return ERROR
        scope.define_variable(node.name.value, node.type.value)
        return node.type.value

    @visitor.when(ast.ComparerNode)
    def visit(self, node, scope, errors):
        rleft = self.visit(node.left, scope, errors)
        rright = self.visit(node.right, scope, errors)
        if rleft != "Bool" or rright != "Bool":
            errors.append('Operator error: the operand types do not match. Both operands must be "BOOLEAN"')
            return ERROR
        return rleft

    @visitor.when(ast.ArithmeticNode)
    def visit(self, node, scope, errors):
        rleft = self.visit(node.left, scope, errors)
        rright = self.visit(node.right, scope, errors)
        if rleft != rright or rleft != "Int" or rright != "Int":
            errors.append('Operator error: the operand types do not match. Both operands must be "INTEGER"')
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
        child_scope = scope.create_child_scope()
        rtype = True
        for expr in node.exprs:
            if not self.visit(expr, child_scope, errors):
                rtype = False
        return rtype

    @visitor.when(ast.AssignationNode)
    def visit(self, node, scope, errors):
        rtype = self.visit(node.value, scope, errors)
        if not scope.is_defined(node.name.value):
            errors.append('Variable "%s" not defined at line %d column %d.' % (node.name.value, node.name.line, node.name.column))
            return ERROR
        if rtype != 'Void' or not scope.inherits(rtype, scope.get_type(node.name.value), 0):
            errors.append('Assignation failed due to the type of the variable  "%s" and the type of the assigned expression do not match at line %d column %d' % (node.name.value, node.name.line, node.name.column))
            return ERROR
        return scope.get_type(node.name.value)

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
        if not scope.is_defined(node.id.value):
            errors.append('Variable "%s" not defined at  line %s column %s.' % (node.id.value, node.id.line, node.id.column))
            return ERROR
        return scope.get_type(node.id.value)

    @visitor.when(ast.DeclarationNode)
    def visit(self, node, scope, errors):
        rtype = 'Void'
        if node.expr:
            rtype = self.visit(node.expr, scope, errors)

        t = node.type.value if node.type.value != 'SELF_TYPE' else scope.inside
        if rtype != 'Void' and not scope.inherits(rtype, t, 0):
            errors.append('Declaration failed because the type of the variable and the type of the expression do not match at line %d column %d' % (node.name.line, node.name.column))
            return ERROR
        
        if scope.is_local(node.name.value):
            errors.append('Variable "%s" already defined at line:%d column:%d.' % (node.name.value, node.name.line, node.name.column))
            return ERROR
        
        scope.define_variable(node.name.value, t) if rtype != 'Void' else scope.define_variable(node.name.value, 'Void')
        return t if rtype != 'Void' else 'Void'
    
    @visitor.when(ast.NewNode)
    def visit(self, node, scope, errors):
        if not scope.check_type(node.type.value):
            errors.append('Type "%s" not defined at line %d column %d' % (node.type.value, node.type.line, node.type.column))
            return ERROR
        return node.type.value if node.type.value != 'SELF_TYPE' else scope.inside
    
    @visitor.when(ast.LoopNode)
    def visit(self, node, scope, errors):
        cvisit = self.visit(node.condition, scope, errors)
        child_scope = scope.create_child_scope()
        result = self.visit(node.body, child_scope, errors)
        return ERROR if not cvisit or not result else 'Void'
    
    @visitor.when(ast.ConditionalNode)
    def visit(self, node, scope, errors):
        _if = self.visit(node.if_part, scope, errors)
        child_scope = scope.create_child_scope()
        _then = self.visit(node.then_part, child_scope, errors)
        child_scope = scope.create_child_scope()
        _else = self.visit(node.else_part, child_scope, errors)
        if not _if or not _then or not _else:
            return ERROR
        return scope.join(_then, _else)
    
    def arguments_checker(self, method, node, scope, errors):
        if len(node.params) != len(method.params):
            errors.append('Method "%s" receives %d parameters, %d was given at line %d, column %d.'%(method.name.value, len(method.params), len(node.params), node.method_name.line, node.method_name.column))
            return False
        result = True
        for i in range(len(node.params)):
            arg_t = self.visit(node.params[i], scope, errors)
            if not arg_t:
                result = False
            param_t = method.params[i].type.value
            if arg_t != 'Void' and not scope.inherits(arg_t, param_t, 0):
                errors.append('Parameter %s has type %s but %s was given at line %d, column %d.' % (method.params[i].name.value, param_t, arg_t, node.params[i].name.line, node.params[i].name.column))
                result = False
        return False
        
    @visitor.when(ast.ShortDispatchNode)
    def visit(self, node, scope, errors):
        method = scope.is_defined_in_type(scope.inside,node.method_name.value)
        if not method:
            errors.append('Method "%s" not defined at line %d column %d' % (node.method_name.value, node.method_name.line, node.method_name.column))
            return ERROR
        if not self.arguments_checker(method, node, scope, errors):
            return ERROR
        return method.return_type.value

    @visitor.when(ast.PointDispatchNode)
    def visit(self, node, scope, errors):
        t = self.visit(node.expr, scope, errors)
        if not t:
            return ERROR
        m = scope.look_for_method(t,node.method_name.value)
        if not m:
            return ERROR
        if not self.arguments_checker(m, node, scope, errors):
            return ERROR
        return m.return_type.value
    
    @visitor.when(ast.ParentDispatchNode)
    def visit(self, node, scope, errors):
        t = self.visit(node.expr, scope, errors)
        if not scope.inherits(t, node.parent.value, 0)[0]:
            return ERROR
        m = scope.get_method(node.parent.value, node.method_name.value)
        if not m:
            return ERROR
        if not self.arguments_checker(m, node, scope, errors):
            return ERROR
        return m.return_type.value

    @visitor.when(ast.IsVoidNode)
    def visit(self, node, scope, errors):
        if not self.visit(node.expr, scope, errors):
            return ERROR
        return 'Bool'
    
    @visitor.when(ast.CaseNode)
    def visit(self, node, scope, errors):
        maint = self.visit(node.main_expr, scope, errors)
        if not maint:
            return ERROR
        result = ERROR
        minLevel = 100100
        for b in node.branches:
            btype = self.visit(b, scope, errors)
            if not btype:
                return ERROR
            _type = b.type.value
            t, level = scope.inherits(maint, _type, 0)
            if t and level < minLevel:
                result = btype
                minLevel = level
        return result
    
    @visitor.when(ast.VoidNode)
    def visit(self, node, scope, errors):
        return 'Void'