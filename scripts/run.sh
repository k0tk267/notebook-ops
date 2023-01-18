source .env

input_file_name=$1
output_file_name=$2
batch_size=$3
epoch_size=$4
time_stamp=$(date "+%Y-%m-%dT%H:%M:%S")

command="
    poetry run papermill \
    ${PROJECT_PATH}/src/notebooks/$input_file_name \
    ${PROJECT_PATH}/data/results/notebooks/${time_stamp}_$output_file_name \
    -p BATCH_SIZE $batch_size \
    -p EPOCH $epoch_size \
    --request-save-on-cell-execute \
    --prepare-execute \
    --log-output \
    --progress-bar
"

eval ${command}