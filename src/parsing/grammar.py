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
    
    method : CLASS_BODY_ID "("decl_params")" ":" TYPE "{" expr "}"//
    decl_params : (decl_param)?("," decl_param)*
    decl_param : CNAME ":" TYPE

    assignment : CNAME "<""-" expr//
    ?expr : | decl 
            | assignment 
            | new 
            | string
            | calc

    ?calc :   ar "<" arithmetic -> less 
            | ar "=" arithmetic -> eq 
            | ar "<""=" arithmetic -> leq
            | ar ">" arithmetic -> g
            | ar ">""=" arithmetic -> ge
            | calc_atom
    
    ?calc_atom :  "("calc")"
                  | arithmetic
                  | atom


    ?arithmetic : ar | larithm

    ?ar : ar "+" term -> plus | ar "-" term -> minus | term
    ?term : term "*" num_atom -> times| term "/" num_atom -> div | num_atom

    ?larithm :  ar "+" latom -> lplus | ar "-" latom -> lminus | lterm
    ?lterm : term "*" latom -> ltimes | term "/" latom -> ldiv | latom
    ?latom : let | "~"latom -> neglet
    
    conditional : IF calc THEN calc ELSE calc FI//

    loop : WHILE calc LOOP expr POOL//
    
    case : CASE calc OF branches ESAC//
    branches : (branch)+
    branch :  CNAME ":" TYPE "="">" expr ";" //

    ?atom : boolean_atom  | loop  | SELF -> self 
    ?num_atom : SIGNED_NUMBER -> number | "~"num_atom -> neg | ID -> id | "("arithmetic")" -> braces | dispatch | case | conditional | block 
    ?boolean_atom : TRUE -> true | FALSE -> false | NOT calc -> notx | isvoid
    
    isvoid : ISVOID expr
    ?new : NEW TYPE
    block : "{" (expr";")+ "}"
    
    let : LET decl_list IN arithmetic
    decl_list : decl("," decl)*
    decl : CNAME ":" TYPE ["<""-" expr]

    ?dispatch : point_dispatch | short_dispatch | parent_dispatch
    point_dispatch : calc_atom"."CNAME func_params
    short_dispatch : CNAME func_params
    parent_dispatch : calc_atom"@"TYPE"."CNAME func_params

    func_params : "(" expr? (","expr)* ")"

    string : ESCAPED_STRING

    CLASS_BODY_ID : LCASE_LETTER[CNAME]
    TYPE : UCASE_LETTER[CNAME]
    ID : (LCASE_LETTER|UCASE_LETTER)[CNAME]
    
    CLASS : "_____class"
    ELSE : "_____else"
    FALSE : "_____false"
    FI : "_____fi"
    IF : "_____if"
    IN : "_____in"
    INHERITS : "_____inherits"
    ISVOID : "_____isvoid"
    LET : "_____let"
    LOOP : "_____loop"
    POOL : "_____pool"
    THEN : "_____then"
    WHILE : "_____while"
    CASE : "_____case"
    ESAC : "_____esac"
    NEW : "_____new"
    OF : "_____of"
    NOT : "_____not"
    TRUE : "_____true"
    SELF :  "_____self"

    

    %import common.ESCAPED_STRING
    %import common.CNAME
    %import common.LCASE_LETTER
    %import common.UCASE_LETTER
    %import common.SIGNED_NUMBER
    %import common.WS
    %ignore WS
    
"""

keywords = [
    
]