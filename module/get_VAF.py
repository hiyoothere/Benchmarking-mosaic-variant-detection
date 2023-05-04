#!/usr/bin/python

def MF(line):
	return (line.split('\t')[23])

def gatk(line):
	if line[0] != '#':
	        s = line.split('\t')[-1]
		s1 = line.split('\t')
        	info = s.split(':')
	        dp = int(info[2])
        	alt = int(info[1].split(',')[1])	
		if dp != 0:
		        return float(alt)/dp
		else:
			tmp = s1[-3].split('AF=')[1]
			sec_vaf = tmp.split(';')[0]
			return sec_vaf
def mtpd(line):
        if line[0] != '#':
                s = line.split('\t')[-1]
                s1 = line.split('\t')
                info = s.split(':')
                dp = int(info[3])
                alt = int(info[1].split(',')[1])
                if dp != 0:
                        return float(alt)/dp
                else:
                        tmp = s1[-3].split('AF=')[1]
                        sec_vaf = tmp.split(';')[0]
                        return sec_vaf
def mtpd_cont(line):
        if line[0] != '#':
                s = line.split('\t')[-2]
                s1 = line.split('\t')
                info = s.split(':')
                dp = int(info[3])
                alt = int(info[1].split(',')[1])
                if dp != 0:
                        return float(alt)/dp
                else:
                        tmp = s1[-3].split('AF=')[1]
                        sec_vaf = tmp.split(';')[0]
                        return sec_vaf
'''
def gatk_cont(line):
        if line[0] != '#':
                s = line.split('\t')[-2]
                s1 = line.split('\t')
                info = s.split(':')
                dp = int(info[2])
                alt = int(info[1].split(',')[1])
                if dp != 0:
                        return float(alt)/dp
                else:
                        tmp = s1[-3].split('AF=')[1]
                        sec_vaf = tmp.split(';')[0]
                        return sec_vaf'''

def mutect(line):
        if line[0] != '#':
                s = line.split('\t')[-1]
                info = s.split(':')
		vaf = info[2]
 #               dp = int(info[3])
#                alt = int(info[1].split(',')[1])
                return vaf

def MH(line):
	if line[0] != '#':
		s = line.split('\t')
		ref = int(s[7])
		alt = int(s[9])
		vaf = float(alt)/(ref+alt)
		return vaf
def STK(line):
        dic_idx = {'A': 0, 'C': 1, 'G':2, 'T':3}
        if line[0] != '#':
               s = line.strip().split('\t')
               format = s[-1]
               ref = s[3]
               alt = s[4]
               l_format = format.split(':')[4:]
               dp_cnt = int(format.split(':')[0])
               alt_cnt= int(l_format[dic_idx[alt]].split(',')[0])
               vaf = float(alt_cnt)/dp_cnt
               return vaf
def STK_cont(line):
        dic_idx = {'A': 0, 'C': 1, 'G':2, 'T':3}
        if line[0] != '#':
               s = line.strip().split('\t')
               format = s[-2]
               ref = s[3]
               alt = s[4]
               l_format = format.split(':')[4:]
               dp_cnt = int(format.split(':')[0])
               alt_cnt= int(l_format[dic_idx[alt]].split(',')[0])
               vaf = float(alt_cnt)/dp_cnt
               return vaf

def STK_ind(line):
        if line[0] != '#':
               s = line.strip().split('\t')
               format = s[-1]
               l_format = format.split(':')
               dp_cnt = int(l_format[0])
               alt_cnt= int(l_format[2].split(',')[0])
               vaf = float(alt_cnt)/(dp_cnt)
               return vaf
def STK_ind_cont(line):
        if line[0] != '#':
               s = line.strip().split('\t')
               format = s[-2]
               l_format = format.split(':')
               dp_cnt = int(l_format[0])
               alt_cnt= int(l_format[2].split(',')[0])
               vaf = float(alt_cnt)/(dp_cnt)
               return vaf 


def MH_cont(line):
	if line[0] != '#':
                s = line.split('\t')
		cont = s[11].split(',')
                ref = int(cont[0].split(':')[-1])
                alt = int(cont[1].split(':')[1][:-1])
                vaf = float(alt)/(ref+alt)
                return vaf
