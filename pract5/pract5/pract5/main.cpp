#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

float** createNewMatrix(int N)
{
	float** matrix = new float* [N];
	int i;
	for (i = 0; i < N; ++i)
		matrix[i] = new float[N];
	return matrix;
}

float** getA(int N, ifstream& in)
{
	float** A = createNewMatrix(N);
	int i,j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
			in >> A[i][j];
	return A;
}

float ** getAT(float** A, int N)
{
	float** AT = createNewMatrix(N);
	int i, j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
			AT[i][j] = A[j][i];
	return AT;
}

float getAone(float ** A, int N)
{
	float max = 0, current;
	int i, j;
	for (i = 0; i < N; ++i)
	{
		current = 0;
		for (j = 0; j < N; ++j)
			current += abs(A[j][i]);
		if (current > max)
			max = current;
	}
	return max;
}

float getAinfinity(float** A, int N)
{
	float max = 0, current;
	int i, j;
	for (i = 0; i < N; ++i)
	{
		current = 0;
		for (j = 0; j < N; ++j)
			current += abs(A[i][j]);
		if (current > max)
			max = current;
	}
	return max;
}


float** getB(float** AT, int N, float Aone, float Ainfinity)
{
	float** B = createNewMatrix(N), AoneAndAinfinityMult = Aone*Ainfinity;
	int i, j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
			B[i][j] = AT[i][j] / AoneAndAinfinityMult;
	return B;
}

float** matrixMultiplication(float** A, float** B, int N)
{
	float** result = createNewMatrix(N);
	int i, j, k;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
		{
			result[i][j] = 0;
			for (k = 0; k < N; ++k)
				result[i][j] += A[i][k] * B[k][j];
		}
	return result;
}

void matrixAddition(float** A, float** B, int N)
{
	int i, j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
				A[i][j] += B[i][j];
}

float** matrixSubtraction(float** decreasing, float** subtrahend, int N)
{
	float** result = createNewMatrix(N);
	int i, j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
			result[i][j] = decreasing[i][j] - subtrahend[i][j];
	return result;
}

float** getI(int N)
{
	float** I = createNewMatrix(N);
	int i, j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
			I[i][j] = 0;
	for (i = 0; i < N; ++i)
		I[i][i] = 1;
	return I;
}

float** getR(float** I, float** B, float** A, int N)
{
	float** ABMult = matrixMultiplication(B, A, N);
	return matrixSubtraction(I, ABMult,N);
}

void cleanUpMatrix(float** matrix, int N)
{
	if (!matrix)
		return;
	int i;
	for (i = 0; i < N; ++i)
		if (matrix[i])
			delete(matrix[i]);
	delete(matrix);
}

float** getInvertedA(float ** I,float** R, float** B, int N, int M)
{
	float** prevRDeg, ** curRDeg = NULL, ** summ = I;
	matrixAddition(summ, R, N);
	int i;
	curRDeg = matrixMultiplication(R, R, N);
	matrixAddition(summ, curRDeg, N);
	prevRDeg = curRDeg;
	for (i = 2; i < M; ++i)
	{
		curRDeg = matrixMultiplication(R, prevRDeg, N);
		matrixAddition(summ, curRDeg, N);
		cleanUpMatrix(prevRDeg, N);
		prevRDeg = curRDeg;
	}
	cleanUpMatrix(curRDeg,N);
	float** AInverted = matrixMultiplication(summ, B, N);
	return AInverted;
}

void showAInverted(float ** AInverted,int N)
{
	int i, j;
	for (i = 0; i < N; ++i)
	{
		for (j = 0; j < N; ++j)
			printf("%.4f ", AInverted[i][j]);
		printf("\n");
	}
}

int main(int argc, char ** argv)
{
	if (argc != 4)
	{
		cout << "wrong number of arguments" << endl;
		return -1;
	}
	int N = atoi(argv[1]), M = atoi(argv[2]);
	ifstream in;
	in.open(argv[3]);
	if (!in)
	{
		cout << "couldn't open file" << endl;
		return -1;
	}
	/*int N, M;
	cin >> N >> M;*/
	float** A = getA(N,in);
	float** AT = getAT(A, N);
	float Aone = getAone(A, N);
	float Ainfinity = getAinfinity(A, N);
	float** B = getB(AT, N, Aone, Ainfinity);
	float** I = getI(N);
	float** R = getR(I, B, A, N);
	float** AInverted = getInvertedA(I, R, B, N, M);
	showAInverted(AInverted, N);
	cleanUpMatrix(A, N);
	cleanUpMatrix(AT, N);
	cleanUpMatrix(B, N);
	cleanUpMatrix(I, N);
	cleanUpMatrix(R, N);
	cleanUpMatrix(AInverted, N);
	return 0;
}