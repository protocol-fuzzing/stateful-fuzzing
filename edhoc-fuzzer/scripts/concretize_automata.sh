#!/bin/bash

SUT="$1"			# SUT name (e.g., uoscore-uedhoc)
ARGSFILE="$2"	# Filename of the args for edhoc-fuzzer
DOTFILE="$3"	# Filename of the abstract automata to concretize
OUTDIR="$4"		# Output directory

cd ${EDHOC_FUZZER}
mkdir ${OUTDIR}
# Extract abstract seeds from automata
echo "Produce abstract seeds from automata ${DOTFILE}"
automata_abstract_seeds.py ${DOTFILE} ${OUTDIR}
# Concretize all abstract seeds
ABSFILES=$(ls ${OUTDIR}/*.abstra)
for f in ${ABSFILES} ; do
	echo "Produce real seed from ${f}"
	sname=${f%.*}
	sname=${sname##*/}
	concretize_one.sh ${SUT} ${f} ${ARGSFILE} 
	if ! cmp -s ${OUTDIR}/${sname}.length send.length ; then
		echo "Real and abstract seeds' length match: SAVED"
		mv send.length ${OUTDIR}/${sname}.total_length
		mv send.raw ${OUTDIR}/${sname}.raw
		mv send.replay ${OUTDIR}/${sname}.replay
		if [ -f "recv.length" ]; then
			rm recv.length
			rm recv.raw
			rm recv.replay
		fi
	else
		echo "Real and abstract seeds' length doesn't match: DISCARDED"
		rm send.* recv.*
		mv ${OUTDIR}/${sname}.abstra ${OUTDIR}/${sname}.abstra.discard
		mv ${OUTDIR}/${sname}.length ${OUTDIR}/${sname}.length.discard
	fi
done
