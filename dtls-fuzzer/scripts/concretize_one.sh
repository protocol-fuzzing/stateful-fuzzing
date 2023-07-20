#!/bin/bash

SUT="$1"			# SUT name (e.g., openssl-1.1.1) -- this name must match the name of the SUT folder inside the Docker container
ABSFILE="$2"	# Filename of the abstract sequence to concretize
ARGSFILE="$3"	# Filename of the args for dtls-fuzzer

if [ "${SUT}" == "wolfssl" ]; then
	cd ${DTLS_FUZZER} && CUSTOM_FUZZ_WOLFROOT="./suts/wolfssl" LD_LIBRARY_PATH="suts/wolfssl/src/.libs:$LD_LIBRARY_PATH" java -jar target/dtls-fuzzer.jar @${ARGSFILE} -test ${ABSFILE}
elif [ "${SUT}" == "gnutls" ]; then
	cd ${DTLS_FUZZER} && LD_LIBRARY_PATH="/usr/local/lib64:suts/${SUT}:$LD_LIBRARY_PATH" java -jar target/dtls-fuzzer.jar @${ARGSFILE} -test ${ABSFILE}
else
	cd ${DTLS_FUZZER} && LD_LIBRARY_PATH="suts/${SUT}:$LD_LIBRARY_PATH" java -jar target/dtls-fuzzer.jar @${ARGSFILE} -test ${ABSFILE}
fi
