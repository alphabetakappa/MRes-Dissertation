main
((s_outputs!(3+1))!0)!0

init
q = 4
k = 16

where
s_outputs  = niloutputs : (transpose [i_wrapper s_outputs 0, j_wrapper s_outputs 0, k_wrapper s_outputs 0, jf1_delay s_outputs 0 ])
             where
             niloutputs = [[nullvalue], [nullvalue, nullvalue], [nullvalue], [nullvalue]]
             nullvalue = 0
             endwhere
i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(i_f1 t)]
                     i_f1 0 = q
                     i_f1 t = cond (t<0) 0
                     ( ((inbound_messages_this_timestep!0)!0) +((inbound_messages_this_timestep!3)!0))
                     endwhere
