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
echo $i
OUT_FILE="$OUT_DIR/${i}_phanotate.txt"
PROT_FILE="$OUT_DIR/${i}_prot.faa"
GENE_FILE="$OUT_DIR/${i}_genes.fna"

echo "$PHANOTATE/phanotate.py $SAMPLE >> $OUT_FILE"
$PHANOTATE/phanotate.py $SAMPLE >> $OUT_FILE

echo "$WORKER_DIR/parse_phanotate.py"
python $WORKER_DIR/parse_phanotate.py -i $OUT_FILE -f $SAMPLE -p $PROT_FILE -g $GENE_FILE
