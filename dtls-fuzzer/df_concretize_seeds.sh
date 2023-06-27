#!/bin/bash

SUT="$1"			# SUT name (e.g., openssl-1.1.1) -- this name must match the name of the SUT folder inside the Docker container
ABSFILES="$2"	# List of filename of the abstract seeds to concretize
ARGSFILE="$3"	# Filename of the args for dtls-fuzzer
OUTDIR="$4"		# Output directory

DTLS_FUZZER="/home/ubuntu/dtls-fuzzer"
DOCKER_OUTDIR=${SUT}_seeds

#create one container for each run
id=$(docker run --cpus=1 -d -it dtls-fuzzer /bin/bash -c "cd ${DTLS_FUZZER} && mkdir ${DOCKER_OUTDIR} && concretize_seeds.sh ${SUT} '${ABSFILES}' ${ARGSFILE} ${DOCKER_OUTDIR} && tar -czvf ${DOCKER_OUTDIR}.tar.gz ${DOCKER_OUTDIR}")
cid=${id::12} #store only the first 12 characters of a container ID
#
#wait until all these dockers are stopped
printf "\nWaiting for the following container to stop: ${cid}"
docker wait ${cid} > /dev/null
wait

docker cp ${cid}:${DTLS_FUZZER}/${DOCKER_OUTDIR}.tar.gz ${OUTDIR}/ > /dev/null
printf "\nDeleting ${cid}"
docker rm ${cid} # Remove container now that we don't need it
