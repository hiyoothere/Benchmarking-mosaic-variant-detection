import sys
import os

###########################################################
######### STEP1. extract conc position features ###########
###########################################################

# for HC200 call MT raw , MFRL alt
# Call set

_type = ['mx','tp']
for typ in _type:
    _dir = '/data/project/MRS/4.Analysis_Mosaic/12.HC200/1.DF_A/'+typ
    _list = os.listdir(_dir)
    _TP=[]
    _FP=[]
    for i in _list:
        if 'TP.vcf' in i:
            _TP.append(i)
        elif 'FP.vcf' in i:
            _FP.append(i)

    _dic={}
    total_TP = 0
    total_FP = 0
    for o in _TP:
        f_TP=open(_dir+'/'+o,'r')
        line_TP=f_TP.readlines()
        for m in range(0,len(line_TP)):
            total_TP +=1
            ls_TP=line_TP[m]
            lis_TP=ls_TP.rstrip().split('\t')
            sample_pre = o.rstrip().split('.')
            sample_name = sample_pre[1].split('_')[0]
            key = sample_name+'_'+lis_TP[2]+'_'+lis_TP[3]
            _dic[key]='TP'
        f_TP.close()

    for w in _FP:
        f_FP=open(_dir+'/'+w,'r')
        line_FP=f_FP.readlines()
        for n in range(0,len(line_FP)):
            total_FP +=1
            ls_FP=line_FP[n]
            lis_FP=ls_FP.rstrip().split('\t')
            sample_pre = w.rstrip().split('.')
            sample_name = sample_pre[1].split('_')[0]
            key = sample_name+'_'+lis_FP[2]+'_'+lis_FP[3]
            _dic[key]='FP'
        f_FP.close()

    ################################# RAW ##################################

    Mutect_dir = '/data/project/MRS/4.Analysis_Mosaic/4.MT/0.DF/'+typ
    Mutect_list = os.listdir(Mutect_dir)
    Mutect_TPFP = []
    for i in Mutect_list:
        if '.vcf' in i and 'vcf.' not in i and 'fil' not in i:
            Mutect_TPFP.append(i)


    Mutect_TP_count = 0
    Mutect_FP_count = 0        
    fo_analysis = open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison.txt','w')
    fo_percent=open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison_percent.txt','w')
    for o in Mutect_TPFP:
        f_HC=open(Mutect_dir+'/'+o,'r')
        line_HC=f_HC.readlines()
        for m in range(0,len(line_HC)):
            ls_HC=line_HC[m].rstrip()
            if ls_HC[0] == '#':
                continue
            lis_HC=ls_HC.rstrip().split('\t')
            sample_pre = o.rstrip().split('.')
            sample_name = sample_pre[0]
            key = sample_name+'_'+lis_HC[0]+'_'+lis_HC[1]
            if key in _dic:
                fo_analysis.write(key+'\t'+_dic[key]+'\t'+ls_HC+'\n')
                if _dic[key] == 'TP':
                    Mutect_TP_count += 1
                else:
                    Mutect_FP_count += 1
        f_HC.close()

    fo_analysis.close()
    if total_TP == 0 :
        divide_TP = 0
    else:
        divide_TP = Mutect_TP_count / total_TP
    if total_FP == 0 :
        divide_FP = 0
    else:
        divide_FP = Mutect_FP_count / total_FP
    fo_percent.writelines('TP'+'\t'+'bf :'+'\t'+str(total_TP)+'\t'+'af :'
                             +'\t'+str(Mutect_TP_count)+'\t'+str(divide_TP)+'\n'+
                            'FP'+'\t'+'bf :'+'\t'+str(total_FP)+'\t'+'af :'
                             +'\t'+str(Mutect_FP_count)+'\t'+str(divide_FP))
    fo_percent.close()


    f_analysis = open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison.txt','r')


    line_analysis = f_analysis.readlines()
    final = []
    for line in range(0,len(line_analysis)):
        ls_analysis = line_analysis[line]
        lis_analysis = ls_analysis.rstrip().split('\t')
        INFO = []
        INFO.append(lis_analysis[0])
        INFO.append(lis_analysis[1])
        INFO8_p = lis_analysis[9].rstrip().split(';')
        for r in INFO8_p:
            if r == 'PON':
                continue
            INFO8_both = r.rstrip().split('=')
            INFO8_value = INFO8_both[1]
            INFO.append(INFO8_value)
        if not 'PGT:PID' in lis_analysis[10]:
            INFO9_p=lis_analysis[11].rstrip().split(':')
            for y in INFO9_p:
                INFO.append(y)
        else:
            INFO9_p=lis_analysis[11].rstrip().split(':')
            for h in [0,1,2,3,4,5,9]:
                INFO.append(INFO9_p[h])    
        final.append(INFO)

    f_analysis.close()

    fo_final = open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison_final.txt','w')

    fo_final.writelines('Sample'+'\t'+'TP_FP'+'\t'+'AS_SB_TABLE'+'\t'+'DP'+'\t'+
                        'ECNT'+'\t'+'MBQ'+'\t'+'MFRL'+'\t'+'MMQ'+'\t'+'MPOS'+'\t'+'POPAF'+'\t'+
                        'TLOD'+'\t'+'GT'+'\t'+'AD'+'\t'+'AF'+'\t'+ 'DP'+'\t'+'F1R2'+'\t'+'F2R1'+'\t'+'SB'+'\n')
    for w in final:

        for l in range(0,len(w)):
            if not l == (len(w)-1):
                fo_final.write(w[l]+'\t')
            else:
                fo_final.write(w[l]+'\n')
    fo_final.close()
    os.remove('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison.txt')

    f_final = open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison_final.txt','r')
    fo_seperate = open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison.txt','w')

    line_f=f_final.readlines()
    fo_seperate.writelines('Sample'+'\t'+'TP_FP'+'\t'+
                        'AS_SB_TABLE_ref_forward_readcount'+'\t'+'AS_SB_TABLE_ref_reverse_readcount'+'\t'+
                        'AS_SB_TABLE_alt_forward_readcount'+'\t'+'AS_SB_TABLE_alt_reverse_readcount'+'\t'+
                        'DP'+'\t'+'ECNT'+'\t'+
                        'MBQ_ref'+'\t'+'MBQ_alt'+'\t'+'MFRL_ref'+'\t'+'MFRL_alt'+'\t'+
                        'MMQ_ref'+'\t'+'MMQ_alt'+'\t'+
                        'MPOS'+'\t'+'POPAF'+'\t'+'TLOD'+'\t'+
                        'GT_ref'+'\t'+'GT_alt'+'\t'+'AD_ref'+'\t'+'AD_alt'+'\t'+
                        'AF'+'\t'+ 'DP_2'+'\t'+'F1R2_1'+'\t'+'F1R2_2'+'\t'+'F2R1_1'+'\t'+'F2R1_2'+'\t'+
                        'SB_1'+'\t'+'SB_2'+'\t'+'SB_3'+'\t'+'SB_4'+'\n')
    for t in range(1,len(line_f)):
            ls_f=line_f[t]
            lis_f=ls_f.rstrip().split('\t')
            AS_SB=lis_f[2].rstrip().split('|')
            AS_SB_ref=AS_SB[0].rstrip().split(',') # 0,1
            AS_SB_alt=AS_SB[1].rstrip().split(',')
            MBQ=lis_f[5].rstrip().split(',')
            MFRL=lis_f[6].rstrip().split(',')
            MMQ=lis_f[7].rstrip().split(',')
            if '/' in lis_f[11]:
                GT=lis_f[11].rstrip().split('/')
            elif '|' in lis_f[11]:
                GT=lis_f[11].rstrip().split('|')
            AD=lis_f[12].rstrip().split(',')
            F1R2=lis_f[15].rstrip().split(',')
            F2R1=lis_f[16].rstrip().split(',')
            SB=lis_f[17].rstrip().split(',') #0123

            fo_seperate.writelines(lis_f[0]+'\t'+lis_f[1]+'\t'+
                               AS_SB_ref[0]+'\t'+AS_SB_ref[1]+'\t'+AS_SB_alt[0]+'\t'+AS_SB_alt[1]+'\t'+
                               lis_f[3]+'\t'+lis_f[4]+'\t'+
                               MBQ[0]+'\t'+MBQ[1]+'\t'+MFRL[0]+'\t'+MFRL[1]+'\t'+MMQ[0]+'\t'+MMQ[1]+'\t'+
                               lis_f[8]+'\t'+lis_f[9]+'\t'+lis_f[10]+'\t'+
                               GT[0]+'\t'+GT[1]+'\t'+AD[0]+'\t'+AD[1]+'\t'+
                               lis_f[13]+'\t'+lis_f[14]+'\t'+
                               F1R2[0]+'\t'+F1R2[1]+'\t'+F2R1[0]+'\t'+F2R1[1]+'\t'+
                               SB[0]+'\t'+SB[1]+'\t'+SB[2]+'\t'+SB[3]+'\n')
    f_final.close()
    fo_seperate.close()
    os.remove('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MT_'+typ+'_comparison_final.txt')

###########################################################
######### STEP2. filter ensemble features #################
###########################################################

_type = ['mx','tp']
_dir = '/data/project/MRS/5.Combined_Analysis/combination/output'
for typ in _type:
    TP_passed = 0
    TP_filtered = 0

    FP_passed = 0
    FP_filtered = 0

    fo_data = open(_dir+'/result/MFRL_alt_'+typ+'.txt','w')
    f_data = open(_dir+'/'+'call_HC200_raw_MT_'+typ+'_comparison.txt','r')

    line_data = f_data.readlines()
    for m in range(1,len(line_data)):
        ls_data = line_data[m]
        lis_data = ls_data.rstrip().split('\t')
        if lis_data[1] == 'TP':
            if float(lis_data[11]) < 150 : # filtered
                TP_filtered += 1
            else:
                TP_passed += 1
        elif lis_data[1] == 'FP':
            if float(lis_data[11]) < 150: # filtered
                FP_filtered += 1
            else:
                FP_passed += 1

    fo_data.writelines('TP_passed'+'\t'+str(TP_passed)+'\n')
    fo_data.writelines('TP_filtered'+'\t'+str(TP_filtered)+'\n')
    fo_data.writelines('FP_passed'+'\t'+str(FP_passed)+'\n')
    fo_data.writelines('FP_filtered'+'\t'+str(FP_filtered))
    
    f_data.close()
    fo_data.close()

