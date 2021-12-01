import sys
import glob
def create_dict(infile):
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
				final_dict[chr][pos] = ["NA", alt_type, [vaf, 0.0]]
		else:
			final_dict[chr] = {pos : ["NA", alt_type, [vaf, 0.0]] }
	f.close()
	return final_dict

def find_alt(MH_dict, PU_files):
	ALT_dict = {}	
	use_nc = "FALSE"	
	for PU in PU_files:
		#if 'mx' in PU:
		#	result = add_alt(PU, MH_dict)
		#	ALT_dict = result
		#else:
		#	result = add_alt(PU, MH_dict)
                #        ALT_dict = result
		#print PU
		result = add_alt(PU, MH_dict)
		ALT_dict = result
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
		#if 'mx' in PU:
		#	alt_ct = int(s[4])
		#else: 
		#	if 'snv' in s[-1]:
		#		alt_ct = int(s[4])
		#	else:
		#		continue
		if chr in MH_dict:
			if pos in MH_dict[chr]:
				if MH_dict[chr][pos][1] == alt_type:
					MH_dict[chr][pos][0] = alt_ct
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
			alt = ALT_dict[chr][pos][0]
			alt_type = ALT_dict[chr][pos][1] 
			if alt != "NA":
				if alt >= 3:
					if  (ALT_dict[chr][pos][2][0] >= 0.3) & (ALT_dict[chr][pos][2][1] >= 0.3):
						continue
					else:
						#sha_out.write('\t'.join([chr, pos, str(alt) ,str(ALT_dict[chr][pos][2])]) + '\n')
						PU_VAF = str(ALT_dict[chr][pos][2][1])
						sha_out.write('\t'.join([chr, pos, ALT_dict[chr][pos][1], PU_VAF])+ '\n')
				else:
					#spe_out.write('\t'.join([chr, pos, str(alt),str(ALT_dict[chr][pos][2])]) + '\n')
					spe_out.write('\t'.join([chr, pos])+ '\n')
			else:
				#print '_'.join([chr, pos])
				#print ALT_dict[chr][pos]
				#spe_out.write('\t'.join([chr, pos, str(alt), str(ALT_dict[chr][pos][2])]) + '\n')
				spe_out.write('\t'.join([chr, pos])+ '\n')

	#print "No alt in PU : %s"%str(NO_alt)			
				
	sha_out.close()
        spe_out.close()

def main(eval_ls, PU, OutPath, ID_con, ID_cas, TAG):
	if TAG == "TP":
		tag = "pc"
	else:
		tag = "nc"

	for eval in eval_ls:
		if 'DS' in eval:
			ID = eval.split('/')[-1].split('_')[-1].replace('.%s.txt'%TAG, '')
		else:
			ID = eval.split('/')[-1].split('.')[0].split('_')[-1]
		#print "%s specific"%ID
		print ID
		if ID == ID_con: #### get case alt
			MH_dict = create_dict(eval)
			if 'IND' in eval:
				PU_files = glob.glob(PU + "/" + ID_cas  + "*" + tag + "*ind.txt")
			else:
				PU_files = glob.glob(PU + "/" + ID_cas + "*" + tag + "*snv.txt")
			ALT_dict = find_alt(MH_dict, PU_files)	
			filter_alt(ALT_dict, OutPath, eval) 
		else: #### get control alt
			MH_dict = create_dict(eval)     
			if 'IND' in eval:
	                        PU_files = glob.glob(PU + "/" + ID_con + "*" + tag + "*ind.txt")
			else:
                                PU_files = glob.glob(PU + "/" + ID_con + "*" + tag + "*snv.txt")
                        ALT_dict = find_alt(MH_dict, PU_files)  
                        filter_alt(ALT_dict, OutPath, eval)

		#print PU_files

####
####
#### EXECUTION
MH = sys.argv[1]
ID_con = sys.argv[2]
ID_cas = sys.argv[3]
PU = sys.argv[4]
OutPath = sys.argv[5]

tag=["TP", "FP"]

for TAG in tag:
	MH_files = glob.glob(MH + '/' + '_'.join([ID_cas, ID_con]) + "*" + TAG + "*txt" )
	eval_ls = []
	for i in range(0, len(MH_files)):
		IDs = MH_files[i].split('/')[-1].split('_')
		if (IDs[1] != ID_con) | (IDs[0] != ID_cas): #### ensuring not to take in other samples
			continue
		elif "sha" in MH_files[i]:
			continue
		else:
			eval_ls.append(MH_files[i])
	print eval_ls
	main(eval_ls, PU, OutPath, ID_con, ID_cas, TAG)



