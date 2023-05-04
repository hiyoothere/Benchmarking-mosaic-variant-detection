#!/usr/bin/python

import sys
import glob
sys.path.append("modules")
import Expect_VAF


f_ans = open("Expected_VAF.txt", 'r')
rl = f_ans.readlines()
dic = {}
def get(dic_vaf_ans, type):
	for each in rl:
		cnt = 0
		if each[0] == '#':
			s = each.split('\t')
			for i in range(1,len(s)):
				dic[i] = s[i]
				
		else:
			s = each.split('\t')
			for i in range(1,len(s)):
				if s[i] != '0':
					vaf = float(s[i]) * 100
					vtype = dic[i].split('-')[0]
					if vaf != 0:
						if i%2 == 1:
							Cnt_Ans = Expect_VAF.Cnt(vtype ,'het', 'hc', type)
						else:
							Cnt_Ans = Expect_VAF.Cnt(vtype ,'hom', 'hc', type)
						if vaf not in dic_vaf_ans:
							dic_vaf_ans[vaf] = Cnt_Ans
						else:
							dic_vaf_ans[vaf] += Cnt_Ans
	
	dictionary_items = dic_vaf_ans.items()
	dic_vaf_ans = sorted(dictionary_items)
	#print 'dic_vaf_ans: ', dic_vaf_ans
	return dic_vaf_ans	


