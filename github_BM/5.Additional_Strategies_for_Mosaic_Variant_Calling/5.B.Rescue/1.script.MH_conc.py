import glob
import sys

def con_pos(con_MH):
	con_dict = {}		
	f = open(con_MH, 'r')
	for line in f:
		if 'id' in line:
                        #s = line.split()
                        #idx = s.index('AF')
                        #print idx
			pass
                else:
                        s = line.split()
                        if '14.DM' in con_MH:
				alt = s[13]
                                #chr = 'chr'+s[2]
                                #pos = s[3]
                                #vaf = float(s[7])
                        elif '1.MH' in con_MH:
				alt=s[16]
                                #chr = s[0]
                                #pos = s[1]
                                #ref = int(s[7])
                                #alt = int(s[9])
                                #vaf = float(alt)/(ref+alt)
                        elif '3.MF' in con_MH:
                        	temp=s[8].split('~')
				alt = temp[-1]
				if "/7.IND_A/" in con_MH:
					if len(temp[-1]) > len(temp[-2]): #INSERTION
						alt = temp[-1].replace(temp[-2], "+", 1)
					else:
						alt = temp[-2].replace(temp[-1], '-', 1)
						
				# chr = s[0].split('~')[1]
                               # pos = s[0].split('~')[2]
                               # vaf = float(s[idx])
			chr = s[2]
			pos = s[3]
			vaf = float(s[4])
			if chr in con_dict:
				if pos in con_dict[chr]:
					print "ERROR: %s : %s"%(chr, pos)
				else:
					con_dict[chr][pos] = [[vaf, "NA"], alt] ## VAF of con first in list of vaf in position
			else:
				con_dict[chr] = {pos : [[vaf, "NA"],alt]}
	f.close()
	return con_dict

def combine(con_dict, cas_MH):
	cas = open(cas_MH, 'r')
	for line in cas:
		if 'id' in line:
			#s = line.split()
			#idx = s.index('AF')
			#print idx
			pass
		else:
			s = line.split()
			if '14.DM' in cas_MH:
				alt = s[13]
			#	chr = 'chr'+s[2]
			#	pos = s[3]
			#	vaf = float(s[7])
			elif '1.MH' in cas_MH:
				alt=s[16]
			#	chr = s[0]
			#	pos = s[1]
			#	ref = int(s[7])
			#	alt = int(s[9])
			#	vaf = float(alt)/(ref+alt)
			elif '3.MF' in cas_MH:
				temp=s[8].split('~')
                                alt = temp[-1]
                                if "/7.IND_A/" in cas_MH:
                                        if len(temp[-1]) > len(temp[-2]): #INSERTION
                                                alt = temp[-1].replace(temp[-2], "+", 1)
                                        else:
                                                alt = temp[-2].replace(temp[-1], '-', 1)
			#	chr = s[0].split('~')[1]
			#	pos = s[0].split('~')[2]
			#	vaf = float(s[idx])
			chr = s[2]
                        pos = s[3]
                        vaf = float(s[4])
	
			if chr in con_dict:
				if pos in con_dict[chr]:
					con_dict[chr][pos][0][1] = vaf
				else:	
					con_dict[chr][pos] = [["NA", vaf],alt]
			else:
				con_dict[chr] = {pos : [["NA", vaf], alt] } 

	cas.close()	
	return con_dict	

def rem_het(total_dict):
	filtered_ct=0
	for chr in total_dict:
		for pos in total_dict[chr]:
			ls = total_dict[chr][pos][0]
			if 'NA' in ls:
				continue
			else:
				if (ls[0] >= 0.30) & (ls[1] >= 0.30): ### remove positions with af 30+ in both tissues
					total_dict[chr][pos][0] = ["NA"]
					filtered_ct+=1
	#print total_dict
	return total_dict

def write_final(passed_dict, con_out, cas_out, sha_out):
	
	#### DISORDERED
	for chr in passed_dict:
                for pos in passed_dict[chr]:
                        line_ls = [chr, pos, passed_dict[chr][pos][1]]
                        ls = passed_dict[chr][pos][0]
			#print ls
                        if "NA" in ls:
				if len(ls) == 1:
					continue
                                elif ls[0] == "NA":
					line_ls.append(str(ls[1]))
                                        cas_out.write('\t'.join(line_ls) + '\n')
                                else:
					line_ls.append(str(ls[0]))
                                        con_out.write('\t'.join(line_ls) + '\n')
                        else: #shared
				con_vaf = passed_dict[chr][pos][0][0] ### add con VAF for future analysis
				line = '\t'.join([chr, pos, passed_dict[chr][pos][1], str(con_vaf)]) + '\n' 
                                sha_out.write(line)	

		
def main(ID_con, ID_cas, con_MH, cas_MH, OutPath, TAG):	
	
	con_dict = con_pos(con_MH)
	
	total_dict = combine(con_dict, cas_MH) 

	passed_dict = rem_het(total_dict)
	
	### writing files
	###### cone specific
	###### ctrl specific
	###### shared (with 30% af filter
	con_file = OutPath + "/" + '_'.join([ID_cas, ID_con, ID_con]) + "." + TAG + ".txt"
	cas_file = OutPath + "/" + '_'.join([ID_cas, ID_con, ID_cas]) + "." + TAG + ".txt"
	sha_file = OutPath + "/" + '_'.join([ID_cas, ID_con]) + "." + TAG + ".sha.txt"
		
	#cols = ["#CHR", "POS"]
	
	con_out = open(con_file, 'w')
	cas_out = open(cas_file, 'w')
	sha_out = open(sha_file, 'w')	

#	con_out.write('\t'.join(cols) + '\n')
#	cas_out.write('\t'.join(cols) + '\n')
#	sha_out.write('\t'.join(cols) + '\n')

	write_final(passed_dict, con_out, cas_out, sha_out)

	con_out.close()
	cas_out.close()
	sha_out.close()

##### EXECUTION ######

MHpath = sys.argv[1]
ID_con = sys.argv[2]
ID_cas = sys.argv[3]
OutPath = sys.argv[4]
DP = sys.argv[5]

TOOL=MHpath.split('/')[-3].split('.')[-1]

#1if '1.MH' in MHpath:
#	if "ND" in DP:
#		con_MH = MHpath + "/ND-" + ID_con + "/final.passed.tsv"
#		cas_MH = MHpath + "/ND-" + ID_cas + "/final.passed.tsv"
#	else:
#		con_MH = MHpath + "/"  + ID_con.replace('.', '-') + "/final.passed.tsv"
#	        cas_MH = MHpath + "/" +  ID_cas.replace('.', '-') + "/final.passed.tsv"	
#elif '3.MF' in MHpath:
#	if "ND" in DP:
#                con_MH = MHpath + "/" + ID_con + "/" + ID_con + ".features"
#                cas_MH = MHpath + "/" + ID_cas + "/" + ID_cas + ".features"
#        else:
#                con_MH = MHpath + "/"  + ID_con.replace('.', '-') + "/" + ID_con + ".features"
#                cas_MH = MHpath + "/" +  ID_cas.replace('.', '-') + "/" + ID_cas + ".features"
#elif '14.DM' in MHpath:
#	if "ND" in DP:
#                con_MH = MHpath + "/" + ID_con + ".DM.output.mosaic.txt"
#                cas_MH = MHpath + "/" + ID_cas + ".DM.output.mosaic.txt"
#        else:
#                con_MH = MHpath + "/"  + ID_con.replace('.', '-') + "/" + ID_con + ".DM.output.mosaic.txt"
#                cas_MH = MHpath + "/" +  ID_cas.replace('.', '-') + "/" + ID_cas + ".DM.output.mosaic.txt"
#
TP_cas_MH = MHpath + '/' + TOOL + '.' + ID_cas + "_TP.vcf"
TP_con_MH = MHpath + '/' + TOOL + '.' + ID_con + "_TP.vcf"
TAG="TP"
main(ID_con, ID_cas, TP_con_MH, TP_cas_MH, OutPath, TAG)


FP_cas_MH = MHpath + '/' + TOOL + '.' + ID_cas + "_FP.vcf"
FP_con_MH = MHpath + '/' + TOOL + '.' + ID_con + "_FP.vcf"
TAG="FP"
main(ID_con, ID_cas, FP_con_MH, FP_cas_MH, OutPath, TAG)
