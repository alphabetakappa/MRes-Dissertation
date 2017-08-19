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
<expr_whereblock>      ::= <newline><spaces n><where><newline><localdefinitions n><newline>
<spaces 1>             ::= <space>
<spaces n>             ::= <space><spaces n-1>
<localdefinitions n>   ::= <spaces n><localvaldef> <newline> | <spaces n><localfuncdef> <newline>
                           | <spaces n> <localvaldef> <newline> <localdefinitions n>
                           | <spaces n> <localfuncdef> <newline> <localdefinitions n>
