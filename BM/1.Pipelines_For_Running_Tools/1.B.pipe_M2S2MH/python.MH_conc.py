import glob
import sys

##### creatin dict that will have all control positions
def con_pos(con_MH):
	con_dict = {}		
	f = open(con_MH, 'r')
	for line in f:
		s = line.split()
		chr = s[0]
		pos = s[1]	
		ref = int(s[7]) #ref depth
		alt = int(s[9]) #alt depth
		vaf = float(alt)/(ref+alt)
		alt_type = s[8] #alt base
		if chr in con_dict:
			if pos in con_dict[chr]:
				print "ERROR: %s : %s"%(chr, pos)
			else:
				con_dict[chr][pos] = [[vaf, "NA"], alt_type] ## VAF of con FIRST in list of vaf in position
		else:
			con_dict[chr] = {pos : [[vaf, "NA"], alt_type]}
	f.close()
	return con_dict

def combine(con_dict, cas_MH):
	cas = open(cas_MH, 'r')
	for line in cas:
		s = line.split()
		chr = s[0]
		pos = s[1] 
		ref = int(s[7]) #ref depth
		alt = int(s[9]) #alt depth
		vaf = float(alt)/(ref+alt)
		alt_type = s[8] #alt base
		if chr in con_dict:
			if pos in con_dict[chr]:
				con_dict[chr][pos][0][1] = vaf
			else:	
				con_dict[chr][pos] = [["NA", vaf], alt_type] ## VAF of cas SECOND in list of vaf in position
		else:
			con_dict[chr] = {pos : [["NA", vaf], alt_type] } 

	cas.close()	
	return con_dict	

def rem_het(total_dict):
	for chr in total_dict:
		for pos in total_dict[chr]:
			ls = total_dict[chr][pos][0]
			if 'NA' in ls:
				continue
			else:
				if (ls[0] >= 0.30) & (ls[1] >= 0.30): ### remove positions with af 30+ in both tissues
					total_dict[chr][pos][0] = ["NA"] ## VAF [con, cas] will be listed as ['NA']
	return total_dict

def write_final(passed_dict, con_out, cas_out, sha_out):
	
	#### DISORDERED
	for chr in passed_dict:
                for pos in passed_dict[chr]:
                        line = [chr, pos, passed_dict[chr][pos][1]]
                        ls = passed_dict[chr][pos][0] ### VAF of cas, con or 'NA'
                        if "NA" in ls:
				if len(ls) == 1: #when 'NA'
					continue
                                elif ls[0] == "NA": #when only case
					line.append(str(ls[1]))
                                        cas_out.write('\t'.join(line) + '\n')
                                else: #when only control
					line.append(str(ls[0]))
                                        con_out.write('\t'.join(line) + '\n')
                        else: #shared
				con_vaf = passed_dict[chr][pos][0][0] ### add con VAF for future analysis
				line = '\t'.join([chr, pos, passed_dict[chr][pos][1], str(con_vaf)]) + '\n' 
                                sha_out.write(line)	

		
def main(ID_con, ID_cas, con_MH, cas_MH, OutPath):	
	
	con_dict = con_pos(con_MH) # control positions
	
	total_dict = combine(con_dict, cas_MH) # conc positions of ctrl and case
 
	passed_dict = rem_het(total_dict) # remove any positions with 0.30+ VAF for both ctrl and case
	
	### writing files
	###### ctrl specific
	###### case specific
	###### shared (with 30% af filter)
	con_file = OutPath + "/" + '_'.join([ID_cas, ID_con, ID_con]) + ".txt"
	cas_file = OutPath + "/" + '_'.join([ID_cas, ID_con, ID_cas]) + ".txt"
	sha_file = OutPath + "/" + '_'.join([ID_cas, ID_con]) + ".sha.txt"
		
	con_out = open(con_file, 'w')
	cas_out = open(cas_file, 'w')
	sha_out = open(sha_file, 'w')	

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

if "ND" in DP:
	con_MH = MHpath + "/ND-" + ID_con + "/final.passed.tsv"
	cas_MH = MHpath + "/ND-" + ID_cas + "/final.passed.tsv"
else:
	con_MH = MHpath + "/"  + ID_con.replace('.', '-') + "/final.passed.tsv"
        cas_MH = MHpath + "/" +  ID_cas.replace('.', '-') + "/final.passed.tsv"	

main(ID_con, ID_cas, con_MH, cas_MH, OutPath)
