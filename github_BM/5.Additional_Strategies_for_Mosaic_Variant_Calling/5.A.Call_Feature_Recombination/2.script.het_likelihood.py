import sys

def main(infile, outfile, FIL, PASS):

        TP_og = 0
        TP_pass = 0
        TP_fil = 0

        FP_og = 0
        FP_pass = 0
        FP_fil=0
	
	inf = open(infile, 'r')
	fil_f= open(FIL, 'w')
        pass_f = open(PASS, 'w')
	
	idx = 0
	for line in inf:
		s = line.split()
		if "TP_FP" in line:
			idx = s.index("het_likelihood")
		else:
			if s[1] == "TP":
                                TP_og+=1
                        else : ## FP orginal count
                                FP_og+=1

			if float(s[idx]) > 0.25 :
				fil_f.write(line)
				if s[1] == "TP":
                                        TP_fil+=1
                                else:
                                        FP_fil+=1

			else:
				pass_f.write(line)
				if s[1] == "TP":
                                        TP_pass+=1
                                else:
                                        FP_pass+=1

	inf.close()
	fil_f.close()
        pass_f.close()

        out = open(outfile, 'a')

        data = {0 : ["het_likelihood", "TP", str(TP_og), str(TP_pass), "PASSED"],
                1 : ["het_likelihood", "TP", str(TP_og), str(TP_fil), "REMOVED"],
                2 : ["het_likelihood", "FP", str(FP_og), str(FP_pass), "PASSED"],
                3 : ["het_likelihood", "FP", str(FP_og), str(FP_fil), "REMOVED"]}

        for i in data:
                line = '\t'.join(data[i]) + '\n'
                out.write(line)

        out.close()
	



##############################################
DIR=sys.argv[1]
infile=sys.argv[2]
outfile=sys.argv[3]

infile = DIR + infile
outfile = DIR + outfile
FIL = infile.replace(".txt", ".het_likelihood.filtered.txt")
PASS = infile.replace(".txt", ".het_likelihood.PASS.txt")

main(infile, outfile, FIL, PASS)
