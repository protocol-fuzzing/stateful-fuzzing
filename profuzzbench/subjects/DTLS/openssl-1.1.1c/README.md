Please carefully read the [main README.md](../../../README.md), which is stored in the benchmark's root folder, before following this subject-specific guideline.

# Fuzzing OpenSSL 1.1.1c server with AFLNet, AFLnwe and AFL-ML
Please follow the steps below to run and collect experimental results for OpenSSL.

## Step-1. Build a docker image
The following commands create a docker image tagged OpenSSL. The image should have everything available for fuzzing and code coverage calculation.

```bash
cd $PFBENCH
cd subjects/DTLS/openssl-1.1.1c
docker build . -t profuzz-openssl-1.1.1c
```

## Step-2. Run fuzzing
The following commands run 4 instances of AFLNet and 4 instances of AFL-ML to simultaenously fuzz OpenSSL in 60 minutes.

```bash
cd $PFBENCH
source profuzz-init.sh
mkdir results-openssl-1.1.1c

profuzzbench_exec_common.sh profuzz-openssl-1.1.1c 4 results-openssl-1.1.1c aflnet out-openssl-aflnet "-P DTLS12 -D 10000 -q 3 -s 3 -E -K -R -W 40 -m none -t 1000+" 3600 5 &
profuzzbench_exec_common.sh profuzz-openssl-1.1.1c 4 results-openssl-1.1.1c aflml out-openssl-aflml "-P DTLS12 -D 10000 -q 3 -s 3 -E -K -R -W 40 -m none -t 1000+" 3600 5
```

<!--
## Step-3. Collect the results
The following commands collect the  code coverage results produced by AFLNet and AFL-ML and save them to results.csv.

```bash
cd $PFBENCH/results-openssl-1.1.1c

profuzzbench_generate_csv.sh openssl-1.1.1c 4 aflnet results.csv 0
profuzzbench_generate_csv.sh openssl-1.1.1c 4 aflml results.csv 1
```

## Step-4. Analyze the results
The results collected in step 3 (i.e., results.csv) can be used for plotting. Use the following command to plot the coverage over time and save it to a file.

```
cd $PFBENCH/results-openssl-1.1.1c

profuzzbench_plot.py -i results.csv -p openssl-1.1.1c -r 4 -c 60 -s 1 -o cov_over_time.png
```
-->
