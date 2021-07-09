# The default path for the job is your home directory, so we change directory to where the files are.
cd /
# JOB_ID=`basename ${0} | cut -f1 -d"."`
OUTPUT_FILE=$1
DEVICE=$2
API=$3
MODELNAME=$4
# Benchmark Application script writes output to a file inside a directory. We make sure that this directory exists.
#  The output directory is the first argument of the bash script
mkdir -p $OUTPUT_FILE/${MODELNAME}_docker

if [ "$DEVICE" = "MYRIAD" ] || [ "$DEVICE" = "HDDL" ] || [ "$DEVICE" = "MULTI:HDDL,CPU" ] || [ "$DEVICE" = "MULTI:CPU,GPU" ]; then
    FP_MODEL="FP16"
else
    FP_MODEL="FP32"
fi

SAMPLEPATH="/"

mkdir -p ${OUTPUT_FILE}
# rm -f ${OUTPUT_FILE}/*

echo /${OUTPUT_FILE}/${MODELNAME}_docker > ${MODELNAME}_benchmark.txt

# Running the benchmark application code

python3 /opt/intel/openvino/deployment_tools/tools/benchmark_tool/benchmark_app.py -m /onnx_wgts/${FP_MODEL}/${MODELNAME}/${MODELNAME}.xml \
            -d $DEVICE \
            -niter 10 \
            -api $API \
            -nireq 32\
            --report_type detailed_counters \
            --report_folder /${OUTPUT_FILE}/${MODELNAME}_docker