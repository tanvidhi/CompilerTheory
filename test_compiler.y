/* This compiler does not fulfill project requirements */

%{

#include <stdio.h>
#include <stdlib.h>


#define SYMTABSIZE		50
#define IDLENGTH		15
#define NOTHING			-1
#define INDENTOFFSET	2

	enum ParseTreeNodeType {PROGRAM, STATEMENTS, STATEMENT, IF_STATEMENT, WHILE_STATEMENT, ASSIGNMENT_STATEMENT,
							CONDITION, RELOP, EXPR, BINARYOP, NUMBER_VALUE, ID_VALUE};

char *NodeName[] = {"PROGRAM", "STATEMENTS", "STATEMENT", "IF_STATEMENT", "WHILE_STATEMENT", "ASSIGNMENT_STATEMENT",
					"CONDITION", "RELOP", "EXPR", "BINARYOP", "NUMBER_VALUE", "ID_VALUE"};
							
#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define NULL 0
#endif

struct treeNode
{
	int item;
	int nodeIdentifier;
	struct treeNode *first;
	struct treeNode *second;
	struct treeNode *third;
};

typedef struct treeNode TREE_NODE;
typedef TREE_NODE *TERNARY_TREE;

TERNARY_TREE create_node(int, int, TERNARY_TREE, TERNARY_TREE, TERNARY_TREE);
#ifdef DEBUG
void PrintTree(TERNARY_TREE, int);
#endif
void WriteCode(TERNARY_TREE);

struct symTabNode
{
	char identifier[IDLENGTH];
};

typedef struct symTabNode SYMTABNODE;
typedef SYMTABNODE *SYMTABNODEPTR;

SYMTABNODEPTR symTab[SYMTABSIZE];

int currentSymTabSize = 0;
%}

%start program

%union
{
	int iVal;
	TERNARY_TREE tVal;
}

%token 	SEMICOLON ASSIGNMENT LESS_THAN GREATER_THAN PLUS MINUS BEGIN END IF THEN ELSE WHILE DO
%token<iVal>	ID NUMBER
%type<tVal> program statements statement if_statement while_statement assignment_statement
			condition relop expr binaryOp value

%%

program : BEGIN statements END
			{ 
				TERNARY_TREE ParseTree;
				ParseTree = create_node(NOTHING, PROGRAM, $2, NULL, NULL);
				#ifdef DEBUG
				PrintTree(ParseTree, 0);
				#endif
				WriteCode(ParseTree);
			}
			;
statements : statement {$$ = create_node(NOTHING, STATEMENTS, $1, NULL, NULL);}
			 | statement SEMICOLON statements {$$ = create_node(NOTHING, STATEMENTS, $1, $3, NULL);}
			 ;
statement : if_statement {$$ = create_node(NOTHING, STATEMENTS, $1, NULL, NULL);}
			| while_statement {$$ = create_node(NOTHING, STATEMENTS, $1, NULL, NULL);}
			| assignment_statement {$$ = create_node(NOTHING, STATEMENTS, $1, NULL, NULL);}
			| program {$$ = create_node(NOTHING, STATEMENTS, $1, NULL, NULL);}
			;	 
if_statement : IF condition THEN statement {$$ = create_node(NOTHING, IF_STATEMENT, $2, $4, NULL);}
			 ;
while_statement : WHILE condition DO statement {$$ = create_node(NOTHING, WHILE_STATEMENT, $2, $4, NULL);}
				;
assignment_statement : ID ASSIGNMENT expr {$$ = create_node($1, ASSIGNMENT_STATEMENT, $3, NULL, NULL);}
					 ;
condition : expr relop expr {$$ = create_node(NOTHING, CONDITION, $1, $2, $3);}

relop : LESS_THAN {$$ = create_node(LESS_THAN, RELOP, NULL, NULL, NULL);}
		 | GREATER_THAN {$$ = create_node(GREATER_THAN, RELOP, NULL, NULL, NULL);}
		 ; 
expr : value binaryOp expr {$$ = create_node(NOTHING, EXPR, $1, $2, $3);}
	   | value {$$ = create_node(NOTHING, EXPR, $1, NULL, NULL);}
	   ;
binaryOp : PLUS {$$ = create_node(PLUS, BINARYOP, NULL, NULL, NULL);}
		   | MINUS {$$ = create_node(MINUS, BINARYOP, NULL, NULL, NULL);}
		   ;   
value : NUMBER {$$ = create_node($1, NUMBER_VALUE, NULL, NULL, NULL);}
		| ID {$$ = create_node($1, ID_VALUE, NULL, NULL, NULL);}
		;
		
%%

TERNARY_TREE create_node(int ival, int case_identifier, TERNARY_TREE p1, TERNARY_TREE p2, TERNARY_TREE p3)
{
	TERNARY_TREE t;
	t = (TERNARY_TREE)malloc(sizeof(TREE_NODE));
	t->item = ival;
	t->nodeIdentifier = case_identifier;
	t->first = p1;
	t->second = p2;
	t->third = p3;
	return (t);
}

#ifdef DEBUG
void PrintTree(TERNARY_TREE t, int indent)
{
	int i;
	if(t == NULL)
		return;
	for(i = indent; i; i--)
		printf(" ");
	if(t->nodeIdentifier == NUMBER_VALUE)
		printf("Number: %d", t->item);
	else if(t->nodeIdentifier == ID_VALUE)
	{
		if(t->item > 0 && t->item < SYMTABSIZE)
			printf("Identifier: %s", symTab[t->item]->identifier);
		else
			printf("Unknown Identifier: %d", t->item);
	}
	if(t->item != NOTHING
		printf("Item: %d\n", t->item);
	if(t->nodeIdentifier < 0 || t->nodeIdentifier > sizeof(NodeName))
		printf("Unknown nodeIdentifier: %d\n", t->nodeIdentifier);
	else
		printf("nodeIdentifier: %s\n", NodeName[t->nodeIdentifier]);
	PrintTree(t->first, indent+3);
	PrintTree(t->second, indent+3);
	PrintTree(t->third, indent+3);
}
#endif

void WriteCode(TERNARY_TREE t)
{
	if(t == NULL)
		return;
	switch(t->nodeIdentifier)
	{
		case(PROGRAM):
			printf("int main(void) {\n");
			WriteCode(t->first);
			printf("}\n");
			return;
		case(STATEMENTS):
			WriteCode(t->first);
			printf(";\n");
			WriteCode(t->second);
			return;
		case(IF_STATEMENT):
			printf("if (");
			WriteCode(t->first);
			printf(") {\n");
			WriteCode(t->second);
			printf("}\n");
			return;
		case(WHILE_STATEMENT):
			printf("while (");
			WriteCode(t->first);
			print(") do {\n");
			WriteCode(t->second);
			printf("}\n");
			return;
		case(ASSIGNMENT_STATEMENT):
			if(t->item >= 0 && t->item < SYMTABSIZE)
				printf("%s", symTab[t->item]->identifier);
			else
				printf("Unknown Identifier: %d", t->item);
			printf(" = ");
			WriteCode(t->first);
			return;
		case(NUMBER_VALUE):
			printf("%d", t->item);
			return;
				
	}
	WriteCode(t->first);
	WriteCode(t->second);
	WriteCode(t->third);
}

#include "lex.yy.c"

