# DTLS-Fuzzer docker

This project aims at embedding [DTLS-Fuzzer](https://github.com/assist-project/dtls-fuzzer) into a stable and controllable environment, i.e. a docker container.
The main benefit is that the SUTs (Systems Under Test) processed with DTLS-Fuzzer can after be fuzzed/tested by other tools under the same conditions.

Three scripts are available to do the following three operations:
 - learn SUTs (Systems Under Test)
 - concretize abstract input sequences
 - extract abstract input traces from an automata (transition cover) and concretize them


## Install

To build the Docker container run:
```shell
docker build -t dtls-fuzzer .
```
It will install all the dependencies for DTLS-Fuzzer and the SUTs.
A patch is applied to DTLS-Fuzzer in order to enable the dumping of the input/output sequences.
The script `setup_sut.sh` of DTLS-Fuzzer is overwritten by the extended one.
The patches in the folder `patches` are applied to the corresponding SUTs.
The configuration files in the folder `args` are added to DTLS-Fuzzer. 
All the test-cases in the `examples/tests` are added to DTLS-Fuzzer.

Finally the following SUTs are installed using the script `setup_sut.sh`:
 - etinydtls
 - openssl-1.1.1
 - openssl-3.0
 - wolfssl
 - mbedtls


## Usage

In the following, we refer as *seed* for a sequence of inputs/outputs.
An *abstract seed* is a sequence of letter from the abstract alphabet defined in DTLS-Fuzzer.
A *real seed* is the concretization of an abstract seed during a communication with a real SUT.
We record both the second of *inputs* and the sequence of *outputs* during a communication with the SUT.


### Learn an automata model of an SUT

To learn an automata modelling a SUT, use the script
```shell
./df_learn_automata.sh <sut> <conf_file> <test_file> <out_dir> [options]
```
Where:
 - `sut` is the codename of the SUT used in `setup_sut.sh`
 - `conf_file` is the path to the configuration file in the folder `args`
 - `test_file` is the file from the folder `examples/tests` which is compulsorily add to the query tests
 - `out_dir` is the folder to store the output
 - `options`[optional] additional options for DTLS-Fuzzer (between quotes)

#### Example:
```shell
./df_learn_automata.sh openssl-1.1.1 args/openssl-1.1.1/learn_openssl-1.1.1_all_cert_req_rwalk_incl examples/tests/dhe_ecdhe_psk_rsa_cert results-learning/
```

#### Results:
A compressed archive named `[sut]_learn.tar.gz` containing the output of DTLS-Fuzzer



### Concretize a set of abstract seeds

To concretize a set of abstract seeds, use the script:
```shell
./df_concretize_seeds.sh <sut> <abstract_seeds> <conf_file> <out_dir>
```
Where:
 - `sut` is the codename of the SUT used in `setup_sut.sh`
 - `abstract_seeds` is the list (between quotes and separated with a space) of abstract seeds from the folder `examples/tests` to concretize
 - `conf_file` is the path to the configuration file in the folder `args`
 - `out_dir` is the folder to store the output

#### Example:
```shell
./df_concretize_seeds.sh openssl-1.1.1 "psk rsa ecdhe" args/openssl-1.1.1/learn_openssl-1.1.1_all_cert_none_rwalk_incl results-seeds/
```

#### Results:
A compressed archive named `[sut]_seeds.tar.gz` containing for each abstract seed:
 - `[sut]_[seed]_client.length` number of inputs sent
 - `[sut]_[seed]_client.raw` the concretize inputs sequence
 - `[sut]_[seed]_client.replay` the concretize inputs sequence where each input is preceded by its size on 4 bytes (little endian)
 - `[sut]_[seed]_server.length` number of outputs received
 - `[sut]_[seed]_server.raw` the concretize outputs sequence
 - `[sut]_[seed]_server.replay` the concretize outputs sequence where each output is preceded by its size on 4 bytes (little endian)



### Concretize traces from an automata

To concretize a set of traces from an automata modeling a SUT, use the script:
```shell
./df_concretize_automata.sh <sut> <conf_file> <dot_file> <out_dir>
```
Where:
 - `sut` is the codename of the SUT used in `setup_sut.sh`
 - `conf_file` is the path to the configuration file in the folder `args`
 - `dot_file` is the path to the file describing the automata (produced by DTLS-Fuzzer)
 - `out_dir` is the folder to store the output

#### Example:
TODO
#### Results:
TODO
