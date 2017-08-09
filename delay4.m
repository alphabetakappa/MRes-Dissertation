jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                     where
                     inbound_messages_this_timestep  = hd inputs
                     future_messages                 = tl inputs
                     outbound_messages_this_timestep = [(jf1_current), (jf1_delayed)]
                     jf1_current = value from initial wrapper
                     jf1_delayed = previous jf1_current value 
