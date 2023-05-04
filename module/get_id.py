#!/usr/bin/python

def MF(line):
	if line[0] == 'M' or line[0] == 'D' or line[0] == 'S':
		s = line.split('\t')
		CHR= s[0].split('~')[1]
		pos = s[0].split('~')[2]
		ref = s[0].split('~')[3]
		alt = s[0].split('~')[4]
		id = CHR + ":" + pos + ':' + ref + ':' + alt
		return id

def STK(line):
        if line[0] != '#':
              s = line.split('\t')
              return s[0] + ':' + s[1] + ':' + s[3] + ':' + s[4]

def gatk(line):
	if line[0] != '#':
		s = line.split('\t')
#		print s
		return s[0] + ':' + s[1] + ':' + s[3] + ':' + s[4]

def MH(line):
	if line[0] != '#':
		s = line.split('\t')
#		print s
		return s[0] + ':' + s[1] + ':' + s[6] + ':' + s[8]
