'''
Este es el archivo que ejecuta todo el proceso de compilacion
'''

from lark import Lark, Token
from parsing import grammar, cool_ast, preprocess
from parsing.cool_transformer import ToCoolASTTransformer
from checksemantic.checksemantics import CheckSemanticsVisitor
from checksemantic.scope import Scope

import sys

def fetch_program(path):
    fd = open(path)
    program = fd.read(10000000)
    fd.close()
    return program

if __name__ == '__main__':

    path = sys.argv[1]
    program = fetch_program(path)
    
    parser = Lark(grammar.grammar, start='program')

    preprocessed = preprocess.preprocess_program(program)

    try:
        tree = parser.parse(preprocessed)
    except:
        print('Syntax Error!')
        raise Exception("Syntactical error")

    ast = ToCoolASTTransformer().transform(tree)

    checkSemanticVisitor = CheckSemanticsVisitor()
    scope = Scope()
    errors = []

    t = checkSemanticVisitor.visit(ast, scope, errors)
    if not t:
        print('There were semantic errors!')
        print('============================')
        for error in errors:
            print(error)