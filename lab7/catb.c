#include <stdio.h>
#include <stdlib.h>

int  main(int argc, char **argv)
{
	char ch;
	while ((ch=getchar()) != EOF)
		putchar(ch);
	
	exit(0);
}
