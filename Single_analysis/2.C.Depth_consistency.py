#!/usr/bin/python

import sys
import glob
from itertools import combinations

#. Get call set consistency across four different depths
# ND=1100x, D1=125x, D2=250x, D3=500x

def whole_dict(whole_files, DATA, TAG):
	for file in whole_files:
		f = open(file, 'r')
		for line in f:
			s = line.split()
			sample = s[1].split('.')[0]
			if sample == 'ind':
				sample = s[1].split('.')[1]
			chr = s[2]
			pos = s[3]
			if sample in DATA:
				if chr in DATA[sample]:
					if pos in DATA[sample][chr]:
						continue
					else:
						DATA[sample][chr][pos] = ["ND"]
				else:
					DATA[sample][chr] = {pos : ["ND"]}
			else:
				DATA[sample] = {chr : {pos : ["ND"]}}

		f.close()
	return DATA

def DS_dict(DS_files, DATA, outfile, TAG):
	for file in DS_files:
		#print depth
		d = open(file, 'r')
		for line in d:
			s = line.split()
			temp = s[1].split('.')
			if len(temp) >= 2:
                        	sample = temp[1]
                                depth = temp[0]
				if temp[0] == 'ind':
					sample = temp[2]
					depth = temp[1]
                        else:
                                sample = '-'.join(s[1].split('-')[1:])
                                depth = s[1].split('-')[0]
                        chr = s[2]
                        pos = s[3]
	
			if sample in DATA:
		        	if chr in DATA[sample]:
		                	if pos in DATA[sample][chr]:
		                        	DATA[sample][chr][pos].append(depth)
		                        else:
		                        	DATA[sample][chr][pos] = [depth]
		                else:
		                        DATA[sample][chr] = {pos : [depth]}
		        else:
		                DATA[sample] = {chr : {pos : [depth]}}
			
		d.close()
	
	count_comb(DATA, outfile)

def count_comb(DATA, outfile):
	depth = ["ND", "D1", "D2", "D3"]

	all_comb = {}
	for n in range(1, len(depth)+1):
		comb  = [i for i in combinations(depth, n)]
		for c in comb:
			all_comb[c] = 0
	
	for sample in DATA:
		for chr in DATA[sample]:
			for pos in DATA[sample][chr]:
				for c in all_comb:
					if DATA[sample][chr][pos] == list(c):
						all_comb[c]+=1
	print all_comb
	
	out = open(outfile, 'w')
	cols = ["COMB", 'CT']
	out.write('\t'.join(cols) + '\n')
	for c in all_comb:
		COMB = "&".join(list(c)) 
		out.write('\t'.join([COMB, str(all_comb[c])]) + '\n')
	out.close()

def main(whole_files, DS_files, outfile, TAG):
	
	DATA = {}
	DATA = whole_dict(whole_files, DATA, TAG)
	
	DS_dict(DS_files, DATA, outfile, TAG)	


########### EXECUTION
import sys

wholePath = sys.argv[1] # parsed input file path of 1100x
DSPath = sys.argv[2] # parsed input file path of other depths
TAG = sys.argv[3] # part of suffix of the outputfile
outfile = sys.argv[4] #output file

whole_files = glob.glob(wholePath + '/*_%s.vcf'%(TAG))
DS_files  = glob.glob(DSPath + '/*_%s.vcf'%(TAG))

if len(whole_files) == 0:
	print "missing whole files"
elif len(DS_files) == 0:
	print "missing DS files"
else:
	main(whole_files, DS_files, outfile, TAG)

