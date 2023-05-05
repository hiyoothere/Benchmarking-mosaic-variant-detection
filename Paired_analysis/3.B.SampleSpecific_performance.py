#!/usr/bin/python

import sys
import glob
sys.path.append("../module/")
import Expect_VAF
import __Dic_VAF_ANS
from scipy.stats import hmean

dir='/data/project/MRS/5.Combined_Analysis/Samplespecific/' # output path
##1. Gather Expected VAFs in the reference data 
l_total_ans = [] 
f_total_ans = open("../module/Expected_VAF.txt",'r')
for line in f_total_ans:
	if line[0] != '#':
		s = line.split('\t')
		for i in range(1,len(s)):
			ans_vaf = round((float(s[i]) * 100),2)
			if ans_vaf not in l_total_ans:
				l_total_ans.append(ans_vaf)
l_total_ans.remove(0.0)

	
## Get variant call count for each VAF 
tool = sys.argv[1] #Method to analyze
dic_vaf_ans = {}
dic_vaf_call = {}
out = open(dir+'sample_specific_Perf_by_VAF.hc.snv.txt','a') # output file
out_auprc = open( dir+tool + "_auprc_input.txt", 'w') #For AUPRC calculation
filelist = glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/1.a.DF_PA/SetB/*TP.uniq*.vcf") # Sample specific true positive variants from SetB
l_cnt = []
for file in filelist:
        print (file)
	l_vars = []
	f = open(file,'r')
	#dic_ans = {}
	dic_eachfile = {}
	f = open(file,'r')
	sample  = str(file).split('/')[-1]
        case = sample.split('_')[1]
        control = sample.split('_')[2]
        this = sample.split('_')[-1][:-4] #M3-1
#               print (case, control, this)
        v_type = {'M1':['V1', 'V2'], 'M2':['V1', 'V3', 'V4'], 'M3':['V1', 'V3', 'V5'] }
        this_Mtype = this[:2]
        this_var = set(v_type[this_Mtype])
        if this == case:
            counter = control
        elif this == control:
            counter = case
        else:
            print ("ERROR")
        counter_var = set(v_type[counter[:2]])
        this_only = this_var.difference(counter_var)
        for i in list(this_only):
            l_vars.append(i+':hom')
            l_vars.append(i+':het')
#               print (case, control, this, counter, l_vars)
        sample = this
	for i in l_vars:
		v = i.split(':')[0]
		type = i.split(':')[1]
		Cnt_Ans = Expect_VAF.Cnt(v,type, 'hc', 'snv')
		VAF =  Expect_VAF.VAF(sample,v,type)
		dic_eachfile[VAF] = 0
	for line in f:
		s = line.split('\t')
		info = line.split('\t')[5]
		v = info.split(':')[1][:2]
		type = info.split('_')[1]
		###Get value for AUPRC
		if tool == '3.MF': #mosaic probability
			value =  s[-4]
		elif tool == '1.MH':
			value = s[-1].rstrip('\n') #MH: mosaic probability
		elif tool == '4.MT':
			tmp_info = s[-3].split(';')
			for i in tmp_info:
				if 'TLOD' in i:
					value = i.lstrip("TLOD=")
                elif tool == '17.MT_PD':
                        tmp_info = s[-5].split(';')
                        for i in tmp_info:
                                if 'TLOD' in i:
                                        value = i.lstrip("TLOD=")
		elif tool == '14.DM':
			value = s[-3]
		elif tool == '7.HC20' or tool == '12.HC200':
			tmp_info = s[-3].split(';')
			for i in tmp_info:
				if 'QD' in i:
					value = i.lstrip("QD=")
		elif tool == '16.STK':
				tmp_info = s[-5].split(';')
				for i in tmp_info:
					if 'SomaticEVS' in i:
						value = i.lstrip('SomaticEVS=')
		elif tool == '13.MSM':
				if s[-4][:2] == 'GT':# line is from mt2
					tmp_info = s[-5].split(';')
					
					for i in tmp_info:
						if 'TLOD' in i:
								value = i.lstrip("TLOD=") 
				else: #line from MH
					value = 9999
                if v in list(this_only):
			VAF =  Expect_VAF.VAF(sample,v,type)
			out_auprc.write("%s\t%s\t%s\t%s\t%s\n" %(tool, sample, VAF, value, "tp"))
			dic_eachfile[VAF] += 1
	l_cnt.append(dic_eachfile)

print ('l_cnt: ',l_cnt)
print ('length l_cnt : ', len(l_cnt))
for i in range(len(l_cnt)):
	for vaf in l_cnt[i]:
		each_dic = l_cnt[i]
		call = int(each_dic[vaf])
		if vaf not in dic_vaf_call: 
			dic_vaf_call[vaf] = call
		else:
		
			dic_vaf_call[vaf] += call
dic_vaf_ans = {}
case = ['M3']
cont = ['M1', 'M2']
l_type= ['het', 'hom']
m_type = {'M1':9, 'M2':12, 'M3':18 }
v_type = {'M1':['V1', 'V2'], 'M2':['V1', 'V3', 'V4'], 'M3':['V1', 'V3', 'V5'] }
#v_type = {'M1':['V1'], 'M2':['V1', 'V3'], 'M3':['V1', 'V3'] }


for control in cont:
    for zyg in l_type:
        for i in range(m_type[control]):
            sample_control = control + '-' + str(i+1)
            for j in range(m_type['M3']):
                 sample_case = 'M3-' + str(j+1)
#               print (sample_case, sample_control)
                 l_var_case = set(v_type['M3'])
                 l_var_control = set(v_type[control])
                 case_only = l_var_case.difference(l_var_control)
                 control_only = l_var_control.difference(l_var_case)
#                print (list(case_only))
                 l_subtraction = []
                 dic_sample_var = {}
                 dic_sample_var['M3'] = list(case_only)
                 dic_sample_var[control] = list(control_only)
                 for each_sample in dic_sample_var:
                     l_ea_v = dic_sample_var[each_sample]
                     for ea_v in l_ea_v:
                         if each_sample[:2] == 'M3':
                             samp = sample_case
                         else:
                             samp = sample_control
                        # print (ea_v, samp)
                         ea_af = Expect_VAF.VAF(samp, ea_v.upper(), zyg)
                         ea_cnt = Expect_VAF.Cnt(ea_v.upper(), zyg, 'hc' , 'snv')
                         if ea_af not in dic_vaf_ans:
                             dic_vaf_ans[float(ea_af)] = 0
                         dic_vaf_ans[float(ea_af)] += ea_cnt
tot_ans = 0
#        print (dic_vaf_ans)
dic_vaf_ans = dict(sorted(dic_vaf_ans.items()))
print (dic_vaf_ans)
for i in dic_vaf_ans:
	vaf = i
	cnt = dic_vaf_ans[i]
	tot_ans += cnt
bin_size =  float(tot_ans)/b
#print "Total number of Answer is : ", tot_ans
#print "BIN SIZE IS: " , bin_size

l_bin_cnt = []
for i in range(b):
	cnt = (i+1)*bin_size
	l_bin_cnt.append(cnt)
#print l_bin_cnt	
cnt_in_bin = 0 
l_bin = []
l_multiple = []
for i in range(len(l_bin_cnt)):
	cnt_in_bin = 0
	l_each  =  []
	for j in dic_vaf_ans:
		#print j
		vaf = j 
		cnt = dic_vaf_ans[j] 
		cnt_in_bin += int(cnt) 
		if cnt_in_bin < l_bin_cnt[i]:
			if str(vaf) + ':' + str(cnt) not in l_multiple:
				l_each.append(str(vaf) + ':' + str(cnt))
				l_multiple.append(str(vaf) + ':' + str(cnt))
	l_bin.append(l_each)
print (l_bin)
l_range = []
for vafs in l_bin:
	if len(vafs) != 0:
		each_range = str(vafs[0].split(':')[0]) + ' <= VAF < next ' 
		l_range.append(float(vafs[0].split(':')[0]))
		print (each_range)
	else:
		print ("VAF")
		
l_range =  [0, 1, 2, 3, 4, 10, 15, 25, 100]
print (l_range)
l_key = []
f_ans = {}
f_call = {}
#print dic_vaf_ans
#print dic_vaf_call
for i in range(len(l_range)-1):
	each_cnt_ans = 0
	#print l_range[i]
	#print str(l_range[i]) + ' <= v < ' + str(l_range[i+1])
	key = '['+ str(l_range[i]) + ',' + str(l_range[i+1])+ ')'
	l_key.append(key)
	for set in dic_vaf_ans:
		#print set
		#print set[0]
		if l_range[i] <= float(set) < l_range[i+1]:
			cnt_ans = int(dic_vaf_ans[set])
			each_cnt_ans += cnt_ans
	print (each_cnt_ans)
	f_ans[key] = each_cnt_ans
	
for i in range(len(l_range)-1):
	each_cnt_ans = 0
	print (str(l_range[i]) + ' <= v < ' + str(l_range[i+1]))
	key = '['+ str(l_range[i]) + ',' + str(l_range[i+1])+ ')'
	for set in dic_vaf_call:
		if l_range[i] <= float(set) < l_range[i+1]:
			cnt_ans = int(dic_vaf_call[set])
			each_cnt_ans += cnt_ans
	print (each_cnt_ans)
	f_call[key] = each_cnt_ans

for i in l_key:
	print (i, f_ans[i], f_call[i])
fpfilelist = glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/1.a.DF_PA/SetA/*M*FP.uniq*.vcf") # Sample specific false positive variants from SetA (Non-variant)
fp2 =  glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/1.a.DF_PA/SetB/*M*FP.uniq*.vcf") # Sample specific false positive variants from SetB (Germline)
fpfilelist.extend(fp2)
l_FP = []
for file in fpfilelist:
	f = open(file,'r')
	for line in f:
		s = line.split('\t')
		info = line.split('\t')[5]
		if tool == '3.MF': #mosaic probability
			value =  s[-4]
		elif tool == '1.MH':
			value = s[-1].rstrip('\n') #MH: mosaic probability
		elif tool == '4.MT':
			tmp_info = s[-3].split(';')
			for i in tmp_info:
				if 'TLOD' in i:
					value = i.lstrip("TLOD=")
		elif tool == '14.DM':
			value = s[-3]
		elif tool == '7.HC20' or tool == '12.HC200':
			tmp_info = s[-3].split(';')
			for i in tmp_info:
				if 'QD' in i:
					value = i.lstrip("QD=")
		auprc_vaf = float(line.split('\t')[4]) * 100
		vaf = float(line.split('\t')[4])
		l_FP.append(vaf)
		out_auprc.write("%s\t%s\t%s\t%s\t%s\n" %(tool, sample, auprc_vaf, value, "fp"))
#print l_FP
#print len(l_FP)
f_callfp = {}
for i in range(len(l_range)-1):
	each_cnt_ans = 0
	print (str(l_range[i]) + ' <= v < ' + str(l_range[i+1]))
	key = '['+ str(l_range[i]) + ',' + str(l_range[i+1])+ ')'
	for set in l_FP:
		if l_range[i] <= float(set*100) < l_range[i+1]:
			each_cnt_ans += 1
	f_callfp[key] = each_cnt_ans
l_graph = [1,2,3,4,10, 15,25, 32] # for visuallization

idx = 0
print (l_key)
for i in l_key:
        print (i)
	sen = float(f_call[i])/f_ans[i]
	if f_call[i] == 0:
		ori_pre = 0
		if f_callfp[i] == 0:
			cof = 0
		else:
			cof = float((f_call[i] + f_callfp[i]))/(f_call[i]+(252.75*f_callfp[i])) #weight for SNV
		
	else:
		ori_pre = float(f_call[i])/(f_call[i] + f_callfp[i])
		cof = float((f_call[i] + f_callfp[i]))/(f_call[i]+(252.75*f_callfp[i]))
	pre = ori_pre*cof
	if sen ==0 and pre == 0:
		fscore = 'null'
	else:
		fscore = hmean([float(sen),float(pre)])
        print (tool, i, str(f_ans[i]), str(f_call[i]), str(f_callfp[i]), str(sen), str(ori_pre), str(cof), str(pre), str(fscore), l_graph[idx])
	out.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%f\n" %(tool, i, str(f_ans[i]), str(f_call[i]), str(f_callfp[i]), str(sen), str(ori_pre), str(cof), str(pre), str(fscore), l_graph[idx]))

	idx += 1		
	
		




