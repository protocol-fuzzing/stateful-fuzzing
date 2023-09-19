#!/bin/bash

SUT="$1"			# SUT name (e.g., uoscore-uedhoc)
ABSFILE="$2"	# Filename of the abstract sequence to concretize
ARGSFILE="$3"	# Filename of the args for edhoc-fuzzer

cd ${EDHOC_FUZZER} &&  java -jar edhoc-fuzzer.jar @${ARGSFILE} -test ${ABSFILE}
