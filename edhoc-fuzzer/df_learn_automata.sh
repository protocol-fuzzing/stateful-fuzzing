#!/bin/bash

SUT="$1"			# SUT name (e.g., uoscore-uedhoc)
ARGSFILE="$2"	# Filename of the args for edhoc-fuzzer
OUTDIR="$3"		# Output directory
OPTIONS="$4" 	# Additional options for learning

EDHOC_FUZZER="/home/ubuntu/edhoc-fuzzer"
DOCKER_OUTDIR=${ARGSFILE##*/}

#create one container for each run
id=$(docker run --cpus=1 -d -it edhoc-fuzzer /bin/bash -c "cd ${EDHOC_FUZZER} && mkdir ${DOCKER_OUTDIR} && learn_automata.sh ${SUT} ${ARGSFILE} \"${OPTIONS}\" && mv experiments/results/* ${DOCKER_OUTDIR} && tar -czvf ${DOCKER_OUTDIR}.tar.gz ${DOCKER_OUTDIR}")
cid=${id::12} #store only the first 12 characters of a container ID
#
#wait until all these dockers are stopped
printf "\nWaiting for the following container to stop: ${cid}"
docker wait ${cid} > /dev/null
wait

docker cp ${cid}:${EDHOC_FUZZER}/${DOCKER_OUTDIR}.tar.gz ${OUTDIR}/ > /dev/null
printf "\nDeleting ${cid}"
docker rm ${cid} # Remove container now that we don't need it
