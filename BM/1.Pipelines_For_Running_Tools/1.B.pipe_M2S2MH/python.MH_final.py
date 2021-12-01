import sys
import glob

def ND_DS(ID, DATA):
	if '0.DF' in DATA: ## whole
		data = DATA + '/ND-' + ID + '/final.passed.tsv'
	else: ### downsample
		id = ID.split('.')
		data = DATA + '/' + '-'.join(id) + '/final.passed.tsv'	
	return data

########################################################################################
##### STEP 1: sort SHARED and TISSUE-SPECIFIC
########################################################################################
def write_data(files, DATA, OutPath):

	sha_files = []
	sha_outfile = ""

	## distinguishe whether the file if shared or not by the length of the IDs present in file name
	for file in files:
		### WHOLE IDs
		ss = file.split('/')[-1].split('.')[0].split('_')
		### DOWNSAMPLE IDs
		if 'D' in file.split('/')[-1]:
                        ss = file.split('/')[-1].split('_')
                        ss[-1] = '.'.join(ss[-1].split('.')[0:2])
		
		### SHARED ############################################
		if '.sha.' in file:
			sha_files.append(file)
			if len(ss) < 3: ### find the non-resue shared file to make it the output filename for new directory
				sha_outfile = OutPath + '/' + file.split('/')[-1]		
			
		### tissue-specific ##################################
		else:
			ID = ss[-1] ## the last ID is the specific tissue
			data = ND_DS(ID, DATA) #grab MH raw call file of the specific tissue
			outfile = OutPath + '/' + file.split('/')[-1]
			extract_spec(file, data, outfile) ## data extraction

	### FOR SHARED : different method of data extraction
	write_shared(sha_files, DATA, sha_outfile)

########################################################################################
##### STEP 2-SHARED : sort through shared files to use proper MH call files
########################################################################################
def write_shared(sha_files, DATA, sha_outfile):
	
	FINAL={}
	for file in sha_files:
		ss = file.split('/')[-1].split('.')[0].split('_')
		if 'D' in file.split('/')[-1]:
                	ss = file.split('/')[-1].split('_')
                	ss[-1] = '.'.join(ss[-1].split('.')[0:2])
	
		if len(ss) < 3:
			ID = ss[0] ## when concurrent calls, use first ID which is case (M3)
                else:	
			ID = ss[-1] ## when spe-> shared calls(RESCUED), use third ID which is specific
		
		data = ND_DS(ID, DATA) ## grab files 
		FINAL = pos_data(file, FINAL, data, ss) #make dict of chr, pos, VAF of each shared tissue AND MH data

	extract_sha(FINAL,sha_outfile)

########################################################################################
##### STEP 3-SHARED : get MH data for each shared tissue position 
#######################################################################################	
def pos_data(file, FINAL, data, ss):
	f = open(file, 'r')
	for line in f:
                s = line.split()
                chr = s[0]
                pos = int(s[1])
		#if len(ss) < 3:
		#	vaf = s[2]
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
	
	d = open(data, 'r') ## extract data from MH for each chr, pos of shared tissue
	for line in d:
                s = line.split()
                chr2 = s[0]
                pos2 = int(s[1])
                if chr2 in FINAL:
                        if pos2 in FINAL[chr2]:
				vaf = FINAL[chr2][pos2].split('\t')
				if len(vaf) == 1: ## double cheack that the VAF is present
					if vaf != '.': ## check if VAF is a number
						s.append(vaf[0]) # add VAF to the end of the number 
       		 				FINAL[chr2][pos2] = '\t'.join(s) 
	d.close()

	return FINAL

def pos_dict(infile, temp): ### make dict of chr and pos of file
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


########################################################################################
##### STEP 4-SHARED :  write output of shared in sorted order
#######################################################################################
def extract_sha(FINAL, sha_outfile):
	chr_num =[]
	chr_alp = []
	
	for chr in FINAL:
		if any(i.isdigit() for i in chr) == True:
			chr_num.append(int(chr.replace('chr', ''))) # make list of chr in numbers (1,2,etc.)
		else:
			chr_alp.append(chr.replace('chr', '')) #make list of chr that are in alaphabets(X, Y, etc)

	## sort both chr number and alphabet list
	chr_num.sort()
	chr_alp.sort()

	out = open(sha_outfile, 'w')
	for i in range(0, len(chr_num)): ### FIRST, go through sorted chr numbers
		chr = 'chr'+str(chr_num[i])

		pos_ls = [] ## make pos list of each chr and sort
		for pos in FINAL[chr]:
			pos_ls.append(pos)
		pos_ls.sort()

		for j in range(0, len(pos_ls)): ## write output in sorted chr number and pos 
			s = FINAL[chr][pos_ls[j]].split()
			if len(s) > 1:
				out.write(FINAL[chr][pos_ls[j]] + '\n')


	for i in range(0, len(chr_alp)): ### SECOND, go through sorted chr alphabets
                chr = 'chr'+str(chr_alp[i])

                pos_ls = [] ## make pos list of each chr and sort
                for pos in FINAL[chr]:
                        pos_ls.append(pos)
                pos_ls.sort()
	
		for j in range(0, len(pos_ls)): ## write output in sorted chr number and pos 
			s = FINAL[chr][pos_ls[j]].split()
			if len(s) > 1:
	                        out.write(FINAL[chr][pos_ls[j]] + '\n')
	out.close()

########################################################################################
##### STEP 2-SPECIFIC : writing output
########################################################################################
def extract_spec(file, data, outfile):
	out = open(outfile, 'w')
	temp = {}
	position = pos_dict(file, temp) # extract position of the specific tissue
	d = open(data, 'r') ## MH raw CALL
	for line in d:
		s = line.split()
		chr = s[0]
                pos = int(s[1])
		if chr in position:
			if pos in position[chr]:
				out.write(line) ## if chr, pos of specific tissue in MH, write output
	d.close()
	out.close()

def main(POS_files, DATA, OutPath, ID_con, ID_cas):
	
	write_data(POS_files, DATA, OutPath)
	

####
####
#### EXECUTION
POS = sys.argv[1]
ID_con = sys.argv[2]
ID_cas = sys.argv[3]
DATA = sys.argv[4]
OutPath = sys.argv[5]

POS_files = glob.glob(POS + '/' + '_'.join([ID_cas, ID_con]) + "*txt" )
eval_ls = []
for i in range(0, len(POS_files)):
	file =POS_files[i].split('/')[-1]

        IDs = file.split('.')[0].split('_') ## whole IDs from glob files	
	if 'D' in file:
		IDs = file.split('_')
		IDs[-1] = '.'.join(IDs[-1].split('.')[0:2]) ## DS IDs from glob files
        
	## check if glob IDs match the given case and ctrl IDs
	if (IDs[1] != ID_con) | (IDs[0] != ID_cas): ## only grabbing files of ctrl and case ID (prevent from parsing M2-12 when M2-1)
                continue
        else :
                eval_ls.append(POS_files[i])
print eval_ls

main(eval_ls, DATA, OutPath, ID_con, ID_cas)




