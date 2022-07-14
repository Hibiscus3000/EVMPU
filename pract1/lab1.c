#include <stdio.h>
#include <string.h>

double LeibnizFormula (long long N)
{
    double Pi = 0, nextMember;
    long long i;
    for (i = 0; i < N; i++)
    {
	if (i % 2)
	    nextMember = -1;
	else
	    nextMember = 1;
	nextMember /= 2*(double)(i) + 1;
	Pi += nextMember;
    } 
    Pi *= 4;
    return Pi;
}

int fromCharToInt (char c)
{
    return (int)(c - '0');
}

long long getN (char * charN)
{
    int i, lengthN = strlen(charN);
    long long N = 0;
    for (i = 0; i < lengthN; i++)
    {
		N *= 10;
		N += (long long)(fromCharToInt(charN[i]));
    }
    return N;
}

void printAnswer(double Pi)
{
    printf("%f\n",Pi);
}

int main(int argc, char** argv)
{
    long long N = getN(argv[1]);
    double Pi = LeibnizFormula(N);
    printAnswer(Pi);
    return 0;
}