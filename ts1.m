main
i_f1_list ! 3

init
q = 4
k = 16

where
i_f1_list = _createlist i_f1 0
            where
            _createlist f t = (f t):(_createlist f (t+1))
            i_f1 0 = q
            i_f1 t = (i_f1_list ! (t-1) ) + (j_f1_list ! (t-2))
j_f1_list = _createlist j_f1 0
            where
            _createlist f t = (f t):(_createlist f (t+1))
            j_f1 0 = k
            j_f1 t = cond (t<0) (k_f1_list ! (t-1))
                             (25 + ((j_f1_list ! (t-1)) * (i_f1_list ! (t-1))) + (j_f2_list ! (t-1)))
j_f2_list = _createlist j_f2 0
            where
            _createlist f t = (f t):(_createlist f (t+1))
            j_f2 0 = k+q
            j_f2 t = cond (t<3) 27 ((j_f1_list ! (t-1)) + 27)
k_f1_list = _createlist k_f1 0
            where
            _createlist f t = (f t):(_createlist f (t+1))
            k_f1 0 = 0
            k_f1 t = k + q + (j_f1_list ! (t-1))
