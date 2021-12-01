#!/usr/bin/python

import sys
import glob
sys.path.append("/home/hiyoothere/modules/")
import Expect_VAF
import __Dic_VAF_ANS

from scipy.stats import hmean

##1. Gather Expected VAFs in the reference data 
l_total_ans = [] 
f_total_ans = open("/data/project/MRS/Resource/Expected_VAF.txt",'r')
for line in f_total_ans:
	if line[0] != '#':
		s = line.split('\t')
		for i in range(1,len(s)):
			ans_vaf = round((float(s[i]) * 100),2)
			if ans_vaf not in l_total_ans:
				l_total_ans.append(ans_vaf)
l_total_ans.remove(0.0)
print l_total_ans
	
## Get variant call count for each VAF 
b= 8
tool_list = ['3.MF','1.MH',  '4.MT','7.HC20','12.HC200', '14.DM']
for tool in tool_list:
	dic_vaf_ans = {}
        dic_vaf_call = {}
	out = open('single_Perf_by_VAF.hc.snv.D3.txt','a')
	filelist = glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/3.DS_A/tp/*D3*TP.vcf")
	l_cnt = []
	for file in filelist:
		l_vars = []
		f = open(file,'r')
		#dic_ans = {}
		dic_eachfile = {}
		firline = f.readlines()[0]
		f = open(file,'r')
		sample  = firline.split('\t')[1]
		sample = sample.split('.')[1]
		if sample[1] == '1': #M1
                        l_vars.extend(['V1:het', 'V1:hom', 'V2:het', 'V2:hom'])
                elif sample[1] == '2': #M2
                        l_vars.extend(['V1:het', 'V1:hom', 'V3:het', 'V3:hom', 'V4:het', 'V4:hom'])
                else: #M3
                        l_vars.extend(['V1:het', 'V1:hom', 'V3:het', 'V3:hom', 'V5:het', 'V5:hom'])
		print 'l_vars: ' , l_vars
                for i in l_vars:
               		v = i.split(':')[0]
                        type = i.split(':')[1]
                        Cnt_Ans = Expect_VAF.Cnt(v,type, 'hc', 'snv')
                        VAF =  Expect_VAF.VAF(sample,v,type)
			dic_eachfile[VAF] = 0
		for line in f:
			info = line.split('\t')[5]
			v = info.split(':')[1][:2]
			type = info.split('_')[1]
			VAF =  Expect_VAF.VAF(sample,v,type)
			dic_eachfile[VAF] += 1
		l_cnt.append(dic_eachfile)
		dic_ans_total = {}
	print 'l_cnt: ',l_cnt
	print 'length l_cnt : ', len(l_cnt)
	for i in range(len(l_cnt)):
		for vaf in l_cnt[i]:
			each_dic = l_cnt[i]
			call = int(each_dic[vaf])
			if vaf not in dic_vaf_call: 
				dic_vaf_call[vaf] = call
			else:
			
				dic_vaf_call[vaf] += call
	dic_vaf_ans = {}
	dic_vaf_ans = __Dic_VAF_ANS.get(dic_vaf_ans, 'snv')
	print 'dic_vaf_ans: ', dic_vaf_ans
	## Total number of variant calls in each expected VAFs
	print 'dic_vaf_call: ', dic_vaf_call

	tot_ans = 0
	for i in dic_vaf_ans:
		vaf = i[0]
		cnt = i[1]
		tot_ans += cnt
	bin_size =  float(tot_ans)/b
	print "Total number of Answer is : ", tot_ans
	print "BIN SIZE IS: " , bin_size

	l_bin_cnt = []
	for i in range(b):
		cnt = (i+1)*bin_size
		l_bin_cnt.append(cnt)
	print l_bin_cnt	
	cnt_in_bin = 0 
	l_bin = []
	l_multiple = []
	for i in range(len(l_bin_cnt)):
		cnt_in_bin = 0
		l_each  =  []
		for j in dic_vaf_ans:
			print j
			vaf = j[0] 
			cnt = j[1] 
			cnt_in_bin += int(cnt) 
			if cnt_in_bin < l_bin_cnt[i]:
				if str(vaf) + ':' + str(cnt) not in l_multiple:
					l_each.append(str(vaf) + ':' + str(cnt))
					l_multiple.append(str(vaf) + ':' + str(cnt))
		l_bin.append(l_each)
	print l_bin
	l_range = []
	for vafs in l_bin:
		 if len(vafs) != 0:
			each_range = str(vafs[0].split(':')[0]) + ' <= VAF < next ' 	
			l_range.append(float(vafs[0].split(':')[0]))
			print each_range
		 else:
			print "VAF"
			
	print l_range 
	l_range.append(100.0)
	l_range[0] = 0 
	l_key = []
	f_ans = {}
	f_call = {}
	print dic_vaf_ans
	print dic_vaf_call
	for i in range(b):
		each_cnt_ans = 0
		print l_range[i]
		print str(l_range[i]) + ' <= v < ' + str(l_range[i+1])
		key = '['+ str(l_range[i]) + ',' + str(l_range[i+1])+ ')'
		l_key.append(key)
		for set in dic_vaf_ans:
			print set
			print set[0]
			if l_range[i] <= float(set[0]) < l_range[i+1]:
				cnt_ans = int(set[1])
				each_cnt_ans += cnt_ans
		print each_cnt_ans
		f_ans[key] = each_cnt_ans
		
	for i in range(b):
	        each_cnt_ans = 0
	        print str(l_range[i]) + ' <= v < ' + str(l_range[i+1])
	        key = '['+ str(l_range[i]) + ',' + str(l_range[i+1])+ ')'
	        for set in dic_vaf_call:
	                if l_range[i] <= float(set) < l_range[i+1]:
	                        cnt_ans = int(dic_vaf_call[set])
	                        each_cnt_ans += cnt_ans
	        print each_cnt_ans
	        f_call[key] = each_cnt_ans

	for i in l_key:
		print i, f_ans[i], f_call[i]
        fpfilelist = glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/3.DS_A/mx/*D3*FP.vcf")
	fp2 =  glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/3.DS_A/tp/*D3*FP.vcf")
	fpfilelist.extend(fp2)
	l_FP = []
	for file in fpfilelist:
                f = open(file,'r')
                for line in f:
                        vaf = float(line.split('\t')[4])
                        l_FP.append(vaf)
	print l_FP
	print len(l_FP)
	f_callfp = {}
	for i in range(b):
                each_cnt_ans = 0
                print str(l_range[i]) + ' <= v < ' + str(l_range[i+1])
                key = '['+ str(l_range[i]) + ',' + str(l_range[i+1])+ ')'
                for set in l_FP:
                        if l_range[i] <= float(set*100) < l_range[i+1]:
                                each_cnt_ans += 1
                f_callfp[key] = each_cnt_ans
	l_graph = [1,2,3,4,7.5,9.6,20, 35] # for visuallization
	idx = 0
	for i in l_key:
#                print tool, i, f_ans[i], f_call[i], f_callfp[i]
		sen = float(f_call[i])/f_ans[i]
		if f_call[i] == 0:
			ori_pre = 0
			if f_callfp[i] == 0:
				cof = 0
			else:
				cof = float((f_call[i] + f_callfp[i]))/(f_call[i]+(252.75*f_callfp[i]))
			
		else:
			ori_pre = float(f_call[i])/(f_call[i] + f_callfp[i])
			cof = float((f_call[i] + f_callfp[i]))/(f_call[i]+(252.75*f_callfp[i]))
		pre = ori_pre*cof
		if sen ==0 and pre == 0:
			fscore = 'null'
		else:
			fscore = hmean([float(sen),float(pre)])
	#	if fscore != 'null':
		out.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%f\n" %(tool, i, str(f_ans[i]), str(f_call[i]), str(f_callfp[i]), str(sen), str(ori_pre), str(cof), str(pre), str(fscore), l_graph[idx]))
		idx += 1		
		
			
	
