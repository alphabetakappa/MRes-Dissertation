tomira infile outfile = [Tofile outfile result]
                        where
                        input = read infile

                        result = "main = "++blk1++"\n"++"where\n"++blk2++"\n"++blk3
                        rest0         = losemain input
                        (blk1, rest1) = findblk1 rest0 []
                        (blk2, blk3)  = findblk2 rest1 []

                        losemain ('m':'a':'i':'n':xs) = xs

                        findblk1 ('i':'n':'i':'t':xs) blk1 = (blk1, xs)
                        findblk1 (x:xs)               blk1 = findblk1 xs (blk1++[x])

                        findblk2 ('w':'h':'e':'r':'e':xs) blk2 = (blk2, xs)
                        findblk2 (x:xs)                   blk2 = findblk2 xs (blk2++[x])
