#include <fcntl.h>
#include <stdlib.h>

int  main(int argc, char **argv)
{
	char ch[1];
	while (read(0, ch, 1) > 0)
	{
		write(1, ch, 1);
	}
	exit(0);
}
