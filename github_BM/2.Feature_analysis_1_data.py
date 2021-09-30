#!/bin/bash

import sys
import os

#_type = ['mx','tp']
_type = ['tp']
for typ in _type:
    _dir = '/data/project/MRS/4.Analysis_Mosaic/4.MT/1.DF_A/' + typ
    _list = os.listdir(_dir)
    _TP = []
    _FP = []
    for _emt in _list:
        if 'TP.vcf' in _emt:
            _TP.append(_emt)
        elif 'FP.vcf' in _emt:
            _FP.append(_emt)
            
    ##########################
    fo_MT = open('/data/project/MRS/5.Combined_Analysis/feature_analysis/MT_'+typ+'TPFP_feature.txt','w')
    fo_MT.writelines("ID"+'\t'+"TP_FP"+'\t'+"GERMQ"+'\t'+"MMQ_ref"+'\t'+"MMQ_alt"+'\t'+"MBQ_ref"+'\t'+
                     "MBQ_alt"+'\t'+"MFRL_ref"+'\t'+"MFRL_alt"+'\t'+"ECNT"+'\t'+"POPAF"+'\t'+"TLOD"+'\t'+
                     "AF"+'\t'+"MPOS"+'\n')
    
    for vcf in _TP:
        f_TP = open(_dir + '/' + vcf, 'r')
        line_TP = f_TP.readlines()
        for line in range(0,len(line_TP)):
            ls_TP = line_TP[line]
            ls_TP = ls_TP.rstrip().split('\t')
            ID = ls_TP[1] + '_' + ls_TP[2] + '_' + ls_TP[3]
            AF = ls_TP[4]
            INFO = ls_TP[15].rstrip().split(';')
            ####################################
            GERMQ = INFO[4].split('=')[1]
            MMQ_ref = INFO[7].split('=')[1].split(',')[0]
            MMQ_alt = INFO[7].split('=')[1].split(',')[1]
            MBQ_ref = INFO[5].split('=')[1].split(',')[0]
            MBQ_alt = INFO[5].split('=')[1].split(',')[1]
            MFRL_ref = INFO[6].split('=')[1].split(',')[0]
            MFRL_alt = INFO[6].split('=')[1].split(',')[1]
            ECNT = INFO[3].split('=')[1]
            POPAF = INFO[9].split('=')[1]
            TLOD = INFO[10].split('=')[1]
            MPOS = INFO[8].split('=')[1]
            
            fo_MT.writelines(ID+'\t'+"TP"+'\t'+GERMQ+'\t'+MMQ_ref+'\t'+MMQ_alt+'\t'+MBQ_ref+'\t'+
                     MBQ_alt+'\t'+MFRL_ref+'\t'+MFRL_alt+'\t'+ECNT+'\t'+POPAF+'\t'+TLOD+'\t'+
                     AF+'\t'+MPOS+'\n')
        f_TP.close()

    for vcf in _FP:
        f_FP = open(_dir + '/' + vcf, 'r')
        line_FP = f_FP.readlines()
        for line in range(0,len(line_FP)):
            ls_FP = line_FP[line]
            ls_FP = ls_FP.rstrip().split('\t')
            ID = ls_FP[1] + '_' + ls_FP[2] + '_' + ls_FP[3]
            AF = ls_FP[4]
            INFO = ls_FP[15].rstrip().split(';')
            ####################################
            GERMQ = INFO[4].split('=')[1]
            MMQ_ref = INFO[7].split('=')[1].split(',')[0]
            MMQ_alt = INFO[7].split('=')[1].split(',')[1]
            MBQ_ref = INFO[5].split('=')[1].split(',')[0]
            MBQ_alt = INFO[5].split('=')[1].split(',')[1]
            MFRL_ref = INFO[6].split('=')[1].split(',')[0]
            MFRL_alt = INFO[6].split('=')[1].split(',')[1]
            ECNT = INFO[3].split('=')[1]
            POPAF = INFO[9].split('=')[1]
            TLOD = INFO[10].split('=')[1]
            MPOS = INFO[8].split('=')[1]
            
            fo_MT.writelines(ID+'\t'+"FP"+'\t'+GERMQ+'\t'+MMQ_ref+'\t'+MMQ_alt+'\t'+MBQ_ref+'\t'+
                     MBQ_alt+'\t'+MFRL_ref+'\t'+MFRL_alt+'\t'+ECNT+'\t'+POPAF+'\t'+TLOD+'\t'+
                     AF+'\t'+MPOS+'\n')
        f_FP.close()
    fo_MT.close()
