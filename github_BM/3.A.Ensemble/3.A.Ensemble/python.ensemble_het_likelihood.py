import sys
import os

###########################################################
######### STEP1. extract conc position features ###########
###########################################################

# for HC200 call MF raw , het likelihood
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
            sample_name_pre = o.rstrip().split('.')[1]
            sample_name = sample_name_pre.rstrip().split('_')[0]
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
            sample_name_pre = w.rstrip().split('.')[1]
            sample_name = sample_name_pre.rstrip().split('_')[0]
            key = sample_name+'_'+lis_FP[2]+'_'+lis_FP[3]
            _dic[key]='FP'
        f_FP.close()

    ################################# RAW ##################################
    path_dir = '/data/project/MRS/4.Analysis_Mosaic/3.MF/0.DF/'+typ
    file_list = os.listdir(path_dir)
    MF_list=[]
    for i in file_list:
        if not 'ind.' in i:
            MF_list.append(i)

    MF_TP_count = 0
    MF_FP_count = 0
    fo_MF=open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MF_'+typ+'_comparison.txt','w')
    MF_header=open('/data/project/MRS/Resource/header.MF.txt','r')
    line_MF_header = MF_header.readlines()
    ls_MF_header = line_MF_header[0].rstrip()
    fo_MF.writelines('Sample'+'\t'+'TP_FP'+'\t'+ls_MF_header+'\n')   # first line
    fo_MF_percent=open('/data/project/MRS/5.Combined_Analysis/combination/output/call_HC200_raw_MF_'+typ+'_comparison_percent.txt','w')
    for sample in MF_list:
        f_MF=open(path_dir+'/'+sample+'/'+sample+'.features','r')
        line_MF=f_MF.readlines()
        for line in range(1,len(line_MF)): ########
            ls_MF=line_MF[line].rstrip()
            lis_MF=ls_MF.split('\t')
            id_MF = lis_MF[0].rstrip().split('~')
            chr_MF = id_MF[1]
            pos_MF = id_MF[2]
            key = sample+'_'+chr_MF+'_'+pos_MF
            if key in _dic:
                fo_MF.writelines(key+'\t'+_dic[key]+'\t'+ls_MF+'\n')
                if _dic[key] == 'TP':
                    MF_TP_count += 1
                else:
                    MF_FP_count += 1

    fo_MF.close()

    if total_TP == 0 :
        divide_TP = 0
    else:
        divide_TP = MF_TP_count / total_TP
    if total_FP == 0 :
        divide_FP = 0
    else:
        divide_FP = MF_FP_count / total_FP

    fo_MF_percent.writelines('TP'+'\t'+'bf :'+'\t'+str(total_TP)+'\t'+'af :'
                             +'\t'+str(MF_TP_count)+'\t'+str(divide_TP)+'\n'+
                            'FP'+'\t'+'bf :'+'\t'+str(total_FP)+'\t'+'af :'
                             +'\t'+str(MF_FP_count)+'\t'+str(divide_FP))

    fo_MF_percent.close()
    MF_header.close()

###########################################################
######### STEP2. filter ensemble features #################
###########################################################

_type = ['mx','tp']
_dir = '/data/project/MRS/5.Combined_Analysis/combination/output'
for typ in _type:
    TP_passed = 0
    TP_filtered = 0
    TP_error = 0
    
    FP_passed = 0
    FP_filtered = 0
    FP_error = 0
    
    fo_data = open(_dir+'/result/het_likelihood_'+typ+'.txt','w')
    f_data = open(_dir+'/'+'call_HC200_raw_MF_'+typ+'_comparison.txt','r')

    line_data = f_data.readlines()
    for m in range(1,len(line_data)):
        ls_data = line_data[m]
        lis_data = ls_data.rstrip().split('\t')
        if lis_data[1] == 'TP':
            if lis_data[28] != '':
                if float(lis_data[28]) > 0.25 : # filtered
                    TP_filtered += 1
                else:
                    TP_passed += 1
            else:
                TP_error += 1
                
        elif lis_data[1] == 'FP':
            if lis_data[28] != '':
                if float(lis_data[28]) > 0.25 : # filtered
                    FP_filtered += 1
                else:
                    FP_passed += 1
            else:
                FP_error += 1

    fo_data.writelines('TP_passed'+'\t'+str(TP_passed)+'\n')
    fo_data.writelines('TP_filtered'+'\t'+str(TP_filtered)+'\n')
    fo_data.writelines('TP_error'+'\t'+str(TP_error)+'\n')
    fo_data.writelines('FP_passed'+'\t'+str(FP_passed)+'\n')
    fo_data.writelines('FP_filtered'+'\t'+str(FP_filtered)+'\n')
    fo_data.writelines('FP_error'+'\t'+str(FP_error))
    
    f_data.close()
    fo_data.close()
