import glob
import sys

def MS_data(MS_ls): ### make chr, pos dict with data line for each positions of Mutect-Strelka

	count =0
	MS_dict = {}
	for file in MS_ls:
		f = open(file, 'r')
		for line in f:
			s = line.split()
			chr = s[0]
			pos = int(s[1])
			if chr in MS_dict:
				if pos in MS_dict[chr]:
					print "ERROR :  position already in place"
				else:
					MS_dict[chr][pos] = line
					count +=1
			else:
				MS_dict[chr] = {pos : line}
				count+=1
		f.close()

	return MS_dict

def final(MH_file, MS_dict, outfile): #### only write output of MH positions present in Mutect-Strelka positions
	f = open(MH_file, 'r')
	for line in f: 
		s = line.split()
                chr = s[0]
                pos = int(s[1])
		if chr in MS_dict:
			if pos in MS_dict[chr]:
				MS_dict[chr][pos] = line ## replace concurrent tissue-specific calls with MH data
			else:
				MS_dict[chr][pos] = line
		else:
			MS_dict[chr] = {pos : line}
	f.close()
	
	### SORTING BY CHR number, CHR alphabet, and POS of each chr
	chr_num =[]
        chr_alp = []
        for chr in MS_dict:
                if any(i.isdigit() for i in chr) == True:
                        chr_num.append(int(chr.replace('chr', '')))
                else:
                        chr_alp.append(chr.replace('chr', ''))
        chr_num.sort()
        chr_alp.sort()
        out = open(outfile, 'w')
        for i in range(0, len(chr_num)):
                chr = 'chr'+str(chr_num[i])
                pos_ls = []
                for pos in MS_dict[chr]:
                        pos_ls.append(pos)
                pos_ls.sort()
                for j in range(0, len(pos_ls)):
                        out.write(MS_dict[chr][pos_ls[j]] )

        for i in range(0, len(chr_alp)):
                chr = 'chr'+str(chr_alp[i])
                pos_ls = []
                for pos in MS_dict[chr]:
                        pos_ls.append(pos)
                pos_ls.sort()
                for j in range(0, len(pos_ls)):
                        out.write(MS_dict[chr][pos_ls[j]] )
        out.close()


def main(MS, MH_ls, OutPath, ID_cas, ID_con):

	for file in MH_ls:
		temp = file.split('/')[-1].split('.')[0].split('_') ### MH file IDs
		
		if 'D' in temp[0]: ### MH file IDs for Downsaample
			IDs = file.split('/')[-1].split('_')
			IDs[-1] = IDs[-1].replace(".txt", "")
			if 'sha' in IDs[-1]:
				IDs[-1]=IDs[-1].replace('.sha', '')
			temp = IDs
			
		if len(temp) != 3: ## exclude shared MH files
			continue
		else:
			case = temp[0] #M3
			ctrl = temp[1] #M1|M2
			spec = temp[-1] ## specific tissue 
			if spec == ID_con: # if control specific
				MS_ls = glob.glob(MS + '/' + '_'.join([spec, case]) + ".*.vcf" )
			else: # if case specific
				MS_ls = glob.glob(MS + '/' + '_'.join([spec, ctrl]) + ".*.vcf" )
			
			if len(MS_ls) != 0:
				MS_dict = MS_data(MS_ls)
				outfile = OutPath + '/' + file.split('/')[-1]
				final(file, MS_dict, outfile)
	
##### EXECUTION

ID_con = sys.argv[1]
ID_cas = sys.argv[2]
MS = sys.argv[3]
MH = sys.argv[4]
OutPath = sys.argv[5]

MH_files = glob.glob(MH + '/' + '_'.join([ID_cas, ID_con]) + "_*txt" )
MH_2 = glob.glob(MH + '/' + '_'.join([ID_cas, ID_con]) + ".*txt" )
MH_files.extend(MH_2)

print MH_files

main(MS, MH_files, OutPath, ID_cas, ID_con)

