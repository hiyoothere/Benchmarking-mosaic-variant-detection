import glob
import sys




def depth_filter(d , file, OutPath):
	print file
	outfile = OutPath + '/' + file.split('/')[-1] 
	in_f = open(file, 'r')
	out = open(outfile, 'w')
	for line in in_f:
		s = line.split()
		if len(s) < 3:
			print s 
			continue
		
		seq_depth = float(s[3])
		
		if (d[0] < seq_depth ) & (seq_depth < d[1]): #when sequencing depth is in between the or equal to the filtering depths
			out.write(line)
	
	in_f.close()
	out.close()

def main(eval_ls, OutPath, DEPTH):
	
	d = []
	depth = open(DEPTH, 'r')
	for line in depth:
		d = line.split()
	depth.close()

	d = [float(i) for i in d] # as of 21.07.16 the depth values are 132.0, 1472.0

	for file in eval_ls:
		depth_filter(d , file, OutPath)


####EXECUTION
ID_con = sys.argv[1]
ID_cas = sys.argv[2]
DataPath = sys.argv[3]
OutPath = sys.argv[4]
DEPTH = sys.argv[5] ## provided depth from the random 2000 from each transplanted 38 samples

infiles = glob.glob(DataPath + '/' + '_'.join([ID_cas, ID_con]) + '*txt') 
eval_ls = []
for i in range(0, len(infiles)):
	file =infiles[i].split('/')[-1]

        IDs = file.split('.')[0].split('_')## sample IDs (ex.M1-1) for both cas and con from files
        
	if 'D' in file: ### reassign IDs when downsample
                IDs = file.split('_')
                IDs[-1] = '.'.join(IDs[-1].split('.')[0:2])
	print IDs
	
	##check to only use IDs that were given not all files (prevent from grabbing M2-12 when looking for M2-1)
        if (IDs[1] != ID_con) | (IDs[0] != ID_cas):
                continue
        else :
                eval_ls.append(infiles[i])
print eval_ls

## start parsing
main(eval_ls, OutPath, DEPTH)
