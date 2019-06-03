from lark import Lark

#TODO: Do something about lalr thing

grammar = r"""
    program : class_list

    class_list : (cls)+

    ?cls : simple_cls | descendant_cls
    
    descendant_cls : CLASS TYPE INHERITS TYPE "{" class_body "}"";"   
    simple_cls : CLASS TYPE "{" class_body "}"";"
    
    ?class_body : feature_list

    feature_list : feature*
    ?feature : attr | method
    
    attr : CLASS_BODY_ID ":" TYPE ["<""-"expr]";"//
    
    method : CLASS_BODY_ID "("decl_params")" ":" TYPE "{" expr "};"//
    decl_params : (decl_param)?("," decl_param)*
    decl_param : CNAME ":" TYPE

    assignment : CNAME "<""-" expr//
    
    ?expr :   decl 
            | assignment 
            | new 
            | calc

    ?calc :   expr "<" expr -> less 
            | expr "=" expr -> eq 
            | expr "<""=" expr -> leq
            | expr ">" expr -> g
            | expr ">""=" expr -> ge
            | calc_atom
    
    ?calc_atom :    "("expr")"
                  | arithmetic
                  | string
                  | atom


    ?arithmetic : ar | larithm

    ?larithm :  ar "+" lterm -> lplus 
        | ar "-" lterm -> lminus 
        | lterm
    
    ?lterm : term "*" latom -> ltimes 
        | term "/" latom -> ldiv 
        | latom
    
    ?latom : "~"latom -> neglet
        | let

    ?ar : ar "+" term -> plus 
        | ar "-" term -> minus 
        | term
    
    ?term : term "*" factor -> times
        | term "/" factor -> div 
        | factor
    
    ?factor: "~"factor -> neg 
        | num_atom
    
    conditional : IF expr THEN expr ELSE expr FI//

    loop : WHILE calc LOOP expr POOL//
    
    case : CASE expr OF branches ESAC//
    branches : (branch)+
    branch :  ID ":" TYPE "="">" expr ";" //

    ?atom : boolean_atom  | loop  | SELF -> self
    ?num_atom : SIGNED_NUMBER -> number | ID -> id | "("arithmetic")" -> braces | dispatch | case | conditional | block 
    ?boolean_atom : TRUE -> true | FALSE -> false | NOT calc -> notx | isvoid
    
    isvoid : ISVOID expr
    ?new : NEW TYPE
    block : "{" (expr";")+ "}"
    
    let : LET decl_list IN expr
    decl_list : decl("," decl)*
    decl : CNAME ":" TYPE ["<""-" expr]

    ?dispatch : point_dispatch | short_dispatch | parent_dispatch
    point_dispatch : calc_atom"."CNAME func_params
    short_dispatch : CLASS_BODY_ID func_params
    parent_dispatch : calc_atom"@"TYPE"."CNAME func_params

    func_params : "(" [expr(","expr)*] ")"

    string : ESCAPED_STRING

    CLASS_BODY_ID : LCASE_LETTER(LETTER|DIGIT|"_")*
    TYPE : UCASE_LETTER(CNAME|DIGIT|"_")*
    ID : (LETTER)(LETTER|DIGIT|"_")*
    
    CLASS : "$$$class"
    ELSE : "$$$else"
    FALSE : "$$$false"
    FI : "$$$fi"
    IF : "$$$if"
    IN : "$$$in"
    INHERITS : "$$$inherits"
    ISVOID : "$$$isvoid"
    LET : "$$$let"
    LOOP : "$$$loop"
    POOL : "$$$pool"
    THEN : "$$$then"
    WHILE : "$$$while"
    CASE : "$$$case"
    ESAC : "$$$esac"
    NEW : "$$$new"
    OF : "$$$of"
    NOT : "$$$not"
    TRUE : "$$$true"
    SELF :  "$$$self"

    

    %import common.ESCAPED_STRING
    %import common.CNAME
    %import common.LCASE_LETTER
    %import common.UCASE_LETTER
    %import common.LETTER
    %import common.SIGNED_NUMBER
    %import common.DIGIT
    %import common.WS
    %ignore WS
    
"""