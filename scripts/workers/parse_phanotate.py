#!/usr/bin/python
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import argparse
import os
import sys


# --------------------------------------------------
def get_args():
    """Get command-line arguments"""

    parser = argparse.ArgumentParser(
        description='Parse results phanotate',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('-i',
                        '--pinput',
                        help='Phanotate output file',
                        metavar='PINPUT',
                        type=str,
                        default="")

    parser.add_argument('-f',
                        '--finput',
                        help='Sequence fasta file',
                        metavar='FINPUT',
                        type=str,
                        default="")

    parser.add_argument('-p',
                        '--protein',
                        help='Protein output file name',
                        metavar='PROT',
                        type=str,
                        default="")

    parser.add_argument('-g',
                        '--gene',
                        help='Gene output file name',
                        metavar='GENE',
                        type=str,
                        default="")

    return parser.parse_args()


# --------------------------------------------------

def main():
    args=get_args()
    fasta_file=args.finput
    phanotate_file=args.pinput
    protein_file=args.protein
    gene_file=args.gene

    record_dict = SeqIO.to_dict(SeqIO.parse(fasta_file, "fasta"))

    phanotate_CDS=[]
    phanotate_proteins=[]
    i=0

    # read the phanotate output file as a tsv
    with open(phanotate_file) as f:
        lines = f.read().split('\n')[:-1]
        for c, line in enumerate(lines):
            if not line.startswith('#'): #skip the comment lines from the file
                i=i+1
                data = line.split();
                curr_record=record_dict[data[3]]

                # get start and end of the CDS
                if int(data[0]) < int(data[1]):
                    start=int(data[0])-1
                    end=int(data[1])-1
                else:
                    start=int(data[1])
                    end=int(data[0])

                curr_CDS = curr_record.seq[start:end]
            
                # get reverse complement if strand == -
                if data[2] == "-":
                    curr_CDS=curr_CDS.reverse_complement()
                    print("reverse complement")
                else:
                    print(curr_CDS)

                #get a name for the CDS and create a record
                CDS_id=data[3]+"_CDS_"+str(i)
                new_record = SeqRecord(curr_CDS,CDS_id, '', '')
                new_record_prot = SeqRecord(curr_CDS.translate(),CDS_id, '', '')            
                # add record in the output list
                phanotate_CDS.append(new_record)
                phanotate_proteins.append(new_record_prot)

                # print verifications
                print(new_record.id)
                print(str(start)+"--"+str(end))

    # write output file
    SeqIO.write(phanotate_CDS, gene_file, "fasta")

    # write protein output file
    SeqIO.write(phanotate_proteins, protein_file, "fasta")

# --------------------------------------------------
if __name__ == '__main__':
    main()
