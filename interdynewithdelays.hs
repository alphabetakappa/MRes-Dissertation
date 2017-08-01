exampleExperiment
  = do
    sim 100 myargs (map snd myagents)
    where
    myargs   = [ (Arg (Str "maxDelay", maxDelay)),
                 (DelayArg (Str "DelayArg", delay))
               ]
    myagents = [ (agent1, [1]),
                 (agent2, []),
                 (agent3, [2,3])
               ]
    delay 1 2 = 1
    delay 1 x = error "illegal interaction"
    delay 2 x = 2
    delay 3 2 = 3
    delay 3 x = error "illegal interaction"
    maxDelay = fromIntegral 3
