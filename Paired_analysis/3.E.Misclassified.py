#!/user/bin/python

import sys
import glob
sys.path.append("../module/")
import Expect_VAF
import __Dic_VAF_ANS

tool_list = ['1.MH'] #Method to analyze
for tool in tool_list:
    cnt_pair = 0
    tool_ans = 0
    tool_shared = 0
    tool_miscla = 0
    dic_vaf_ans = {}
    dic_vaf_call = {}
    out = open('Misclassification.txt','a') # output
    print (tool)
    filelist = glob.glob("/data/project/MRS/4.Analysis_Mosaic/" + tool + "/1.a.DF_PA/SetB/*M*TP.common.vcf") # parsed form of shared true positives
    print (filelist)
        #3.MF_M3-9_M2-8_TP.common.vcf
    for file in filelist:
            cnt_pair +=1
            l_vars = []
            combi = str(file).split('_')
            print (combi)
            case = combi[-3]
            cont = combi[-2]
            f_case_uniq = str(file).split('.common')[0] + '.uniq_' + case + '.vcf'
            f_cont_uniq = str(file).split('.common')[0] + '.uniq_' +  cont + '.vcf'
            #3.MF_M3-9_M2-8_TP.uniq_M2-8.vcf
            if case[1] == '3' and cont[1] == '1':
                l_vars.extend(['V1:het', 'V1:hom'])
            elif case[1] == '3' and cont[1] == '2':
                l_vars.extend(['V1:het', 'V1:hom', 'V3:het', 'V3:hom'])
            pair_cnt_ans = 0
            pair_cnt_call_shared = 0
            pair_cnt_call_uniq = 0 #misclassified 
            for i in l_vars:
                v = i.split(':')[0]
                type = i.split(':')[1]
                Cnt_Ans = Expect_VAF.Cnt(v,type, 'hc', 'snv')
                #VAF =  Expect_VAF.VAF(sample,v,type)
                pair_cnt_ans += Cnt_Ans
            f= open(file, 'r')
            for line in f:
                #TP:V3_het_snv
                info = line.split('\t')[5]
                var = info.split(':')[1][:-4]
                pair_cnt_call_shared += 0.5 #line 2 for one var
            f_case = open(f_case_uniq, 'r')
            f_cont = open(f_cont_uniq, 'r')
            for line in f_case:
                info = line.split('\t')[5]
                var = info.split(':')[1][:-4]
                feature_var =var.split('_')
                var_type = ':'.join(feature_var)
                if var_type in l_vars:
                    pair_cnt_call_uniq +=1
            for line in f_cont:
                info = line.split('\t')[5]
                var = info.split(':')[1][:-4]
                feature_var =var.split('_')
                var_type = ':'.join(feature_var)
                if var_type in l_vars:
                    pair_cnt_call_uniq +=1
            print (tool, case, cont, pair_cnt_ans, pair_cnt_call_shared,  pair_cnt_call_shared/pair_cnt_ans, pair_cnt_call_uniq, pair_cnt_call_uniq/float(pair_cnt_ans))
            tool_ans = tool_ans +  pair_cnt_ans
            tool_shared += pair_cnt_call_shared
            tool_miscla += pair_cnt_call_uniq 
    out.write(tool+ '\t' + str(tool_ans) + '\t' + str(tool_shared) + '\t' + str(round(tool_shared/tool_ans*100,2)) + '\t' + str(tool_miscla) + '\t' + str(round(float(tool_miscla)/tool_ans*100,2))+'\t' + str(cnt_pair) +'\n')
