||Lexer
||Reads in the file and converts it to tokens

lexeme ::= Initl | Varl [char] | Recrell [char] [char] | Opcond | Mainl | Wherel | Optl | Ophd | Intfunc [char] | Numl num | Opcon | Opbng | Opdiv | Optim | Opmin | Opplus | Rbckt | Lbckt | Rlbkt | Llbkt | Opequ | Opne | Oplt | Opgt | Oplet | Opget | Concomma | Newl | Endwherel


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
lex ('\n':xs)      = Newl:lex xs
lex (',':xs)       = Concomma:(lex xs)
lex (':':xs)       = Opcon:(lex xs)
lex (x:xs)         = (Numl (numval a)): (lex b), if (isnumber a)
                   = (Intfunc (tl a)):(lex b), if (hd a) = '_'
                   = Ophd:(lex b), if a=['h','d']
                   = Optl:(lex b), if a=['t','l']
                   = Initl:(lex b), if a=['i','n','i','t']
                   = Endwherel:(lex b), if a=['e','n','d','w','h','e','r','e']
                   = Wherel:(lex b), if a=['w','h','e','r','e']
                   = Mainl:(lex b), if a=['m', 'a', 'i', 'n']
                   = Opcond:(lex b), if a=['c','o','n','d']
                   = (returnfunc a []):(lex b), if (isfunc a)
                   = (Varl a):(lex b), otherwise
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

returnfunc []       a = Recrell a []
returnfunc ('_':xs) a = Recrell a xs
returnfunc (x:xs)   a = returnfunc xs (a++[x])









||Parse tree
||Stores the structure of the inputted file


simulation           ::= Simulation mainblock initblock whereblock
mainblock            ::= Main expression ||recrelname [argname]
recrelname           ::= Recrelname [char]
initblock            ::= Init [valdef]
whereblock           ::= Where [recreldef]
valdef               ::= Valdef valname expression
valname              ::= Valnamedef [char]
recreldef            ::= Recreldef agentname funcname [argname] expression
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
operation            ::= Plus | Minus | Times | Divide | Lessthan | Greaterthan | Equals | Notequals | Lessthanorequalto | Greaterthanorequalto | Cons | Index










||Parser
||This turns the tokens into the parse tree

parser x = Simulation (get_main a) (get_init b) (get_lwhere c)
           where
           a = find_drive x []
           b = find_inits x
           c = find_rr x


find_drive (Initl:xs) dlist = dlist
find_drive (Mainl:xs) dlist = find_drive xs dlist
find_drive (x:xs)     dlist = find_drive xs (dlist++[x])

find_inits (Initl:xs) = find_initssub xs []
find_inits (x:xs)     = find_inits xs

find_initssub (Wherel:xs) ilist = ilist
find_initssub (x:xs)      ilist = find_initssub xs (ilist++[x])


find_rr (Wherel:xs) = xs
find_rr (x:xs)      = find_rr xs



get_main x = Main exp
             where
             (exp, none) = get_expr x

find_rrname ((Recrell a b):xs) = Recrelname (a++"_"++b)
find_rrname (x:xs)             = find_rrname xs

find_rrargs ((Recrell a b):xs) = find_rrnamesub xs []
find_rrargs (x:xs)             = find_rrargs xs

find_rrnamesub [] arglist = arglist
find_rrnamesub ((Numl a):xs) arglist = find_rrnamesub xs (arglist++[(Argnumdef a)])
find_rrnamesub ((Varl a):xs) arglist = find_rrnamesub xs (arglist++[(Argnamedef a)])



get_init x = Init (find_indefs x [])

find_indefs []                    dlist = dlist
find_indefs ((Varl a):(Opequ):xs) dlist = find_indefs nxs ndlist
                                          where
                                          ndlist = dlist ++ [ndef]
                                          ndef = Valdef (Valnamedef a) (expr)
                                          (expr, nxs) = get_expr xs


get_lwhere x = Where [Recreldef (Agentnamedef "a") (Funcnamedef "b") [] (SimpleExpression (Number 1))]||(find_rrlist x [])

find_rrlist []                 rrlist = rrlist
find_rrlist ((Recrell a b):xs) rrlist = find_rrlist nxs nrrlist
                                        where
                                        nrrlist = rrlist ++ [nrr]
                                        nrr = Recreldef (Agentnamedef a) (Funcnamedef b) args expr
                                        args = get_rrargs xs []
                                        (expr, nxs) = get_expr (get_aftequ xs)

get_aftequ (Opequ:xs) = xs
get_aftequ (x:xs)     = get_aftequ xs

get_rrargs (Opequ:xs)    arglist = arglist
get_rrargs ((Numl a):xs) arglist = get_rrargs xs (arglist++[(Argnumdef a)])
get_rrargs ((Varl a):xs) arglist = get_rrargs xs (arglist++[(Argnamedef a)])



get_expr x = ((WhereExpression outw inw), rest), if is_where x
           = ((SimpleExpression exp), rest), otherwise
             where
             outw = Number 1
             inw = Whereblock []
             (exp, rest) = get_exprision x (Number 0)


is_where []          = False
is_where (Wherel:xs) = True
is_where (x:xs)      = is_where xs






get_exprision ((Numl a):xs)      lst = get_exprision xs (Number a)
get_exprision ((Varl a):xs)      lst = get_exprision xs (Valname a)
get_exprision ((Llbkt):xs)       lst = get_exprision al (List il)
                                       where
                                       (il, al) = (find_list xs)
get_exprision ((Lbckt):xs)       lst = get_exprision ab epr
                                       where
                                       epr = Bracketed eib
                                       (eib, n) = get_exprision ib (Number 0)
                                       (ib, ab) = (find_inbr xs [])
get_exprision ((Opcond):xs)      lst = get_exprision r3 exp
                                       where
                                       exp = (Conditional fst snd trd)
                                       (fst, r1) = get_exprision xs (Number 0)
                                       (snd, r2) = get_exprision r1 (Number 0)
                                       (trd, r3) = get_exprision r2 (Number 0)
get_exprision ((Ophd):xs)        lst = get_exprision rest nlst
                                       where
                                       nlst = Unaryop Head ex
                                       (ex, rest) = get_exprision xs (Number 0)
get_exprision ((Optl):xs)        lst = get_exprision rest nlst
                                       where
                                       nlst = Unaryop Tail ex
                                       (ex, rest) = get_exprision xs (Number 0)
get_exprision ((Recrell a b):xs) lst = get_exprision rest nlst
                                       where
                                       nlst = Application (Recrelname (a++"_"++b)) args
                                       (args, rest) = (get_eargs xs [])
get_exprision ((Intfunc a):xs)   lst = get_exprision r1 nlst
                                       where
                                       nlst = Localapplication (Localfuncnamedef a) args
                                       (args, r1) = (get_eargs xs [])
get_exprision (x:xs)             lst = (oper, rest), if is_op (x:xs)
                                     = (lst, (x:xs)), otherwise
                                       where
                                       oper = Binaryop lst (find_op x) nexp
                                       (nexp, rest) = get_exprision xs (Number 0)


find_list x = (list, rest)
              where
              list = get_li inl [] []
              (inl, rest) = list_splitter x []

list_splitter (Rlbkt:xs) inl = (inl, xs)
list_splitter (x:xs)     inl = list_splitter xs (inl++[x])

get_li []            ce list = list
get_li (Concomma:xs) ce list = get_li xs [] nlist
                               where
                               nlist = list++[nnitem]
                               nnitem = Listitem nitem
                               (nitem, none) = get_exprision ce (Number 0)
get_li (x:xs)        ce list = get_li xs (ce++[x]) list



find_inbr (Rbckt:xs) inbrk = (inbrk, xs)
find_inbr (x:xs)     inbrk = find_inbr xs (inbrk++[x])


get_eargs (Rbckt:xs) args = (args, xs)
get_eargs x          args = get_eargs rest nargs
                            where
                            nargs = args ++[exp]
                            (exp, rest) = get_exprision x (Number 0)

is_op []          = False
is_op (Opplus:xs) = True
is_op (Opmin:xs)  = True
is_op (Optim:xs)  = True
is_op (Opdiv:xs)  = True
is_op (Oplt:xs)   = True
is_op (Opgt:xs)   = True
is_op (Opequ:xs)  = True
is_op (Opne:xs)   = True
is_op (Oplet:xs)  = True
is_op (Opget:xs)  = True
is_op (Opcon:xs)  = True
is_op (Opbng:xs)  = True
is_op x           = False



find_op Opplus = Plus
find_op Opmin  = Minus
find_op Optim  = Times
find_op Opdiv  = Divide
find_op Oplt   = Lessthan
find_op Opgt   = Greaterthan
find_op Opequ  = Equals
find_op Opne   = Notequals
find_op Oplet  = Lessthanorequalto
find_op Opget  = Greaterthanorequalto
find_op Opcon  = Cons
find_op Opbng  = Index



||first step translation


trans_step1 (Simulation mblock iblock wblock) = Simulation nmblk iblock nwblk
                                                where
                                                nwblk = add_wrapper cwblk
                                                cwblk = add_callsw wblock
                                                nmblk = add_callsm mblock

add_callsm (Main a) = Main na
                      where
                      na = add_expcall na

add_expcall (SimpleExpression a) = SimpleExpression na
                                   where
                                   na = addcalls_exprions a
add_expcall (WhereExpression a b) = WhereExpression na nb
                                    where
                                    na = addcalls_exprions a
                                    nb = addcalls_wl b

addcalls_wl (Whereblock defs) = Whereblock (adcalsdfs defs [])




adcalsdfs [] ndefs = ndefs
adcalsdfs ((Localvaldef vn exp):xs) ndefs = adcalsdfs xs nndfs
                                            where
                                            nndfs = ndefs++[nitem]
                                            nitem = Localvaldef vn (add_expcall exp)
adcalsdfs ((Localfuncdef vn arg exp):xs) ndefs = adcalsdfs xs nndfs
                                                 where
                                                 nndfs = ndefs++[nitem]
                                                 nitem = Localfuncdef vn  arg (add_expcall exp)



addcalls_exprions (Conditional a b c) = Conditional new_a new_b new_c
                                        where
                                        new_a = addcalls_exprions a
                                        new_b = addcalls_exprions b
                                        new_c = addcalls_exprions c
addcalls_exprions (Bracketed a)       = Bracketed new_a
                                        where
                                        new_a = addcalls_exprions a
addcalls_exprions (List a)           = List na
                                       where
                                       na = addcallslist a []
addcalls_exprions (Binaryop a b c)  = Binaryop new_a b new_c
                                      where
                                      new_a = addcalls_exprions a
                                      new_c = addcalls_exprions c
addcalls_exprions (Localapplication a b) = Localapplication a b
addcalls_exprions (Application a c) = Binaryop wrap Index fstarg
                                      where
                                      wrap = Application newb newc
                                      newb = changename a
                                      newc = tl (c)
                                      fstarg = hd (c)
addcalls_exprions (Valname a)       = Valname a
addcalls_exprions (Unaryop a b)     = Unaryop a new_b
                                      where
                                      new_b = addcalls_exprions b
addcalls_exprions (Number a)        = Number a




changename (Recrelname a) = Recrelname (a++"_list")

addcallslist []                  list = list
addcallslist ((Listitem exp):xs) list = addcallslist xs (list++[(Listitem (addcalls_exprions exp))])




add_callsw (Where x) = Where nx
                       where
                       nx = wlac x []

wlac [] list = list
wlac ((Recreldef a b c d):xs) list = wlac xs nlist
                                     where
                                     nlist = list++[(Recreldef a b c nd)]
                                     nd = add_expcall d

add_wrapper (Where x) = Where nx
                        where
                        nx = adfunwraps x []

adfunwraps []     list = list
adfunwraps (x:xs) list = adfunwraps xs (list++[(addwrap x)])

addwrap (Recreldef a b c d) = Recreldef a nb [] ne
                              where
                              nb = chngnme b
                              ne = makewrapexp a b c d

chngnme (Funcnamedef a) = Funcnamedef (a++"_list")

makewrapexp a b c d = WhereExpression exp defs
                      where
                      exp = Localapplication (Localfuncnamedef "_createlist") [Application nname [(Number 0)]]
                      nname = createname a b
                      defs = Whereblock (mdeflist nname c d)

createname (Agentnamedef a) (Funcnamedef b) = Recrelname (a++b)




mdeflist a   b c = [item1, item2]
                   where
                   item1 = Localfuncdef (Localfuncnamedef "_createlist") [(Argnamedef "f"), (Argnamedef "t")] exp1
                   exp1 = SimpleExpression lv1
                   lv1  = (Binaryop lv2 Cons lv3)
                   lv2 = (Localapplication (Localfuncnamedef "f") ([Valname "t"]))
                   lv3 = (Localapplication (Localfuncnamedef "_createlist") [Localapplication (Localfuncnamedef "f") [Binaryop (Valname "t") Plus (Number 1)]])
                   item2 = (Localfuncdef (Localfuncnamedef (unpack a)) b c)

unpack (Recrelname a) = a
