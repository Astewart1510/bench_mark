#!/bin/bash
set -e

BLUE='\033[1;34m'
NC='\033[0m'
INSTANCE_DIR="occlum_instance"
bomfile="../dcap.yaml"

# parameter 1 defines the predefined Occlum json
function build_and_run() {
    config=$1

    if [ ! -f $config ]; then
        echo "Please provide valid Occlum json file"
        exit -1
    fi

    rm -rf ${INSTANCE_DIR} && occlum new ${INSTANCE_DIR}
    pushd ${INSTANCE_DIR}

    rm -rf image
    copy_bom -f $bomfile --root image --include-dir /opt/occlum/etc/template
    cp ../$config Occlum.json
    occlum build

    echo -e "${BLUE}occlum run${NC}"
    
    # Prepare a file to store boot time results
    RESULTS_FILE="occlum_results.txt"
    echo "Boot Time Results for running 10 HelloWorld quoting binaries in Occlum enclave.." > $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    # Run the program multiple times and measure boot time
    for i in {1..10}
    do
        start=$(date +%s.%N)
        occlum run /bin/helloworld
        end=$(date +%s.%N)
        runtime=$(echo "$end - $start" | bc)
        echo "$i: $runtime seconds" >> $RESULTS_FILE
    done

    # Calculate and print the average boot time
    total_time=$(awk '{sum += $2} END {print sum}' $RESULTS_FILE)
    average_time=$(echo "scale=3; $total_time / 10" | bc)
    echo "" >> $RESULTS_FILE
    echo "Average boot time: $average_time seconds" >> $RESULTS_FILE

    popd
}
echo "*** Install Azure Driver in Container ***"
apt purge libsgx-dcap-default-qpl
echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/msprod.list
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
apt update
apt install az-dcap-client
apt-get update && apt-get install -y bc

echo "*** Build and run the code ***"
make -C helloworld clean
make -C helloworld

# Build and run with your desired Occlum JSON file
build_and_run ./config/Occlum.json
