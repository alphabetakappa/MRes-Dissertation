jf1 delay inputs t = outbound messages this timestep : (jf1 delay future messages ( t+1))
                     where
                     inbound messages this timestep = hd inputs
                     future messages = tl inputs outbound messages this timestep = [( jf1 delayed t) ]
                     jf1 delayed 0 = k
                     jf1 delayed t = (( inbound messages this timestep !1) !0)
