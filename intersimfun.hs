sim steps args agents
  = do
     "ouput" = f steps
    where
    "update the aguments"
    "








sim x runtime_args agentinfo = (getargval.hd.getmsgargs) (((snd (outputs!x))!0)!0)
                                where
                                outputs = (0,[]):timed_transposed_msgs
                                timed_transposed_msgs = zip2 [1..] transposed_msgs
                                transposed_msgs = transpose allmessages
                                allmessages = map apply_to_args (zip2 [1..] agentinfo)
                                              where
                                              apply_to_args (agentid, (agentfn,broadcastsubscriptions)) = agentfn Emptyagentstate runtime_args (redacted_msgs agentid outputs) agentid
                                              redacted_msgs id outputs = map (f id) outputs
                                              f x (time, xs)               = (time, concat (map (filter (h x)) xs))
                                              h x (Message (f,t) args)     = (t=x)











sim steps args agents
  = do
     trace_outh <- openFile (prefix ++ "trace") WriteMode
     data_outh  <- openFile (prefix ++ "data.csv") WriteMode
     hSetBuffering trace_outh (BlockBuffering Nothing)
     hSetBuffering data_outh  (BlockBuffering Nothing)

     hPutStr trace_outh ("START OF SIMULATION - seed is " ++ seedmsg ++
                         "\nNB System Time 2 aligns with Exchange Time 1\n\n")
     tracer allstates trace_outh data_outh
     statstuff

    where
     updatedArgs = (generateAgentSubscriptionArg agents) : args
     statstuff = if (arg_findval "autostats" updatedArgs) /= -1
                 then (printstatoutput (statfuncs (prefix ++ "data.csv")
                                        assetreturnscoln True)
                       (prefix ++ "-asset_returns-"))
                 else  return()   --do nothing
     highestbrg = maximum ((concat (map snd agents)) ++ [0])
     myrands = if (arg_findval "randseed" updatedArgs) /= -1
               then drop (pmh + (length agents)) randoms
               else drop ((round (arg_findval "randseed" updatedArgs))
                           * (pmh + (length agents))) randoms
     seedmsg = if (arg_findval "randseed" updatedArgs) == (-1)
               then "default"
               else show (arg_findval "randseed" updatedArgs)
     pmh = (sum (map ord prefix)) --Poor Man's Hash (function)'
     prefix = if p /= Nothing
              then (fromStr (fromJust p)) ++ "-"
              else if (arg_findstr 9989793425 updatedArgs) /= ""
                   then (arg_findstr 9989793425 updatedArgs) ++ "-"
                   else  ""

              where
              a = arg_lookup "prefix" updatedArgs
              p = arg_extract_strarg_value a
     startsimstate = sim_emptystate agents updatedArgs highestbrg myrands
     allstates = startsimstate : simstates
     simstates = simstep steps 1 updatedArgs startsimstate allmessages myrands
     allmessages = map f (zip [1..] agents)

       where
         f :: (Int,(Agent_t, [Int]))  -> [[Msg_t]]
         f (id,(a, brcs)) = a emptyagentstate updatedArgs (map (g id) allstates)  id

           where
             g x st = ((fromIntegral $sim_gettime st), sim_getmymessages st x,
                       (concat (map (sim_getmybroadcasts st) brcs)) ++
                       (sim_getmyroutedbroadcasts st x))

