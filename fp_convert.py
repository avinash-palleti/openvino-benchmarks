from IPython.display import HTML
import os
import time
import sys                                                     
from openvino.inference_engine import IECore
import cv2
import pandas as pd
from qarpo.model_visualizer_link import *
import glob
from google_drive_downloader import GoogleDriveDownloader as gdd
import subprocess

gdd.download_file_from_google_drive(file_id='1ofz5FcjIBZXvGYazU-PmPz7yhlUv9vEU',
                                    dest_path='/onnx_wgts.zip',
                                    unzip=True)

modelnames = glob.glob("/onnx_wgts/*.onnx", recursive=True)
models = []

for m in modelnames:
    models.append(m.split('/')[-1].split('.')[-2])
    
for m in models:
    print(m)

for m in modelnames:
    if m != '/onnx_wgts/nvidia_ssd.onnx':
        # FP16 IR generation
        !mo.py \
        --input_model {m} \
        --input_shape=[1,3,224,224] \
        --mean_values=[0.485,0.456,0.406] \
        -o onnx_wgts/FP16/{m.split('/')[-1].split('.')[-2]} \
        --data_type FP16
        # FP32 IR generation
        !mo.py \
        --input_model {m} \
        --input_shape=[1,3,224,224] \
        --mean_values=[0.485,0.456,0.406] \
        -o onnx_wgts/FP32/{m.split('/')[-1].split('.')[-2]} \
        --data_type FP32
    else:
        # mean values for NVIDIA SSD unknown, will try finding them later.
        # FP16 IR generation
        !mo.py \
        --input_model {m} \
        --input_shape=[1,3,300,300] \
        --mean_values=[0.485,0.456,0.406] \
        -o onnx_wgts/FP16/{m.split('/')[-1].split('.')[-2]} \
        --data_type FP16
        # FP32 IR generation
        !mo.py \
        --input_model {m} \
        --input_shape=[1,3,300,300] \
        --mean_values=[0.485,0.456,0.406] \
        -o onnx_wgts/FP32/{m.split('/')[-1].split('.')[-2]} \
        --data_type FP32

for md in models:
    print("{} benchmarking started.".format(md))
    subprocess.run(["/benchmark_app_job.sh", "job_files/outputs/ CPU async {md}"], shell=True)
    print("{} benchmarking done.".format(md))
