from lark import Lark
import grammar

program = "class Main{ main():Int{ { v <- 4 + let t : Int <- 5 in t + 5; case v of s : Int => if true then 5 + 5 else 3 fi; esac; } } };"
parser = Lark(grammar.grammar, start='program')
print('PARSER CREATED')
tree = parser.parse(program)
print(tree.pretty())