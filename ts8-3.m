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
                                                                        endwhere
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
                                               endwhere
                                      j_f2 0 = k+q
                                      j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                                               where
                                               msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                                               args_from_j        = concat (map getmsgargs msgs_from_j)
                                               j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
                                               endwhere
                                      endwhere
