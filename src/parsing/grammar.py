from lark import Lark

#TODO: Encontrar la forma de quitar los keywords de los id disponibles y asi poder agregar variables a la produccion 'calc'.

grammar = r"""
    program : class_list

    class_list : (cls)+
    ?cls : simple_cls | descendant_cls
    descendant_cls : CLASS TYPE INHERITS TYPE "{" class_body "}"";"
    simple_cls : CLASS TYPE "{" class_body "}"";"
    ?class_body : feature_list

    feature_list : feature*
    ?feature : attr | method
    
    attr : CLASS_BODY_ID ":" TYPE ["<""-"expr]";"
    
    method : CLASS_BODY_ID "("decl_params")" ":" TYPE "{" expr "}"
    decl_params : (decl_param)?("," decl_param)*
    decl_param : CNAME ":" TYPE

    ?expr : decl 
         | assignment
         | calc
         | conditional
         | loop
         | new
         | string

    assignment : CNAME "<""-" expr
    
    ?calc : ar "<" ar -> less | ar "=" ar -> eq | ar "<""=" ar -> leq | ar
    ?ar : arithm | larithm

    ?arithm : arithm "+" term -> plus | arithm "-" term -> minus | term
    ?term : term "*" atom -> times| term "/" atom -> div | atom

    ?larithm : arithm "+" lterm -> lplus | arithm "-" lterm -> lminus | lterm
    ?lterm : term "*" latom -> ltimes | lterm "/" latom -> ldiv | latom
    ?latom : "~"latom -> neglet | let 
    
    conditional : IF calc THEN expr ELSE expr FI

    loop : WHILE calc LOOP expr POOL
    
    case : CASE expr OF branches ESAC
    branches : (branch)+
    branch :  CNAME ":" TYPE "="">" expr ";" 

    ?atom : num_atom | boolean_atom | dispatch
    ?num_atom : SIGNED_NUMBER -> number | CNAME -> id | "("calc")" -> braces | "~"num_atom -> neg | case | block | isvoid 
    ?boolean_atom : TRUE -> true | FALSE -> false | NOT expr -> notx
    
    //ID : /^(?!.*("c""l""a""s""s"|"i""f"|"t""h""e""n"|"e""l""s""e"|"f""i"|"c""a""s""e"|"o""f"|"e""s""a""c"|"l""e""t"|"i""n"|"t""r""u""e"|"f""a""l""s""e"|"i""n""h""e""r""i""t""s"|"i""s""v""o""i""d"|"l""o""o""p"|"p""o""o""l"|"w""h""i""l""e"|"n""o""t"|"s""e""l""f"|"n""e""w")).*$/
    
    isvoid : ISVOID expr
    ?new : NEW TYPE
    block : "{" (expr";")+ "}"
    
    let : LET decl_list IN expr
    decl_list : decl("," decl)*
    decl : CNAME ":" TYPE ["<""-" expr]

    ?dispatch : point_dispatch | short_dispatch | parent_dispatch
    point_dispatch : expr"."CNAME"("func_params")"
    short_dispatch : CNAME"("func_params")"
    parent_dispatch : expr"@"TYPE"."CNAME"("func_params")"

    func_params : (expr)?(","expr)*

    string : ESCAPED_STRING

    CLASS_BODY_ID : LCASE_LETTER[CNAME]
    TYPE : UCASE_LETTER[CNAME]
    
    CLASS : "class"
    ELSE : "else"
    FALSE : "false"
    FI : "fi"
    IF : "if"
    IN : "in"
    INHERITS : "inherits"
    ISVOID : "isvoid"
    LET : "let"
    LOOP : "loop"
    POOL : "pool"
    THEN : "then"
    WHILE : "while"
    CASE : "case"
    ESAC : "esac"
    NEW : "new"
    OF : "of"
    NOT : "not"
    TRUE : "true"
    SELF :  "self"

    

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