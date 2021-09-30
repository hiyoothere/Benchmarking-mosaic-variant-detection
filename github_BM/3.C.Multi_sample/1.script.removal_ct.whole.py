import glob
import sys
#from random import choice
import itertools

def M1(file, TOTAL):
	noalt_M1=0
	TPFP = file.split('_')[-1].split('.')[0]
	f = open(file, 'r')
	for line in f:
		s = line.split()
		chr=s[2]
		pos=s[3]
		if TPFP in TOTAL:
			if chr in TOTAL[TPFP]:
				if pos in TOTAL[TPFP][chr]:
					print "ERROR"
				else:
					TOTAL[TPFP][chr][pos] = ['M1']
			else:
				TOTAL[TPFP][chr] = {pos : ['M1'] }
		else:
			TOTAL[TPFP] = {chr : {pos : ['M1'] }}
	f.close()
	return TOTAL
	
def M1M2(file, TOTAL):
	M1M2_ct = 0
	M2_ct  = 0
	noalt_M2=0
	TPFP = file.split('_')[-1].split('.')[0]
	f = open(file, 'r')
	for line in f:
		s = line.split()
		chr=s[2]
                pos=s[3]
		M2_ct+=1
		if TPFP in TOTAL:
			if chr in TOTAL[TPFP]:
				if pos in TOTAL[TPFP][chr]:
					TOTAL[TPFP][chr][pos].append("M2")
					M1M2_ct +=1
	f.close()
			
	return TOTAL	

def M3(file, TOTAL,data):
	M1M2M3_ct = 0
	M1M2_M3_ct = 0
	M1M3_ct =0
	M1_ct=0#
	M3_ct = 0 #
	noalt_M3 = 0
	TPFP = file.split('_')[-1].split('.')[0]
	f = open(file, 'r')
	for line in f:
		s = line.split()
		chr=s[2]
                pos=s[3]
		M3_ct+=1
		if TPFP in TOTAL:
			if chr in TOTAL[TPFP]:
				if pos in TOTAL[TPFP][chr]:
					TOTAL[TPFP][chr][pos].append("M3")
	f.close()
	if TPFP in TOTAL:
		for chr in TOTAL[TPFP]:
			for pos in TOTAL[TPFP][chr]:
				temp = TOTAL[TPFP][chr][pos]	
				if ("M1" in temp) and ("M2" in temp) and ("M3" in temp):
					M1M2M3_ct+=1
				elif ("M1" in temp) and ("M2" in temp):
					M1M2_M3_ct+=1
				elif ("M1" in temp) and ("M3" in temp):
					M1M3_ct +=1
				else:
					M1_ct+=1

	data["M1M2M3_" + TPFP] = M1M2M3_ct
	data["M1M2_" + TPFP] = M1M2_M3_ct
	data["M1M3_" + TPFP] = M1M3_ct
	data["M1_" + TPFP] = M1_ct
	return TOTAL, data
def get_FN(M1_ls):
	FN = {}
	for file in M1_ls:
		infile  = file.replace("TP", "FN")
		f  = open(infile, "r")
		sample = infile.split('/')[-1].split('.')[-2].split('_')[0]
		ct = 0
		for line in f:
			if "#" in line:
				continue
			if "CHR" in line:
				continue
			else:
				ct+=1

		f.close()	
		if sample not in FN:
			FN[sample] = ct
		else:
			print "ERROR"
	print FN
	return FN

def main(infiles, out, cols, samples, FN):
	data = {}
	TOTAL = {}
	for file in infiles:
		if "M1" in file:
			TOTAL = M1(file, TOTAL) 
	for file in infiles:
		if "M2" in file:
			TOTAL = M1M2(file, TOTAL)
	for file in infiles:
		if "M3" in file:
			results = M3(file, TOTAL, data)
                        TOTAL = results[0]
                        data = results[1]
	line = [samples]
	for c in cols:
		if "SAMPLES" in c:
			continue
		##elif c == "M1_total_FN":
		##	line.append(str(FN_ct))
		elif c == "TP_rem_per":
                        TP1=data["M1M2_TP"] + data["M1M2M3_TP"]
                        if TP1 == 0:
                                line.append("NA")
                        else:
                                tp_rem = float(data["M1M2_TP"])/(TP1)*100
                                line.append(str(tp_rem))
		elif c == "FP_rem_per":
                        FP1=data["M1M2_FP"] + data["M1M2M3_FP"]
                        if FP1 == 0:
                                line.append("NA")
                        else:
                                fp_rem = float(data["M1M2_FP"])/(FP1)*100
                                line.append(str(fp_rem))
		else:
			line.append(str(data[c]))
	out.write('\t'.join(line) + '\n')

############## EXECUTION ###############

DIR = sys.argv[1] ##/data/project/MRS/4.Analysis_Mosaic/4.MT/1.DF_A
tag = sys.argv[2] ## snv or ind
outpath=sys.argv[3]

tool = DIR.split('/')[-2].split('.')[-1] ## MT


M1_ls = []
M2_ls = []
M3_ls = []
M1_files = []
all = glob.glob(DIR + '/mx/*TP*')
for a in all:
	sample = a.split('/')[-1].split('.')[-2].split('_')[0]
	if "M1" in a:
		M1_ls.append(sample)
		M1_files.append(a)
	elif "M2" in a:
		M2_ls.append(sample)
	else:
		M3_ls.append(sample)
M = [M1_ls, M2_ls, M3_ls]

FN = get_FN(M1_files)
print FN
combination = list(itertools.product(*M)) ### create 1944 combinations of M1*M2*M3

out = open(outpath + "/MT.whole." + tag + ".txt", 'w')
##cols = ["SAMPLES", "M1M2M3_TP", "M1M2M3_FP", "M1M2_TP","M1M2_FP", "M1M3_TP","M1M3_FP", "M1_TP", "M1_FP", "M1_total_FN","TP_rem_per", "FP_rem_per"]
cols = ["SAMPLES", "M1M2M3_TP", "M1M2M3_FP", "M1M2_TP","M1M2_FP", "M1M3_TP","M1M3_FP", "M1_TP", "M1_FP", "TP_rem_per", "FP_rem_per"]
out.write("\t".join(cols) + "\n")

for c in combination:
	infiles = []
	samples = '.'.join(c)
	FN_ct = FN[c[0]]
	for s in c:
		TP = glob.glob(DIR + "/tp/" + tool + "." + s + "_TP*") ##### TP from transplanted
		FP_mx = glob.glob(DIR + "/mx/" + tool + "." + s + "_FP*") ##### artifact FP 
		temp = TP + FP_mx
		for t in temp:
			if ("FP" in t) or ("TP" in t):
				continue
			#elif ("FN" in t) and ("M1" in t):
			#	continue
			else:
				temp.remove(t)
		infiles.extend(temp)
	main(infiles, out, cols, samples, FN_ct)
out.close()
