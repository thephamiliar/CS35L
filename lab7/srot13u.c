#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>

int rot13cmp(void const *a, void const *b);
int g_cmp_count = 0;

int  main(int argc, char *argv)
{
	char ch[1];
	int nchars = 0, nwords = 0;
	char **words = malloc(nwords*sizeof(char*));
	char *new_word = malloc(nchars*sizeof(char));
	if (!words || !new_word)
	{
		fprintf(stderr, "Error in allocating initial memory");
		exit(1);
	}


	/*check if input is regular file*/

	struct stat reg;
	int size = 0;
	fstat(0, &reg);
	if (S_ISREG(reg.st_mode))
	{
		size = reg.st_size;
		words = malloc(size*sizeof(char*));
		do {
			while(read(0, ch, 1) > 0)
			{
				if (*ch == '\n')
				{
					nchars++;
					new_word = realloc(new_word, nchars*sizeof(char));
					new_word[nchars-1] = *ch;
					nwords++;
					words[nwords-1]= new_word;
					nchars = 0;
					char *tmp = malloc(nchars*sizeof(char*));
					new_word = tmp;
				}
				else
				{
					nchars++;
					new_word = realloc(new_word, nchars*sizeof(char));
					new_word[nchars-1] = *ch;
				}	
			}
		fstat(0,&reg);
		} while (reg.st_size != size);
	}
	else
	{
		while (read(0,ch,1)>0)
		{
			if (*ch == '\n')
			{
				nchars++;
				new_word = realloc(new_word, nchars*sizeof(char));
				if (!new_word)
				{
					fprintf(stderr, "Error in reallocating memory in new word");
					exit(1);
				}
				new_word[nchars-1] = *ch;
				nwords++;
				words = realloc(words, nwords*sizeof(char*));
				if (!words)
				{
					fprintf(stderr, "Error in reallocating memory in array of words");
					exit(1);
				}
				words[nwords-1]= new_word;
				nchars = 0;
				char *tmp = malloc(nchars*sizeof(char));
				new_word = tmp;
			}
			else
			{
				nchars++;
				new_word = realloc(new_word, nchars*sizeof(char));
				if (!new_word)
				{
					fprintf(stderr, "Error in reallocating memory in new word");
					exit(1);
				}
				new_word[nchars-1] = *ch;
			}
		}
		if (nchars != 0 && new_word[nchars-1] != '\n')
		{
			nchars++;
			new_word = realloc(new_word, nchars*sizeof(char));
			if (!new_word)
			{
				fprintf(stderr, "Error in reallocating memory in new word");
				exit(1);
			}
			new_word[nchars-1] = '\n';
			nwords++;
			words = realloc(words, nwords*sizeof(char*));
			if (!words)
			{
				fprintf(stderr, "Error in reallocating memory in array of words");
				exit(1);
			}
			words[nwords-1]= new_word;
		}
	}

	/*Sort the words using the rot13cmp function*/
	qsort(words, nwords, sizeof(char*), rot13cmp);
	
	/*Print the sorted file in ROT13 format*/
	int i;
	for (i = 0; i < nwords; i++)
	{
		int j;
		for (j=0; words[i][j]!='\n'; j++)
			write(1, &words[i][j], 1);
		write(1, &words[i][j], 1);
	}

	fprintf(stderr, "Number of comparisons: %d\n", g_cmp_count);

	/*Free memory*/
	if (words)
	{
		int i;
		for (i = 0; i < nwords; i++)
			free(words[i]);
		free(words);
	}
	
	exit(0);
}

/* Returns positive,negative, or zero depending if
   a > b, a < b, or a == b respectively. */
int rot13cmp (void const *a, void const *b)
{
	g_cmp_count++;
	const char *p1=*((const char**) a);
	const char *p2=*((const char**) b);
	int i1 = 0, i2 = 0;
	while (p1[i1]!= '\n' && p2[i2]!= '\n' && p1[i1] == p2[i2])
	{
		i1++;
		i2++;
	}
	const char c1 = p1[i1];
	const char c2 = p2[i2];
	int diff = 0;
	if (c1 =='\n' && c2=='\n')
		diff = 0;
	else if ((c1 < 'N' && c2 < 'N') || 
			((c1 > 'M' && c2 > 'M') && (c1 < 'a' && c2 < 'a')) ||
			((c1 < 'n' && c2 < 'n') && (c1 > 'Z' && c1 > 'Z')) ||
			(c1 > 'm' && c2 > 'm') || (islower(c1) != islower(c2)))
		diff = c1-c2;
	else
		diff = c2-c1;
	return diff;
}
