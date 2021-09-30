#!/usr/bin/python

import glob
import sys
from scipy.stats import hmean
#>>> hmean([1, 4])
tool = sys.argv[1]
weight = float(sys.argv[2])
out = open("/data/project/MRS/5.Combined_Analysis/Filter/Fil_ana." + tool + ".txt", "w")
types = ['mx', 'tp']
out.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", %('type', 'filter', 'tp', 'fp', 'ratio', 'sen', 'pre', 'fscore', 'str(F1-new_F1)', '((ratio of delta F1')) 
for type in types:
	print type
	c_tp = 0 
	c_fp = 0
	c_fn = 0
	c_tn = 0
	ori = open("/data/project/MRS/5.Combined_Analysis/Filter/" + tool + "." + type + ".summary.txt", "r")
	for line in ori:
		s = line.split('\t')
		tp = int(s[2])
		fp = int(s[3])
		fn = int(s[4].rstrip('\n'))
		c_tp += tp
		c_fp += fp
		c_fn += fn
	if type == 'mx':
		tot_n = 33093574 #number of negative controls in SetA
	else:
		tot_n = 10774 + 7050 #number of negative controls in SetB
	tn = tot_n - c_fp
	print "tn" , tn
	c_tn += tot_n 
	print c_tp
	print c_fp
	ans = c_tp + c_fn 
	sen = c_tp/float(ans)
	pre_ori = c_tp/float(c_tp + c_fp)
	cof= (c_tp + c_fp)/(c_tp + (weight*c_fp))
	pre = pre_ori * cof
#	F1 = (c_tp+c_tn) / float(c_tp + c_fn + c_fp + c_tn)

	F1 = hmean([sen, pre])
	F1_ratio = 1
	out.write(type + "\tori\t"+ str(c_tp) + '\t' + str(c_fp) + '\t' +str(c_tp/float(c_fp)) + '\t'+ str(sen)+ '\t' + str(pre) +'\t'+ str(F1) + '\t' +str(F1-F1)+ '\t0\n')
	dic_fil_tp = {}
	dic_fil_fp = {}
	l_fil = []
	fs_TP = glob.glob("/data/project/MRS/4.Analysis_Mosaic/"+tool+"/6.FIL/"+type+"/*TP.snv.vcf")
	for file in fs_TP:
		f = open(file, 'r')
		for line in f:
			s = line.split('\t')
			filter = s[14]
			print filter
			#print filter
			if filter not in l_fil:
				l_fil.append(filter)
			if filter not in dic_fil_tp:
				dic_fil_tp[filter] = 1
			else:
				dic_fil_tp[filter] += 1
	print dic_fil_tp
	fs_FP = glob.glob("/data/project/MRS/4.Analysis_Mosaic/"+tool+"/6.FIL/"+type+"/*FP.snv.vcf")
        for file in fs_FP:
                f = open(file, 'r')
                for line in f:
                        s = line.split('\t')
                        filter = s[14]
                        #print filter
                        if filter not in l_fil:
                                l_fil.append(filter)
                        if filter not in dic_fil_fp:
                                dic_fil_fp[filter] = 1
                        else:
                                dic_fil_fp[filter] += 1
        print dic_fil_fp
	for i in l_fil:
		if len(i.split(';')) == 1:
		
			if i in dic_fil_tp:
				fil_tp = dic_fil_tp[i]
			else:
				fil_tp = 0
			if i in dic_fil_fp:
        	                fil_fp = dic_fil_fp[i]
                	else:
                        	fil_fp = 0
			new_tp = c_tp+fil_tp
			new_fp = c_fp+fil_fp
			new_tn = tot_n - new_fp
			sen = new_tp/float(ans)
			pre_ori = c_tp/float(c_tp + c_fp)
			cof = float(new_tp + new_fp)/(new_tp + (weight*new_fp))
			pre = cof*pre_ori
			new_F1 = hmean([sen, pre])
			#new_F1 = float(new_tp + new_tn) / (tot_n + ans)
			F1_ratio = '-'
			if new_fp == c_fp:
				ratio = 'NA'
			else:
				ratio  = float(new_tp-c_tp)/(new_fp-c_fp)
		
			out.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" %(type, i, str(new_tp-c_tp), str(new_fp-c_fp), str(ratio), str(sen), str(pre), str(new_F1), str(F1-new_F1), str((F1-new_F1)/F1))
	

