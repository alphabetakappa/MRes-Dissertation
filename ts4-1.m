main
((s_outputs!(3+1))!0)!0

init
q = 4
k = 16

where
s_outputs  = niloutputs : (transpose [i_wrapper s_outputs 0, j_wrapper s_outputs 0, k_wrapper s_outputs 0, jf1_delay s_outputs 0 ])
             where
             niloutputs = [[nullvalue], [nullvalue, nullvalue], [nullvalue], [nullvalue]]
             nullvalue = 0
