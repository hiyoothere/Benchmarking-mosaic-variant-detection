"""Generate allele frequencies from pileup all sample merged file."""


# Import modules
import sys


# Input parameters
IN_FILE = sys.argv[1]
FLOAT_PREC = sys.argv[2]
OUT_DIR = sys.argv[3]
OUT_ID = sys.argv[4]


# Global variables
float_prec = int(FLOAT_PREC)
in_id = IN_FILE.split("/")[-1][:-4]
out_file = "{}/{}.{}.txt".format(OUT_DIR, in_id, OUT_ID)


def __get_af_list(samp_list):
    af_list = list()
    for samp in samp_list:
        samp_info = samp.split("_")
        cur_af = samp_info[4]
        cur_af_float = round(float(cur_af), float_prec)
        af_list.append(cur_af_float)
    return af_list


if __name__ == '__main__':
    print(f"# Input: {IN_FILE}")
    print(f"# Output: {out_file}")
    with open(out_file, "w") as out_f, open(IN_FILE, "r") as in_f:
        out_f.write("#AF\tTAG\n")
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
            af_list = __get_af_list(samp_list)
            if len(af_list) > 0:
                for af in af_list:
                    out_l = f"{af}\t{in_items[-2]}\n"
                    out_f.write(out_l)
    print("# All operations complete")
