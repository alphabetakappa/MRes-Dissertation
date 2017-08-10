msgs_from_i        = filter ((=1).getmsgfrom) inbound_messages_this_timestep
args_from_i        = concat (map getmsgargs msgs_from_i)
i_f1_last_timestep = (getargval.hd) (filter ((="i_f1").getargstr) args_from_i)
