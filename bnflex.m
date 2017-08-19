<simulation>           ::=  <mainblock> <newline> <initblock> <newline> <whereblock>
<mainblock>            ::=  <main> <newline><expression>
<initblock>            ::=  <init> | <init> <newline> <valdefinitions>
<whereblock>           ::=  <where> | <where> <newline>  <recreldefinitions>
<valdefinitions>       ::=  <valdef> <newline> | <valdef> <newline> <valdefinitions>
<valdef>               ::=  <valname> <space> <equals> <space> <expression>
<valname>              ::=  <letters>
<letters>              ::=  <letter> | <letter> <letters>
<letter>               ::= <lowercaseletter> | <uppercaseletter>
<lowercaseletter>      ::=  'a' .. 'z'
<uppercaseletter>      ::=  'A' .. 'Z'
<equals>               ::=  '='
<space>                ::=  ' '
<newline>              ::=  '\n'
<underscore>           ::=  '_'
<main>                 ::=  "main"
<init>                 ::=  "init"
<where>                ::=  "where"
<recreldefinitions>    ::=  <recreldef> <newline> | <recreldef> <newline> <recreldefinitions>
<recreldef>            ::= <newline>
                           | <recrelname> <space> <t> <space> <equals> <space> <expression>
                           | <recrelname> <space> <t> <space> <args> <space> <equals> <space> <expression>
<t>                    ::= 't'
<recrelname>           ::= <letters> <underscore> <letters> <letters>
<args>                 ::=  <argname> | <argname> <space> <args>
<argname>              ::= <letters> | <number> | <lparenthesis> <number> <rparenthesis>
<expression>           ::= <simple_expression> | <simple_expression> <expr_whereblock>
<simple_expression>    ::= <number>
                           | <valname>
                           | <argname>
                           | <localvalname>
                           | <list>
                           | <lparenthesis><simple_expression> <rparenthesis>
                           | <cond> <simple_expression> <simple_expression> <expression>
                           | <simple_expression><operation> <simple_expression>
                           | <internop> <expression>
                           | <recrelname> <expressions>
                           | <localfuncname> <expressions>
<expr_whereblock>      ::= <newline> <where> <newline> <localdefinitions> <newline> <endwhere> <newline>
<localdefinitions>     ::= <localvaldef> <newline> |<localfuncdef> <newline>
                           | <localvaldef><newline> <localdefinitions>
                           | <localfuncdef><newline> <localdefinitions>
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
<endwhere>             ::= "endwhere"
