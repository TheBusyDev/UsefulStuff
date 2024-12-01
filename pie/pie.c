/*
PI approximation using Leibniz series: 1 - 1/3 + 1/5 - 1/7 + 1/9 - ... = pi/4
*/
#include <stdio.h>

int main ()
{
	int den = 1, num = 4;
	long double pie = 4, real_pi = 3.141592653589793;

	printf ("Real PI:   %.15LF\n", real_pi);
	printf ("PIE:       ");

	while (1)
	{
		num *= -1;
		den += 2;
		pie = pie + (long double)num/den;
		printf ("\033[12G%.48LF", pie);
	}
	
	return 0;
}