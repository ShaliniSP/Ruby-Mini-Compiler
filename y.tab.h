/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_int = 258,
    T_flt = 259,
    T_id = 260,
    T_string = 261,
    T_puts = 262,
    T_do = 263,
    T_end = 264,
    T_begin = 265,
    T_when = 266,
    T_case = 267,
    T_while = 268,
    T_else = 269,
    T_return = 270,
    T_def = 271,
    T_class = 272,
    T_plus = 273,
    T_minus = 274,
    T_mul = 275,
    T_div = 276,
    T_mod = 277,
    T_openpar = 278,
    T_closepar = 279,
    T_opencurly = 280,
    T_closecurly = 281,
    T_openbox = 282,
    T_closebox = 283,
    T_asop = 284,
    T_exp = 285,
    T_comp = 286,
    T_gt = 287,
    T_lt = 288,
    T_gte = 289,
    T_lte = 290,
    T_ne = 291,
    T_ccomp = 292,
    T_expas = 293,
    T_addas = 294,
    T_subas = 295,
    T_mulas = 296,
    T_divas = 297,
    T_modas = 298,
    T_and = 299,
    T_or = 300,
    T_not = 301,
    T_comma = 302,
    T_true = 303,
    T_false = 304,
    T_inrange = 305,
    T_exrange = 306
  };
#endif
/* Tokens.  */
#define T_int 258
#define T_flt 259
#define T_id 260
#define T_string 261
#define T_puts 262
#define T_do 263
#define T_end 264
#define T_begin 265
#define T_when 266
#define T_case 267
#define T_while 268
#define T_else 269
#define T_return 270
#define T_def 271
#define T_class 272
#define T_plus 273
#define T_minus 274
#define T_mul 275
#define T_div 276
#define T_mod 277
#define T_openpar 278
#define T_closepar 279
#define T_opencurly 280
#define T_closecurly 281
#define T_openbox 282
#define T_closebox 283
#define T_asop 284
#define T_exp 285
#define T_comp 286
#define T_gt 287
#define T_lt 288
#define T_gte 289
#define T_lte 290
#define T_ne 291
#define T_ccomp 292
#define T_expas 293
#define T_addas 294
#define T_subas 295
#define T_mulas 296
#define T_divas 297
#define T_modas 298
#define T_and 299
#define T_or 300
#define T_not 301
#define T_comma 302
#define T_true 303
#define T_false 304
#define T_inrange 305
#define T_exrange 306

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 24 "ruby2.y" /* yacc.c:1909  */

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



#line 195 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
