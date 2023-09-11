#!/usr/bin/env bash

SUT="$1"	# SUT name (e.g., openssl-1.1.1) -- this name must match the name of the SUT folder inside the Docker container
ARGSFILE="$2"	# Filename of the args for dtls-fuzzer
TESTFILE="$3"	# Mandatory test-case for the learning
OPTIONS="$4" 	# Additional options for learning

if [ "${SUT}" == "wolfssl" ]; then
	cd ${DTLS_FUZZER} && CUSTOM_FUZZ_WOLFROOT="./suts/wolfssl" LD_LIBRARY_PATH="suts/wolfssl/src/.libs:$LD_LIBRARY_PATH" java -jar target/dtls-fuzzer.jar @${ARGSFILE} -timeLimit "PT48H" -equivalenceAlgorithms "SAMPLED_TESTS,RANDOM_WP_METHOD,WP_METHOD" -testFile ${TESTFILE} ${OPTIONS}
elif [ "${SUT}" == "gnutls" ]; then
	cd ${DTLS_FUZZER} && LD_LIBRARY_PATH="/usr/local/lib64:suts/${SUT}:$LD_LIBRARY_PATH" java -jar target/dtls-fuzzer.jar @${ARGSFILE} -timeLimit "PT48H" -equivalenceAlgorithms "SAMPLED_TESTS,RANDOM_WP_METHOD,WP_METHOD" -testFile ${TESTFILE} ${OPTIONS}
else
	cd ${DTLS_FUZZER} && LD_LIBRARY_PATH="suts/${SUT}:$LD_LIBRARY_PATH" java -jar target/dtls-fuzzer.jar @${ARGSFILE} -timeLimit "PT48H" -equivalenceAlgorithms "SAMPLED_TESTS,RANDOM_WP_METHOD,WP_METHOD" -testFile ${TESTFILE} ${OPTIONS}
fi
