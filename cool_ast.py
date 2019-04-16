
class ClassListNode:
    def __init__(self, clss):
        self.classes = clss

class ClassNode:
    def __init__(self, name, features, parent=None):
        self.name = name
        self.features = features
        self.parent = parent

class AttributeNode:
    def __init__(self, name, t, value):
        self.name = name
        self.type = t
        self.value = value

class MethodNode:
    def __init__(self, name, params,return_type, body):
        self.name = name
        self.params = params
        self.return_type = return_type
        self.body = body

class ExpressionNode:
    pass

class AssignationNode(ExpressionNode):
    def __init__(self, name, value):
        self.name = name
        self.value = value

class BinaryNode(ExpressionNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right

class LessNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class EqualNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class LeqNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class SumNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class SubNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class TimesNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class DivNode(BinaryNode):
    def __init__(self, left, right):
        super().__init__(left, right)

class AtomicNode(ExpressionNode):
    pass

class UnaryNode(AtomicNode):
    def __init__(self, expr):
        self.expr = expr

class OpositeNode(UnaryNode):
    def __init__(self, expr):
        super().__init__(expr)

class NotNode(UnaryNode):
    def __init__(self, expr):
        super().__init__(expr)

class ConstantNode(AtomicNode):
    def __init__(self, value):
        self.value = value

class NumberNode(ConstantNode):
    def __init__(self, value):
        super().__init__(value)

class StrtingNode(ConstantNode):
    def __init__(self, value):
        super().__init__(value)

class BoolNode(ConstantNode):
    def __init__(self, value):
        super().__init__(value)

class CaseNode(AtomicNode):
    def __init__(self, main_expr, branches):
        self.main_expr = main_expr
        self.branches = branches

class DeclarationNode:
    def __init__(self, name, t, expr):
        self.name = name
        self.type = t
        self.expr = expr

class BlockNode(AtomicNode):
    def __init__(self, exprs):
        self.exprs = exprs

class IsVoidNode(UnaryNode):
    def __init__(self, expr):
        super().__init__(expr)

class VarNode(AtomicNode):
    def __init__(self, id):
        self.id = id

class DispatchNode(AtomicNode):
    def __init__(self, method_name, params):
        self.method_name = method_name
        self.params = params

class ShortDispatchNode(DispatchNode):
    def __init__(self, method_name, params):
        super().__init__(method_name, params)

class PointDispatchNode(DispatchNode):
    def __init__(self, expr, t,method_name, params):
        super().__init__(method_name, params)
        self.expr = expr

class ParentDispatchNode(DispatchNode):
    def __init__(self, expr, parent, method_name, params):
        super().__init__(method_name, params)
        self.expr = expr
        self.parent = parent

class ConditionalNode(ExpressionNode):
    def __init__(self, if_part, then_part, else_part):
        self.if_part = if_part
        self.then_part = then_part
        self.else_part = else_part

class LoopNode(ExpressionNode):
    def __init__(self, condition, body):
        self.condition = condition
        self.body = body

class LetNode(AtomicNode):
    def __init__(self, let_part, in_part):
        self.let_part = let_part
        self.in_part = in_part

class NewNode(AtomicNode):
    def __init__(self, t):
        self.type = t
