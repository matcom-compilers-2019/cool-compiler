from lark import Lark, Token
from parsing import grammar, cool_ast, preprocess
from parsing.cool_transformer import ToCoolASTTransformer
from checksemantic.checksemantics import CheckSemanticsVisitor
from checksemantic.scope import Scope
from cool import fetch_program
from code_gen.transpilator import *

import os, sys


if __name__ == '__main__':
    program = fetch_program(sys.argv[1])

    parser = Lark(grammar.grammar, start='program')

    preprocessed = preprocess.preprocess_program(program)
    tree = parser.parse(preprocessed)
    ast = ToCoolASTTransformer().transform(tree)
    checkSemanticVisitor = CheckSemanticsVisitor()
    scope = Scope()
    errors = []
    t = checkSemanticVisitor.visit(ast, scope, errors)

    if not t:
        for e in errors:
            print(e)
    else:
        cv = codeVisitor()
        
        cv.collectTypes(ast.class_list.classes)

        print('Classes')
        for clase in cv.vt.clases:
            print (clase)
        
        print('Methods')
        for m in cv.vt.methods.keys():
            print (m + " " + str(cv.vt.methods[m]))

        print('Attributes')
        for att in cv.vt.attr.keys():
            print (att + " " + str(cv.vt.attr[att]))
