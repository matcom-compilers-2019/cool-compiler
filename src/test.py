from lark import Lark, Token
from parsing import grammar, cool_ast, preprocess
from parsing.cool_transformer import ToCoolASTTransformer
from checksemantic.checksemantics import CheckSemanticsVisitor
from checksemantic.scope import Scope
from cool import fetch_program

import os, sys

######################PARTIVULAR TEST################################
# program = r"""
# (*
#  *  This file shows how to implement a list data type for lists of integers.
#  *  It makes use of INHERITANCE and DYNAMIC DISPATCH.
#  *
#  *  The List class has 4 operations defined on List objects. If 'l' is
#  *  a list, then the methods dispatched on 'l' have the following effects:
#  *
#  *    isNil() : Bool		Returns true if 'l' is empty, false otherwise.
#  *    head()  : Int		Returns the integer at the head of 'l'.
#  *				If 'l' is empty, execution aborts.
#  *    tail()  : List		Returns the remainder of the 'l',
#  *				i.e. without the first element.
#  *    cons(i : Int) : List	Return a new list containing i as the
#  *				first element, followed by the
#  *				elements in 'l'.
#  *
#  *  There are 2 kinds of lists, the empty list and a non-empty
#  *  list. We can think of the non-empty list as a specialization of
#  *  the empty list.
#  *  The class List defines the operations on empty list. The class
#  *  Cons inherits from List and redefines things to handle non-empty
#  *  lists.
#  *)


# class List {
#    -- Define operations on empty lists.

#    isNil() : Bool { true };

#    -- Since abort() has return type Object and head() has return type
#    -- Int, we need to have an Int as the result of the method body,
#    -- even though abort() never returns.

#    head()  : Int { { abort(); 0; } };

#    -- As for head(), the self is just to make sure the return type of
#    -- tail() is correct.

#    tail()  : List { { abort(); self; } };

#    -- When we cons and element onto the empty list we get a non-empty
#    -- list. The (new Cons) expression creates a new list cell of class
#    -- Cons, which is initialized by a dispatch to init().
#    -- The result of init() is an element of class Cons, but it
#    -- conforms to the return type List, because Cons is a subclass of
#    -- List.

#    cons(i : Int) : List {
#       (new Cons).init(i, self)
#    };

# };


# (*
#  *  Cons inherits all operations from List. We can reuse only the cons
#  *  method though, because adding an element to the front of an emtpy
#  *  list is the same as adding it to the front of a non empty
#  *  list. All other methods have to be redefined, since the behaviour
#  *  for them is different from the empty list.
#  *
#  *  Cons needs two attributes to hold the integer of this list
#  *  cell and to hold the rest of the list.
#  *
#  *  The init() method is used by the cons() method to initialize the
#  *  cell.
#  *)

# class Cons inherits List {

#    car : Int;	-- The element in this list cell

#    cdr : List;	-- The rest of the list

#    isNil() : Bool { false };

#    head()  : Int { car };

#    tail()  : List { cdr };

#    init(i : Int, rest : List) : List {
#       {
# 	 car <- i;
# 	 cdr <- rest;
# 	 self;
#       }
#    };

# };



# (*
#  *  The Main class shows how to use the List class. It creates a small
#  *  list and then repeatedly prints out its elements and takes off the
#  *  first element of the list.
#  *)

# class Main inherits IO {

#    mylist : List;

#    -- Print all elements of the list. Calls itself recursively with
#    -- the tail of the list, until the end of the list is reached.

#    print_list(l : List) : Object {
#       if l.isNil() then out_string("\n")
#                    else {
# 			   out_int(l.head());
# 			   out_string(" ");
# 			   print_list(l.tail());
# 		        }
#       fi
#    };

#    -- Note how the dynamic dispatch mechanism is responsible to end
#    -- the while loop. As long as mylist is bound to an object of 
#    -- dynamic type Cons, the dispatch to isNil calls the isNil method of
#    -- the Cons class, which returns false. However when we reach the
#    -- end of the list, mylist gets bound to the object that was
#    -- created by the (new List) expression. This object is of dynamic type
#    -- List, and thus the method isNil in the List class is called and
#    -- returns true.

#    main() : Object {
#       {
# 	 mylist <- (new List).cons(1).cons(2).cons(3).cons(4).cons(5);
# 	 while (not mylist.isNil()) loop
# 	    {
# 	       print_list(mylist);
# 	       mylist <- mylist.tail();
# 	    }
# 	 pool;
#       }
#    };

# };




# """

# pp = preprocess.preprocess_program(program)
# parser = Lark(grammar.grammar, start='program')
# tree = parser.parse(pp)
# print(tree.pretty())
# trans = ToCoolASTTransformer()
# ast = trans.transform(tree)
# cs = CheckSemanticsVisitor()
# errors = []
# scope = Scope()
# result = cs.visit(ast,scope, errors)
# if not result:
#     for e in errors:
#         print(e)
#####################################################################

def compile(parser, program, exception_on_syntax=False):
    
    try:
        preprocessed = preprocess.preprocess_program(program)
        try:
            tree = parser.parse(preprocessed)
            ast = ToCoolASTTransformer().transform(tree)
            checkSemanticVisitor = CheckSemanticsVisitor()
            scope = Scope()
            errors = []
            t = checkSemanticVisitor.visit(ast, scope, errors)
            return t, errors
        except:
            print('Syntax error!')
            if exception_on_syntax:
                raise Exception("")
            return False, []
    except:
        print('Error when preprocessing!')
        if exception_on_syntax:
                raise Exception("")
        return False, []

def walk(dir, parser, exception_on_sintax=False):
    for (curr_dir, sub_dirs, files) in os.walk(dir):
        for f in files:
            program = fetch_program(os.path.join(curr_dir,f))
            print('===================================')
            result, errors = compile(parser, program, exception_on_sintax)
            if not result:
                for e in errors:
                    print(e)
                print('On file %s'%(f))
            else:
                print('%s: Succesfully compiled!'%(f))
            print('===================================')

if __name__ == '__main__':

    parser = Lark(grammar.grammar, start='program')

    if len(sys.argv) == 3 and sys.argv[1] == '-p':
        program = fetch_program(sys.argv[2])
        result, errors = compile(parser, program, True) #Cambiar a falso antes de entregar
        if not result:
            for e in errors:
                print(e)
            print('On file %s'%(sys.argv[2]))
        else:
            print('%s: Succesfully compiled!'%(sys.argv[2]))

    elif len(sys.argv) == 3 and sys.argv[1] == '-r':
        walk(sys.argv[2], parser, False) #Cambiar a falso antes de entregar
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





