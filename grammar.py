from lark import Lark

grammar = r"""
    ?program : [class_list] main_class [class_list]

    class_list : (class)+
    class : "c""l""a""s""s" TYPE ["i""n""h""e""r""i""t""s" TYPE] "{" class_body "}"";"
    ?class_body : feature_list

    main_class : "c""l""a""s""s" "M""a""i""n" "{" main_feature_list "}"";"

    main_feature_list :  main_method 
    main_method : "m""a""i""n""("")"":""I""n""t""{" method_body "}"

    feature_list : (feature)*
    ?feature : attr | method
    
    attr : CLASS_BODY_ID ":" TYPE ["<""-"expr]";"
    
    method : CLASS_BODY_ID "("decl_params")" ":" TYPE "{" method_body "}"
    decl_params : (decl_param)*
    decl_param : CNAME ":" TYPE
    ?method_body : expr
    
    expr_list : (expr)+

    ?expr : assignment
         | calc
         | conditional
         | loop
         | new

    assignment : CNAME "<""-" expr
    
    ?calc : arithm "<" larithm -> less | arithm "=" larithm -> eq | arithm "<""=" larithm -> leq | arithm | larithm

    ?arithm : arithm "+" term -> plus | arithm "-" term -> minus| term
    ?term : term "*" num_atom -> times| term "/" num_atom -> div| num_atom

    ?larithm : arithm "+" lterm -> lplus | arithm "-" lterm -> lminus | lterm
    ?lterm : lterm "*" let -> ltimes | lterm "/" let -> ldiv | let
    
    conditional : "i""f" calc "t""h""e""n" expr "e""l""s""e" expr "f""i"

    loop : "w""h""i""l""e" calc "l""o""o""p" expr "p""o""o""l"
    
    case : "c""a""s""e" expr "o""f" branches "e""s""a""c"
    branches : (branch)+
    branch : CNAME ":" TYPE "="">" expr ";" 

    ?atom : num_atom | boolean_atom | dispatch
    ?num_atom : SIGNED_NUMBER -> number | CNAME | "("calc")" | "~"calc | case | block | isvoid 
    ?boolean_atom : "true" -> true | "false" -> false | "not" expr -> not
    
    isvoid : "i""s""v""o""i""d" expr
    new : "n""e""w" TYPE
    block : "{" (expr";")+ "}"
    
    let : "l""e""t" decl_list "i""n" expr
    decl_list : decl("," decl)*
    decl : CNAME ":" TYPE ["<""-" expr]

    dispatch : point_dispatch | short_dispatch | parent_dispatch
    point_dispatch : expr"."CNAME"("func_params")"
    short_dispatch : CNAME"("func_params")"
    parent_dispatch : expr"@"TYPE"."CNAME"("func_params")"

    func_params : expr[","expr]*

    CLASS_BODY_ID : LCASE_LETTER[CNAME]
    TYPE : UCASE_LETTER[CNAME]

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