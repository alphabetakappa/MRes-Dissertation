main
i_f1 3

init
q = 4
k = 16

where
i_f1 0 = q
i_f1 t = (i_f1 (t-1)) + (j_f1 (t-2))
j_f1 0 = k
j_f1 t = cond (t<0) (k_f1 (t-1)) (25+((j_f1 (t-1))*(i_f1 (t-1))) + (j_f2 (t-1)))
j_f2 0 = k+q
j_f2 t = cond (t<3) 27 ((j_f1 (t-1)) + 27)
k_f1 0 = 0
k_f1 t = k + q + (j_f1 (t-1))
