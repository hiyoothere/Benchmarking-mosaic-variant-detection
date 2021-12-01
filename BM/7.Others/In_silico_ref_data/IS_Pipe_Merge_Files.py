import sys
import os.path
import time
import parse

## Input Parameters
IN_DIR = sys.argv[1]
OUT_DIR = sys.argv[2]
IS_INPUT = sys.argv[3]
IV_INPUT = sys.argv[4]

def WriteMergedFiles(is_cvcf_file, iv_cvcf_file, m_pc_cvcf_file, m_nc_cvcf_file):
	init_time = time.time()
	iv_fp = parse.FileParser(iv_cvcf_file)
	is_fp = parse.FileParser(is_cvcf_file)
	with open(m_pc_cvcf_file, "w") as pc_f, open(m_nc_cvcf_file, "w") as nc_f:
		pc_f.write("#IV_REF_BQ\tIV_ALT_BQ\tIS_REF_BQ\tIS_ALT_BQ\t"+
			"IV_AF\tIS_AF\tVAR\tZYG\n")
		nc_f.write("#IV_REF_BQ\tIV_ALT_BQ\tIS_REF_BQ\tIS_ALT_BQ\t"+
			"IV_AF\tIS_AF\tTAG\n")
		l_cnt = 0
		while not(iv_fp.term) and not(is_fp.term):
				parse.printprog(l_cnt, init_time)
				l_cnt += 1
				iv_e = iv_fp.getlinelist()
				is_e = is_fp.getlinelist()
				cur_cmp_res = iv_fp.cmpanditer(is_fp)
				if cur_cmp_res == 0:
					if "nc" in iv_e[-1]:
						nc_f.write("{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(
							iv_e[-6], iv_e[-5], is_e[-6], is_e[-5],
							iv_e[-2], is_e[-2], iv_e[-1]))
					else:
						tag_list = iv_e[-1].split("-")
						pc_f.write("{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(
							iv_e[-6], iv_e[-5], is_e[-6], is_e[-5],
							iv_e[-2], is_e[-2], tag_list[1], tag_list[2]))
	iv_fp.closeobj()
	is_fp.closeobj()

if __name__ == '__main__':
	m_pc_cvcf_file = OUT_DIR + "/" + IV_INPUT + ".af.bq.tag.merged.pc.cvcf"
	m_nc_cvcf_file = OUT_DIR + "/" + IV_INPUT + ".af.bq.tag.merged.nc.cvcf"
	is_cvcf_file = IN_DIR + "/" + IS_INPUT + ".af.bq.tag.cvcf"
	iv_cvcf_file = IN_DIR + "/" + IV_INPUT + ".af.bq.tag.cvcf"

	if os.path.isfile(m_pc_cvcf_file) and os.path.isfile(m_nc_cvcf_file):
		print("** Merged .cvcf files has been generated previously")
	else:
		print("** Merging .cvcf files")
		print("** Generating merged PC .cvcf file: {}".format(m_pc_cvcf_file))
		print("** Generating merged NC .cvcf file: {}".format(m_nc_cvcf_file))
		WriteMergedFiles(is_cvcf_file, iv_cvcf_file, m_pc_cvcf_file, m_nc_cvcf_file)
		print("** All operations complete")