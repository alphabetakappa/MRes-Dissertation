k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = map f (hd inputs)
                                                       where
                                                       f xs = map g xs
                                                       g xs = filter h xs
                                                       h (a,b,c) = ((b=3) \/ (a,b,c) = (0,0,0))
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [[(3,2,k_f1 t)]]
                     k_f1 0 = 0
                     k_f1 t = k + q + j_f1_last_timestep
                              where
                              j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = map f (hd inputs)
                                                       where
                                                       f xs = map g xs
                                                       g xs = filter h xs
                                                       h (a,b,c) = ((b=4) \/ (a,b,c) = (0,0,0))
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [[(4, 1, jf1_delayed t)]]
                     jf1_delayed 0 = k
                     jf1_delayed t = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
