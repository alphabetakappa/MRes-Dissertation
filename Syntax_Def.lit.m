simulation ::= Simulation [definition] experiment

definition ::= [expression] recrel

recrel ::= Function [char] [char] [argument] expression

argument::= Argument expression

experiment::= Experiment [initcon] experimentrun

initcon::= Initcon [char] expression

experimentrun::= Emptyrun|Experimentrun expression

expression::= Emptyexpression
              |Ifthenelse expression expression expression
              |Brackets expression
              |List [expression]
              |Operation expression op expression
              |IntFunct [char] [argument]
              |ExtFunct [char] [char] [argument]
              |IntVar [char]
              |ExVar [char] [argument]
              |Specialfunc specfunc expression
              |Number num
              |Where expression [subdefinition]

op::= Plus
      |Minus
      |Multiply
      |Divide
      |Lessthan
      |Greaterthan
      |Equals
      |Notequals
      |Lessequ
      |Greaterequ
      |Listadd
      |Bang

specfunc::= Listhead|Listtail

subdefinition ::= IntVariable [char] expression |  IntFunction [char] [argument] expression
