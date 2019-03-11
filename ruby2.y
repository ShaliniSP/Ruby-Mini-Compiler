%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYDEBUG 1
void yyerror(char *s);
int yylex();
int yylineno;
void print_symtable();
extern int check_symtable(char *text);
extern void putvar_symtable(int ind, char *scope, int line_no, char *tok_val);
%}

%locations 

%union
{
    char *id;
    char* array;
    int intval;
    char *str;
    float floatval;
    int boo;
    int arithop;
    int relop;
    int asop;
    struct table{
        char *tok_name;
        char *tok_val;
        char *scope;
        int line_no;
        int int_val;
        float float_val;
        int bool_val;
        char* str;
        char* array;
        int occurences;
    }table;

    struct table tab_arr[20];
}

%start line

%token <intval> T_int
%token <floatval> T_flt
%token <id> T_id
%token <str> T_string
%token <arithop> T_ARITH_OP
%token <relop> T_REL_OP_SING
//%token <array> T_array

%token 	T_puts 		
		T_do		
		T_end		
		T_begin 	
		T_when 		
		T_case 		
		T_while 	
		T_else 		
		T_return
        T_def
        T_class

%token  
        T_openpar
        T_closepar
        T_opencurly
        T_closecurly
        T_openbox
        T_closebox
        T_asop
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
        T_comma
        T_true
        T_false
        T_inrange
        T_exrange

%left '-' '+'
%left '*' '/'

%type <intval> operatorExp 
%type <array> arrayExp
%type <intval> term1
%type <id> term2



%%

line    : expression 
        | line expression
        | statement 
        | line statement 
        | error '\n'
        ;

expression : booleanExp
		    |operatorExp    
            ;

operatorExp		: operatorExp'*'operatorExp {$$=$1*$3;}  
                | operatorExp'/'operatorExp {
                                                if($3==0)
                                                {
													yyerror("Divide by Zero");
                                                }
											    else
													$$=$1/$3;
											}
                | operatorExp'+'operatorExp {$$=$1+$3;}
                | operatorExp'-'operatorExp {$$=$1-$3;}
                //| operatorExp'%'operatorExp {$$=$1%$3;}
                | term                          
                ;

relationalExp   : term T_REL_OP_SING term
                | term relDbl term
                ;

booleanExp      : relationalExp boolExp2 
                | T_not relationalExp 
                ;

boolExp2        : T_and relationalExp
                | T_or relationalExp
                ;

arrayExp        : T_openbox numList T_closebox

numList         : intList
                | fltList
                ;

intList         : T_int T_comma intList
                | T_int     
                ;

fltList         : T_flt T_comma fltList
                | T_flt
                ;

assignmentExp   : T_id T_asop operatorExp       {int i = check_symtable($1);
                                                yylval.tab_arr[i].int_val = $3;
                                                yylval.tab_arr[i].tok_name = "int";
                                                }
                | T_id T_asop arrayExp           {int i = check_symtable($1);
                                                yylval.tab_arr[i].array = "0005x44";
                                                yylval.tab_arr[i].tok_name = "array";

                                                }
                | T_id T_asop T_string          {int i = check_symtable($1);
                                                yylval.tab_arr[i].str = $3;
                                                yylval.tab_arr[i].tok_name = "string";
                                                }
                | T_id T_addas expression 
                | T_id T_subas expression 
                | T_id T_mulas expression
                | T_id T_divas expression
                | T_id T_modas expression
                | T_id T_expas expression
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
            | functionStat
            | classStat
            ;

term        : term1 | term2 ;
term1       : T_int         
            | T_flt                
            | T_openpar operatorExp T_closepar   {$$ = $2;}
            ;
term2       : T_id          {int i = check_symtable($1);
                             $$ = yylval.tab_arr[i].int_val;
                            }
        

// While statement

iterStat    : T_while conditionalExp T_do whileExp T_end
            | T_begin whileExp T_end T_while conditionalExp
            ;

whileExp    : statement whileExp
            |
            ;


// Case statement

selStat     : T_case T_id whenStat T_end
            ;

whenStat    : T_when term whenExp whenOptional
            ; 

whenExp     : statement whenExpOpt  
            ;

whenOptional : T_else whenExp
             | whenStat
             | 
             ;

whenExpOpt  : whenExp
            | 
            ;

// Function

functionStat    : T_def T_id T_openpar T_id T_closepar funcExp T_end
                ;

funcExp         : statement funcExp2
                ;

funcExp2        : funcExp
                |
                ;

// Class

classStat   : T_class T_id classExp T_end
            ;

classExp    : statement classExp2
            ;

classExp2   : classExp
            |
            ;



// Values

// Val         : Val ',' Val 
//             | T_int 
//             | T_flt
//             | T_string
//             | T_inrange
//             | T_exrange
//             | conditionalExp
%%

void yyerror(char *s) {

    fprintf(stderr, "Error in Line %d: %s\n", yylineno, s);
}

void print_symtable(){
    int i=1;
    printf("\nSYMBOL TABLE\n\n");
    printf("Type\t\tName\t\tScope\t\tLineNo\t\tIntVal\t\tFloatVal\t\tBoolVal\t\tString\t\tArrPoint\tOccurences\n");
    while(yylval.tab_arr[i].tok_name!=NULL)
    {
        printf("%s\t\t%s\t\t%s\t\t%d\t\t%d\t\t%f\t\t%d\t\t%s\t\t%s\t\t%d\n",yylval.tab_arr[i].tok_name,yylval.tab_arr[i].tok_val,yylval.tab_arr[i].scope,yylval.tab_arr[i].line_no,yylval.tab_arr[i].int_val,yylval.tab_arr[i].float_val,yylval.tab_arr[i].bool_val, yylval.tab_arr[i].str, yylval.tab_arr[i].array, yylval.tab_arr[i].occurences);
        i++;
    }
}


int check_symtable(char *text)
{
    int i=1;
	//printf("%s",yylval.tab_arr[1].tok_name);
    while(yylval.tab_arr[i].tok_name!=NULL)
    {
		//printf("text:%s  arr:%s\n",text,yylval.tab_arr[i].tok_val);
        if(strcmp(text,yylval.tab_arr[i].tok_val)==0)
        {
            return i;
        } 
        else{
            i++;
        }  
    }
    return -1;
}

void putvar_symtable(int ind, char *scope, int line_no, char *tok_val)
{
    yylval.tab_arr[ind].tok_name="id";
	yylval.tab_arr[ind].scope=scope;
	yylval.tab_arr[ind].line_no=line_no;
	yylval.tab_arr[ind].tok_val = (char*)malloc(sizeof(char)*32);
    yylval.tab_arr[ind].occurences = 1;
	if(strlen(tok_val)>31)
	{
		printf("Identifier too long\n");
		strncpy(yylval.tab_arr[ind].tok_val,tok_val,31);
	}
	else
	{
		strcpy(yylval.tab_arr[ind].tok_val,tok_val);
	}
    printf("Added %s to ST\n",tok_val);
}

int main()
{
    extern FILE *yyin, *yyout; 
  
    /* yyin points to the file input.txt 
    and opens  it in read mode*/
    yyin = fopen("while_input.txt", "r"); 

    /* yyout points to the file output.txt 
    and opens it in write mode*/
    yyout = fopen("Output.txt", "w"); 
        /*DEBUG CODE*/
        //  #if YYDEBUG
        //      yydebug = 1;
        //  #endif
    yyparse();
    
    print_symtable();
}