from lark import Lark, Token
import grammar
from cool_transformer import ToCoolASTTransformer
from checksemantics import CheckSemanticsVisitor
from scope import Scope



###TODO: LOS METODOS NO DEBEN TENER IGUAL NOMBRE EN LA MISMA CLASE (ESTO INCLUYE Q NO SE PUEDEN REDEFINIR METODOS EN LAS CLASES HEREDERAS)!!!
###TODO: VERIFICAR SI UN TIPO HEREDA DE OTRO EN VEZ DE QUE SEAN DEL MISMO TIPO EN ALGUNOS CASOS(??)
###TODO: INCLUIR 'SELF_TYPE' QUE REPRESENTA LA CLASE DONDE ESTA. POSIBLEMENTE HAYA QUE MODIFICAR LA GRAMATICA PQ SOLO PUEDE APARECER EN 'NEW', TIPO DE RETORNO, LET, ATRIBUTOS
###TODO: self VARIABLE
###TODO: NO ES NECESARIO INICIALIZAR TODAS LAS VARIABLES O ATRIBUTOS EN CASO DE QUE NO SE INICIALICE EL VALOR SERA void.
###TODO: join EN EL SCOPE PARA DETERMINAR EL TIPO ESTATICO DE EXPRESIONES COMO EL IF-THEN-ELSE
###TODO: NO EXITE PRINT NI SCAN SINO QUE HAY UNA CLASE IO QUE TIENE LOS METODOS DE ENTRADA Y SALIDA

#"class A{ a : Int <- 5; }; class B {};"
program = r"""
class A{ 
    m(a:Int, b:Bool):Int{
        4
    } 
    t():Int{
        m(3,true)
    } 
};

class B inherits A{
    n():Int{
        5
    }
};

class Main{ 
    main():Int{ 
        { 
            x : A <- new A;
            x.t();
            y : B <- new B;
            y@A.t();
            v : Int <- 4 + ~let t : Int <- 5 in t + 5; 
            case v of s : Int => if true then 5 + 5 else 3 fi; esac; 
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