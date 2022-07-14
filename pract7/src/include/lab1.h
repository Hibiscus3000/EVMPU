#ifndef _LAB1_
#define _LAB1_

#include <stdio.h>
#include <string.h>

double LeibnizFormula(long long N)
{
    double Pi = 0, nextMember;
    long long i;
    for (i = 0; i < N; i++)
    {
        if (i % 2)
            nextMember = -1;
        else
            nextMember = 1;
        nextMember /= 2 * (double)(i)+1;
        Pi += nextMember;
    }
    Pi *= 4;
    return Pi;
}

#endif