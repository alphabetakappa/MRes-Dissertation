main
h_sim (3+1)

init
q = 4
k = 16

where
h_sim x = (thd3.hd) (((outputs!x)!0)!0)
          where
          newnullvalue = [(0,0,0)]
          niloutputs   = [[newnullvalue], [newnullvalue, newnullvalue], [newnullvalue], [newnullvalue]]
          outputs      = niloutputs : redactedoutputs
          redactedoutputs = transpose [ i_wrapper i_inputs 0 ,j_wrapper j_inputs 0 ,k_wrapper k_inputs 0, jf1_delay jf1_inputs 0 ]
                            where
                            i_inputs   = map (map (map (filter (h 1)))) outputs
                            j_inputs   = map (map (map (filter (h 2)))) outputs
                            k_inputs   = map (map (map (filter (h 3)))) outputs
                            jf1_inputs = map (map (map (filter (h 4)))) outputs
                            h x (a,b,c) = ((b=x) \/ (a,b,c) = (0,0,0))
                            endwhere
          endwhere
