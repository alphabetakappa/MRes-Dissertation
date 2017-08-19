main
h_sim (3+1) runtime_args agentinfo

where
runtime_args = [(Arg ("q",4)), (Arg ("k", 16))]
agentinfo = [(i_wrapper,[]), (j_wrapper, []), (k_wrapper, []), (jf1_delay, [])]
h_sim x args agents = (thd3.hd) (((snd (outputs!x))!0)!0)
                      where
                      newnullvalue = [(0,0,0)]
                      niloutputs = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue]]
                      outputs = zip2 [0..] (niloutputs : (redactedoutputs))
                      redactedoutputs = transpose (map apply_to_args (zip2 [1..] agents))
                                        where
                                        apply_to_args (agentid, (f,broadcastsubscriptions)) = f Emptyagentstate args (myoutputs agentid) agentid
                                        myoutputs id = map (f id) outputs
		                                f x (t, xs)  = (t, map (map (filter (h x))) xs)
		                                h x (a,b,c)  = ((b=x) \/ (a,b,c) = (0,0,0))
                                        endwhere
                      endwhere
i_wrapper localstate args inputs id = outbound_messages_this_timestep : (i_wrapper localstate args future_messages id)
                                      where
                                      q = (getargval.hd) (filter ((="q").getargstr) args)
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      t                               = fst (hd inputs)
                                      future_messages                 = tl inputs
                                      outbound_messages_this_timestep = [ [ (id,1,res),(id,2,res)]]
                                                                        where
                                                                        res = i_f1 t
                                                                        endwhere
                                      i_f1 0 = q
                                      i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                                               where
                                               i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                               j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
                                               endwhere
                                      endwhere
