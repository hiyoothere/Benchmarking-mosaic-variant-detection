#!/bin/python
import sys
f = open("2fold_sen.txt", 'r')
weight = float(sys.argv[2])
dic_ans = {}
dic_tp = {}
dic_fp = {}
for i in range(4):
	for j in range(4):
		heng = str(i) + ',' + str(j)
		dic_ans[heng] = 0 
		dic_tp[heng] = 0
		dic_fp[heng] = 0
print dic_ans
for line in f:
	s = line.split('\t')
	if s[0] == sys.argv[1]:
		vafset = s[2]
		print vafset
		
		if len(vafset.split('/')) > 1:
			case = float(vafset.split('/')[0])*0.01
			cont = float(vafset.split('/')[1])*0.01
			ans = float(s[3])
			tp = float(s[4])
                        if case <=0.05: #heng = 0
                                if cont <= 0.05:
                                        dic_ans['0,0'] += ans
                                        dic_tp['0,0'] += tp
                                elif cont <= 0.1:
                                        dic_ans['0,1'] += ans
                                        dic_tp['0,1'] += tp
                                elif cont <= 0.25:
                                        dic_ans['0,2'] += ans
                                        dic_tp['0,2'] += tp
                                else:
                                        dic_ans['0,3'] += ans
                                        dic_tp['0,3'] += tp
                        elif case <= 0.1:
                                if cont <= 0.05:
                                        dic_ans['1,0'] += ans
                                        dic_tp['1,0'] += tp
                                elif cont <= 0.1:
                                        dic_ans['1,1'] += ans
                                        dic_tp['1,1'] += tp
                                elif cont <= 0.25:
                                        dic_ans['1,2'] += ans
                                        dic_tp['1,2'] += tp
                                else:
                                        dic_ans['1,3'] += ans
                                        dic_tp['1,3'] += tp
                        elif case <= 0.25:
                                if cont <= 0.05:
                                        dic_ans['2,0'] += ans
                                        dic_tp['2,0'] += tp
                                elif cont <= 0.1:
                                        dic_ans['2,1'] += ans
                                        dic_tp['2,1'] += tp
                                        print '2,1: ' + vafset
                                elif cont <= 0.25:
                                        dic_ans['2,2'] += ans
                                        dic_tp['2,2'] += tp
                                else:
                                        dic_ans['2,3'] += ans
                                        dic_tp['2,3'] += tp
                        else:
                                if cont <= 0.05:
                                        dic_ans['3,0'] += ans
                                        dic_tp['3,0'] += tp
                                elif cont <= 0.1:
                                        dic_ans['3,1'] += ans
                                        dic_tp['3,1'] += tp
                                        print '3,1: ' + vafset
                                elif cont <= 0.25:
                                        dic_ans['3,2'] += ans
                                        dic_tp['3,2'] += tp
                                else:
                                        dic_ans['3,3'] += ans
                                        dic_tp['3,3'] += tp

	
print dic_ans
print dic_tp
out = open("/data/project/MRS/5.Combined_Analysis/SharedVAF/3grade_sen.txt", 'a')
FP_dir = '/data/project/MRS/4.Analysis_Mosaic/'+ sys.argv[1] +'/1.a.DF_PA/mx/'
import glob
fps = glob.glob(FP_dir + '*_FP.common.vcf')
fps_tp = glob.glob('/data/project/MRS/4.Analysis_Mosaic/'+ sys.argv[1] +'/1.a.DF_PA/tp/*_FP.common.vcf')
fps = fps + fps_tp
print fps
for file in fps:
	f = open(file, 'r')
	dic_temp = {}
	for line in f:
		s = line.split('\t')
		sample = s[1]
		chr = s[2]
		pos = s[3]
		vaf = s[4]
		if sample[:2] == 'M3':
			if chr+':'+pos not in dic_temp:
				dic_temp[chr+':'+pos] = s[4]
			else:
				dic_temp[chr+':'+pos] = s[4] + ',' + dic_temp[chr+':'+pos]
		else: #M2
			if chr+':'+pos not in dic_temp:
                                dic_temp[chr+':'+pos] = s[4]
                        else:
                                dic_temp[chr+':'+pos] =   dic_temp[chr+':'+pos] + ',' + s[4]

	if len(dic_temp) != 0:
		for pos in dic_temp:
			case = float(dic_temp[pos].split(',')[0])
			cont = float(dic_temp[pos].split(',')[1])
                        if case <= 0.05: #heng = 0
                                if cont <= 0.05:
                                        dic_fp['0,0'] += 1
                                elif cont <= 0.1:
                                        dic_fp['0,1'] += 1
                                elif cont <= 0.25:
                                        dic_fp['0,2'] += 1
                                else:
                                        dic_fp['0,3'] += 1
                        elif case <= 0.1:
                                if cont <= 0.05:
                                        dic_fp['1,0'] += 1
                                elif cont <= 0.1:
                                        dic_fp['1,1'] += 1
                                elif cont <= 0.25:
                                        dic_fp['1,2'] += 1
                                else:
                                        dic_fp['1,3'] += 1
                        elif case <= 0.25:
                                if cont <= 0.05:
                                        dic_fp['2,0'] += 1
                                elif cont <= 0.1:
                                        dic_fp['2,1'] += 1
                                        print '2,1: ' + vafset
                                elif cont <= 0.25:
                                        dic_fp['2,2'] += 1
                                else:
                                        dic_fp['2,3'] += 1
                        else:
                                if cont <= 0.05:
                                        dic_fp['3,0'] +=1
                                elif cont <= 0.1:
                                        dic_f['3,1'] += 1
                                elif cont <= 0.25:
                                        dic_fp['3,2'] += 1
                                else:
                                        dic_fp['3,3'] += 1

print dic_fp

from scipy.stats import hmean
#import statistics
for i in range(4):
        for j in range(4):
                heng = str(i) + ',' + str(j)
		ans = dic_ans[heng] 
		tp = dic_tp[heng]
		fp = dic_fp[heng]
#		cof = (tp+fp)/(tp+(593.17*fp))
		if ans != 0:
			sen = tp/ans
			if tp+fp > 0:
				pre = (tp/(tp + fp))
				cof = (tp+fp)/(tp+(weight*fp))
	
				precof = pre*cof
				out.write("%s\t%s\t%s\t%s\t%f\t%s\t%s\t%s\t%f\t%f\n" %(sys.argv[1], str(i), str(j),str(ans),  sen, str(pre),str(cof), str(pre*cof), tp, fp ))
		else:
				pre = 'null'
				cof = 'null'
				precof = 'null'
		#	fscore = hmean([pre,sen])
		#	fscore = statistics.harmonic_mean(sen,pre)
				out.write("%s\t%s\t%s\t%s\t%f\t%s\t%s\t%s\t%f\t%f\n" %(sys.argv[1], str(i), str(j),str(ans),  sen, str(pre),str(cof), 'null', tp, fp ))





