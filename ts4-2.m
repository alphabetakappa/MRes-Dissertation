i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(i_f1 t)]
                     i_f1 0 = q
                     i_f1 t = cond (t<0) 0
                              ( ((inbound_messages_this_timestep!0)!0) +((inbound_messages_this_timestep!3)!1))
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
                     j_f2 0 = k+q
                     j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                              where
                              j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [k_f1 t]
                     k_f1 0 = 0
                     k_f1 t = k + q + j_f1_last_timestep
                              where
                              j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(jf1_current), (jf1_delayed)]
                     jf1_current = ((inbound_messages_this_timestep!1)!0)
                     jf1_delayed = ((inbound_messages_this_timestep!3)!0)
