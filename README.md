# openvino-benchmarks
Dockerfile for running the benchmark scripts on OpenVINO

## How to
1. build the container
2. run the following command to run the container and transfer the experiment data to the local pc.
```bash
docker container run -v <current folder where you want to transfer>:/job_files/outputs/ <container-name> 
```