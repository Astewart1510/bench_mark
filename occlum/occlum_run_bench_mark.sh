#!/bin/bash


cleanup_docker_containers() {
    echo "Cleaning up all Docker containers..."
    # Stop all running containers
    docker stop $(docker ps -aq)
    # Remove all containers
    docker rm $(docker ps -aq)
    echo "All Docker containers have been removed."
}

CONTAINER_NAME="occlum_benchmark_test"
# Define the Occlum Docker image
OCCLUM_IMAGE="occlum/occlum:0.30.0-ubuntu20.04"

# Path to hello_world.c file on the host
HELLO_WORLD_PATH="./hello_world.c"
# Path to docker executable script
DOCKER_EXEC="./docker_bench_mark.sh"

# Create softlinks for SGX devices on the host
mkdir -p /dev/sgx
sudo ln -sf /dev/sgx_enclave /dev/sgx/enclave
sudo ln -sf /dev/sgx_provision /dev/sgx/provision

# Start the Occlum Docker container in privileged mode
docker run -itd --privileged -v /dev/sgx:/dev/sgx --name $CONTAINER_NAME $OCCLUM_IMAGE

# Make executable and then copy files into container
chmod +x docker_bench_mark.sh
docker cp $HELLO_WORLD_PATH $CONTAINER_NAME:/home
docker cp $DOCKER_EXEC $CONTAINER_NAME:/home

# Modify Occlum.json configuration in the container
docker exec -it $CONTAINER_NAME /bin/bash -c "sed -i 's/\"default_heap_size\": \"[^\"]*\"/\"default_heap_size\": \"256MB\"/' /home/occlum_instance/Occlum.json"
docker exec -it $CONTAINER_NAME /bin/bash -c "sed -i 's/\"user_space_size\": \"[^\"]*\"/\"user_space_size\": \"300MB\"/' /home/occlum_instance/Occlum.json"

echo "Setup completed successfully...."
echo ""
# Execute occlum docker scripts
echo "Execute docker script to start benchmark"
docker exec -it $CONTAINER_NAME /bin/bash -c "cd /home && ./docker_bench_mark.sh"
docker cp $CONTAINER_NAME:/home/results.txt ./results.txt

# Cleanup Docker containers
cleanup_docker_containers

# Display Boot Time results
cat ./results.txt
