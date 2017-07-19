run_main = [main 0]

srt_i_f1 0 = 0

srt_j_f1 0 = 0

srt_j_f1 2 = 0

main runnumber =

[i_f1!3]

where
{
i_f1 = _createlist 0
       where
       _createlist t = (_sublogic t):_createlist (t+1)
       _sublogic   t = (i_f1!(t-1)) + (j_f1!(t-1))
    
j_f1 = _createlist 0
       where
       _createlist t = (_sublogic t):_createlist (t+1)
       _sublogic   t = (j_f2!t) + (j_f1!(t-1))
    
j_f2 = _createlist 0
       where
       _createlist t = (_sublogic t):_createlist (t+1)
       _sublogic   t = myif (t<4) then (10) else (0)
}
