#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <xmmintrin.h>
using namespace std;
float* getA(int N, ifstream& in)
{
	float* A = new float[N * N];
	int i;
	for (i = 0; i < N * N; ++i)
		in >> A[i];
	return A;
}
float* getAT(float* A, int N)
{
	float* AT = new float[N * N];
	int i, j;
	for (i = 0; i < N; ++i)
		for (j = 0; j < N; ++j)
			AT[i * N + j] = A[j * N + i];
	return AT;
}
float getAone(float* A, int N)
{
	float max = 0, current = 0;
	int i;
	for (i = 0; i < N * N; ++i)
	{
		current += abs(A[i]);
		if (i % N == N - 1)
		{
			if (current > max)
				max = current;
			current = 0;
		}
	}
	return max;
}
float getAinfinity(float* A, int N)
{
	float max = 0, current = 0;
	int i;
	for (i = 0; i < N * N; ++i)
	{
		current += abs(A[i]);
		if (i % N == N - 1)
		{
			if (current > max)
				max = current;
			current = 0;
		}
	}
	return max;
}
float* getB(float* AT, int N, float Aone, float Ainfinity)
{
	float* B = new float[N * N], AoneAndAinfinityMult = Aone * Ainfinity;
	int i;
	for (i = 0; i < N * N; ++i)
		B[i] = AT[i] / AoneAndAinfinityMult;
	return B;
}

float* matrixMultiplication(float* A, float* B, int N)
{
	float* result = new float[N * N];
	int i, j, k;
	__m128 p, a, * c, * b;
	for (i = 0; i < N; ++i)
	{
		c = (__m128*)(result + i * N);
		for (j = 0; j < N; ++j)
			*(c + j) = _mm_setzero_ps();
		for (k = 0; k < N; ++k)
		{
			a = _mm_set1_ps(A[i * N + k]);
			b = (__m128*)(B + k * N);
			for (j = 0; j < N; ++j)
			{
				p = _mm_mul_ps(*(b + j), a);
				*(c + j) = _mm_add_ps(*(c + j), p);
			}
		}
	}
	return result;
}

void matrixAddition(float* A, float* B, int N)
{
	int i;
	for (i = 0; i < N * N; i += 4)
		_mm_storeu_ps(A +
			i, _mm_add_ps(_mm_loadu_ps(A + i), _mm_loadu_ps(B + i)));
}
float* matrixSubtraction(float* decreasing, float* subtrahend, int N)
{
	float* result = new float[N * N];
	int i;
	for (i = 0; i < N * N; ++i)
		result[i] = decreasing[i] - subtrahend[i];
	return result;
}
float* getI(int N)
{
	float* I = new float[N * N];
	int i;
	for (i = 0; i < N * N; ++i)
		I[i] = 0;
	for (i = 0; i < N; ++i)
		I[i * N + i] = 1;
	return I;
}
float* getR(float* I, float* B, float* A, int N)
{
	float* ABMult = matrixMultiplication(B, A, N);
	return matrixSubtraction(I, ABMult, N);
}
float* getInvertedA(float* I, float* R, float* B, int N, int M)
{
	float* prevRDeg, * curRDeg = NULL, * summ = I;
	matrixAddition(summ, R, N);
	int i;
	curRDeg = matrixMultiplication(R, R, N);
	matrixAddition(summ, curRDeg, N);
	prevRDeg = curRDeg;
	for (i = 2; i < M; ++i)
	{
		curRDeg = matrixMultiplication(R, prevRDeg, N);
		matrixAddition(summ, curRDeg, N);
		free(prevRDeg);
		prevRDeg = curRDeg;
	}
	free(curRDeg);
	float* AInverted = matrixMultiplication(summ, B, N);
	return AInverted;
}
void showAInverted(float* AInverted, int N)
{
	int i;
	for (i = 0; i < N * N; ++i)
	{
		printf("%.4f ", AInverted[i]);
		if (i % N == N - 1)
			printf("\n");
	}
}
int main(int argc, char** argv)
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
	float* A = getA(N, in);
	float* AT = getAT(A, N);
	float Aone = getAone(A, N);
	float Ainfinity = getAinfinity(A, N);
	float* B = getB(AT, N, Aone, Ainfinity);
	float* I = getI(N);
	float* R = getR(I, B, A, N);
	float* AInverted = getInvertedA(I, R, B, N, M);
	showAInverted(AInverted, N);
	free(A);
	free(AT);
	free(B);
	free(I);
	free(R);
	free(AInverted);
	return 0;
}
