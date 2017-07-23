Main
i_f1_list ! 3

Init
q = 4
k = 16

Where
_createlist f t = (f t):(_createlist f (t+1))

i_f1_list = _createlist i_f1 0
            where
            i_f1 0 = q
            i_f1 t = (i_f1_list ! (t-1) ) + (j_f1_list ! (t-1))

j_f1_list = _createlist j_f1 0
            where
            j_f1 0 = k
            j_f1 t = if (t<0) then k else (25 + ((j_f1_list ! (t-1)) * (i_f1_list ! (t-1))) + (j_f2_list ! (t-1)))

j_f2_list = _createlist j_f2 0
            where
            j_f2 0 = k+q
            j_f2 t = (j_f1_list ! (t-3)) + 27
