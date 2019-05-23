from lark import Transformer
from parsing.cool_ast import *

class ToCoolASTTransformer(Transformer):

    def program(self, cls_list):
        return ProgramNode(cls_list[0])

    def class_list(self, clss):
        return ClassListNode(clss)

    def simple_cls(self, t):
        return ClassNode(t[1], t[2])
    
    def descendant_cls(self, children):
        name, parent, body = children[1], children[3], children[4]
        return ClassNode(name, body, parent=parent)
    
    def feature_list(self, features):
        return features
    
    def attr(self, children):
        name, t, expr = children[0], children[1], children[2] if len(children)==3 else None
        return AttributeNode(name, t, expr)
    
    def method(self, children):
        name, params, rtype, body = children[0], children[1], children[2], children[3]
        return MethodNode(name, params, rtype, body)
    
    def decl_params(self, params):
        return params
    
    def decl_param(self, param):
        name, t = param[0], param[1]
        return ParamNode(name, t)
    
    def assignment(self, children):
        name, val = children[0], children[1]
        return AssignationNode(name, val)
    
    def less(self, children):
        l, r = children[0], children[1]
        return LessNode(l, r)
    
    def eq(self, children):
        l, r = children[0], children[1]
        return EqualNode(l, r)

    def leq(self, children):
        l, r = children[0], children[1]
        return LeqNode(l, r)

    def plus(self, children):
        l, r = children[0], children[1]
        return SumNode(l, r)
    
    def minus(self, children):
        l, r = children[0], children[1]
        return SubNode(l, r) 

    def times(self, children):
        l, r = children[0], children[1]
        return TimesNode(l, r)
    
    def div(self, children):
        l, r = children[0], children[1]
        return DivNode(l, r)
    
    def lplus(self, children):
        l, r = children[0], children[1]
        return SumNode(l, r)
    
    def lminus(self, children):
        l, r = children[0], children[1]
        return SubNode(l, r) 

    def ltimes(self, children):
        l, r = children[0], children[1]
        return TimesNode(l, r)
    
    def ldiv(self, children):
        l, r = children[0], children[1]
        return DivNode(l, r)
    
    def let(self, children):
        let_part, in_part = children[1], children[3]
        return LetNode(let_part, in_part)
    
    def decl_list(self, l):
        return l
    
    def decl(self, children):
        name, t, expr = children[0], children[1], children[2] if len(children)==3 else None
        return DeclarationNode(name, t, expr)

    def neglet(self, ch):
        return OpositeNode(ch[0])

    def number(self, num):
        return NumberNode(float(num[0]))
    
    def true(self, ch):
        return BoolNode(True)
    
    def false(self, ch):
        return BoolNode(False)
    
    def string(self, ch):
        return StrtingNode(ch[0])

    def id(self, var):
        return VarNode(var[0])
    
    def braces(self, expr):
        return expr
    
    def neg(self, expr):
        return OpositeNode(expr[0])
    
    def notx(self, expr):
        return NotNode(expr[0])
    
    def case(self, children):
        expr, branches = children[1], children[3]
        return CaseNode(expr, branches)

    def branches(self, b):
        return b
    
    def branch(self, children):
        name, t, expr = children[0], children[1], children[2]
        return DeclarationNode(name, t, expr)
    
    def block(self, exprs):
        return BlockNode(exprs)
    
    def isvoid(self, expr):
        return IsVoidNode(expr[1])
    
    def new(self, t):
        return NewNode(t[1])
    
    def point_dispatch(self, children):
        expr, name, params = children[0], children[1], children[2]
        return PointDispatchNode(expr, name, params)
    
    def short_dispatch(self, children):
        name, params = children[0], children[1]
        return ShortDispatchNode(name, params)
    
    def parent_dispatch(self, children):
        expr, t, name, params = children[0], children[1], children[2], children[3]
        return ParentDispatchNode(expr, t, name, params)

    def func_params(self, children):
        return children
    
    def conditional(self, children):
        if_part, then_part, else_part = children[1], children[3], children[5]
        return ConditionalNode(if_part, then_part, else_part)
    
    def loop(self, children):
        cond, expr = children[0], children[1]
        return LoopNode(cond, expr)
    
    def void(self, child):
        return VoidNode()