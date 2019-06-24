import sys, os
sys.path.append(os.pardir)

from lark import Lark, Token
from parsing import grammar, cool_ast, preprocess
from parsing.cool_transformer import ToCoolASTTransformer
from checksemantic.checksemantics import CheckSemanticsVisitor
from checksemantic.scope import Scope
from cool import fetch_program
from code_gen.transpilator import codeVisitor
from code_gen.visitorMips import MIPS


def compile(parser, program, exception_on_syntax=False, CIL = False, SPIM = False):
    
    try:
        preprocessed = preprocess.preprocess_program(program)
        try:
            tree = parser.parse(preprocessed)
            ast = ToCoolASTTransformer().transform(tree)
            checkSemanticVisitor = CheckSemanticsVisitor()
            scope = Scope()
            errors = []
            t = checkSemanticVisitor.visit(ast, scope, errors)


            if t:
                try:
                    cv = codeVisitor()
                    cv.visit(ast)

                    #For static code
                    static_code = os.path.join(os.pardir, 'code_gen', 'staticMipsCode.s')
                    mips = MIPS(cv.code, cv.data, static_code)

                    code_lines = mips.generate()
                    return t, errors, code_lines
                except:
                    print('Error in translation to MIPS')
            return t, errors, []
        
        except:
            print('Syntax error!')
            if exception_on_syntax:
                raise Exception("")
            return False, [], []
    except:
        print('Error when preprocessing!')
        if exception_on_syntax:
                raise Exception("")
        return False, [], []

def walk(dir, parser, exception_on_sintax = False, SPIM = False):
    for (curr_dir, sub_dirs, files) in os.walk(dir):
        for f in files:
            program = fetch_program(os.path.join(curr_dir,f))
            #print(f)
            print('===================================')
            result, errors, mips_code = compile(parser, program, exception_on_sintax, False,)
            if not result:
                for e in errors:
                    print(e)
                print('On file %s'%(f))
            else:
                print('%s: Succesfully compiled!'%(f))
                if SPIM:
                    file_name = f[:f.index('.')] + '.s'
                    path = os.path.join('Output', file_name)
                    with open(path, 'w') as f:
                        f.write(mips_code)
            print('===================================')

if __name__ == '__main__':

    parser = Lark(grammar.grammar, start='program')

    if len(sys.argv) == 3 and sys.argv[1] == '-p':
        program = fetch_program(sys.argv[2])
        result, errors, mips_code = compile(parser, program, True) #Cambiar a falso antes de entregar
        if not result:
            for e in errors:
                print(e)
            print('On file %s'%(sys.argv[2]))
        else:
            print('%s: Succesfully compiled!'%(sys.argv[2]))
            file_name = sys.argv[2].split(os.sep)[-1]
            file_name = file_name[:file_name.index('.')] + '.s'
            path = os.path.join('Output', file_name)
            with open(path, 'w') as f:
                f.write(mips_code)

    elif len(sys.argv) == 3 and sys.argv[1] == '-r':
        walk(sys.argv[2], parser, True, True) #Cambiar a falso antes de entregar
    elif len(sys.argv) == 1:
        walk(os.path.join('.', 'test'), parser, False) #Cambiar a falso antes de entregar
    else:
        print("Usage: python test.py [<option> <path>]")
        print()
        print('Available options:')
        print("-p: To compile a single file. <path> must be a the path of a file.")
        print("-r: To compile all the files in a directory tree. <path> must be a the path of a directory.")
        print()
        print("When using without options all the files on directory tree rooted at './test' are compiled")





