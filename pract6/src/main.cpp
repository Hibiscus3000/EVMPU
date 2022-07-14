#define M 1000000
#define NUMBER_OF_MEASUREMENTS 20
#define NUMBER_OF_INCREASES 110
#define K 10

#include "include/lab1.h"
#include <fstream>
#include <iostream>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <stdint.h>

using namespace std;

void bypass(ofstream& out, int* x, int N)
{
	int j, i, k = 0;
	uint64_t t, min = 0;
	uint64_t tbegin, tend;
	uint32_t t1begin, t1end, t2begin, t2end;
	for (i = 0; i < N * K; ++i)
	{
		k = x[k];
	}
	if (123 == k)
		cout << "!!!!";
	for (j = 0; j < NUMBER_OF_MEASUREMENTS; ++j)
	{
		tbegin = __builtin_ia32_rdtsc();
		for (i = 0; i < N * K; ++i)
			k = x[k];
		tend = __builtin_ia32_rdtsc();
		if (123 == k)
			cout << "!!!!";
		t = (uint64_t)((tend - tbegin) / (N * K));
		if ((0 == min) || (t < min))
			min = t;
	}
	out << min << ',';
}

void straight(ofstream& out, int* x, int N)
{
	int i;
	for (i = 0; i < N - 1; ++i)
		x[i] = i + 1;
	x[N - 1] = 0;
	bypass(out, x, N);
}

void reverse(ofstream& out, int* x, int N)
{
	int i;
	for (i = N - 1; i > 0; --i)
		x[i] = i - 1;
	x[0] = N - 1;
	bypass(out, x, N);
}

void random(ofstream& out, int* x, int N)
{
	int i, k = 0, offset = 1, numberOfUnvisitedElements = N, beginElementsChecked = 1, endElementsChecked = 0;
	bool* visited = new bool[N];
	for (i = 1; i < N; ++i)
		visited[i] = false;
	visited[0] = true;
	i = 0;
	while (numberOfUnvisitedElements != 1)
	{
		k = (rand() % (N - endElementsChecked - beginElementsChecked)) + beginElementsChecked;
		while (visited[k] != false)
		{
			k += offset;
			if (k < 0)
				k += N;
			if (k > N - 1)
				k = k % N;
			offset = (int)pow(-1, offset) * (1 + abs(offset));
		}
		offset = 1;
		visited[k] = true;
		x[i] = k;
		i = k;
		if ((k == N - endElementsChecked - 1) && (numberOfUnvisitedElements != 2))
			while (visited[k] != false)
			{
				--k;
				++endElementsChecked;
			}
		if ((k == beginElementsChecked) && (numberOfUnvisitedElements != 2))
			while (visited[k] != false)
			{
				++k;
				++beginElementsChecked;
			}
		--numberOfUnvisitedElements;
	}
	x[k] = 0;
	delete[] visited;
	bypass(out, x, N);
}

int main()
{
	srand((unsigned)time(0));
	int N = 256, i, * x, space;
	double Pi = LeibnizFormula(M);
	time_t time;
	if (1.1 == Pi)
		cout << "!!!!";
	ofstream out("out.csv");
	for (i = 0; i < NUMBER_OF_INCREASES; ++i)
	{
		out << N << ',';
		space = round((N * 10) / 256);
		if (space < 10240)
			out << (double)(space / 10)  << " KB,";
		else
			out << (double)(round(space / 1024) / 10) << " MB,";
		x = new int[N];
		straight(out, x, N);
		reverse(out, x, N);
		random(out, x, N);
		delete[] x;
		N = (int)(N * 1.1);
		out << endl;
	}
	return 0;
}