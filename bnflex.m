<simulation>  ::= <mainblock> <newline> <initblock> <newline> <whereblock>
<mainblock>   ::= <main> <expressions>
<initblock>   ::= <init> <expressions>
<whereblock>  ::= <where> <recrels> | <where> <expressions>
<expressions> ::= <expression> | <expression> <expressions>
<recrels>     ::= <recrel> | <recrel> <recrels>
<letters>     ::= <letter> | <letter> <letters>
<number>      ::= <digit> | <digit> <number>
<expression>  ::= <cond> <expression> <expression> <expression>
                | <brackets>
                | <list>
                | <expression> <operation> <expression>
                | <function>
                | <variable>
                | <internop> <expression>
                | <number>
                | <whereblock>
<main>        ::= ``main\n''
<init>        ::= ``init\n''
<whereblock>  ::= ``where\n''
<recrel>      ::= <letters> ``_'' <letters>
<letter>      ::= `a' .. 'z' | `A' .. `Z'
<cond>        ::= ``cond ''
<brackets>    ::= ``('' <expression> ``)''
<list>        ::= ``['' <expression>``]''
                | ``['' <expression> ``,'' <list>
                | <expression> ``,''
                | <expression> ``]''
<operation>   ::= ``+''
                | ``-''
                |``+''
                |``-''
                |``*''
                |``/''
                |``<''
                |``>''
                |``=''
                |``~=''
                |``<=''
                |``>=''
                |``:''
                |``!''
<function>    ::= `_' <letters> | `_' <letters> <expressions> | `_' <letters> <expressions> `=' <expression>
<variable>    ::= <letters> | <letters> `=' <expression>
<internop>    ::= ``hd'' | ``tl''
<digit>       ::= `0' .. `9'
<newline>     ::= `\n'
