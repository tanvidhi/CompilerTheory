/* This compiler does not fulfill project requirements */

%{
#ifdef PRINT
#define TOKEN(t) printf("Token: " #t "\n");
#define NUMBER_TOKEN(t) printf("Number %d Token: " #t "\n", atoi(yytext));
#define ID_TOKEN(t) printf("ID %s Token: " #t "\n", yytext);
#else
#define TOKEN(t) return(t);
#define NUMBER_TOKEN(t) yylval.iVal = atoi(yytext); return(t);
#define ID_TOKEN(t) yylval.iVal = installId(yytext); return(t);

#include <strings.h>
extern SYMTABNODEPTR symTab[SYMTABSIZE];
extern int currentSymTabSize;

#endif
%}

delim		[ \r\n\t]
ws		{delim}*
digit		[0-9]
letter		[a-zA-Z]
number		{digit}+
id		{letter}({letter}|{digit})*
%%
{ws}		; /* skip space */
";"		TOKEN(SEMICOLON)
"="		TOKEN(ASSIGNMENT)
"<"		TOKEN(LESS_THAN)
">"		TOKEN(GREATER_THAN)
"+"		TOKEN(PLUS)
"-"		TOKEN(MINUS)
begin		TOKEN(BEGIN)
end		TOKEN(END)
if		TOKEN(IF)
then		TOKEN(THEN)
else		TOKEN(ELSE)
while		TOKEN(WHILE)
do		TOKEN(DO)
{id}		ID_TOKEN(ID)
{number} 	NUMBER_TOKEN(NUMBER)
.		printf("Error: Unexpected symbol in lexical analyzer %s (%d)\n", yytext, yytext[0]);
%%

#ifndef PRINT

SYMTABNODEPTR newSymTabNode()
{
	return ((SYMTABNODEPTR)malloc(sizeof(SYMTABNODE)));
}

int installID(char *id)
{
	extern SYMTABNODEPTR symTab[SYMTABSIZE];
	extern int currentSymTabSize;
	int index;
	
	index = lookup(id);
	if(index >= 0)
	{
		return (index);
	}
	else
	{
		if(currentSymTabSize >= SYMTABSIZE)
			return (NOTHING);
		else
		{
			symTab[currentSymTabSize] = newSymTabNode();
			strncpy(symTab[currentSymTabSize]->identifier, id, IDLENGTH);
			symTab[currentSymTabSize]->identifier[IDLENGTH-1] = '\0';
			return (currentSymTabSize++);
		}
	}
}

int lookup(char *s)
{
	extern SYMTABNODEPTR symTab[SYMTABSIZE];
	extern int currentSymTabSize;
	int i;
	
	for(i = 0; i < currentSymTabSize; i++)
	{
		if(strncmp(s, symTab[i]->identifier, IDLENGTH) == 0)
		{
			return (i);
		}
	}
	return (-1);
}

#endif
