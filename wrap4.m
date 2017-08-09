i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(logic1 t), (logic2 t)]
                     logic1 t = function (inbound_messages_this_timestep)
                     logic2 t = function (inbound_messages_this_timestep)
