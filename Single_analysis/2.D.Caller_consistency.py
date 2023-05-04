#!/usr/bin/python
import glob
import sys
def jcd_sim(list1, list2):
    intersection = len(list(set(list1).intersection(list2)))
    union = (len(list1) + len(list2)) - intersection
    if union != 0:
	    return float(intersection) / union
    else:
	    return 'NA'


def in_list(path):
	f_l = glob.glob(path + "*TP.vcf") #true positives. put each type of false positives here
#	print f_l
	l_ele = []
	for file in f_l:
		t = str(file).split('/')[6][0]
#		print file
		f = open(file, 'r')
		for line in f:
			if line[0] != '#':
				s = line.split('\t')
				if t=='3' : #3.DS_A
					if s[0][-1] == 'H':
						ele = s[1][3:] + ':' + s[2] + ':' + s[3]
                                                l_ele.append(ele)
					else:
						ele = s[1].split('.')[1] + ':' + s[2] + ':' + s[3]
						l_ele.append(ele)
				else:
					ele = s[1].split('.')[0] + ':' + s[2] + ':' + s[3]
                                        l_ele.append(ele)
	return l_ele

# put the parsed ouputs in four depths into lists. Put output path and prefix of those files
MH_d1 = in_list("/data/project/MRS/4.Analysis_Mosaic/1.MH/3.DS_A/mx/MH.D1")
MH_d2 = in_list("/data/project/MRS/4.Analysis_Mosaic/1.MH/3.DS_A/mx/MH.D2")
MH_d3 = in_list("/data/project/MRS/4.Analysis_Mosaic/1.MH/3.DS_A/mx/MH.D3")
MH_d4 = in_list("/data/project/MRS/4.Analysis_Mosaic/1.MH/1.DF_A/mx/MH")
MF_d1 = in_list("/data/project/MRS/4.Analysis_Mosaic/3.MF/3.DS_A/mx/MF.D1")
MF_d2 = in_list("/data/project/MRS/4.Analysis_Mosaic/3.MF/3.DS_A/mx/MF.D2")
MF_d3 = in_list("/data/project/MRS/4.Analysis_Mosaic/3.MF/3.DS_A/mx/MF.D3")
MF_d4 = in_list("/data/project/MRS/4.Analysis_Mosaic/3.MF/1.DF_A/mx/MF")
MT_d1 = in_list("/data/project/MRS/4.Analysis_Mosaic/4.MT/3.DS_A/mx/MT.D1")
MT_d2 = in_list("/data/project/MRS/4.Analysis_Mosaic/4.MT/3.DS_A/mx/MT.D2")
MT_d3 = in_list("/data/project/MRS/4.Analysis_Mosaic/4.MT/3.DS_A/mx/MT.D3")
MT_d4 = in_list("/data/project/MRS/4.Analysis_Mosaic/4.MT/1.DF_A/mx/MT")
HC20_d1 = in_list("/data/project/MRS/4.Analysis_Mosaic/7.HC20/3.DS_A/mx/HC20.D1")
HC20_d2 = in_list("/data/project/MRS/4.Analysis_Mosaic/7.HC20/3.DS_A/mx/HC20.D2")
HC20_d3 = in_list("/data/project/MRS/4.Analysis_Mosaic/7.HC20/3.DS_A/mx/HC20.D3")
HC20_d4 = in_list("/data/project/MRS/4.Analysis_Mosaic/7.HC20/1.DF_A/mx/HC20")
HC200_d1 = in_list("/data/project/MRS/4.Analysis_Mosaic/12.HC200/3.DS_A/mx/HC200.D1")
HC200_d2 = in_list("/data/project/MRS/4.Analysis_Mosaic/12.HC200/3.DS_A/mx/HC200.D2")
HC200_d3 = in_list("/data/project/MRS/4.Analysis_Mosaic/12.HC200/3.DS_A/mx/HC200.D3")
HC200_d4 = in_list("/data/project/MRS/4.Analysis_Mosaic/12.HC200/1.DF_A/mx/HC200")
DM_d4= in_list("/data/project/MRS/4.Analysis_Mosaic/14.DM/1.DF_A/mx/DM")
DM_d1 = in_list("/data/project/MRS/4.Analysis_Mosaic/14.DM/3.DS_A/mx/DM.D1")
DM_d2 = in_list("/data/project/MRS/4.Analysis_Mosaic/14.DM/3.DS_A/mx/DM.D2")
DM_d3 = in_list("/data/project/MRS/4.Analysis_Mosaic/14.DM/3.DS_A/mx/DM.D3")


import itertools 
# 1100x
l_all = ['DM_d4','MH_d4', 'HC200_d4','MF_d4','MT_d4',  'HC20_d4']
c2= list(itertools.permutations(l_all, 2))
dic_jcd = {}
for i in c2:
	l = list(i)
	dic_jcd[i] = jcd_sim(locals()[l[0]], locals()[l[1]])

print dic_jcd

out = open("D4.MX.TP.jcd.txt", 'w')

for i in dic_jcd:
	print i[0], i[1], dic_jcd[i]
	out.write(i[0] + '\t' + i[1] + '\t' + str(dic_jcd[i])+ '\n')
	out.write(i[0] + '\t' + i[0] + '\t1\n')

#D3
l_all = ['DM_d3','MH_d3', 'HC200_d3','MF_d3','MT_d3',  'HC20_d3']
c2= list(itertools.permutations(l_all, 2))
dic_jcd = {}
for i in c2:
        l = list(i)
        dic_jcd[i] = jcd_sim(locals()[l[0]], locals()[l[1]])

print dic_jcd

out = open("D3.MX.TP.jcd.txt", 'w')

for i in dic_jcd:
        print i[0], i[1], dic_jcd[i]
        out.write(i[0] + '\t' + i[1] + '\t' + str(dic_jcd[i])+ '\n')
        out.write(i[0] + '\t' + i[0] + '\t1\n')

l_all = ['DM_d2','MH_d2', 'HC200_d2','MF_d2','MT_d2',  'HC20_d2']
c2= list(itertools.permutations(l_all, 2))
dic_jcd = {}
for i in c2:
        l = list(i)
        dic_jcd[i] = jcd_sim(locals()[l[0]], locals()[l[1]])

print dic_jcd

out = open("D2.MX.TP.jcd.txt", 'w')

for i in dic_jcd:
        print i[0], i[1], dic_jcd[i]
        out.write(i[0] + '\t' + i[1] + '\t' + str(dic_jcd[i])+ '\n')
        out.write(i[0] + '\t' + i[0] + '\t1\n')

#D1
l_all = ['DM_d1','MH_d1', 'HC200_d1','MF_d1','MT_d1',  'HC20_d1']
c2= list(itertools.permutations(l_all, 2))
dic_jcd = {}
for i in c2:
        l = list(i)
        dic_jcd[i] = jcd_sim(locals()[l[0]], locals()[l[1]])

print dic_jcd

out = open("D1.MX.TP.jcd.txt", 'w')

for i in dic_jcd:
        print i[0], i[1], dic_jcd[i]
        out.write(i[0] + '\t' + i[1] + '\t' + str(dic_jcd[i])+ '\n')
        out.write(i[0] + '\t' + i[0] + '\t1\n')

