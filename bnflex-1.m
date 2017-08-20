<simulation>           ::= <mainblock> <newline> <initblock> <newline> <whereblock>
<mainblock>            ::= <main> <newline> <recrelname> <space> <numbers>
<numbers>              ::= <number> | <number> <space> <numbers>
<initblock>            ::= <init>    | <init> <newline> <valdefinitions>
<whereblock>           ::= <where> | <where> <newline> <recreldefinitions>
<valdefinitions>       ::= <valdef> <newline> | <valdef> <newline> <valdefinitions>
<valdef>               ::= <valname> <space> <equals> <space> <expression>
<valname>              ::= <letters>
<recreldefinitions>    ::= <recreldef> <newline> | <recreldef> <newline> <recreldefinitions>
<recreldef>            ::= <newline>
                           | <recrelname> <space> <t> <space> <equals> <space> <expression>
                           | <recrelname> <space> <t> <space> <args> <space> <equals> <space> <expression>
<recrelname>           ::= <letters> <underscore> <letters>
<args>                 ::= <argname> | <argname> <space> <args>
<argname>              ::= <letters> | <number> | <lparenthesis> <number> <rparenthesis>
<expression>           ::= <simple_expression> | <simple_expression> <expr_whereblock>
<simple_expression>    ::= <number>
                           | <valname>
                           | <argname>
                           | <t>
                           | <localvalname>
                           | <list>
                           | <lparenthesis> <simple_expression> <rparenthesis>
                           | <cond> <simple_expression> <simple_expression> <expression>
                           | <simple_expression> <operation> <simple_expression>
                           | <internop> <simple_expression>
                           | <recrelname> <simple_expressions>
                           | <localfuncname> <simple_expressions>
<expr_whereblock>      ::= <newline> <indent n> <where> <newline> <localdefinitions n> <newline> <indent n> <endwhere> <newline>
<localdefinitions n>   ::= <indent n> <localvaldef> <newline>
                           | <indent n> <localfuncdef> <newline>
                           | <indent n> <localvaldef> <newline> <localdefinitions n>
                           | <indent n> <localfuncdef> <newline> <localdefinitions n>
<localvaldef>          ::= <localvalname> <space> <equals> <space> <expression>
<localfuncdef>         ::= <localfuncname> <space> <args> <space> <equals> <space> <expression>
<simple_expressions>   ::= <simple_expression> | <simple_expression> <space> <simple_expressions>
<localfuncname>        ::= <underscore> <letters>
<localvalname>         ::= <underscore> <letters>
<list>                 ::= <lbracket> <rbracket> | <lbracket> <listitems> <rbracket>
<listitems>            ::= <simple_expression> | <simple_expression> <comma> <space> <listitems>
<internop>             ::= <head> | <tail> | <not>
<number>               ::= <zero> | <posnumber> | <minus> <posnumber>
<posnumber>            ::= <firstdigit> <digits> | <firstdigit> <digits> <dot> <digits>
