%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYDEBUG 0

void yyerror(char *s);
int yylex();
int yylineno;
/* Symbol Table functions */
void print_symtable();
extern int check_symtable(char *text);
extern void putvar_symtable(int ind, char *scope, int line_no, char *tok_val);
/* AST functions */
/*struct node *init_tree();
struct node *make_node(char *tk_value, struct node *left_value, struct node *right_value);
void print_node(struct node *root); */

%}

%locations 

%union
{
    char *id;
    char* array;
    int intval;
    char *str;
    float floatval;
    char* boolval;
    int arithop;
    int relop;
    int asop;

    struct table{
        char *tok_name;
        char *tok_val;
        char *scope;
        int line_no;
        int uni_val_flag;
        union value
        {
            int int_val;
            float float_val;
            char* bool_val;
            char* str;
            char* array;
        }val;
        int occurences;
    }table;

    struct table tab_arr[20];

    /*struct node{
        char *token_value;
        struct node *left;
        struct node *right;
    }node;*/


}

%start line

%token <intval> T_int
%token <floatval> T_flt
%token <id> T_id
%token <str> T_string
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

%token  T_plus
        T_minus
        T_mul
        T_div
        T_mod
        T_openpar
        T_closepar
        T_opencurly
        T_closecurly
        T_openbox
        T_closebox
        T_asop
        T_exp
        T_comp
        T_gt
        T_lt
        T_gte
        T_lte
        T_ne
        T_ccomp
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

%left T_minus T_plus
%left T_mul T_div T_mod

%left T_lt T_gt
%left T_lte T_gte T_comp T_ccomp T_ne

%left T_not
%left T_and
%left T_or
/*%left OP_GREATER_THAN_REL
%left REL*/

%type <table> operatorExp 
%type <array> arrayExp
%type <table> relationalExp
//%type <table> booleanExp
%type <table> conditionalExp
//%type <intval> term1a
//%type <floatval> term1b
%type <table> term1
%type <table> term2
%type <table> term



%%

line    : expression 
        | line expression
        | statement 
        | line statement 
        | error '\n'
        ;

expression  : conditionalExp
            ;

operatorExp		: operatorExp T_mul operatorExp {
                                                    if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                    {
                                                        $$.uni_val_flag = 0;
                                                        $$.val.int_val = $1.val.int_val * $3.val.int_val;
                                                    }
                                                    else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                    {
                                                        $$.uni_val_flag = 1;
                                                        $$.val.float_val = $1.val.int_val * $3.val.float_val;
                                                    }
                                                    else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                    {
                                                        $$.uni_val_flag = 1;
                                                        $$.val.float_val = $1.val.float_val * $3.val.int_val;
                                                    }
                                                    else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                    {
                                                        $$.uni_val_flag = 1;
                                                        $$.val.float_val = $1.val.float_val * $3.val.float_val;
                                                    }            
                                                }  
                | operatorExp T_div operatorExp {
                                                if($3.uni_val_flag == 0 && $3.val.int_val == 0 || $3.uni_val_flag == 1 && $3.val.float_val == 0.0)
                                                {
													yyerror("Divide by Zero");
                                                }
											    else if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                {
                                                    $$.uni_val_flag = 1;
                                                    $$.val.float_val = (float) $1.val.int_val / (float) $3.val.int_val;
                                                }
                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                {
                                                    $$.uni_val_flag = 1;
                                                    $$.val.float_val = $1.val.int_val / $3.val.float_val;
                                                }
                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                {
                                                    $$.uni_val_flag = 1;
                                                    $$.val.float_val = $1.val.float_val / $3.val.int_val;
                                                }
                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                {
                                                    $$.uni_val_flag = 1;
                                                    $$.val.float_val = $1.val.float_val / $3.val.float_val;
                                                }  
											}
                | operatorExp T_plus operatorExp {  /*$$ = make_node("+",$1,$3);*/
                                                        if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                        {
                                                            $$.uni_val_flag = 0;
                                                            $$.val.int_val = $1.val.int_val + $3.val.int_val;
                                                        }
                                                        else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $3.val.float_val + $1.val.int_val ;
                                                        }
                                                        else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $1.val.float_val + $3.val.int_val;
                                                        }
                                                        else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $1.val.float_val + $3.val.float_val;
                                                        } 
                                                    /*printf("$$ = %d %d %d",$$,$1,$3);*/
                                                    }
                | operatorExp T_minus operatorExp   {
                                                        if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                        {
                                                            $$.uni_val_flag = 0;
                                                            $$.val.int_val = $1.val.int_val - $3.val.int_val;
                                                        }
                                                        else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $1.val.int_val - $3.val.float_val;
                                                        }
                                                        else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $1.val.float_val - $3.val.int_val;
                                                        }
                                                        else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $1.val.float_val - $3.val.float_val;
                                                        } 
                                                    }
                | operatorExp T_mod operatorExp     {
                                                        $$.uni_val_flag = 0; 
                                                        $$.val.int_val = $1.val.int_val % $3.val.int_val;
                                                    }
                | operatorExp T_ccomp operatorExp   {
                                                        $$.uni_val_flag = 0;
                                                        if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                            $$.val.int_val = $1.val.int_val < $3.val.int_val ? -1 : $1.val.int_val > $3.val.int_val ? 1 : 0;
                                                        else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                            $$.val.int_val = $1.val.int_val < $3.val.float_val ? -1 : $1.val.int_val > $3.val.float_val ? 1 : 0;
                                                        else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                            $$.val.int_val = $1.val.float_val < $3.val.int_val ? -1 : $1.val.float_val > $3.val.int_val ? 1 : 0;
                                                        else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                            $$.val.int_val = $1.val.float_val < $3.val.float_val ? -1 : $1.val.float_val > $3.val.float_val ? 1 : 0;
                                                    }    
                | term       
                ;

relationalExp   : relationalExp T_lt relationalExp          {
                                                                $$.uni_val_flag = 3;
                                                                if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.int_val < $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.int_val < $3.val.float_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.float_val < $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.float_val < $3.val.float_val ? "true":"false";
                                                            }
                | relationalExp T_gt relationalExp          {
                                                                $$.uni_val_flag = 3;
                                                                if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.int_val > $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.int_val > $3.val.float_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.float_val > $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.float_val > $3.val.float_val ? "true":"false";
                                                            }
                | relationalExp T_lte relationalExp         {
                                                                $$.uni_val_flag = 3;
                                                                if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.int_val <= $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.int_val <= $3.val.float_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.float_val <= $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.float_val <= $3.val.float_val ? "true":"false";
                                                            }
                | relationalExp T_gte relationalExp         {
                                                                $$.uni_val_flag = 3;
                                                                if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.int_val >= $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.int_val >= $3.val.float_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.float_val >= $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.float_val >= $3.val.float_val ? "true":"false";
                                                            }
                | relationalExp T_comp relationalExp        {
                                                                $$.uni_val_flag = 3;
                                                                if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.int_val == $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.int_val == $3.val.float_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.float_val == $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.float_val == $3.val.float_val ? "true":"false";
                                                            }
                | relationalExp T_ne relationalExp          {
                                                                $$.uni_val_flag = 3;
                                                                if($1.uni_val_flag == 0 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.int_val != $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 0 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.int_val != $3.val.float_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 0)
                                                                    $$.val.bool_val = $1.val.float_val != $3.val.int_val ? "true":"false";
                                                                else if($1.uni_val_flag == 1 && $3.uni_val_flag == 1)
                                                                    $$.val.bool_val = $1.val.float_val != $3.val.float_val ? "true":"false";
                                                            }
                | operatorExp                               {
                                                                if($1.uni_val_flag == 0)
                                                                {
                                                                    $$.uni_val_flag = 0;
                                                                    $$.val.int_val = $1.val.int_val;
                                                                }
                                                                else if($1.uni_val_flag == 1)
                                                                {
                                                                    $$.uni_val_flag = 1;
                                                                    $$.val.float_val = $1.val.float_val;
                                                                }
                                                            }                                          
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

assignmentExp   : T_id T_asop conditionalExp    {
                                                    int i = check_symtable($1);
                                                    yylval.tab_arr[i].uni_val_flag = $3.uni_val_flag;
                                                    switch($3.uni_val_flag)
                                                    {
                                                        case 0:
                                                            yylval.tab_arr[i].val.int_val = $3.val.int_val;
                                                            yylval.tab_arr[i].tok_name = "int";
                                                            break;
                                                        case 1:
                                                            yylval.tab_arr[i].val.float_val = $3.val.float_val;
                                                            yylval.tab_arr[i].tok_name = "float";
                                                            break;
                                                        case 3:
                                                            yylval.tab_arr[i].val.bool_val = (char*)malloc((strlen($3.val.bool_val)+1) * sizeof(char));
                                                            strcpy(yylval.tab_arr[i].val.bool_val, $3.val.bool_val);
                                                            yylval.tab_arr[i].tok_name = "bool";

                                                    }
                                            } 

            | T_id T_asop arrayExp           {
                                                int i = check_symtable($1);
                                                yylval.tab_arr[i].uni_val_flag = 4;
                                                yylval.tab_arr[i].val.array = "0005x44";
                                                yylval.tab_arr[i].tok_name = "array";

                                            }
            | T_id T_asop T_string          {
                                                int i = check_symtable($1);
                                                yylval.tab_arr[i].uni_val_flag = 2;
                                                yylval.tab_arr[i].val.str = $3;
                                                yylval.tab_arr[i].tok_name = "string";
                                            }
            /*| T_id T_asop operatorExp       {
                                                int i = check_symtable($1);
                                                if($3.uni_val_flag == 0)
                                                {
                                                    yylval.tab_arr[i].uni_val_flag = 0;
                                                    yylval.tab_arr[i].val.int_val = $3.val.int_val;
                                                    yylval.tab_arr[i].tok_name = "int"; 
                                                }
                                                else if($3.uni_val_flag==1)
                                                {
                                                    yylval.tab_arr[i].uni_val_flag = 1;
                                                    yylval.tab_arr[i].val.float_val = $3.val.float_val;
                                                    yylval.tab_arr[i].tok_name = "float";
                                                }
                                            }*/
            | T_id T_addas term             {
                                                int i = check_symtable($1);
                                                if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 0;
                                                            yylval.tab_arr[i].val.int_val = yylval.tab_arr[i].val.int_val + $3.val.int_val;
                                                        }
                                                        else if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 1;
                                                            yylval.tab_arr[i].val.float_val = $3.val.float_val + yylval.tab_arr[i].val.int_val ;
                                                        }
                                                        else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 1;
                                                            yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val + $3.val.int_val;
                                                        }
                                                        else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 1;
                                                            yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val + $3.val.float_val;
                                                        }
                                            }
            | T_id T_subas term            {
                                                int i = check_symtable($1);
                                                if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 0;
                                                            yylval.tab_arr[i].val.int_val = yylval.tab_arr[i].val.int_val - $3.val.int_val;
                                                        }
                                                        else if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 1;
                                                            yylval.tab_arr[i].val.float_val = $3.val.float_val - yylval.tab_arr[i].val.int_val ;
                                                        }
                                                        else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 1;
                                                            yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val - $3.val.int_val;
                                                        }
                                                        else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                        {
                                                            yylval.tab_arr[i].uni_val_flag = 1;
                                                            yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val - $3.val.float_val;
                                                        }
                                            }
            | T_id T_mulas term            {
                                                int i = check_symtable($1);
                                                if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                    {
                                                        yylval.tab_arr[i].uni_val_flag = 0;
                                                        yylval.tab_arr[i].val.int_val = yylval.tab_arr[i].val.int_val * $3.val.int_val;
                                                    }
                                                    else if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                    {
                                                        yylval.tab_arr[i].uni_val_flag = 1;
                                                        yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.int_val * $3.val.float_val;
                                                    }
                                                    else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                    {
                                                        yylval.tab_arr[i].uni_val_flag = 1;
                                                        yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val * $3.val.int_val;
                                                    }
                                                    else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                    {
                                                        yylval.tab_arr[i].uni_val_flag = 1;
                                                        yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val * $3.val.float_val;
                                                    }
                                            }
            | T_id T_divas term            {
                                                int i = check_symtable($1);
                                                if($3.uni_val_flag == 0 && $3.val.int_val == 0 || $3.uni_val_flag == 1 && $3.val.float_val == 0.0)
                                                {
													yyerror("Divide by Zero");
                                                }
											    else if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 0)   
                                                {
                                                    yylval.tab_arr[i].uni_val_flag = 1;
                                                    yylval.tab_arr[i].val.float_val = (float) yylval.tab_arr[i].val.int_val / (float) $3.val.int_val;
                                                }
                                                else if(yylval.tab_arr[i].uni_val_flag == 0 && $3.uni_val_flag == 1)   
                                                {
                                                    yylval.tab_arr[i].uni_val_flag = 1;
                                                    yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.int_val / $3.val.float_val;
                                                }
                                                else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 0)   
                                                {
                                                    yylval.tab_arr[i].uni_val_flag = 1;
                                                    yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val / $3.val.int_val;
                                                }
                                                else if(yylval.tab_arr[i].uni_val_flag == 1 && $3.uni_val_flag == 1)   
                                                {
                                                    yylval.tab_arr[i].uni_val_flag = 1;
                                                    yylval.tab_arr[i].val.float_val = yylval.tab_arr[i].val.float_val / $3.val.float_val;
                                                }
                                            }
            ;


conditionalExp  : relationalExp                 {
                                                    switch($1.uni_val_flag)
                                                    {
                                                        case 0:
                                                            $$.uni_val_flag = 0;
                                                            $$.val.int_val = $1.val.int_val;
                                                            break;
                                                        case 1:
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $1.val.float_val;
                                                            break;
                                                        case 3:
                                                            $$.uni_val_flag = 3;
                                                            $$.val.bool_val = $1.val.bool_val;
                                                            break; 
                                                    }
                                                }
                | conditionalExp T_and conditionalExp   {
                                                            $$.uni_val_flag = 3;
                                                            int a = strcmp($1.val.bool_val, "true") ? 0 : 1;
                                                            int b = strcmp($3.val.bool_val, "true") ? 0 : 1;
                                                            $$.val.bool_val = a && b ? "true" : "false";
                                                        }
                | conditionalExp T_or conditionalExp    {
                                                            $$.uni_val_flag = 3;
                                                            int a = strcmp($1.val.bool_val, "true") ? 0 : 1;
                                                            int b = strcmp($3.val.bool_val, "true") ? 0 : 1;
                                                            $$.val.bool_val = a || b ? "true" : "false";
                                                        }
                | T_not conditionalExp                  {
                                                            $$.uni_val_flag = 3;
                                                            int a = strcmp($2.val.bool_val, "true") ? 0 : 1;
                                                            $$.val.bool_val = !a ? "true" : "false";
                                                        }
                ;

statement   : T_return term
            | iterStat
            | selStat
            | assignmentExp
            | functionStat
            | classStat
            ;

term        : term1 | term2 ;
term1       : T_int                                 {
                                                         $$.uni_val_flag = 0;
                                                         $$.val.int_val = $1;
                                                                   
                                                        /*$$ = make_node($1,NULL,NULL);*/
                                                    }            
            | T_openpar operatorExp T_closepar      {
                                                        if($2.uni_val_flag == 0)
                                                        {
                                                            $$.uni_val_flag = 0;
                                                            $$.val.int_val = $2.val.int_val;
                                                        }
                                                        else if($2.uni_val_flag == 1)
                                                        {
                                                            $$.uni_val_flag = 1;
                                                            $$.val.float_val = $2.val.float_val;
                                                        }
                                                    }
            | T_flt                                 {
                                                         $$.uni_val_flag = 1;
                                                         $$.val.float_val = $1;
                                                                   
                                                        /*$$ = make_node($1,NULL,NULL);*/
                                                    }            
            ;                                 
            
term2       : T_id          {
                                int i = check_symtable($1);
                                if(yylval.tab_arr[i].uni_val_flag == 0)
                                {
                                    $$.uni_val_flag = 0;
                                    $$.val.int_val = yylval.tab_arr[i].val.int_val;    //FIX THIS
                                }
                                else if(yylval.tab_arr[i].uni_val_flag == 1)
                                {
                                    $$.uni_val_flag = 1;
                                    $$.val.float_val = yylval.tab_arr[i].val.float_val;
                                }
                             //printf("iterm = %d\n",i);
                            }
        

// While statement

iterStat    : T_while conditionalExp T_do whileExp T_end    {printf("WHILE");}
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


%%

void yyerror(char *s) {

    fprintf(stderr, "Error in Line %d: %s\n", yylineno, s);
}

void print_symtable(){
    int i=1;
    printf("\nSYMBOL TABLE\n\n");
    printf("Type\t\tName\t\tScope\t\tLineNo\t\tOccurences\t\tValue\n");
    while(yylval.tab_arr[i].tok_name!=NULL)
    {
        printf("%s\t\t%s\t\t%s\t\t%d\t\t%d\t\t\t",yylval.tab_arr[i].tok_name,yylval.tab_arr[i].tok_val,yylval.tab_arr[i].scope,yylval.tab_arr[i].line_no,yylval.tab_arr[i].occurences);
        switch(yylval.tab_arr[i].uni_val_flag)
        {
            case 0: 
                printf("%d\n", yylval.tab_arr[i].val.int_val);
                break;
            case 1: 
                printf("%f\n", yylval.tab_arr[i].val.float_val);
                break;
            case 2: 
                printf("%s\n", yylval.tab_arr[i].val.str);
                break;  
            case 3: 
                printf("%s\n", yylval.tab_arr[i].val.bool_val);
                break;
            case 4: 
                printf("%s\n", yylval.tab_arr[i].val.array);
                break;

        }
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
            return i;
        i++; 
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

/*struct node *init_tree()
{
    struct node *root = malloc(sizeof(struct node));
    root->token_value = NULL;
    root->left = NULL;
    root->right = NULL;
    return root;    

}

struct node *make_node(char *tk_value, struct node *left_value, struct node *right_value)
{
    struct node *node = malloc(sizeof(struct node));
    node->token_value = tk_value;
    node->left = left_value;
    node->right = right_value;
    return node;
}

void print_node(struct node *root)
{
    if(root == NULL)
      return;
    print_node(root->left);                 // inorder traversal
    printf("%s\n",root->token_value);
    print_node(root->right);
}*/

int main()
{
    extern FILE *yyin, *yyout; 
  
    /* yyin points to the file input.txt 
    and opens  it in read mode*/
    yyin = fopen("test.txt", "r"); 

    /* yyout points to the file output.txt 
    and opens it in write mode*/
    yyout = fopen("Output.txt", "w"); 
        /*DEBUG CODE*/
         #if YYDEBUG
             yydebug = 1;
         #endif
    yyparse();
    
    print_symtable();
}