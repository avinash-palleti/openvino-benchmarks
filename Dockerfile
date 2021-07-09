FROM openvino/ubuntu20_runtime
RUN pip install googledrivedownloader
RUN pip install pandas
RUN pip install progress
RUN mkdir -p /job_files/outputs/
RUN mkdir -p /onnx_wgts/FP32
RUN mkdir -p /onnx_wgts/FP16
ADD fp_convert.py /
ADD benchmark_app_job.sh /
CMD chmod +x benchmark_app_job.sh
CMD [ "python", "/fp_convert.py" ]
