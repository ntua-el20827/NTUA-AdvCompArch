#!/bin/bash

# Define constant values
L2c=2048
L2a=16
L2b=256
TLBe=64
TLBa=4
TLBp=4096

# Define tests configurations
tests=(
    "32 4 64"
    "32 8 64"
    "64 4 64"
    "64 8 64"
    "128 4 64"
)

# Create a directory for storing output files
output_dir="output_files/rtview_outputs"
mkdir -p "$output_dir"

# Run tests
for ((i=0; i<${#tests[@]}; ++i)); do
    test=${tests[$i]}
    IFS=' ' read -r L1c L1a L1b <<< "$test"

    # Run command and store output in a file
    output_file="$output_dir/output_$i.txt"
    /home/george/Workshop/uni/8sem/archlab/ex1/pin-3.30-98830-g1d7b601b3-gcc-linux/pin -t /home/george/Workshop/uni/8sem/archlab/ex1/parsec-3.0/advcomparch-ex1-helpcode/pintool/obj-intel64/simulator.so -o "$output_file" -L1c "$L1c" -L1a "$L1a" -L1b "$L1b" -L2c "$L2c" -L2a "$L2a" -L2b "$L2b" -TLBe "$TLBe" -TLBa "$TLBa" -TLBp "$TLBp" -- /home/george/Workshop/uni/8sem/archlab/ex1/parsec-3.0/parsec_workspace/executables/rtview /home/george/Workshop/uni/8sem/archlab/ex1/parsec-3.0/parsec_workspace/inputs/happy_buddha.obj -automove -nthreads 1 -frames 3 -res 1920 1080

    echo "Test $i completed. Output stored in $output_file"
done

# Find configuration with the highest IPC
max_ipc=0
max_ipc_config=""
for file in "$output_dir"/*.txt; do
    ipc=$(sed '6q;d' "$file" | awk '{print $2}')  # Adjusted to extract the value after "IPC:"
    if (( $(echo "$ipc > $max_ipc" | bc -l) )); then
        max_ipc=$ipc
        max_ipc_config=$(basename "$file")
    fi
done

# Print the values of the best configuration
best_config_index=$(echo "$max_ipc_config" | cut -d '_' -f 2 | cut -d '.' -f 1)
echo "Best configuration values: ${tests[$best_config_index]}"

# Save the best configuration to a file
echo "[RTVIEW] Best configuration: ${tests[$best_config_index]} with IPC $max_ipc" >> /home/george/Workshop/uni/8sem/archlab/ex1/ex7_5/best_configurations5.txt

echo "[RESULT] Configuration with the highest IPC for blackscholes is $max_ipc_config with IPC $max_ipc"

