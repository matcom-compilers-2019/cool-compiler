from lark import Lark, Token
import grammar
from cool_transformer import ToCoolASTTransformer
from checksemantics import CheckSemanticsVisitor
from scope import Scope


#"class A{ a : Int <- 5; }; class B {};"
program = "class A{ m():Int{4} t():Int{3} }; class Main{ main():Int{ { v <- 4 + ~let t : Int <- 5 in t + 5; case v of s : Int => if true then 5 + 5 else 3 fi; esac; } } };class B inherits A{ n():Int{5}};"
parser = Lark(grammar.grammar, start='program')
print('PARSER CREATED')
tree = parser.parse(program)
print(tree.pretty())
ast = ToCoolASTTransformer().transform(tree)
print('AST CREATED')
checkSemanticVisitor = CheckSemanticsVisitor()
scope = Scope()
errors = []
t = checkSemanticVisitor.visit(ast, scope, errors)
print(t)
print(errors)
