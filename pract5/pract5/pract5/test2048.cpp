#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main()
{
	int i, k;
	FILE * out = fopen("test32.txt","w");
	for (i = 0; i < 32; ++i)
	{
		for (k = 0; k < 32; ++k)
			fprintf(out, "%d ", i - k);
		fprintf(out, "\n");
	}
}