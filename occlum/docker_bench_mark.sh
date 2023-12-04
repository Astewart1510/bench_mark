#!/bin/bash

# Step 1: Setup and Compile the Hello World program
apt-get update && apt-get install -y bc

cd /home
occlum-gcc -o hello_world hello_world.c

# Step 2: Initialize a new Occlum instance
occlum new occlum_instance
cd occlum_instance

# Step 3: Copy the Hello World program to the image
cp ../hello_world image/bin/

# Step 4: Build the Occlum environment
occlum build


# Prepare a file to store results.txt
RESULTS_FILE="/home/results.txt"
echo "Boot Time Results for running 10 Hello World binaries in Occlum enclave.." > $RESULTS_FILE
echo "" >> $RESULTS_FILE

# Run the program multiple times and measure boot time
for i in {1..10}
do
    start=$(date +%s.%N)
    occlum run /bin/hello_world
    end=$(date +%s.%N)
    runtime=$(echo "$end - $start" | bc)
    echo "$i $runtime" >> $RESULTS_FILE
done

echo "" >> $RESULTS_FILE
# Calculate and print the average boot time
total_time=$(awk '{sum += $2} END {print sum}' $RESULTS_FILE)
average_time=$(echo "$total_time / 10" | bc -l)
echo "Average boot time: $average_time seconds" >> $RESULTS_FILE

