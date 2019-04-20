from lark import Lark
#TODO: Encontrar la forma de quitar los keywords de los id disponibles y asi poder agregar variables a la produccion 'calc'.

grammar = r"""
    program : class_list

    class_list : (cls)+
    ?cls : simple_cls | descendant_cls
    descendant_cls : "c""l""a""s""s" TYPE "i""n""h""e""r""i""t""s" TYPE "{" class_body "}"";"
    simple_cls : "c""l""a""s""s" TYPE "{" class_body "}"";"
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
         | ar
         | atom
         | conditional
         | loop
         | new
         | string

    assignment : CNAME "<""-" expr
    
    ?calc : ar "<" ar -> less | ar "=" ar -> eq | ar "<""=" ar -> leq | boolean_atom
    ?ar : arithm | larithm

    ?arithm : arithm "+" term -> plus | arithm "-" term -> minus| term
    ?term : term "*" num_atom -> times| term "/" num_atom -> div| num_atom

    ?larithm : arithm "+" lterm -> lplus | arithm "-" lterm -> lminus | lterm
    ?lterm : term "*" latom -> ltimes | lterm "/" latom -> ldiv | latom
    ?latom : "~"latom -> neglet | let 
    
    conditional : "i""f" calc "t""h""e""n" expr "e""l""s""e" expr "f""i"

    loop : "w""h""i""l""e" calc "l""o""o""p" expr "p""o""o""l"
    
    case : "c""a""s""e" expr "o""f" branches "e""s""a""c"
    branches : (branch)+
    branch : CNAME ":" TYPE "="">" expr ";" 

    ?atom : num_atom | boolean_atom | dispatch | printx | scan
    ?num_atom : SIGNED_NUMBER -> number | CNAME -> id | "("calc")" -> braces | "~"num_atom -> neg | case | block | isvoid 
    ?boolean_atom : "t""r""u""e" -> true | "f""a""l""s""e" -> false | "n""o""t" expr -> notx
    
    printx : "p""r""i""n""t" expr
    scan : "s""c""a""n"
    isvoid : "i""s""v""o""i""d" expr
    new : "n""e""w" TYPE
    block : "{" (expr";")+ "}"
    
    let : "l""e""t" decl_list "i""n" expr
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

    %import common.ESCAPED_STRING
    %import common.CNAME
    %import common.LCASE_LETTER
    %import common.UCASE_LETTER
    %import common.SIGNED_NUMBER
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