#!/bin/sh
set -u
#
# Checking args
#

source scripts/config.sh

if [[ ! -d "$DIR" ]]; then
    echo "$DIR directory does not exist. Please provide a directory containing contigs to process. Job terminated."
    exit 1
fi

if [[ -f "$DIR/annotation_file_list.txt" ]]; then
    rm "$DIR/annotation_file_list.txt"
fi

export FILE_LIST="$DIR/annotation_file_list.txt"

find $DIR -maxdepth 1 -type f -name "*.fasta">> $FILE_LIST
find $DIR -maxdepth 1 -type f -name "*.fa">> $FILE_LIST
export NUM_FILES=$(wc -l < "$FILE_LIST")

if [[ $NUM_FILES -eq 0 ]]; then
  echo "No models found in $DIR, please correct config file. Job terminated."
  exit 1
fi

if [[ ! -d $OUT_DIR ]]; then
  echo "$OUT_DIR does not exists, we'll create it for you."
  mkdir $OUT_DIR
fi


#
# Job submission
#

PREV_JOB_ID=""
ARGS="-q $QUEUE -W group_list=$GROUP -M $MAIL_USER -m $MAIL_TYPE"

#
## 01-gene calling
#

PROG="01-gene_calling"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG"
init_dir "$STDERR_DIR" "$STDOUT_DIR"

if [[ "$CALLER" == "phanotate" ]]; then
    echo "launching gene annotation using phanotate  $SCRIPT_DIR/run_phanotate.sh "

    JOB_ID=`qsub $ARGS -v FILE_LIST,DIR,PHANOTATE,STDERR_DIR,STDOUT_DIR,OUT_DIR,WORKER_DIR -N run_phanotate -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_phanotate.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job. Job terminated
    fi

    echo "job successfully submited"

else
    echo "launching gene annotation using prodigal  $SCRIPT_DIR/run_prodigal.sh "

    JOB_ID=`qsub $ARGS -v SAMPLE_LIST,DIR,VIR_DIR,METABAT,STDERR_DIR,STDOUT_DIR,OUT -N run_prodigal -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_prodigal.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job. Job terminated
    fi

    echo "job successfully submited"
fi


