from lark import Lark
import grammar

program = r"""
    class Main{

        main():Int{
            {
                v <- 5;
            }
        }
    };
    """
parser = Lark(grammar.grammar, start='program')
tree = parser.parse(program)
print(tree.pretty())