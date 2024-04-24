#!/bin/bash

# Define constant values
L1c=128
L1a=8
L1b=128
L2c=2048
L2a=16
L2b=256

# Define tests configurations
tests=(
    "32 4 4096"
    "32 8 4096"
    "64 1 4096"
    "64 2 4096"
    "64 4 4096"
    "64 8 4096"
    "64 16 4096"
    "64 32 4096"
    "64 64 4096"
    "128 4 4096"
    "256 4 4096"
)


# Create a directory for storing output files
output_dir="output_files/bodytrack_outputs"
mkdir -p "$output_dir"

# Run tests
for ((i=0; i<${#tests[@]}; ++i)); do
    test=${tests[$i]}
    IFS=' ' read -r TLBe TLBa TLBp <<< "$test"

    # Run command and store output in a file
    output_file="$output_dir/output_$i.txt"
    /home/george/Workshop/uni/8sem/archlab/ex1/pin-3.30-98830-g1d7b601b3-gcc-linux/pin -t /home/george/Workshop/uni/8sem/archlab/ex1/parsec-3.0/advcomparch-ex1-helpcode/pintool/obj-intel64/simulator.so -o "$output_file" -L1c "$L1c" -L1a "$L1a" -L1b "$L1b" -L2c "$L2c" -L2a "$L2a" -L2b "$L2b" -TLBe "$TLBe" -TLBa "$TLBa" -TLBp "$TLBp" -- /home/george/Workshop/uni/8sem/archlab/ex1/parsec-3.0/parsec_workspace/executables/bodytrack /home/george/Workshop/uni/8sem/archlab/ex1/parsec-3.0/parsec_workspace/inputs/sequenceB_4 4 4 4000 5 0 1


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
echo "[BODYTRACK] Best configuration: ${tests[$best_config_index]} with IPC $max_ipc" >> /home/george/Workshop/uni/8sem/archlab/ex1/ex7_3/best_configurations3.txt

echo "[RESULT] Configuration with the highest IPC for blackscholes is $max_ipc_config with IPC $max_ipc"

