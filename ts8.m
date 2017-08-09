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
		                                       h x Hiaton                   = False
		                                       h x (Message (f,t) args)     = (t=x)
                                               h x (Datamessage (f,t) text) = error "Datamessage not yet implemented"
i_wrapper localstate args inputs id = outbound_messages_this_timestep : (i_wrapper localstate args future_messages id)
                                      where
                                      q = (getargval.hd) (filter ((="q").getargstr) args)
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      t                               = fst (hd inputs)
                                      future_messages                 = tl inputs
                                      outbound_messages_this_timestep = [ Message (id,1) [(Arg ("i_f1",res))],Message (id,2) [(Arg ("i_f1",res))]]
                                                                        where
                                                                        res = i_f1 t
                                      i_f1 0 = q
                                      i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_last_timestep)
                                               where
                                               msgs_from_i        = filter ((=1).getmsgfrom) inbound_messages_this_timestep
                                               args_from_i        = concat (map getmsgargs msgs_from_i)
                                               i_f1_last_timestep = (getargval.hd) (filter ((="i_f1").getargstr) args_from_i)
                                               msgs_from_jd        = filter ((=4).getmsgfrom) inbound_messages_this_timestep
                                               args_from_jd        = concat (map getmsgargs msgs_from_j)
                                               j_f1_2last_timestep = (getargval.hd) (filter ((="j_f1d").getargstr) args_from_jd)
j_wrapper localstate args inputs id = outbound_messages_this_timestep : (j_wrapper localstate args future_messages id)
                                      where
                                      q = (getargval.hd) (filter ((="q").getargstr) args)
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      t                               = fst (hd inputs)
                                      future_messages                 = tl inputs
                                      outbound_messages_this_timestep = [ Message (id,4) [(Arg ("j_f1",res1))],Message (id,2) [(Arg ("j_f1",res1))],Message (id,3) [(Arg ("j_f1",res1))],Message (id,2) [(Arg ("j_f2",res2))]]
                                                                        where
                                                                        res1 = j_f1 t
                                                                        res2 = j_f2 t
                                      j_f1 0 = k
                                      j_f1 t = cond (t<0) k_f1_last_timestep
                                               (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                                               where
                                               msgs_from_i        = filter ((=1).getmsgfrom) inbound_messages_this_timestep
                                               args_from_i        = concat (map getmsgargs msgs_from_i)
                                               i_f1_last_timestep = (getargval.hd) (filter ((="i_f1").getargstr) args_from_i)
                                               msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                                               args_from_j        = concat (map getmsgargs msgs_from_j)
                                               j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
                                               j_f2_last_timestep = (getargval.hd) (filter ((="j_f2").getargstr) args_from_j)
                                               msgs_from_k        = filter ((=3).getmsgfrom) inbound_messages_this_timestep
                                               args_from_k        = concat (map getmsgargs msgs_from_k)
                                               k_f1_last_timestep = (getargval.hd) (filter ((="k_f1").getargstr) args_from_j)
                                      j_f2 0 = k+q
                                      j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                                               where
                                               msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                                               args_from_j        = concat (map getmsgargs msgs_from_j)
                                               j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
k_wrapper localstate args inputs id = outbound_messages_this_timestep : (k_wrapper localstate args future_messages id)
                                      where
                                      q = (getargval.hd) (filter ((="q").getargstr) args)
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      t                               = fst (hd inputs)
                                      future_messages                 = tl inputs
                                      outbound_messages_this_timestep = [Message (id,2) [(Arg ("k_f1",k_f1 t))]]
                                      k_f1 0 = 0
                                      k_f1 t = k + q + j_f1_last_timestep
                                               where
                                               msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                                               args_from_j        = concat (map getmsgargs msgs_from_j)
                                               j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
jf1_delay localstate args inputs id = outbound_messages_this_timestep : (jf1_delay localstate args future_messages id)
                                      where
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      future_messages                 = tl inputs
                                      t                               = fst (hd inputs)
                                      outbound_messages_this_timestep = [Message (id, 4) [(Arg ("j_f1c", jf2_current t))], Message (id, 1) [(Arg ("j_f1d", jf2_delayed))]]
                                      msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                                      args_from_j        = concat (map getmsgargs msgs_from_j)
                                      jf2_current        = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
                                      msgs_from_jd        = filter ((=4).getmsgfrom) inbound_messages_this_timestep
                                      args_from_jd        = concat (map getmsgargs msgs_from_jd)
                                      jf2_delayed         = (getargval.hd) (filter ((="j_f1c").getargstr) args_from_jd)
