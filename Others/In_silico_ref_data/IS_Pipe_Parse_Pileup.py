import sys
import glob
import time
import os.path
import re
import tree
import parse

## Input Parameters
IN_DIR = sys.argv[1]
OUT_DIR = sys.argv[2]
IS_INPUT = sys.argv[3]
IV_INPUT = sys.argv[4]
IV_PUP_DIR = sys.argv[5]

## Key Variables
NC_P_FILE = "/data/project/RefStand/gavehan/PIPE/py_pickle/nc.treedic.nc.p"
FA_DIR = "/data/project/RefStand/FA/2.After_ManCNV"
ALT_PAT_SET = set("atgcATGC")
BQ_MIN_CNST = ord("!")

def GrabIvPupFile(iv_pup_dir, iv_pup_id, id_head):
    iv_pup_list = glob.glob(iv_pup_dir + "/*.pileup")
    if id_head:
        iv_pup_pat = re.compile("^{}.*{}.*".format(id_head, iv_pup_id))
    else:
        iv_pup_pat = re.compile(".*{}.*".format(iv_pup_id))
    for iv_pup in iv_pup_list:
        iv_pup_name = iv_pup.split("/")[-1]
        if not(re.fullmatch(iv_pup_pat, iv_pup_name) is None):
            return iv_pup
    return None

def GetFaFileList(fa_dir, mos):
    fa_file_list = []
    fa_file_head = fa_dir + "/FA-V"
    if mos == 1:
        fa_file_list.append(fa_file_head+"1-het.vcf")
        fa_file_list.append(fa_file_head+"1-hom.vcf")
        fa_file_list.append(fa_file_head+"2-het.vcf")
        fa_file_list.append(fa_file_head+"2-hom.vcf")
    elif mos == 2:
        fa_file_list.append(fa_file_head+"1-het.vcf")
        fa_file_list.append(fa_file_head+"1-hom.vcf")
        fa_file_list.append(fa_file_head+"3-het.vcf")
        fa_file_list.append(fa_file_head+"3-hom.vcf")
        fa_file_list.append(fa_file_head+"4-het.vcf")
        fa_file_list.append(fa_file_head+"4-hom.vcf")
    elif mos == 3:
        fa_file_list.append(fa_file_head+"1-het.vcf")
        fa_file_list.append(fa_file_head+"1-hom.vcf")
        fa_file_list.append(fa_file_head+"3-het.vcf")
        fa_file_list.append(fa_file_head+"3-hom.vcf")
        fa_file_list.append(fa_file_head+"5-het.vcf")
        fa_file_list.append(fa_file_head+"5-hom.vcf")
    return fa_file_list

def EnrichFaTreeDic(fa_file, fa_tree_dic):
    init_time = time.time()
    fa_file_id_list = fa_file.split("/")[-1].split(".")
    fa_id = ".".join(fa_file_id_list[:-1])
    with open(fa_file, "r") as fa_f:
        for l_cnt, fa_l in enumerate(fa_f):
            parse.printprog(l_cnt, init_time)
            fa_e = fa_l.split()
            fa_chr_key = fa_e[0][3:]
            if not(fa_chr_key in fa_tree_dic):
                fa_tree_dic[fa_chr_key] = tree.LLRBtree()
            if not(fa_tree_dic[fa_chr_key].search(int(fa_e[1])) is None):
                print("ERROR: Duplicate FA tree-dic entry: {}".format(fa_l))
            fa_tree_dic[fa_chr_key].insert(int(fa_e[1]), fa_id)
    return fa_tree_dic

def WriteCvcfFile(pup_file, out_file, fa_tree_dic):
    init_time = time.time()
    with open(pup_file, "r") as p_f, open(out_file, "w") as out_f:
        hd = "{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(
            "#CHR", "POS", "REF_NT", "ALT_NT",
            "REF_AVG_BQ", "ALT_AVG_BQ", "REF_CNT", "ALT_CNT",
            "AF", "TAG")
        out_f.write(hd)
        for l_cnt, p_l in enumerate(p_f):
            parse.printprog(l_cnt, init_time)
            if "#" in p_l:
                continue
            p_e = p_l.split()
            p_chr_key = p_e[0][3:]
            if not(p_chr_key in fa_tree_dic):
                continue
            fa_tag = fa_tree_dic[p_chr_key].search(int(p_e[1]))
            if fa_tag is None:
                continue
            try:
                p_info = ProcessPupLine(p_e[4], p_e[5])
                af = p_info[-1] / (p_info[-2] + p_info[-1]) if p_info[-1] > 0 else 0.0
                out_l = "{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(
                    p_e[0], p_e[1], p_e[2], p_info[0], p_info[1],
                    p_info[2], p_info[3], p_info[4], af, fa_tag)
                out_f.write(out_l)
            except Exception as e:
                print("ERROR: .pup Line: {}".format(p_l))
                raise e

def ProcessPupLine(base_str, qual_str):
    base_idx = 0
    qual_idx = 0
    alt_cnt_dic = {"A":0, "T":0, "C":0, "G":0}
    alt_bq_dic = {"A":0, "T":0, "C":0, "G":0}
    ref_cnt = 0
    ref_bq = 0.0
    while base_idx < len(base_str) and qual_idx < len(qual_str):
        cur_nt = base_str[base_idx]
        cur_bq = ord(qual_str[qual_idx]) - BQ_MIN_CNST
        if cur_nt == "." or cur_nt == ",":
            ref_cnt += 1
            ref_bq += cur_bq
            qual_idx += 1
        elif cur_nt in ALT_PAT_SET:
            alt_cnt_dic[cur_nt.upper()] += 1
            alt_bq_dic[cur_nt.upper()] += cur_bq
            qual_idx += 1
        elif cur_nt == "^":
            base_idx += 1
        elif cur_nt == "*" or cur_nt == "<" or cur_nt == ">":
            qual_idx += 1
        elif cur_nt == "+" or cur_nt == "-":
            skip = base_idx + 1
            indel_len_str = ""
            while(base_str[skip].isdigit()):
                indel_len_str += base_str[skip]
                skip += 1
            indel_len = int(indel_len_str)
            base_idx = skip + indel_len - 1
        base_idx += 1

    maj_alt_nt = "."
    maj_alt_cnt = 0
    for nt in alt_cnt_dic:
        if alt_cnt_dic[nt] > maj_alt_cnt:
            maj_alt_nt = nt
            maj_alt_cnt = alt_cnt_dic[nt]
    ref_avg_bq = ref_bq / ref_cnt if ref_cnt > 1 else 0.0
    maj_alt_avq_bq = 0.0 if maj_alt_nt == "." else alt_bq_dic[maj_alt_nt] / maj_alt_cnt
    return (maj_alt_nt, ref_avg_bq, maj_alt_avq_bq, ref_cnt, maj_alt_cnt)

if __name__ == '__main__':
    is_pup_file = IN_DIR + "/" + IS_INPUT
    is_cvcf_file = OUT_DIR + "/" + IS_INPUT[:-4] + ".af.bq.tag.cvcf"
    iv_pup_file = GrabIvPupFile(IV_PUP_DIR, IV_INPUT, "For_PU_")
    iv_cvcf_file = OUT_DIR + "/" + IV_INPUT + ".af.bq.tag.cvcf"

    if os.path.isfile(is_cvcf_file) and os.path.isfile(iv_cvcf_file):
        print("** IS .cvcf and IV .cvcf have been generated previously")
    else:
        print("** Loading FA tree-dic with NC data from {}".format(NC_P_FILE))
        fa_annot_tree_dic = parse.loadpickle(NC_P_FILE)
        fa_file_list = GetFaFileList(FA_DIR, int(IV_INPUT[1]))
        for fa_file in fa_file_list:
            print("** Enriching FA tree-dic with {}".format(fa_file))
            fa_annot_tree_dic = EnrichFaTreeDic(fa_file, fa_annot_tree_dic)
        print("** FA tree-dic construction complete")
        if os.path.isfile(is_cvcf_file):
            print("** IS .cvcf has been generated previously: {}".format(is_cvcf_file))
        else:
            print("** Generating IS .cvcf: {}".format(is_cvcf_file))
            WriteCvcfFile(is_pup_file, is_cvcf_file, fa_annot_tree_dic)
        if os.path.isfile(iv_cvcf_file):
            print("** IV .cvcf has been generated previously: {}".format(iv_cvcf_file))
        else:
            print("** Generating IV .cvcf: {}".format(iv_cvcf_file))
            WriteCvcfFile(iv_pup_file, iv_cvcf_file, fa_annot_tree_dic)
        print("** All operations complete")
