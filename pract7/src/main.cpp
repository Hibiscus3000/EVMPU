#define M 1000000
#define OFFSET 786432
#define NUMBER_OF_FRAGMENTS 32
#define NUMBER_OF_ELEMENTS_IN_FRAGMENT 16

#include "include/lab1.h"
#include <fstream>
#include <iostream>
#include <ctime>
#include <cstdlib>
#include <stdint.h>

using namespace std;

void arrayFilling(int*& x, int N, int numberOfFragments)
{
	int i, j;
	x = new int[N];
	for (j = 0; j < NUMBER_OF_ELEMENTS_IN_FRAGMENT; ++j)
		for (i = 0; i < numberOfFragments - 1; ++i)
			x[i * OFFSET + j] = (i + 1) * OFFSET + j;
	for (i = 0; i < NUMBER_OF_ELEMENTS_IN_FRAGMENT - 1; ++i)
		x[(numberOfFragments - 1) * OFFSET + i] = 1 + i;
	x[(numberOfFragments - 1) * OFFSET + NUMBER_OF_ELEMENTS_IN_FRAGMENT - 1] = 0;
}

void bypass(ofstream& out, int* x, int N, int numberOfMeasurments, int numberOfFragments)
{
	int j, i, m, k;
	uint64_t t, min, tbegin, tend;
	uint32_t t1begin, t1end, t2begin, t2end;
	for (j = 0; j < numberOfMeasurments; ++j)
	{
		k = 0;
		tbegin = __builtin_ia32_rdtsc();
		for (i = 0; i < NUMBER_OF_ELEMENTS_IN_FRAGMENT * numberOfFragments; ++i)
			k = x[k];
		tend = __builtin_ia32_rdtsc();
		tend = __builtin_ia32_rdtsc();
		t = (uint64_t)((tend - tbegin) / (NUMBER_OF_ELEMENTS_IN_FRAGMENT * numberOfFragments));
		if (123 == k)
			cout << "!!!!";
		if ((0 == min) || (t < min))
			min = t;
	}
	out << numberOfFragments << ',' << min << endl;
}

int main(int argc, char** argv)
{
	srand((unsigned)time(0));
	int* x = NULL, numberOfMeasurments = atoi(argv[1]);
	double Pi = LeibnizFormula(M);
	int N;
	time_t time;
	if (1.1 == Pi)
		cout << "!!!!";
	ofstream out(argv[2]);
	if (!out)
	{
		cout << "couldn't open output file" << endl;
		return 1;
	}
	int i;
	for (i = 0; i < NUMBER_OF_FRAGMENTS; ++i)
	{
		N = OFFSET * (i + 1);
		arrayFilling(x, N, i + 1);
		bypass(out, x, N, numberOfMeasurments, i + 1);
		delete[] x;
	}
	return 0;
}