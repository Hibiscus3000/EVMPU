#include <math.h>
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <cblas.h>

using namespace std;

void showAInverted(float* AInverted, int N);

float* getA(int N, ifstream& in)
{
	float* A = new float[N * N];
	int i;
	for (i = 0; i < N * N; ++i)
		in >> A[i];
	return A;
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

float* getB(float* A, float* I, int N, float Aone, float Ainfinity)
{
	float* B = new float[N * N], AoneAndAinfinityMult = Aone * Ainfinity;
	cblas_sgemm(CblasRowMajor, CblasTrans, CblasNoTrans, N, N, N, (float)(1 / AoneAndAinfinityMult), A, N, I, N, 0, B, N);
	return B;
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
	float* R = getI(N);
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, -1, B, N, A, N, 1, R, N);
	return R;
}

float* getInvertedA(float* I, float* R, float* B, int N, int M)
{
	float* nextRDeg = new float[N * N], * prevRDeg = new float[N * N], * summ = getI(N);
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1, R, N, I, N, 1, summ, N);
	int i;
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1, R, N, R, N, 0, prevRDeg, N);
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1, prevRDeg, N, I, N, 1, summ, N);
	for (i = 2; i < M; ++i)
	{
		cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1, R, N, prevRDeg, N, 0, nextRDeg, N);
		cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1, nextRDeg, N, I, N, 1, summ, N);
		free(prevRDeg);
		prevRDeg = nextRDeg;
		nextRDeg = new float[N * N];
	}
	free(prevRDeg);
	free(nextRDeg);
	float* AInverted = new float[N * N];
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1, summ, N, B, N, 0, AInverted, N);
	free(summ);
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
	/*int N, M;
	cin >> N >> M;*/
	float* A = getA(N, in);
	float Aone = getAone(A, N);
	float Ainfinity = getAinfinity(A, N);
	float* I = getI(N);
	float* B = getB(A, I, N, Aone, Ainfinity);
	float* R = getR(I, B, A, N);
	float* AInverted = getInvertedA(I, R, B, N, M);
	showAInverted(AInverted, N);
	free(A);
	free(B);
	free(I);
	free(R);
	free(AInverted);
	return 0;
}