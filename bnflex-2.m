<localdefinitions>     ::= <localvaldef> <newline> |<localfuncdef> <newline>
                           | <localvaldef> <newline> <localdefinitions>
                           | <localfuncdef> <newline> <localdefinitions>
<localvaldef>          ::= <localvalname> <space> <equals> <space> <expression>
<localfuncdef>         ::= <localfuncname> <space> <args> <space> <equals> <space> <expression>
<expressions>          ::= <expression> | <expression> <space> <expressions>
<localfuncname>        ::= <underscore> <letters>
<localvalname>         ::= <underscore> <letters>
<list>                 ::= <lbracket> <rbracket> |<lbracket> <listitems> <rbracket>
<listitems>            ::= <simple_expression> |<simple_expression> <comma> <space> <listitems>
<lparenthesis>         ::=  '('
<rparenthesis>         ::=  ')'
<lbracket>             ::=  '['
<rbracket>             ::=  ']'
<comma>                ::=  ','
<internop>             ::= <head> | <tail> | <not>
<not>                  ::= '~'
<head>                 ::=  "hd"
<tail>                 ::=  "tl"
<number>               ::= <zero> | <posnumber> | <minus> <posnumber>
<posnumber>            ::= <firstdigit> <digits> | <firstdigit> <digits> <dot> <digits>
<firstdigit>           ::= '1' .. '9'
<digits>               ::= <digit> | <digit> <digits>
<dot>                  ::= '.'
<digit>                ::=  '0' .. '9'
<operation>            ::= <plus>
                           | <minus>
                           | <times>
                           | <divide>
                           | <lessthan>
                           | <greaterthan>
                           | <equals>
                           | <notequals>
                           | <lessthanorequalto>
                           | <greaterthanorequalto>
                           | <cons>
                           | <index>
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
