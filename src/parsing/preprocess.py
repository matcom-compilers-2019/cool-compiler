
keywords = [
    "class",
    "else",
    "false",
    "fi",
    "if",
    "in",
    "inherits",
    "isvoid",
    "let",
    "loop",
    "pool",
    "then",
    "while",
    "case",
    "esac",
    "new",
    "of",
    "not",
    "true",
    "self"
]

def next_word(program, idx):
    i = idx
    word = ""
    while i < len(program) and not program[i] in [':',';',',','.','(',')','{','}','[',']','@','<','>','=','-','+',' ','*','/', '\n','\t','~']:
        word += program[i]
        i += 1
    if word == "" and i < len(program):
        word = program[i]
        i += 1
    return word, i

def add__(keyword):
    return "$$$"+keyword

def preprocess_program(program):
    """
    Points the keywords and remove single line comments.
    """
    i = 0
    new_program = ""
    while i < len(program):
        word, i = next_word(program, i)
        if word in keywords:
            new_program += add__(word)
        #Remove single line comments
        elif word == '-':
            w, i2 = next_word(program, i)
            if w == '-':
                while w != '\n' and i2 < len(program):
                    w, i2 = next_word(program, i2)
                i = i2
            else:
                new_program += word
        elif word == '(':
            w, i2 = next_word(program, i)
            if w == '*':
                while i2 < len(program):
                    w, i2 = next_word(program, i2)
                    if w == '*':
                        w, i2 = next_word(program, i2)
                        if w == ')':
                            break
                i = i2
            else:
                new_program += word
        else:
            new_program += word
    return new_program

if __name__ == '__main__':
    print(preprocess_program(r"""
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
"""))