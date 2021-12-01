"""Generate case-ctrl allele frequency pairs from pileup all sample merged file."""


# Import modules
import sys
from itertools import product


# Input parameters
IN_FILE = sys.argv[1]
NO_DUP = sys.argv[2]
FLOAT_PREC = sys.argv[3]
OUT_DIR = sys.argv[4]
OUT_ID = sys.argv[5]


# Global variables
no_dup = NO_DUP in {"true", "True", "TRUE", "t", "T"}
float_prec = int(FLOAT_PREC)
in_id = IN_FILE.split("/")[-1][:-4]
out_file = "{}/{}.{}.txt".format(OUT_DIR, in_id, OUT_ID)
zero_warn = False
blank_pair = (0.0, 0.0)


def __calculate_no_dup_pair(samp_list, err_hd):
    case_set = set()
    ctrl_set = set()
    case_count = 0
    ctrl_count = 0
    for samp in samp_list:
        samp_info = samp.split("_")
        samp_id = samp_info[0]
        cur_af = samp_info[4]
        cur_af_float = round(float(cur_af), float_prec)
        if zero_warn and cur_af_float == 0.0:
            print("WARNING: Null AF found > {}".format(err_hd))
        if "M3" in samp_id:
            case_count += 1
            case_set.add(cur_af_float)
        else:
            ctrl_count += 1
            ctrl_set.add(cur_af_float)
    if case_count < 18:
        case_set.add(0.0)
    if ctrl_count < 21:
        ctrl_set.add(0.0)
    case_list = sorted(case_set)
    ctrl_list = sorted(ctrl_set)
    comb_list = list(product(*[case_list, ctrl_list]))
    return comb_list


def __calculate_dup_pair(samp_list):
    case_list = [0.0] * 18
    ctrl_list = [0.0] * 21
    for samp in samp_list:
        samp_info = samp.split("_")
        samp_id = samp_info[0]
        cur_af = samp_info[4]
        cur_af_float = round(float(cur_af), float_prec)
        cur_samp_num = int(samp_id.split("-")[-1])
        if "M1" in samp_id:
            ctrl_list[cur_samp_num - 1] = cur_af_float
        elif "M2" in samp_id:
            ctrl_list[cur_samp_num + 8] = cur_af_float
        else:
            case_list[cur_samp_num - 1] = cur_af_float
    return list(product(*[case_list, ctrl_list]))


if __name__ == '__main__':
    print(f"# Input: {IN_FILE}")
    print(f"# Output: {out_file}")
    with open(out_file, "w") as out_f, open(IN_FILE, "r") as in_f:
        out_f.write("#CASE_AF\tCTRL_AF\tTAG\n")
        cur_chr = "chr0"
        for in_l in in_f:
            if in_l[0] == "#":
                continue
            in_items = in_l.split()
            if in_items[0] != cur_chr:
                cur_chr = in_items[0]
                print(cur_chr)
            err_hd = ":".join(in_items[:-1])
            samp_list = in_items[-1].split(";")
            if no_dup:
                pair_list = __calculate_no_dup_pair(samp_list, err_hd)
            else:
                pair_list = __calculate_dup_pair(samp_list)
            if blank_pair in pair_list:
                pair_list = [x for x in pair_list if x != blank_pair]
            if len(pair_list) > 0:
                for pair in pair_list:
                    out_l = f"{pair[0]}\t{pair[1]}\t{in_items[-2]}\n"
                    out_f.write(out_l)
    print("# All operations complete")
