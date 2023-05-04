#!/usr/bin/python

# Put answers into list
f_M1 = open("M1.pc.snv.vcf", 'r')
l_M1 = []
for line in f_M1:
    locus = ';'.join(line.split('\t')[0:2])
    l_M1.append(locus)

f_M2 = open("M2.pc.snv.vcf", 'r')
l_M2 = []
for line in f_M2:
    locus = ';'.join(line.split('\t')[0:2])
    l_M2.append(locus)

f_M3 = open("M3.pc.snv.vcf", 'r')
l_M3 = []
for line in f_M3:
    locus = ';'.join(line.split('\t')[0:2])
    l_M3.append(locus)

out_FN = open("FN_position.bed", 'w')
import sys
import glob
sys.path.append("../module/")
import Expect_VAF
import __Dic_VAF_ANS
dir_f = "/data/project/MRS/4.Analysis_Mosaic/0.PU/1.DF_A/parse_mx_wc2/0.by_var_type/" #path to pileup files
filelist = glob.glob(dir_f + '*parse.pc_snv.txt') #pileup files
dic_ans = {}
dic_alt_zero = {}
cnt_zero = 0
cnt_nonzero = 0
for file in filelist:
    f = open(file, 'r')
    f_name = str(f).split('/')[-1]
    sample = f_name.split('.')[0]
    print (sample)
    Mtype = sample.split('-')[0]
    if Mtype == 'M1':
        l_Mtype =  l_M1
    elif Mtype == 'M2':
        l_Mtype =  l_M2
    elif Mtype == 'M3':
        l_Mtype =  l_M3
    for line in f:
        s = line.strip().split('\t')
        #Have to compare if it's final pc
        locus = s[0] + ';' + s[1]
        if locus in l_Mtype:
            dp = s[2]
            alt = s[4]
            var = s[-1]
            v = var.split('_')[0]
            zyg = var.split('_')[1]
            exp_vaf = Expect_VAF.VAF(sample, v, zyg)
            if exp_vaf not in dic_ans:
                dic_ans[exp_vaf] = 1
            else:
                dic_ans[exp_vaf] += 1
            if alt == '0':
                out_FN.write(s[0] + '\t' + str(int(s[1])-1) + '\t' + s[1] + '\n')
                
                if exp_vaf not in dic_alt_zero:
                    dic_alt_zero[exp_vaf] = 1
                    #rint (line)
                else:
                    dic_alt_zero[exp_vaf] += 1
            else:
                cnt_nonzero +=1

out = open("FN_alt_zero_stat.txt", 'w')
out.write("%s\t%s\t%s\t%s\t%s\t%s\n" %("exp_VAF", "cnt_ans", "alt_nonzero", "alt_zero", "ratio_alt_nz", "ratio_alt_zero"))
l_exp_vaf = list(dic_ans.keys())
l_exp_vaf.sort()
print (l_exp_vaf)
print (dic_ans)
for exp_vaf in l_exp_vaf:
    ans = dic_ans[exp_vaf]
    zero_alt = 0
    if exp_vaf in dic_alt_zero:
        zero_alt = dic_alt_zero[exp_vaf]
    nonzero_alt = ans - zero_alt
    print (exp_vaf, ans, nonzero_alt ,zero_alt , nonzero_alt/ans, zero_alt/ans)
    out.write("%f\t%d\t%d\t%d\t%f\t%f\n" %(round(exp_vaf,2), ans, nonzero_alt ,zero_alt , nonzero_alt/ans, zero_alt/ans))


f_FN = open("FN_alt_zero_stat.txt", 'r')

dic_fn_nonzero = {}
for line in f_FN:
    s = line.split('\t')
    if s[0] == 'exp_VAF':
        l_header = s
    else:
        dic_line = dict(zip(l_header, s))
        dic_fn_nonzero[dic_line['exp_VAF']] =  dic_line['ratio_alt_nz']
print (dic_fn_nonzero)

import scipy
from scipy import stats
out = open("../output/FN_CP_snv.txt", 'w')
l_snv = [0,1,2,3,4, 7.5, 9.6, 25, 100]
l_graph = [1,2,3,4,7.5,  9.6, 20, 35]
dic_bin_ans = {}
dic_bin_alt_zero = {}
for i in range(len(l_snv)-1):
    lower = l_snv[i]
    upper = l_snv[i+1]
    ranges = '[' + str(lower) + ',' + str(upper) + ')'
    dic_bin_ans[ranges] = 0
    tmp_ans =0
    nz_ans =0
    print (lower, upper)
    for VAF in dic_fn_nonzero:
        each_vaf = round(float(VAF),2)
        for j in dic_vaf_ans:
            if each_vaf == float(j[0]):
                ori_ans = float(j[1])
                ratio_nz = float(dic_fn_nonzero[VAF])

                if lower <= each_vaf < upper:
                    tmp_ans += ori_ans
                    nz_ans += ori_ans*ratio_nz
    print (tmp_ans, nz_ans, round(nz_ans/tmp_ans, 2), l_graph[i])
    out.write(str(l_graph[i]) +'\t' + str(tmp_ans) + '\t' +  str(nz_ans) + '\t' + str(round(nz_ans/tmp_ans, 2))+ '\n' )
                    
