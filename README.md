# BenchMarking

This repo serves benchmarking scripts to measure the boot time of SGX frameworks: Occlum, Ego and Gramine.
Follow the Environment setup below before running the benchmark test.

## Environment

I used an Azure Confidential Computing Machine - a simple Standard_DC1s_v2 Linux, Ubtuntu 20.04, Intel SGX (x86)
You can follow this [guide](https://learn.microsoft.com/en-us/azure/confidential-computing/quick-create-marketplace).

Alternatively, you can follow the Quick start guide from either [Occlum](https://occlum.readthedocs.io/en/latest/quickstart.html), [Ego](https://docs.edgeless.systems/ego/) or [Gramine](https://gramine.readthedocs.io/en/latest/installation.html)

Please follow the installation files for each framework. For Occlum and Gramine I used their docker images and for Ego I used snap. 

### Prerequisites

- Ubuntu 20.04
- Intel SGX enabled machine
- Docker
- DCAP installed and working - I used the [MS Azure Cloud Dcap installation](https://hub.docker.com/r/gramineproject/gramine)

## Run benchmark

This benchmarking test is designed to simply measure the boot time of a helloworld binary executed within an enclave for each framework. Each binary contains code to generate the enclave quote used to intiate the process of remote attestation. The test is done over 10 iterations for each framework.
**Note:** For Gramine, I found it to be super fast so I included two measurements, one for boot time and another for build + boot time.

### Occlum test

1. Navigate to occlum directory
`cd occlum`

2. Run test script 
`./occlum_run_bench_mark.sh`


Expect the results of the test to be logged to the terminal or they can be viewed in a "results.txt" file. 

eg.
```bash
Boot Time Results for running 10 Hello World quoting binaries in Occlum enclave..

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
Boot Time Results for running 10 Hello World quoting binaries in EGo enclave..

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
### Gramine test

1. Navigate to occlum directory
`cd gramine`

2. Run test script 
`./gramine_run_bench_mark.sh`

eg.
```bash
Boot time and build time results for running 10 HelloWorld quoting binaries in Gramine enclave..
Iteration | Build & Enclave Boot Time (seconds) | Enclave Boot Time (seconds)

1 | .913732542 | .526210653
2 | .906079580 | .527364505
3 | .916404341 | .550026647
4 | .921755098 | .510736129
5 | .953999340 | .510665528
6 | .922724108 | .508646407
7 | .947686373 | .540922850
8 | .901417779 | .526615696
9 | .890110658 | .522344450
10 | .921677893 | .518024004

Average | .91955877120000000000 | .52415568690000000000
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
