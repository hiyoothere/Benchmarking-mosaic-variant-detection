#!/usr/bin/python

import sys
import os
Tool = sys.argv[1]

DIR="/data/project/MRS/4.Analysis_Mosaic/" + Tool + "/1.DF_A/mx/"
OUTDIR="/data/project/MRS/4.Analysis_Mosaic/" + Tool + "/1.a.DF_PA/"
if os.path.isdir(OUTDIR) == False:
	os.mkdir(OUTDIR)
	os.mkdir(OUTDIR + 'mx/')
OUTDIR="/data/project/MRS/4.Analysis_Mosaic/" + Tool + "/1.a.DF_PA/mx/"
l_TF = ["TP", "FP"]
out = open("summary.txt","a")
out.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" %('CASE','CONT',"cnt_common","cnt_uniq_CASE","cnt_uniq_CONT","cnt_CASE","cnt_CASE_FP"))
def make_analysis(case,cont):
        CASE = open(DIR + Tool.split('.')[1]+"." + Case + "_"+TF+".vcf","rb")
        CONT = open(DIR + Tool.split('.')[1] +"." + Control +"_"+TF+".vcf","rb")
        out1 = open(OUTDIR + Tool + "_summary_PAIR.txt","a")

        l_CASE = []
        l_CONT = []
        dic_CASE = {}
        dic_CONT = {}
        cnt_CASE_FP = 0
        cnt_CONT_FP = 0

        for line in CASE:
                s = line.split('\t')
                CHR = s[2]
                pos = s[3]
                region = s[2] + '"'+ s[3]
                l_CASE.append(region)
                dic_CASE[region] = line

        for line in CONT:
                s = line.split('\t')
                CHR = s[2]
                pos = s[3]
                region = s[2] + '"'+ s[3]
                l_CONT.append(region)
                dic_CONT[region] = line

        s_CASE = set(l_CASE)
        s_CONT = set(l_CONT)
        common = s_CASE & s_CONT
        uniq_CASE = s_CASE - s_CONT
        uniq_CONT = s_CONT - s_CASE
        cnt_common = len(list(common))
        cnt_uniq_CASE = len(list(uniq_CASE))
        cnt_uniq_CONT = len(list(uniq_CONT))
        cnt_CASE = len(list(uniq_CASE))+ len(list(common))
        out_com = open(OUTDIR+Tool+"_"+ Case + "_" + Control + "_"+TF+".common.vcf", 'wb')
        out_uni_CASE = open(OUTDIR+ Tool+"_" + Case + "_" + Control + "_"+TF+".uniq_" + Case + ".vcf", 'wb')
        out_uni_CONT = open(OUTDIR+Tool+"_" + Case + "_" + Control + "_"+TF+".uniq_" + Control + ".vcf", 'wb')

        for idx in list(common):
                out_com.write(dic_CASE[idx])
                out_com.write(dic_CONT[idx])
        for idx in list(uniq_CASE):
                out_uni_CASE.write(dic_CASE[idx])

        for idx in list(uniq_CONT):
                out_uni_CONT.write(dic_CONT[idx])

        out1.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" %(Case,Control,cnt_common,cnt_uniq_CASE,cnt_uniq_CONT,cnt_CASE,cnt_CASE_FP,cnt_CONT_FP))

for TF in l_TF:
	l_M1 = []
	l_M2 = []
	l_M3 = []
	for i in range(9):
	        name = "M1-" + str(i+1)
	        l_M1.append(name)
	for i in range(12):
	        name = "M2-" + str(i+1)
	        l_M2.append(name)
	for i in range(18):
	        name = "M3-" + str(i+1)
	        l_M3.append(name)
	
	for M3 in l_M3: #CASE
	        for M1 in l_M1: #CONTROL
	                Case = M3
	                Control = M1
	                print Case, Control
	                out  = open("summary.txt","a")
	                make_analysis(Case,Control)
	
	for M3 in l_M3: #CASE
	        for M2 in l_M2: #CONTROL
	                Case = M3
	                Control = M2
	                print Case, Control
	                out  = open("summary.txt","a")
	                make_analysis(Case,Control)
