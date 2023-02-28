#ifndef CUDACC
#define CUDACC
#endif
#include <cuda.h>
#include <device_functions.h>
#include <cuda_runtime_api.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <curand_kernel.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <random>
#include <conio.h>



double det(double* arr, int N) //Перемножаем элементы на главной диагонали , получаем определитель
{
    double d = 1.0;
    for (int i = 0; i < N; i++)
        d *= arr[i * N + i];
    return d;
}

__global__ void test(double* arr, int N)
{
    int i = (blockIdx.x * blockDim.x + threadIdx.x) / N;
    int j;
    double kof;
    for (j = 0; j < N; j++)
    {
        if (i >= j && i < N - 1)
        {
            kof = arr[(i + 1) * N + j] / arr[j * N + j];
            int g = (blockIdx.x * blockDim.x + threadIdx.x) % N;
            if (g < N)
            {
                arr[(i + 1) * N + g] -= kof * arr[j * N + g];
            }
        }
    }

}

__host__ int main()
{
    int N;
    printf("Enrer size of matrix N = ");
    scanf_s("%i", &N);
    int SizeMatr = N * N;//Размер матрицы
    int SizeInByte = SizeMatr * sizeof(double);//Память, необходимая для массива на GPU 
    double* pMatr = new double[SizeMatr];//Выделяем память под массив

    //Заполняем матрицу случайными числами и выводим 
    srand(time(NULL));
    for (int i = 0; i < SizeMatr; i++)
    {
        pMatr[i] = 1 + rand() % 9;
    }

    printf("\n");
    //for (int i = 0; i < SizeMatr; i++)
    //{
    //    printf("%0.2f ", pMatr[i]);
    //    if (((i + 1) % N == 0) && (i != 0)) printf("\n");
    //}
    //printf("\n");


    double* pMatr_GPU;

    float start2 = clock();

    cudaMalloc((void**)&pMatr_GPU, SizeInByte);//Выделяем память под массив на GPU
    cudaMemcpy(pMatr_GPU, pMatr, SizeInByte, cudaMemcpyHostToDevice);//Копируем значения матрицы на GPU 

    int gridsize = ((N * N) / 1024) + 1;
    int blocksize = 1024;

    //Инициализируем переменные для замера времени работы
    float recording;
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);


    test << <  gridsize, blocksize >> > (pMatr_GPU, N); // вызов функции для изменения матрицы 

    float end = clock();
    //Получаем время работы
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&recording, start, stop);

    cudaThreadSynchronize();//Синхронизируем потоки

    cudaMemcpy(pMatr, pMatr_GPU, SizeInByte, cudaMemcpyDeviceToHost);//Копируем новую матрицу с GPU обратно на CPU
    printf("\n");
    //for (int i = 0; i < SizeMatr; i++)  //выводим измененную матрицу
    //{
    //    printf("%0.2f ", pMatr[i]);
    //    if (((i + 1) % N == 0) && (i != 0)) printf("\n");
    //}
    //printf("\n");

    printf("\ndet A = %.2f \n", det(pMatr, N));//Выводим определитель
    if (recording > 0) printf("Time of execution =  %.2f\n", recording);
    else printf("Time working =  %.2f\n", end - start2);

    cudaFree(pMatr_GPU);//Освобождаем память

    return 0;
}
