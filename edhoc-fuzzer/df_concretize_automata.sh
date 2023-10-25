#!/usr/bin/env bash

SUT="$1"			# SUT name (e.g., uoscore-uedhoc)
ARGSFILE="$2"	# Filename of the args for edhoc-fuzzer
DOTFILE="$3"	# Mandatory test-case for the learning
OUTDIR="$4"		# Output directory

EDHOC_FUZZER="/home/ubuntu/edhoc-fuzzer"
AUTOMATA="/home/ubuntu/automata"
DOTFILE_NAME=${DOTFILE##*/}
DOCKER_OUTDIR=${DOTFILE_NAME%.*}_automata_seeds

#create one container for each run
id=$(docker run --cpus=1 -d -it --mount type=bind,source="$(pwd)"/${DOTFILE},target=${AUTOMATA}/${DOTFILE_NAME},readonly edhoc-fuzzer /bin/bash -c "cd ${EDHOC_FUZZER} && concretize_automata.sh ${SUT} ${ARGSFILE} ${AUTOMATA}/${DOTFILE_NAME} ${DOCKER_OUTDIR} && tar -czvf ${DOCKER_OUTDIR}.tar.gz ${DOCKER_OUTDIR}")
cid=${id::12} #store only the first 12 characters of a container ID
#
#wait until all these dockers are stopped
printf "\nWaiting for the following container to stop: ${cid}"
docker wait ${cid} > /dev/null
wait

docker cp ${cid}:${EDHOC_FUZZER}/${DOCKER_OUTDIR}.tar.gz ${OUTDIR}/ > /dev/null
printf "\nDeleting ${cid}"
docker rm ${cid} # Remove container now that we don't need it
