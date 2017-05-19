/* This compiler does not fulfill project requirements */

#include <stdio.h>

int main(void)
{
	#if YYDEBUG == 1
	extern int yydebug;
	yydebug = l;
	#endif
	return(yyparse());
}

void yyerror(char *s)
{
	fprintf(stderr, "Error : Exiting %s\n", s);
}