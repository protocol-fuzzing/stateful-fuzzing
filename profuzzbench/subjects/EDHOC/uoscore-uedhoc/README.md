Please carefully read the [main README.md](../../../README.md), which is stored in the benchmark's root folder, before following this subject-specific guideline.

# Fuzzing uoscore-uedhoc server with AFLNet and AFLnwe
Please follow the steps below to run and collect experimental results for uoscore-uedhoc.

## Step-1. Build a docker image
The following commands create a docker image tagged uoscore-uedhoc. The image should have everything available for fuzzing and code coverage calculation.

```bash
cd $PFBENCH
cd subjects/EDHOC/uoscore-uedhoc
docker build . -t uoscore-uedhoc
```

## Step-2. Run fuzzing
The following commands run 4 instances of AFLNet and 4 instances of AFLnwe to simultaenously fuzz uoscore-uedhoc in 60 minutes.

```bash
cd $PFBENCH
mkdir results-uoscore-uedhoc

profuzzbench_exec_common.sh uoscore-uedhoc 4 results-uoscore-uedhoc aflnet out-uoscore-uedhoc-aflnet "-P COAP -m none -D 50000 -q 3 -s 3 -R -E -K -W 10" 3600 5 &
profuzzbench_exec_common.sh uoscore-uedhoc 4 results-uoscore-uedhoc aflnwe out-uoscore-uedhoc-aflnwe "-D 50000 -K -W 10" 3600 5
```

## Step-3. Collect the results
The following commands collect the  code coverage results produced by AFLNet and AFLnwe and save them to results.csv.

```bash
cd $PFBENCH/results-uoscore-uedhoc

profuzzbench_generate_csv.sh uoscore-uedhoc 4 aflnet results.csv 0
profuzzbench_generate_csv.sh uoscore-uedhoc 4 aflnwe results.csv 1
```

## Step-4. Analyze the results
The results collected in step 3 (i.e., results.csv) can be used for plotting. Use the following command to plot the coverage over time and save it to a file.

```
cd $PFBENCH/results-uoscore-uedhoc

profuzzbench_plot.py -i results.csv -p uoscore-uedhoc -r 4 -c 60 -s 1 -o cov_over_time.png
```
