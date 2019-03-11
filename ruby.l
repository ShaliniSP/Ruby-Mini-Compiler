%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int yylex();
int ind = 1;		// start indexing from 1
int cmp_fl;
int comments = 0;
extern int check_symtable(char *text);
extern void putvar_symtable(int ind, char *scope, int line_no, char *tok_val);
%}

%option yylineno


RESERVED 	"BEGIN"|"do"|"next"|"then"|"END"|"nil"|"true"|"not"|"and"|"end"|"or"|"false"|"unless"|"begin"|"until"|"break"|"when"|"case"|"return"|"while"|"def"|"class"

VALID 		[_a-zA-Z]
DIGIT 		[0-9]
SPACES 		[ \t]


VAR 			{VALID}({VALID}|{DIGIT})*
GLOBALVAR 		\${VALID}({VALID}|{DIGIT})*
INSTANCEVAR 	\@{VALID}({VALID}|{DIGIT})*
CLASSVAR		\@\@{VALID}({VALID}|{DIGIT})*

	/*	not strong, string checking	*/
STRING 		\"(\\.|[^"\\])*\"


SIGN 		\+|\-
INT 		0|(({SIGN}?)([0-9]{DIGIT}*)){0,9}
FLOAT 		({SIGN}?{DIGIT}+(\.({DIGIT}+))(["e"]{INT})?)

BOOL 		"true"|"false"
	/*ARRAY 		'[' {INT} ']'*/

	/* ranges are verified by the parser */
IN_RANGE	\({INT}\.\.{INT}\)	
EX_RANGE	\({INT}\.\.\.{INT}\)

ARITH_OP 	"\+"|"\-"|"\*"|"\/"|"%"
AR_EXP 		"**"

BOOL_OP 	"&&"|"||"|"and"|"or"|"not"

REL_OP_SING ">"|"<"
REL_OP_MUL 	">="|"<="|"=="|"!="|"<=>"|"==="|".eql?"|"equal?"


OR 			"||"|"or" 
AND 		"&&"|"and"
XOR 		"^"
NOT 		"not"


S_AS_OP 		"="
C_ARITH_AS_OP 	{ARITH_OP}?\=
C_BOOL_AS_OP 	{BOOL_OP}?\=
P_AS_OP 		({VAR}\,)*{VAR}=

%%

\n 			{}
	/*comments*/
"\=begin"(.*\n)*"\=end" 		{comments++;}
"\#"([a-z]|[A-Z]|[0-9]|" ")*	{comments++;}
	/*keywords*/

"puts" 		{return T_puts;}
"do" 		{return T_do;}
"end" 		{return T_end;}
"begin" 	{return T_begin;}
"when" 		{return T_when;}
"case" 		{return T_case;}
"while" 	{return T_while;}
"else"		{return T_else;}
"return"	{return T_return;}
"def"		{return T_def;}
"class"		{return T_class;}
	/*operators*/
	/*{ARRAY}			{printf("Array: %s", yytext); yylval.array = strdup(yytext); return T_array;}*/

"("				{return T_openpar;}
")"				{return T_closepar;}
"{"				{return T_opencurly;}
"}"				{return T_closecurly;}
"["				{return T_openbox;}
"]"				{return T_closebox;}
"="				{return T_asop;}
"**"			{return T_exp;}
"=="			{return T_comp;}
">="			{return T_gte;}
"<="			{return T_lte;}
"!="			{return T_ne;}
"<=>"			{return T_ccomp;}
"==="			{return T_scomp;}
"**="			{return T_expas;}
"+="			{return T_addas;}
"-="			{return T_subas;}
"*="			{return T_mulas;}
"/="			{return T_divas;}
"%="			{return T_modas;}
"&&" | "and"	{return T_and;}
"||" | "or"		{return T_or;}
"!"  | "not"		{return T_not;}
","				{char x[1] = ",";return T_comma;}
"true"			{yylval.boo = 1; return T_true;}
"false"			{yylval.boo = 0; return T_false;}

{SPACES}		{}	
{ARITH_OP} 		{yylval.arithop = atoi(yytext);printf("arith_op: %d\n",yylval.arithop);return T_ARITH_OP;}
{REL_OP_SING}	{yylval.relop = atoi(yytext);return T_REL_OP_SING;}

{VAR}			{	cmp_fl = check_symtable(yytext);
					if(cmp_fl<0)
					{
						putvar_symtable(ind,"local",yylineno,yytext);
						ind++;
						yylval.id = strdup(yytext);
						return T_id;
					}
					else
					{
						printf("%s Already in Symbol Table\n",yytext);
						yylval.tab_arr[cmp_fl].occurences++;
						return T_id;
					}
				}

{GLOBALVAR}		{	cmp_fl = check_symtable(yytext);
					if(cmp_fl<0)
					{
						putvar_symtable(ind,"global",yylineno,yytext);
						ind++;
						yylval.id = strdup(yytext);
						return T_id;
					}
					else
					{
						printf("%s Already in Symbol Table\n",yytext);
						yylval.tab_arr[cmp_fl].occurences++;
						return T_id;
					}
				}

{CLASSVAR} 		{	cmp_fl = check_symtable(yytext);
					if(cmp_fl<0)
					{
						putvar_symtable(ind,"class",yylineno,yytext);
						ind++;
						yylval.id = strdup(yytext);
						return T_id;
					}
					else
					{
						printf("%s Already in Symbol Table\n",yytext);
						yylval.tab_arr[cmp_fl].occurences++;
						return T_id;
					}
				}

{INSTANCEVAR}	{	cmp_fl = check_symtable(yytext);
					if(cmp_fl<0)
					{
						putvar_symtable(ind,"instance",yylineno,yytext);
						ind++;
						yylval.id = strdup(yytext);
						return T_id;
					}
					else
					{
						printf("%s Already in Symbol Table\n",yytext);
						yylval.tab_arr[cmp_fl].occurences++;
						return T_id;
					}
				}


{INT}			{yylval.intval = atoi(yytext);return T_int;}
{FLOAT}			{yylval.floatval = atof(yytext);return T_flt;}
{STRING}		{yylval.str = strdup(yytext);return T_string;}
{IN_RANGE}		{return T_inrange;}	
{EX_RANGE}		{return T_exrange;}

. 				{printf("error\n");}


%%


int yywrap(void){
	return 1;
}



