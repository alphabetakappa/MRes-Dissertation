main
i_f1 3

init
q = 4
k = 16

where
{
i_f1 0 = q
i_f1 t = (i_f1 (t-1) ) + (j_f1 (t-1))

j_f1 0 = k
j_f1 t = if (t<0) then k else (25 + ((j_f1 (t-1)) * (i_f1 (t-1))) + (j_f2 (t-1)))
j_f2 0 = k+q
j_f2 t = (j_f1 (t-3)) + 27
}
