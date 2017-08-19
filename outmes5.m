i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     outbound_messages_this_timestep = [ [ (1,1,logic1),(1,2,logic1)]]
                     logic1 t = function (inbound_messages_this_timestep)
                     endwhere
