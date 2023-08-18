# Stateful Fuzzing

This project regroups some tools for the fuzzing of communication protocol with state-aware approach.
The technique used here consists in two steps:
 - first an automata representing the SUT (System Under Test) is learned,
 - then this model is used to drive the fuzzing.

Each stage is performed inside a controlled environment i.e. a docker container.
Thus we can ensure some consistency between the two steps, and hopefully produce better results.

The only protocol supported so far is DTLS.

The learning step is carried out by [DTLS-Fuzzer](https://github.com/assist-project/dtls-fuzzer).
The fuzzing can be carried out by the following fuzzers (for comparison):
 - [AFLNet](https://github.com/aflnet/aflnet)
 - [StateAFL](https://github.com/stateafl/stateafl)
 - [AFL-ML](https://github.com/remiparrot/aflnet), which is the one using the learned automata

The fuzzing step is integrated in an extension of [ProFuzzBench](https://github.com/profuzzbench/profuzzbench).


## Workflow

0. Build the docker for DTLS-Fuzzer

Run:
```sh
cd dtls-fuzzer
docker build -t dtls-fuzzer .
```
See [dtls-fuzzer/README.md](https://github.com/remiparrot/stateful-fuzzing/blob/main/dtls-fuzzer/README.md) for more informations.

### To fuzz with AFLNet or StateAFL

1. Produce some seeds

Use the script `df_concretize_seeds.sh`, in the subfolder `dtls-fuzzer`.
See [dtls-fuzzer/README.md](https://github.com/remiparrot/stateful-fuzzing/blob/main/dtls-fuzzer/README.md) for more informations.

2. Copy the seeds in the fuzzing docker

For AFLNet, copy the files `*.raw` from the concretized seeds folder to the corresponding folder in ProFuzzBench: `profuzzbench/subjects/DTLS/[SUT]/in-dtls/`.
Build the docker of the target SUT:
```sh
cd profuzzbench/subjects/DTLS/[SUT]/
docker build -t profuzz-[SUT] .
```
Then for StateAFL, copy the files `*.replay` from the concretized seeds folder to the corresponding folder in ProFuzzBench: `profuzzbench/subjects/DTLS/[SUT]/in-dtls-replay/`.
Build the docker of the target SUT:
```sh
cd profuzzbench/subjects/DTLS/[SUT]/
docker build -t profuzz-[SUT]-stateafl . -f Dockerfile-stateafl
```

3. Run the fuzzing

Use the script of ProFuzzBench to run the fuzzing, for example:
```sh
cd profuzzbench
source profuzz-init.sh
profuzzbench_exec_common.sh profuzz-openssl-1.1.1 4 results-openssl-1.1.1/20230629/ aflnet out-openssl-aflnet "-P DTLS12 -D 10000 -q 3 -s 3 -E -K -R -W 20 -m none -t 1000+" 172800 5
```
See [profuzzbench/README.md](https://github.com/remiparrot/stateful-fuzzing/blob/main/profuzzbench/README.md) for more informations.

### To fuzz with AFL-ML

1. Learn the automata

Use the script `df_learn_automata.sh`, in the subfolder `dtls-fuzzer`.
See [dtls-fuzzer/README.md](https://github.com/remiparrot/stateful-fuzzing/blob/main/dtls-fuzzer/README.md) for more informations.

2. Concretize seeds from the automata

Use the script `df_concretize_automata_seeds.sh`, in the subfolder `dtls-fuzzer`.
See [dtls-fuzzer/README.md](https://github.com/remiparrot/stateful-fuzzing/blob/main/dtls-fuzzer/README.md) for more informations.

3. Copy the seeds in the fuzzing docker

Copy the files `*.replay` and `*.length` from the concretized seeds folder to the corresponding folder in ProFuzzBench: `profuzzbench/subjects/DTLS/[SUT]/in-dtls-aflml/`.
Build the docker of the target SUT:
```sh
cd profuzzbench/subjects/DTLS/[SUT]/
docker build -t profuzz-[SUT] . -f Dockerfile
```

4. Run the fuzzing

Use the script of ProFuzzBench to run the fuzzing, for example:
```sh
cd profuzzbench
source profuzz-init.sh
profuzzbench_exec_common.sh profuzz-etinydtls 4 results-etinydtls/20230704/ aflml out-etinydtls-aflml "-P DTLS12 -D 10000 -q 3 -s 3 -E -K -R -W 30 -m none -t 1000+" 172800 5
```
See [profuzzbench/README.md](https://github.com/remiparrot/stateful-fuzzing/blob/main/profuzzbench/README.md) for more informations.
