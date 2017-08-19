main
(i_wrapper ! 3) ! 0

init
q = 4
k = 16

where
i_wrapper = (transpose [i_f1_list])
            where
            i_f1_list = _createlist i_f1 0
                        where
                        _createlist f t = (f t):(_createlist f (t+1))
                        i_f1 0 = q
                        i_f1 1 = (i_f1_list ! 0 ) + k
                        i_f1 t = (i_f1_list ! (t-1) ) + (((j_wrapper ! (t-2)) ! 0)
                        endwhere
            endwhere
j_wrapper = (transpose [j_f1_list, j_f2_list])
            where
            j_f1_list = _createlist j_f1 0
                        where
                        _createlist f t = (f t):(_createlist f (t+1))
                        j_f1 0 = k
                        j_f1 t = cond (t<0) ((k_wrapper ! (t-1)) ! 0)
                                      (25 + ((j_wrapper ! (t-1)) ! 0) * ((i_wrapper ! (t-1)) ! 0) + (j_f2_list ! (t-1)))
                        endwhere
            j_f2_list = _createlist j_f2 0
                        where
                        _createlist f t = (f t):(_createlist f (t+1))
                        j_f2 0 = k+q
                        j_f2 t = cond (t<3) 27 ((j_f1_list ! (t-1)) + 27)
                        endwhere
            endwhere
k_wrapper = (transpose [k_f1_list])
            where
            k_f1_list = _createlist k_f1 0
                        where
                        _createlist f t = (f t):(_createlist f (t+1))
                        k_f1 0 = 0
                        k_f1 t = k + q + ((j_wrapper ! (t-1)) ! 0)
                        endwhere
            endwhere
