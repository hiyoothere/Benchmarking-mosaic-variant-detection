# Import Modules
import sys
import bioparse as bp
import glob


# Input Parameters
IN_SAMP = sys.argv[1]
IN_DS = sys.argv[2]
OUTDIR = sys.argv[3]


# Key Variables
IN_DIR = $OUTDIR


if __name__ == '__main__':
    if IN_DS == "ND":
        IN_DIR += "/0.DF"
    else:
        IN_DIR += "/2.DS"
    IN_DIR = "{}/mx/{}-{}/param".format(IN_DIR, IN_DS, IN_SAMP)
    all_log_list = glob.glob("{}/stdout_*".format(IN_DIR))
    print (IN_DIR)
    print (all_log_list)
    all_log_list = glob.glob("/data/project/MRS/4.analysis/MHD0" + IN_DIR + "/ts/D0-M1-1/param/stdout*"
    valid = False
    avg_dep, alpha, beta = None, None, None
    for in_log in all_log_list:
        f = open(in_log, 'r')
        in_fp = bp.FileParser(in_log)
        for in_items in in_fp.iter():
            if len(in_items) > 1:
                if "100.00%" in in_items[-1]:
                    valid = True
                elif valid:
                    if "depth:" in in_items[-2]:
                        avg_dep = in_items[-1]
                    elif "alpha:" in in_items[-2]:
                        alpha = in_items[-1]
                    elif "beta:" in in_items[-2]:
                        beta = in_items[-1]
        if valid:
            break
    print("{};{};{}".format(avg_dep, alpha, beta))
