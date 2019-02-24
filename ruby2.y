%{
#include<stdio.h>
#include<stdlib.h>
#define YYDEBUG 1
void yyerror(char *s);
int yylex();
int linenum;
%}


%locations 

%union
{
    int intval;
    char *id,*str;
    float floatval;
    int boo;
    int arithop;
    int relop;
    int asop;
}

%start line

%token <intval> T_int
%token <floatval> T_flt
%token <id> T_id
%token <str> T_string
%token <arithop> T_ARITH_OP
%token <relop> T_REL_OP_SING
%token 	T_puts 		
		T_do		
		T_end		
		T_begin 	
		T_when 		
		T_case 		
		T_while 	
		T_else 		
		T_return

%token  T_asop
        T_exp
        T_comp
        T_gte
        T_lte
        T_ne
        T_ccomp
        T_scomp
        T_expas
        T_addas
        T_subas
        T_mulas
        T_divas
        T_modas
        T_and
        T_or
        T_not
        T_true
        T_false
        T_inrange
        T_exrange

%%

line    : expression {;}
        | line expression  {;}
        | statement {;}
        | line statement {;}
        ;

expression : term       
       	    |relationalExp
		    |booleanExp
		    |operatorExp
		    |assignmentExp
            ;

operatorExp		: expression T_ARITH_OP expression
                | expression T_exp expression
                ;

booleanExp      : expression T_and expression
                | expression T_or expression
                | T_not expression
                ;

assignmentExp   : T_id T_asop expression    
                | T_id T_addas expression 
                | T_id T_subas expression 
                | T_id T_mulas expression
                | T_id T_divas expression
                | T_id T_modas expression
                | T_id T_expas expression
                ;

relationalExp   : expression T_REL_OP_SING expression
                | expression relDbl expression
                ;

conditionalExp  : relationalExp
                | booleanExp
                ;

relDbl          : T_comp
                | T_gte
                | T_lte
                | T_ne
                | T_ccomp
                | T_scomp
                ;

statement   : T_return term
            | iterStat
            | selStat
            | assignmentExp
            ;

term    : T_int
        | T_flt                
        | T_id          
        | '(' expression ')'
        ;

// While statement

iterStat    : T_while conditionalExp T_do whileExp T_end
            | T_begin whileExp T_end T_while conditionalExp
            ;

whileExp    : statement whileExp2
            ;

whileExp2   : whileExp
            | iterStat
            | 
            ;

// Case statement

selStat     : T_case T_id whenStat T_end
            ;

whenStat    : T_when term whenExp whenOptional
            ; 

whenExp     : selStat
            | statement whenExpOpt
            ;

whenOptional : T_else whenExp
             | whenStat
             | 
             ;

whenExpOpt  : whenExp
            | 
            ;

// Values

Val         : Val ',' Val 
            | T_int 
            | T_flt
            | T_string
            | T_inrange
            | T_exrange
            | conditionalExp
%%

void yyerror(char *s) {

    fprintf(stderr, "Error in Line %d: %s\n", linenum, s);
}

struct table
{
    char key[20];
    char value[20];
};

int main()
{
    struct table symbol_table[100];

    extern FILE *yyin, *yyout; 
  
    /* yyin points to the file input.txt 
    and opens  it in read mode*/
    yyin = fopen("do_while_input.txt", "r"); 

    char c;
    for (c = getc(yyin); c != EOF; c = getc(yyin)) 
        if (c == '\n') // Increment count if this character is newline 
            linenum = linenum + 1;
  
    /* yyout points to the file output.txt 
    and opens it in write mode*/
    yyout = fopen("Output.txt", "w"); 
        /*DEBUG CODE*/
        /*#if YYDEBUG
        yydebug = 1;
    #endif*/
    yyparse();
}