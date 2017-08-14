i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = map f (hd inputs)
                                                       where
                                                       f xs = map g xs
                                                       g xs = filter h xs
                                                       h (a,b,c) = ((b=1) \/ (a,b,c) = (0,0,0))
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [ [ (1,1,res),(1,2,res)]]
                                                       where
                                                       res = i_f1 t
                     i_f1 0 = q
                     i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                              where
                              i_f1_last_timestep  = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                              j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
j_wrapper inputs t = outbound_messages_this_timestep : (j_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = map f (hd inputs)
                                                       where
                                                       f xs = map g xs
                                                       g xs = filter h xs
                                                       h (a,b,c) = ((b=2) \/ (a,b,c) = (0,0,0))
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [ [ (2,4,res1),(2,2,res1),(2,3,res1)],[(2,2,res2)]]
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
