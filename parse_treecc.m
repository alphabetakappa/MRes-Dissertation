simulation           ::= Simulation mainblock initblock whereblock
mainblock            ::= Main recrelname [num]
recrelname           ::= Recrelname [char]
initblock            ::= Init [valdef]
whereblock           ::= Where [recreldef] 
valdef               ::= Valdef valname expression
valname              ::= Valnamedef [char]
recreldef            ::= Recreldef agentname funcname char [argname] expression
agentname            ::= Agentnamedef [char]
funcname             ::= Funcnamedef [char]
argname              ::= Argnamedef [char] | Argnumdef num
expression           ::= SimpleExpression simple_expression | WhereExpression simple_expression expr_whereblock
simple_expression    ::= Number num | Valname [char] | Argname [char] | Time char | Localvalname [char]
                         | List [listitem] | Bracketed simple_expression 
                         | Conditional simple_expression simple_expression simple_expression
                         | Binaryop simple_expression operation simple_expression
                         | Unaryop internop simple_expression
                         | Application recrelname [simple_expression]
                         | Localapplication localfuncname [simple_expression]
expr_whereblock      ::= Whereblock [localdefinition]
localdefinition      ::= Localvaldef localvalname expression | Localfuncdef localfuncname [argname] expression
localfuncname        ::= Localfuncnamedef [char]
localvalname         ::= Localvalnamedef  [char]
listitem             ::= Listitem simple_expression
internop             ::= Head | Tail | Not
operation            ::= Plus | Minus | Times | Divide | Lessthan | Greaterthan | Equals | Notequals | Lessthanorequalto 
                         | Greaterthanorequalto | Cons | Index
