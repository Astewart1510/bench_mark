#!/bin/bash


cleanup_docker_containers() {
    echo "Cleaning up all Docker containers..."
    # Stop all running containers
    docker stop $(docker ps -aq)
    # Remove all containers
    docker rm $(docker ps -aq)
    echo "All Docker containers have been removed."
}

CONTAINER_NAME="occlum_benchmark_test_FINAL_3"
# Define the Occlum Docker image
OCCLUM_IMAGE="occlum/occlum:0.30.0-ubuntu20.04"

# Path to occulum app
OCClUM_APP="../occlum"

# Create softlinks for SGX devices on the host
mkdir -p /dev/sgx
sudo ln -sf /dev/sgx_enclave /dev/sgx/enclave
sudo ln -sf /dev/sgx_provision /dev/sgx/provision

# Start the Occlum Docker container in privileged mode
docker run -itd --privileged -v /dev/sgx:/dev/sgx  --name $CONTAINER_NAME $OCCLUM_IMAGE

# Make executable and then copy files into container
chmod +x docker_occulum_benchmark.sh
docker cp $OCClUM_APP $CONTAINER_NAME:/home

echo "Setup completed successfully...."
echo ""
# Execute occlum docker scripts
echo "Execute docker script to start benchmark"
docker exec -it $CONTAINER_NAME /bin/bash -c "cd /home/occlum && ./docker_occulum_benchmark.sh"
docker cp $CONTAINER_NAME:/home/occlum/occlum_instance/occlum_results.txt ./occlum_results.txt

# Cleanup Docker containers
cleanup_docker_containers

# Display Boot Time results
cat ./occlum_results.txt
