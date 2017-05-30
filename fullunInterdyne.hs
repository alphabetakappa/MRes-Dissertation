import Simulations.RuntimeArgFunctions as RTAFuns

exampleExperiment :: IO ()
exampleExperiment
  = do
    sim 60 myargs (map snd myagents)
    where
    myargs = [ convert ]
    myagents = [ ("Trader",  (traderWrapper, [1])),
                 ("Broker",  (brokerWrapper, [3])),
                 ("Exchange",(exchangeWrapper, [2,3]))
               ]
    convert = RTAFuns.generateAgentBimapArg myagents
