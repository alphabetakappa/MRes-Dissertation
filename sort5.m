i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = map f (hd inputs)
                                                       where
                                                       f xs = map g xs
                                                       g xs = filter h xs
                                                       h (a,b,c) = ((b=1) \/ (a,b,c) = (0,0,0))
                                                       endwhere
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [ [messages]]
                     logic t = function (inbound_messages_this_timestep)
                     endwhere
