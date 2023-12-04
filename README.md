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
Boot Time Results for running 10 Hello World binaries in Occlum enclave..

1 2.370507250
2 2.192411428
3 2.190091903
4 2.161669690
5 2.159550050
6 2.156466418
7 2.208925764
8 2.180626320
9 2.153037844
10 2.230094036

Average boot time: 2.20034000000000000000 seconds
```

### Ego test

1. Navigate to occlum directory
`cd ego`

2. Run test script 
`./ego_run_bench_mark.sh`

eg.
```bash
Boot Time Results for running 10 Hello World binaries in EGo enclave..

1 2.098878703
2 2.067205426
3 2.105139744
4 2.104138933
5 2.049242979
6 2.097399793
7 2.111776959
8 2.117838413
9 2.077859055
10 2.116631498

Average boot time: 2.09461000000000000000 seconds
```


## Memory Allocation: Occlum vs. EGo

### Occlum Configuration

In Occlum, memory allocation is static. For our benchmarks, I set:
```
user_space_size: 300MB
default_heap_size: 256MB
```
These settings in `Occlum.json` define the total user space and default heap size for processes.

### EGo Configuration

EGo dynamically manages memory. I aligned its heap size with Occlum by setting heapSize to `256MB` in `enclave.json`.

### Benchmarking Approach

To ensure fair comparison, both frameworks were configured with a 256MB heap size. This alignment focuses the benchmark on performance under similar memory constraints.
