run_main = [main 0]

srt_i_f1 0 = 0

srt_j_f1 0 = 0

srt_j_f1 2 = 0

main runnumber =

[((sim_harness!0)!3)!0]

where
{
sim_harness = allmsg
              where
              allmsg  = _addsrtmsg restmsgs
              _addsrtmsg restmsgs = []                  ||adds startmsg to restmsgs : doesnt do it so have to make fun
              restmsgs = _createmsgs 1
              _createmsgs time = msg:_createmsgs (time+1)
                                 where
                                 msg = [_msgtowrap 1, _msgtowrap 2]
                                 _msgtowrap id = [(i_wrapper 1 (_createmsgs time) 1)!time, (j_wrapper 1 (_createmsgs) 2)!time]
                                      
i_wrapper t allmsg id = _outmsg:i_wrapper (t+1) (tl allmsg) id
                        where
                                      
                        redmsg = hd (allmsg!(id-1))
                                      
                        _outmsg = [_f1!t]

                        _f1 = _createlist 0
                              where
                              _createlist t = (_sublogic t):_createlist (t+1)
                              _sublogic   t = (i_f1!(t-1)) + ((redmsg!1)!0)

j_wrapper t allmsg id = _outmsg:j_wrapper (t+1) (tl allmsg) id
                        where
                        
                        redmsg = hd (allmsg!(id-1))
                                      
                        _outmsg = [_f1!t, _f2!t]
                                      
                        _f1 = _createlist 0
                              where
                              _createlist t = (_sublogic t):_createlist (t+1)
                              _sublogic   t = (j_f2!t) + (j_f1!(t-1))
    
                        _f2 = _createlist 0
                              where
                              _createlist t = (_sublogic t):_createlist (t+1)
                              _sublogic   t = myif (t<4) then (10) else (0)
}



to look back in time you have to pass a list contaiing those values through the recursion of the wrapper, however wont this valiate the type defintion of the wrapper?

How should a fucntion access its own value at a previous time step? this should be by passing a list through the recursion as well?

All fucntions within a wrapper can access all other functions within the same wrapper at time step t, but can only access functions in other wrappers at t-1
This is needed for both functionality and makes sense when creating agents with multiple parts which can be seen to operate at the same time

How do I send a message to the harness at this stage sense to and from dont exist?

When to and from do exist should a subfunction a wrapper be written like

msg = (0, id, _f1!t), if t = 3
msg = ..., otherwise

Is [!t]:recursion, a backwards list? does it make [...,t3,t2,t1] instead of [t1,t2,t3,...]

Do I need another step where I make the types correct?
