# Import Modules
import sys
sys.path.append(sys.path[0] + "/../common")
import bioparse as bp
import glob
import os
import math


# Input Parameters
IN_DIR = sys.argv[1]


# Key Variables
LOG_SIG = math.log10(0.05)


def __grab_input(in_dir):
    in_file_list = glob.glob("{}/*/*/final.passed.tsv".format(in_dir))
    if len(in_file_list) == 0:
        sys.exit(1)
    return in_file_list


def __parse_final(in_file, out_hd):
    case_file = open("{}.case.tsv".format(out_hd), "w")
    share_file = open("{}.shared.tsv".format(out_hd), "w")
    case_cnt = 0
    share_cnt = 0
    share_fail_cnt = 0
    err_fail_cnt = 0
    in_fp = bp.FileParser(in_file)
    for in_items in in_fp.iter():
        out_l = "{}\n".format(in_fp.get_line().strip())
        share_mos_prob = float(in_items[-2])
        if share_mos_prob > LOG_SIG:
            test_tup = (in_items[-2], in_items[-7], in_items[-12], in_items[-17])
            share_sig_prob = max(tuple(map(float, test_tup)))
            if share_sig_prob == share_mos_prob:
                share_cnt += 1
                share_file.write(out_l)
            else:
                share_fail_cnt += 1
                # print("#{}\n#{}\t{}\t{}".format(out_l, share_mos_prob, share_sig_prob, test_tup))
        elif float(in_items[-1]) > LOG_SIG:
            case_cnt += 1
            case_file.write(out_l)
        else:
            err_fail_cnt += 1
    in_fp.close()
    case_file.close()
    share_file.close()
    print("SHARE:{}\tCASE:{}\tSHARE_FAIL:{}\tERR_FAIL:{}".format(share_cnt, case_cnt, share_fail_cnt, err_fail_cnt))


if __name__ == '__main__':
    in_file_list = __grab_input(IN_DIR)
    print("## Input: {}".format(len(in_file_list)))
    for in_file in in_file_list:
        print(in_file)
    for in_file in in_file_list:
        if os.stat(in_file).st_size == 0:
            continue
        print("Processing {}".format(in_file))
        __parse_final(in_file, in_file[:-4])
    print("## All operations complete")
