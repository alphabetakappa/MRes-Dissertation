{-|
-- FILENAME:            ExampleExperiment.hs 
-- 
-- DESCRIPTION: 
--   Example exxperiment showcasing how to code an experiment to make use of the
--   simulator's in built functionality to delay messages and broadcasts between
--   agents. Also on how to use AgentBimapArg to get the agentID of another agent
--   using their agentLabel.
--  
-- NOTES: 
--   This module is split into:
--     1) Example coding of an experiment which uses the DelayArg, AgentBimapArg, and
--        maxDelay args.
--     2) Example coding of the agents within the experiment - which are using
--        AgentBimapArg to get the agentIDs of those agents which they will
--        interact with. 
--     3) Commentary and helper functions for the 'agents' parameter to sim,
--        DelayArg, "maxDelay" arg, and AgentSubscriptionArg
--     4) Commentary and helper functions for AgentBimapArg
--        N.B. Helper functions can be reused for making new experiments.
--
-- AUTHOR(S): 
--   Vikram Bakshi (VAB)
--   Christopher D. Clack (CDC)
--
-- DATE CREATED: 
--   Sun Jul 19 2015
--
-- MAJOR CHANGES:
--   --   DATE -- WHO ---------------------- WHAT --------------------
--   2015 07 19 - VAB - Finalised Module - example experiment works as expected.
--   2015 16 11 - CDC - Changed name FunArg1 to DelayArg; new version 0.250
--   2015 16 11 - CDC - Changed name FunArg3 to AgentBimapArg
--
-- KNOWN ISSUES:
--              
-}

module Simulations.ExampleExperiment where

import Simulator.Sim
import Common.Comm
import Common.Types
import Common.Messages
import System.Directory
import Data.Maybe
import Data.Bimap (Bimap)
import qualified Data.Bimap as Data.Bimap
import qualified Data.Vector as Data.Vector
import qualified Simulations.RuntimeArgFunctions as RuntimeArgFunctions
  
--------------------------------------------------------------------------------------------------------------
-- Begin: Example coding of an experiment which uses DelayArg, AgentBimapArg, and the new style agent-list. 
--------------------------------------------------------------------------------------------------------------

funArgsMaxDelayAndAgentsExample :: IO ()
funArgsMaxDelayAndAgentsExample
  = do
    createDirectoryIfMissing True ("SimulationOutput/"++thefilename)
    sim 60 meinargs (RuntimeArgFunctions.transformForSim meinagents)
    where
    meinargs = [ (Arg (Str "Calm", 1))
               , (Arg (Str fthefilename, 9989793425))
               , (Arg (Str "Randomise", 1))
               , delayarg, maxDelayArg, agentBimapArg ] -- agentSubscriptionArg, agentBimapArg ]
    fthefilename = "SimulationOutput/" ++ thefilename ++ "/" ++ thefilename
    thefilename = "funArgsMaxDelayAndAgentsExample"
    -- We define our agent list in the new-style i.e. with an agent label for each wrapper. 
    meinagents = [       ("CME_Exch_1", (exampleWrapper1, [0]    )), -- This would be given ID 1.
                         ("CME_Exch_2", (exampleWrapper2, [1]    )), -- This would be given ID 2.
                         ("CQS",        (exampleWrapper3, [1,2]  )), -- This would be given ID 3.
                         ("FR1",        (exampleWrapper4, [2]    )), -- This would be given ID 4.
                         ("Broker1",    (exampleWrapper5, [2]    ))  -- This would be given ID 5.
                  ]                                                                              
    ---------------- DelayArg
    -- We encode our adjacency matrix representation of the experiment's graph. 
    delays :: [ [Maybe Int] ] 
    delays  = [--      {- 0 Sim -}  {-1 CME_Exch_1-}  {-2 CME_Exch_2-}  {-3 CQS-}  {-4 FR1-}  {-5 Broker1-}
   {-0 Simulator -}  [     Just 0,         Just 0,         Just 0,      Just 0,    Just 0,    Just 0    ],  
   {-1 CME_Exch_1-}  [     Just 0,         Nothing,        Just 1,      Just 2,    Just 3,    Just 4    ],
   {-2 CME_Exch_2-}  [     Just 0,         Just 1,        Nothing,      Just 1,    Just 2,    Just 3    ],
   {-3 CQS-}         [     Just 0,        Just 50,         Just 1,     Nothing,    Just 1,    Just 2    ], 
   {-4 FR1-}         [     Just 0,         Just 3,         Just 2,      Just 1,    Nothing,   Nothing   ], 
   {-5 Broker1-}     [     Just 0,         Just 4,         Just 3,      Just 2,    Nothing,   Nothing   ] 
              ]
    -- Turn delays from [ [ Maybe Int] ] to a vector of vectors.
    delaysAsVector      = Data.Vector.fromList (map Data.Vector.fromList delays) 
    -- Code the function responsible for returning the delay between two agents. 
    getTimeStepDelay :: Int -> Int -> Int                    
    getTimeStepDelay agentFrom agentTo = delay
      where 
        agentFromDelayList  = delaysAsVector Data.Vector.! agentFrom
        delay               | agentFromDelayList Data.Vector.! agentTo == Nothing
                                = error ("getTimeStepDelay: There is no delay specified between agentFrom: "++(show agentFrom)++" and agentTo: "++(show agentTo))
                            | otherwise
                                = fromJust (agentFromDelayList Data.Vector.! agentTo) -- Otherwise, extract the Int from the Just constructor. 
    -- Wrap the function in a DelayArg constructor so it can be included in the list of args:
    delayarg = DelayArg (Str "DelayArg", getTimeStepDelay)      
    ---------------- maxDelay Arg
    maxDelay            = findMaxDelay delays   -- Find the maximum delay within the [ [ Maybe Int ] ] definition of delays.
    maxDelayAsDouble    = fromIntegral maxDelay -- Turn it into a double to match the type expected within the Arg constructor.
    maxDelayArg         = (Arg (Str "maxDelay", maxDelayAsDouble)) -- Wrap it in an Arg constructor, and include it in the list of args. 
    ----------------- AgentBimapArg
    agentBimapArg = generateAgentBimapArg meinagents

--------------------------------------------------------------------------------------------------------------
-- End: Example coding of an experiment which uses DelayArg, AgentBimapArg, and the new style agent-list. 
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- Begin: Example coding five agents which use AgentBimapArg to get the IDs of the agents they interact with.
--------------------------------------------------------------------------------------------------------------

-- Prior to the addition of AgentBimapArg, agents had to hard code the ID of the other agents they would send
-- messages to within their logic. The only exception was the exchange agent (nice_mime) which could
-- use the ID of an agent once it received a message to send a reply. 
    
-- AgentBimapArg allows agents to refer to each other using the user specified labels instead - decoupling agents
-- from needing to hard code the IDs within their logic. The following five agents are all examples of how
-- to get the IDs of other agents which you are required to interact with without having to hard code it into
-- your logic. The labels are completely meaningless and are given as examples only. 

-- We use the getCorrespondingAgentIdentifier to get the agentIDs from a given label. 
-- getCorrespondingAgentIdentifier :: (AgentIdentifier_t -> AgentIdentifier_t)
-- This means if we want the ID corresponding to an agent label we given it a (AgentLabel "string") and it will
-- return an error (if it doesn't exist) or an (AgentID integerID). It also works for the other way around@
-- give it an (AgentID integerID) and it will return an error (if it doesn't exist) or an (AgentLabel "string").

{- So that you don't have to scroll up here is how we defined the agent list:

    meinagents = [       ("CME_Exch_1", (exampleWrapper1, [0]    )), -- This would be given ID 1.
                         ("CME_Exch_2", (exampleWrapper2, [1]    )), -- This would be given ID 2.
                         ("CQS",        (exampleWrapper3, [1,2]  )), -- This would be given ID 3.
                         ("FR1",        (exampleWrapper4, [2]    )), -- This would be given ID 4.
                         ("Broker1",    (exampleWrapper5, [2]    ))  -- This would be given ID 5.
                  ]                                                       -}                       

-- exampleWrapper1 has the label "CME_Exch_1", and needs to communicate with those subscribed to broadcast
-- channel 2, and "Broker1" (who has ID 5).
exampleWrapper1 :: Agent_t
exampleWrapper1 (Emptyagentstate) args ((time, messages, broadcasts) : restOfStates) myid
  = ( ( [msg] ) : (exampleWrapper1 (Emptyagentstate) args restOfStates myid) )
    where
    msg | time == 0 = Broadcastmessage (1,2) (Strbroadcast (Str "Broadcast from (1, 2). Sent at time 0. "))
        | time == 1 = Debugmessage (1, broker1ID) "This message was sent at time 1 from/to (1,5). The delay is of 4 t.s. so it should arrive at time 6."  
        | otherwise = Hiaton
    -- Grab the function we wrapped up into a FunArg. Since this wrapper's logic depends on it - halt the program with an error if the simulation
    -- does not have a AgentBimapArg runtime argument. 
    agentBimapArg | (arg_lookup "AgentBimapArg" args) == EmptyArg 
                    = error "You have not encoded a BiMap (AgentBimapArg) for the wrapper to find the IDs of the agents it will interact with."
                  | otherwise                               
                    = (arg_lookup "AgentBimapArg" args)
    -- Take the function out of the AgentBimapArg constructor.                                                     
    getCorrespondingAgentIdentifier = arg_extract_AgentBimapArg_value agentBimapArg
    -- Use it to return the corresponding agentID. 
    (AgentID broker1ID) = getCorrespondingAgentIdentifier (AgentLabel "Broker1")

-- exampleWrapper2 has the label "CME_Exch_2", and needs to communicate with "FR1" (who has ID 4).
exampleWrapper2 :: Agent_t
exampleWrapper2 (Emptyagentstate) args ((time, messages, broadcasts) : restOfStates) myid
  = ( ( [msg] ) : (exampleWrapper2 (Emptyagentstate) args restOfStates myid) )
    where
    msg | time == 2 = Debugmessage (2, fr1ID) "This message was sent at time 2 from/to (2,4). The delay is of 2 t.s. so it should arrive at time 5."  
        | otherwise = Hiaton
    -- Grab the function we wrapped up into a FunArg. Since this wrapper's logic depends on it - halt the program with an erorr if the simulation
    -- does not have a AgentBimapArg runtime argument. 
    agentBimapArg | (arg_lookup "AgentBimapArg" args) == EmptyArg = error "You have not encoded a BiMap (AgentBimapArg) for the wrapper to find the IDs of the agents it will interact with."
            | otherwise                               = (arg_lookup "AgentBimapArg" args)
    -- Take the function out of the AgentBimapArg constructor.                                                     
    getCorrespondingAgentIdentifier = arg_extract_AgentBimapArg_value agentBimapArg
    (AgentID fr1ID) = getCorrespondingAgentIdentifier (AgentLabel "FR1")

-- exampleWrapper3 has the label "CQS", and needs to communicate with "CME_Exch_1" (who has ID 1).
exampleWrapper3 :: Agent_t
exampleWrapper3 (Emptyagentstate) args ((time, messages, broadcasts) : restOfStates) myid
  = ( ( [msg] ) : (exampleWrapper3 (Emptyagentstate) args restOfStates myid) )
    where
    msg | time == 3 = Debugmessage (3, cmeExch1ID) "This message was sent at time 3 from/to (3,1). The delay is of 50 t.s. so it should arrive at time 54."  
        | otherwise = Hiaton
    -- Grab the function we wrapped up into a FunArg. Since this wrapper's logic depends on it - halt the program with an erorr if the simulation
    -- does not have a AgentBimapArg runtime argument. 
    agentBimapArg | (arg_lookup "AgentBimapArg" args) == EmptyArg = error "You have not encoded a BiMap (AgentBimapArg) for the wrapper to find the IDs of the agents it will interact with."
            | otherwise                               = (arg_lookup "AgentBimapArg" args)
    -- Take the function out of the AgentBimapArg constructor.                                                     
    getCorrespondingAgentIdentifier = arg_extract_AgentBimapArg_value agentBimapArg
    (AgentID cmeExch1ID) = getCorrespondingAgentIdentifier (AgentLabel "CME_Exch_1")

-- exampleWrapper4 has the label "FR1", and needs to communicate with those subscribed to broadcast
-- channel 1, and "CME_Exch_2" (who has ID 2).
exampleWrapper4 :: Agent_t
exampleWrapper4 (Emptyagentstate) args ((time, messages, broadcasts) : restOfStates) myid
  = ( ( [msg] ) : (exampleWrapper4 (Emptyagentstate) args restOfStates myid) )
    where
    msg | time == 4 = Debugmessage (4, cmeExch2ID) "This message was sent at time 4 from/to (4,2). The delay is of 2 t.s. so it should arrive at time 7."
        | time == 9 = Broadcastmessage (4,1) (Strbroadcast (Str "Broadcast from (4, 1). Sent at time 9. "))
        | otherwise = Hiaton 
    -- Grab the function we wrapped up into a FunArg. Since this wrapper's logic depends on it - halt the program with an erorr if the simulation
    -- does not have a AgentBimapArg runtime argument. 
    agentBimapArg | (arg_lookup "AgentBimapArg" args) == EmptyArg = error "You have not encoded a BiMap (AgentBimapArg) for the wrapper to find the IDs of the agents it will interact with."
            | otherwise                               = (arg_lookup "AgentBimapArg" args)
    -- Take the function out of the AgentBimapArg constructor.                                                     
    getCorrespondingAgentIdentifier = arg_extract_AgentBimapArg_value agentBimapArg
    (AgentID cmeExch2ID) = getCorrespondingAgentIdentifier (AgentLabel "CME_Exch_2")

-- exampleWrapper5 has the label "Broker1", and needs to communicate with those subscribed to broadcast
-- channel 0, and "CME_Exch_1" (who has ID 1).
exampleWrapper5 :: Agent_t
exampleWrapper5 (Emptyagentstate) args ((time, messages, broadcasts) : restOfStates) myid
  = ( ( [msg] ) : (exampleWrapper5 (Emptyagentstate) args restOfStates myid) )
    where
    msg | time == 4 = Broadcastmessage (5,0) (Strbroadcast (Str "Broadcast from (5, 0). Sent at time 4. "))
        | time == 5 = Debugmessage (5, cmeExch1ID) "This message was sent at time 5 from/to (5,1). The delay is of 4 t.s. so it should arrive at time 10."  
        | otherwise = Hiaton
    -- Grab the function we wrapped up into a FunArg. Since this wrapper's logic depends on it - halt the program with an erorr if the simulation
    -- does not have a AgentBimapArg runtime argument. 
    agentBimapArg | (arg_lookup "AgentBimapArg" args) == EmptyArg = error "You have not encoded a BiMap (AgentBimapArg) for the wrapper to find the IDs of the agents it will interact with."
            | otherwise                               = (arg_lookup "AgentBimapArg" args)
    -- Take the function out of the AgentBimapArg constructor.                                                     
    getCorrespondingAgentIdentifier = arg_extract_AgentBimapArg_value agentBimapArg
    (AgentID cmeExch1ID) = getCorrespondingAgentIdentifier (AgentLabel "CME_Exch_1")

--------------------------------------------------------------------------------------------------------------
-- End: Example coding five agents which use AgentBimapArg to get the IDs of the agents they interact with.
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- Begin: Commentary and helper Functions for the 'agents' parameter to sim, DelayArg, "maxDelay" arg
--------------------------------------------------------------------------------------------------------------


-- The 'args' parameter: 
--      There are two modes the simulator can run in:
--              1) Compatability Mode.
--              2) With Delays and Routed Broadcasts.
--      For the simulator to run in mode 2, three 'args' need to be added to the list of arguments which are passed to sim. They are a set and they all must be present. 
--          i) A "DelayArg"  - this contains a function 'getTimeStepDelay' :: (Int -> Int -> Int). The function returns the timestep delay of sending
--                            a message between the two agentIDs (Ints).
--         ii) A "maxDelay" - This is encoded using the 'Arg (Str, Double)' with the string being equal to 'maxDelay'. The double is the maximum delay
--                            possible between two agents within your simulation (which should really be an Int - but we cannot change it because existing
--                            code relies on it). 

---------- i) "DelayArg": It is up to the user to decide how to provide this function. An example is given below:
--
--   In this example suppose that we have 5 agents (as well as the simulator - which is always agent 0 - making 6 total), and the user defined agent list is:
-- 
--                  > meinagents = [      ("CME_Exch_1", (exampleWrapper1, [0]    )), -- This would be given ID 1.
--                  >                     ("CME_Exch_2", (exampleWrapper2, [1]    )), -- This would be given ID 2. 
--                  >                     ("CQS",        (exampleWrapper3, [1,2]  )), -- This would be given ID 3. 
--                  >                     ("FR1",        (exampleWrapper4, [2]    )), -- This would be given ID 4. 
--                  >                     ("Broker1",    (exampleWrapper5, [2]    ))  -- This would be given ID 5. 
--                  >              ]
--
--   The idea is to encode the adjacency matrix representation of the simulation graph. The type of the ajacency matrix is :: [[ Maybe Int]].
--   -> If there is no connection between the nodes (agents) in the graph then we place a Nothing.
--   -> If there is no delay in sending a message from one agent to another then we put Just 0.
--   -> Otherwise we input Just x, where x is the Int representing the delay between the two agents, in timesteps. 
-- 
--   The ID 0 is reserved, and is always given to the simulator. Any messages sent to ID 0 are known as 'Harness Messages' (useful for debugging). 
--   We define our adjacency matrix as follows:
--
--                  >   -- We encode our adjacency matrix representation of the experiment's graph. 
--                  >   delays :: [ [Maybe Int] ] 
--                  >   delays  = [--      {- 0 Sim -}  {-1 CME_Exch_1-}  {-2 CME_Exch_2-}  {-3 CQS-}  {-4 FR1-}  {-5 Broker1-}
--                  >  {-0 Simulator -}  [     Just 0,         Just 0,         Just 0,      Just 0,    Just 0,    Just 0    ],  
--                  >  {-1 CME_Exch_1-}  [     Just 0,         Nothing,        Just 1,      Just 2,    Just 3,    Just 4    ],
--                  >  {-2 CME_Exch_2-}  [     Just 0,         Just 1,        Nothing,      Just 1,    Just 2,    Just 3    ],
--                  >  {-3 CQS-}         [     Just 0,        Just 50,         Just 1,     Nothing,    Just 1,    Just 2    ], 
--                  >  {-4 FR1-}         [     Just 0,         Just 3,         Just 2,      Just 1,    Nothing,   Nothing   ], 
--                  >  {-5 Broker1-}     [     Just 0,         Just 4,         Just 3,      Just 2,    Nothing,   Nothing   ] 
--                  >             ]
--
--   Certain conditions must be met for an accurate/successfull simulation to take place:
--   <--> If you have 5 agents (not including the 0th agent - so 6 in total) then you need a 6x6 matrix with every entry populated. The relationship between
--        two agents has to be defined explicitly as a Nothing or a Just Int (with Just 0 meaning there is no delay in sending a message). 
--   <--> The inner list of delays at index 'x' must correspond to the delays for the agent with ID 'x'. So e.g. delays!!1 must correspond to the delays
--        for agent 1. delays!!2 for agent 2 and so on. Agent 0 is always the simulator itself. 
--   <--> The connection between agent 0 (the simulator) and itself must always be a Just value. This is because Hiatons have a from and to ID of 0,
--        so if an agent outputs a Hiaton and there is no connection between the simulator and itself then this will cause an error.
--   <--> For debugging it makes sense that every agent's connection to agent 0 is Just 0 - so messages output to agent 0 are never delayed.
--   <--> For debugging it makes sense that agent 0's connection to everyone else is also Just 0. 
--
--   List lookups are slow, O(n), and since this adjacency matrix will never change throughout the simulation we can convert it into an array to turn the lookup time into O(1).
--   We use Haskell's Data.Vector module to convert the 2-D list into a 2-D vector. Vectors are implemented as arrays.
--
--                 >  delaysAsVector = Data.Vector.fromList (map Data.Vector.fromList delays)
--
--  We are now ready to encode the function which takes two Ints and returns the delay between them. We use the 'Data.Vector.!' function to retrieve the
--  value stored at the specified offset.

{-
  >  -- Code the function responsible for returning the delay between two agents. 
  >  getTimeStepDelay :: Int -> Int -> Int                    
  >  getTimeStepDelay agentFrom agentTo = delay
  >    where 
  >      agentFromDelayList  = delaysAsVector Data.Vector.! agentFrom
  >      delay               | agentFromDelayList Data.Vector.! agentTo == Nothing
  >                              = error ("getTimeStepDelay: There is no delay specified between agentFrom: "++(show agentFrom)++" and agentTo: "++(show agentTo))
  >                          | otherwise
  >                              = fromJust (agentFromDelayList Data.Vector.! agentTo) -- Otherwise, extract the Int from the Just constructor. 
-}
--   We can now create the DelayArg. This would be included in list of 'args' passed to the sim function.
--
-- >  delayarg = DelayArg (Str "DelayArg", getTimeStepDelay)
--
--------- ii) "maxDelay":
--
--   The simulator needs to know the maximum delay for your simulation. This is so that it knows how many delays queues to keep internally.
--   If you decide to encode your DelayArg like the example above, the function 'findMaxDelay' can be used on the list of lists definition of your delays
--   to return the maximum value:

findMaxDelay = RuntimeArgFunctions.findMaxDelay

--
--   You can then encode a 'maxDelay' argument which would be included in the list of args passed to the sim function, like so:
{-
  >  ---------------- maxDelay Arg
  >  maxDelay            = findMaxDelay delays   -- Find the maximum delay within the [ [ Maybe Int ] ] definition of delays.
  >  maxDelayAsDouble    = fromIntegral maxDelay -- Turn it into a double to match the type expected within the Arg constructor.
  >  maxDelayArg         = (Arg (Str "maxDelay", maxDelayAsDouble)) -- Wrap it in an Arg constructor, and include it in the list of args. 
-}
--
--   The call to fromIntegral is necessary to turn your Int into a Double, as per the type definition of Arg_t.

--------------------------------------------------------------------------------------------------------------
-- End: Commentary and helper Functions for the 'agents' parameter to sim, DelayArg, "maxDelay" arg
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- Begin: Commentary and helper Functions for AgentBimapArg
--------------------------------------------------------------------------------------------------------------

--     Since order is preserved by the transformForSim function the IDs of each agent can be known in advance. Since you would have defined your user list in the 'new style'
--     [(String, (Agent_t, [Int]) )] this allows us to generate a bidirectional mapping between agent labels and agent IDs. A pair (a,b) in a Bimap is coupled such that 'b' can
--     be found when 'a' is used as a key, and 'a' can be found when 'b' is used as a key (there is a one to one correspondence).
--
--     This is perfect for us, because there may be situations where we need to find the agentLabel corresponding to an ID (e.g. for the trace file output) as well as situations
--     where we need to find the agentID corresponding to the agentLabel (e.g. for an agent's wrapper logic to be decoupled from the ordering of the agent list). Since agentLabels and
--     agentIDs are unique for each agent, using a BiMap to store the information makes sense. The function generateAgentBimap is given the user defined agentList and returns the Bimap:

generateAgentBimap = RuntimeArgFunctions.generateAgentBimap

--     AgentBimapArg's purpose is to provide a function which if given an agentLabel returns the corresponding agentID, and 
--     if given the agentID it returns the agentLabel.
--     It needs to contain a function of the type (AgentIdentifier_t -> AgentIdentifier_t). The definition of AgentIdentifier_t is given as:
--
--              > data AgentIdentifier_t = AgentLabel String | AgentID Int
--
--              We generate a biMap using the same example user defined agent list (mainagents) for the DelayArg explanation above:
--        
--              > biMap = generateAgentBimap meinagents
--
-- We then code the function getCorrespondingAgentIdentifier. This is done by the user creating the experiment. An example is given below:
-- If you feed it an (AgentLabel String) it will return the corresponding (AgentID Int) and vice versa. 

generateAgentBimapArg = RuntimeArgFunctions.generateAgentBimapArg

-- Since all agents receive the runtime args which we passed to sim, each agent can use the Bimap to get the agent ID of the
-- other agents it communicates with - without needing to know the ID prior to the simulation starting. This decouples agents from
-- hard coding the ID into their logic and means that the order that agents are defined in the user defined agent list [(String, (Agent_t, [Int]) )]
-- does not matter to the agent (compared with before AgentBimapArg was added and a change in order would mean a change in the logic of the wrapper).
-- Examples of agents using the function getCorrespondingAgentIdentifier are given in this module in the definition of the agents above
-- (examplewrapper1, examplewrapper2 etc.)

--------------------------------------------------------------------------------------------------------------
-- End: Commentary and helper Functions for AgentBimapArg
--------------------------------------------------------------------------------------------------------------
