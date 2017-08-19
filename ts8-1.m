main
h_sim (3+1) runtime_args agentinfo

where
runtime_args = [(Arg ("q",4)), (Arg ("k", 16))]
agentinfo = [(i_wrapper,[]), (j_wrapper, []), (k_wrapper, []), (jf1_delay, [])]
h_sim x runtime_args agentinfo = (getargval.hd.getmsgargs) (((snd (outputs!x))!0)!0)
                                 where
                                 outputs = (0,[]):timed_transposed_msgs
                                 timed_transposed_msgs = zip2 [1..] transposed_msgs
                                 transposed_msgs = transpose allmessages
                                 allmessages = map apply_to_args (zip2 [1..] agentinfo)
                                               where
                                               apply_to_args (agentid, (agentfn,broadcastsubscriptions)) = agentfn Emptyagentstate runtime_args (redacted_msgs agentid outputs) agentid
                                               redacted_msgs id outputs = map (f id) outputs
		                                       f x (time, xs)               = (time, concat (map (filter (h x)) xs))
		                                       h x (Message (f,t) args)     = (t=x)
                                               endwhere
                                 endwhere
