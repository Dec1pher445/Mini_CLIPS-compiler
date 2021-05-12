%{
  //Declaration of varianbles, functions and methods used
  #include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define YYDEBUG 1 
	#define YYSTYPE char*
	int line = 1;
	int correctWords = 0;
	int incorrectWords = 0;
	int incorrectExprs = 0;
	int correctExprs = 0; //Counts correct statements
	extern char *yytext;
	int yylex();
	int yyerror(const char *s); //changed the function to accept char pointer to avoid warnings during compiling 
	int resetIncorrectExprs (int i);
	FILE *yyin;
	FILE *yyout;
	
%}

/* token definition */
%token ZERO 
%token INT 
%token VAR
%token PLUS 
%token MINUS 
%token MULT 
%token DIV 
%token EQUALS 
%token STARTSWITHZERO 
%token SIGNEDZERO
%token DEFRULE 
%token DEFFACTS 
%token TEST 
%token PRINTOUT 
%token READ 
%token BIND 
%token STATE 
%token LP 
%token RP 
%token ARROW

%left PLUS MINUS
%left DIV MULT

%start program

%%


//Declaration of the rules and syntax

program:
    program expr              { fprintf(yyout,"\nMathimatic Expression."); }
		|program deffacts         { fprintf(yyout,"\nDeffacts Definition."); correctExprs++; }
		|program defrule          { fprintf(yyout,"\nDefrule Definition."); correctExprs++; }
		|program test             { fprintf(yyout,"\nTest Function."); correctExprs++; }
		|program printout         { fprintf(yyout,"\nPrint Function."); correctExprs++; }
		|program read             { fprintf(yyout,"\nRead Function."); correctExprs++; }
		|program bind             { fprintf(yyout,"\nBind Function."); correctExprs++; }
		|program error	          { fprintf(yyout,"\nSyntax error");  incorrectExprs++;}
		|
		;

expr:
	INT	  { correctExprs++; }
	|VAR	{ correctExprs++; }
	|LP PLUS mathrecursion RP   { correctExprs++; }
	|LP MINUS mathrecursion RP  { correctExprs++; }
	|LP MULT mathrecursion RP   { correctExprs++; }
	|LP DIV mathrecursion RP    { correctExprs++; }
	|LP EQUALS mathrecursion RP { correctExprs++; }
	;

defrule: LP DEFRULE STATE defruleRecursion MINUS ARROW action RP{ correctExprs++; }
;

deffacts: LP DEFFACTS STATE fact RP { correctExprs++; }
;

test: LP TEST equal RP { correctExprs++; }
;

printout: LP PRINTOUT printoutRecursion RP { correctExprs++; }
;

read: LP READ VAR RP { correctExprs++; }
;

bind: LP BIND VAR expr RP { correctExprs++; }
;

/*Αναδρομική κλήση του equal*/
equal: LP EQUALS expr expr RP
	|equal LP EQUALS expr expr RP
	;

mathrecursion: expr
	|mathrecursion expr
	;

recursion: expr
	|recursion expr
	|STATE
	|recursion STATE
	;

fact: LP STATE recursion RP
	|fact LP STATE recursion RP
	;

defruleRecursion: LP STATE recursion RP
	|defruleRecursion LP STATE recursion RP
	|test
	|defruleRecursion test
	;

action: printout
	|action printout
	|test
	|action test
	|bind 
	|action bind
	|read
	|action read
	;

printoutRecursion: LP STATE recursion RP
	|printoutRecursion LP STATE recursion RP
	|LP expr recursion RP
	|printoutRecursion LP expr recursion RP
	|expr
	|printoutRecursion expr
	;
%%

//The function yyerror is responsible for finding the syntax errors. 
//If there is a syntax error this function prints an error message
int yyerror(char  const*s) {
  fprintf(yyout,"\nLine: %d FAILURE %s\n",line-1,s);
}

extern int yy_flex_debug; 

//main function
int main(int argc,char **argv){

	//flex debugging
	//yy_flex_debug = 1;
	//yydebug = 1;

	//checking for the files from which the compiler will read the input and write the output
	if(argc == 2){

		yyin=fopen(argv[1],"r");

	}else{
		yyin=stdin;
	}
	
	if(argc == 3){

		yyin=fopen(argv[1],"r");
		yyout=fopen(argv[2],"w");

	}

	int parse = yyparse();

	//checking if there were any syntax errors
	if (incorrectExprs == 0 && incorrectWords == 0 && parse == 0){
		
		printf("\nINPUT FILE: PARSING SUCCEEDED.\n");
		
	}else{

		printf("\nINPUT FILE: PARSING FAILED.\n");

	}

	//printing information about the correct words, exprations and inorrect words and expation if they excist
	printf("Number of correct words detected : %d\n",correctWords);
	printf("Number of correct expretions detected : %d\n",correctExprs);

	printf("Number of incorect words detected : %d\n",incorrectWords);
	incorrectExprs = resetIncorrectExprs(incorrectExprs); 
	printf("Number of incorect expretions detected : %d\n",incorrectExprs-1);
	
	fclose(yyin);
	fclose(yyout);
	
	return 0;
}

//If the parser recognizes a syntax error it counts the expresion which is wrong as one incorrect expration but it counts
//the previous line as well wrong. So to count correctly the wrong Expration we had to print the number of incorrect exprations 
//minus one. But with this method the count starts at -1 so to display everything correctly we have to reset the counter variable
//to zero. 
int resetIncorrectExprs (int i){
	if (i <= 0)
		return 1;
}