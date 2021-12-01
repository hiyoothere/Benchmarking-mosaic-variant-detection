"""Generate expected case-ctrl allele frequency pairs."""


# Import modules
import sys
from itertools import product


# Input parameters
OUT_FILE = sys.argv[1]


# Global variables
VAR_TUP = ("V1", "V2", "V3", "V4", "V5")
M1_DICT = {"V1": (4, 9.6, 28), "V2": (0.5, 1, 3, 25)}
M2_DICT = {"V1": (4, 9.6, 28), "V3": (5, 8), "V4": (0.5, 3)}
M3_DICT = {"V1": (4, 9.6, 28), "V3": (7.5, 10, 12, 16), "V5": (1, 2, 4)}


if __name__ == '__main__':
    with open(OUT_FILE, "w") as out_f:
        for var_id in VAR_TUP:
            case_set = M3_DICT[var_id] if var_id in M3_DICT else (0,)
            ctrl_set1 = M2_DICT[var_id] if var_id in M2_DICT else (0,)
            ctrl_set2 = M1_DICT[var_id] if var_id in M1_DICT else (0,)
            ctrl_set = tuple(sorted(set(ctrl_set1).union(set(ctrl_set2))))
            het_pair_list = list(product(*[case_set, ctrl_set]))
            case_set2 = [x*2 for x in case_set]
            ctrl_set2 = [x*2 for x in ctrl_set]
            hom_pair_list = list(product(*[case_set2, ctrl_set2]))
            for cur_pair in het_pair_list:
                if cur_pair == (0, 0) or cur_pair in hom_pair_list:
                    continue
                out_l = f"{var_id}\t{cur_pair[0]}\t{cur_pair[1]}"
                print(out_l)
                out_f.write(f"{out_l}\n")
            for cur_pair in hom_pair_list:
                if cur_pair == (0, 0):
                    continue
                out_l = f"{var_id}\t{cur_pair[0]}\t{cur_pair[1]}"
                print(out_l)
                out_f.write(f"{out_l}\n")
