#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

void PrintMatrix(float** arr, int rasmer);
void TreugVid(float** matrix);

int main()
{
	int rasmer;
	double det;
	double time_spent = 0.0;
	float** matrix;
	
	printf("Vvedite rasmer marix: ");
	scanf("%d", &rasmer);
	srand(time(NULL));
	
	int time_start = clock();
	matrix = malloc(rasmer * sizeof(float*));
	for (int i = 0; i < rasmer; i++)
		matrix[i] = malloc(rasmer * sizeof(float));

	for (int i = 0; i < rasmer; i++)
		for (int j = 0; j < rasmer; j++)
			//scanf("%f", &matrix[i][j]);
			matrix[i][j] = rand() % 10;

	/*PrintMatrix(matrix, rasmer);*/	
	int time_start_2_sub = clock();
	TreugVid(matrix, rasmer);
	int time_start_2 = clock() - time_start_2_sub;
	//PrintMatrix(matrix, rasmer);
	
	det = 1;
	for (int i = 0; i < rasmer; i++)
	{
		det = det * matrix[i][i];
	}
	printf("%.2lf", det);
	printf("\nTime working = %i", clock() - time_start);	
	printf("\nTime working 2 = %i",time_start_2);

	return 0;
}

void PrintMatrix(float** arr, int rasmer)
{
	for (int i = 0; i < rasmer; i++)
	{
		for (int j = 0; j < rasmer; j++)
			printf("%.2f ", arr[i][j]);
		printf("\n");
	}
	printf("\n");
}
void TreugVid(float** matrix, int rasmer)
{
	double sub;
	int k = 0;

	while (k < rasmer - 1)
	{
		for (int i = k; i < rasmer - 1; i++)
		{
			sub = matrix[i + 1][k] / matrix[k][k];
			for (int j = 0; j < rasmer; j++)
			{
				matrix[i + 1][j] -= matrix[k][j] * sub;
			}
		}
		k++;
	}
}