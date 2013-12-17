#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int rot13cmp (void const *a, void const *b);


int  main(int argc, char **argv)
{
	char ch;
	int nchars = 0, nwords = 0;
	char **words = malloc(nwords*sizeof(char*));
	char *new_word = malloc(nchars*sizeof(char));
	if (!words || !new_word)
	{
		fprintf(stderr, "Error in allocating initial memory");
		exit(1);
	}

	while ((ch=getchar()) != EOF)
	{
		if (ch == '\n')
		{
			nchars++;
			new_word = realloc(new_word, nchars*sizeof(char));
			if (!new_word)
			{
				fprintf(stderr, "Error in reallocating memory in new word");
				exit(1);
			}
			new_word[nchars-1] = ch;
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
			new_word[nchars-1] = ch;
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

	/*Sort the words using the rot13cmp function*/
	qsort(words, nwords, sizeof(char*), rot13cmp);
	
	/*Print the sorted file in ROT13 formate*/
	int i;
	for (i = 0; i < nwords; i++)
	{
		int j;
		for (j = 0; words[i][j] != '\n'; j++) 
			printf("%c",words[i][j]);
		printf("%c",words[i][j]);
	}

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
