k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [[(3,2,k_f1 t)]]
                     k_f1 0 = 0
                     k_f1 t = k + q + j_f1_last_timestep
                              where
                              j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [[(4, 4, jf1_current)], [(4, 1, jf1_delayed)]]
                     jf2_current = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
                     jf2_delayed = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
