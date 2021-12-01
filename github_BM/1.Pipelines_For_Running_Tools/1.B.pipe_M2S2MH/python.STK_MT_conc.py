import sys
import glob

def Mutect(MUTECT, STK, MT_STK): ### create dict with mutect data line for each chr, pos
	
	MT_dict = {}
	f = open(MUTECT, 'r')
		
	for line in f:
		if '#' in line:
			if "fileformat" in line:
				fileformat = line
			continue
		else:
			s = line.split()
			chr = s[0]
			pos = s[1]
			if chr in MT_dict:
				if pos in MT_dict[chr]:
					print("ERROR: %s : %s"%(chr, pos))
				else:
					MT_dict[chr][pos] = line # need mutect data line when concordant with Strelka
			else:
				MT_dict[chr] = {pos : line}
	f.close()

	write_conc(MT_dict, fileformat, STK, MT_STK)

def write_conc(MT_dict, fileformat, STK, MT_STK):
	
	infile = open(STK, 'r')
	out = open(MT_STK, 'w')

	FINAL=[]
	#out.write(fileformat)
	for line in infile:
		if '#' in line:
			continue
		else:
			s = line.split()
			chr = s[0]
			pos = s[1]
			if chr in MT_dict:
				if pos in MT_dict[chr]:
					FINAL.append(MT_dict[chr][pos]) ### make list of data line
									### could've wrote output here but there was error in Mutect lines

	print len(FINAL)
	for i in range(0, len(FINAL)):
		if i == (len(FINAL)-1):
			#print i
			
			FINAL[i].rstrip('\n') #strip final line due to writing extra line when there is no data
			
			out.write(FINAL[i])
		else:
			out.write(FINAL[i]) #other lines can be written as is
	infile.close() 
	out.close()


def main(MUTECT, STK, MT_STK):
	
	MT_dict = Mutect(MUTECT, STK, MT_STK)


##### EXECUTION

#MUTECT = "/data/project/MRS/4.Analysis_Mosaic/4.MT/0.DF/mx/M3-9_M2-9.filtered.PASS.indels.vcf" 
#STK = "/data/project/MRS/4.Analysis_Mosaic/13.MSM/1.STK/0.DF/mx/M3-9_M2-9/results/variants/somatic.indels.PASS.vcf"
#MT_STK = "/data/project/MRS/4.Analysis_Mosaic/MSM/MT_STK/MT_STK.indels.PASS.vcf"

MUTECT= sys.argv[1]
STK = sys.argv[2]
MT_STK = sys.argv[3]

main(MUTECT, STK, MT_STK)


