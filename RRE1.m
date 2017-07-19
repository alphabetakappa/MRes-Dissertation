run_main = [main 0]

srt_i_f1 0 = 0

srt_j_f1 0 = 0

srt_j_f1 2 = 0

main runnumber =

[i_f1 3]

where
{
i_f1 t = i_f1 (t-1) + j_f1 (t-1)
    
j_f1 t = j_f2 t + j_f1 (t-1)
    
j_f2 t = myif (t<4) then (10) else (0)
}
