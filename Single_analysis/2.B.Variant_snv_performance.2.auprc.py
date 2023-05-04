#!/usr/bin/python

import pandas as pd
import sys
from collections import OrderedDict
from operator import itemgetter
b= 8
l_bin_snv = [0, 1,  2, 3, 4, 7.5, 9.6, 25, 100.0]
tool_list = ['3.MF' ,'1.MH', '14.DM',  '4.MT','7.HC20','12.HC200']
l_bin_range = []
dic_cnt_ans_bin = {}
f_ans_bin = open('single_Perf_by_VAF.hc.' + variant_type +'.txt','r')
out_AUPRC = open('single_Perf_by_VAF.hc.' + variant_type +'.auprc.txt','a')
dic_tool_perf = {}
for line in f_ans_bin:
    s = line.strip().split('\t')
    tool = s[0]
    if tool not in dic_tool_perf:
        dic_tool_perf[tool] = [line]
    else:
        dic_tool_perf[tool].append(line)
    #print (s)
    each_bin = s[1][1:-1]
    small = each_bin.split(',')[0]
    #print (small)
    if small == str(0):
        pass
    else:
        small = small.rstrip('.0')
    large = each_bin.split(',')[1]
    if large == str(100.0):
        pass
    else:
        large = large.rstrip('.0')
    bin_range = small+ ' <= v < ' + large
    dic_cnt_ans_bin[bin_range] = s[2] #each_bin_ans
    if bin_range not in l_bin_range:
        l_bin_range.append(bin_range)

print (dic_cnt_ans_bin)
print ("l_bin_range; ", l_bin_range)
for tool in tool_list:
    dic_auprc = {}
    dic = {} #"range";:[readline]
    f = open(tool + "_auprc_input."+DP+"txt", 'r')
    rl = f.readlines()
    for i in range(1,len(l_bin_snv)):
        bin_range = str(l_bin_snv[i-1])+ ' <= v < ' + str(l_bin_snv[i])
        print ('range: ', bin_range)
        for each_line in rl:
            s = each_line.strip().split('\t')
            vaf = float(s[2])
            if l_bin_snv[i-1] <= vaf < l_bin_snv[i]:
                if bin_range not in dic:
                    dic[bin_range] = [each_line]
                else:
                    dic[bin_range].append(each_line)
                
    print (dic_tool_perf)
    for b in dic:
        df = pd.DataFrame({"vaf": [],
                      "value": [],
                      "truth": []})
        lines = dic[b]
        for each_line in lines:
            s = each_line.strip().split('\t')
            vaf = s[2]
            value = s[3]
            term = s[4]
	    new_row = {'vaf': vaf, 'value': value, 'truth': term}
	    df = df.append(new_row, ignore_index=True)
        df = df.sort_values(by=["value"], ascending= True)
        print (df)
        tp = 0
        fp = 0
        dic_sen = OrderedDict() #order:sen
        dic_pre = OrderedDict()
        cnt_ans = float(dic_cnt_ans_bin[b])
        for idx,row in df.iterrows():
            truth = row['truth']
	    print ("TRUTH", truth)
            value = row['value']
            print (value, truth)
            if truth == 'tp': #pc
                tp +=1
            elif truth == 'fp': #FP
                fp +=1
            if tp == 0 and fp == 0:
                sensitivty = 0
                precision = 'NA'
                dic_sen[idx] = sensitivty
                dic_pre[idx] = precision
            else:
                sensitivty = float(tp)/cnt_ans
                precision = float(tp)/(tp + fp)
                dic_sen[idx] = sensitivty
                dic_pre[idx] = precision
        sorted_dic_sen =OrderedDict(sorted(dic_sen.items(), key=itemgetter(1)))
        #print (sorted_dic_sen)
        l_sen = []
        l_pre = []
        for idx in sorted_dic_sen:
            l_sen.append(sorted_dic_sen[idx])
            pre = dic_pre[idx]
            l_pre.append(pre)
        print (tool, b, "max sen: ",l_sen[-1])
        print (tool, b, "min pre: ", l_pre[-1])
        AUPRC = 0
	if sum(l_sen) ==0:
		AUPRC = 'NA'
	else:
	        for i in range(1,len(l_pre)):
        	    tmp_AUPRC = (l_pre[i-1] + l_pre[i]) * (l_sen[i] - l_sen[i-1])/2
       # print (sensitivty, precision, tmp_AUPRC)
	            AUPRC += tmp_AUPRC
        print (b, AUPRC)
        dic_auprc[b] = AUPRC
    print ("dic_auprc: ", dic_auprc)
    

    for i in range(len(l_bin_range)):
        if l_bin_range[i] in dic_auprc:
            print (dic_auprc[l_bin_range[i]],"and it's line is ", dic_tool_perf[tool][i])
            out_AUPRC.write(dic_tool_perf[tool][i].rstrip('\n') + '\t' + str(dic_auprc[l_bin_range[i]]) + '\n')
        else:
            print ("THERE IS NO AUPRC for ",dic_tool_perf[tool][i] )
            out_AUPRC.write(dic_tool_perf[tool][i].rstrip('\n') + '\t' + 'null' + '\n')
