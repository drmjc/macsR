#!/bin/bash
# Fix a MACS output file.
# 
# usage:
# fix.macs.sh -?
# fix.macs.sh /path/to/macs/results
#
# Mark Cowley, 2012-03-13

usage()
{
cat << EOF
usage: $0 options /path/to/macs/results

This script takes a MACS result directory & annotates the peaks with nearest TSS and CpG islands.

OPTIONS:
     -h, -?: help
EOF
}

if [ $# -eq 0 ]; then 
  usage
  exit 1
fi

while getopts "h" option
do
     case "${option}" in
          h) usage
             exit 1;;
          \?) usage
             exit 1;;
     esac
done
# update $@ to not include any of these options.
shift $(($OPTIND - 1)) 

dir=${1-"."}
if [ ! -d "$dir" ]; then 
	echo "ERROR: input should be a directory: $dir"
	usage
	exit 2
fi

cd "$dir"
echo "Annotating MACS results in `pwd`"
Rscript --vanilla -e 'suppressPackageStartupMessages(library(macsR)); fix.macs.output(getwd(), fdr.thresh=c(5,10,15,25))' || { echo >&2 "fix.macs.output failed. Aborting"; exit 2; }
cd -
