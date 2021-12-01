#!/usr/bin/python
import glob
import sys
sys.path.append("/home/hiyoothere/modules/")
import get_VAF
import get_id
import os

type=sys.argv[1]
dic_outname = { "4.MT":"*PASS.snps.vcf" }
turn=[ 'mx', 'tp']
for each_turn in turn:
	filelist = glob.glob("/data/project/MRS/4.Analysis_Mosaic/"+type+ "/0.DF/" + each_turn + '/' + dic_outname[type])
	print filelist
	DataPath="/data/project/MRS/4.Analysis_Mosaic/" + type + "/0.DF/"+ each_turn+ '/'
	if os.path.isdir("/data/project/MRS/4.Analysis_Mosaic/" + type + "/1.DF_A/") == False:
		os.mkdir("/data/project/MRS/4.Analysis_Mosaic/" + type + "/1.DF_A/")
	outpath="/data/project/MRS/4.Analysis_Mosaic/" + type + "/1.DF_A/" + each_turn + '/'
	if os.path.isdir(outpath) == True:
		pass
	else:
		os.mkdir("/data/project/MRS/4.Analysis_Mosaic/" + type + "/1.DF_A/")
		os.mkdir(outpath)
	AnswerPath="/data/project/MRS/0.Genotype/ctrl/pc/3.hc/"
	
	for file in filelist:
		print file
	        samp = str(file).split('/')[-1]
	        samp = samp.split('.')[0] #+'_'+  samp.split('_')[1]
		print samp
	        mosaic_type = samp[:2]
		print mosaic_type
		pc = open(AnswerPath+ mosaic_type+'.pc.snv.vcf','r')
	        out_TP = open(outpath+type.split('.')[1]+'.' +samp+"_TP.vcf","wb")
		out_FP = open(outpath+type.split('.')[1]+'.'+samp+"_FP.vcf","wb")
		out_FN = open(outpath+type.split('.')[1]+'.'+samp+"_FN.vcf","wb")
		l_total = []
		l_call = []
		l_call_pos = []
		dic_totalinfo = {}
		dic_callinfo =  {}
		dic_pc = {}
		dic_pc_type= {}
		cnt_call = 0
		cnt_TP = 0
		for line in pc:
			if line[0] != '#':
				s = line.split('\t')
		                idx = get_id.gatk(line)
		                dic_pc[idx] = '.'
				dic_pc_type[idx] = s[2]
				l_total.append(idx)
				dic_totalinfo[idx] = line
		f = open(file,'r')	
		for line in f:
			if line[0] != '#':
				s = line.split('\t')
				cnt_call += 1
				idx = get_id.gatk(line)
				l_call.append(idx)
				l_call_pos.append(line.split('\t')[0] + ':' + line.split('\t')[1])
				AF = get_VAF.mutect(line)
				if idx in dic_pc:
		                        out_TP.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" %(type, samp,s[0], s[1], str(AF), 'TP'+":"+dic_pc_type[idx],'1',samp,line))			
					cnt_TP +=1
					l_total.remove(idx)
				else:
					dic_callinfo[idx] = line
		##2.FN
		cnt_FN = 0
		for i in l_total:
			out_FN.write(dic_totalinfo[i])
			cnt_FN += 1

		l_nc = []
                dic_nc_ann = {}
		if each_turn == 'tp':
			nc = open("/data/project/MRS/0.Genotype/ctrl/nc/4.hc_rp/hc/germline.nc.snv.vcf" , 'r')
			for line in nc:
	                        if line[0] != '#':
        	                        s = line.split("\t")
                	                idx = get_id.gatk(line)
                        	        l_nc.append(idx)
                                	dic_nc_ann[idx] = s[2].rstrip('\n')
			s_call = set(l_call)
			s_nc = set(l_nc)
			FP = s_nc & s_call
			l_FP = list(FP)
                        l_FP.sort()
                        print l_FP
                        out_summary.write("%s\t%s\t%s\t%s\t%s\n" %(samp,cnt_call, cnt_TP, str(len(FP)), cnt_FN))
		else:
			nc = open("/data/project/MRS/0.Genotype/ctrl/nc/4.hc_rp/hc/refhom.nc.vcf" , 'r')
			for line in nc:
	                        if line[0] != '#':
        	                        s = line.split("\t")
                        	        CHR = s[0]
                                	pos = s[1]
	                                l_nc.append(CHR+':'+pos)
        	                        dic_nc_ann[CHR+':'+pos] = s[2].rstrip('\n')
			s_call = set(l_call_pos)
                        s_nc = set(l_nc)
                        FP = s_nc & s_call
			l_FP = list(FP)
			l_FP.sort()
			print l_FP
			out_summary.write("%s\t%s\t%s\t%s\t%s\n" %(samp,cnt_call, cnt_TP, str(len(FP)), cnt_FN))
		out_TP.close()
		out_FN.close()
	        for each in l_FP:
			if each_turn == 'mx':
				for call in dic_callinfo:
					if call.split(':')[0]+':'+call.split(':')[1] == each:
						line = dic_callinfo[call]
						AF = get_VAF.mutect(line)
						out_FP.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" %(type, samp,call.split(':')[0], call.split(':')[1]  , str(AF), 'FP:refhom','0',samp,line)) 
			else:
			#each = pos or pos+refalt
			
				line = dic_callinfo[each]
				AF = get_VAF.mutect(line)
				idx = get_id.gatk(line)
#			print AF
				out_FP.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" %(type, samp, idx.split(':')[0], idx.split(':')[1], str(AF), 'FP:'+dic_nc_ann[idx],'0',samp,line))
		out_FP.close()		
