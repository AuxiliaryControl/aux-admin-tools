import torch
import time

# Configuration: 30,000 x 30,000 matrix
# Memory math: 30k * 30k * 4 bytes (float32) = ~3.6 GB per matrix
# We create 3 matrices (A, B, Result) = ~10.8 GB VRAM Usage
# We do this 100 times to sustain load
N = 30000
LOOP_COUNT = 100

print(f"Initializing Stress Test on {torch.cuda.get_device_name(0)}...")
print(f"Allocating Tensors ({N}x{N})... this may take a moment.")

# Allocate to GPU
x = torch.randn(N, N, device='cuda')
y = torch.randn(N, N, device='cuda')

print("Starting Matrix Multiplication Loop. Watch your nvidia-smi window!")
start_time = time.time()

for i in range(LOOP_COUNT):
    # The heavy lifting
    torch.matmul(x, y)
    
    # Force CUDA to finish (async otherwise)
    torch.cuda.synchronize()

    if i % 10 == 0:
        print(f" Batch {i}/{LOOP_COUNT} complete...")

end_time = time.time()
duration = end_time - start_time

print(f"DONE. Completed {LOOP_COUNT} iterations in {duration:.2f} seconds.")

# Log to vault
with open('/vault/stress_results.txt', 'w') as f:
    f.write(f"Stress Test Passed. \nDevice: {torch.cuda.get_device_name(0)}\nDuration: {duration:.2f}s\n")
