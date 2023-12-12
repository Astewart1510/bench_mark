#!/bin/bash

# Prepare a file to store results
RESULTS_FILE="./gramine_results.txt"
echo -e "\nBoot time and build time results for running 10 HelloWorld quoting binaries in Gramine enclave.." >> $RESULTS_FILE
echo -e "Iteration | Build & Enclave Boot Time (seconds) | Enclave Boot Time (seconds)\n" >> $RESULTS_FILE

# Initialize variables for total times
total_build_exec_time=0
total_boot_time=0

# Run the program multiple times and measure build + Boot time and enclave boot time
for i in {1..10}
do
    make SGX=1 clean
    # Measure build and boot time
    start_build_exec=$(date +%s.%N)
    make SGX=1
    gramine-sgx helloworld
    end_build_exec=$(date +%s.%N)
    runtime_build_exec=$(echo "$end_build_exec - $start_build_exec" | bc)

    # Measure enclave boot time
    start_boot=$(date +%s.%N)
    gramine-sgx helloworld
    end_boot=$(date +%s.%N)
    runtime_boot=$(echo "$end_boot - $start_boot" | bc)

    # Append results to the file with column names
    echo "$i | $runtime_build_exec | $runtime_boot" >> $RESULTS_FILE

    # Accumulate times for averaging
    total_build_exec_time=$(echo "$total_build_exec_time + $runtime_build_exec" | bc -l)
    total_boot_time=$(echo "$total_boot_time + $runtime_boot" | bc -l)
done

# Calculate and print the average times
average_build_exec_time=$(echo "$total_build_exec_time / 10" | bc -l)
average_boot_time=$(echo "$total_boot_time / 10" | bc -l)

# Add average times to the results file
echo "" >> $RESULTS_FILE
echo "Average | $average_build_exec_time | $average_boot_time" >> $RESULTS_FILE

#clean up
make SGX=1 clean
# Display results
cat "$RESULTS_FILE"
