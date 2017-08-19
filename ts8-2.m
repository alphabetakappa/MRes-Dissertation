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
                                                                        endwhere
                                      i_f1 0 = q
                                      i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_last_timestep)
                                               where
                                               msgs_from_i        = filter ((=1).getmsgfrom) inbound_messages_this_timestep
                                               args_from_i        = concat (map getmsgargs msgs_from_i)
                                               i_f1_last_timestep = (getargval.hd) (filter ((="i_f1").getargstr) args_from_i)
                                               msgs_from_jd        = filter ((=4).getmsgfrom) inbound_messages_this_timestep
                                               args_from_jd        = concat (map getmsgargs msgs_from_j)
                                               j_f1_2last_timestep = (getargval.hd) (filter ((="j_f1d").getargstr) args_from_jd)
                                               endwhere
                                      endwhere
