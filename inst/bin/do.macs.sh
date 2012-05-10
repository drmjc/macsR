#!/bin/bash
# Run MACS, fix the output & annotate the peaks with nearest TSS and CpG island
# Note, currently there's only a small subset of the macs14 options available,
# & it's really only been tested on hg19 with BAM file(s)
# 
# usage:
# do.macs.sh -?
# do.macs.sh -t <treated.bam> -c <control.bam> -n TREATvsCON -f BAM -g hs
# do.macs.sh -t <treated.bam> -n TREATED -f BAM -g hs
#
# Mark Cowley, 2012-03-08
treatment=""
control=""
name=""
format=""
genome=""

usage()
{
cat << EOF
usage: $0 options

This script runs macs14, writes the results into the current working directory,
then fixes the output, and annotates to TSS and CpG islands.
It only provides a subset of the macs14 options, for running in single sample mode,
or 2 sample mode. 

Despite MACS supporting many input file types, this script has only
been tested with BAM files.

OPTIONS:
     -h, -?: help
     -t TFILE   ChIP-seq treatment file. REQUIRED.
     -c CFILE   ChIP-seq control file. OPTIONAL.
     -n NAME    Experiment Name, DEAFULT: "NA"
     -f FORMAT  Format of tag file, "AUTO", "BED" or "ELAND" or
        "ELANDMULTI" or "ELANDMULTIPET" or "ELANDEXPORT" or
        "SAM" or "BAM" or "BOWTIE". The default AUTO option
        will let MACS decide which format the file is. Please
        check the definition in 00README file if you choose EL
        AND/ELANDMULTI/ELANDMULTIPET/ELANDEXPORT/SAM/BAM/BOWTIE.
        DEFAULT: "AUTO"
     -g GSIZE  Effective genome size. It can be 1.0e+9 or 1000000000,
        or shortcuts:'hs' for human (2.7e9), 'mm' for mouse
        (1.87e9), 'ce' for C. elegans (9e7) and 'dm' for
        fruitfly (1.2e8), Default:hs
EOF
}

# Require macs14
hash macs14 2>/dev/null || { echo >&2 "I require macs14 but it's not installed.  Aborting."; exit 1; }

if [ $# -eq 0 ]; then 
  usage
  exit 1
fi

while getopts "t:c:n:f:g:h" option
do
     case "${option}" in
          t) [ -f "${OPTARG}" ] || { echo >&2 "-t file doesn't exist. Aborting"; exit 1; }
             treatment="-t ${OPTARG}";;
          c) [ -f "${OPTARG}" ] || { echo >&2 "-c file doesn't exist. Aborting"; exit 1; }
		     control="-c ${OPTARG}";;
          n) name="-n ${OPTARG}";;
          f) format="-f ${OPTARG}";;
          g) genome="-g ${OPTARG}";;
          h) usage
             exit 1;;
          \?) usage
             exit 1;;
     esac
done
# update $# to not include any of these options.
shift $(($OPTIND - 1)) 

if [ $# -ne 0 ]; then 
  echo "You have supplied additional parameters"
  usage
  exit 1
fi

echo "Running macs14 in `pwd`"
macs14 $treatment $control $name $format $genome --diag 2>&1 || { echo >&2 "macs14 failed. Aborting"; exit 2; }

echo "Fixing results"
Rscript --vanilla -e 'suppressPackageStartupMessages(library(macsR)); fix.macs.output(getwd(), fdr.thresh=c(5,10,15,25))' || { echo >&2 "fix.macs.output failed. Aborting"; exit 2; }
	
echo "Annotating results"
Rscript --vanilla -e 'suppressPackageStartupMessages(library(macsR)); annotate.macs.output(getwd(), "hg19", tss=TRUE, cpg=TRUE)' || { echo >&2 "annotate.macs.output failed. Aborting"; exit 2; }
