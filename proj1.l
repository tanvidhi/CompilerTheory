/* just like Unix wc */

%option noyywrap

%{
int isANumber = 0;
%}

%%

[0] | [0-9]+ { isANumber = 1 }

%%

int main()
{
  yylex();
  if(isANumber==1)
    printf("is a number");
  else
    printf("is not a number");
}