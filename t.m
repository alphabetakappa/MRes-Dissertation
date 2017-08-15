|| This Miranda script tests various stages of the translation from
|| recurrence relations to an agent-based formulation
||
|| -------------------------
||

str == [char]
double == num
int == num
lob == [char]   || this is a placeholder - it is not used yet, and should be more structured

|| Later (in main6 onwards) we will use arg_t,  agentstate_t, msg_t etc. as follows:

arg_t ::= EmptyArg | Arg (str, double) 

getargstr EmptyArg = error "Can't get argstring from empty arg"
getargstr (Arg (s,n)) = s

getargval EmptyArg = error "Can't get argval from empty arg"
getargval (Arg (s,n)) = n


agentstate_t ::= Emptyagentstate | Agentstate (double, double, int, lob)

msg_t ::= Hiaton | Message (int,int) [arg_t] | Datamessage (int,int) [char]     
getmsgfrom  Hiaton                  = 0       || Essentially: the sim harness is the from/to of all Hiatons
getmsgfrom (Message (f,t) args)     = f
getmsgfrom (Datamessage (f,t) text) = f

getmsgto    Hiaton                  = 0       || Essentially: the sim harness is the from/to of all Hiatons
getmsgto   (Message (f,t) args)     = t
getmsgto   (Datamessage (f,t) text) = t

getmsgargs  Hiaton                  = []
getmsgargs (Message (f,t) args)     = args
getmsgargs (Datamessage (f,t) text) = error "Datamessage does not have data of type arg_t"

||agent_t == agentstate_t -> [arg_t] -> [(num, [msg_t])] -> num -> [[msg_t]] 



|| We need functions to get the components of a 3-tuple:

fst3 (a,b,c) = a
snd3 (a,b,c) = b
thd3 (a,b,c) = c


|| Miranda doesn't have a distfix conditional "if ... then ... else ..."
|| so we'll create something similar - a ternary conditional called "cond"

cond x y z = y, if x
           = z, otherwise

|| We also use the following function:

s_createlist    f   t = (f t):(s_createlist f (t+1))

|| -------------------------


||test x = (main0 x = main1 x = main2 x = main3 x = main4 x = main5a x = main5b x = main6 x = main7 x)

|| ==========
|| Original
|| 

main0 x 
      = i_f1 x
        where
        q = 4
        k = 16
        i_f1 0 = q
        i_f1 t = (i_f1 (t-1)) + (j_f1 (t-2))
        j_f1 (-1) = k
        j_f1 0 = k
        j_f1 t = cond (t<0) (k_f1 (t-1)) 
                 (25+((j_f1 (t-1))*(i_f1 (t-1))) + (j_f2 (t-1)))
        j_f2 0 = k+q
        j_f2 t = cond (t<3) 27 ((j_f1 (t-1)) + 27)
        k_f1 0 = 0
        k_f1 t = k + q + (j_f1 (t-1))




|| ==========
|| Step 1
|| 
main1 x
      = i_f1_list ! x
        where
        q = 4
        k = 16
        i_f1_list = s_createlist i_f1 0
                    where
                    i_f1 0 = q
                    i_f1 1 = (i_f1_list ! 0 ) + k
                    i_f1 t = (i_f1_list ! (t-1) ) + (j_f1_list ! (t-2))
        j_f1_list = s_createlist j_f1 0
                    where
                    j_f1 0 = k
                    j_f1 t = cond (t<0) (k_f1_list ! (t-1)) 
                             (25 + ((j_f1_list ! (t-1)) * (i_f1_list ! (t-1))) + (j_f2_list ! (t-1)))
        j_f2_list = s_createlist j_f2 0
                    where
                    j_f2 0 = k+q
                    j_f2 t = cond (t<3) 27 ((j_f1_list ! (t-1)) + 27)
        k_f1_list = s_createlist k_f1 0
                    where
                    k_f1 0 = 0
                    k_f1 t = k + q + (j_f1_list ! (t-1))



|| ==========
|| Step 2
|| 
main2 x
      = (i_wrapper ! x) ! 0
        where
        q = 4
        k = 16
        i_wrapper = (transpose [i_f1_list])
                    where
                    i_f1_list = s_createlist i_f1 0
                                where
                                i_f1 0 = q
                                i_f1 1 = (i_f1_list ! 0 ) + k
                                i_f1 t = (i_f1_list!(t-1)) + ((j_wrapper!(t-2))!0)
        j_wrapper = (transpose [j_f1_list, j_f2_list])
                    where
                    j_f1_list = s_createlist j_f1 0
                                where
                                j_f1 0 = k
                                j_f1 t = cond (t<0) ((k_wrapper!(t-1))!0) 
                                              (25 + ((j_f1_list!(t-1)) * ((i_wrapper!(t-1))!0)) 
                                                  + (j_f2_list!(t-1)))
                    j_f2_list = s_createlist j_f2 0
                                where
                                j_f2 0 = k+q
                                j_f2 t = cond (t<3) 27 ((j_f1_list ! (t-1)) + 27)
        k_wrapper = (transpose [k_f1_list])
                    where
                    k_f1_list = s_createlist k_f1 0
                                where
                                k_f1 0 = 0
                                k_f1 t = k + q + ((j_wrapper!(t-1)) ! 0)



|| ==========
|| Step 3
|| 
|| In main3, note that outputs now has niloutputs added to the front, so 
|| outputs at time (t-1) is given by outputs ! t

main3 x 
      = ((outputs!(x+1))!0)!0
        where
        q = 4
        k = 16
        nullvalue = 0
        niloutputs = [[nullvalue], [nullvalue, nullvalue], [nullvalue]]
        outputs    = niloutputs : (transpose [i_wrapper, j_wrapper, k_wrapper])
        i_wrapper  = transpose [i_f1_list]
                     where
                     i_f1_list = s_createlist i_f1 0
                     i_f1 0 = q
                     i_f1 1 = (i_f1_list ! 0 ) + k
                     i_f1 t = cond (t<0) 0 ((i_f1_list!(t-1)) + j_f1_2last_timestep)
                              where
                              j_f1_2last_timestep = (((outputs!(t-1))!1)!0)
        j_wrapper  = transpose [j_f1_list, j_f2_list]
                     where
                     j_f1_list = s_createlist j_f1 0
                                 where
                                 j_f1 0 = k
                                 j_f1 t = cond (t<0) k_f1_last_timestep
                                              (25 + ((j_f1_list ! (t-1)) * i_f1_last_timestep) 
                                                  + (j_f2_list ! (t-1)))
                                          where
                                          i_f1_last_timestep = (((outputs!t)!0)!0)
                                          k_f1_last_timestep = (((outputs!t)!2)!0)
                     j_f2_list = s_createlist j_f2 0
                                 where
                                 j_f2 0 = k+q
                                 j_f2 t = cond (t<3) 27 ((j_f1_list ! (t-1)) + 27)
        k_wrapper  = transpose [k_f1_list]
                     where
                     k_f1_list = s_createlist k_f1 0
                                 where
                                 k_f1 0 = 0
                                 k_f1 t = k + q + j_f1_last_timestep
                                          where
                                          j_f1_last_timestep = (((outputs!t)!1)!0) 
  

|| ==========
|| Step 4
|| 
|| NB In main4 the outputs are memorised in the message-passing list rather than being memorised in
||    a local list.  Therefore, the internal functions MUST NOT be recursive - to access their own 
||    values at time (t-1) they must get them from the current input.  If they try to evaluate 
||    recursively then the input value in the current time step is used over and over again as 
||    they loop (instead of using the previous value, and the previous previous value, etc etc).  
||    This is a problem Leo noticed previously.

main4 x
      = ((outputs!(x+1))!0)!0
        where
        q = 4
        k = 16
        nullvalue = 0
        niloutputs = [[nullvalue], [nullvalue, nullvalue], [nullvalue], [nullvalue]]
        outputs = niloutputs : transpose [ i_wrapper outputs 0 ,j_wrapper outputs 0 ,k_wrapper outputs 0,jf1_delay outputs 0]
        i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [(i_f1 t)]
                             i_f1 0 = q
                             i_f1 t = cond (t<0) 0
                                           ( ((inbound_messages_this_timestep!0)!0) 
                                            +((inbound_messages_this_timestep!3)!0))
        j_wrapper inputs t = outbound_messages_this_timestep : (j_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [(j_f1 t), (j_f2 t)]
                             j_f1 0 = k
                             j_f1 t = cond (t<0) k_f1_last_timestep
                                          (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                                      where
                                      i_f1_last_timestep = ((inbound_messages_this_timestep!0)!0)
                                      j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
                                      j_f2_last_timestep = ((inbound_messages_this_timestep!1)!1)
                                      k_f1_last_timestep = ((inbound_messages_this_timestep!2)!0)
                             j_f2 0 = k+q
                             j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                                      where
                                      j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
        k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [k_f1 t]
                             k_f1 0 = 0
                             k_f1 t = k + q + j_f1_last_timestep
                                      where
                                      j_f1_last_timestep = ((inbound_messages_this_timestep!1)!0)
        jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [(jf1_delayed t)]
                             jf1_delayed 0 = k
                             jf1_delayed t = ((inbound_messages_this_timestep!1)!0)




|| ==========
|| Step 5
||
|| Here we create from/to IDs in preparation for messaging
|| There are two versions (main5a and main5b).  It would be possible to skip straight
|| from main4 to main5b
||


main5a x
      = (thd3.hd) (((outputs!(x+1))!0)!0)
        where
        q = 4
        k = 16
        newnullvalue = [(0,0,0)]
        niloutputs = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue]]
        outputs = niloutputs : transpose [ i_wrapper outputs 0 ,j_wrapper outputs 0 ,k_wrapper outputs 0, jf1_delay outputs 0]
        i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = map f (hd inputs)
                                                               where
                                                               f xs = map g xs
                                                               g xs = filter h xs
                                                               h (a,b,c) = ((b=1) \/ (a,b,c) = (0,0,0))
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [ [ (1,1,res)  || from i to i
                                                                  ,(1,2,res)] || from i to j
                                                               ]
                                                               where
                                                               res = i_f1 t 
                             i_f1 0 = q
                             i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                                      where
                                      i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                      j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
        j_wrapper inputs t = outbound_messages_this_timestep : (j_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = map f (hd inputs)
                                                               where
                                                               f xs = map g xs
                                                               g xs = filter h xs
                                                               h (a,b,c) = ((b=2) \/ (a,b,c) = (0,0,0))
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [ [ (2,4,res1)  || from j to i
                                                                  ,(2,2,res1)  || from j to j 
                                                                  ,(2,3,res1)] || from j to k
                                                                ,[(2,2,res2)]  || from j to j
                                                               ] 
                                                               where
                                                               res1 = j_f1 t
                                                               res2 = j_f2 t
                             j_f1 0 = k
                             j_f1 t = cond (t<0) k_f1_last_timestep
                                          (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                                      where
                                      i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                      j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
                                      j_f2_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!1)
                                      k_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!2)!0)
                             j_f2 0 = k+q
                             j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                                      where
                                      j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
        k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = map f (hd inputs)
                                                               where
                                                               f xs = map g xs
                                                               g xs = filter h xs
                                                               h (a,b,c) = ((b=3) \/ (a,b,c) = (0,0,0))
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [[(3,2,k_f1 t)]]  || From k to j only
                             k_f1 0 = 0
                             k_f1 t = k + q + j_f1_last_timestep
                                      where
                                      j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
        jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = map f (hd inputs)
                                                               where
                                                               f xs = map g xs
                                                               g xs = filter h xs
                                                               h (a,b,c) = ((b=4) \/ (a,b,c) = (0,0,0))
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [[(4,1,jf1_delayed t)]]
                             jf1_delayed 0 = k
                             jf1_delayed t = (thd3.hd) ((inbound_messages_this_timestep!1)!0)






||
|| The second version (main5b) does the redaction in what is becoming the "sim" function
||
main5b x
      = sim (x+1)
        where
        q = 4
        k = 16
        sim x = (thd3.hd) (((outputs!x)!0)!0)
                where
                newnullvalue = [(0,0,0)]
                niloutputs = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue]]
                outputs = niloutputs : redactedoutputs
                redactedoutputs 
                 = transpose [ i_wrapper i_outputs 0 ,j_wrapper j_outputs 0 ,k_wrapper k_outputs 0, jf1_delay jf1_inputs 0 ]
                   where
                   i_outputs   = map (map (map (filter (h 1)))) outputs
                   j_outputs   = map (map (map (filter (h 2)))) outputs
                   k_outputs   = map (map (map (filter (h 3)))) outputs
                   jf1_inputs  = map (map (map (filter (h 4)))) outputs
		           h x (a,b,c) = ((b=x) \/ (a,b,c) = (0,0,0))
        i_wrapper inputs t = outbound_messages_this_timestep : (i_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [ [ (1,1,res)  || from i to i
                                                                  ,(1,2,res)] || from i to j
                                                               ]
                                                               where
                                                               res = i_f1 t 
                             i_f1 0 = q
                             i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                                      where
                                      i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                      j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
        j_wrapper inputs t = outbound_messages_this_timestep : (j_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [ [ (2,4,res1)  || from j to i
                                                                  ,(2,2,res1)  || from j to j 
                                                                  ,(2,3,res1)] || from j to k
                                                                ,[(2,2,res2)]  || from j to j
                                                               ] 
                                                               where
                                                               res1 = j_f1 t
                                                               res2 = j_f2 t
                             j_f1 0 = k
                             j_f1 t = cond (t<0) k_f1_last_timestep
                                          (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                                      where
                                      i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                                      j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
                                      j_f2_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!1)
                                      k_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!2)!0)
                             j_f2 0 = k+q
                             j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                                      where
                                      j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
        k_wrapper inputs t = outbound_messages_this_timestep : (k_wrapper future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [[(3,2,k_f1 t)]]  || From k to j only
                             k_f1 0 = 0
                             k_f1 t = k + q + j_f1_last_timestep
                                      where
                                      j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
        jf1_delay inputs t = outbound_messages_this_timestep : (jf1_delay future_messages (t+1))
                             where
                             inbound_messages_this_timestep  = hd inputs
                             future_messages                 = tl inputs
                             outbound_messages_this_timestep = [[(4,1,jf1_delayed t)]]
                             jf1_delayed 0 = k
                             jf1_delayed t = (thd3.hd) ((inbound_messages_this_timestep!1)!0)



|| ==========
|| Step 6
||
|| Here we start to make the "wrapper" functions look more like InterDyne agents
|| - First we pass the agent id number as the last number (and use it as "from" when sending output tuples)
|| - Combine input messages and time into a tuple (broadcast messages will be added later).
||   Notice that time is no longer incremented inside the agents (we use zip2 inside sim instead).
|| - Add runtime arguments to sim and to the agent wrappers (passing initial values - i.e. q and k)
|| - Add an agent local state argument (in place but currently unused)
|| - Make sim take a list of agent functions and (curently unused) broadcast channels as a third argument
||

   main6 x 
      = sim (x+1) runtime_args agentinfo
        where
        runtime_args = [(Arg ("q",4)), (Arg ("k", 16))]
        agentinfo = [(i_wrapper,[]), (j_wrapper, []), (k_wrapper, []), (jf1_delay, [])]
        sim x args agents
              = (thd3.hd) (((snd (outputs!x))!0)!0)
                where
                newnullvalue = [(0,0,0)]
                niloutputs = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue]]
                outputs = zip2 [0..] (niloutputs : (redactedoutputs))
                redactedoutputs 
                 = transpose (map apply_to_args (zip2 [1..] agents))
                   where
                   apply_to_args (agentid, (f,broadcastsubscriptions)) 
                                 = f Emptyagentstate args (myoutputs agentid) agentid
                   myoutputs id = map (f id) outputs
		           f x (t, xs)  = (t, map (map (filter (h x))) xs)
		           h x (a,b,c)  = ((b=x) \/ (a,b,c) = (0,0,0))
        i_wrapper localstate args inputs id 
              = outbound_messages_this_timestep : (i_wrapper localstate args future_messages id)
                where
                q = (getargval.hd) (filter ((="q").getargstr) args)
                k = (getargval.hd) (filter ((="k").getargstr) args)
                inbound_messages_this_timestep  = snd (hd inputs)
                t                               = fst (hd inputs)
                future_messages                 = tl inputs
                outbound_messages_this_timestep = [ [ (id,1,res)  || from i to i
                                                     ,(id,2,res)] || from i to j
                                                  ]
                                                  where
                                                  res = i_f1 t 
                i_f1 0 = q
                i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_2last_timestep)
                         where
                         i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                         j_f1_2last_timestep = (thd3.hd) ((inbound_messages_this_timestep!3)!0)
        j_wrapper localstate args inputs id 
              = outbound_messages_this_timestep : (j_wrapper localstate args future_messages id)
                where
                q = (getargval.hd) (filter ((="q").getargstr) args)
                k = (getargval.hd) (filter ((="k").getargstr) args)
                inbound_messages_this_timestep  = snd (hd inputs)
                t                               = fst (hd inputs)
                future_messages                 = tl inputs
                outbound_messages_this_timestep = [ [ (id,4,res1)  || from j to i
                                                     ,(id,2,res1)  || from j to j 
                                                     ,(id,3,res1)] || from j to k
                                                   ,[ (id,2,res2)] || from j to j
                                                  ] 
                                                  where
                                                  res1 = j_f1 t
                                                  res2 = j_f2 t
                j_f1 0 = k
                j_f1 t = cond (t<0) k_f1_last_timestep
                             (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                         where
                         i_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!0)!0)
                         j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
                         j_f2_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!1)
                         k_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!2)!0)
                j_f2 0 = k+q
                j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                         where
                         j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
        k_wrapper localstate args inputs id
              = outbound_messages_this_timestep : (k_wrapper localstate args future_messages id)
                where
                q = (getargval.hd) (filter ((="q").getargstr) args)
                k = (getargval.hd) (filter ((="k").getargstr) args)
                inbound_messages_this_timestep  = snd (hd inputs)
                t                               = fst (hd inputs)
                future_messages                 = tl inputs
                outbound_messages_this_timestep = [[(id,2,k_f1 t)]]  || From k to j only
                k_f1 0 = 0
                k_f1 t = k + q + j_f1_last_timestep
                         where
                         j_f1_last_timestep = (thd3.hd) ((inbound_messages_this_timestep!1)!0)
        jf1_delay localstate args inputs id
               = outbound_messages_this_timestep : (jf1_delay localstate args future_messages id)
                 where
                 inbound_messages_this_timestep  = snd (hd inputs)
                 future_messages                 = tl inputs
                 t                               = fst (hd inputs)
                 outbound_messages_this_timestep = [[(id,1,jf1_delayed t)]]
                 k = (getargval.hd) (filter ((="k").getargstr) args)
                 jf1_delayed 0 = k
                 jf1_delayed t = (thd3.hd) ((inbound_messages_this_timestep!1)!0)





|| ==========
|| Step 7
||
|| - Make the wrapper functions produce a list of lists of items of type msg_t
|| - Make the wrapper functions consume a list of tuples each containing time and a list of items of type msg_t
||
   main7 x 
      = sim (x+1) runtime_args agentinfo
        where
        runtime_args = [(Arg ("q",4)), (Arg ("k", 16))]
        agentinfo = [(i_wrapper,[]), (j_wrapper, []), (k_wrapper, []), (jf1_delay, [])]
        sim x runtime_args agentinfo 
              = (getargval.hd.getmsgargs) (((snd (outputs!x))!0)!0)
                where
                outputs = (0,[]):timed_transposed_msgs

                || timed_transposed_msgs is a list of outputs at each timestep,
                || each being a tuple of a time and a list of outputs from all agents
                || [(1,t1_outputs), (2,t2_outputs),...]

                timed_transposed_msgs = zip2 [1..] transposed_msgs

                || transposed_msgs is a list of outputs at each timestep
                || [t1_outputs, t2, outputs, ...]
                || each being a list of outputs from all agents
                || [t1_outputs_agent1, t1_outputs_agent2, ...]
                || each item of which is a list of msg_t

                transposed_msgs = transpose allmessages

                || allmessages is a list of outputs from each agent
                || [agent1_output, agent2_output, ...]
                || each of which is a list of outputs 
                || per timestep, each being a list of msg_t

                allmessages 
                 = map apply_to_args (zip2 [1..] agentinfo)
                   where
                   apply_to_args (agentid, (agentfn,broadcastsubscriptions)) 
                                 = agentfn Emptyagentstate runtime_args (redacted_msgs agentid outputs) agentid
      
                   ||redacted_msgs :: num -> [(num, [[msg_t]])] -> [(num,[msg_t])]
                   redacted_msgs id outputs     = map (f id) outputs
		           f x (time, xs)               = (time, concat (map (filter (h x)) xs))
		           h x Hiaton                   = False
		           h x (Message (f,t) args)     = (t=x)
                   h x (Datamessage (f,t) text) = error "Datamessage not yet implemented"
        || i_wrapper :: agent_t
        i_wrapper localstate args inputs id 
              = outbound_messages_this_timestep : (i_wrapper localstate args future_messages id)
                where
                q = (getargval.hd) (filter ((="q").getargstr) args)
                k = (getargval.hd) (filter ((="k").getargstr) args)
                inbound_messages_this_timestep  = snd (hd inputs)
                t                               = fst (hd inputs)
                future_messages                 = tl inputs
                outbound_messages_this_timestep = [ Message (id,1) [(Arg ("i_f1",res))] || from i to i
                                                   ,Message (id,2) [(Arg ("i_f1",res))] || from i to j
                                                  ]
                                                  where
                                                  res = i_f1 t 
                i_f1 0 = q
                i_f1 t = cond (t<0) 0 (i_f1_last_timestep + j_f1_last_timestep)
                         where
                         msgs_from_i        = filter ((=1).getmsgfrom) inbound_messages_this_timestep
                         args_from_i        = concat (map getmsgargs msgs_from_i)
                         i_f1_last_timestep = (getargval.hd) (filter ((="i_f1").getargstr) args_from_i)
                         msgs_from_j        = filter ((=4).getmsgfrom) inbound_messages_this_timestep
                         args_from_j        = concat (map getmsgargs msgs_from_j)
                         j_f1_last_timestep = (getargval.hd) (filter ((="j_f1d").getargstr) args_from_j)
        ||j_wrapper :: agent_t
        j_wrapper localstate args inputs id 
              = outbound_messages_this_timestep : (j_wrapper localstate args future_messages id)
                where
                q = (getargval.hd) (filter ((="q").getargstr) args)
                k = (getargval.hd) (filter ((="k").getargstr) args)
                inbound_messages_this_timestep  = snd (hd inputs)
                t                               = fst (hd inputs)
                future_messages                 = tl inputs
                outbound_messages_this_timestep = [ Message (id,4) [(Arg ("j_f1",res1))]  || from j to i
                                                   ,Message (id,2) [(Arg ("j_f1",res1))]  || from j to j 
                                                   ,Message (id,3) [(Arg ("j_f1",res1))]  || from j to k
                                                   ,Message (id,2) [(Arg ("j_f2",res2))]  || from j to j
                                                  ] 
                                                  where
                                                  res1 = j_f1 t
                                                  res2 = j_f2 t
                j_f1 0 = k
                j_f1 t = cond (t<0) k_f1_last_timestep
                             (25 + (j_f1_last_timestep * i_f1_last_timestep)+j_f2_last_timestep)
                         where
                         msgs_from_i        = filter ((=1).getmsgfrom) inbound_messages_this_timestep
                         args_from_i        = concat (map getmsgargs msgs_from_i)
                         i_f1_last_timestep = (getargval.hd) (filter ((="i_f1").getargstr) args_from_i)
                         msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                         args_from_j        = concat (map getmsgargs msgs_from_j)
                         j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
                         j_f2_last_timestep = (getargval.hd) (filter ((="j_f2").getargstr) args_from_j)
                         msgs_from_k        = filter ((=3).getmsgfrom) inbound_messages_this_timestep
                         args_from_k        = concat (map getmsgargs msgs_from_k)
                         k_f1_last_timestep = (getargval.hd) (filter ((="k_f1").getargstr) args_from_j)
                j_f2 0 = k+q
                j_f2 t = cond (t<3) 27 (j_f1_last_timestep + 27)
                         where
                         msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                         args_from_j        = concat (map getmsgargs msgs_from_j)
                         j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
        ||k_wrapper :: agent_t
        k_wrapper localstate args inputs id
              = outbound_messages_this_timestep : (k_wrapper localstate args future_messages id)
                where
                q = (getargval.hd) (filter ((="q").getargstr) args)
                k = (getargval.hd) (filter ((="k").getargstr) args)
                inbound_messages_this_timestep  = snd (hd inputs)
                t                               = fst (hd inputs)
                future_messages                 = tl inputs
                outbound_messages_this_timestep = [Message (id,2) [(Arg ("k_f1",k_f1 t))]]  || From k to j only
                k_f1 0 = 0
                k_f1 t = k + q + j_f1_last_timestep
                         where
                         msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                         args_from_j        = concat (map getmsgargs msgs_from_j)
                         j_f1_last_timestep = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)
        jf1_delay localstate args inputs id
               = outbound_messages_this_timestep : (jf1_delay localstate args future_messages id)
                 where
                 k = (getargval.hd) (filter ((="k").getargstr) args)
                 inbound_messages_this_timestep  = snd (hd inputs)
                 t                               = fst (hd inputs)
                 future_messages                 = tl inputs
                 outbound_messages_this_timestep = [Message (id, 1) [(Arg ("j_f1d", jf1_delayed t))]]
                 msgs_from_j        = filter ((=2).getmsgfrom) inbound_messages_this_timestep
                 args_from_j        = concat (map getmsgargs msgs_from_j)
                 jf1_delayed 0     = k
                 jf1_delayed t     = (getargval.hd) (filter ((="j_f1").getargstr) args_from_j)







|| We would like agents to end up with the following type:
|| type Agent_t = Agentstate_t -> [Arg_t] -> [(Int, [Msg_t], [Msg_t])] -> Int -> [[Msg_t]]
||
|| Thus, we still need to add broadcast messages





|| The above steps are sufficient for first-degree recurrence relations.  However, second-degree
|| recurrence relations may reference values at time t-2, and so on for third-degree and higher.
|| The next step will be to create local state and local history so that agents can reference values
|| from times t-2, t-3 etc.  This also supports recurrence relations that take other arguments in
|| addition to time - these can be passed inside the local state.
