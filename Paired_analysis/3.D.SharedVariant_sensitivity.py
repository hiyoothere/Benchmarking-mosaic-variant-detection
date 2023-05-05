#!/usr/bin/python
import sys
sys.path.append("../module/")
import Expect_VAF

l_set = []
for i in range(18):
	m3 = 'M3-' + str(i+1)
	for j in range(9):
		m1 = 'M1-' + str(j+1)
		l_set.append(m3 + '/' + m1)
	for j in range(12):
		m2 = 'M2-' + str(j+1)
		l_set.append(m3 + '/' + m2)
 
dic_V1 = {}
dic_V3 = {}
for each in l_set:
	set = each
	case = each.split('/')[0]
	cont = each.split('/')[1]
	if cont[:2] == 'M2':
		V3_case = Expect_VAF.VAF(case, 'V3', 'het')
	        V3_cont = Expect_VAF.VAF(cont, 'V3', 'het')
	        set_VAF3 = str(V3_case) + '/' +  str(V3_cont) # e.g., 4.0/4.0
	        if set_VAF3 not in dic_V3:
	                dic_V3[set_VAF3] = [set]
	        else:
        	        dic_V3[set_VAF3].append(set)
	V1_case = Expect_VAF.VAF(case, 'V1', 'het')
	V1_cont = Expect_VAF.VAF(cont, 'V1', 'het')
	set_VAF = str(V1_case) + '/' +  str(V1_cont) #4.0/4.0
	if set_VAF not in dic_V1:
		dic_V1[set_VAF] = [set]
	else:
		dic_V1[set_VAF].append(set)
print len(dic_V1)
#print dic
cnt = 0
for i in dic_V1:
	cnt += len(dic_V1[i])
print cnt


#2fold
dic_2fold_down = {}
dic_2fold_Nup = {}
dic_2fold_down['V1_het'] = []
dic_2fold_down['V1_hom'] = []
dic_2fold_Nup['V1_het'] = []
dic_2fold_Nup['V1_hom'] = []
dic_2fold_down['V3_het'] = []
dic_2fold_down['V3_hom'] = []
dic_2fold_Nup['V3_het'] = []
dic_2fold_Nup['V3_hom'] = []

for each in dic_V1:
	V1_case = float(each.split('/')[0])
	V1_cont = float(each.split('/')[1])
	samples = dic_V1[each]
	v1 = each+ '=' + str(samples)
	if V1_case> V1_cont:
		if V1_case/V1_cont < 2:
			dic_2fold_down['V1_het'].append(v1)
		else: 
			dic_2fold_Nup['V1_het'].append(v1)  
	else:	
		if V1_cont/V1_case < 2:
			dic_2fold_down['V1_het'].append(v1)
                else:                                
                        dic_2fold_Nup['V1_het'].append(v1)
	V1_case_hom = V1_case*2
	V1_cont_hom = V1_cont*2
	v1_hom = str(V1_case_hom) + '/' + str(V1_cont_hom) + '=' + str(samples)
	if V1_case_hom> V1_cont_hom:
                if V1_case_hom/V1_cont_hom < 2:
                        dic_2fold_down['V1_hom'].append(v1_hom)
                else:
                        dic_2fold_Nup['V1_hom'].append(v1_hom)
        else:
                if V1_cont_hom/V1_case_hom < 2:
                        dic_2fold_down['V1_hom'].append(v1_hom)
                else:
                        dic_2fold_Nup['V1_hom'].append(v1_hom)

for each in dic_V3:
        V3_case = float(each.split('/')[0])
        V3_cont = float(each.split('/')[1])
	samples = dic_V3[each]
        v3 = each+ '=' + str(samples)
        if V3_case> V3_cont:
                if V3_case/V3_cont < 2:
                        dic_2fold_down['V3_het'].append(v3)
                else:
                        dic_2fold_Nup['V3_het'].append(v3)
        else:
                if V1_cont/V1_case < 2:
                        dic_2fold_down['V3_het'].append(v3)
                else:
                        dic_2fold_Nup['V3_het'].append(v3)
        V3_case_hom = V3_case*2
        V3_cont_hom = V3_cont*2
        v3_hom = str(V3_case_hom) + '/' + str(V3_cont_hom) + '=' + str(samples)
        if V3_case_hom> V3_cont_hom:
                if V3_case_hom/V3_cont_hom < 2:
                        dic_2fold_down['V3_hom'].append(v3_hom)
                else:
                        dic_2fold_Nup['V3_hom'].append(v3_hom)
        else:
                if V3_cont_hom/V3_case_hom < 2:
                        dic_2fold_down['V3_hom'].append(v3_hom)
                else:
                        dic_2fold_Nup['V3_hom'].append(v3_hom)
dic_ans = {}

dic_ans['V1_het'] = Expect_VAF.Cnt('V1', 'het', 'hc', 'snv')
dic_ans['V1_hom'] = Expect_VAF.Cnt('V1', 'hom', 'hc', 'snv')
dic_ans['V3_het'] = Expect_VAF.Cnt('V3', 'het', 'hc', 'snv')
dic_ans['V3_hom'] = Expect_VAF.Cnt('V3', 'hom', 'hc', 'snv')


out = open("/data/project/MRS/5.Combined_Analysis/SharedVAF/2fold_sen.txt", 'a')
TP_dir = '/data/project/MRS/4.Analysis_Mosaic/'+ sys.argv[1] +'/1.a.DF_PA/tp/'
TOTAL_ANS = 0
TOTAL_TP = 0
for v in dic_2fold_down: # For balanced VAF shared variants
	for vaftype in dic_2fold_down[v]:
		#print vaftype
		vaf = vaftype.split('=')[0]
		cnt_tp_in_vaf = 0
		samples = vaftype.split('=')[1]	
		l_sample = samples.split("'")
		for i in l_sample:
			if 'M' not in i:
				l_sample.remove(i)
#		print l_sample
		for each in l_sample:
			case = each.split('/')[0]
			cont = each.split('/')[1]
			f = open(TP_dir + sys.argv[1]+ '_' + case + '_' + cont + '_TP.common.vcf', 'r') # parsed form of shared variant file
			for line in f:
				if line.split('\t')[5][3:9] == v: #V1-het
					cnt_tp_in_vaf += 0.5
					TOTAL_TP += 0.5
		ans_vaf_all =  dic_ans[v] * len(l_sample)
		TOTAL_ANS += ans_vaf_all 
		sen = float(cnt_tp_in_vaf)/ans_vaf_all
		out.write("%s\t%s\t%s\t%f\t%f\t%f\n" %( sys.argv[1], '2fdown', vaf, ans_vaf_all, cnt_tp_in_vaf, sen ))
out.write("%s\t%s\t%s\t%f\t%f\t%f\n" %( sys.argv[1], '2fdown_total', '', TOTAL_ANS , TOTAL_TP, float(TOTAL_TP)/TOTAL_ANS))

TOTAL_ANS = 0
TOTAL_TP = 0
for v in dic_2fold_Nup: # For unbalanced VAF shared variants
        for vaftype in dic_2fold_Nup[v]:
                #print vaftype
                vaf = vaftype.split('=')[0]
                cnt_tp_in_vaf = 0
                samples = vaftype.split('=')[1]
                l_sample = samples.split("'")
                for i in l_sample:
                        if 'M' not in i:
                                l_sample.remove(i)
#               print l_sample
                for each in l_sample:
                        case = each.split('/')[0]
                        cont = each.split('/')[1]
                        f = open(TP_dir + sys.argv[1] + '_'+case + '_' + cont + '_TP.common.vcf', 'r')
                        for line in f:
                                if line.split('\t')[5][3:9] == v: #V1-het
                                        cnt_tp_in_vaf += 0.5
					TOTAL_TP += 0.5
                ans_vaf_all =  dic_ans[v] * len(l_sample)
                sen = float(cnt_tp_in_vaf)/ans_vaf_all
		TOTAL_ANS += ans_vaf_all
                out.write("%s\t%s\t%s\t%f\t%f\t%f\n" %( sys.argv[1], '2fup', vaf, ans_vaf_all, cnt_tp_in_vaf, sen))
out.write("%s\t%s\t%s\t%f\t%f\t%f\n" %( sys.argv[1], '2fup_total', '', TOTAL_ANS , TOTAL_TP, float(TOTAL_TP)/TOTAL_ANS))




