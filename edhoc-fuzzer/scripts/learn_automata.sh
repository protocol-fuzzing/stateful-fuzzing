#!/usr/bin/env bash

SUT="$1"			# SUT name (e.g., uoscore-uedhoc)
ARGSFILE="$2"	# Filename of the args for edhoc-fuzzer
OPTIONS="$3" 	# Additional options for learning

cd ${EDHOC_FUZZER} && java -jar edhoc-fuzzer.jar @${ARGSFILE} ${OPTIONS}
