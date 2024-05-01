import matplotlib.pyplot as plt
import numpy as np
import os

# Function to extract IPC value from output.txt file
def extract_ipc(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line in lines:
            if line.startswith("IPC:"):
                ipc_value = float(line.split(":")[1])
                return ipc_value
    return None

# Directory containing the output folders
output_folder_path = "/home/george/Workshop/uni/8sem/archlab/ex1/ex7_2/output_files"

# List of folder names representing different CPUs
cpu_folders = [
    "blackscholes_outputs",
    "fluidanimate_outputs",
    "streamcluster_outputs",
    "bodytrack_outputs",
    "freqmine_outputs",
    "swaptions_outputs",
    "canneal_outputs",
    "rtview_outputs"
]

# List to store IPC values for each CPU
cpu_ipc_values = {}
number_of_tests = 0

# Iterate through each CPU folder
for cpu_folder in cpu_folders:
    cpu_type = cpu_folder.split("_")[0].capitalize()
    ipc_values_test = []
    # Iterate through each output.txt file in the CPU folder
    for j in range(14):  
        if (j==2 or j==5 or j==8 or j==11):
        	#ipc = 0
        	#ipc_values_test.append(ipc)
        	continue
        output_file_path = os.path.join(output_folder_path, cpu_folder, f"output_{j}.txt")
        number_of_tests+=1
        ipc = extract_ipc(output_file_path)
        ipc_values_test.append(ipc)
    cpu_ipc_values[cpu_type] = ipc_values_test

# Calculate geometric mean for each test
geometric_means = []
for i in range(10):
    ipc_values_at_index = [cpu_ipc_values[cpu_type][i] for cpu_type in cpu_ipc_values]
    geometric_mean = np.prod(ipc_values_at_index) ** (1/len(ipc_values_at_index))
    geometric_means.append(geometric_mean)

# Plotting geometric means
plt.figure(figsize=(10, 6))
plt.plot(range(1, 11), geometric_means, marker='o', color='blue')
plt.title('Geometric Mean of IPC Values of all benchmarks for Different Tests')
plt.xlabel('Test')
plt.ylabel('Geometric Mean of IPC')
plt.xticks(range(1, 11))
plt.grid(True)
plt.show()

# Plotting
plt.figure(figsize=(10, 6))
for cpu_type, ipc_values in cpu_ipc_values.items():
    max_ipc_value = max(ipc_values)
    max_test_index = ipc_values.index(max_ipc_value) + 1
    plt.plot(range(1, 11), ipc_values, label=cpu_type)
    plt.scatter(max_test_index, max_ipc_value, color='red', marker='o')  # Marking max IPC
    

plt.title('IPC Values for Different CPUs')
plt.xlabel('Test')
plt.ylabel('IPC')
plt.xticks(range(1, 11))
plt.legend()
plt.grid(True)
plt.show()

