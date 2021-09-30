import sys
import glob
def create_dict(infile): ## get positions of case or control that are in question
	final_dict = {}
	
	f = open(infile, 'r')
	for line in f:
		s = line.split()
		chr = s[0]
		pos = s[1]
		alt_type = s[2]
                vaf = float(s[3])
		if chr in final_dict:
			if pos in final_dict[chr]:
				print "ERROR : position overlap"
			else:
				final_dict[chr][pos] = ["NA", alt_type, [vaf, 0.0]] # need to add VAF for 0.3 VAF filtration in the future
		else:
			final_dict[chr] = {pos : ["NA", alt_type, [vaf, 0.0]]}
	f.close()
	return final_dict

def find_alt(MH_dict, PU_files):
	ALT_dict = {}	
	use_nc = "FALSE"	
	for PU in PU_files:	
		ALT_dict = add_alt(PU, MH_dict) #place holder that has constantly updated PU alt_ct and VAF of the other tissue

	return ALT_dict	
		
def add_alt(PU, MH_dict):
	use_nc = "FALSE"
	pu = open(PU, 'r')
	for line in pu:
		s = line.split()
		chr = s[0]
		pos = s[1]
		alt_type = s[3]
                alt_ct=int(s[4])
                vaf = float(s[5])
		
		if chr in MH_dict:
			if pos in MH_dict[chr]:
				if MH_dict[chr][pos][1] == alt_type:
                                        MH_dict[chr][pos][0] = alt_ct #alt count of the other tissue
                                        MH_dict[chr][pos][2][1] = vaf
	pu.close()
	return MH_dict
	
def filter_alt(ALT_dict, OutPath, eval):
	sha_file = OutPath + "/" + eval.split('/')[-1].replace('.txt', '.sha.txt')
	spe_file = OutPath + "/" + eval.split('/')[-1]
	sha_out = open(sha_file, 'w') 
	spe_out = open(spe_file, 'w')
	#NO_alt=0
	for chr in ALT_dict:
		for pos in ALT_dict[chr]:
			alt = ALT_dict[chr][pos][0] #alt count of the other tissue
			alt_type = ALT_dict[chr][pos][1] 
			if alt != "NA":
				if alt >= 3: #FILTER : when other tissue's alt is at least 3
					
					### REMOVED
					if  (ALT_dict[chr][pos][2][0] >= 0.3) & (ALT_dict[chr][pos][2][1] >= 0.3): 
                                                continue
                                        #### SHARED (RESCUED)
					else: #FILTER : when the rescued VAF [OR] the VAF of tissue in question are no more than 0.3 
						PU_VAF = str(ALT_dict[chr][pos][2][1])
						sha_out.write('\t'.join([chr, pos, ALT_dict[chr][pos][1], PU_VAF])+ '\n')
				else:
					#### SPECIFIC : other tisse alt is less than 3
					spe_out.write('\t'.join([chr, pos]) + '\n')
			else:
				### SPECIFIC : no alt in other tissue
				spe_out.write('\t'.join([chr, pos]) + '\n')

	#print "No alt in PU : %s"%str(NO_alt)			
				
	sha_out.close()
        spe_out.close()

def main(eval_ls, PU, OutPath, ID_con, ID_cas):
	for eval in eval_ls:
		if 'D' not in ID_cas:
			ID = eval.split('/')[-1].split('.')[0].split('_')[-1]
		else:
			ID = eval.split('/')[-1].split('_')[-1].replace('.txt', '')
		print ID

		if ID == ID_con: #### get case alt for control positions
			MH_dict = create_dict(eval) # get ctrl positions
			PU_files = glob.glob(PU + "/" + ID_cas  + ".*snv.txt") #grab PU file of the other tissue(CASE)
			
			ALT_dict = find_alt(MH_dict, PU_files) #add alt ct and VAF when present in other tissue
			filter_alt(ALT_dict, OutPath, eval) #FILTERS : alt >=0 AND not VAF 0.3 in bothe tissues
		
		else: #### get control alt
			MH_dict = create_dict(eval) # get case positions    
			PU_files = glob.glob(PU + "/" + ID_con + ".*snv.txt") #grab PU file of the other tissue(CONTROL)
	
                        ALT_dict = find_alt(MH_dict, PU_files)  #add alt ct and VAF when present in other tissues
                        filter_alt(ALT_dict, OutPath, eval) #FILTERS : alt >=0 AND not VAF 0.3 in bothe tissues

####
####
#### EXECUTION
MH = sys.argv[1]
ID_con = sys.argv[2]
ID_cas = sys.argv[3]
PU = sys.argv[4]
OutPath = sys.argv[5]

MH_files = glob.glob(MH + '/' + '_'.join([ID_cas, ID_con]) + "*txt" )
eval_ls = []
for i in range(0, len(MH_files)):
	IDs = MH_files[i].split('/')[-1].split('_')
	if (IDs[1] != ID_con) | (IDs[0] != ID_cas): #### ensuring not to take in other samples
		continue
	elif "sha" not in MH_files[i]:
		eval_ls.append(MH_files[i])
print eval_ls
#
#PU_files = glob.glob(PU + "/" + ID + "*snv.txt")
#print PU_files
main(eval_ls, PU, OutPath, ID_con, ID_cas)




