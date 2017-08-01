wrapper st args ((t, msgs, bcasts) : rest) myid = [m] : (wrapper st args rest myid)
                                                  where
                                                  m = logic (t, msgs, bcasts)
