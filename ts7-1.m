main
h_sim (3+1) runtime_args agentinfo

where
runtime_args = [(Arg ("q",4)), (Arg ("k", 16))]
agentinfo = [(i_wrapper,[]), (j_wrapper, []), (k_wrapper, []), (jf1_delay, [])]
h_sim x args agents = (thd3.hd) (((snd (outputs!x))!0)!0)
                      where
                      newnullvalue = [(0,0,0)]
                      niloutputs = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue, newnullvalue]]
                      outputs = zip2 [0..] (niloutputs : (redactedoutputs))
                      redactedoutputs = transpose (map apply_to_args (zip2 [1..] agents))
                                        where
                                        apply_to_args (agentid, (f,broadcastsubscriptions)) = f Emptyagentstate args (myoutputs agentid) agentid
                                        myoutputs id = map (f id) outputs
		                                f x (t, xs)  = (t, map (map (filter (h x))) xs)
		                                h x (a,b,c)  = ((b=x) \/ (a,b,c) = (0,0,0))
