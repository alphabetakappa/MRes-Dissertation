h_sim x = outputfunction (x)
          where
          newnullvalue = [(0,0,0)]
          niloutputs   = listfuction (newnullvalue)
          outputs      = niloutputs : redactedoutputs
          redactedoutputs = transpose [ i_wrapper i_inputs 0 ,j_wrapper j_inputs 0]
                            where
                            i_inputs   = map (map (map (filter (h 1)))) outputs
                            j_inputs   = map (map (map (filter (h 2)))) outputs
                            h x (a,b,c) = ((b=x) \/ (a,b,c) = (0,0,0))
                            endwhere
          endwhere
