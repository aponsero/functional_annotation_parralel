export CWD=$PWD
# where programs are
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export PHANOTATE="/rsgrps/bhurwitz/alise/tools/PHANOTATE" #phanotate path
export PRODIGAL="/rsgrps/bhurwitz/alise/tools/Prodigal" #Prodigal path
# where the dataset to prepare is
export DIR="/rsgrps/bhurwitz/alise/temp/tests"
export OUT_DIR="/rsgrps/bhurwitz/alise/temp/tests/phanotate"
# choose tools to run
export CALLER="phanotate" #prodigal or phanotate

#place to store the scripts
export SCRIPT_DIR="$PWD/scripts"
export WORKER_DIR="$SCRIPT_DIR/workers"
# User informations
export QUEUE="standard"
export GROUP="bhurwitz"
export MAIL_USER="aponsero@email.arizona.edu"
export MAIL_TYPE="bea"

#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
