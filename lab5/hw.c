#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int rot13cmp (const void *a, const void *b);

int  main(int argc, char **argv)
{
	char ch;
	int nchars = 0, nwords = 0;
	char *new_word = NULL, *more_chars = NULL;
//	char **words = malloc(nwords*sizeof(char*));
//	char **tmp_words = NULL, *tmp_word = NULL;
	while ((ch=getchar()) != EOF)
	{
		while (isalpha(ch=getchar()))
		if (ch == '\n')
		{
			nwords++;
//			tmp_words = realloc (words, nwords*sizeof(char*));
//			words = tmp_words;
			char *new_word = malloc(nchars*sizeof(char));
			int i;
			for (i = 0; i < nchars; i++)
				new_word[i] = ch;
//			words[nwords] = new_word;
			nwords++;
			printf("%d", nchars);
			nchars = 0;
			free(new_word);
		}
		nchars++;
	}
	if (nchars > 0)
	{
		nwords++;
//		tmp_words = realloc (words, nwords*sizeof(char*));
//		words = tmp_words;
		char *new_word = malloc(nchars*sizeof(char));
//		words[nwords] = new_word;
		nwords++;
		printf("%d", nchars);
		nchars = 0;
	}

	//if (argc < 2)
	//{
	//	fprintf(stderr, "No file input\n", argv[0]);
	//	exit(1);
	//}
	//printf("%c %d", ch, i);
	printf("%d", nwords-1);
//	free(words);
	exit(0);
}
/* Returns positive,negative, or zero depending if
   a > b, a < b, or a == b respectively. */
int rot13cmp (const void *a, const void *b)
{
	const char *p1=*(const char**)a;
	const char *p2=*(const char**)b;
//	char p1[]="\0Dhvpx";
//	char p2[]="\0Oebja";
	int i1 = 0, i2 = 0;
	while (!isalpha(p1[i1]))
		i1++;
	while (!isalpha(p2[i2]))
		i2++;
	while (p1[i1]!= '\n' && p2[i2]!= '\n' && p1[i1] == p2[i2])
	{
		i1++;
		i2++;
	}
	char c1 = tolower(p1[i1]);
	/*Allocate enough memory to read the arguments*/
	char c2 = tolower(p2[i2]);
	int diff = 0;
//	printf("%c\n%c\n",c1,c2);
	if (c1 =='\n' && c2=='\n')
		diff = 0;
	else if ((c1 < 'n' && c2 < 'n') || (c1 > 'm' && c2 > 'm'))
	{
//		printf("same section\n");
		diff = c1-c2;
	}
	else
	{
//		printf("diff section\n");
		diff = c2-c1;
	}
/*	if (diff == 0 || diff > 0)
		printf("%c\n%c\n", c2, c1);
	else
		printf("%c\n%c\n", c1, c2);*/
//	printf("%d\n",diff);
	return diff;
}
