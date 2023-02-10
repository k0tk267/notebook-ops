source .env

input_file_name=$1
output_file_name=$2
message=${output_file_name%.*}
time_stamp=$(date "+%Y-%m-%dT%H:%M:%S")

command="
    poetry run papermill \
    ${PROJECT_PATH}/src/notebooks/$input_file_name \
    ${PROJECT_PATH}/results/notebooks/${time_stamp}_$output_file_name \
    -p MAX_TOKEN_LENGTH 512 \
    -p BATCH_SIZE_TRAIN 32 \
    -p BATCH_SIZE_VALID 32 \
    -p BATCH_SIZE_TEST 32 \
    -p EPOCHS 10000 \
    -p PATIENCE 100 \
    -p GPU_NUM 1 \
    -p TIME_STAMP $time_stamp \
    -p MESSAGE $message \
    --request-save-on-cell-execute \
    --prepare-execute \
    --log-output \
    --progress-bar
"

eval ${command}