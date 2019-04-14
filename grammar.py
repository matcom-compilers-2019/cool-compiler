from lark import Lark

grammar = r"""
    ?program : (class_list)* main_class (class_list)*

    class_list : (class)*
    class : "class" TYPE ["inherits" TYPE] "{" class_body "};"
    ?class_body : feature_list

    main_class : "class Main {" main_feature_list "};"
    main_feature_list : (feature_list)* main_method (feature_list)*
    main_method : "main():Int{" method_body "}"

    feature_list : (feature)*
    ?feature : attr | method
    
    attr : CLASS_BODY_ID ":" TYPE ["<""-"expr]";"
    
    method : CLASS_BODY_ID "("decl_params")" ":" TYPE "{" method_body "}"
    decl_params : (decl_param)*
    decl_param : CNAME ":" TYPE
    ?method_body : expr_list
    
    expr_list : (expr)+
    expr : assignment
         | arithm
         | conditional
         | loop
         | block
         | let
         | case
         | new
         | atom
         | isvoid
    
    assignment : CNAME "<-" expr
    
    isvoid : "isvoid" expr
    
    new : "new" TYPE

    arithm : term "+" arithm | term "-" arithm | term
    term : num_atom "*" arithm | num_atom "/" arithm | num_atom | dispatch

    conditional : "if" bool_expr "then" expr "else" expr "if"

    loop : "while" bool_expr "loop" expr "pool"
    
    bool_expr : boolean_atom "<" bool_expr | boolean_atom "<=" bool_expr | boolean_atom "=" bool_expr

    block : "{" (expr";")+ "}"

    let : "let" decl_list "in" expr
    decl_list : decl["," decl]*
    decl : CNAME ":" TYPE ["<-" expr]

    case : "case" expr "of" branches "esac"
    branches : (branch)+
    branch : CNAME ":" "TYPE" "=>" expr ";" 

    atom : num_atom | boolean_atom
    num_atom : SIGNED_NUMBER -> number | CNAME | "("arithm")" | "~"arithm
    boolean_atom : "true" -> true | "false" -> false | "not" bool_expr
    
    dispatch : point_dispatch | short_dispatch | parent_dispatch
    point_dispatch : expr"."CNAME"("func_params")"
    short_dispatch : CNAME"("func_params")"
    parent_dispatch : expr"@"TYPE"."CNAME"("func_params")"

    func_params : expr[","expr]*

    CLASS_BODY_ID : LCASE_LETTER[CNAME]
    TYPE : UCASE_LETTER[CNAME]

    %import common.CNAME
    %import common.LCASE_LETTER
    %import common.WS

    %ignore WS
    
"""

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
    "true"
]