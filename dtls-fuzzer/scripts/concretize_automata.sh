#!/bin/bash

SUT="$1"			# SUT name (e.g., openssl-1.1.1) -- this name must match the name of the SUT folder inside the Docker container
ARGSFILE="$2"	# Filename of the args for dtls-fuzzer
DOTFILE="$3"	# Filename of the abstract automata to concretize
OUTDIR="$4"		# Output directory

cd ${DTLS_FUZZER}
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
		mv send.length ${OUTDIR}/${sname}_client.length
		mv send.raw ${OUTDIR}/${sname}_client.raw
		mv send.replay ${OUTDIR}/${sname}_client.replay
		if [ -f "recv.length" ]; then
			mv recv.length ${OUTDIR}/${sname}_server.length
			mv recv.raw ${OUTDIR}/${sname}_server.raw
			mv recv.replay ${OUTDIR}/${sname}_server.replay
		fi
	else
		echo "Real and abstract seeds' length doesn't match: DISCARDED"
		rm send.* recv.*
		mv ${OUTDIR}/${sname}.abstra ${OUTDIR}/${sname}.abstra.discard
		mv ${OUTDIR}/${sname}.length ${OUTDIR}/${sname}.abstra.length
	fi
done
