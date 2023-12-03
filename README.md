# BenchMarking

This repo serves benchmarking scripts to measure the boot time of SGX frameworks: Occlum and Ego.
Follow the Environment setup below before running the benchmark test.

## Environment

I used an Azure Confidential Computing Machine - a simple Standard_DC1s_v2 Linux, Ubtuntu 20.04, Intel SGX (x86)
You can follow this [guide](https://learn.microsoft.com/en-us/azure/confidential-computing/quick-create-marketplace).

Alternatively, you can follow the Quick start guide from either [Occlum](https://occlum.readthedocs.io/en/latest/quickstart.html) or [Ego](https://docs.edgeless.systems/ego/).

### Prerequisites

- Ubuntu 20.04
- Intel SGX enabled machine
- Docker

## Run benchmark

This benchmarking test is designed to simply measure the boot time of a hello world binary executed within an enclave for each framework. The test is done over 10 iterations for each framework. 

### Occlum test

1. Navigate to occlum directory
`cd occlum`

2. Run test script 
`./occlum_run_bench_mark.sh`

Expect the results of the test to be logged to the terminal or they can be viewed in a "results.txt" file. 

eg.
```bash
Boot Time Results for running 10 Hello World binaries..

1 2.860983086
2 2.244129000
3 2.199010215
4 2.197258127
5 2.306564250
6 2.376046991
7 2.368860547
8 2.361805866
9 2.297390455
10 2.216734941

Average boot time: 2.34288000000000000000 seconds
```

