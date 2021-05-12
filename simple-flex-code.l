/*Reading one file only. Ends when it finds EOF */
%option noyywrap

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YYSTYPE char*

/* Header file that contains all the tokens */
#include "simple-bison-code.tab.h"

extern int line; //Line counter
extern int correctWords; //Correct words counter
extern int incorrectWords; //Incorrect Words counter
extern FILE *yyout;
void prn(char *s);

%}

/*Regular exprations declaration*/
/*STARTSWITHZERO regex detects if an integer starts with zero for error handling*/
/*SIGNEDZERO regex detects if the number zero is signed for error handling*/
DELIMITER       [ \t]+
LP              "("
RP              ")"
PLUS            "+"
MINUS           "-"
DIV             "/"
MULT            "*"
EQUALS          "="
STARTSWITHZERO   0[0-9]+ 
SIGNEDZERO      [+-]0   
INTEGERS        [0]|[+-]?[1-9][0-9]* 
VARIABLES	    [?][0-9a-zA-Z]* 
COMMENTS        ;.*
DEFFACTS        "deffacts"
DEFRULE         "defrule"
TEST            "test"
PRINT           "printout t"
READ            "read"
BIND            "bind"
STATE           [a-zA-Z][0-9a-zA-Z_-]*
ARROW           ">"
ERROR           .
NEWLINE         \n

/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias arithmhtikhs timhs mesw ths synarthshs yylex() */

%%

{DELIMITER}     { }
{LP}            { prn("Left parenthesis"); return LP; }
{RP}            { prn("Right parenthesis");  return RP; }
{ARROW}            { prn("ARROW"); return ARROW; }
{STARTSWITHZERO}   { prn("Number starting with 0"); incorrectWords++; }
{SIGNEDZERO}    { prn("Signed 0"); incorrectWords++; }
{INTEGERS}      { prn("INTEGERS");  correctWords++; return INT; }
{VARIABLES}	    { prn("VARIABLE");  correctWords++; return VAR; }
{PLUS}          { prn("PLUS"); return PLUS; }
{MINUS}         { prn("MINUS"); return MINUS; }
{DIV}           { prn("DIV"); return DIV; }
{MULT}          { prn("MULT"); return MULT; }
{EQUALS}        { prn("EQUALS"); return EQUALS; }
{COMMENTS}      { prn("COMMENTS"); }
{DEFFACTS}      { prn("DEFFACTS");  correctWords++; return DEFFACTS; }
{DEFRULE}       { prn("DEFRULE");  correctWords++; return DEFRULE; }
{TEST}          { prn("TEST");  correctWords++; return TEST; }
{PRINT}         { prn("PRINT");  correctWords++; return PRINTOUT; }
{READ}          { prn("READ");  correctWords++; return READ; }
{BIND}          { prn("BIND");  correctWords++; return BIND; }
{STATE}         { prn("STATE");  correctWords++; return STATE; }
{ERROR}         { fprintf(yyout, "\nWrong word definition at line: %d", line); incorrectWords++;}
{NEWLINE}       { line++; printf("\n"); }


%%


void prn(char *s)
{
	fprintf(yyout,"\n\t%s: %s ", s, yytext);
	return;
}


