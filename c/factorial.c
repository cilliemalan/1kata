// build with: gcc factorial.c -o factorial
#include <stdlib.h>
#include <stdio.h>

int factorial(int n)
{
    if (n == 0)
    {
        return 1;
    }
    else
    {
        return n * factorial(n - 1);
    }
}

int main(int argc, char** argv)
{
    int n;

    if(argc != 2)
    {
        printf("Please specify an argument\n");
    }
    else
    {
        n = atoi(argv[1]);
        printf("The result is: %d\n", factorial(n));
    }
}
