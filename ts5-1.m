main
(thd3.hd) (((s_outputs!(3+1))!0)!0)

init
q = 4
k = 16

where
s_outputs  = niloutputs :  transpose [ i_wrapper s_outputs 0 ,j_wrapper s_outputs 0 ,k_wrapper s_outputs 0, jf1_delay s_outputs 0  ]
             where
             niloutputs = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue]]
             nullvalue = [(0,0,0)]
             endwhere
i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = map f (hd inputs)
                                                       where
                                                       f xs = map g xs
                                                       g xs = filter h xs
                                                       h (a,b,c) = ((b=1) \/ (a,b,c) = (0,0,0))
                                                       endwhere
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [ [ (1,1,res),(1,2,res)]]
                                                       where
                                                       res = i_f1 t
                                                       endwhere
                     i_f1 0 = q
                     i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                              where
                              i_f1_last_timestep  = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                              j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
                              endwhere
                     endwhere
