Main
sim_harness 3

Init
q = 4
k = 16

Where
_createlist f t = (f t):(_createlist f (t+1))
_createwrapper lists = (map hd lists) : (_createwrapper (map tl lists))
_createmsgwrapper lists = (map _tplhd lists) : (_createmsgwrapper (map _tpltl lists))
                          where
                          _tplhd (from, to, values) = (from, to, hd values)
                          _tpltl (from, to, values) = (from, to, tl values)
_createinput id outputs = (_getmsgs id (hd outputs) []):_createinput id (tl outputs)
                          where
                          _getmessages id []     msgs = msgs
                          _getmessages id (x:xs) msgs = _getmessages id xs (msgs++(_getsubmsgs x))
                                                        where
                                                        _getsubmsgs []                     id submsgs = submsgs
                                                        _getsubmsgs ((from, to, value):xs) id submsgs = if (to = id) then (_getsubmsgs xs id (submsgs++[(from, to, value)])) else (_getsubmsgs xs id submsgs)
_getvalue (from, to, value) = value


sim_harness t = return
                where
                return  = _createinput 0 outputs
                outputs =  _createwrapper [i_wrapperfun (inputs ! 0), j_wrapperfun (inputs ! 1)]
                inputs  = [_createinput 1 outputs, _createinput 2 outputs]

i_wrapperfun inputs = _createmsgwrapper [(1, 2, i_f1_list), (1, 0, i_f1_list)]
                      where
                      i_f1_list = _createlist i_f1 0
                                  where
                                  i_f1 0 = q
                                  i_f1 t = (i_f1_list ! (t-1) ) + (_getvalue ( (hd inputs) ! 0 ))

j_wrapperfun inputs = _createmsgwrapper [(2, 1, j_f1_list)]
                      where
                      j_f1_list = _createlist j_f1 0
                                  where
                                  j_f1 0 = k
                                  j_f1 t = if (t<0) then k else (25 + ((j_f1_list ! (t-1)) * (_getvalue ( (hd inputs) ! 0))) + (j_f2_lst ! (t-1)))
                      j_f2_list = _createlist j_f2 0
                                  where
                                  j_f2 0 = k+q
                                  j_f2 t = (j_f1_list ! (t-3)) + 27
