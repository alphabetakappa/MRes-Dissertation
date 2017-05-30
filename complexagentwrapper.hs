wrapper_i :: Agent_t
wrapper_i st args ((t, msgs, bcasts) : rest) myid
     =  [m]  : (wrapper_i st args rest myid)
        where
        m = logic_i (t, msgs, bcasts)
