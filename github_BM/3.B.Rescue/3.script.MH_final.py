import sys
import glob

def ND_DS(ID, DATA, TAG):
	tool = DATA.split('/')[-3].split('.')[-1]
	data = DATA + '/%s.%s_%s.vcf'%(tool, ID, TAG)
	return data

def write_data(files, DATA, OutPath, TAG):

	sha_files = []
	sha_outfile = ""
	for file in files:
		ss = file.split('/')[-1].split('.')[0].split('_')
		if '.sha.' in file: ## shared
			#print file
			sha_files.append(file)
		#	if len(ss) < 3: ## shared
		#		sha_outfile = OutPath + '/' + file.split('/')[-1]		
		#	
		else: ### tissue-specific
			ID = ss[-1]
			data = ND_DS(ID, DATA, TAG)
			outfile = OutPath + '/' + file.split('/')[-1]
			extract_spec(file, data, outfile)

	write_shared(sha_files, DATA, OutPath, TAG)

def write_shared(sha_files, DATA, OutPath, TAG):
	
	for file in sha_files:
		FINAL ={}
		ss = file.split('/')[-1].split('.')[0].split('_')
		if len(ss) < 3:
			ID = ss[0] ## when concurrent calls, use first ID which is case (M3)
                else:	
			ID = ss[-1] ## when spe-> shared calls, use thirdt ID which is specific
		data = ND_DS(ID, DATA, TAG)
		#print data
		#print ss
		sha_outfile = OutPath + '/' + file.split('/')[-1]
		#print sha_outfile
		FINAL = pos_data(file, FINAL, data, ss)
		extract_sha(FINAL,sha_outfile)
	
def pos_data(file, FINAL, data, ss):
	f = open(file, 'r')
	for line in f:
                s = line.split()
                chr = s[0]
                pos = int(s[1])
		#if len(ss) < 3:
		if '.sha.' in file:
			vaf = s[-1]
		else:
			vaf = '.'
                if chr in FINAL:
			if pos in FINAL[chr]:
				print "ERROR : position is already there"
				continue
			else:
                        	FINAL[chr][pos] = vaf
                else:
                        FINAL[chr] = {pos : vaf}
        f.close()
	d = open(data, 'r')
	for line in d:
                s = line.split()
		if 'id' in line:
			pass
		else:
			chr2 = s[2]
			pos2 = int(s[3])
                	if chr2 in FINAL:
                	        if pos2 in FINAL[chr2]:
					vaf = FINAL[chr2][pos2].split('\t')
					if len(vaf) == 1:
						if vaf != '.':
							s.append(vaf[0])
       			 				FINAL[chr2][pos2] = '\t'.join(s)
								
	d.close()

	return FINAL

def pos_dict(infile, temp):
	f = open(infile, 'r')
	for line in f:
		s = line.split()
		chr = s[0]
		pos = int(s[1])
		if chr in temp:
			temp[chr].append(pos)
			temp[chr].sort()
		else:
			temp[chr] = [pos]
	f.close()
	return temp

def extract_sha(FINAL, sha_outfile):
	#print sha_outfile
	chr_num =[]
	chr_alp = []
	for chr in FINAL:
		if any(i.isdigit() for i in chr) == True:
			chr_num.append(int(chr.replace('chr', '')))
		else:
			chr_alp.append(chr.replace('chr', ''))
	chr_num.sort()
	chr_alp.sort()
	out = open(sha_outfile, 'w')
	for i in range(0, len(chr_num)):
		chr = 'chr'+str(chr_num[i])
		pos_ls = []
		for pos in FINAL[chr]:
			pos_ls.append(pos)
		pos_ls.sort()
		for j in range(0, len(pos_ls)):
			s = FINAL[chr][pos_ls[j]].split()
			if len(s) > 1:
				out.write(FINAL[chr][pos_ls[j]] + '\n')

	for i in range(0, len(chr_alp)):
                chr = 'chr'+str(chr_alp[i])
                pos_ls = []
                for pos in FINAL[chr]:
                        pos_ls.append(pos)
                pos_ls.sort()
		for j in range(0, len(pos_ls)):
			s = FINAL[chr][pos_ls[j]].split()
			if len(s) > 1:
	                        out.write(FINAL[chr][pos_ls[j]] + '\n')
	out.close()

def extract_spec(file, data, outfile):
	out = open(outfile, 'w')
	temp = {}
	position = pos_dict(file, temp)
	d = open(data, 'r')
	for line in d:
		if 'id' in line:
			pass
		else:
			s = line.split()
			chr = s[2]
			pos = int(s[3])
			if chr in position:
				if pos in position[chr]:
					out.write(line)
	d.close()
	out.close()

def main(POS_files, DATA, OutPath, ID_con, ID_cas, TAG):
	#print POS_files	
	write_data(POS_files, DATA, OutPath, TAG)
	

####
####
#### EXECUTION
POS = sys.argv[1]
ID_con = sys.argv[2]
ID_cas = sys.argv[3]
DATA = sys.argv[4]
OutPath = sys.argv[5]

###TP
POS_files = glob.glob(POS + '/' + '_'.join([ID_cas, ID_con]) + "*TP*txt" )
eval_ls = []
for i in range(0, len(POS_files)):
        file=POS_files[i].split('/')[-1]

        IDs = file.split('.')[0].split('_')
        if 'D' in file:
                IDs = file.split('_')
                IDs[-1] = '.'.join(IDs[-1].split('.')[0:2]) ## DS IDs from glob files

	if (IDs[1] != ID_con) | (IDs[0] != ID_cas):
                continue
        else :
                eval_ls.append(POS_files[i])

main(eval_ls, DATA, OutPath, ID_con, ID_cas, "TP")


### FP
POS_files = glob.glob(POS + '/' + '_'.join([ID_cas, ID_con]) + "*FP*txt" )
eval_ls = []
for i in range(0, len(POS_files)):
	file=POS_files[i].split('/')[-1]

        IDs = file.split('.')[0].split('_')
	if 'D' in file:
                IDs = file.split('_')
                IDs[-1] = '.'.join(IDs[-1].split('.')[0:2]) ## DS IDs from glob files

        if (IDs[1] != ID_con) | (IDs[0] != ID_cas):
                continue
        else :
                eval_ls.append(POS_files[i])

main(eval_ls, DATA, OutPath, ID_con, ID_cas, "FP")



