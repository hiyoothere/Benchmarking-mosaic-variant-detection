#!/home/hiyoothere/miniconda3/bin/python

import pandas as pd

Exp = pd.read_csv("Expected_VAF.txt",sep='\t')
df_Exp = pd.DataFrame(Exp)

def VAF(sample,v, type): #Sample, Variant type (e.g., V1), type (het or hom)
	sample = sample.split('.')[0]
	IDX = v.upper() + '-' + type.upper()
#	print IDX
	tmp = df_Exp.loc[df_Exp['#MUT'] == sample] 
	vaf =  tmp[IDX]
#	print (vaf)
	VAF =  float(vaf.tolist()[0]) * 100
	return round(VAF,1)

hc = pd.read_csv("Cnt_PC.hc.txt",sep='\t')
def Cnt( v, type , region, var): #v = Variant type, type = het or hom, region = hc (high-confidence), var = snv or indel
	if region == 'hc':
		df_Ans = pd.DataFrame(hc)
		if var == 'snv':
			IDX= 'SNV_' + type 
		else:
			IDX= 'IND_' + type
		tmp = df_Ans.loc[df_Ans['#TYPE'] == IDX]
		return tmp[v.upper()].tolist()[0]
	elif region == 'rp':
		df_Ans = pd.DataFrame(rp)
		if var == 'snv':
			IDX= 'SNV_' + type
		else:
			IDX= 'IND_' + type
		tmp = df_Ans.loc[df_Ans['#TYPE'] == IDX]
		return tmp[v.upper()].tolist()[0]
#print Cnt('v1', 'het', 'hc')
		
