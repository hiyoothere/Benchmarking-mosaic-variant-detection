import glob
import sys


def get_DM_DP(file, DM_DP, dp_frac):
	tag= file.split('/')[-2] ## mx or tp
	if "D" in file.split('/')[-1]: ## DOWNSAMPLE
		IDs = file.split('/')[-1].split('_')
		IDs[-1] = '.'.join(IDs[-1].split('.')[0:2])

		depth = IDs[0].split('.')[0]
		if len(IDs) == 2:
                        sample=IDs[0].split('.')[-1]
                else:
                        sample=IDs[-1].split('.')[-1]

                cohort = sample.split('-')[0]
                sample = depth + '.' + sample
		print sample
		DM_file = glob.glob(DM_DP + "/*" + depth + "*" + cohort + "*" + tag + "*" )
	else:
		IDs = file.split('/')[-1].split('.')[0].split('_')
		if len(IDs) == 2:
			sample=IDs[0]
		else:
			sample=IDs[-1]
		cohort = sample.split('-')[0]
                DM_file = glob.glob(DM_DP + "/*whole*" + cohort + "*" + tag + "*" )
			
	dm = open(DM_file[0], 'r')
	for line in dm:
		if '#' in line:
			continue
		else:
			s = line.split()
			if sample == s[0]:
				AVG_dp  = int(s[-2])
				dp = AVG_dp*dp_frac
				break
	dm.close() 
	return dp
		

def depth_filter(d , file, OutPath, DM_DP):
	print file
	outfile = OutPath + '/' + file.split('/')[-1] 
	in_f = open(file, 'r')
	out = open(outfile, 'w')
	for line in in_f:
		s = line.split()
		if len(s) < 3:
			continue
		#seq_depth = float(s[3])
		if "3.MF" in file:
			seq_depth = float(s[32]) ##s[8+24]
		elif "14.DM" in file:
			#print float(s[25])
			seq_depth = get_DM_DP(file, DM_DP, float(s[25]))
		

		if (d[0] < seq_depth ) & (seq_depth < d[1]): #when sequencing depth is in between the or equal to the filtering depths
			out.write(line)
		else: 
			#print seq_depth
			pass
	
	in_f.close()
	out.close()

def main(eval_ls, OutPath, DEPTH, DM_DP):
	
	d = []
	depth = open(DEPTH, 'r')
	for line in depth:
		d = line.split()
	depth.close()

	d = [float(i) for i in d] # as of 21.07.16 the depth values are 132.0, 1472.0

	for file in eval_ls:	
		depth_filter(d , file, OutPath, DM_DP)


####EXECUTION
ID_con = sys.argv[1]
ID_cas = sys.argv[2]
DataPath = sys.argv[3]
OutPath = sys.argv[4]
DEPTH = sys.argv[5] ## provided depth from the random 2000 from each transplanted 38 samples
DM_DP = sys.argv[6] ## avg seq depth for DeepMosaic

print DataPath
infiles = glob.glob(DataPath + '/' + '_'.join([ID_cas, ID_con]) + '*txt') 
eval_ls = []
for i in range(0, len(infiles)):
	file =infiles[i].split('/')[-1]

        IDs = file.split('.')[0].split('_')## sample IDs (ex.M1-1) for both cas and con from files
        
	if 'D' in file: ### reassign IDs when downsample
                IDs = file.split('_')
                IDs[-1] = '.'.join(IDs[-1].split('.')[0:2])
	
	##check to only use IDs that were given not all files (prevent from grabbing M2-12 when looking for M2-1)
        if (IDs[1] != ID_con) | (IDs[0] != ID_cas):
                continue
        else :
                eval_ls.append(infiles[i])
#print DEPTH
#print eval_ls

## start parsing
main(eval_ls, OutPath, DEPTH, DM_DP)
