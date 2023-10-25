#!/usr/bin/env bash

SUT="$1"			# SUT name (e.g., uoscore-uedhoc)
ABSFILES="$2"	# List of filename of the abstract seeds to concretize
ARGSFILE="$3"	# Filename of the args for edhoc-fuzzer
OUTDIR="$4"		# Output directory

cd ${EDHOC_FUZZER}
for f in ${ABSFILES} ; do
	concretize_one.sh ${SUT} examples/tests/${f} ${ARGSFILE}
	mv send.length ${OUTDIR}/${SUT}_${f}_client.length
	mv send.raw ${OUTDIR}/${SUT}_${f}_client.raw
	mv send.replay ${OUTDIR}/${SUT}_${f}_client.replay
	mv recv.length ${OUTDIR}/${SUT}_${f}_server.length
	mv recv.raw ${OUTDIR}/${SUT}_${f}_server.raw
	mv recv.replay ${OUTDIR}/${SUT}_${f}_server.replay
done
