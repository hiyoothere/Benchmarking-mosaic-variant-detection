import sys
import glob
import random


#DataPath = "/data/project/MRS/4.Analysis_Mosaic/13.MSM/interim/"
#FILES = glob.glob(DataPath + "M*.vcf")
DataPath= sys.argv[1]
outfile=sys.argv[2]
DP=sys.argv[3]

FILES = glob.glob(DataPath + "/%s.M*.vcf"%DP )
print outfile

depth_ls = []
RAND = [] 
for file in FILES:
	print file
	f = open(file, 'r')
	for line in f:
		s = line.split()
		data = s[7].split(';')
		temp = {}
		for d in data:
			x = d.split('=')
			temp[x[0]] = x[1]
		depth_ls.append(temp['DP']) ## make a list of dp for each file
	f.close()

	R = random.sample(depth_ls, 2000) # select random 2000
	R = [int(r) for r in R] 
	RAND.extend(R) #merge (random 2000 dp) x (39 samples) into one list

print len(RAND)

import numpy as np

out = open(outfile, 'w')

data = [np.percentile(RAND,5), np.percentile(RAND,95)] ##find 5th and 95th percentile dp
d = [str(i) for i in data]

out.write('\t'.join(d))
out.close()


