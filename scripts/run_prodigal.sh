#!/bin/bash

#PBS -l select=1:ncpus=16:mem=6gb
#PBS -l walltime=01:00:00
#PBS -l place=free:shared

conda activate bio

HOST=`hostname`
LOG="$STDOUT_DIR/${HOST}.log"
ERRORLOG="$STDERR_DIR/${HOST}.log"

if [ ! -f "$LOG" ] ; then
    touch "$LOG"
fi
echo "Started `date`">>"$LOG"
echo "Host `hostname`">>"$LOG"


SAMPLE=`head -n +${PBS_ARRAY_INDEX} $FILE_LIST | tail -n 1`

echo "processing $SAMPLE"
i="$(basename -- $SAMPLE)"

OUT_FILE="$OUT_DIR/${i}_prodigal.gff"
PROT_FILE="$OUT_DIR/${i}_prot.faa"
GENE_FILE="$OUT_DIR/${i}_genes.fna"

echo "$PRODIGAL/prodigal -i $SAMPLE -o $OUT_FILE -f gff  -a $PROT_FILE -d $GENE_FILE -p meta"
$PRODIGAL/prodigal -i $SAMPLE -o $OUT_FILE -f gff -a $PROT_FILE -d $GENE_FILE -p meta



