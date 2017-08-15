k_wrapper localstate args inputs id = outbound_messages_this_timestep : (k_wrapper localstate args future_messages id)
                                      where
                                      q = (getargval.hd) (filter ((="q").getargstr) args)
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      t                               = fst (hd inputs)
                                      future_messages                 = tl inputs
                                      outbound_messages_this_timestep = [[(id,2,k_f1 t)]]
                                      k_f1 0 = 0
                                      k_f1 t = k + q + j_f1_last_timestep
                                               where
                                               j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
jf1_delay localstate args inputs id = outbound_messages_this_timestep : (jf1_delay localstate args future_messages id)
                                      where
                                      inbound_messages_this_timestep  = snd (hd inputs)
                                      future_messages                 = tl inputs
                                      t                               = fst (hd inputs)
                                      outbound_messages_this_timestep = [[(id,1,jf1_delayed t)]]
                                      k = (getargval.hd) (filter ((="k").getargstr) args)
                                      jf1_delayed 0 = k
                                      jf1_delayed t = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
