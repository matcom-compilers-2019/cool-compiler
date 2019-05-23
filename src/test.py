from lark import Lark, Token
from parsing import grammar, cool_ast
from parsing.cool_transformer import ToCoolASTTransformer
from checksemantic.checksemantics import CheckSemanticsVisitor
from checksemantic.scope import Scope

###TODO: AVERIGUAR COMO PUEDO HACER PARA CONTROLAR QUE LOS NOMBRES DE LAS VARIABLES NO SEAN RESERVED WORDS

# program = r"""
# class Main{
#     main():INT{2+2}
# };
# """

program = r"""
class A{ 
    clone(c : A):SELF_TYPE{
        self
    }
    m(a:Int, b:Bool):Int{
        4
    } 
    t():Int{
        m(3,true)
    } 
};

class B inherits A{
    n():Int{
        {
            clone(self);
            5;
        }
    }
};

class Main{ 
    main():Int{ 
        { 
            x : A <- new A;
            x.t();
            y : A <- new B;
            y@A.t();
            v : Int <- 4 + ~let t : Int <- 5 in t + 5; 
            case v of s : Int => if true then 5 + 5 else 3 fi; esac; 
            0;
        } 
    } 
};
"""
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
for error in errors:
    print(error)