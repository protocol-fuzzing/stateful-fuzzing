#!/bin/bash

SUT="$1"			# SUT name (e.g., openssl-1.1.1) -- this name must match the name of the SUT folder inside the Docker container
ARGSFILE="$2"	# Filename of the args for dtls-fuzzer
DOTFILE="$3"	# Mandatory test-case for the learning
OUTDIR="$4"		# Output directory

DTLS_FUZZER="/home/ubuntu/dtls-fuzzer"
AUTOMATA="/home/ubuntu/automata"

#create one container for each run
id=$(docker run --cpus=1 -d -it --mount type=bind,source="$(pwd)"/automata,target=${AUTOMATA},readonly dtls-fuzzer /bin/bash -c "cd ${DTLS_FUZZER} && concretize_automata.sh ${SUT} ${ARGSFILE} ${AUTOMATA}/${DOTFILE} ${OUTDIR} && tar -czvf ${OUTDIR}.tar.gz ${OUTDIR}")
cid=${id::12} #store only the first 12 characters of a container ID
#
#wait until all these dockers are stopped
printf "\nWaiting for the following container to stop: ${cid}"
docker wait ${cid} > /dev/null
wait

docker cp ${cid}:${DTLS_FUZZER}/${OUTDIR}.tar.gz ./${OUTDIR}.tar.gz > /dev/null
printf "\nDeleting ${cid}"
docker rm ${cid} # Remove container now that we don't need it
