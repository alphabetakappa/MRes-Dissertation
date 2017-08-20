<operation>            ::= <plus> | <minus> | <times> | <divide> | <lessthan> | <greaterthan> | <equals> | <notequals> | <lessthanorequalto> | <greaterthanorequalto> | <cons> | <index>
<indent 1>             ::= <space>
<indent n>             ::= <space> <indent n-1>
<letters>              ::= <letter> | <letter> <letters>
<letter>               ::= <lowercaseletter> | <uppercaseletter>
<digits>               ::= <digit> | <digit> <digits>
<main>                 ::= "main"
<init>                 ::= "init"
<where>                ::= "where"
<endwhere>             ::= "endwhere"
<firstdigit>           ::= '1' .. '9'
<digit>                ::= '0' .. '9'
<lowercaseletter>      ::= 'a' .. 'z'
<uppercaseletter>      ::= 'A' .. 'Z'
<equals>               ::= '='
<space>                ::= ' '
<newline>              ::= '\n'
<underscore>           ::= '_'
<lparenthesis>         ::= '('
<rparenthesis>         ::= ')'
<lbracket>             ::= '['
<rbracket>             ::= ']'
<comma>                ::= ','
<head>                 ::= "hd"
<tail>                 ::= "tl"
<not>                  ::= '~'
<dot>                  ::= '.'
<plus>                 ::= '+'
<minus>                ::= '-'
<times>                ::= '*'
<divide>               ::= '/'
<lessthan>             ::= '<'
<greaterthan>          ::= '>'
<notequals>            ::= "~="
<lessthanorequalto>    ::= "<="
<greaterthanorequalto> ::= ">="
<cons>                 ::= ':'
<index>                ::= '!'
<t>                    ::= 't'
