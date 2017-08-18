||Lexer
||Reads in the file and converts it to tokens

lexeme::=Init|Var [char]|Recrel [char] [char]|Cond|Main|Fwhere|Optl|Ophd|Intfunc [char]|Num num|Opcon|Opbng|Opdiv|Optim|Opmin|Opplus|Rbckt|Lbckt|Rlbkt|Llbkt|Opequ|Opne|Oplt|Opgt|Oplet|Opget|Concomma|nl


lex []             = []
lex ('>':'=':xs)   = Opget:(lex xs)
lex ('<':'=':xs)   = Oplet:(lex xs)
lex ('>':xs)       = Opgt:(lex xs)
lex ('<':xs)       = Oplt:(lex xs)
lex ('~':'=':xs)   = Opne:(lex xs)
lex ('=':xs)       = Opequ:(lex xs)
lex ('[':xs)       = Llbkt:(lex xs)
lex (']':xs)       = Rlbkt:(lex xs)
lex ('(':xs)       = Lbckt:(lex xs)
lex (')':xs)       = Rbckt:(lex xs)
lex ('+':xs)       = Opplus:(lex xs)
lex ('-':xs)       = Opmin:(lex xs)
lex ('*':xs)       = Optim:(lex xs)
lex ('/':xs)       = Opdiv:(lex xs)
lex ('!':xs)       = Opbng:(lex xs)
lex (' ':xs)       = lex xs
lex ('\n':xs)      = nl:lex xs
lex (',':xs)       = Concomma:(lex xs)
lex (':':xs)       = Opcon:(lex xs)
lex (x:xs)         = (Num (numval a)): (lex b), if (isnumber a)
                   = (Intfunc (tl a)):(lex b), if (hd a) = '_'
                   = Ophd:(lex b), if a=['h','d']
                   = Optl:(lex b), if a=['t','l']
                   = Fwhere:(lex b), if a=['w','h','e','r','e']
                   = Main:(lex b), if a=['m', 'a', 'i', 'n']
                   = Cond:(lex b), if a=['c','o','n','d']
                   = (returnfunc a []):(lex b), if (isfunc a)
                   = (Var a):(lex b), otherwise
                     where
                     (a,b)=f (x:xs) []
                     f []        a = (a,[])
                     f (' ':xs)  a = (a,xs)
                     f (')':xs)  a = (a,(')':xs))
                     f (',':xs)  a = (a,(',':xs))
                     f ('+':xs)  a = (a,('+':xs))
                     f ('-':xs)  a = (a,('-':xs))
                     f ('*':xs)  a = (a,('*':xs))
                     f ('/':xs)  a = (a,('/':xs))
                     f ('<':xs)  a = (a,('<':xs))
                     f ('>':xs)  a = (a,('>':xs))
                     f ('=':xs)  a = (a,('=':xs))
                     f (']':xs)  a = (a,(']':xs))
                     f (':':xs)  a = (a,(':':xs))
                     f ('{':xs)  a = (a,('{':xs))
                     f ('}':xs)  a = (a,('}':xs))
                     f ('\n':xs) a = (a,xs)
                     f (x:xs)    a = f xs (a++[x])

isnumber x = (removeall "0123456789." (mkset x)) = []

removeall xs []     = []
removeall xs (y:ys) = removeall xs ys, if member xs y
                    = y:(removeall xs ys), otherwise

isfunc [] = False
isfunc ('_':xs) = True
isfunc (x:xs) = isfunc xs

beforescore []       a = a
beforescore ('_':xs) a = a
beforescore (x:xs)   a = beforescore xs (a++[x])

returnfunc []       a = Recrel a []
returnfunc ('_':xs) a = Recrel a xs
returnfunc (x:xs)   a = returnfunc xs (a++[x])













||Parse tree
||Stores the structure of the inputted file


simulation ::= Simulation [definition] experiment

definition ::= Function [char] [char] [argument] expression

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
































||Parser
||This turns the tokens into the parse tree

parser x = Simulation (get_defs a []) (get_exprement b c)
           Where
           a = find_recrel x
           b = find_intial x
           c = find_exp x

find_recrel (Fwhere:y) = y
find_recrel (z:y)      = find_recrel y

find_intial (Init:y) = find_intial1 y []
find_intial (z:y)    = find_intial y

find_intial1 (Fwhere:y) list = list
find_intial1 (z:y)      list = find_intial1 y (list++[z])

find_exp (Main:y) = find_exp1 y []
find_exp (z:y)    = find_exp y

find_exp1 (Init:y) list = list
find_exp1 (z:y)    list = find_exp1 y (list++[z])




get_defs []      deflist = deflist
get_defs unedefs deflist = get_defs newundefs newdeflist
                           where
                           newundefs = b
                           newdeflist = deflist ++ [a]
                           a = gd_fd unedefs


gd_fd ((Recrel a b):xs) = Function a b args expr
                          where
                          (args, rest1) = get_args xs []
                          exstuff = after_equals rest1
                          (expr, none) = get_expr exstuff Emptyexpression



get_args (nl:xs)       args = (args, xs)
get_args (Rbckt:xs)    args = (args, xs)
get_args (Opequ:xs)    args = (args, xs)
get_args (Concomma:xs) args = (args, xs)
get_args x             args = get_args new_x new_args
                              where
                              new_args = args++[arg]
                              (arg, new_x) = get_expr x Emptyexpression







get_expr x                 Emptyexpression = (new_a, new_xs), if istherewhere x
                                             where
                                             (bwhere, awhere) = wheresplitter x []
                                             (inter_where, new_xs) = get_wherestate awhere []
                                             (mid_a, none) = get_expression bwhere Emptyexpression
                                             new_a = Where mid_a inter_where
get_expr (Cond:xs)         Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = (Ifthenelse expr1 expr2 expr3)
                                             (expr1, xs1) = get_expr xs Emptyexpression
                                             (expr2, xs2) = get_expr xs1 Emptyexpression
                                             (expr3, new_xs) = get_expr xs2 Emptyexpression
get_expr (Lbckt:xs)        Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = Braclets expr
                                             (expr, rest) = get_expr in_bracket Emptyexpression
                                             (in_bracket, new_xs) = get_bracket xs []
get_expr (Llbkt:xs)        Emptyexpression = get_expr new_xs new_a
                                             where
                                             (listeditems, new_xs) = f xs []
                                             f (Llbkt:xs) a = (a, xs)
                                             f (Concomma:xs) a = f xs a
                                             f x a = f nn_xs nnn_a
                                                     where
                                                     (mid_a, nn_xs) = get_expr x Emptyexpression
                                                     nnn_a = a++[mid_a]
                                             new_a = List listeditems
get_expr ((Intfunc a):xs)  Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = IntFunct a args
                                             (args, new_xs) = get_args xs []
get_expr ((Recrel a b):xs) Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = ExtFunct a b args
                                             (args, new_xs) = get_args xs []
get_expr ((Var a):xs)      Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = IntVar a
                                             new_xs = xs
get_expr (Ophd:xs)         Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = (Specialfunc Listhead exp)
                                             (exp, new_xs) = get_expr xs Emptyexpression
get_expr (Optl:xs)         Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = (Specialfunc Listtail exp)
                                             (exp, new_xs) = get_expr xs Emptyexpression
get_expr ((Num a):xs)      Emptyexpression = get_expr new_xs new_a
                                             where
                                             new_a = Number a
                                             new_xs = xs
get_expr (x:xs)            a               = (a, (x:xs)), if isexprend x
                                           = get_expr new_xs new_a, otherwise
                                             where
                                             new_a = (Operation a (get_op x) mid_a)
                                             (mid_a, new_xs) = get_expr xs Emptyexpression


isexprend []          = True
isexprend (Opplus:xs) = False
isexprend (Opmin:xs)  = False
isexprend (Optim:xs)  = False
isexprend (Opdiv:xs)  = False
isexprend (Oplt:xs)   = False
isexprend (Opgt:xs)   = False
isexprend (Opequ:xs)  = False
isexprend (Opne:xs)   = False
isexprend (Oplet:xs)  = False
isexprend (Opget:xs)  = False
isexprend (Opcon:xs)  = False
isexprend (Opbng:xs)  = False
isexprend x           = True

get_op Opplus = Plus
get_op Opmin  = Minus
get_op Optim  = Multiply
get_op Opdiv  = Divide
get_op Oplt   = Lessthan
get_op Opgt   = Greaterthan
get_op Opequ  = Equals
get_op Opne   = Notequals
get_op Oplet  = Lessequ
get_op Opget  = Greaterequ
get_op Opcon  = Listadd
get_op Opbng  = Bang


wheresplitter (Fwhere:xs) a = (a, xs)
wheresplitter (x:xs)      a = wheresplitter xs (a++[x])


get_wherestate []                inwhere = (inwhere, [])
get_wherestate ((Recrel a b):xs) inwhere = (inwhere, ((Recrel a b):xs))
get_wherestate ((Var a):xs)      inwhere = get_wherestate new_xs new_inwhere
                                           where
                                           new_inwhere = inwhere ++ [sub_func]
                                           sub_func = IntVariable a expr
                                           (expr, new_xs) = get_expr lexs Emptyexpression
                                           lexs = get_aftereqs xs
get_wherestate ((Intfunc a):xs)  inwhere = get_wherestate new_xs new_inwhere
                                           where
                                           new_inwhere = inwhere ++ [sub_func]
                                           sub_func = IntFunction a args expr
                                           (args, rest) = get_args xs []
                                           (expr, new_xs) = get_expr lexs Emptyexpression
                                           lexs = get_aftereqs rest



get_aftereqs (Opequ:xs) = xs
get_aftereqs (x:xs)     = get_aftereqs xs




get_bracket (Lbckt:xs) a = get_bracket new_xs new_a
                           where
                           (new_a, new_xs) = get_innerbracket xs (a++[Lbckt])
get_bracket (Rbckt:xs) a = (a, xs)
get_bracket (x:xs)     a = get_bracket xs (a++[x])


get_innerbracket (Lbckt:xs) a = get_innerbracket new_xs new_a
                                where
                                (new_a, new_xs) = get_innerbracket xs (a++[Lbckt])
get_innerbracket (Rbckt:xs) a = ((a++[Rbckt]), xs)
get_innerbracket (x:xs)     a = get_innerbracket xs (a++[x])



get_exprement b c = Experiment intialcons exprun
                    where
                    exprun = Experimentrun exprsion
                    (exprsion, none) = get_expr c Emptyexpression
                    intialcons = get_inconlist b []

get_inconlist []                 itcons = itcons
get_inconlist ((Var a):Opequ:xs) itcons = get_inconlist new_x new_itcons
                                          where
                                          new_itcons = itcons ++[newit]
                                          newit = Initcon a expr
                                          (expr, new_x) = get_expr xs Emptyexpression







||first step translation


trans_step1 (Simulation defs expriment) = Simulation new_defs new_expirment
                                          where
                                          new_defs      = wrapdefs
                                          new_expirment = callexpermnet
                                          wrapdefs      = add_wdefs calldefs
                                          calldefs      = add_cdefs defs []
                                          callexpermnet = add_cexpem expriment





add_cexpem Experiment inits exprun = Experiment new_inits new_exprun
                                     where
                                     new_inits = add_initcalss inits []
                                     new_exprun = add_expcalls exprun

add_initcalss []                    ninits = ninits
add_initcalss ((Initcon a expr):xs) ninits = add_initcalss xs new_ninits
                                             where
                                             new_ninits = Initcon a new_expr
                                             new_expr = addcalls_exprions expr

add_expcalls (Experimentrun a) = Experimentrun new_a
                                 where
                                 new_a = addcalls_exprions a


add_cdefs [] ndefs = ndefs
add_cdefs (x:xs) ndefs = add_cdefs xs (ndefs++[new_x])
                         where
                         new_x = adddefcal x

adddefcal (Function a b c d) = Function a b new_c new_d
                               where
                               new_c = cargs c []
                               new_d = addcalls_exprions d





addcalls_exprions (Ifthenelse a b c) = Ifthenelse new_a new_b new_c
                                       where
                                       new_a = addcalls_exprions a
                                       new_b = addcalls_exprions b
                                       new_c = addcalls_exprions c
addcalls_exprions (Brackets a)       = Brackets new_a
                                       where
                                       new_a = addcalls_exprions a
addcalls_exprions (List a)           = List new_a
                                       where
                                       new_a = cargs a []
addcalls_exprions (Operation a b c) = Operation new_a b new_c
                                      where
                                      new_a = addcalls_exprions a
                                      new_c = addcalls_exprions c
addcalls_exprions (IntFunct a b)    = IntFunct a new_b
                                      where
                                      new_b = cargs b []
addcalls_exprions (ExtFunct a b c)  = Operation wrap Bang fstarg
                                      where
                                      wrap = ExtFunct a newb newc
                                      newb = b ++ "_list"
                                      newc = tl (cargs c [])
                                      fstarg = hd (cargs c [])
addcalls_exprions (IntVar a)        = IntVar a
addcalls_exprions (Specialfunc a b) = Specialfunc a new_b
                                      where
                                      new_b = addcalls_exprions b
addcalls_exprions (Number a)        = Number a
addcalls_exprions (Where a b)       = Where new_a new_b
                                      where
                                      new_a = addcalls_exprions a
                                      new_b = callssubdefs b []

cargs []     list = list
cargs (x:xs) list = cargs xs (list++[new_x])
                    where
                    new_x = addcalls_exprions x


callssubdefs [] newdefs = newdefs
callssubdefs ((IntVariable a b):xs) = callssubdefs xs nnewdefs
                                      where
                                      nnewdefs = newdefs ++ [ndef]
                                      ndef = IntVariable a new_b
                                      new_b = addcalls_exprions b
callssubdefs (( IntFunction a args b):xs) = callssubdefs xs nnewdefs
                                            where
                                            nnewdefs = newdefs ++ [ndef]
                                            ndef = IntFunction a new_args new_b
                                            new_args = cargs args []
                                            new_b = addcalls_exprions b







add_wdefs [] ndefs = ndefs
add_wdefs (x:xs) ndefs = add_wdefs nxs nnedfs
                         where
                         nndefs = addwrapper fx fun
                         (id1, id2) = getdefid x
                         fun = creatffunc (x:xs) [] (id1,id2)
                         fx = findfx fun

getdefid (Function a b c d) = (a, b)

creatffunc ((Function a b c d):xs) defl id = creatffunc xs ndefl
                                             where
                                             ndefl = defl++[(Function a b c d)], (a,b) = id
                                             ndefl = defl, otherwise

findfx ((Function a b c d):xs) = Function a b c d, if (hd c) = (IntVar "t")



addwrapper (Function a b c d) fun = Function a newb newc newd
                                    where
                                    newb = b ++ "_list"
                                    newc = tl c
                                    newd = Where exp subsdefs
                                    exp = IntFunct "createlist" [(ExtFunct a b newc), (Number 0)]
                                    subsdefs = creatldef:fun
                                    creatldef = IntFunction "createlist" [(IntFunct "f"), (IntVar "t")] log
                                    log = Operation (Brackets IntFunct "f" [IntVar "t"]) Listadd (IntFunct "createlist" [(IntFunct "f" []), (Brackets Operation (IntVar "t") Plus (Number 1))])
