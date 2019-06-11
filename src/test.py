from lark import Lark, Token
from parsing import grammar, cool_ast, preprocess
from parsing.cool_transformer import ToCoolASTTransformer
from checksemantic.checksemantics import CheckSemanticsVisitor
from checksemantic.scope import Scope
from cool import fetch_program

import os, sys

######################PARTIVULAR TEST################################
program = r"""
class A {
    f() : Object {
        {
            -- valid
            while 1=1 loop 1 pool;
            while 1=1 loop while 2=2 loop 2 pool pool;
        }
    };
};

class Main {
	main() : Int {
		1
	};
};
"""

pp = preprocess.preprocess_program(program)
parser = Lark(grammar.grammar, start='program')
tree = parser.parse(pp)
print(tree.pretty())
trans = ToCoolASTTransformer()
ast = trans.transform(tree)
cs = CheckSemanticsVisitor()
errors = []
scope = Scope()
result = cs.visit(ast,scope, errors)
if not result:
    for e in errors:
        print(e)

#####################################################################

# def compile(parser, program, exception_on_syntax=False):
    
#     try:
#         preprocessed = preprocess.preprocess_program(program)
#         try:
#             tree = parser.parse(preprocessed)
#             ast = ToCoolASTTransformer().transform(tree)
#             checkSemanticVisitor = CheckSemanticsVisitor()
#             scope = Scope()
#             errors = []
#             t = checkSemanticVisitor.visit(ast, scope, errors)
#             return t, errors
#         except:
#             print('Syntax error!')
#             if exception_on_syntax:
#                 raise Exception("")
#             return False, []
#     except:
#         print('Error when preprocessing!')
#         if exception_on_syntax:
#                 raise Exception("")
#         return False, []

# def walk(dir, parser, exception_on_sintax=False):
#     for (curr_dir, sub_dirs, files) in os.walk(dir):
#         for f in files:
#             program = fetch_program(os.path.join(curr_dir,f))
#             print('===================================')
#             result, errors = compile(parser, program, exception_on_sintax)
#             if not result:
#                 for e in errors:
#                     print(e)
#                 print('On file %s'%(f))
#             else:
#                 print('%s: Succesfully compiled!'%(f))
#             print('===================================')

# if __name__ == '__main__':

#     parser = Lark(grammar.grammar, start='program')

#     if len(sys.argv) == 3 and sys.argv[1] == '-p':
#         program = fetch_program(sys.argv[2])
#         result, errors = compile(parser, program, True) #Cambiar a falso antes de entregar
#         if not result:
#             for e in errors:
#                 print(e)
#             print('On file %s'%(sys.argv[2]))
#         else:
#             print('%s: Succesfully compiled!'%(sys.argv[2]))

#     elif len(sys.argv) == 3 and sys.argv[1] == '-r':
#         walk(sys.argv[2], parser, False) #Cambiar a falso antes de entregar
#     elif len(sys.argv) == 1:
#         walk(os.path.join('.', 'test'), parser, False) #Cambiar a falso antes de entregar
#     else:
#         print("Usage: python test.py [<option> <path>]")
#         print()
#         print('Available options:')
#         print("-p: To compile a single file. <path> must be a the path of a file.")
#         print("-r: To compile all the files in a directory tree. <path> must be a the path of a directory.")
#         print()
#         print("When using without options all the files on directory tree rooted at './test' are compiled")





