main
h_sim (3+1)

init
q = 4
k = 16

where
h_sim x = (thd3.hd) (((outputs!x)!0)!0)
          where
          newnullvalue = [(0,0,0)]
          niloutputs   = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue, newnullvalue]]
          outputs      = niloutputs : redactedoutputs
          redactedoutputs = transpose [ i_wrapper i_inputs 0 ,j_wrapper j_inputs 0 ,k_wrapper k_inputs 0, jf1_delay jf1_inputs 0 ]
                            where
                            i_inputs   = map (map (map (filter (h 1)))) outputs
                            j_inputs   = map (map (map (filter (h 2)))) outputs
                            k_inputs   = map (map (map (filter (h 3)))) outputs
                            jf1_inputs = map (map (map (filter (h 4)))) outputs
                            h x (a,b,c) = ((b=x) \/ (a,b,c) = (0,0,0))
i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [ [ (1,1,res),(1,2,res)]]
                                                       where
                                                       res = i_f1 t
                     i_f1 0 = q
                     i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_last_timestep)
                              where
                              i_f1_last_timestep  = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                              j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
j_wrapper inputs t = outbound_messages_this_timestep : (j_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
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
