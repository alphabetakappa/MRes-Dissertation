<simulation> ::= ``Simulation'' [<definition>] <experiment>

<definition> ::= ``Function'' [<letter>] [<letter>] [<argument>] <expression>

<argument> ::= ``Argument'' <expression>

<experiment> ::= ``Experiment'' [<initcon>] <experimentrun>

<initcon> ::= ``Initcon'' [<letter>] <expression>

<experimentrun> ::= ``Emptyrun'' | ``Experimentrun'' <expression>

<expression> ::= ``Emptyexpression''
              |<expression> <expression> <expression>
              |``Brackets'' <expression>
              |``List'' [<expression>]
              |``Operation'' <expression> <op> <expression>
              |``IntFunct'' [<letter>] [<argument>]
              |``ExtFunct'' [<letter>] [<letter>] [<argument>]
              |``IntVar'' [<letter>]
              |``ExVar'' [<letter>] [<argument>]
              |``Specialfunc'' <specfunc> <expression>
              |``Number'' <number>
              |``Where'' <expression> [<subdefinition>]

<op> ::= ``+''
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

<specfunc> ::= ``hd'' | ``tl''

<subdefinition> ::= ``IntVariable'' [<letter>] <expression> |  ``IntFunction'' [<letter>] [<argument>] <expression>

<letter> ::= any lower or upper case letter

<number> ::= any number
