%{
#include <stdio.h>
#include<string.h>
#include "y.tab.h"
int yylex();
void yyerror(char *s);
%}

RESERVED "BEGIN"|"do"|"next"|"then"|"END"|"nil"|"true"|"not"|"and"|"end"|"or"|"false"|"unless"|"begin"|"until"|"break"|"when"|"case"|"return"|"while"

ALPHABET 	[a-zA-Z]
VALID 		[_a-zA-Z]
DIGIT 		[0-9]
SPACES 		[ \t]


VAR 		{VALID}({VALID}|{DIGIT})*
	/*	not strong, string checking	*/
STRING 		\"(\\.|[^"\\])*\"


SIGN 		\+|\-
INT 		0|(({SIGN}?)([0-9]{DIGIT}*)){0,9}
FLOAT 		({SIGN}?{DIGIT}+(\.({DIGIT}+))(["e"]{INT})?)

BOOL 		"true"|"false"

	/* ranges are verified by the parser */
IN_RANGE	\({INT}\.\.{INT}\)	
EX_RANGE	\({INT}\.\.\.{INT}\)

ARITH_OP 	"\+"|"\-"|"\*"|"\/"|"%"
AR_EXP 		"**"

BOOL_OP 	"&&"|"||"|"and"|"or"|"not"

REL_OP_SING ">"|"<"
REL_OP_MUL 	">="|"<="|"=="|"!="|"<=>"|"==="|".eql?"|"equal?"


T_Or 		"||"|"or" 
T_And 		"&&"|"and"
T_Xor 		"^"
T_Not 		"not"


S_AS_OP 		"="
C_ARITH_AS_OP 	{ARITH_OP}?\=
C_BOOL_AS_OP 	{BOOL_OP}?\=
P_AS_OP 		({VAR}\,)*{VAR}=

	/*
	if we use parallel assignment then, 
	number of tokens on the rhs should be 
	at least equal to that in lhs,  
	parenthesis are handled in a different way (complex)
	*/

%%
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
	/*operators*/
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
"!" | "not"		{return T_not;}
","				{char x[1] = ",";return atoi(x);}
"true"			{yylval.boo = 1; return T_true;}
"false"			{yylval.boo = 0; return T_false;}

{SPACES}		{}	
{ARITH_OP} 		{yylval.arithop = atoi(yytext);return T_ARITH_OP;}
{REL_OP_SING}	{yylval.relop = atoi(yytext);return T_REL_OP_SING;}
{VAR}			{yylval.id = yytext;return T_id;}
{INT}			{yylval.intval = atoi(yytext);return T_int;}
{FLOAT}			{yylval.floatval = atof(yytext);return T_flt;}
{STRING}		{yylval.str = strdup(yytext);return T_string;}
{IN_RANGE}		{return T_inrange;}	
{EX_RANGE}		{return T_exrange;}

. 				{printf("error\n");}


%%

	/*int main(){
	yylex();
}*/


int yywrap(void){
	return 1;
}

