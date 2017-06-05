import Simulations.RuntimeArgFunctions as RTAFuns

exampleExperiment :: IO ()
exampleExperiment
  = do
    sim 60 myargs (map snd myagents)
    where
    myargs   = [ convert,
                 (Arg (Str "maxDelay", maxDelay)),
                 (DelayArg (Str "DelayArg", delay))
               ]
    myagents = [ ("Trader",  (traderWrapper, [1])),
                 ("Broker",  (brokerWrapper, [3])),
                 ("Exchange",(exchangeWrapper, [2,3]))
               ]
    convert = RTAFuns.generateAgentBimapArg myagents
    delay 1 2 = 1
    delay 1 x = error "illegal interaction"
    delay 2 x = 2
    delay 3 2 = 3
    delay 3 x = error "illegal interaction"
    maxDelay = fromIntegral 3
