/* Kao Vue, Roland Bernard, Tanvi Gandhi, Edgardo Quevada
 * project 1, stubbRule's are for testing the output.
 * The numbering system on the stubb is A.B or A.B.C
 * 'A' represents the problem number, B and C are to categorize each solution
 * to keep track of which line of code is passing the tokens as numbers.
 * After extensive testing we will remove the "stubbRule:x.x.x" out of the
 * program and turn in the assignment.
 */
/* There are 6 sections of code in the flex code. They each correspond to the comments below:
   problem 1. A number with no leading zeros unless it is a single digit 
   
   problem 2. Decimal numbers. No leading zeros unless there is a peroid after one initial zero.
   We are allowed to have tailing zeros.
   
   problem 3. any number from problem 1 or 2 followed by e/E and a number from problem 1 
   
   problem 4. Exactly one leading zero, followed by one or more digits 0-7. 
   If there is exactly two digits, they may both be zeros. 
   Otherwise no leading zero after initial zero.
   
   problem 5. Starts with 0x or 0X followed by hex digits. 
   No leading zeros after 0x but can be 0x0. */
   
%option noyywrap

%%
[0]              printf("%s Number stubbRule:1.0\n", yytext);
[-]?[1-9][0-9]*  printf("%s Number stubbRule:1.1\n", yytext);

[-]?[0][\.][0-9]+          printf("%s Number stubbRule:2.0\n", yytext);
[-]?[1-9][0-9]*[\.][0-9]+  printf("%s Number stubbRule:2.1\n", yytext);

[0][[:upper:]e][0]  printf("%s Number stubbRule:3.0.0\n", yytext);
[0][[:upper:]e][-]?[1-9][0-9]*  printf("%s Number stubbRule:3.0.1\n", yytext);
[-]?[1-9][0-9]*[[:upper:]e][0]  printf("%s Number stubbRule:3.1.0\n", yytext);
[-]?[1-9][0-9]*[[:upper:]e][-]?[1-9][0-9]*   printf("%s Number stubbRule:3.1.1\n", yytext);
[-]?[0][\.][0-9]+[[:upper:]e][0]   printf("%s Number stubbRule:3.2.0\n", yytext);
[-]?[0][\.][0-9]+[[:upper:]e][-]?[1-9][0-9]*  printf("%s Number stubbRule:3.2.1\n", yytext);
[-]?[1-9][0-9]*[\.]?[0-9]+[[:upper:]e][0] printf("%s Number stubbRule:3.3.0\n", yytext);
[-]?[1-9][0-9]*[\.]?[0-9]+[[:upper:]e][-]?[1-9][0-9]* printf("%s Number stubbRule:3.3.1\n", yytext);

[-]?[0][0] printf("%s Number stubbRule:4.0\n", yytext);
[-]?[0][1-7][0-7]* printf("%s Number stubbRule:4.1\n", yytext);

[-]?[0][[:upper:]x][0] printf("%s Number stubbRule:5.0\n", yytext);
[-]?[0][[:upper:]x][1-9A-F][0-9A-F]* printf("%s Number stubbRule:5.1\n", yytext);

[-a-zA-Z0-9~`!@#$%^&*()_+\.<>{}\[\];':"\\]+  printf("%s Not a number stubbNoRule\n", yytext);
[ ]             printf("");
%%

int main()
{
  yylex();
}