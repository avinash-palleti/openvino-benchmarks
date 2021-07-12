FROM openvino/ubuntu20_runtime
FROM python:3.9.2
USER root
RUN pip install googledrivedownloader ipython
RUN pip install pandas
RUN mkdir /job_files
RUN mkdir /onnx_wgts
RUN mkdir /job_files/outputs/
RUN mkdir /onnx_wgts/FP32
RUN mkdir /onnx_wgts/FP16
ADD fp_convert.py /
ADD benchmark_app_job.sh /
CMD chmod +x benchmark_app_job.sh
CMD [ "python", "/fp_convert.py" ]
