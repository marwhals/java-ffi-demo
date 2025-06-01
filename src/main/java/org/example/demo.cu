#include <iostream>
#include <cstdlib>
#include <ctime>

#define N 1024  // Matrix size (NxN)

// CUDA Kernel for matrix addition
__global__ void matrixAdd(int *A, int *B, int *C, int N) {
    // Calculate the index of the thread
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    // Ensure we stay within bounds
    if (row < N && col < N) {
        int index = row * N + col;
        C[index] = A[index] + B[index];
    }
}

int main() {
    int *h_A, *h_B, *h_C;  // Host matrices
    int *d_A, *d_B, *d_C;  // Device matrices

    // Allocate memory for matrices on the host
    h_A = (int*)malloc(N * N * sizeof(int));
    h_B = (int*)malloc(N * N * sizeof(int));
    h_C = (int*)malloc(N * N * sizeof(int));

    // Initialize matrices with random values
    srand(time(0));
    for (int i = 0; i < N * N; i++) {
        h_A[i] = rand() % 100;
        h_B[i] = rand() % 100;
    }

    // Allocate memory for matrices on the device (GPU)
    cudaMalloc((void**)&d_A, N * N * sizeof(int));
    cudaMalloc((void**)&d_B, N * N * sizeof(int));
    cudaMalloc((void**)&d_C, N * N * sizeof(int));

    // Copy matrices from host to device
    cudaMemcpy(d_A, h_A, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, N * N * sizeof(int), cudaMemcpyHostToDevice);

    // Define block and grid size
    dim3 threadsPerBlock(16, 16);  // 16x16 block
    dim3 numBlocks((N + 15) / 16, (N + 15) / 16);  // Grid size

    // Launch the kernel
    matrixAdd<<<numBlocks, threadsPerBlock>>>(d_A, d_B, d_C, N);

    // Copy the result matrix back to the host
    cudaMemcpy(h_C, d_C, N * N * sizeof(int), cudaMemcpyDeviceToHost);

    // Optionally, print the result (for small N)
//     /*
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            std::cout << h_C[i * N + j] << " ";
        }
        std::cout << std::endl;
    }
//     */

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    // Free host memory
    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}
