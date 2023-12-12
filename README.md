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
Sample terminal log from executable binary. 
```
quote size = 4600
DCAP generate quote successfully
{
  "Type": 3,
  "Attributes": 7,
  "MrEnclaveHex": "C31CB24487E2AC394DA9F5388F2CBC4E895AE1350D9A845806B663E5830B6B49",
  "MrSignerHex": "83D719E77DEACA1470F6BAF62A4D774303C899DB69020F9C70EE1DFC08C7CE9E",
  "ProductIdHex": "00000000000000000000000000000000",
  "SecurityVersion": 0,
  "Attributes": 7,
  "EnclaveHeldDataHex": "010203040506"
}
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
Sample terminal log from the executable binary.
```
EGo v1.4.0 (7af5647641a966a762c025b0389b7995f5e53062)
[erthost] loading enclave ...
[erthost] entering enclave ...
[ego] starting application ...
quote size = 4616
DCAP generate quote successfully
{
  "Type": 3,
  "Attributes": 0,
  "MrEnclaveHex": "96EE199DBA986FB14CC9AFFA00000000",
  "MrSignerHex": "F79C4CA9940A0DB3957F060783C12521",
  "ProductIdHex": "03000200000000000A000F00939A7233",
  "SecurityVersion": 1,
  "Attributes": 0,
  "EnclaveHeldDataHex": "4C8068D396095D3B1E2260E6BF813BD8CE5DEDB92921A7AF06EC8915AC59F3F8"
}
Cleaning up generated files...
Cleanup completed.
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
Sample terminal log from the executable binary.
```
Gramine is starting. Parsing TOML manifest file, this may take some time...
-----------------------------------------------------------------------------------------------------------------------
Gramine detected the following insecure configurations:

  - sgx.debug = true                           (this is a debug enclave)

Gramine will continue application execution, but this configuration must not be used in production!
-----------------------------------------------------------------------------------------------------------------------

/dev/attestation/quote exists and is readable
ATTRIBUTES.FLAGS: 07
ATTRIBUTES.XFRM: 0700000000000000
MRENCLAVE: 37cc5babda8ee16b296fa4e71aa23e529c5ac5c5a073f341556224cfe6994f05
MRSIGNER: d312b93d55e5992d5e78edaff9df7a66b9eb4a47a250cc42bed6dc10a123034d
ISVPRODID: 0000
ISVSVN: 0000
REPORTDATA: 736f6d652d64756d6d792d646174610000000000000000000000000000000000
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
