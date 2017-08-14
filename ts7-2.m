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
                                      i_f1 0 = q
                                      i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                                               where
                                               i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                               j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
j_wrapper localstate args inputs id = outbound_messages_this_timestep : (j_wrapper localstate args future_messages id)
                                      where
                                      q = (getargval.hd) (filter ((="q").getargstr) args)
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      t                               = fst (hd inputs)
                                      future_messages                 = tl inputs
                                      outbound_messages_this_timestep = [ [ (id,4,res1),(id,2,res1),(id,3,res1)],[ (id,2,res2)]]
                                                                        where
                                                                        res1 = j_f1 t
                                                                        res2 = j_f2 t
                                      j_f1 0 = k
                                      j_f1 t = cond (t<0) k_f1_last_timestep
                                                    (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                                               where
                                               i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                               j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
                                               j_f2_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!1)
                                               k_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!2)!0)
                                      j_f2 0 = k+q
                                      j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                                               where
                                               j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
