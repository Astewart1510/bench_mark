#!/bin/bash
cleanup_files() {
    echo "Cleaning up generated files..."
    rm -f main private.pem public.pem
    echo "Cleanup completed."
}
# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Check if Go is installed
if ! command_exists go; then
    echo "Go is not installed. Please install Go."
    exit 1
fi

# Check if EGo is installed
if ! command_exists ego-go || ! command_exists ego; then
    echo "EGo is not installed. Please install EGo."
    exit 1
fi

#build and sign
ego-go build main.go
ego sign main

# Prepare a file to store results
RESULTS_FILE="./results.txt"
echo "Boot Time Results for running 10 Hello World binaries in EGo enclave.." > $RESULTS_FILE
echo "" >> $RESULTS_FILE

# Run the program multiple times and measure boot time
for i in {1..10}
do
    start=$(date +%s.%N)
    ego run main
    end=$(date +%s.%N)
    runtime=$(echo "$end - $start" | bc)
    echo "$i $runtime" >> $RESULTS_FILE
done

echo "" >> $RESULTS_FILE
# Calculate and print the average boot time
total_time=$(awk '{sum += $2} END {print sum}' $RESULTS_FILE)
average_time=$(echo "$total_time / 10" | bc -l)
echo "Average boot time: $average_time seconds" >> $RESULTS_FILE

# Clean up files
cleanup_files

# Display results
cat "./results.txt"