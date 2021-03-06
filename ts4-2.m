j_wrapper inputs t = outbound_messages_this_timestep : (j_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(j_f1 t), (j_f2 t)]
                     j_f1 0 = k
                     j_f1 t = cond (t<0) k_f1_last_timestep
                              (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                              where
                              i_f1_last_timestep = ((inbound_messages_this_timestep!0)!0)
                              j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
                              j_f2_last_timestep = ((inbound_messages_this_timestep!1)!1)
                              k_f1_last_timestep = ((inbound_messages_this_timestep!2)!0)
                              endwhere
                     j_f2 0 = k+q
                     j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                              where
                              j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
                              endwhere
                     endwhere
k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [k_f1 t]
                     k_f1 0 = 0
                     k_f1 t = k + q + j_f1_last_timestep
                              where
                              j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
                              endwhere
                     endwhere
jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(jf1_delayed t)]
                     jf1_delayed 0 = k
                     jf1_delayed t = ((inbound_messages_this_timestep!1)!0)
                     endwhere
