# EDHOC-Fuzzer docker

This project aims at embedding [EDHOC-Fuzzer](https://github.com/protocol-fuzzing/edhoc-fuzzer) into a stable and controllable environment, i.e. a docker container.
The main benefit is that the SUTs (Systems Under Test) processed with EDHOC-Fuzzer can after be fuzzed/tested by other tools under the same conditions.

Three scripts are available to do the following three operations:
 - learn SUTs (Systems Under Test)
 - concretize abstract input sequences
 - extract abstract input traces from an automata (transition cover) and concretize them


## Install

To build the Docker container run:
```sh
docker build -t edhoc-fuzzer .
```
*Warning*: The container should be named `edhoc-fuzzer`. If not the scripts called `df_[..].sh` should be modified accordingly.

It will install all the dependencies for EDHOC-Fuzzer and the SUTs.
The configuration files in the folder `args` are added to EDHOC-Fuzzer. 
All the test-cases in the `examples/tests` are added to EDHOC-Fuzzer.


## Usage

In the following, we refer as *seed* for a sequence of inputs/outputs.
An *abstract seed* is a sequence of letter from the abstract alphabet defined in EDHOC-Fuzzer.
A *real seed* is the concretization of an abstract seed during a communication with a real SUT.
We record both the second of *inputs* and the sequence of *outputs* during a communication with the SUT.


### Learn an automata model of an SUT

To learn an automata modelling a SUT, use the script
```sh
./df_learn_automata.sh <sut> <conf_file> <out_dir> [options]
```
Where:
 - `sut` is the codename of the SUT used in `setup_sut.sh`
 - `conf_file` is the path to the configuration file in the folder `args`
 - `out_dir` is the folder to store the output
 - `options`[optional] additional options for EDHOC-Fuzzer (between quotes)

#### Example:
```sh
./df_learn_automata.sh uoscore-uedhoc args/uoscore-uedhoc/server_linux_edhoc_oscore results-learning/
```

#### Results:
A compressed archive named `[conf_file].tar.gz` containing the output of EDHOC-Fuzzer



### Concretize a set of abstract seeds

To concretize a set of abstract seeds, use the script:
```sh
./df_concretize_seeds.sh <sut> <abstract_seeds> <conf_file> <out_dir>
```
Where:
 - `sut` is the codename of the SUT used in `setup_sut.sh`
 - `abstract_seeds` is the list (between quotes and separated with a space) of abstract seeds from the folder `examples/tests` to concretize
 - `conf_file` is the path to the configuration file in the folder `args`
 - `out_dir` is the folder to store the output

#### Example:
```sh
./df_concretize_seeds.sh uoscore-uedhoc "m1_m3" args/uoscore-uedhoc/server_linux_edhoc_oscore results-seeds/
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
```sh
./df_concretize_automata.sh <sut> <conf_file> <dot_file> <out_dir>
```
Where:
 - `sut` is the codename of the SUT used in `setup_sut.sh`
 - `conf_file` is the path to the configuration file in the folder `args`
 - `dot_file` is the path to the file describing the automata (produced by EDHOC-Fuzzer)
 - `out_dir` is the folder to store the output

#### Example:
```sh
./df_concretize_automata.sh uoscore-uedhoc args/uoscore-uedhoc/server_linux_edhoc_oscore results-learning/learn_uoscore-uedhoc/learnedModel.dot results-automata-seeds/
```

#### Results:
A compressed archive named `[sut]_automata_seeds.tar.gz` containing a set of seeds.

The set of abstract seeds is produced from the automata, as followed:
1. First, a transition cover $Cov$ is computed, i.e. a set of traces $\rho=i_1 \dots i_n$ covering all the transitions of the automata. This transition cover is *minimal* in that sense: there are no traces $\rho,\rho'\in Cov$ such that $\rho$ is the prefix of $\rho'$.
2. Then, we defined the set $`S=\{(\rho,k) \mid \rho=i_1 \dots i_n \in Cov \text{ and } k \in [1 .. n]\}`$. A couple $(\rho,k)$ with $\rho=i_1 \dots i_n$ defined a prefix $i_1 \dots i_k$ and a suffix $i_{k+1} \dots i_n$.
3. Finally a subset $S_m \subseteq S$ is defined such that it nevers contain the same prefix twice: $\forall (\rho,k), (\rho',k') \in S_m$, if $\rho=i_1 \dots i_n$ and $`\rho'=i'_1 \dots i'_{n'}`$, then $`i_1 \dots i_k \neq i'_1 \dots i'_{k'}`$.

Note that the three sets $Cov$, $S$ and $S_m$ are not unique, we compute only ones of them.

A seed in that case is a couple $(\rho, k)$.
Each seed is then concretized, and we end up with the following files:
 - `seed_[xxxx].length` size of the prefix (value of $k$)
 - `seed_[xxxx].abstra` the absract inputs sequence $\rho$
 - `seed_[xxxx].raw` the concretize inputs sequence $\rho$
 - `seed_[xxxx].replay` the concretize inputs sequence $\rho$ where each input is preceded by its size on 4 bytes (little endian)
 - `seed_[xxxx].total_length` size of the complete input sequence $\rho$ (value of $n$)

