Main
((outputs ! 3) ! 0) ! 0

Init
q = 4
k = 16

Where
_createlist f t = (f t):(_createlist f (t+1))
_createwrapper lists = (map hd lists) : (_createwrapper (map tl lists))

outputs =  _createwrapper [i_wrapperfun outputs,    j_wrapperfun outputs]

i_wrapperfun inputs = _createwrapper [i_f1_list]
                      where
                      i_f1_list = _createlist i_f1 0
                                  where
                                  i_f1 0 = q
                                  i_f1 t = (i_f1_list ! (t-1) ) + (((hd inputs) ! 1) ! 0)

j_wrapperfun inputs = _createwrapper [j_f1_list, j_f2_list]
                      where
                      j_f1_list = _createlist j_f1 0
                                  where
                                  j_f1 0 = k
                                  j_f1 t = if (t<0) then k else (25 + ((j_f1_list ! (t-1)) * (((hd inputs) ! 0) ! 0)) + (j_f2_lst ! (t-1)))
                      j_f2_list = _createlist j_f2 0
                                  where
                                  j_f2 0 = k+q
                                  j_f2 t = (j_f1_list ! (t-3)) + 27
